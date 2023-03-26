package ru.flashader.clausewitzlocalisationhelper.utils {
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.FileFilter;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.utils.ByteArray;
	import org.aswing.JOptionPane;
	
	/**
	* @author Ilja 'flashader' Mickodin
	*/
	
	public class FileOperations {
		public static const SOURCE_PATH_POSTFIX:String = "_l_english.yml";
		public static const TARGET_PATH_POSTFIX:String = "_l_russian.yml";
		
		private static const yamlFilters:Array = [new FileFilter("Yaml", "*.yml")];
		private static var _lastLoadedSourceFile:File = null;
		private static var _lastLoadedTargetFile:File = null;
		private static var _isSourceLoading:Boolean;
		private static var _lastLoadFileCallback:Function;
		
		public static function CheckExistanceAndWriteToOutputFilePath(isSource:Boolean, serialized:String):void {
			var outputFilePath:String = GetAnyFullFilePath(isSource);
			var outputFile:File = new File(outputFilePath);
			if (outputFile.exists) {
				Modals.ShowModal(
					LocalisationStrings.FILE_ALREADY_EXISTS,
					LocalisationStrings.SHOULD_WE_REWRITE_EXISTING_FILE.replace(LocalisationStrings.TEMPLATE_TO_CHANGE, outputFile.nativePath),
					function(userChoice:int):void {
						if ((userChoice & JOptionPane.YES) > 0) {
							FileOperations.WriteYamlToFile(outputFilePath, serialized);
						}
					},
					JOptionPane.YES | JOptionPane.NO
				);
			} else {
				FileOperations.WriteYamlToFile(outputFilePath, serialized);
			}
		}
		
		public static function WriteYamlToFile(targetPath:String, content:String):void {
			var tempFile:File = File.createTempFile();
			var stream:FileStream = new FileStream();
			var jsonBytes:ByteArray = new ByteArray();
			
			jsonBytes.writeMultiByte(content, "utf-8"); //He-he-he: ยง
			stream.open(tempFile, FileMode.WRITE);
			stream.writeBytes(jsonBytes);
			stream.close();
			
			var resultOutFile:File = new File(targetPath);
			
			tempFile.moveTo(resultOutFile, true);
			
			Modals.ShowModal(
				LocalisationStrings.CONGRATULATIONS,
				LocalisationStrings.ONE_MORE_FILE_TRANSLATED,
				function(userChoice:int):void {
					if ((userChoice & JOptionPane.YES) > 0) {
						navigateToURL(new URLRequest(resultOutFile.nativePath));
					}
				},
				JOptionPane.YES | JOptionPane.NO
			);
		}
		
		public static function LoadFileDialog(isSource:Boolean, callback:Function):void {
			_lastLoadFileCallback = callback;
			_isSourceLoading = isSource;
			var file:File = new File();
			file.addEventListener(Event.SELECT, fileToLoadSelectedListener);
			file.browseForOpen(LocalisationStrings.CHOOSE_SOURCE_YAML, yamlFilters);
		}
		
		private static function fileToLoadSelectedListener(e:Event):void {
			var file:File = e.currentTarget as File;
			var stream:FileStream = new FileStream();
			stream.open(file, FileMode.READ);
			var fileData:String = stream.readUTFBytes(stream.bytesAvailable);
			stream.close();
			var fullPath:String = file.nativePath;
			if (_isSourceLoading) {
				_lastLoadedSourceFile = file;
			} else {
				_lastLoadedTargetFile = file;
			}
			
			_lastLoadFileCallback(fileData, GetFilename(GetLastLoadedFile(_isSourceLoading)), _isSourceLoading);
		}
		
		public static function GetLastLoadedFile(isSource:Boolean):File {
			return isSource ? _lastLoadedSourceFile : _lastLoadedTargetFile;
		}
		
		public static function GetFilename(file:File):String {
			return file.nativePath.replace(file.parent.nativePath + File.separator, "");
		}
		
		public static function GetAnyFullFilePath(isSourcePrefferable:Boolean):String {
			var lastLoadedFile:File = GetLastLoadedFile(isSourcePrefferable);
			if (lastLoadedFile == null) {
				lastLoadedFile = GetLastLoadedFile(!isSourcePrefferable);
			}
			var toReturn:String = lastLoadedFile.nativePath;
			return toReturn.substring(0, toReturn.lastIndexOf("_l_")) + (isSourcePrefferable ? SOURCE_PATH_POSTFIX : TARGET_PATH_POSTFIX);
		}
	}
}