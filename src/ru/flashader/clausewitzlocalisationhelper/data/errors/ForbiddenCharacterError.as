package ru.flashader.clausewitzlocalisationhelper.data.errors {
	import ru.flashader.clausewitzlocalisationhelper.data.errors.YMLStringError;
	
	/**
	* @author Ilja 'flashader' Mickodin
	*/
	
	public class ForbiddenCharacterError extends YMLStringError {
		private var _char:String;
		
		public function get char():String {
			return _char;
		}
		
		public function ForbiddenCharacterError(char:String, position:int) {
			_char = char;
			super(position);
		}
	}
}