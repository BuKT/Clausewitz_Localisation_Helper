package ru.flashader.clausewitzlocalisationhelper {
	import flash.display.Sprite;
	import flash.events.Event;
	import org.aswing.*;
	import org.aswing.AsWingManager;
	
	/**
	* @author Ilja 'flashader' Mickodin
	*/
	
	public class TranslatingWindowController extends Sprite {
		private static const PLEASE_WAIT:String = "Подождите примерно три секунды.";
		private static const PLEASE_PRESS:String = "Нажмите 'Ctrl'+'Shift'+'S', а потом закройте это окно";
		private static const PLEASE_WAIT_AGAIN:String = "И ещё три секунды.";
		private var scrollPane:JScrollPane;
		private var _mainASWindow:JWindow;
		private var _currentAlert:JOptionPane;
		private var _currentTranslatingEntry:TranslateEntry;
		
		
		public function TranslatingWindowController() {
			super();
			AsWingManager.setRoot(this);
			
			//JOptionPane.showMessageDialog("About", "This is just a menu test demo!\n\n alskdjaldjalsdkj\n\n l;jasdf;ljasdfklj \n\n a;dksfj;ladfj;ladfj").getMsgLabel().setSelectable(true);
			
			WebTranslator.addEventListener(WebTranslatorEvent.REQUEST_USER_INPUT, handleUserInputRequest);
			WebTranslator.addEventListener(WebTranslatorEvent.TRANSLATION_ENDED, endTranslation);
			
			var entry:TranslateEntry = new TranslateEntry();
			entry.addTranslateRequestListener(initiateTranslate);
			
			
			_mainASWindow = new JWindow(this);
			_mainASWindow.setContentPane(entry);
			_mainASWindow.setSizeWH(stage.stageWidth, stage.stageHeight);
			_mainASWindow.show();
		}
		
		private function initiateTranslate(entry:TranslateEntry):void {
			if (_currentAlert != null) {
				_currentAlert.getFrame().dispose();
			}
			_currentAlert = JOptionPane.showMessageDialog("Идёт перевод", PLEASE_WAIT, null, null, true, null, 0);
			_currentAlert.getFrame().getTitleBar().getCloseButton().setVisible(false);
			_currentTranslatingEntry = entry;
			WebTranslator.TranslateMe(_currentTranslatingEntry.getSourceTranslation().getText(), stage);
		}
		
		private function handleUserInputRequest(e:Event):void {
			if (_currentAlert != null) {
				_currentAlert.getFrame().dispose();
			}
			_currentAlert = JOptionPane.showMessageDialog("Нужна помощь", PLEASE_PRESS, continueTranslate, null, true, null, JOptionPane.CLOSE);
		}
		
		private function continueTranslate(e:int):void {
			if (_currentAlert != null) {
				_currentAlert.getFrame().dispose();
			}
			_currentAlert = JOptionPane.showMessageDialog("Спасибо", PLEASE_WAIT_AGAIN, null, null, true, null, 0);
			_currentAlert.getFrame().getTitleBar().getCloseButton().setVisible(false);
			WebTranslator.ContinueTranslate(_currentTranslatingEntry.getTargetTranslation().getTextField());
		}
		
		private function endTranslation(e:Event):void {
			if (_currentAlert != null) {
				_currentAlert.getFrame().dispose();
			}
		}
	}
}