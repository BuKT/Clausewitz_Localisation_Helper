package ru.flashader.clausewitzlocalisationhelper.data {
	import ru.flashader.clausewitzlocalisationhelper.utils.Utilities;
	//import ru.flashader.clausewitzlocalisationhelper.utils.EUUtils;
	
	/**
	* @author Ilja 'flashader' Mickodin
	*/
	
	public class BaseSeparateTranslationEntry {
		private var _translateRequestProcessingCallback:Function;
		private var _valueChangedListener:Function;
		protected var _key:String;
		protected var _sourceValue:String = "";
		protected var _targetValue:String = "";
		private var _sourceValueOnceSetted:Boolean = false;
		private var _targetValueOnceSetted:Boolean = false;
		//protected var _isFuckingGEKS:Boolean = true;
		
		public function ToString(isSource:Boolean):String {
			return " ".concat(
				_key,
				': "',
				isSource ?
					_sourceValue :
					//_isFuckingGEKS ?
						//EUUtils.ConvertStringToEUCorr(_targetValue) :
						_targetValue,
				'"'
			);
		}
		
		public function Merge(entry:BaseSeparateTranslationEntry, isSource:Boolean):void {
			isSource ? _sourceValue = entry.GetRawValue(isSource) : _targetValue = entry.GetRawValue(isSource);
			_sourceValueOnceSetted ||= entry._sourceValueOnceSetted;
			_targetValueOnceSetted ||= entry._targetValueOnceSetted;
		}
		
		public function ToTableArray():Array {
			var toReturn:Array = new Array();
			toReturn.push(_key);
			toReturn.push(Utilities.ConvertStringToR(_sourceValue));
			toReturn.push(Utilities.ConvertStringToR(_targetValue));
			return toReturn;
		}
		
		public function GetKey():String {
			return _key;
		}
		
		public function GetTextFieldReadyValue(isSource:Boolean):String {
			return Utilities.ConvertStringToR(isSource ? _sourceValue : _targetValue);
		}
		
		public function SetKey(key:String):void {
			_key = key;
		}
		
		public function SetRawValue(value:String, isSource:Boolean):void {
			//value = _isFuckingGEKS ? EUUtils.ConvertStringToEUCyr(value) : value;
			if (isSource) {
				_sourceValue = value;
				_sourceValueOnceSetted = true;
			} else {
				_targetValue = value;
				_targetValueOnceSetted = true;
			}
		}
		
		public function GetRawValue(isSource:Boolean):String{
			//value = _isFuckingGEKS ? EUUtils.ConvertStringToEUCyr(value) : value;
			return isSource ? _sourceValue : _targetValue;
		}
		
		public function GetValueOnceSetted(isSource:Boolean):Boolean {
			return isSource ? _sourceValueOnceSetted : _targetValueOnceSetted;
		}
		
		public function SetValueFromField(value:String, isSource:Boolean):void {
			var convertedValue:String = Utilities.ConvertStringToN(value);
			SetRawValue(convertedValue, isSource);
			if (_valueChangedListener != null) {
				_valueChangedListener(this);
			}
		}
		
		public function addTranslateRequestListener(callback:Function):void {
			_translateRequestProcessingCallback = callback;
		}
		
		public function JustCopyTo(isSource:Boolean):void { //TODO: flashader Уведомить
			SetRawValue(!isSource ? _sourceValue : _targetValue, isSource);
			if (_valueChangedListener != null) {
				_valueChangedListener(this);
			}
		}
		
		public function SomeoneRequestToTranslateYou(isSource:Boolean):void {
			if (_translateRequestProcessingCallback != null) {
				_translateRequestProcessingCallback(this, isSource);
			}
		}
		
		public function GetValueToTranslate(isSource:Boolean):String {
			return GetRawValue(isSource);
		}
		
		public function SetTranslatedValue(value:String, isSource:Boolean):void {
			SetRawValue(value, isSource);
			if (_valueChangedListener != null) {
				_valueChangedListener(this);
			}
		}
		
		public function IsKeyed():Boolean {
			return GetKey() != null && GetKey().length > 0;
		}
		
		public function addValueChangedListener(callback:Function):void {
			_valueChangedListener = callback;
		}
		
		public function DisposeAllListeners():void {
			_translateRequestProcessingCallback = null;
			_valueChangedListener = null;
		}
		
		public static function DeepCloneFrom(original:BaseSeparateTranslationEntry):BaseSeparateTranslationEntry {
			var clone:BaseSeparateTranslationEntry = new BaseSeparateTranslationEntry();
			clone.Merge(original, true);
			clone.Merge(original, false);
			clone._key = original._key;
			return clone;
		}
	}
}