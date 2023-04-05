package ru.flashader.clausewitzlocalisationhelper.data {
	
	import ru.flashader.clausewitzlocalisationhelper.data.errors.ForbiddenCharacterError;
	import ru.flashader.clausewitzlocalisationhelper.data.errors.YMLStringError;
	import ru.flashader.clausewitzlocalisationhelper.utils.Parsers;
	//import ru.flashader.clausewitzlocalisationhelper.utils.EUUtils;

	/**
	* @author Ilja 'flashader' Mickodin
	*/
	
	public class RichSeparateTranslationEntry extends BaseSeparateTranslationEntry {
		private var _sourceVersion:Number = Number.NaN;
		private var _targetVersion:Number = Number.NaN;
		private var _sourceComment:String;
		private var _targetComment:String; //TODO: flashader Кажется, коммент лучше оставить ровно один
		private var _sourceRawLine:String;
		private var _targetRawLine:String;
		public var isEmpty:Boolean;
		private var _sourceTaggedRegions:Vector.<TaggedRegion> = new Vector.<TaggedRegion>();
		private var _targetTaggedRegions:Vector.<TaggedRegion> = new Vector.<TaggedRegion>();
		
		private var _sourceErrors:Vector.<YMLStringError> = new Vector.<YMLStringError>();
		private var _targetErrors:Vector.<YMLStringError> = new Vector.<YMLStringError>();
		private var _sourceReplacingStringParts:Vector.<ReplacedStringPart> = new Vector.<ReplacedStringPart>();
		private var _targetReplacingStringParts:Vector.<ReplacedStringPart> = new Vector.<ReplacedStringPart>();
		
		override public function Merge(entry:BaseSeparateTranslationEntry, isSource:Boolean):void {
			super.Merge(entry, isSource);
			var richEntry:RichSeparateTranslationEntry = entry as RichSeparateTranslationEntry;
			if (richEntry != null) {
				SetVersion(richEntry.GetVersion(isSource), isSource);
				SetComment(richEntry.GetComment(isSource), isSource);
				SetRawLine(richEntry.GetRawLine(isSource), isSource);
				
				var i:int = 0;
				var taggedRegions:Vector.<TaggedRegion> = isSource ? richEntry._sourceTaggedRegions : richEntry._targetTaggedRegions;
				for (i = 0; i < taggedRegions.length; i++) {
					var taggedRegion:TaggedRegion = taggedRegions[i].Clone();
					isSource ? _sourceTaggedRegions.push(taggedRegion) : _targetTaggedRegions.push(taggedRegion);
				}
				
				var errors:Vector.<YMLStringError> = isSource ? richEntry._sourceErrors : richEntry._targetErrors;
				for (i = 0; i < errors.length; i++) {
					var error:YMLStringError = errors[i].Clone();
					isSource ? _sourceErrors.push(error) : _targetErrors.push(error);
				}
				
				var replacingParts:Vector.<ReplacedStringPart> = isSource ? richEntry._sourceReplacingStringParts : richEntry._targetReplacingStringParts;
				for (i = 0; i < replacingParts.length; i++) {
					var replacingPart:ReplacedStringPart = replacingParts[i].Clone();
					isSource ? _sourceReplacingStringParts.push(replacingPart) : _targetReplacingStringParts.push(replacingPart);
				}
			}
		}
		
		public function SetVersion(value:Number, isSource:Boolean):void {
			isSource ? _sourceVersion = value : _targetVersion = value;
		}
		
		public function SetComment(value:String, isSource:Boolean):void {
			isSource ? _sourceComment = value: _targetComment = value;
		}
		
		public function SetRawLine(value:String, isSource:Boolean):void {
			isSource ? _sourceRawLine = value: _targetRawLine = value;
		}
		
		private function GetVersion(isSource:Boolean):Number {
			return isSource ? _sourceVersion : _targetVersion;
		}
		
		private function GetComment(isSource:Boolean):String {
			return isSource ? _sourceComment : _targetComment;
		}
		
		private function GetRawLine(isSource:Boolean):String {
			return isSource ? _sourceRawLine : _targetRawLine;
		}
		
		override public function ToString(isSource:Boolean):String {
			return " ".concat(
				_key,
				":",
				isNaN(GetVersion(isSource)) ?
					' "' :
					GetVersion(isSource) + ' "',
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
		
		public function CleanTaggedRegions(isSource:Boolean):void {
			isSource ? _sourceTaggedRegions.length = 0 : _targetTaggedRegions.length = 0;
		}
		
		public function ClearErrors(isSource:Boolean):void {
			isSource ? _sourceErrors.length = 0 : _targetErrors.length = 0;
		}
		
		public function RemoveErrorAt(errorIdx:int, isSource:Boolean):void {
			isSource ? _sourceErrors.removeAt(errorIdx) : _targetErrors.removeAt(errorIdx);
		}
		
		public function GetValueToParse(isSource:Boolean):String {
			return isSource ? _sourceValue : _targetValue;
		}
		
		public function GetTaggedRegions(isSource:Boolean):Vector.<TaggedRegion> {
			return isSource ? _sourceTaggedRegions : _targetTaggedRegions;
		}
		
		override public function JustCopyTo(isSource:Boolean):void {
			SetVersion(!isSource ? _sourceVersion : _targetVersion, isSource);
			SetComment(!isSource ? _sourceComment : _targetComment, isSource);
			SetRawLine(!isSource ? _sourceRawLine : _targetRawLine, isSource);
			isSource ? _sourceTaggedRegions = _targetTaggedRegions : _targetTaggedRegions = _sourceTaggedRegions;
			isSource ? _sourceErrors = _targetErrors : _targetErrors = _sourceErrors;
			isSource ? _sourceReplacingStringParts = _targetReplacingStringParts : _targetReplacingStringParts = _sourceReplacingStringParts;
			super.JustCopyTo(isSource);
		}
		
		override public function GetValueToTranslate(isSource:Boolean):String {
			Parsers.ParseTags(this, isSource);
			var toReturn:String = super.GetValueToTranslate(isSource);
			var replacingStringParts:Vector.<ReplacedStringPart> = isSource ? _sourceReplacingStringParts : _targetReplacingStringParts;
			replacingStringParts.length = 0;
			var i:int;
			var taggedRegions:Vector.<TaggedRegion> = isSource ? _sourceTaggedRegions : _targetTaggedRegions;
			for (i = 0; i < taggedRegions.length; i++) {
				var region:TaggedRegion = taggedRegions[i];
				replacingStringParts.push(
					new ReplacedStringPart(region, region.RegionEndIndex, region.NonTranslatableEnd)
				);
				replacingStringParts.push(
					new ReplacedStringPart(region, region.RegionStartIndex, region.NonTranslatableStart)
				);
			}
			replacingStringParts.sort(ReplacedStringPart.SortingByIndexes);
			for (i = replacingStringParts.length - 1; i >= 0; i--) {
				var rsp:ReplacedStringPart = replacingStringParts[i];
				toReturn = rsp.ReplaceWithTemporaryData(toReturn, '<div>'.concat(i).concat('</div>'));
			}
			return toReturn;
		}
		
		override public function SetTranslatedValue(value:String, isSource:Boolean):void {
			value = value.replace(/&gt;/g, '>');
			value = value.replace(/&lt;/g, '<');
			
			value = value.replace(/<дел> /g, '<div>');
			value = value.replace(/<дел>/g, '<div>');
			value = value.replace(/< дел>/g, '<div>');
			value = value.replace(/<д ел>/g, '<div>');
			value = value.replace(/<де л>/g, '<div>');
			value = value.replace(/<дел >/g, '<div>');
			
			value = value.replace(/ <\/дел>/g, '</div>');
			value = value.replace(/<\/дел>/g, '</div>');
			value = value.replace(/< \/дел>/g, '</div>');
			value = value.replace(/<\/ дел>/g, '</div>');
			value = value.replace(/<\/д ел>/g, '</div>');
			value = value.replace(/<\/де л>/g, '</div>');
			value = value.replace(/<\/дел >/g, '</div>');
			value = value.replace(/<\/дел> >/g, '</div>');
			
			value = value.replace(/<раздел> /g, '<div>');
			value = value.replace(/<раздел>/g, '<div>');
			value = value.replace(/< раздел>/g, '<div>');
			value = value.replace(/<р аздел>/g, '<div>');
			value = value.replace(/<ра здел>/g, '<div>');
			value = value.replace(/<раз дел>/g, '<div>');
			value = value.replace(/<разд ел>/g, '<div>');
			value = value.replace(/<разде л>/g, '<div>');
			value = value.replace(/<раздел >/g, '<div>');
			
			value = value.replace(/ <\/раздел>/g, '</div>');
			value = value.replace(/<\/раздел>/g, '</div>');
			value = value.replace(/< \/раздел>/g, '</div>');
			value = value.replace(/<\/ раздел>/g, '</div>');
			value = value.replace(/<\/р аздел>/g, '</div>');
			value = value.replace(/<\/ра здел>/g, '</div>');
			value = value.replace(/<\/раз дел>/g, '</div>');
			value = value.replace(/<\/разд ел>/g, '</div>');
			value = value.replace(/<\/разде л>/g, '</div>');
			value = value.replace(/<\/раздел >/g, '</div>');
			value = value.replace(/<\/раздел> >/g, '</div>');
			
			
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
			
			
			var replacingStringParts:Vector.<ReplacedStringPart> = !isSource ? _sourceReplacingStringParts : _targetReplacingStringParts;
			
			for (var i:int = replacingStringParts.length - 1; i >= 0; i--) {
				var rsp:ReplacedStringPart = replacingStringParts[i];
				value = value.replace(rsp.TemporaryString, rsp.ReplacingString);
			}
			super.SetTranslatedValue(value, isSource);
			Parsers.ParseTags(this, isSource);
		}
		
		override public function IsKeyed():Boolean {
			return super.IsKeyed() && !isEmpty;
		}
		
		public static function DeepCloneFrom(original:RichSeparateTranslationEntry):RichSeparateTranslationEntry { //TODO: flashader Похуй уже, я заебался рефакторить. Если что-то вдруг сломается или не склонится - потом починим.
			var clone:RichSeparateTranslationEntry = new RichSeparateTranslationEntry();
			clone.Merge(original, true);
			clone.Merge(original, false);
			clone._key = original._key;
			clone.isEmpty = original.isEmpty;
			return clone;
		}
	}
}
