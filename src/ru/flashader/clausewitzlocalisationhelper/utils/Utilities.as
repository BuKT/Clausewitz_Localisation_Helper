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
			toConvert = toConvert.replace(/&quot;/g, '"');
			toConvert = toConvert.replace(/&#39;/g, '"');
			return toConvert;
		}
		
		public static function RemoveStrangeSpaces(toConvert:String):String {
			toConvert = toConvert.replace(/%20/g, ' ');
			toConvert = toConvert.replace(/&ZeroWidthSpace;/g, '');
			toConvert = toConvert.replace(/\u0020/g, ' ');
			toConvert = toConvert.replace(/\u00A0/g, ' ');
			toConvert = toConvert.replace(/\u1680/g, ' ');
			toConvert = toConvert.replace(/\u2000/g, ' ');
			toConvert = toConvert.replace(/\u2001/g, ' ');
			toConvert = toConvert.replace(/\u2002/g, ' ');
			toConvert = toConvert.replace(/\u2003/g, ' ');
			toConvert = toConvert.replace(/\u2004/g, ' ');
			toConvert = toConvert.replace(/\u2005/g, ' ');
			toConvert = toConvert.replace(/\u2006/g, ' ');
			toConvert = toConvert.replace(/\u2007/g, ' ');
			toConvert = toConvert.replace(/\u2008/g, ' ');
			toConvert = toConvert.replace(/\u2009/g, ' ');
			toConvert = toConvert.replace(/\u200A/g, ' ');
			toConvert = toConvert.replace(/\u202F/g, ' ');
			toConvert = toConvert.replace(/\u205F/g, ' ');
			toConvert = toConvert.replace(/\u3000/g, ' ');
			
			toConvert = toConvert.replace(/\u180E/g, '');
			toConvert = toConvert.replace(/\u200B/g, '');
			toConvert = toConvert.replace(/\u200C/g, '');
			toConvert = toConvert.replace(/\u200D/g, '');
			toConvert = toConvert.replace(/\u2060/g, '');
			return toConvert;
		}
	}
}