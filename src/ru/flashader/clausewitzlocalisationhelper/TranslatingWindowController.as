package ru.flashader.clausewitzlocalisationhelper {
	import flash.display.Shape;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextInteractionMode;
	
	/**
	* @author Ilja 'flashader' Mickodin
	*/
	
	public class TranslatingWindowController extends Sprite {
		private var _sourceInput:TextField;
		private var _overlayButton:SimpleButton;
		
		public function TranslatingWindowController() {
			super();
			WebTranslator.addEventListener(WebTranslatorEvent.REQUEST_USER_INPUT, handleUserInputRequest);
			_sourceInput = new TextField();
			_sourceInput.text = "Translate me please please please";
			_sourceInput.width = 400;
			_sourceInput.height = 200;
			_sourceInput.border = true;
			_sourceInput.borderColor = 0x000000;
			_sourceInput.type = TextFieldType.INPUT;
			addChild(_sourceInput);
			var translateButton:SimpleButton = createButton(120, 20);
			translateButton.addEventListener(MouseEvent.CLICK, initiateTranslate);
			translateButton.width = 100;
			translateButton.height = 30;
			translateButton.y = _sourceInput.x + _sourceInput.height + 10;
			addChild(translateButton);
			
			_overlayButton = createButton(stage.stageWidth, stage.stageHeight);
			
		}
		
		private function createButton(w:int, h:int):SimpleButton {
			return new SimpleButton(
				createButtonDisplayState(0xFFCC00, w, h),
				createButtonDisplayState(0xCCFF00, w, h),
				createButtonDisplayState(0xFFCC00, w, h),
				createButtonDisplayState(0x00CCFF, w, h)
			);
		}
		
		private function initiateTranslate(e:MouseEvent):void {
			WebTranslator.TranslateMe(_sourceInput.text, stage);
		}
		
		private function ContinueTranslate(e:MouseEvent):void {
			e.currentTarget.removeEventListener(e.type, arguments.callee)
			removeChild(_overlayButton);
			WebTranslator.ContinueTranslate(_sourceInput);
		}
		
		private function handleUserInputRequest(e:Event):void {
			addChild(_overlayButton);
			_overlayButton.addEventListener(MouseEvent.CLICK, ContinueTranslate);
		}
		
		private function ProcessUserInput(e:KeyboardEvent):void {
			if (
				!e.controlKey ||
				!e.shiftKey ||
				!(
					e.charCode == "S".charCodeAt() ||
					e.charCode == "s".charCodeAt()
				)
			) {
				trace("nope");
				return;
			}
			e.currentTarget.remove(e.type, arguments.callee);
			WebTranslator.ContinueTranslate(_sourceInput);
		}

		private function createButtonDisplayState(bgColor:uint, w:int, h:int):Shape {
			var toReturn:Shape = new Shape();
			with (toReturn) {
				graphics.beginFill(bgColor);
				graphics.drawRect(0, 0, w, h);
				graphics.endFill();
			}
			return toReturn;
		}
	}
}