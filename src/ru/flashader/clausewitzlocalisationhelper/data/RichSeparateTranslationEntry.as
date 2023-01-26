package ru.flashader.clausewitzlocalisationhelper.data {
	
	import ru.flashader.clausewitzlocalisationhelper.data.errors.YMLStringError;

	/**
	* @author Ilja 'flashader' Mickodin
	*/
	
	public class RichSeparateTranslationEntry extends BaseSeparateTranslationEntry {
		public var Version:int;
		public var Comment:String;
		public var Raw:String;
		public var Errors:Vector.<YMLStringError> = new Vector.<YMLStringError>();
		public var isEmpty:Boolean;
		
		override public function TargetToString():String {
			return " ".concat(Key, ":", isNaN(Version) ? ' "' : Version + ' "', TargetValue, '"');
		}
	}
}