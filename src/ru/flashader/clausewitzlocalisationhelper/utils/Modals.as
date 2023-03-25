package ru.flashader.clausewitzlocalisationhelper.utils {
	import flash.events.Event;
	import org.aswing.JOptionPane;
	
	/**
	* @author Ilja 'flashader' Mickodin
	*/
	
	public class Modals {
		private static var _currentAlert:JOptionPane;
		
		public static function ShowModal(title:String, message:String, closeHandler:Function = null, buttons:int = 0):void {
			CloseModal();
			_currentAlert = JOptionPane.showMessageDialog(title, message, closeHandler, null, true, null, buttons);
			_currentAlert.getMsgLabel().setSelectable(closeHandler != null);
			_currentAlert.getFrame().getTitleBar().getCloseButton().setVisible(closeHandler != null);
		}
		
		public static function ShowErrorMessage(message:String):void {
			ShowModal("Произошла ошибка", message, EmptyFunction);
		}
		
		public static function CloseModal(e:Event = null):void {
			if (_currentAlert != null) {
				_currentAlert.getFrame().dispose();
			}
			_currentAlert = null;
		}
		
		public static function EmptyFunction(...args):void { }
		
		public static function EmergencyLog(log:String):void {
			ShowModal("Хуйня случилась", log);
			throw new Error("To prevent code completion");
		}
	}
}