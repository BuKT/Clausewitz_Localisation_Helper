package ru.flashader.clausewitzlocalisationhelper.data.errors {
	
	/**
	* @author Ilja 'flashader' Mickodin
	*/
	
	public class UnclosedTagError extends YMLStringError {
		public function UnclosedTagError(position:int) {
			super(position);
		}
		
		override protected function GetNewInstance():YMLStringError {
			return new UnclosedTagError(-1);
		}
	}
}