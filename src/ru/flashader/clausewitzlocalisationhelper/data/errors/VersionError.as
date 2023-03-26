package ru.flashader.clausewitzlocalisationhelper.data.errors {
	
	/**
	* @author Ilja 'flashader' Mickodin
	*/
	
	public class VersionError extends YMLStringError {
		public function VersionError() { super( -1); }
		
		override protected function GetNewInstance():YMLStringError {
			return new VersionError();
		}
	}
}