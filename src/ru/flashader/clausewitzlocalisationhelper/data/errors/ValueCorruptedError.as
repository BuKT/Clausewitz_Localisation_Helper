package ru.flashader.clausewitzlocalisationhelper.data.errors {
	/**
	* @author Ilja 'flashader' Mickodin
	*/
	
	public class ValueCorruptedError extends YMLStringError {
		public function ValueCorruptedError() { super(-1); }
		
		override protected function GetNewInstance():YMLStringError {
			return new ValueCorruptedError();
		}
	}
}