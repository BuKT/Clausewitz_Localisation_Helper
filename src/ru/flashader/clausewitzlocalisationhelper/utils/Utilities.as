package ru.flashader.clausewitzlocalisationhelper.utils {
	import ru.flashader.clausewitzlocalisationhelper.data.BaseSeparateTranslationEntry;
	import ru.flashader.clausewitzlocalisationhelper.data.RichSeparateTranslationEntry;
	import ru.flashader.clausewitzlocalisationhelper.data.TranslationFileContent;
	import ru.flashader.clausewitzlocalisationhelper.data.errors.ForbiddenCharacterError;
	import ru.flashader.clausewitzlocalisationhelper.data.errors.ValueCorruptedError;
	import ru.flashader.clausewitzlocalisationhelper.data.errors.VersionError;

	/**
	* @author Ilja 'flashader' Mickodin
	*/
	
	public class Utilities {
		
		public static function FindAll(charToFind:String, where:String, whereTo:Vector.<int>):void {
			var idx:int = where.indexOf(charToFind);
			while (idx > -1) {
				whereTo.push(idx);
				idx++;
				idx = where.indexOf(charToFind, idx);
			}
		}
		
		public static function trimLeft(toTrim:String, char:String = " "):String {
			if (toTrim.charAt(0) == char.charAt(0)) {
				toTrim = trimLeft(toTrim.substring(1), char);
			}
			return toTrim;
		}
		
		public static function trimRight(toTrim:String, char:String = " "):String {
			if (toTrim.charAt(toTrim.length - 1) == char.charAt(0)) {
				toTrim = trimRight(toTrim.substring(0, toTrim.length - 2), char);
			}
			return toTrim;
		}
		
		public static function ConvertStringToN(toConvert:String):String {
			while (toConvert.indexOf("\r") > -1) {
				toConvert = toConvert.replace("\r", "\\n");
			}
			return toConvert;
		}
		
		public static function ConvertStringToShortN(toConvert:String):String {
			while (toConvert.indexOf("\r") > -1) {
				toConvert = toConvert.replace("\r", "\n");
			}
			return toConvert;
		}
		
		public static function ConvertStringToR(toConvert:String):String {
			while (toConvert.indexOf("\\n") > -1) {
				toConvert = toConvert.replace("\\n", "\r");
			}
			while (toConvert.indexOf("\n") > -1) {
				toConvert = toConvert.replace("\n", "\r");
			}
			return toConvert;
		}
		
		public static function RemoveSharps(toConvert:String):String {
			while (toConvert.indexOf("#") > -1) {
				toConvert = toConvert.replace("#", "%23");
			}
			return toConvert;
		}
		
		public static function RestoreSharps(toConvert:String):String {
			while (toConvert.indexOf("%23") > -1) {
				toConvert = toConvert.replace("%23", "#");
			}
			return toConvert;
		}
		
		public static function RestoreQuotation(toConvert:String):String {
			while (toConvert.indexOf("&quot;") > -1) {
				toConvert = toConvert.replace("&quot;", '"');
			}
			while (toConvert.indexOf("&#39;") > -1) {
				toConvert = toConvert.replace("&#39;", "'");
			}
			return toConvert;
		}
	}
}