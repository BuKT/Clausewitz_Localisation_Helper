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
		
		override public function Clone():YMLStringError {
			var clone: ForbiddenCharacterError = super.Clone() as ForbiddenCharacterError;
			clone._char = _char;
			return clone;
		}
		
		override protected function GetNewInstance():YMLStringError {
			return new ForbiddenCharacterError("", 0);
		}
	}
}