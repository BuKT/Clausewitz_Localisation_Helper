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
		
		public function Clone():YMLStringError {
			var clone:YMLStringError = GetNewInstance();
			clone._position = _position;
			return clone;
		}
		
		protected function GetNewInstance():YMLStringError {
			return new YMLStringError(_position);
		}
	}
}