package ru.flashader.clausewitzlocalisationhelper {
	import flash.events.Event;
	
	/**
	* @author Ilja 'flashader' Mickodin
	*/
	
	public class WebTranslatorEvent extends Event {
		public static const REQUEST_USER_INPUT:String = "requestUserInput";		
		
		public function WebTranslatorEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
		}
	}
}