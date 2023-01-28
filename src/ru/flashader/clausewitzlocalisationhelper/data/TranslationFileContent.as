package ru.flashader.clausewitzlocalisationhelper.data {
	import ru.flashader.clausewitzlocalisationhelper.utils.EntryToTextfieldsBinderMediator;
	
	/**
	* @author Ilja 'flashader' Mickodin
	*/
	
	public class TranslationFileContent {
		private static const ALLOWING_TO_CALL_CONSTRUCTOR:String = "ยง";
		private static var _instance:TranslationFileContent;
		
		public var LanguageSourcePostfix:String;
		public var LanguageTargetPostfix:String = "l_russian";
		private var _translateEntriesList:Vector.<BaseSeparateTranslationEntry> = new Vector.<BaseSeparateTranslationEntry>;
		private static var _translateRequestProcessingCallback:Function;
		
		public function TranslationFileContent(securityKey:String) {
			if (securityKey != ALLOWING_TO_CALL_CONSTRUCTOR) {
				throw new Error("Not allowed");
			}
		}
		
		private function cleanEntries():void {
			for each (var entry:BaseSeparateTranslationEntry in _translateEntriesList) {
				EntryToTextfieldsBinderMediator.UnbindAllFromEntry(entry);
				entry.DisposeAllListeners();
			}
			_translateEntriesList.length = 0;
		}
		
		public function ToYAML(isSource:Boolean):String {
			var toReturnArray:Array = [ GetPostfix(isSource).concat(":") ];
			for each (var entry:BaseSeparateTranslationEntry in _translateEntriesList) {
				var richEntry:RichSeparateTranslationEntry = (entry as RichSeparateTranslationEntry);
				if (richEntry != null && richEntry.isEmpty) {
					toReturnArray.push(richEntry.Raw);
				} else {
					toReturnArray.push(entry.ToString(isSource));
				}
			}
			return toReturnArray.join("\n");
		}
		
		public function SetPostfix(value:String, isSource:Boolean):void {
			isSource ? LanguageSourcePostfix = value : LanguageTargetPostfix = value;
		}
		
		private function GetPostfix(isSource:Boolean):String {
			return isSource ? LanguageSourcePostfix : LanguageTargetPostfix;
		}
		
		public function AddTranslateEntry(entry:BaseSeparateTranslationEntry):void { //TODO: flashader Проверять на дублирующиеся ключи? Или уже похуй?
			_translateEntriesList.push(entry);
			entry.addTranslateRequestListener(processTranslateRequestListener);
		}
		
		public function GetEntriesList():Vector.<BaseSeparateTranslationEntry> {
			return _translateEntriesList.concat();
		}
		
		private function processTranslateRequestListener(entry:BaseSeparateTranslationEntry):void {
			if (_translateRequestProcessingCallback != null) {
				_translateRequestProcessingCallback(entry.SetTranslatedTarget, entry.GetSourceToTranslate());
			}
		}
		
		public static function addTranslateRequestListener(callback:Function):void {
			_translateRequestProcessingCallback = callback;
		}
		
		public static function Obtain(isSourceLoading:Boolean):TranslationFileContent {
			if (_instance == null) {
				_instance = new TranslationFileContent(ALLOWING_TO_CALL_CONSTRUCTOR);
			} else if (isSourceLoading) {
				_instance.cleanEntries();
			}
			return _instance;
		}
	}
}