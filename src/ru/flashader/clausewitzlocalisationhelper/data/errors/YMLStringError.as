package ru.flashader.clausewitzlocalisationhelper.data.errors {
	/**
	* @author Ilja 'flashader' Mickodin
	*/
	
	public class YMLStringError {
		private var _position:int;
		
		public function get Position():int {
			return _position;
		}
		
		public function YMLStringError(position:int) {
			_position = position;
		}
	}
}