package ru.flashader.clausewitzlocalisationhelper.utils {
	import ru.flashader.clausewitzlocalisationhelper.utils.Utilities;
	import ru.flashader.clausewitzlocalisationhelper.data.*;
	import ru.flashader.clausewitzlocalisationhelper.data.errors.*;
	
	/**
	* @author Ilja 'flashader' Mickodin
	*/
	
	public class Parsers {
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
		
		public static function DoParseAndFill(fileContent:String, fullPath:String, targetTranslationContainer:TranslationFileContent, isSource:Boolean):void {
			var escapedContent:String = fileContent.replace("\\n", FLASHADER_TEMPORARY_TEMPLATE);
			var lines:Array = escapedContent.split("\r\n");
			if (lines.length <= 1) {
				lines = escapedContent.split("\n");
				trace("Single linebreak");
			}
			for each (var line:String in lines) {
				var lineContent:RichSeparateTranslationEntry = ParseSingleLine(
					line.replace(
						FLASHADER_TEMPORARY_TEMPLATE,
						"\\n"
					).replace (
						'\\"',
						'"'
					),
					true
				);
				var postfixToCheck:String = isSource ? targetTranslationContainer.LanguageSourcePostfix : targetTranslationContainer.LanguageTargetPostfix;
				if (
					(
						postfixToCheck == null ||
						postfixToCheck.length == 0
					) &&
					lineContent.GetErrorsLength(isSource) == 1 &&
					lineContent.GetErrors(isSource)[0] is ValueCorruptedError
				) {
					targetTranslationContainer.SetPostfix(lineContent.GetKey(), isSource);
				} else {
					targetTranslationContainer.AddTranslateEntry(lineContent);
				}
			}
		}
		
		//https://hoi4.paradoxwikis.com/Localisation#Special_characters
		private static function ParseSingleLine(line:String, isSource:Boolean):RichSeparateTranslationEntry {
			var lineEntry:RichSeparateTranslationEntry = new RichSeparateTranslationEntry();
			lineEntry.Raw = line;
			
			var compressedLine:String = line.replace(" ", "").replace("\t", "");
			if (compressedLine.length == 0) {
				lineEntry.isEmpty = true;
				return lineEntry;
			}
			
			var firstColonIndex:int = line.indexOf(COLON_CHAR);
			
			SharpCharsIndex.length = 0;
			QuoteCharsIndex.length = 0;
			ParagraphCharsIndex.length = 0;
			EscapeCharsIndex.length = 0;
			BucksCharsIndex.length = 0;
			OpenBracketCharsIndex.length = 0;
			CloseBracketCharsIndex.length = 0;
			
			Utilities.FindAll(SHARP_CHAR, line, SharpCharsIndex);
			Utilities.FindAll(PARAGRAPH_CHAR, line, ParagraphCharsIndex);
			Utilities.FindAll(BUCKS_CHAR, line, BucksCharsIndex);
			Utilities.FindAll(OPEN_BRACKET_CHAR, line, OpenBracketCharsIndex);
			Utilities.FindAll(CLOSE_BRACKET_CHAR, line, CloseBracketCharsIndex);
			
			Utilities.FindAll(QUOTE_CHAR, line, QuoteCharsIndex);
			Utilities.FindAll(ESCAPE_CHAR, line, EscapeCharsIndex);
			
			
			if (firstColonIndex < 0) { //Строка без ключа
				lineEntry.isEmpty = true;
				for (var i:int = 0; i < line.length; i++) {
					var char:String = line.charAt(i);
					if (char == SHARP_CHAR) {
						lineEntry.Comment = line.substring(i, line.length);
						break;
					}
					if (char != " " && char != "\t") {
						lineEntry.AddError(new ForbiddenCharacterError(char, i), isSource);
					}
				}
				return lineEntry;
			}
			var keyZone:String = line.substr(0, firstColonIndex); //Тут бы ещё проверку на количество пробелов до и после делать.
			var commentStartIndex:int = FindComment(keyZone);
			if (commentStartIndex > -1) {
				lineEntry.Comment = line.substring(commentStartIndex, line.length);
				lineEntry.isEmpty = true;
				return lineEntry;
			}
			var forbiddenLines:Array = Utilities.trimLeft(keyZone).match(CORRECT_NAME_REG);
			if (forbiddenLines != null && forbiddenLines.length > 0) {
				lineEntry.AddError(new ForbiddenCharacterError(char, line.indexOf(forbiddenLines[0])), isSource);
				lineEntry.isEmpty = true;
				return lineEntry;
			}
			lineEntry.SetKey(Utilities.trimLeft(keyZone));
			
			if (QuoteCharsIndex.length < 2) {
				lineEntry.AddError(new ValueCorruptedError(), isSource);
				lineEntry.isEmpty = true;
				return lineEntry;
			}
			var versionZone:String = line.substring(firstColonIndex + 1, QuoteCharsIndex[0]);
			if (versionZone.length > 0) {
				var versionString:String = Utilities.trimRight(versionZone);
				if (versionString.length > 0) { //Что-то, кроме кучи пробелов
					if (versionString.charAt(0) == " ") { //Но начинается тоже с пробела - а так уже нельзя
						lineEntry.AddError(new VersionError(), isSource);//Первый случай некритичной ошибки - можно исправить самостоятельно. Удалим и всё 
					} else { //Слева пробелов нет, справа убрали. А вдруг и правда число?
						var forbiddenVersion:Array = versionString.match(CORRECT_VERSION_REG);
						if (forbiddenVersion != null && forbiddenVersion.length > 0) {
							lineEntry.AddError(new ForbiddenCharacterError(char, line.indexOf(forbiddenVersion[0])), isSource);
						} else {
							lineEntry.Version = parseInt(versionString);
						}
						
					}
				}
			}
			lineEntry.SetRawValue(line.substring(QuoteCharsIndex[0] + 1, QuoteCharsIndex[QuoteCharsIndex.length - 1]), isSource);
			
			ParseTags(lineEntry);
			
			//TODO: flashader Тут можно почистить от лишних эскейпов.
			//Да ещё и проверки всяких раскрасок проодить. Но влом пока.
			//И Файнд коммент ещё снизу заюзать! Чтобы после кавычки тоже схавала конец строки
			
			return lineEntry;
		}
		
		private static function ParseTags(lineEntry:RichSeparateTranslationEntry):void {
			//TODO: flashader Нутыпонел. Жопа полная.
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
	}
}