package ru.flashader.clausewitzlocalisationhelper.data {
	
	/**
	* @author Ilja 'flashader' Mickodin
	*/
	
	public class TaggedRegion {
		public var RegionStartIndex:int;
		public var RegionEndIndex:int;
		//public var GameType:int = GameTypeEnum.UNKNOWN;
		public var NonTranslatableStart:String;
		public var NonTranslatableEnd:String;
		
		public function Clone():TaggedRegion {
			var clone:TaggedRegion = new TaggedRegion();
			clone.RegionStartIndex = RegionStartIndex;
			clone.RegionEndIndex = RegionEndIndex;
			clone.NonTranslatableStart = NonTranslatableStart;
			clone.NonTranslatableEnd = NonTranslatableEnd;
			return clone;
		}
	}
	
	//public class GameTypeEnum {
		//public static const UNKNOWN:int = -1;
		//public static const CK:int = 0;
		//public static const EU:int = 1;
		//public static const VIC:int = 2;
		//public static const HOI:int = 3;
	//}
}