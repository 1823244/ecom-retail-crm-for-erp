﻿Перем Телефон;

&НаКлиенте
Процедура ПоискПоТелефону(Команда)
	
	Если ЗначениеЗаполнено(НомерТелефона) Тогда
		
		ТелефонДляПроверки = crm_RetailCRMОбщий.ПриведениеТелНомераСтандарт(НомерТелефона);
		
		Если Не СтрДлина(ТелефонДляПроверки) = 11 Тогда 
			Сообщить("Не заполнен телефон.",СтатусСообщения.Важное);
			Возврат;		
		КонецЕсли;
		
	ИначеЕсли ЗначениеЗаполнено(НомерКарты) Тогда 
		
	Иначе 
		
		Сообщить("Введите номер телефона или номер карты клиента.",СтатусСообщения.Важное);
		Возврат;
		
	КонецЕсли;
	
	ЗаполнитьФормуВыбораКлиента(ТелефонДляПроверки, НомерКарты);
	
КонецПроцедуры

Функция УдалитьЛишниеСимволы(Телефон)
	
	ТелефонБезЛишнихСимволов = "";
	
	Счетчик = 1; 	
	Пока Счетчик <= СтрДлина(Телефон) Цикл
		Символ = Сред(Телефон,Счетчик,1);
		Если КодСимвола(Символ) >= 48 и КодСимвола(Символ) <= 57 Тогда 
			ТелефонБезЛишнихСимволов = ТелефонБезЛишнихСимволов + Символ;			
		КонецЕсли;
		Счетчик = Счетчик + 1;
	КонецЦикла;
	
	Возврат ТелефонБезЛишнихСимволов;	
	
КонецФункции

&НаКлиенте
Процедура ЗаполнитьФормуВыбораКлиента(ТелефонДляПроверки, НомерКарты)Экспорт 
	 
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("ТелефонДляПроверки", ТелефонДляПроверки);
	СтруктураПараметров.Вставить("НомерКарты", НомерКарты);
	СтруктураПараметров.Вставить("Организация", Организация);
	СтруктураПараметров.Вставить("КассаККМ", КассаККМ);
	
	Магазин = ПолучитьЗначениеМагазина();
	
	СтруктураПараметров.Вставить("Магазин", Магазин);
	
	ОбработчикОповещения = Новый ОписаниеОповещения ("ВывестиДанныеУчастникаПЛ",ЭтаФорма, СтруктураПараметров);
	ОткрытьФорму("ОбщаяФорма.crm_ВыборКлиента",СтруктураПараметров,,,,,ОбработчикОповещения);
	
КонецПроцедуры

&НаСервере
Функция ПолучитьЗначениеМагазина()
	
	Магазин = Неопределено;
	Если crm_RetailCRMПовтИсп.ПолучитьЗначениеКонстанты("СвязьМагазина") = "Склад1С" Тогда 
		МагазинСклад = crm_RetailCRMПовтИсп.ПолучитьЗначениеКонстанты("МагазинСклад");
		Если МагазинСклад <> Неопределено Тогда
			Если ТипЗнч(МагазинСклад) = Тип("Строка") Тогда 
				Сообщить("Проверьте, заполнено ли соответствие магазина ReatilCRM и склада 1С на вкладке ""Розница""");
			Иначе
				СоответствиеМагазинСклад = МагазинСклад.Найти(КассаККМ.Склад, "Склад"); 
				Если СоответствиеМагазинСклад <> Неопределено Тогда
					Магазин = СоответствиеМагазинСклад.КодМагазина;					
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	Иначе
		МагазинОрганизация = crm_RetailCRMПовтИсп.ПолучитьЗначениеКонстанты("МагазинОрганизация");
		Если МагазинОрганизация <> Неопределено Тогда
			Если ТипЗнч(МагазинОрганизация) = Тип("Строка") Тогда 
				Сообщить("Проверьте, заполнено ли соответствие магазина ReatilCRM и организации 1С на вкладке ""Розница""");
			Иначе 
				СоответствиеМагазинОрганизация = МагазинОрганизация.Найти(Организация, "Организация"); 
				Если СоответствиеМагазинОрганизация <> Неопределено Тогда
					Магазин = СоответствиеМагазинОрганизация.КодМагазина;					
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;

	Возврат Магазин;
	
