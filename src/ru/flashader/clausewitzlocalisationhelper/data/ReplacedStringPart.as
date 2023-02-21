package ru.flashader.clausewitzlocalisationhelper.data {
	/**
	* @author Ilja 'flashader' Mickodin
	*/

	public class ReplacedStringPart {
		public var CorrespondingTag:TaggedRegion;
		public var ReplacingStartIndex:int;
		public var ReplacingString:String;
		public var TemporaryString:String;
		
		public function ReplacedStringPart(tag:TaggedRegion, index:int, string:String) {
			CorrespondingTag = tag;
			ReplacingStartIndex = index;
			ReplacingString = string;
		}
		
		public static function SortingByIndexes(x:ReplacedStringPart, y:ReplacedStringPart):int {
			if (x.ReplacingStartIndex < y.ReplacingStartIndex) { return -1; }
			return 1;
		}
		public function ReplaceWithTemporaryData(value:String, temporary:String):String {
			TemporaryString = temporary;
			return value.substr(0, ReplacingStartIndex).concat(temporary).concat(value.substr(ReplacingStartIndex + ReplacingString.length));
		}
	}
}