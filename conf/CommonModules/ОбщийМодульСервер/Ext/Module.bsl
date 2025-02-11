﻿
Процедура ОтправитьДанныеМониторингаАктивностиПользователя() Экспорт
	
	АдресСервераМониторинга = Константы.АдресСервераМониторинга.Получить();
	ПортСервераМониторинга = Константы.ПортСервераМониторинга.Получить();
	СервисСервераМониторинга = Константы.СервисСервераМониторинга.Получить();
	
	Соединение = Новый HTTPСоединение(АдресСервераМониторинга, ПортСервераМониторинга);
	
	Заголовки = ПолучитьДанныеМониторинга();
	
	Запрос = Новый HTTPЗапрос(СервисСервераМониторинга, Заголовки);
	
	Попытка
		Ответ = Соединение.Получить(Запрос);
	Исключение
		// Здесь должна быть запись в ЖР
	КонецПопытки;
	
КонецПроцедуры

Функция ПолучитьДанныеМониторинга()
	
	ДанныеМониторинга = Новый Соответствие;
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТекущийСеансИнформационнойБазы = ПолучитьТекущийСеансИнформационнойБазы();
	ДанныеМониторинга.Вставить("Пользователь",		Строка(ТекущийСеансИнформационнойБазы.Пользователь));
	ДанныеМониторинга.Вставить("IPАдресКлиента",	ТекущийСеансИнформационнойБазы.IPАдресКлиента);
	ДанныеМониторинга.Вставить("ИмяКомпьютера",		ТекущийСеансИнформационнойБазы.ИмяКомпьютера);
	ДанныеМониторинга.Вставить("НомерСеанса",		Строка(ТекущийСеансИнформационнойБазы.НомерСеанса));
	ДанныеМониторинга.Вставить("НомерСоединения",	Строка(ТекущийСеансИнформационнойБазы.НомерСоединения));
	//  ip-адрес и имя компьютера «сервера» можно получить либо из строки соединения либо через командную строку
	
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат ДанныеМониторинга;
	
КонецФункции // ПолучитьДанныеМониторинга()

Процедура ЗагрузитьКурсыВалют(Адрес, Валюта, ДатаЗагрузки) Экспорт
	
	//Сервер
	Сервер = "cbrates.rbc.ru";
	
	//На определенную дату
	Адрес = "tsv/" + Адрес + ".tsv";
	
	Попытка
		HTTP = Новый HTTPСоединение(Сервер);
	Исключение

	КонецПопытки;
	
	HTTPЗапрос = Новый HTTPЗапрос(Адрес); 
	HTTPОтвет = HTTP.Получить(HTTPЗапрос);
	Текст = HTTPОтвет.ПолучитьТелоКакСтроку("windows-1251");
	
	Если HTTPОтвет.КодСостояния = 200 Тогда
	
		Для ИндексСтроки = 1 По СтрЧислоСтрок(Текст) Цикл
			
			СтрокаКурса = СтрПолучитьСтроку(Текст, ИндексСтроки);
			
			МассивДанных = ОбщийМодульКлиентСервер.АналогСтрРазделить(СтрокаКурса, "	");
			Индекс = 1;
			Если МассивДанных.Количество() = 2 Тогда
				Индекс = 0;
			КонецЕсли;
			
			Кратность = МассивДанных[Индекс];
			Курс = МассивДанных[Индекс + 1];
			
			ЗаписьКурса = РегистрыСведений.КурсыВалют.СоздатьМенеджерЗаписи();
			ЗаписьКурса.Период = ДатаЗагрузки;
			ЗаписьКурса.Валюта = Валюта;
			ЗаписьКурса.Кратность = Кратность;
			ЗаписьКурса.Курс = Курс;
			ЗаписьКурса.Записать();
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

Функция ПолучитьКурсВалюты(Валюта, ДатаКурса) Экспорт
	
	Курс = 1;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	КурсыВалютСрезПоследних.Курс / КурсыВалютСрезПоследних.Кратность КАК Курс
		|ИЗ
		|	РегистрСведений.КурсыВалют.СрезПоследних(&ДатаКурса, Валюта = &Валюта) КАК КурсыВалютСрезПоследних";
	
	Запрос.УстановитьПараметр("Валюта", Валюта);
	Запрос.УстановитьПараметр("ДатаКурса", ДатаКурса);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Курс = ВыборкаДетальныеЗаписи.Курс;
	КонецЦикла;
	
	Возврат Курс;
	
КонецФункции
