package ru.flashader.clausewitzlocalisationhelper {
	import flash.desktop.NativeProcess;
	import flash.desktop.NativeProcessStartupInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.NativeProcessExitEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.FileFilter;
	import org.aswing.*;
	import org.aswing.AsWingManager;
	import org.aswing.event.AWEvent;
	
	/**
	* @author Ilja 'flashader' Mickodin
	*/
	
	public class TranslatingWindowController extends Sprite {
		private static const PLEASE_WAIT:String = "Подождите примерно три секунды.";
		private static const PLEASE_PRESS:String = "Нажмите 'Ctrl'+'Shift'+'S', а потом закройте это окно";
		private static const PLEASE_WAIT_AGAIN:String = "И ещё три секунды.";
		private static const FLASHADER_TEMPORARY_TEMPLATE:String = "###OLOLO_FLASHADER_TEMPORARY_TEMPLATE_OLOLO###";
		
		private var scrollPane:JScrollPane;
		private var _mainASWindow:JWindow;
		private var _translatingWindow:TranslationsWindow;
		private static const yamlFilters:Array = [new FileFilter("Yaml", "*.yml")];
		private var _sourceValues:Object;
		private var _doFastCheck:Boolean = true;
		private var _lastLoadedfilePath:String;
		
		public function TranslatingWindowController() {
			super();
			AsWingManager.setRoot(this);
			
			//JOptionPane.showMessageDialog("About", "This is just a menu test demo!\n\n alskdjaldjalsdkj\n\n l;jasdf;ljasdfklj \n\n a;dksfj;ladfj;ladfj").getMsgLabel().setSelectable(true);
			
			WebTranslator.addEventListener(WebTranslatorEvent.REQUEST_USER_INPUT, handleUserInputRequest);
			WebTranslator.addEventListener(WebTranslatorEvent.TRANSLATION_ENDED, CloseModal);
			
			_translatingWindow = new TranslationsWindow();
			_translatingWindow.addTranslateRequestListener(initiateTranslate);
			_translatingWindow.getLoadButton().addActionListener(OpenLoadDialog);
			
			_mainASWindow = new JWindow(this);
			_mainASWindow.setContentPane(_translatingWindow);
			_mainASWindow.setSizeWH(stage.stageWidth, stage.stageHeight);
			_mainASWindow.show();
		}
		
		private function OpenLoadDialog(e:AWEvent):void {
			var file:File = new File();
			file.addEventListener(Event.SELECT, fileToLoadSelectedListener);
			file.browseForOpen("Выберите исходный yaml файл", yamlFilters);
		}
		
		private function fileToLoadSelectedListener(e:Event):void {
			var file:File = e.currentTarget as File;
			var stream:FileStream = new FileStream();
			stream.open(file, FileMode.READ);
			
			var fileData:String = stream.readUTFBytes(stream.bytesAvailable);
			stream.close();
			var fullPath:String = file.nativePath;
			_lastLoadedfilePath = fullPath.replace(file.parent.nativePath + File.separator, "");
			TryParseSource(fileData, fullPath);
		}
		
		private function TryParseSource(fileContent:String, fullPath:String):void {
			_sourceValues = new Object();
			if (_doFastCheck) {
				ShowModal("Подождите", "Сейчас вылетит птичка");
				DoFastParsing(fileContent, fullPath);
			} else {
				var strings:Array = fileContent.replace("\\n", FLASHADER_TEMPORARY_TEMPLATE).split("\r\n");
				for each (var str:String in strings) {
					//DoManualStringParsing(str.replace(FLASHADER_TEMPORARY_TEMPLATE, "\\n")); //TODO: flashader Скоро
				}
			}
		}
		
		private function DoFastParsing(fullFileTextToPrecheck:String, fullPath:String):void {
			CallExternalParser(
				fullPath,
				fullPath.substring(0, fullPath.lastIndexOf(".")) + ".json",
				FastParsingCompleteHandler,
				ShowErrorMessage
			);
		}
		
		private function FastParsingCompleteHandler(jsonText:String):void {
			EndParsingAndFillViews(new TranslationFileContent(JSON.parse(jsonText)));
		}
		
		private function EndParsingAndFillViews(content:TranslationFileContent):void {			
			_translatingWindow.FillWithSource(content, _lastLoadedfilePath);
			CloseModal();
		}
		
		private var _externalProcess:NativeProcess;
		private var _externalProcessInfo:NativeProcessStartupInfo;
		
		private function CallExternalParser(fullPath:String, fullOutPath:String, successHandler:Function, errorHandler:Function):void {
			if (_externalProcessInfo == null) {
				_externalProcess = new NativeProcess();
				_externalProcessInfo = new NativeProcessStartupInfo();
				_externalProcessInfo.arguments = new Vector.<String>();
				with(_externalProcessInfo) {
					executable = File.applicationDirectory.resolvePath("externals" + File.separator + "YAMLJSONConverter.exe");
					workingDirectory = File.documentsDirector;
				};
			}
			 _externalProcessInfo.arguments[0] = fullPath;
			
			_externalProcess.addEventListener(
				NativeProcessExitEvent.EXIT,
				function (e:NativeProcessExitEvent):void {
					e.currentTarget.removeEventListener(e.type, arguments.callee);
					switch (e.exitCode) {
						case 0:
							successHandler(ReadFileAsText(fullOutPath));
							break;
						default:
							errorHandler(ReadFileAsText(fullPath.substring(0, fullPath.lastIndexOf(".")) + ".log"));
							break;
					}
				}
			);
			_externalProcess.start(_externalProcessInfo);
		}
		
		private function ReadFileAsText(path:String):String {
			var stream:FileStream = new FileStream();
			stream.open(new File(path), FileMode.READ);
			var toReturn:String = stream.readUTFBytes(stream.bytesAvailable);
			stream.close();
			return toReturn;
		}
		
		/**
		* Translation loop
		*/
		
		private var _currentAlert:JOptionPane;
		private var _currentTranslatingEntry:TranslateEntryPanel;
		
		private function initiateTranslate(entry:TranslateEntryPanel):void {
			ShowModal("Идёт перевод", PLEASE_WAIT);
			_currentTranslatingEntry = entry;
			WebTranslator.TranslateMe(_currentTranslatingEntry.getSourceTranslation().getText(), stage);
		}
		
		private function handleUserInputRequest(e:Event):void {
			ShowModal("Нужна помощь", PLEASE_PRESS, continueTranslate);
		}
		
		private function continueTranslate(e:int):void {
			ShowModal("Спасибо", PLEASE_WAIT_AGAIN);
			WebTranslator.ContinueTranslate(_currentTranslatingEntry.getTargetTranslation().getTextField());
		}
		
		private function ShowModal(title:String, message:String, closeHandler:Function = null):void {
			CloseModal();
			_currentAlert = JOptionPane.showMessageDialog(title, message, closeHandler, null, true, null, closeHandler != null ? JOptionPane.CLOSE : 0);
			_currentAlert.getMsgLabel().setSelectable(closeHandler != null);
			_currentAlert.getFrame().getTitleBar().getCloseButton().setVisible(closeHandler != null);
		}
		
		private function ShowErrorMessage(message:String):void {
			ShowModal("Произошла ошибка", message, EmptyFunction);
		}
		
		private function CloseModal(e:Event = null):void {
			if (_currentAlert != null) {
				_currentAlert.getFrame().dispose();
			}
		}
		
		private function EmptyFunction(...args):void { }
	}
}