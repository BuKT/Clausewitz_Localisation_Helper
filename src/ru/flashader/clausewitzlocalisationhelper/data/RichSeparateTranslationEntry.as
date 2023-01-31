package ru.flashader.clausewitzlocalisationhelper.data {
	
	import ru.flashader.clausewitzlocalisationhelper.data.errors.ForbiddenCharacterError;
	import ru.flashader.clausewitzlocalisationhelper.data.errors.YMLStringError;
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
		
		public function RemoveErrorAt(errorIdx:int, isSource:Boolean):void {
			isSource ? _sourceErrors.removeAt(errorIdx) : _targetErrors.removeAt(errorIdx);
		}
		
		public function GetValueToParse(isSource:Boolean):String {
			return isSource ? _sourceValue : _targetValue;
		}
	}
}