КонецФункции

&НаКлиенте
Процедура ВывестиДанныеУчастникаПЛ(РезультатОткрытияФормы, ДополнительныеПараметры) Экспорт 
	
	//перед выводом данных нужно рассчитать скидки
	Скидки = "";
	Если НЕ РезультатОткрытияФормы = Неопределено Тогда
		РезультатОткрытияФормы.Вставить("ВидЦены", ВидЦены);
		РассчитатьСкидкуПоПЛНаСервере(РезультатОткрытияФормы, Магазин, Скидки);
    КонецЕсли;
	Элементы.БонусныйСчетИнфо.Видимость = Истина;
	
	Если НЕ РезультатОткрытияФормы = Неопределено Тогда
		ТипПривилегии = Скидки.Привилегия;
		idСкидкиПоСобытию = Скидки.IDСкидкиПоСобытию;
		БонусовНаСчете = РезультатОткрытияФормы.Баллы;
		ТекущийУровень = РезультатОткрытияФормы.Уровень;
		ФИО = РезультатОткрытияФормы.ФИО;
		
		Если не ЗначениеЗаполнено(РезультатОткрытияФормы.ИД) Тогда 
			//клиента нет в ПЛ
		Иначе 
			СуммаПокупок = РезультатОткрытияФормы.СуммаПокупок;
			СуммаДоСледующегоУровня = РезультатОткрытияФормы.СуммаДоСледующегоУровня;
			БонусыДляСписания = Скидки.БонусыДляСписания;
			БонусыКНачислению = Скидки.КНачислению;
			Если ЗначениеЗаполнено(Скидки.ВсегоБонусов) Тогда 
				БонусовНаСчете = Скидки.ВсегоБонусов;	
			КонецЕсли;
			
		КонецЕсли;
		
		Если ЗначениеЗаполнено(РезультатОткрытияФормы.НомерКарты) Тогда 
			НомерКарты = РезультатОткрытияФормы.НомерКарты;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(РезультатОткрытияФормы.Почта) Тогда 
			Почта = РезультатОткрытияФормы.Почта;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(РезультатОткрытияФормы.ТелефонДляПроверки) Тогда
			//убираем 8 
			ТелефонДляПроверки = РезультатОткрытияФормы.ТелефонДляПроверки; 
			
			Если стрДлина(ТелефонДляПроверки)=11 Тогда // Номер содержит 11 цифр
				Если КодСимвола(Лев(ТелефонДляПроверки,1))=56 Тогда  // Номер начинается с 8-ки
					ТелефонДляПроверки = Прав(ТелефонДляПроверки,стрДлина(ТелефонДляПроверки)-1);
				КонецЕсли;
			КонецЕсли;	
			
			НомерТелефона = ТелефонДляПроверки;
		КонецЕсли;
		
		Если РезультатОткрытияФормы.IDКлиента = "" Тогда 
			IDКлиента = 36587;
		Иначе IDКлиента = РезультатОткрытияФормы.IDКлиента;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(IDКлиента) Тогда 
			Элементы.Списать.Доступность = Истина;
			Элементы.ПродолжитьБезСписания.Доступность = Истина;
		КонецЕсли;
		
	КонецЕсли;
	
	Если БонусыДляСписания = 0 Тогда 
		Элементы.Списать.Доступность = Ложь;	
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура РассчитатьСкидкуПоПЛНаСервере(ДанныеПЛ, Магазин, Скидки)

	СписокТоваров = РеквизитФормыВЗначение("Товары");
	
 	Скидки = crm_RetailCRMОбщий.РассчитатьСкидкуПоПЛ(ДанныеПЛ, Магазин, СписокТоваров, Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура Списать(Команда)
		
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("ТелефонДляПроверки", НомерТелефона);
	СтруктураПараметров.Вставить("НомерКарты", НомерКарты);
	СтруктураПараметров.Вставить("Товары", Товары);
	СтруктураПараметров.Вставить("IDКлиента", IDКлиента); 
	СтруктураПараметров.Вставить("Магазин", Магазин);
	СтруктураПараметров.Вставить("ТипПривилегии", ТипПривилегии);
	СтруктураПараметров.Вставить("ВидЦены", ВидЦены);
	СтруктураПараметров.Вставить("ФИО", ФИО);
	СтруктураПараметров.Вставить("idЧека", idЧека);
	СтруктураПараметров.Вставить("БонусыДляСписания", БонусыДляСписания);
	СтруктураПараметров.Вставить("КассаККМ", КассаККМ);
	СтруктураПараметров.Вставить("Почта", Почта);
	СтруктураПараметров.Вставить("IDСкидкиПоСобытию", idСкидкиПоСобытию);
	
	ОбработчикОповещения = Новый ОписаниеОповещения ("ОбработатьСписаниеБаллов",ЭтаФорма, СтруктураПараметров);
	ОткрытьФорму("ОбщаяФорма.crm_РасчетБаллов",СтруктураПараметров,,,,,ОбработчикОповещения);

КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Параметры.Организация) Тогда 
		Организация = Параметры.Организация;
	КонецЕсли;
	Если ЗначениеЗаполнено(Параметры.КассаККМ) Тогда 
		КассаККМ = Параметры.КассаККМ;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(IDКлиента) Тогда 
		Элементы.Списать.Доступность = Истина;
		Элементы.ПродолжитьБезСписания.Доступность = Истина;
	Иначе 
	 	Элементы.Списать.Доступность = Ложь;
		Элементы.ПродолжитьБезСписания.Доступность = Ложь;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Параметры.ВидЦены) Тогда 
		ВидЦены = Параметры.ВидЦены;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Параметры.idЧека) Тогда 
		idЧека = Параметры.idЧека;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Параметры.НомерТелефона) Тогда 
		НомерТелефона = Параметры.НомерТелефона;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Параметры.Почта) Тогда 
		Почта = Параметры.Почта;
	КонецЕсли;

	ТаблицаТоваров = Параметры.Товары;
	
	//сюда будет передана ТЧ товары
	ТабТовары = Новый ТаблицаЗначений;
	ТабТовары.Колонки.Добавить("Номенклатура");
	ТабТовары.Колонки.Добавить("Характеристика");
	ТабТовары.Колонки.Добавить("ИдентификаторСтроки");
	ТабТовары.Колонки.Добавить("Количество");
	ТабТовары.Колонки.Добавить("СтавкаНДС");
	ТабТовары.Колонки.Добавить("Цена");
	ТабТовары.Колонки.Добавить("Сумма");
	ТабТовары.Колонки.Добавить("ПроцентРучнойСкидки");
	ТабТовары.Колонки.Добавить("ПроцентАвтоматическойСкидки");
	ТабТовары.Колонки.Добавить("СуммаАвтоматическойСкидки");
	ТабТовары.Колонки.Добавить("СуммаВсего");
	ТабТовары.Колонки.Добавить("СуммаРучнойСкидки");
	ТабТовары.Колонки.Добавить("СуммаСкидкиОплатыБонусом");
	
	Для Каждого СтрТоваров из ТаблицаТоваров Цикл 
		СтрТЗ = ТабТовары.Добавить();
		СтрТЗ.Номенклатура 			= СтрТоваров.Номенклатура;
		СтрТЗ.Характеристика 		= СтрТоваров.Характеристика;
		СтрТЗ.ИдентификаторСтроки 	= СтрТоваров.ИдентификаторСтроки;
		СтрТЗ.Количество 			= СтрТоваров.Количество;
		СтрТЗ.СтавкаНДС 			= СтрТоваров.СтавкаНДС;
		СтрТЗ.Цена 					= СтрТоваров.Цена;
		СтрТЗ.Сумма 				= СтрТоваров.Сумма;
		СтрТЗ.ПроцентРучнойСкидки 	= СтрТоваров.ПроцентРучнойСкидки;
		СтрТЗ.ПроцентАвтоматическойСкидки = СтрТоваров.ПроцентАвтоматическойСкидки;
		СтрТЗ.СуммаАвтоматическойСкидки = СтрТоваров.СуммаАвтоматическойСкидки;
		Попытка
			СтрТЗ.СуммаВсего 		= СтрТоваров.СуммаВсего;
		Исключение
			СтрТЗ.СуммаВсего		= СтрТЗ.Сумма;
		КонецПопытки;
		СтрТЗ.СуммаРучнойСкидки 	= СтрТоваров.СуммаРучнойСкидки;
		Попытка
			СтрТЗ.СуммаСкидкиОплатыБонусом 	= СтрТоваров.СуммаСкидкиОплатыБонусом;
		Исключение
		    СтрТЗ.СуммаСкидкиОплатыБонусом 	= 0;
		КонецПопытки;
		
	КонецЦикла;
	
	СписокТоваровОб = РеквизитФормыВЗначение("Товары");
	СписокТоваровОб = ТабТовары;
	ЗначениеВРеквизитФормы(СписокТоваровОб, "Товары");
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьСписаниеБаллов(РезультатОткрытияФормы, ДополнительныеПараметры) Экспорт
	
	Если РезультатОткрытияФормы <> Неопределено Тогда 
		РезультатОткрытияФормы.Вставить("ФИО", ФИО);
		РезультатОткрытияФормы.Вставить("ТипПривилегии", ТипПривилегии);
		ЭтаФорма.Закрыть(РезультатОткрытияФормы);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ЭтаФорма.Элементы.БонусныйСчетИнфо.Видимость = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ПродолжитьБезСписания(Команда)
	
	Действие = "ВыгрузитьНовыйЧек";
	ДанныеЧека = Новый Структура; 
	ДанныеЧека.Вставить("НомерТелефона", НомерТелефона);
	ДанныеЧека.Вставить("НомерКарты", НомерКарты);
	ДанныеЧека.Вставить("IDКлиента", IDКлиента);
	ДанныеЧека.Вставить("Магазин", Магазин);
	ДанныеЧека.Вставить("ВидЦены", ВидЦены); 
	ДанныеЧека.Вставить("КассаККМ", КассаККМ);
	ДанныеЧека.Вставить("Почта", Почта);
	ДанныеЧека.Вставить("ФИО", ФИО);
	
	ДанныеПЛ = Новый Структура;
	ДанныеПЛ.Вставить("ТипПривилегии", ТипПривилегии);
	ДанныеПЛ.Вставить("IDСкидкиПоСобытию", idСкидкиПоСобытию);
	
	СтруктураВозврата = Новый Структура;
	
	ИдЗаказа = idЧека;
	
	ВыгрузитьЧекВCRM(Неопределено, Ложь, ДанныеПЛ, "ВыгрузитьНовыйЧек", ДанныеЧека, ИдЗаказа);
	
	СтруктураВозврата.Вставить("НомерТелефона", НомерТелефона);
	СтруктураВозврата.Вставить("НомерКарты", НомерКарты);
	СтруктураВозврата.Вставить("IDКлиента", IDКлиента);
	СтруктураВозврата.Вставить("КоличествоДляСписания", 0);
	СтруктураВозврата.Вставить("ИдЗаказа", ИдЗаказа);
	СтруктураВозврата.Вставить("Магазин", Магазин);
	ЭтаФорма.Закрыть(СтруктураВозврата);
	
КонецПроцедуры  

&НаСервере
Процедура ВыгрузитьЧекВCRM(Чек, Отменить, ДанныеПЛ, Действие, ДанныеЧека, ИдЗаказа)

	СписокТоваров = РеквизитФормыВЗначение("Товары");
    ДанныеЧека.Вставить("Товары", Товары);
	crm_RetailCRMОбщий.ВыгрузитьЧекВCRM(Чек, Отменить, ДанныеПЛ, Действие, ДанныеЧека, ИдЗаказа, ФИО);
	
КонецПроцедуры

