package ru.flashader.clausewitzlocalisationhelper.utils {
	/**
	* @author Ilja 'flashader' Mickodin
	*/
	
	public class SplittedInput {
		private var _inputs:Vector.<String>;
		private var _currentUntranslatedIndex:int;
		private var _translatorsNeeded:int
		private var _currentTranslationIndex:Number;
		
		public function SplittedInput(input:String) {
			_inputs = new Vector.<String>();
			_translatorsNeeded = 0;
			if (input.length <= 250) { _inputs.push(input); _translatorsNeeded = 1; return; }
			var nNedInput:Array = input.split("\\n");
			for each (var slicedInput:String in nNedInput) {
				if (slicedInput.length > 250) {
					var dottedInput:Array = slicedInput.split(".");
					for each (var doubleSlicedInput:String in dottedInput) {
						_inputs.push(doubleSlicedInput);
						_inputs.push(".");
						if (doubleSlicedInput.length > 0) {
							_translatorsNeeded++;
						}
					}
					_inputs.pop();
				} else {
					_inputs.push(slicedInput);
					if (slicedInput.length > 0) {
						_translatorsNeeded++;
					}
				}
				_inputs.push("\n");
			}
			_inputs.pop();
			
			_currentUntranslatedIndex = 0;
			_currentTranslationIndex = 0;
		}
		
		public function GetNextSplittedInput():String {
			if (_inputs.length < (_currentTranslationIndex * 2)) {
				return null;
			}
			var toReturn:String = _inputs[_currentTranslationIndex * 2];
			_currentTranslationIndex++;
			if (toReturn.length == 0) {
				return GetNextSplittedInput();
			}
			return toReturn;
		}
		
		public function SetCurrentTranslate(currentTranslate:String):void {
			_inputs[_currentUntranslatedIndex * 2] = currentTranslate;
			_currentUntranslatedIndex++;
		}
		
		public function CollectString():String {
			var toReturn:String = "";
			for each(var input:String in _inputs) {
				toReturn = toReturn.concat(input);
			}
			return toReturn;
		}
		
		public function GetTranslatorsNeeded():int {
			return _translatorsNeeded;
		}
		
		public function ResetCounter():void {
			_currentTranslationIndex = 1;
		}
	}
}