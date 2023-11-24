﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УчастиеВПЛ = СписокУчастийВПЛ(Параметры.ТелефонДляПроверки, Параметры.НомерКарты, Параметры.КассаККМ, Параметры.Организация, Параметры.Магазин);
	СписокКлиентовОб = РеквизитФормыВЗначение("СписокКлиентов");
	СписокКлиентовОб = УчастиеВПЛ;
	ЗначениеВРеквизитФормы(СписокКлиентовОб, "СписокКлиентов");
	Телефон = Параметры.ТелефонДляПроверки;
	НомерКарты = Параметры.НомерКарты;
	Магазин = Параметры.Магазин;
	
	Если УчастиеВПЛ.Количество() = 0 Тогда 
		Элементы.Создать.Доступность = Истина;
		Элементы.Выбрать.Доступность = Ложь;
	Иначе 
	 	Элементы.Создать.Доступность = Ложь;
		Элементы.Выбрать.Доступность = Истина;
	КонецЕсли;
	
КонецПроцедуры

Функция СписокУчастийВПЛ(НомерТел, НомерКарты, КассаККМ, Организация, Магазин) Экспорт
	
	КлючCRM 	= crm_RetailCRMОбщий.ПолучитьЗначениеКонстанты("КлючCRM");
	ИмяСервера 	= crm_RetailCRMОбщий.ПолучитьЗначениеКонстанты("ИмяСервера");
	
	Если ЗначениеЗаполнено(НомерТел) Тогда 
		ответ = crm_RetailCRMОбщий.HTTPзапросGET(ИмяСервера,"/api/v5/loyalty/accounts?filter[phoneNumber]=" + НомерТел + "&filter[sites][]=" + Магазин + "&apiKey=" + КлючCRM);
	ИначеЕсли ЗначениеЗаполнено(НомерКарты) Тогда 
		ответ = crm_RetailCRMОбщий.HTTPзапросGET(ИмяСервера,"/api/v5/loyalty/accounts?filter[cardNumber]=" + НомерКарты + "&filter[sites][]=" + Магазин + "&apiKey=" + КлючCRM);
	КонецЕсли;
	
	ответ = crm_RetailCRMОбщий.UnJSON(ответ);
	
	УчастиеВПЛ = Новый ТаблицаЗначений;
	УчастиеВПЛ.Колонки.Добавить("ФИО");
	УчастиеВПЛ.Колонки.Добавить("Телефон");
	УчастиеВПЛ.Колонки.Добавить("УчастникПЛ");
	УчастиеВПЛ.Колонки.Добавить("ПЛ");
	УчастиеВПЛ.Колонки.Добавить("IDучастия");
	УчастиеВПЛ.Колонки.Добавить("НомерКарты");
	УчастиеВПЛ.Колонки.Добавить("КоличествоБонусов");
	УчастиеВПЛ.Колонки.Добавить("Уровень");
	УчастиеВПЛ.Колонки.Добавить("ДатаСоздания");
	УчастиеВПЛ.Колонки.Добавить("ДатаАктивацииУчастия");
	УчастиеВПЛ.Колонки.Добавить("IDКлиента");
	УчастиеВПЛ.Колонки.Добавить("ДатаРождения");
	УчастиеВПЛ.Колонки.Добавить("Пол");
	УчастиеВПЛ.Колонки.Добавить("СуммаПокупок");
	УчастиеВПЛ.Колонки.Добавить("СуммаДоСледующегоУровня");
	УчастиеВПЛ.Колонки.Добавить("Почта");
	
	Если Ответ["loyaltyAccounts"].КОличество()<> 0 Тогда
		IDКлиента = "";
		НазваниеУровня = "";
		Для каждого Лояльность из Ответ["loyaltyAccounts"] Цикл
			СтрТЗ = УчастиеВПЛ.Добавить();
			
			Клиент  = Лояльность["customer"];
			Имя		= ?(Клиент["firstName"] <> Неопределено, Клиент["firstName"],""); 
			Фамилия = ?(Клиент["lastName"] <> Неопределено, Клиент["lastName"],"");
			Отчество= ?(Клиент["patronymic"] <> Неопределено, Клиент["patronymic"],"");
			ФИО = СокрЛП(Фамилия + " " + Имя + " " + Отчество); 
			СтрТЗ.ФИО = ФИО;
			IDКлиента = Клиент["id"];
			Уровень = Лояльность["level"];
			ТипУровня = Уровень["type"]; 
			IDУровня  = Уровень["id"];
			НазваниеУровня	  = Уровень["name"];
			Если Не ЗначениеЗаполнено(НомерТел) Тогда 
				СтрТЗ.Телефон 		= Лояльность["phoneNumber"];
			Иначе 
				СтрТЗ.Телефон 		= НомерТел;
			КонецЕсли;
			СтрТЗ.УчастникПЛ 		= Лояльность["active"];
			СтрТЗ.IDучастия 	 	= Лояльность["id"];
			СтрТЗ.НомерКарты 		= Лояльность["cardNumber"];
			СтрТЗ.КоличествоБонусов = Лояльность["amount"];
			СтрТЗ.Уровень			= НазваниеУровня;
			СтрТЗ.ДатаСоздания 		= crm_RetailCRMОбщий.ПреобразоватьДатуCRM(Лояльность["createdAt"]);
			СтрТЗ.ДатаАктивацииУчастия 	= crm_RetailCRMОбщий.ПреобразоватьДатуCRM(Лояльность["activatedAt"]);
			СтрТЗ.IDКлиента 		= IDКлиента;
			СтрТЗ.СуммаПокупок 		= Лояльность["ordersSum"];
            СтрТЗ.СуммаДоСледующегоУровня = Лояльность["nextLevelSum"];
			СтрТЗ.Почта				= "";
		КонецЦикла;
	Иначе 
		//ищем клиента в retailCRM
		
		Если ЗначениеЗаполнено(НомерТел) Тогда
			ответ = crm_RetailCRMОбщий.HTTPзапросGET(ИмяСервера,"/api/v5/customers?filter[name]=" + НомерТел + "&apiKey=" + КлючCRM);
		ИначеЕсли ЗначениеЗаполнено(НомерКарты) Тогда 
			ответ = crm_RetailCRMОбщий.HTTPзапросGET(ИмяСервера,"/api/v5/customers?filter[discountCardNumber]=" + НомерКарты + "&apiKey=" + КлючCRM);
		КонецЕсли;
		
		Успех = (Найти(ответ, """success"":true") > 0);
		
		ответ = crm_RetailCRMОбщий.UnJSON(ответ);
		
		Для каждого Клиент из Ответ["customers"] Цикл
			ФИО = "" + Клиент["lastName"] + " " + Клиент["firstName"] + " " + Клиент["patronymic"];
			СтрТЗ = УчастиеВПЛ.Добавить();
			СтрТЗ.ФИО 			= ФИО;
			СтрТЗ.Телефон 			= НомерТел;
			СтрТЗ.УчастникПЛ 		= Ложь;
			СтрТЗ.IDучастия 	 	= "";
			СтрТЗ.НомерКарты 		= "";
			СтрТЗ.КоличествоБонусов = "";
			СтрТЗ.Уровень 			= "";
			СтрТЗ.ДатаСоздания 		= crm_RetailCRMОбщий.ПреобразоватьДатуCRM(Клиент["createdAt"]);  //Дата(1,1,1);
			СтрТЗ.ДатаАктивацииУчастия 	= Дата(1,1,1);
			СтрТЗ.IDКлиента 		= Клиент["id"];
			СтрТЗ.ДатаРождения 		= ?(Клиент["birthday"] <> Неопределено, crm_RetailCRMОбщий.ПреобразоватьДатуCRM(Клиент["birthday"]), Дата(1,1,1));
			Пол = Неопределено;
			Если ЗначениеЗаполнено(Клиент["sex"]) Тогда 
				Если Клиент["sex"] = "female" Тогда 
					Пол 	= "Ж";
				ИначеЕсли Клиент["sex"] = "male" Тогда
					Пол 	= "М";
				КонецЕсли;
			КонецЕсли;
			СтрТЗ.Пол 		= Пол;
			СтрТЗ.Почта		= "";			
		КонецЦикла;
	КонецЕсли;
	
	Возврат УчастиеВПЛ;
	
КонецФункции

&НаКлиенте
Процедура Выбрать(Команда)
	//записать клиента в чек
	Клиент = Элементы.СписокКлиентов.ТекущиеДанные;
	
	Если Клиент = Неопределено Тогда 
		Сообщить("Выберите клиента.",СтатусСообщения.Важное);
		Возврат;
	КонецЕсли;
	
	Если Не Клиент.УчастникПЛ Тогда 
		
		ФИО = Клиент.ФИО;
		Фамилия  = ВыделитьСлово(ФИО,1);
		Имя      = ВыделитьСлово(ФИО,2);
		Отчество = ВыделитьСлово(ФИО,3);
		
		СтруктураПараметров = Новый Структура;
		СтруктураПараметров.Вставить("ТелефонДляПроверки", Клиент.Телефон);
		СтруктураПараметров.Вставить("ИД", Клиент.IDучастия);
		СтруктураПараметров.Вставить("Баллы", Клиент.КоличествоБонусов);
		СтруктураПараметров.Вставить("Уровень", Клиент.Уровень);
		СтруктураПараметров.Вставить("ФИО", ФИО);
		СтруктураПараметров.Вставить("Фамилия", Фамилия);
		СтруктураПараметров.Вставить("Имя", Имя);
		СтруктураПараметров.Вставить("Отчество", Отчество);
		СтруктураПараметров.Вставить("КлиентCRM", Истина);
		СтруктураПараметров.Вставить("IDКлиента", Клиент.IDКлиента);
		СтруктураПараметров.Вставить("ДатаРождения", Клиент.ДатаРождения);
		СтруктураПараметров.Вставить("Пол", Клиент.Пол);
		СтруктураПараметров.Вставить("ДатаСоздания", Клиент.ДатаСоздания);
		СтруктураПараметров.Вставить("Магазин", Магазин);
		СтруктураПараметров.Вставить("Почта", Клиент.Почта);

		ПоказатьВопрос(Новый ОписаниеОповещения("ПослеЗакрытияВопроса", ЭтаФорма, СтруктураПараметров)
		, "Клиент не зарегистрирован в программе лояльности. Зарегистрировать?",РежимДиалогаВопрос.ДаНет,,,,КодВозвратаДиалога.Да); 
		
	Иначе
		
		СтруктураПараметров = Новый Структура;
		СтруктураПараметров.Вставить("ТелефонДляПроверки", Клиент.Телефон);
		СтруктураПараметров.Вставить("ИД", Клиент.IDучастия);
		СтруктураПараметров.Вставить("Баллы", Клиент.КоличествоБонусов);
		СтруктураПараметров.Вставить("Уровень", Клиент.Уровень);
		ФИО = Клиент.ФИО;
		СтруктураПараметров.Вставить("ФИО", ФИО);
		Фамилия  = ВыделитьСлово(ФИО,1);
		Имя      = ВыделитьСлово(ФИО,2);
		Отчество = ВыделитьСлово(ФИО,3);
		СтруктураПараметров.Вставить("Фамилия", Фамилия);
		СтруктураПараметров.Вставить("Имя", Имя);
		СтруктураПараметров.Вставить("Отчество", Отчество);
		СтруктураПараметров.Вставить("КлиентCRM", Истина);
		СтруктураПараметров.Вставить("IDКлиента", Клиент.IDКлиента);
		СтруктураПараметров.Вставить("НомерКарты", Клиент.НомерКарты);
		СтруктураПараметров.Вставить("ДатаРождения", Клиент.ДатаРождения);
		СтруктураПараметров.Вставить("Пол", Клиент.Пол);
		СтруктураПараметров.Вставить("Магазин", Магазин);
		СтруктураПараметров.Вставить("СуммаПокупок", Клиент.СуммаПокупок);
		СтруктураПараметров.Вставить("СуммаДоСледующегоУровня", Клиент.СуммаДоСледующегоУровня);
		СтруктураПараметров.Вставить("Почта", Клиент.Почта);
		
		//найдем клиента в 1С
		Партнер = НайтиКлиентаВ1С(СтруктураПараметров);
		Если ЗначениеЗаполнено(Партнер) Тогда 
			crm_RetailCRMОбщий.УстановитьСвойстваПЛ(Партнер, Формат(Число(Клиент.IDучастия),"ЧГ="), true);
		КонецЕсли;
		
		СтруктураПараметров.Вставить("Партнер",Партнер);
		
		ЭтаФорма.Закрыть(СтруктураПараметров);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция НайтиКлиентаВ1С(СтруктураПараметров) 

	Если ЗначениеЗаполнено(СтруктураПараметров.IDКлиента) Тогда 
			Контрагент = crm_RetailCRMОбработка.УТ11_ВернутьКонтрагентаПоID(Формат(Число(СтруктураПараметров.IDКлиента),"ЧГ="), "customer");
			
			Если Не ЗначениеЗаполнено(Контрагент) Тогда 
				Контрагент = crm_RetailCRMОбработка.УТ11_ВернутьКонтрагентаПоТелефону_Почте("", СтруктураПараметров.ТелефонДляПроверки);
				Если Не ЗначениеЗаполнено(Контрагент) Тогда 
					//создадим клиента в 1С
					Структура = Новый Структура;
					Структура.Вставить("Фамилия", 		СтруктураПараметров.Фамилия);
					Структура.Вставить("Имя", 			СтруктураПараметров.Имя);
					Структура.Вставить("Отчество", 		СтруктураПараметров.Отчество);
					Структура.Вставить("Телефон", 		СтруктураПараметров.ТелефонДляПроверки);
					Структура.Вставить("Почта", 		СтруктураПараметров.Почта);
					Структура.Вставить("Пол", 			СтруктураПараметров.Пол);
					Структура.Вставить("ДатаРождения", 	СтруктураПараметров.ДатаРождения);
					Структура.Вставить("IDКлиента", 	Формат(Число(СтруктураПараметров.IDКлиента),"ЧГ="));
					//Если ЗначениеЗаполнено(Параметры.ДатаСоздания) Тогда
						Структура.Вставить("ДатаСоздания", 	ТекущаяДата());
					//Иначе 
						//Структура.Вставить("ДатаСоздания", 	Параметры.ДатаСоздания);
					//КонецЕсли;	
					КлиентПартнер = crm_RetailCRMОбщий.СоздатьКлиента1С(Структура);
					Партнер = КлиентПартнер.Получить("Партнер");
					Контрагент = КлиентПартнер.Получить("Клиент");
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		Если ЗначениеЗаполнено(Контрагент) и не ЗначениеЗаполнено(Партнер) Тогда 
			Партнер = Контрагент.Партнер;	
		КонецЕсли;
		
		возврат Партнер;
		
КонецФункции

&НаКлиенте
Функция ВыделитьСлово(ИсходнаяСтрока,Позиция)
	
	Буфер = СокрЛ(ИсходнаяСтрока);
	ПозицияПослПробела = Найти(Буфер, " ");

	Если ПозицияПослПробела = 0 Тогда
		ИсходнаяСтрока = "";
		Возврат Буфер;
	КонецЕсли;
	
	Если Позиция = 3 Тогда 
	ВыделенноеСлово = СокрЛП(Буфер);
	Иначе 
	ВыделенноеСлово = СокрЛП(Лев(Буфер, ПозицияПослПробела));
	ИсходнаяСтрока = Сред(ИсходнаяСтрока, ПозицияПослПробела + 1);
	КонецЕсли;
	
	Возврат ВыделенноеСлово;
	
КонецФункции

&НаКлиенте
Процедура Создать(Команда)
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("КлиентCRM", Ложь);
	СтруктураПараметров.Вставить("ТелефонДляПроверки", Телефон);
	СтруктураПараметров.Вставить("НомерКарты", НомерКарты);
	СтруктураПараметров.Вставить("Фамилия", "");
	СтруктураПараметров.Вставить("Имя", "");
	СтруктураПараметров.Вставить("Отчество", "");
	СтруктураПараметров.Вставить("ДатаРождения", Дата(1,1,1));
	СтруктураПараметров.Вставить("Пол", "");
	СтруктураПараметров.Вставить("Магазин", Магазин);
		
	ОбработчикОповещения = Новый ОписаниеОповещения ("ЗаполнитьФормуВыбораКлиента",ЭтаФорма, СтруктураПараметров);
	ОткрытьФорму("ОбщаяФорма.crm_РегистрацияКлиента",СтруктураПараметров,,,,,ОбработчикОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗакрытияВопроса(Результат, Параметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		//зарегистрировать клиента
		ОбработчикОповещения = Новый ОписаниеОповещения ("ЗаполнитьФормуВыбораКлиента", ЭтаФорма, Параметры);
		ОткрытьФорму("ОбщаяФорма.crm_РегистрацияКлиента",Параметры,,,,,ОбработчикОповещения);
	Иначе
		ЭтаФорма.Закрыть(Параметры);
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьФормуВыбораКлиента(РезультатОткрытияФормы, ДополнительныеПараметры) Экспорт 
	
	Если НЕ РезультатОткрытияФормы = Неопределено Тогда 
		ЗаполнитьФормуВыбораКлиентаНаСервере(РезультатОткрытияФормы);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьФормуВыбораКлиентаНаСервере(РезультатОткрытияФормы)
	
	СписокКлиентовОб = РеквизитФормыВЗначение("СписокКлиентов");
	
	//создаем новую Тз для записи данных из структуры 
	ТЗ = Новый ТаблицаЗначений;
	ТЗ.Колонки.Добавить("ФИО");
	ТЗ.Колонки.Добавить("Телефон");
	ТЗ.Колонки.Добавить("УчастникПЛ");
	ТЗ.Колонки.Добавить("ПЛ");
	ТЗ.Колонки.Добавить("IDучастия");
	ТЗ.Колонки.Добавить("НомерКарты");
	ТЗ.Колонки.Добавить("КоличествоБонусов");
	ТЗ.Колонки.Добавить("Уровень");
	ТЗ.Колонки.Добавить("ДатаСоздания");
	ТЗ.Колонки.Добавить("ДатаАктивацииУчастия");
	ТЗ.Колонки.Добавить("IDКлиента");
	ТЗ.Колонки.Добавить("ДатаРождения");
	ТЗ.Колонки.Добавить("Пол");
	ТЗ.Колонки.Добавить("СуммаПокупок");
	ТЗ.Колонки.Добавить("СуммаДоСледующегоУровня");
	ТЗ.Колонки.Добавить("Почта");
	
	СтрТЗ = ТЗ.Добавить();
	СтрТЗ.ФИО 				= РезультатОткрытияФормы.ФИО;
	СтрТЗ.Телефон 			= РезультатОткрытияФормы.Телефон;
	СтрТЗ.УчастникПЛ 		= РезультатОткрытияФормы.УчастникПЛ;
	СтрТЗ.ПЛ 				= РезультатОткрытияФормы.ПЛ;
	СтрТЗ.IDучастия 	 	= РезультатОткрытияФормы.IDучастия;
	СтрТЗ.НомерКарты 		= РезультатОткрытияФормы.НомерКарты;
	СтрТЗ.КоличествоБонусов = РезультатОткрытияФормы.КоличествоБонусов;
	СтрТЗ.Уровень			= РезультатОткрытияФормы.Уровень;
	СтрТЗ.ДатаСоздания 		= РезультатОткрытияФормы.ДатаСоздания;
	СтрТЗ.ДатаАктивацииУчастия 	= РезультатОткрытияФормы.ДатаАктивацииУчастия;
	СтрТЗ.IDКлиента 		= РезультатОткрытияФормы.IDКлиента;
    СтрТЗ.ДатаРождения 		= РезультатОткрытияФормы.ДатаРождения;
	СтрТЗ.Пол 				= РезультатОткрытияФормы.Пол;
	СтрТЗ.СуммаПокупок		= РезультатОткрытияФормы.СуммаПокупок;
	СтрТЗ.СуммаДоСледующегоУровня = РезультатОткрытияФормы.СуммаДоСледующегоУровня;
	СтрТЗ.Почта				= РезультатОткрытияФормы.Почта;
	
	СписокКлиентовОб = ТЗ;
	ЗначениеВРеквизитФормы(СписокКлиентовОб, "СписокКлиентов");
	
	Если СписокКлиентов.Количество()>0 Тогда 
		Элементы.Выбрать.Доступность = Истина;
		Элементы.Создать.Доступность = Ложь;
	КонецЕсли;
	
КонецПроцедуры
