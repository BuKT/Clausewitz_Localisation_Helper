package ru.flashader.clausewitzlocalisationhelper.data {
	/**
	* @author Ilja 'flashader' Mickodin
	*/
	
	public class TranslationFileContent {
		public var LanguagePostfix:String;
		public var TranslateEntriesList:Vector.<TranslateEntry>;
		
		public function TranslationFileContent(nonCastedObject:*) {
			LanguagePostfix = nonCastedObject["LanguagePostfix"];
			TranslateEntriesList = new Vector.<TranslateEntry>();
			for each (var nonCastedEntry:* in nonCastedObject["TranslateEntriesList"]) {
				var entry:TranslateEntry = new TranslateEntry();
				entry.Key = nonCastedEntry["Key"];
				entry.Value = nonCastedEntry["Value"];
				TranslateEntriesList.push(entry);
			}
			
		}
		
		public function ToYAML():String {
			var toReturnArray:Array = [ LanguagePostfix.concat(":") ];
			for each (var entry:TranslateEntry in TranslateEntriesList) {
				toReturnArray.push(entry.ToString());
			}
			return toReturnArray.join("\n");
		}
	}
}