﻿
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	СуммаДокумента = Заказы.Итог("Сумма");
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, Режим)
	
	Курс = ОбщийМодульСервер.ПолучитьКурсВалюты(Валюта, Дата);

	// регистр ОплатыПоЗаказам Приход
	Движения.ОплатыПоЗаказам.Записывать = Истина;
	Для Каждого ТекСтрокаЗаказы Из Заказы Цикл
		Движение = Движения.ОплатыПоЗаказам.Добавить();
		Движение.ВидДвижения = ВидДвиженияНакопления.Расход;
		Движение.Период = Дата;
		Движение.Заказ = ТекСтрокаЗаказы.Заказ;
		Движение.Валюта = Валюта;
		Движение.Сумма = ТекСтрокаЗаказы.Сумма * Курс;
		Движение.СуммаВал = ТекСтрокаЗаказы.Сумма;
	КонецЦикла;
	
КонецПроцедуры
