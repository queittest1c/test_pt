﻿

#Область ОписаниеПеременных

#КонецОбласти

#Область ОбработчикиСобытийФормы

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВалютаПриИзменении(Элемент)
	
	Режим = РежимДиалогаВопрос.ДаНет;
	Оповещение = Новый ОписаниеОповещения("ПослеЗакрытияВопроса", ЭтотОбъект, Параметры);
	ПоказатьВопрос(Оповещение, НСтр("ru = 'Пересчитать суммы?';" + " en = 'Recalculate amounts'"), Режим, 0);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыЗаказы

&НаКлиенте
Процедура ЗаказыЗаказПриИзменении(Элемент)
	
	СтрокаТабличнойЧасти = Элементы.Заказы.ТекущиеДанные;
	
	СтрокаТабличнойЧасти.Сумма = ПолучитьСуммуДокумента(СтрокаТабличнойЧасти.Заказ);
	
	ОбновитьСуммуДокумента();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаказыСуммаПриИзменении(Элемент)
	
	ОбновитьСуммуДокумента();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбновитьСуммуДокумента()
	
	Объект.СуммаДокумента = Объект.Заказы.Итог("Сумма");
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗакрытияВопроса(Результат, Параметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		
		Курс = ОбщийМодульСервер.ПолучитьКурсВалюты(Объект.Валюта, Объект.Дата);
		
		Для каждого СтрокаТоваров Из Объект.Заказы Цикл
			СтрокаТоваров.Сумма = Окр(СтрокаТоваров.Сумма / Курс, 2, РежимОкругления.Окр15как20);
		КонецЦикла;
		
		ОбновитьСуммуДокумента();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьСуммуДокумента(Заказ)
	
	Возврат Заказ.СуммаДокумента;
	
КонецФункции // ПолучитьСуммуДокумента()


#КонецОбласти