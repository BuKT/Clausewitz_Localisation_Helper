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
		
		private static const OpenSharpCharsIndex:Vector.<int> = new Vector.<int>();
		private static const OPEN_SHARP_CHAR:String = "#";
		
		private static const CloseSharpCharsIndex:Vector.<int> = new Vector.<int>();
		private static const CLOSE_SHARP_CHAR:String = "#!";
		
		private static const QuoteCharsIndex:Vector.<int> = new Vector.<int>();
		private static const QUOTE_CHAR:String = '"';
		
		//private static const EscapeCharsIndex:Vector.<int> = new Vector.<int>();
		//private static const ESCAPE_CHAR:String = '\\';
		
		private static const OpenParagraphCharsIndex:Vector.<int> = new Vector.<int>();
		private static const OPEN_PARAGRAPH_CHAR:String = "§";
		
		private static const CloseParagraphCharsIndex:Vector.<int> = new Vector.<int>();
		private static const CLOSE_PARAGRAPH_CHAR:String = "§!";
		
		private static const BucksCharsIndex:Vector.<int> = new Vector.<int>();
		private static const BUCKS_CHAR:String = "$";
		
		private static const OpenBracketCharsIndex:Vector.<int> = new Vector.<int>();
		private static const OPEN_BRACKET_CHAR:String = "[";
		
		private static const CloseBracketCharsIndex:Vector.<int> = new Vector.<int>();
		private static const CLOSE_BRACKET_CHAR:String = "]";
		
		private static const CORRECT_NAME_REG:RegExp = new RegExp("[^a-zA-Z0-9_.-]");
		private static const CORRECT_VERSION_REG:RegExp = new RegExp("[^0-9]"); //Ever dots not allowed
		
		private static const FORBIDDEN_INNER_CHARS:Array = [
			OPEN_SHARP_CHAR,
			CLOSE_SHARP_CHAR,
			OPEN_PARAGRAPH_CHAR,
			CLOSE_PARAGRAPH_CHAR,
			BUCKS_CHAR,
			OPEN_BRACKET_CHAR,
			CLOSE_BRACKET_CHAR,
			' '
		];
		
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
			
			QuoteCharsIndex.length = 0;
			Utilities.FindAll(QUOTE_CHAR, line, QuoteCharsIndex);
			
			
			if (firstColonIndex < 0) { //Строка без ключа
				lineEntry.isEmpty = true;
				for (var i:int = 0; i < line.length; i++) {
					var char:String = line.charAt(i);
					if (char == OPEN_SHARP_CHAR) {
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
			
			isSource ? ParseSourceTags(lineEntry) : ParseTargetTags(lineEntry);
			
			//TODO: flashader Тут можно почистить от лишних эскейпов.
			//Да ещё и проверки всяких раскрасок проводить. Но влом пока.
			//И Файнд коммент ещё снизу заюзать! Чтобы после кавычки тоже схавала конец строки
			
			return lineEntry;
		}
		
		public static function ParseSourceTags(lineEntry:RichSeparateTranslationEntry):void {
			lineEntry.SourceTaggedRegions.length = 0;
			lineEntry.ClearErrors(true);
			AddNewTagsErrors(ParseTags(lineEntry.GetValueToParse(true), lineEntry.SourceTaggedRegions, true), lineEntry, true);
		}
		
		public static function ParseTargetTags(lineEntry:RichSeparateTranslationEntry):void {
			lineEntry.TargetTaggedRegions.length = 0;
			lineEntry.ClearErrors(false);
			AddNewTagsErrors(ParseTags(lineEntry.GetValueToParse(false), lineEntry.TargetTaggedRegions, false), lineEntry, true);
		}
		
		private static function ParseTags(value:String, taggedRegions:Vector.<TaggedRegion>, isSource:Boolean):Vector.<YMLStringError> {
			var toReturn:Vector.<YMLStringError> = new Vector.<YMLStringError>();
			ParseForBrackets(value, taggedRegions, toReturn);
			ParseForParagraphs(value, taggedRegions, toReturn);
			ParseForSharps(value, taggedRegions, toReturn);
			ParseForBucks(value, taggedRegions, toReturn);
			return toReturn;
		}
		
		private static function ParseForBrackets(value:String, taggedRegions:Vector.<TaggedRegion>, errorsContainer:Vector.<YMLStringError>):void {
			OpenBracketCharsIndex.length = 0;
			Utilities.FindAll(OPEN_BRACKET_CHAR, value, OpenBracketCharsIndex);
			CloseBracketCharsIndex.length = 0;
			Utilities.FindAll(CLOSE_BRACKET_CHAR, value, CloseBracketCharsIndex);
			for (var i:int = 0; i < OpenBracketCharsIndex.length; i++) {
				var startIndex:int = OpenBracketCharsIndex[i];
				var endIndex:int;
				if (i >= CloseBracketCharsIndex.length || (endIndex = CloseBracketCharsIndex[i]) < startIndex) {
					errorsContainer.push(new UnclosedTagError(startIndex));
					break;
				}
				var firstForbiddenIndex:int = FindFirstForbiddenIndexAfter(value, startIndex);
				if (endIndex > firstForbiddenIndex) {
					errorsContainer.push(new UnknownTagFunction(startIndex));
					break;
				}
				var bracketRegion:TaggedRegion = new TaggedRegion(); //TODO: flashader Третьи кресты позволяют абсолютно ублюдочную конструкцию: "The game concept link [Concept('faith','religion')|E] is now written as religion.", в которой второе слово в унарных кавычках переводить не надо
				bracketRegion.RegionStartIndex = startIndex;
				bracketRegion.RegionEndIndex = startIndex + 1;
				bracketRegion.NonTranslatableStart = value.substr(startIndex, 1);
				bracketRegion.NonTranslatableEnd = value.substr(startIndex + 1, endIndex - startIndex);
				taggedRegions.push(bracketRegion);
			}
		}
		
		private static function ParseForParagraphs(value:String, taggedRegions:Vector.<TaggedRegion>, errorsContainer:Vector.<YMLStringError>):void {
			OpenParagraphCharsIndex.length = 0;
			Utilities.FindAll(OPEN_PARAGRAPH_CHAR, value, OpenParagraphCharsIndex);
			CloseParagraphCharsIndex.length = 0;
			Utilities.FindAll(CLOSE_PARAGRAPH_CHAR, value, CloseParagraphCharsIndex);
			var i:int;
			for (i = 0; i < CloseParagraphCharsIndex.length; i++) { //Открывающий тег очень похож на часть закрывающего
				var doubledIndex:int = OpenParagraphCharsIndex.indexOf(CloseParagraphCharsIndex[i]);
				if (doubledIndex > -1) {
					OpenParagraphCharsIndex.removeAt(doubledIndex);
				}
			}
			
			for (i = 0; i < OpenParagraphCharsIndex.length; i++) {
				var startIndex:int = OpenParagraphCharsIndex[i];
				var endIndex:int;
				if (i >= CloseParagraphCharsIndex.length || (endIndex = CloseParagraphCharsIndex[i]) < startIndex) {
					errorsContainer.push(new UnclosedTagError(startIndex));
					break;
				}
				var paragraphRegion:TaggedRegion = new TaggedRegion();
				paragraphRegion.RegionStartIndex = startIndex;
				paragraphRegion.RegionEndIndex = endIndex;
				paragraphRegion.NonTranslatableStart = value.substr(startIndex, 2);
				paragraphRegion.NonTranslatableEnd = value.substr(endIndex, 2);
				taggedRegions.push(paragraphRegion);
			}
		}
		
		private static function ParseForSharps(value:String, taggedRegions:Vector.<TaggedRegion>, errorsContainer:Vector.<YMLStringError>):void {
			OpenSharpCharsIndex.length = 0;
			Utilities.FindAll(OPEN_SHARP_CHAR, value, OpenSharpCharsIndex);
			CloseSharpCharsIndex.length = 0;
			Utilities.FindAll(CLOSE_SHARP_CHAR, value, CloseSharpCharsIndex);
			var i:int;
			for (i = 0; i < CloseSharpCharsIndex.length; i++) { //Открывающий тег очень похож на часть закрывающего
				var doubledIndex:int = OpenSharpCharsIndex.indexOf(CloseSharpCharsIndex[i]);
				if (doubledIndex > -1) {
					OpenSharpCharsIndex.removeAt(doubledIndex);
				}
			}
			
			for (i = 0; i < OpenSharpCharsIndex.length; i++) {
				var startIndex:int = OpenSharpCharsIndex[i];
				var endIndex:int;
				if (i >= CloseSharpCharsIndex.length || (endIndex = CloseSharpCharsIndex[i]) < startIndex) {
					errorsContainer.push(new UnclosedTagError(startIndex));
					break;
				}
				var firstSpaceIndex:int = value.indexOf(' ', startIndex);
				if (firstSpaceIndex - startIndex < 2 || firstSpaceIndex > endIndex) {
					errorsContainer.push(new UnknownTagFunction(startIndex));
				}
				var sharpRegion:TaggedRegion = new TaggedRegion();
				sharpRegion.RegionStartIndex = startIndex;
				sharpRegion.RegionEndIndex = endIndex;
				sharpRegion.NonTranslatableStart = value.substring(startIndex, firstSpaceIndex + 1);
				sharpRegion.NonTranslatableEnd = value.substr(endIndex, 2);
				taggedRegions.push(sharpRegion);
			}
		}
		private static function ParseForBucks(value:String, taggedRegions:Vector.<TaggedRegion>, errorsContainer:Vector.<YMLStringError>):void {
			BucksCharsIndex.length = 0;
			Utilities.FindAll(BUCKS_CHAR, value, BucksCharsIndex);
			for (var i:int = 0; i < BucksCharsIndex.length; i+=2) {
				var startIndex:int = BucksCharsIndex[i];
				var innerSpaceIndex:int = value.indexOf(' ',  startIndex);
				if (i + 1 >= BucksCharsIndex.length) {
					errorsContainer.push(new UnclosedTagError(startIndex));
					break;
				}
				var endIndex:int = BucksCharsIndex[i + 1];
				var firstForbiddenIndex:int = FindFirstForbiddenIndexAfter(value, startIndex);
				if (endIndex > firstForbiddenIndex) {
					errorsContainer.push(new UnknownTagFunction(startIndex));
					break;
				}
				var bucksRegion:TaggedRegion = new TaggedRegion();
				bucksRegion.RegionStartIndex = startIndex;
				bucksRegion.RegionEndIndex = startIndex + 1;
				bucksRegion.NonTranslatableStart = value.substr(startIndex, 1);
				bucksRegion.NonTranslatableEnd = value.substr(startIndex + 1, endIndex - startIndex);
				taggedRegions.push(bucksRegion);
			}
		}
		
		private static function FindFirstForbiddenIndexAfter(value:String, startIndex:int):int { //Непрерывные тегированные пространства не имеют права содержать другие теги
			var toReturn:int = int.MAX_VALUE;
			var idx:int = -1;
			for (var i:int = 0; i < FORBIDDEN_INNER_CHARS.length; i++) {
				var char:String = FORBIDDEN_INNER_CHARS[i];
				//if (char == exception) { continue; }
				idx = value.indexOf(char, startIndex + 1);
				if (idx > -1) {
					toReturn = Math.min(idx, toReturn);
				}
			}
			return toReturn;
		}
		
		private static function FindComment(toCheck:String):int {
			for (var i:int = 0; i < toCheck.length; i++) {
				var char:String = toCheck.charAt(i);
				if (char == OPEN_SHARP_CHAR) {
					return i;
				}
				if (char != " " && char != "\t") {
					return -1;
				}
			}
			return -1;
		}
		
		private static function AddNewTagsErrors(sourceErrors:Vector.<YMLStringError>, lineEntry:RichSeparateTranslationEntry, isSource:Boolean):void {
			for each (var error:YMLStringError in sourceErrors) {
				lineEntry.AddError(error, isSource);
			}
		}
	}
}