package ru.flashader.clausewitzlocalisationhelper {
	import flash.display.Sprite;
	import flash.events.Event;
	import org.aswing.*;
	import org.aswing.event.AWEvent;
	import ru.flashader.clausewitzlocalisationhelper.data.TranslationFileContent;
	import ru.flashader.clausewitzlocalisationhelper.panels.*;
	import ru.flashader.clausewitzlocalisationhelper.utils.*;
	
	/**
	* @author Ilja 'flashader' Mickodin
	*/
	
	public class ClausewitzLocalizationHelper extends Sprite {
		private var scrollPane:JScrollPane;
		private var _mainASWindow:JWindow;
		private var _translatingWindow:TranslationsPanel;
		private var _translationFileContent:TranslationFileContent;
		private var _doFastCheck:Boolean = true;
		private var _translatesLeft:int = 0;
		private var _translatesFailed:int = 0;
		
		public function ClausewitzLocalizationHelper() {
			super();
			
			AsWingManager.setRoot(this);
			
			WebTranslator.addEventListener(WebTranslatorEvent.REQUEST_USER_INPUT, handleUserInputRequest);
			WebTranslator.addEventListener(WebTranslatorEvent.TRANSLATION_ENDED, TranslationEndedListener);
			WebTranslator.addEventListener(WebTranslatorEvent.TRANSLATION_FAILED, TranslationFailedListener);
			TranslationFileContent.addTranslateRequestListener(initiateTranslate);
			
			_translatingWindow = new TranslationsPanel();
			_translatingWindow.getLoadButton().addActionListener(OpenSourceLoadDialog);
			_translatingWindow.getSaveButton().addActionListener(SaveTranslateTargetEntries);
			
			_mainASWindow = new JWindow(this);
			_mainASWindow.setContentPane(_translatingWindow);
			_mainASWindow.setSizeWH(stage.stageWidth, stage.stageHeight);
			_mainASWindow.show();
		}
		
		private function SaveTranslateTargetEntries(e:AWEvent):void {
			if (FileOperations.GetLastLoadedFile(true) == null) {
				return;
			}
			if (FileOperations.CreateOppositeTranslationsFilePath(true) == "l_russian.yml") {
				ShowFirstWarningAboutSameTranslationSaving(false);
				return;
			}
			SaveTranslateFile(false);
		}
		
		private function SaveTranslateFile(isSource:Boolean):void {
			FileOperations.CheckExistanceAndWriteToOutputFilePath(isSource, _translationFileContent.ToYAML(isSource));
		}
		
		private var _isSourceFileSavingWarningsLoop:Boolean;
		
		private function ShowFirstWarningAboutSameTranslationSaving(isSourceFileSavingWarningsLoop:Boolean):void {
			_isSourceFileSavingWarningsLoop = isSourceFileSavingWarningsLoop;
			Modals.ShowModal(LocalisationStrings.RUSSIAN_RUSSIAN_RUSSIAN_LABEL, LocalisationStrings.RUSSIAN_RUSSIAN_RUSSIAN_DESCRIPTION, CheckIfHeIgnoredFirstWarningAboutSameTranslationSaving, JOptionPane.YES | JOptionPane.NO);
		}
		
		private function CheckIfHeIgnoredFirstWarningAboutSameTranslationSaving(userChoice:int):void {
			if ((userChoice & JOptionPane.YES) > 0) {
				ShowSecondWarningAboutSameTranslationSaving();
			}
		}
		
		private function ShowSecondWarningAboutSameTranslationSaving():void {
			Modals.ShowModal(LocalisationStrings.AS_YOUR_WISH, LocalisationStrings.I_RECALL_MY_QUESTIONS, CheckIfHeIgnoredSecondWarningAboutSameTranslationSaving, JOptionPane.OK);
		}
		
		private function CheckIfHeIgnoredSecondWarningAboutSameTranslationSaving(secondUserChoice:int):void {
			if ((secondUserChoice & JOptionPane.OK) > 0) {
				FileOperations.WriteYamlToFile(FileOperations.GetLastLoadedFile(!_isSourceFileSavingWarningsLoop).nativePath, _translationFileContent.ToYAML(_isSourceFileSavingWarningsLoop)); //Тут до рефакторинга было шедевральное: "Не смотри на код такими глазами - в подобном стиле я могу писать бесконечно. И что ты мне сделаешь? Я в другом моде!"
			}
		}
		
		private function OpenSourceLoadDialog(e:AWEvent):void {
			FileOperations.LoadFileDialog(true, TryParseLoadedFile);
		}
		
		private function TryParseLoadedFile(fileContent:String, filename:String, isSource:Boolean):void {
			_translationFileContent = TranslationFileContent.Obtain(isSource);
			Modals.ShowModal(LocalisationStrings.PLEASE_WAIT, LocalisationStrings.TRYING_TO_PARSE);
			Parsers.DoParseAndFill(fileContent, _translationFileContent, isSource);
			_translatingWindow.FillWithTranslations(_translationFileContent, filename);
			Modals.CloseModal();
		}
		
		/**
		* Translation loop
		*/
		
		private function initiateTranslate(callback:Function, textToTranslate:String):void {
			_translatesLeft++;
			ShowTranslationIsInProgressModal();
			WebTranslator.TranslateMe(textToTranslate, stage, callback);
		}
		
		private function TranslationEndedListener(e:WebTranslatorEvent):void {
			_translatesLeft--;
			if (_translatesLeft > 0) {
				ShowTranslationIsInProgressModal();
			} else {
				EndTranslationCycle();
			}
		}
		
		private function TranslationFailedListener(e:WebTranslatorEvent):void {
			_translatesLeft--;
			_translatesFailed++;
			if (_translatesLeft > 0) {
				ShowTranslationIsInProgressModal();
			} else {
				EndTranslationCycle();
			}
		}
		
		private function EndTranslationCycle():void {
			_translatesLeft = 0;
			if (_translatesFailed > 0) {
				ShowTranslationFailedSomehow();
			} else {
				Modals.CloseModal();
			}
			_translatesFailed = 0;
		}
		
		private function ShowTranslationFailedSomehow():void {
			Modals.ShowModal(
				LocalisationStrings.LISTEN_HERE_YOU_LITTLE_SHIT,
				LocalisationStrings.TOO_FAILED_STRINGS.replace(LocalisationStrings.TEMPLATE_TO_CHANGE, _translatesFailed),
				function(userChoice:int):void {
					if ((userChoice & JOptionPane.YES) > 0) {
						WebTranslator.NavigateHimToCaptcha();
					}
					Modals.CloseModal();
				},
				JOptionPane.YES | JOptionPane.NO
			);
		}
		
		private function ShowTranslationIsInProgressModal():void {
			Modals.ShowModal(LocalisationStrings.TRANSLATING_IN_PROGRESS, LocalisationStrings.PLEASE_WAIT.concat(_translatesLeft > 0 ? LocalisationStrings.TOO_MANY_STRINGS.replace(LocalisationStrings.TEMPLATE_TO_CHANGE, _translatesLeft) : ""));
		}
		
		private function handleUserInputRequest(e:Event):void {
			var message:String = LocalisationStrings.PLEASE_PRESS;
			var translatesLeft:int = WebTranslator.GetTranslatesLeft();
			if (translatesLeft > 0) {
				message = message.concat(LocalisationStrings.TOO_LONG_STRING.replace(LocalisationStrings.TEMPLATE_TO_CHANGE, translatesLeft));
			}
			Modals.ShowModal(LocalisationStrings.NEED_HELP, message, continueTranslate);
		}
		
		private function continueTranslate(e:int):void {
			Modals.ShowModal(LocalisationStrings.THANK_YOU, LocalisationStrings.PLEASE_WAIT_AGAIN);
			WebTranslator.ContinueTranslate();
		}
	}
}