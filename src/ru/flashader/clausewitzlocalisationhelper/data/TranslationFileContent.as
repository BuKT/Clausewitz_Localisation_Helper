package ru.flashader.clausewitzlocalisationhelper.data {
	
	/**
	* @author Ilja 'flashader' Mickodin
	*/
	
	public class TranslationFileContent {
		public var LanguagePostfix:String;
		public var TranslateEntriesList:Vector.<BaseSeparateTranslationEntry> = new Vector.<BaseSeparateTranslationEntry>;
		
		public function ToYAML():String {
			var toReturnArray:Array = [ LanguagePostfix.concat(":") ];
			for each (var entry:BaseSeparateTranslationEntry in TranslateEntriesList) {
				toReturnArray.push(entry.TargetToString());
			}
			return toReturnArray.join("\n");
		}
	}
}