package ru.flashader.clausewitzlocalisationhelper.data {
	import ru.flashader.clausewitzlocalisationhelper.utils.Utilities;
	/**
	* @author Ilja 'flashader' Mickodin
	*/
	
	public class BaseSeparateTranslationEntry {
		private var _translateRequestProcessingCallback:Function;
		private var _valueChangedListener:Function;
		protected var _key:String;
		protected var _sourceValue:String = "";
		protected var _targetValue:String = "";
		
		public function ToString(isSource:Boolean):String {
			return " ".concat(_key, ': "', isSource ? _sourceValue : _targetValue, '"');
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
			isSource ? _sourceValue = value : _targetValue = value;
		}
		
		public function SetValueFromField(value:String, isSource:Boolean):void {
			var convertedValue:String = Utilities.ConvertStringToN(value);
			isSource ? _sourceValue = convertedValue : _targetValue = convertedValue;
			if (_valueChangedListener != null) {
				_valueChangedListener(this);
			}
		}
		
		public function addTranslateRequestListener(callback:Function):void {
			_translateRequestProcessingCallback = callback;
		}
		
		public function JustCopy():void { //TODO: flashader Уведомить
			SetValueFromField(GetTextFieldReadyValue(true), false);
		}
		
		public function SomeoneRequestToTranslateYou():void {
			if (_translateRequestProcessingCallback != null) {
				_translateRequestProcessingCallback(this);
			}
		}
		
		public function GetSourceToTranslate():String {
			return _sourceValue;
		}
		
		public function SetTranslatedTarget(value:String):void {
			_targetValue = value;
			if (_valueChangedListener != null) {
				_valueChangedListener(this);
			}
		}
		
		public function addValueChangedListener(callback:Function):void {
			_valueChangedListener = callback;
		}
		
		public function DisposeAllListeners():void {
			_translateRequestProcessingCallback = null;
			_valueChangedListener = null;
		}
	}
}