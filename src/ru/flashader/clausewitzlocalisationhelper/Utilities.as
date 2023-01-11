package ru.flashader.clausewitzlocalisationhelper {
	import ru.flashader.clausewitzlocalisationhelper.data.LineContent;
	import ru.flashader.clausewitzlocalisationhelper.data.TranslationFileContent;
	import ru.flashader.clausewitzlocalisationhelper.data.errors.ForbiddenCharacterError;
	import ru.flashader.clausewitzlocalisationhelper.data.errors.ValueCorruptedError;
	import ru.flashader.clausewitzlocalisationhelper.data.errors.VersionError;

	/**
	* @author Ilja 'flashader' Mickodin
	*/
	
	public class Utilities {
		private static const FLASHADER_TEMPORARY_TEMPLATE:String = "###OLOLO_FLASHADER_TEMPORARY_TEMPLATE_OLOLO###";
		
		private static const COLON_CHAR:String = ":";
		
		private static const SharpCharsIndex:Vector.<int> = new Vector.<int>();
		private static const SHARP_CHAR:String = "#";
		
		private static const QuoteCharsIndex:Vector.<int> = new Vector.<int>();
		private static const QUOTE_CHAR:String = '"';
		
		private static const EscapeCharsIndex:Vector.<int> = new Vector.<int>();
		private static const ESCAPE_CHAR:String = '\\';
		
		private static const ParagraphCharsIndex:Vector.<int> = new Vector.<int>();
		private static const PARAGRAPH_CHAR:String = "§";
		
		private static const BucksCharsIndex:Vector.<int> = new Vector.<int>();
		private static const BUCKS_CHAR:String = "$";
		
		private static const OpenBracketCharsIndex:Vector.<int> = new Vector.<int>();
		private static const OPEN_BRACKET_CHAR:String = "[";
		
		private static const CloseBracketCharsIndex:Vector.<int> = new Vector.<int>();
		private static const CLOSE_BRACKET_CHAR:String = "]";
		
		private static const CORRECT_NAME_REG:RegExp = new RegExp("[^a-zA-Z0-9_.-]");
		private static const CORRECT_VERSION_REG:RegExp = new RegExp("[^0-9]"); //Ever dots not allowed
		
		public static function DoManualParsing(fileContent:String, fullPath:String):TranslationFileContent {
			var escapedContent:String = fileContent.replace("\\n", FLASHADER_TEMPORARY_TEMPLATE);
			var lines:Array = escapedContent.split("\r\n");
			if (lines.length <= 1) {
				lines = escapedContent.split("\n");
				trace("Single linebreak");
			}
			var toReturn:TranslationFileContent = new TranslationFileContent({});
			for each (var line:String in lines) {
				line = line
				var lineContent:LineContent = ParseSingleLine(
					line.replace(
						FLASHADER_TEMPORARY_TEMPLATE,
						"\\n"
					).replace (
						'\\"',
						'"'
					)
				);
				if (
					(
						toReturn.LanguagePostfix == null ||
						toReturn.LanguagePostfix.length == 0
					) &&
					lineContent.Errors.length == 1 &&
					lineContent.Errors[0] is ValueCorruptedError
				) {
					toReturn.LanguagePostfix = lineContent.Key;
				} else {
					toReturn.TranslateEntriesList.push(lineContent);
				}
			}
			return toReturn;
		}
		
		//https://hoi4.paradoxwikis.com/Localisation#Special_characters
		private static function ParseSingleLine(line:String):LineContent {
			var lineContent:LineContent = new LineContent();
			lineContent.Raw = line;
			
			var compressedLine:String = line.replace(" ", "").replace("\t", "");
			if (compressedLine.length == 0) {
				lineContent.isEmpty = true;
				return lineContent;
			}
			
			var firstColonIndex:int = line.indexOf(COLON_CHAR);
			
			SharpCharsIndex.length = 0;
			QuoteCharsIndex.length = 0;
			ParagraphCharsIndex.length = 0;
			EscapeCharsIndex.length = 0;
			BucksCharsIndex.length = 0;
			OpenBracketCharsIndex.length = 0;
			CloseBracketCharsIndex.length = 0;
			
			FindAll(SHARP_CHAR, line, SharpCharsIndex);
			FindAll(PARAGRAPH_CHAR, line, ParagraphCharsIndex);
			FindAll(BUCKS_CHAR, line, BucksCharsIndex);
			FindAll(OPEN_BRACKET_CHAR, line, OpenBracketCharsIndex);
			FindAll(CLOSE_BRACKET_CHAR, line, CloseBracketCharsIndex);
			
			FindAll(QUOTE_CHAR, line, QuoteCharsIndex);
			FindAll(ESCAPE_CHAR, line, EscapeCharsIndex);
			
			
			if (firstColonIndex < 0) { //Строка без ключа
				lineContent.isEmpty = true;
				for (var i:int = 0; i < line.length; i++) {
					var char:String = line.charAt(i);
					if (char == SHARP_CHAR) {
						lineContent.Comment = line.substring(i, line.length);
						break;
					}
					if (char != " " && char != "\t") {
						lineContent.Errors.push(new ForbiddenCharacterError(char, i));
					}
				}
				return lineContent;
			}
			var keyZone:String = line.substr(0, firstColonIndex); //Тут бы ещё проверку на количество пробелов до и после делать.
			var commentStartIndex:int = FindComment(keyZone);
			if (commentStartIndex > -1) {
				lineContent.Comment = line.substring(commentStartIndex, line.length);
				lineContent.isEmpty = true;
				return lineContent;
			}
			var forbiddenLines:Array = trimLeft(keyZone).match(CORRECT_NAME_REG);
			if (forbiddenLines != null && forbiddenLines.length > 0) {
				lineContent.Errors.push(new ForbiddenCharacterError(char, line.indexOf(forbiddenLines[0])));
				lineContent.isEmpty = true;
				return lineContent;
			}
			lineContent.Key = trimLeft(keyZone);
			
			if (QuoteCharsIndex.length < 2) {
				lineContent.Errors.push(new ValueCorruptedError());
				lineContent.isEmpty = true;
				return lineContent;
			}
			var versionZone:String = line.substring(firstColonIndex + 1, QuoteCharsIndex[0]);
			if (versionZone.length > 0) {
				var versionString:String = trimRight(versionZone);
				if (versionString.length > 0) { //Что-то, кроме кучи пробелов
					if (versionString.charAt(0) == " ") { //Но начинается тоже с пробела - а так уже нельзя
						lineContent.Errors.push(new VersionError());//Первый случай некритичной ошибки - можно исправить самостоятельно. Удалим и всё 
					} else { //Слева пробелов нет, справа убрали. А вдруг и правда число?
						var forbiddenVersion:Array = versionString.match(CORRECT_VERSION_REG);
						if (forbiddenVersion != null && forbiddenVersion.length > 0) {
							lineContent.Errors.push(new ForbiddenCharacterError(char, line.indexOf(forbiddenVersion[0])));
						} else {
							lineContent.Version = parseInt(versionString);
						}
						
					}
				}
			}
			lineContent.Value = line.substring(QuoteCharsIndex[0] + 1, QuoteCharsIndex[QuoteCharsIndex.length - 1]);
			//TODO: flashader Тут можно почистить от лишних эскейпов.
			//Да ещё и проверки всяких раскрасок проодить. Но влом пока.
			//И Файнд коммент ещё снизу заюзать! Чтобы после кавычки тоже схавала конец строки
			
			return lineContent;
		}
		
		private static function FindComment(toCheck:String):int {
			for (var i:int = 0; i < toCheck.length; i++) {
				var char:String = toCheck.charAt(i);
				if (char == SHARP_CHAR) {
					return i;
				}
				if (char != " " && char != "\t") {
					return -1;
				}
			}
			return -1;
		}
		
		private static function FindAll(charToFind:String, where:String, whereTo:Vector.<int>):void {
			var idx:int = where.indexOf(charToFind);
			while (idx > -1) {
				whereTo.push(idx);
				idx++;
				idx = where.indexOf(charToFind, idx);
			}
		}
		
		private static function trimLeft(toTrim:String, char:String = " "):String {
			if (toTrim.charAt(0) == char.charAt(0)) {
				toTrim = trimLeft(toTrim.substring(1), char);
			}
			return toTrim;
		}
		
		private static function trimRight(toTrim:String, char:String = " "):String {
			if (toTrim.charAt(toTrim.length - 1) == char.charAt(0)) {
				toTrim = trimRight(toTrim.substring(0, toTrim.length - 2), char);
			}
			return toTrim;
		}
	}
}