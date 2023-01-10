package ru.flashader.clausewitzlocalisationhelper.data.errors {
	import ru.flashader.clausewitzlocalisationhelper.data.errors.YMLStringError;
	
	/**
	* @author Ilja 'flashader' Mickodin
	*/
	
	public class ForbiddenCharacterError extends YMLStringError {
		private var _char:String;
		private var _index:int;
		
		public function get char():String {
			return _char;
		}
		
		public function get index():int {
			return _index;
		}
		
		public function ForbiddenCharacterError(char:String, i:int) {
			_char = char;
			_index = i;
		}
	}
}