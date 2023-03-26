package ru.flashader.clausewitzlocalisationhelper.utils {

	/**
	* @author Ilja 'flashader' Mickodin
	*/
	
	public class LocalisationStrings {
		public static const PLEASE_WAIT:String = "Подождите немного.";
		public static const PLEASE_PRESS:String = "Нажмите 'Ctrl'+'Shift'+'S', а потом закройте это окно\n\nИмейте в виду, функционал перевода нестабилен и зависит не от меня\nЕсли не перевелось - попробуйте ещё раз";
		public static const PLEASE_WAIT_AGAIN:String = "И ещё три секунды.";
		public static const CHOOSE_SOURCE_YAML:String = "Выберите исходный yaml файл";
		public static const SAY_CHEESE:String = "Сейчас вылетит птичка";
		public static const TRYING_TO_PARSE:String = "Пытаемся распарсить ваше файло";
		public static const TOO_MANY_STRINGS:String = "\n\nСтрок для перевода много.\nПоэтому это окно появится ещё " + TEMPLATE_TO_CHANGE + " раз";
		public static const TOO_FAILED_STRINGS:String = "\n\nСлучилось что-то непонятное, сервак ругается\nПоэтому не переведено " + TEMPLATE_TO_CHANGE + " строк\nВозможно, поможет пройти гугловую капчу и/или перезапустить перевод непереведённого.\n\nПроверим на капчу?";
		public static const TOO_LONG_STRING:String = "\n\nСтрока для перевода очень длинная.\nПоэтому это окно появится ещё " + TEMPLATE_TO_CHANGE + " раз";
		public static const TEMPLATE_TO_CHANGE:String = "###TEMPLATETOCHAGE###";
		public static const AS_YOUR_WISH:String = "Ну, как хотите";
		public static const I_RECALL_MY_QUESTIONS:String = "На этом мои полномочия всё";
		
		public static const RUSSIAN_RUSSIAN_RUSSIAN_LABEL:String = "Русский русскому русский";
		public static const RUSSIAN_RUSSIAN_RUSSIAN_DESCRIPTION:String = "Вы загрузили файл с русской локализацией. И пытаетесь сохранить в него же" +
			"\nВы абсолютно точно уверены, что знаете, что делаете?" +
			"\n\n(В итоговый файл не будут записаны строки слева" +
			"\n только те, что справа (даже если они пустые)";
		
		public static const FILE_ALREADY_EXISTS:String = "Файл существует";
		public static const SHOULD_WE_REWRITE_EXISTING_FILE:String = "Найден уже существующий файл:\n" + TEMPLATE_TO_CHANGE + "\n Перезаписываю?";
		public static const CONGRATULATIONS:String = "Поздравляю!";
		public static const ONE_MORE_FILE_TRANSLATED:String = "Ещё один файл переведён!\n\nХотите открыть его?";
		
		public static const THANK_YOU:String = "Спасибо";
		public static const TRANSLATING_IN_PROGRESS:String = "Идёт перевод";
		public static const NEED_HELP:String = "Нужна помощь";
		public static const LISTEN_HERE_YOU_LITTLE_SHIT:String = "Короче";
		
		public static const BAD_MERGING_LABEL:String = "Файлы не совпадают";
		public static const BAD_MERGING_DESCRIPTION:String = "Похоже, вы загрузили не тот файл. Из " + KEYS_TOTAL_PLACEHOLDER + " ключей в исходном файле отсутствует " + TARGET_KEYS_PLACEHOLDER + " а в целевом " + SOURCE_KEYS_PLACEHOLDER +
			"\nВы абсолютно точно уверены, что знаете, что делаете?" +
			"\nПри сохранении в любой из файлов будут записаны все-все ключи, даже пустые" +
			"\n\nВсё равно загружаем?";
		public static const KEYS_TOTAL_PLACEHOLDER:String = "###KEYSTOTALTEMPLATETOCHAGE###";
		public static const SOURCE_KEYS_PLACEHOLDER:String = "###SOURCEKEYSTEMPLATETOCHAGE###";
		public static const TARGET_KEYS_PLACEHOLDER:String = "###TARGETKEYSTEMPLATETOCHAGE###";
	}
}