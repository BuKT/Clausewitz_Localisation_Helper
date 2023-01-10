package ru.flashader.clausewitzlocalisationhelper.data {
	import ru.flashader.clausewitzlocalisationhelper.data.errors.YMLStringError;
	
	/**
	* @author Ilja 'flashader' Mickodin
	*/
	
	public class LineContent extends TranslateEntry {
		public var Version:int;
		public var Comment:String;
		public var Raw:String;
		public var Errors:Vector.<YMLStringError> = new Vector.<YMLStringError>();
		public var isEmpty:Boolean;
	}
}