package ru.flashader.clausewitzlocalisationhelper.utils {
	import flash.events.Event;
	import flash.utils.Dictionary;
	import org.aswing.JTextArea;
	import ru.flashader.clausewitzlocalisationhelper.data.BaseSeparateTranslationEntry;

	/**
	* @author Ilja 'flashader' Mickodin
	*/
	
	public class EntryToTextfieldsBinderMediator {
		private static var _entryToTableRowsArraysDictionary:Dictionary = new Dictionary(true);
		private static var _entryToTableCallbacksArraysDictionary:Dictionary = new Dictionary(true);
		private static var _tableRowToEntryDictionary:Dictionary = new Dictionary(true);
		private static var _entryToFieldsArraysDictionary:Dictionary = new Dictionary(true);
		private static var _sourceFieldsToEntryDictionary:Dictionary = new Dictionary(true);
		private static var _targetFieldsToEntryDictionary:Dictionary = new Dictionary(true);
		
		public static function BindTableRowArray(entry:BaseSeparateTranslationEntry, tableRowArray:Array, additionalTableCallback:Function):void {
			var entryToTableRowsArray:Array = _entryToTableRowsArraysDictionary[entry];
			if (entryToTableRowsArray == null) {
				entryToTableRowsArray = [];
				_entryToTableRowsArraysDictionary[entry] = entryToTableRowsArray;
			}
			var entryToTableCallbacksArray:Array = _entryToTableCallbacksArraysDictionary[entry];
			if (entryToTableCallbacksArray == null) {
				entryToTableCallbacksArray = [];
				_entryToTableCallbacksArraysDictionary[entry] = entryToTableCallbacksArray;
			}
			entryToTableRowsArray.push(tableRowArray);
			entryToTableCallbacksArray.push(additionalTableCallback);
			_tableRowToEntryDictionary[tableRowArray] = entry;
			
			entry.addValueChangedListener(EntryChangedHandler);
		}
		
		public static function UnbindTableRowArray(tableRowArray:Array, additionalTableCallback:Function):void { //TODO: flashader Хочу спать, пишу копипастом, возможны утечки памяти.
			var entry:BaseSeparateTranslationEntry = _tableRowToEntryDictionary[tableRowArray];
			var i:int = 0;
			var idxToDrop:int = -1;
			
			var tableRows:Array = _entryToTableRowsArraysDictionary[entry];
			if (tableRows != null) {
				for (i = 0; i < tableRows.length; i++) {
					if (tableRows[i] == tableRowArray) {
						idxToDrop = i;
						break;
					}
				}
				if (idxToDrop > -1) {
					tableRows.removeAt(idxToDrop);
				}
			}
			
			var tableCallbacks:Array = _entryToTableCallbacksArraysDictionary[entry];
			if (tableCallbacks != null) {
				for (i = 0; i < tableCallbacks.length; i++) {
					if (tableCallbacks[i] == additionalTableCallback) {
						idxToDrop = i;
						break;
					}
				}
				if (idxToDrop > -1) {
					tableCallbacks.removeAt(idxToDrop);
				}
			}
			
			_tableRowToEntryDictionary[tableRowArray] = null;
		}		
		
		public static function BindFields(entry:BaseSeparateTranslationEntry, sourceField:JTextArea, targetField:JTextArea):void {
			var entryToFieldsArray:Array = _entryToFieldsArraysDictionary[entry];
			if (entryToFieldsArray == null) {
				entryToFieldsArray = [];
				_entryToFieldsArraysDictionary[entry] = entryToFieldsArray;
			}
			entryToFieldsArray.push({ source: sourceField, target: targetField });
			
			_sourceFieldsToEntryDictionary[sourceField] = entry;
			_targetFieldsToEntryDictionary[targetField] = entry;
			
			sourceField.removeEventListener(Event.CHANGE, SourceFieldChangedHandler);
			sourceField.addEventListener(Event.CHANGE, SourceFieldChangedHandler);
			targetField.removeEventListener(Event.CHANGE, TargetFieldChangedHandler);
			targetField.addEventListener(Event.CHANGE, TargetFieldChangedHandler);
			
			entry.addValueChangedListener(EntryChangedHandler);
		}
		
		public static function UnbindFields(sourceField:JTextArea, targetField:JTextArea):void {
			var sourceEntry:BaseSeparateTranslationEntry = _sourceFieldsToEntryDictionary[sourceField];
			var targetEntry:BaseSeparateTranslationEntry = _targetFieldsToEntryDictionary[targetField];
			var i:int = 0;
			var idxToDrop:int = -1;
			var fieldsObject:Object
			
			var sourceArray:Array = _entryToFieldsArraysDictionary[sourceEntry];
			if (sourceArray != null) {
				for (i = 0; i < sourceArray.length; i++) {
					fieldsObject = sourceArray[i];
					if (fieldsObject["source"] == sourceField) {
						fieldsObject["source"] = null;
						if (fieldsObject["target"] == null) {
							idxToDrop = i;
						}
						break;
					}
				}
				if (idxToDrop > -1) {
					sourceArray.removeAt(idxToDrop);
				}
			}
			idxToDrop = -1;
			var targetArray:Array = _entryToFieldsArraysDictionary[targetEntry];
			if (targetArray != null) {
				for (i = 0; i < targetArray.length; i++) {
					fieldsObject = targetArray[i];
					if (fieldsObject["target"] == targetField) {
						fieldsObject["target"] = null;
						if (fieldsObject["source"] == null) {
							idxToDrop = i;
						}
						break;
					}
				}
				if (idxToDrop > -1) {
					targetArray.removeAt(idxToDrop);
				}
			}
			
			_sourceFieldsToEntryDictionary[sourceField] = null;
			_targetFieldsToEntryDictionary[targetField] = null;
		}
		
		public static function UnbindAllFromEntry(entry:BaseSeparateTranslationEntry):void {
			for each (var tableRowsArray:Array in _entryToTableRowsArraysDictionary) {
				tableRowsArray.length = 0;
			}
			_entryToTableRowsArraysDictionary = new Dictionary(true);
			for each (var tableCallbacksArray:Array in _entryToTableCallbacksArraysDictionary) {
				tableCallbacksArray.length = 0;
			}
			_entryToTableCallbacksArraysDictionary = new Dictionary(true);
			_tableRowToEntryDictionary = new Dictionary(true);
			
			for each (var entryToFieldsArray:Array in _entryToFieldsArraysDictionary) {
				entryToFieldsArray["source"] = null;
				entryToFieldsArray["target"] = null;
				entryToFieldsArray.length = 0;
			}
			_entryToFieldsArraysDictionary = new Dictionary(true);
			_sourceFieldsToEntryDictionary = new Dictionary(true);
			_targetFieldsToEntryDictionary = new Dictionary(true);
		}
		
		private static function SourceFieldChangedHandler(e:Event):void {
			var area:JTextArea = e.currentTarget as JTextArea;
			var entry:BaseSeparateTranslationEntry = _sourceFieldsToEntryDictionary[area];
			if (entry == null) { return; }
			entry.SetValueFromField(area.getText(), true);
		}
		
		private static function TargetFieldChangedHandler(e:Event):void {
			var area:JTextArea = e.currentTarget as JTextArea;
			var entry:BaseSeparateTranslationEntry = _targetFieldsToEntryDictionary[area];
			if (entry == null) { return; }
			entry.SetValueFromField(area.getText(), false);
		}
		
		private static function EntryChangedHandler(entry:BaseSeparateTranslationEntry):void {
			var textFieldsBindersArray:Array = _entryToFieldsArraysDictionary[entry];
			if (textFieldsBindersArray != null) {
				for each (var fieldsObject:Object in textFieldsBindersArray) {
					var sourceField:JTextArea = fieldsObject["source"];
					var targetField:JTextArea = fieldsObject["target"];
					if (sourceField != null) {
						sourceField.setText(entry.GetTextFieldReadyValue(true));
					}
					if (targetField != null) {
						targetField.setText(entry.GetTextFieldReadyValue(false));
					}
				}
			}
			var bindedTableRowsArray:Array = _entryToTableRowsArraysDictionary[entry];
			if (bindedTableRowsArray != null) {
				var newTableArray:Array = entry.ToTableArray();
				for each (var bindedTableRowArray:Object in bindedTableRowsArray) {
					bindedTableRowArray.length = 0;
					for each (var tableString:String in newTableArray) {
						bindedTableRowArray.push(tableString);
					}
				}
			}
			var bindedTableCallbacksArray:Array = _entryToTableCallbacksArraysDictionary[entry]
			if (bindedTableCallbacksArray != null) {
				for each (var bindedTableCallback:Function in bindedTableCallbacksArray) {
					if (bindedTableCallback != null) {
						bindedTableCallback();
					}
				}
			}
		}
	}
}