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
	import flash.text.TextField;
	import flash.utils.ByteArray;
	import org.aswing.*;
	import org.aswing.event.AWEvent;
	import ru.flashader.clausewitzlocalisationhelper.data.TranslationFileContent;
	import ru.flashader.clausewitzlocalisationhelper.panels.*;
	import ru.flashader.clausewitzlocalisationhelper.utils.*;
	
	/**
	* @author Ilja 'flashader' Mickodin
	*/
	
	public class ClausewitzLocalizationHelper extends Sprite {
		private static const PLEASE_WAIT:String = "Подождите примерно три секунды.";
		private static const PLEASE_PRESS:String = "Нажмите 'Ctrl'+'Shift'+'S', а потом закройте это окно\n\nИмейте в виду, функционал перевода нестабилен и зависит не от меня\nЕсли не перевелось - попробуйте ещё раз";
		private static const PLEASE_WAIT_AGAIN:String = "И ещё три секунды.";
		private static const CHOOSE_SOURCE_YAML:String = "Выберите исходный yaml файл";
		private static const SAY_CHEESE:String = "Сейчас вылетит птичка";
		private static const TOO_LONG_STRING:String = "\n\nСтрока для перевода очень длинная.\nПоэтому это окно появится ещё " + TRANSLATES_LEFT_PLACEHOLDER + " раз";
		private static const TRANSLATES_LEFT_PLACEHOLDER:String = "###TEMPLATETOCHAGE###";
		
		
		private var scrollPane:JScrollPane;
		private var _mainASWindow:JWindow;
		private var _translatingWindow:TranslationsPanel;
		private static const yamlFilters:Array = [new FileFilter("Yaml", "*.yml")];
		static public const RUSSIAN_RUSSIAN_RUSSIAN:String = "Вы загрузили файл с русской локализацией. И пытаетесь сохранить в него же" +
			"\nВы абсолютно точно уверены, что знаете, что делаете?" +
			"\n\n(В итоговый файл не будут записаны строки слева" +
			"\n только те, что справа (даже если они пустые)";
		private var _sourceValues:Object;
		private var _doFastCheck:Boolean = true;
		private var _lastLoadedfile:File = null;
		
		public function ClausewitzLocalizationHelper() {
			super();
			
			AsWingManager.setRoot(this);
			
			WebTranslator.addEventListener(WebTranslatorEvent.REQUEST_USER_INPUT, handleUserInputRequest);
			WebTranslator.addEventListener(WebTranslatorEvent.TRANSLATION_ENDED, CloseModal);
			
			_translatingWindow = new TranslationsPanel();
			_translatingWindow.addTranslateRequestListener(initiateTranslate);
			_translatingWindow.getLoadButton().addActionListener(OpenLoadDialog);
			_translatingWindow.getSaveButton().addActionListener(SaveTranslateEntries);
			
			_mainASWindow = new JWindow(this);
			_mainASWindow.setContentPane(_translatingWindow);
			_mainASWindow.setSizeWH(stage.stageWidth, stage.stageHeight);
			_mainASWindow.show();
			
			//WebTranslator.TranslateMe("We can now choose another interaction in the Federal Assembly.We can now choose another interaction in the Federal Assembly.We can now choose another interaction in the Federal Assembly.We can now choose another interaction in the Federal Assembly.We can now choose another interaction in the Federal Assembly.We can now choose another interaction in the Federal Assembly.ASDFWe can now choose another interaction in the Federal Assembly.QWERWe can now choose another interaction in the Federal Assembly.", stage);
		}
		
		private function SaveTranslateEntries(e:AWEvent):void {
			if (_lastLoadedfile == null) {
				return;
			}
			var resultFilePath:String = _lastLoadedfile.nativePath.substring(0, _lastLoadedfile.nativePath.lastIndexOf("l_english.")) + "l_russian.json";
			var resultOutputFilePath:String = resultFilePath.substring(0, resultFilePath.lastIndexOf(".")) + ".yml";
			
			if (
				resultFilePath == "l_russian.json"
			) {
				ShowModal(
					"Русский русскому русский",
					RUSSIAN_RUSSIAN_RUSSIAN,
					function(
						userChoice:int
					):void {
						if (
							(
								userChoice &
								JOptionPane.YES
							) > 0
						) {
							ShowModal(
								"Ну, как хотите",
								"На этом мои полномочия всё",
								function(
									secondUserChoice:int
								):void {
									if (
										(
											secondUserChoice &
											JOptionPane.OK
										) > 0
									) {
										resultFilePath = _lastLoadedfile.nativePath.substring(
											0,
											_lastLoadedfile.nativePath.lastIndexOf(
												"."
											)
										) + ".json";
										resultOutputFilePath = resultFilePath.substring(
											0,
											resultFilePath.lastIndexOf(
												"."
											)
										) + ".yml";
										WriteResultAndCallToParseIt(
											resultFilePath,
											resultFilePath.substring(
												0,
												resultFilePath.lastIndexOf(
													"." //Не смотри на на код такими глазами - в подобном стиле я могу писать бесконечно. И что ты мне сделаешь? Я в другом моде!
												)
											) + ".yml"
										);
									}
								},
								JOptionPane.OK
							)
						}
					},
					JOptionPane.YES | JOptionPane.NO
				);
				return;
			}
			
			var resultOutputFile:File = new File(resultOutputFilePath);
			if (resultOutputFile.exists) {
				ShowModal(
					"Файл существует",
					"Найден уже существующий файл:\n" + resultOutputFile.nativePath + "\n Перезаписываю?",
					function(userChoice:int):void {
						if ((userChoice & JOptionPane.YES) > 0) {
							WriteResultAndCallToParseIt(resultFilePath, resultOutputFilePath);
						}
					},
					JOptionPane.YES | JOptionPane.NO
				);
			} else {
				WriteResultAndCallToParseIt(resultFilePath, resultOutputFilePath);
			}
		}
		
		private function WriteResultAndCallToParseIt(resultFilePath:String, resultOutputFilePath:String):void {
			var translationResult:TranslationFileContent = _translatingWindow.CollectTranslations();
			var translationResultJSON:String = JSON.stringify(translationResult);
			
			var tempFile:File = File.createTempFile();
			var stream:FileStream = new FileStream();
			var jsonBytes:ByteArray = new ByteArray();
			
			jsonBytes.writeMultiByte(translationResultJSON, "utf-8"); //He-he-he: ยง
			stream.open(tempFile, FileMode.WRITE);
			stream.writeBytes(jsonBytes);
			stream.close();
			
			var resultFile:File = new File(resultFilePath);
			
			tempFile.moveTo(resultFile, true);
			
			CallExternalParser(
				resultFilePath,
				resultOutputFilePath,
				function(some:String):void {
					RemoveFileAtPath(resultFilePath);
					ShowModal("Поздравляю!", "Ещё один файл переведён!", EmptyFunction, JOptionPane.OK);
				},
				ShowErrorMessage
			);
		}
		
		private function OpenLoadDialog(e:AWEvent):void {
			var file:File = new File();
			file.addEventListener(Event.SELECT, fileToLoadSelectedListener);
			file.browseForOpen(CHOOSE_SOURCE_YAML, yamlFilters);
		}
		
		private function fileToLoadSelectedListener(e:Event):void {
			var file:File = e.currentTarget as File;
			var stream:FileStream = new FileStream();
			stream.open(file, FileMode.READ);
			var fileData:String = stream.readUTFBytes(stream.bytesAvailable);
			stream.close();
			var fullPath:String = file.nativePath;
			_lastLoadedfile = file;
			TryParseSource(fileData, fullPath);
		}
		
		private function TryParseSource(fileContent:String, fullPath:String):void {
			_sourceValues = new Object();
			if (false && _doFastCheck) {
				DoFastParsing(fileContent, fullPath);
			} else {
				EndParsingAndFillViews(Utilities.DoManualParsing(fileContent, fullPath));
				//var strings:Array = fileContent.replace("\\n", FLASHADER_TEMPORARY_TEMPLATE).split("\r\n");
				//for each (var str:String in strings) {
					//DoManualStringParsing(str.replace(FLASHADER_TEMPORARY_TEMPLATE, "\\n")); //TODO: flashader Скоро
				//}
			}
		}
		
		private function DoFastParsing(fullFileTextToPrecheck:String, fullPath:String):void {
			CallExternalParser(
				fullPath,
				fullPath.substring(0, fullPath.lastIndexOf(".")) + ".json",
				FastParsingCompleteHandler,
				CancelLoadingAndShowErrorMessage,
				true
			);
		}
		
		private function CancelLoadingAndShowErrorMessage(message:String):void {
			_lastLoadedfile = null;
			ShowErrorMessage(message);
		}
		
		private function FastParsingCompleteHandler(jsonText:String):void {
			EndParsingAndFillViews(new TranslationFileContent(JSON.parse(jsonText)));
		}
		
		private function EndParsingAndFillViews(content:TranslationFileContent):void {			
			_translatingWindow.FillWithSource(content, _lastLoadedfile.nativePath.replace(_lastLoadedfile.parent.nativePath + File.separator, ""));
			CloseModal();
		}
		
		private var _externalProcess:NativeProcess;
		private var _externalProcessInfo:NativeProcessStartupInfo;
		
		private function CallExternalParser(
			fullPath:String,
			fullOutPath:String,
			successHandler:Function,
			errorHandler:Function,
			doRemoveOutputFileAfterReading:Boolean = false
		):void {
			ShowModal("Подождите", SAY_CHEESE);
			if (_externalProcessInfo == null) {
				_externalProcess = new NativeProcess();
				_externalProcessInfo = new NativeProcessStartupInfo();
				_externalProcessInfo.arguments = new Vector.<String>();
				with (_externalProcessInfo) {
					executable = File.applicationDirectory.resolvePath("externals" + File.separator + "YAMLJSONConverter.exe");
					workingDirectory = File.documentsDirectory;
				};
			}
			var newArguments:Vector.<String> = new Vector.<String>();
			newArguments.push(fullPath);
			_externalProcessInfo.arguments = newArguments;
			_externalProcess.addEventListener(
				NativeProcessExitEvent.EXIT,
				function (e:NativeProcessExitEvent):void {
					e.currentTarget.removeEventListener(e.type, arguments.callee);
					switch (e.exitCode) {
						case 0:
							successHandler(ReadFileAsText(fullOutPath));
							doRemoveOutputFileAfterReading && RemoveFileAtPath(fullOutPath);
							break;
						default:
							var logPath:String = fullPath.substring(0, fullPath.lastIndexOf(".")) + ".log";
							errorHandler(ReadFileAsText(logPath));
							RemoveFileAtPath(logPath);
							break;
					}
				}
			);
			_externalProcess.start(_externalProcessInfo);
		}
		
		private function RemoveFileAtPath(pathToRemove:String):void {
			new File(pathToRemove).deleteFile();
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
		
		private static var _currentAlert:JOptionPane;
		private var _currentTranslatingCallback:Function;
		
		private function initiateTranslate(callback:Function, textToTranslate:String):void {
			ShowModal("Идёт перевод", PLEASE_WAIT);
			_currentTranslatingCallback = callback;
			WebTranslator.TranslateMe(textToTranslate, stage);
		}
		
		private function handleUserInputRequest(e:Event):void {
			var message:String = PLEASE_PRESS;
			var translatesLeft:int = WebTranslator.GetTranslatesLeft();
			if (translatesLeft > 0) {
				message = message.concat(TOO_LONG_STRING.replace(TRANSLATES_LEFT_PLACEHOLDER, translatesLeft));
			}
			ShowModal("Нужна помощь", message, continueTranslate);
		}
		
		private function continueTranslate(e:int):void {
			ShowModal("Спасибо", PLEASE_WAIT_AGAIN);
			WebTranslator.ContinueTranslate(_currentTranslatingCallback);
		}
		
		private static function ShowModal(title:String, message:String, closeHandler:Function = null, buttons:int = 0):void {
			CloseModal();
			_currentAlert = JOptionPane.showMessageDialog(title, message, closeHandler, null, true, null, buttons);
			_currentAlert.getMsgLabel().setSelectable(closeHandler != null);
			_currentAlert.getFrame().getTitleBar().getCloseButton().setVisible(closeHandler != null);
		}
		
		private function ShowErrorMessage(message:String):void {
			ShowModal("Произошла ошибка", message, EmptyFunction);
		}
		
		private static function CloseModal(e:Event = null):void {
			if (_currentAlert != null) {
				_currentAlert.getFrame().dispose();
			}
		}
		
		private function EmptyFunction(...args):void { }
		
		private static function EmergencyLog(log:String):void {
			ShowModal("Хуйня случилась", log);
			throw new Error("To prevent code completion");
		}
	}
}