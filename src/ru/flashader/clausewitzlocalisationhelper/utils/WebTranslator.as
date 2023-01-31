package ru.flashader.clausewitzlocalisationhelper.utils {
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Rectangle;
	import flash.media.StageWebView;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.text.TextField;
	import flash.utils.Dictionary;
	import flash.utils.setTimeout;
	
	/**
	* @author Ilja 'flashader' Mickodin
	*/
	
	public class WebTranslator {
		private static var Dispatcher:EventDispatcher = new EventDispatcher();
		private static var Instances:Vector.<StageWebView> = new Vector.<StageWebView>();
		private static const TEMPLATE_TO_CHANGE:String = "###TEMPLATETOCHAGE###";
		private static const GUIURLToLoad:String = "https://translate.google.com/?sl=auto&tl=ru&text=" + TEMPLATE_TO_CHANGE + "&op=translate";
		private static const CLIURLToLoad:String = "https://translate.google.com/m?sl=auto&tl=ru&q=" + TEMPLATE_TO_CHANGE;
		private static var _secondsLeft:int;
		private static var _callback:Function;
		private static var _outputCallback:Function;
		private static var _tickerSetted:Boolean;
		private static var _splittedInput:SplittedInput;
		private static var _lastTranslatedInput:Number;
		private static var _currentInputToTranslate:String;
		private static var _freeLoaders:Vector.<URLLoader> = new Vector.<URLLoader>();
		private static var _loaderToCallbackDictionary:Dictionary = new Dictionary(true);
		
		
		private static const CLI_TRANSLATION_START_MARKER:String = '<div class="result-container">'
		private static const CLI_TRANSLATION_END_MARKER:String = '</div><div class="links-container"><ul><li><a href="https://www.google.com/m?hl=en-US">Google home</a>'
		private static var _usedLoaders:int = 0;
		private static var _waitedTranslations:Array = [];
		
		public static function TranslateMe(input:String, stage:Stage, outputCallback:Function, useGUIAPI:Boolean = false):void {
			_outputCallback = outputCallback;
			input = Utilities.RemoveSharps(input);
			if (useGUIAPI) {
				TranslateWithGUIAPI(input, stage);
			} else {
				RunCLITranslate(input, outputCallback);
			}
		}
		
		private static function RunCLITranslate(input:String, callback:Function):void {
			if (_usedLoaders > 30) {
				_waitedTranslations.push({
					input: input,
					callback: callback
				});
				return;
			}
			var cliLoader:URLLoader = GetNextFreeCLILoader();
			cliLoader.addEventListener(Event.COMPLETE, completeTranslate);
			_loaderToCallbackDictionary[cliLoader] = callback;
			var requestString:String = CLIURLToLoad.replace(TEMPLATE_TO_CHANGE, input);
			cliLoader.load(new URLRequest(requestString));
		}
		
		private static function GetNextFreeCLILoader():URLLoader {
			_usedLoaders++;
			return _freeLoaders.length == 0 ? new URLLoader() : _freeLoaders.pop();
		}
		
		private static function FreeCLILoader(loader:URLLoader):void {
			_usedLoaders--;
			_loaderToCallbackDictionary[loader] = null;
			loader.removeEventListener(Event.COMPLETE, completeTranslate);
			_freeLoaders.push(loader);
			if (_waitedTranslations.length > 0) {
				var waitedTranslation:Object = _waitedTranslations.pop();
				RunCLITranslate(waitedTranslation["input"], waitedTranslation["callback"]);
			}
		}
		
		private static function completeTranslate(e:Event):void {
			var loader:URLLoader = e.currentTarget as URLLoader;
			var html:String = loader.data.toString();
			var startTranslationIDX:int = html.indexOf(CLI_TRANSLATION_START_MARKER) + CLI_TRANSLATION_START_MARKER.length;
			var endTranslationIDX:int = html.indexOf(CLI_TRANSLATION_END_MARKER);
			var translate:String = Utilities.RestoreQuotation(Utilities.RestoreSharps(html.substring(startTranslationIDX, endTranslationIDX)));
			dispatchEvent(new WebTranslatorEvent(WebTranslatorEvent.TRANSLATION_ENDED));
			_loaderToCallbackDictionary[loader] != null && _loaderToCallbackDictionary[loader](translate);
			FreeCLILoader(loader);
		}
		
		private static function TranslateWithGUIAPI(input:String, stage:Stage):void {
			_callback = RequestUserInput;
			_secondsLeft = 3;
			_splittedInput = new SplittedInput(input);
			
			CreateInstances(stage);
			if (!_tickerSetted) {
				_tickerSetted = true;
				setTimeout(SecondsTicker, 1000);
			}
			
			_lastTranslatedInput = 0;
			var instanceIDX:int = 0;
			while ((_currentInputToTranslate = _splittedInput.GetNextSplittedInput()) != null) {
				Instances[instanceIDX].loadURL(GUIURLToLoad.replace(TEMPLATE_TO_CHANGE, _currentInputToTranslate));
				instanceIDX++;
			}
			_splittedInput.ResetCounter();
		}
		
		private static function RequestUserInput():void {
			Instances[_lastTranslatedInput].assignFocus();
			_callback = null;
			dispatchEvent(new WebTranslatorEvent(WebTranslatorEvent.REQUEST_USER_INPUT));
		}
		
		public static function ContinueTranslate():void {
			_callback = FillOutputField;
			_secondsLeft = 3;
		}
		
		private static function FillOutputField():void {
			_callback = null;
			_splittedInput.SetCurrentTranslate(new URLVariables(Instances[_lastTranslatedInput].location).text);
			_lastTranslatedInput++;
			if ((_currentInputToTranslate = _splittedInput.GetNextSplittedInput()) == null) {
				_outputCallback != null && _outputCallback(_splittedInput.CollectString());
				dispatchEvent(new WebTranslatorEvent(WebTranslatorEvent.TRANSLATION_ENDED));
				return;
			}
			RequestUserInput();
		}
		
		private static function CreateInstances(stage:Stage):void {
			while (Instances.length < _splittedInput.GetTranslatorsNeeded()) {
				var Instance:StageWebView = new StageWebView(true, false);
				Instance.stage = stage;
				var w:int = stage.stageWidth;
				var h:int = stage.stageHeight;
				Instance.viewPort = new Rectangle( -w / 2, -h / 2, w / 2, h / 2);
				Instances.push(Instance);
			}
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
		
		public static function GetTranslatesLeft():int {
			return _splittedInput.GetTranslatorsNeeded() - _lastTranslatedInput - 1;
		}
	}
}