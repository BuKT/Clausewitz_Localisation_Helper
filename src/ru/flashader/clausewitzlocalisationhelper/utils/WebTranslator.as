package ru.flashader.clausewitzlocalisationhelper.utils {
	import flash.display.Stage;
	import flash.events.EventDispatcher;
	import flash.geom.Rectangle;
	import flash.media.StageWebView;
	import flash.net.URLVariables;
	import flash.text.TextField;
	import flash.utils.setTimeout;
	
	/**
	* @author Ilja 'flashader' Mickodin
	*/
	
	public class WebTranslator {
		private static var Dispatcher:EventDispatcher = new EventDispatcher();
		private static var Instance:StageWebView;
		private static const TEMPLATE_TO_CHANGE:String = "###TEMPLATETOCHAGE###";
		private static const URLToLoad:String = "https://translate.google.com/?sl=en&tl=ru&text=" + TEMPLATE_TO_CHANGE + "&op=translate";
		private static var _secondsLeft:int;
		private static var _callback:Function;
		private static var _outputToFill:TextField;
		private static var _inputToTranslate:String;
		
		public static function TranslateMe(input:String, stage:Stage):void {
			if (Instance == null) {
				CreateInstance(stage);
			}
			_inputToTranslate = input;
			_callback = RequestUserInput;
			_secondsLeft = 3;
			Instance.loadURL(URLToLoad.replace(TEMPLATE_TO_CHANGE, input));
		}
		
		private static function RequestUserInput():void {
			_callback = null;
			dispatchEvent(new WebTranslatorEvent(WebTranslatorEvent.REQUEST_USER_INPUT));
		}
		
		public static function ContinueTranslate(outputField:TextField):void {
			_outputToFill = outputField;
			_callback = FillOutputField;
			_secondsLeft = 3;
		}
		
		private static function FillOutputField():void {
			_callback = null;
			_outputToFill.text = new URLVariables(Instance.location).text;
			dispatchEvent(new WebTranslatorEvent(WebTranslatorEvent.TRANSLATION_ENDED));
		}
		
		private static function CreateInstance(stage:Stage):void {
			Instance = new StageWebView(true, false);
			Instance.stage = stage;
			var w:int = stage.stageWidth;
			var h:int = stage.stageHeight;
			Instance.viewPort = new Rectangle( - w / 2, - h / 2, w / 2, h / 2);
			setTimeout(SecondsTicker, 1000);
		}
		
		private static function SecondsTicker():void {
			setTimeout(SecondsTicker, 1000);
			_secondsLeft > 0 &&	_secondsLeft--;
			_secondsLeft == 0 && _callback != null && _callback();
		}
		
		private static function dispatchEvent(event:WebTranslatorEvent):void {
			Dispatcher.dispatchEvent(event);
		}
		
		public static function addEventListener(type:String, callback:Function):void {
			Dispatcher.addEventListener(type, callback);
		}
	}
}