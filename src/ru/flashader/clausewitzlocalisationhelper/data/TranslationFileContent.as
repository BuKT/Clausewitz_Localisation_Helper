package ru.flashader.clausewitzlocalisationhelper.data {
	import flash.utils.Dictionary;
	import ru.flashader.clausewitzlocalisationhelper.utils.EntryToTextfieldsBinderMediator;
	
	/**
	* @author Ilja 'flashader' Mickodin
	*/
	
	public class TranslationFileContent {
		private static const ALLOWING_TO_CALL_CONSTRUCTOR:String = "ยง";
		
		private var _filename:String;
		public var LanguageSourcePostfix:String = "l_english";
		public var LanguageTargetPostfix:String = "l_russian";
		private var _translateEntriesList:Vector.<BaseSeparateTranslationEntry> = new Vector.<BaseSeparateTranslationEntry>();
		private var _keyToEntriesTranslator:Dictionary/*.<String, BaseSeparateTranslationEntry>*/ = new Dictionary/*.<String, BaseSeparateTranslationEntry>*/(true);
		private static var _translateRequestProcessingCallback:Function;
		private var _totalKeys:int;
		private var _notPairedSourceKeysCount:int;
		private var _notPairedTargetKeysCount:int;
		
		public function TranslationFileContent(securityKey:String, filename:String) {
			if (securityKey != ALLOWING_TO_CALL_CONSTRUCTOR) {
				throw new Error("Not allowed");
			}
			_filename = filename;
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
					toReturnArray.push(richEntry.GetRawValue(isSource));
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
			if (entry.IsKeyed()) {
				entry.addTranslateRequestListener(processTranslateRequestListener);
				_keyToEntriesTranslator[entry.GetKey()] = entry;
			}
		}
		
		public function MergeWith(tfc:TranslationFileContent, isSource:Boolean):void {
			for (var i:int = 0; i < tfc._translateEntriesList.length; i++) {
				var entry:BaseSeparateTranslationEntry = tfc._translateEntriesList[i];
				if (!entry.IsKeyed()) {
					AddTranslateEntry(entry);
				} else {
					var existingEntry:BaseSeparateTranslationEntry = GetEntryByKey(entry.GetKey());
					if (existingEntry == null) {
						AddTranslateEntry(entry);
					} else {
						existingEntry.Merge(entry, isSource);
					}
				}
			}
		}
		
		public function RecountKeysCount():void {
			_totalKeys = 0;
			_notPairedSourceKeysCount = 0;
			_notPairedTargetKeysCount = 0;
			for (var i:int = 0; i < _translateEntriesList.length; i++) {
				var entry:BaseSeparateTranslationEntry = _translateEntriesList[i];
				var key:String = entry.GetKey();
				if (
					entry.IsKeyed()
				) {
					_totalKeys++;
					var rawSourceValue:String = entry.GetRawValue(true);
					var rawTargetValue:String = entry.GetRawValue(false);
					if (entry.GetValueOnceSetted(true) && !entry.GetValueOnceSetted(false)) {
						_notPairedSourceKeysCount++;
					}
					if (!entry.GetValueOnceSetted(true) && entry.GetValueOnceSetted(false)) {
						_notPairedTargetKeysCount++;
					}
				}
			}
		}
		
		public function GetTotalKeysCount():int {
			return _totalKeys;
		}
		
		public function GetNotPairedKeysCount(isSource:Boolean):int {
			return isSource ? _notPairedSourceKeysCount : _notPairedTargetKeysCount;
		}
		
		private function GetEntryByKey(key:String):BaseSeparateTranslationEntry {
			return _keyToEntriesTranslator[key];
		}
		
		public function GetEntriesList():Vector.<BaseSeparateTranslationEntry> {
			return _translateEntriesList.concat();
		}
		
		public function GetFilename():String {
			return _filename;
		}
		
		private function processTranslateRequestListener(entry:BaseSeparateTranslationEntry, isSource:Boolean):void {
			if (_translateRequestProcessingCallback != null) {
				_translateRequestProcessingCallback(entry.SetTranslatedValue, entry.GetValueToTranslate(!isSource), isSource);
			}
		}
		
		public static function addTranslateRequestListener(callback:Function):void {
			_translateRequestProcessingCallback = callback;
		}
		
		public static function Obtain(filename:String):TranslationFileContent {
			return new TranslationFileContent(ALLOWING_TO_CALL_CONSTRUCTOR, filename);
		}
		
		public static function DeepCloneFrom(original:TranslationFileContent, filename:String):TranslationFileContent {
			var clone:TranslationFileContent = Obtain(filename);
			clone.LanguageSourcePostfix = original.LanguageSourcePostfix;
			clone.LanguageTargetPostfix = original.LanguageTargetPostfix;
			for (var i:int = 0; i < original._translateEntriesList.length; i++) {
				var entry:BaseSeparateTranslationEntry = original._translateEntriesList[i];
				var richEntry:RichSeparateTranslationEntry = entry as RichSeparateTranslationEntry;
				if (richEntry != null) {
					clone.AddTranslateEntry(RichSeparateTranslationEntry.DeepCloneFrom(richEntry));
				} else if (entry != null) {
					clone.AddTranslateEntry(BaseSeparateTranslationEntry.DeepCloneFrom(richEntry));
				}
			}
			return clone;
		}
	}
}