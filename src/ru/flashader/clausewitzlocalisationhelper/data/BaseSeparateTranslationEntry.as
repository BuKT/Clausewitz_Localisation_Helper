package ru.flashader.clausewitzlocalisationhelper.data {
	/**
	* @author Ilja 'flashader' Mickodin
	*/
	
	public class BaseSeparateTranslationEntry {
		public var Key:String;
		public var SourceValue:String = "";
		public var TargetValue:String = "";
		
		public function TargetToString():String {
			return " ".concat(Key, ': "', TargetValue, '"');
		}
		//TODO: flashader Надо уведомлять все окна, использующие этот энтри о его изменении.
		//Ебучие биндинги городить блять
	}
}