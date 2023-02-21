package ru.flashader.clausewitzlocalisationhelper.data {
	
	import ru.flashader.clausewitzlocalisationhelper.data.errors.ForbiddenCharacterError;
	import ru.flashader.clausewitzlocalisationhelper.data.errors.YMLStringError;
	import ru.flashader.clausewitzlocalisationhelper.utils.Parsers;
	//import ru.flashader.clausewitzlocalisationhelper.utils.EUUtils;

	/**
	* @author Ilja 'flashader' Mickodin
	*/
	
	public class RichSeparateTranslationEntry extends BaseSeparateTranslationEntry {
		public var Version:Number = Number.NaN;
		public var Comment:String;
		public var Raw:String;
		public var isEmpty:Boolean;
		public var SourceTaggedRegions:Vector.<TaggedRegion> = new Vector.<TaggedRegion>();
		public var TargetTaggedRegions:Vector.<TaggedRegion> = new Vector.<TaggedRegion>();
		
		private var _sourceErrors:Vector.<YMLStringError> = new Vector.<YMLStringError>();
		private var _targetErrors:Vector.<YMLStringError> = new Vector.<YMLStringError>();
		private var _replacingStringParts:Vector.<ReplacedStringPart> = new Vector.<ReplacedStringPart>();
		
		override public function ToString(isSource:Boolean):String {
			return " ".concat(
				_key,
				":",
				isNaN(Version) ?
					' "' :
					Version + ' "',
				isSource ?
					_sourceValue :
					//_isFuckingGEKS ?
						//EUUtils.ConvertStringToEUCorr(_targetValue) :
						_targetValue,
				'"'
			);
		}
		
		public function GetErrors(isSource:Boolean):Vector.<YMLStringError> { //Инкапсуляция тут нафигачена исключительно в целях рефакторинга - чтобы не пропустить ни одного места, где использовались ошибки.
			return isSource ? _sourceErrors.concat() : _targetErrors.concat();
		}
		
		public function GetErrorsLength(isSource:Boolean):int {
			return isSource ? _sourceErrors.length : _targetErrors.length;
		}
		
		public function AddError(error:YMLStringError, isSource:Boolean):void {
			isSource ? _sourceErrors.push(error) : _targetErrors.push(error);
		}
		
		public function ClearErrors(isSource:Boolean) {
			isSource ? _sourceErrors.length = 0 : _targetErrors.length = 0;
		}
		
		public function RemoveErrorAt(errorIdx:int, isSource:Boolean):void {
			isSource ? _sourceErrors.removeAt(errorIdx) : _targetErrors.removeAt(errorIdx);
		}
		
		public function GetValueToParse(isSource:Boolean):String {
			return isSource ? _sourceValue : _targetValue;
		}
		
		override public function JustCopy():void {
			super.JustCopy();
			Parsers.ParseTargetTags(this);
		}
		
		override public function GetSourceToTranslate():String {
			Parsers.ParseSourceTags(this);
			var toReturn:String = super.GetSourceToTranslate();
			_replacingStringParts.length = 0;
			var i:int;
			for (i = 0; i < SourceTaggedRegions.length; i++) {
				var region:TaggedRegion = SourceTaggedRegions[i];
				_replacingStringParts.push(
					new ReplacedStringPart(region, region.RegionEndIndex, region.NonTranslatableEnd)
				);
				_replacingStringParts.push(
					new ReplacedStringPart(region, region.RegionStartIndex, region.NonTranslatableStart)
				);
			}
			_replacingStringParts.sort(ReplacedStringPart.SortingByIndexes);
			for (i = _replacingStringParts.length - 1; i >= 0; i--) {
				var rsp:ReplacedStringPart = _replacingStringParts[i];
				toReturn = rsp.ReplaceWithTemporaryData(toReturn, '<div>'.concat(i).concat('</div>'));
			}
			return toReturn;
		}
		
		override public function SetTranslatedTarget(value:String):void {
			value = value.replace(/&gt;/g, '>');
			value = value.replace(/&lt;/g, '<');
			value = value.replace(/< div>/g, '<div>');
			value = value.replace(/<d iv>/g, '<div>');
			value = value.replace(/<di v>/g, '<div>');
			value = value.replace(/<div >/g, '<div>');
			value = value.replace(/<div> /g, '<div>');
			
			value = value.replace(/ <\/div>/g, '</div>');
			value = value.replace(/< \/div>/g, '</div>');
			value = value.replace(/<\/ div>/g, '</div>');
			value = value.replace(/<\/d iv>/g, '</div>');
			value = value.replace(/<\/di v>/g, '</div>');
			value = value.replace(/<\/div >/g, '</div>');
			value = value.replace(/<\/div> >/g, '</div>');
			
			for (var i:int = _replacingStringParts.length - 1; i >= 0; i--) {
				var rsp:ReplacedStringPart = _replacingStringParts[i];
				value = value.replace(rsp.TemporaryString, rsp.ReplacingString);
			}
			super.SetTranslatedTarget(value);
			Parsers.ParseTargetTags(this);
		}
	}
}
