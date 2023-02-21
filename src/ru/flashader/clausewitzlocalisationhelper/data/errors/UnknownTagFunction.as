package ru.flashader.clausewitzlocalisationhelper.data.errors {
	
	/**
	* @author Ilja 'flashader' Mickodin
	*/
	
	public class UnknownTagFunction extends YMLStringError {
		
		public function UnknownTagFunction(position:int) {
			super(position);
		}
	}
}