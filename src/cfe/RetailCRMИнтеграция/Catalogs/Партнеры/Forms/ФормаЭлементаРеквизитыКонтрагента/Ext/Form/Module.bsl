﻿
&НаСервере
Процедура crm_СоздатьКлиентаВCRMПослеНаСервере(Структура)
	
	Если Объект.ЮрФизЛицо = Перечисления.КомпанияЧастноеЛицо.ЧастноеЛицо Тогда 
		
		СвойствоПартнеров = crm_RetailCRMОбработка.УТ11_ПолучитьСвойство("ИД", Справочники.НаборыДополнительныхРеквизитовИСведений.УдалитьСправочник_Партнеры);
		ИДПартнера 	= crm_RetailCRMОбработка.УТ11_ПолучитьЗначениеСвойстваОбъекта(Объект.Ссылка, СвойствоПартнеров);
		
		Успешно = Неопределено;
		
		//СОЗДАНИЕ КЛИЕНТА
		Если Элементы.СоздатьКлиентаВCRM.Заголовок = "Создать клиента в CRM" Тогда 
			crm_RetailCRMОбщий.СоздатьКлиентаИзФормыКонтрагента(Объект.Ссылка, Успешно, Истина, Ложь);  //партнер 
			Если Успешно = Истина Тогда 
				Элементы.СоздатьКлиентаВCRM.Заголовок = "Зарегистрировать в ПЛ";
				Элементы.ОбновитьКлиентаВCRM.Видимость = Истина;
			КонецЕсли;
			
			//РЕГИСТРАЦИЯ КЛИЕНТА
		ИначеЕсли Элементы.СоздатьКлиентаВCRM.Заголовок = "Зарегистрировать в ПЛ" Тогда
			Активность = Неопределено;
			crm_RetailCRMОбщий.РегистрацияКлиента(Объект.Ссылка, Успешно, Активность);
			Если Успешно = Истина и Активность <> Истина Тогда 
				Элементы.СоздатьКлиентаВCRM.Заголовок = "Активировать в ПЛ";
			ИначеЕсли Успешно = Истина и Активность = Истина Тогда 
				Элементы.СоздатьКлиентаВCRM.Заголовок = "Бонусный счет CRM";
			КонецЕсли;
			
			//АКТИВАЦИЯ КЛИЕНТА	
		ИначеЕсли Элементы.СоздатьКлиентаВCRM.Заголовок = "Активировать в ПЛ" Тогда
			//проверить подтверждение по смс
			Если crm_RetailCRMПовтИсп.ПолучитьЗначениеКонстанты("ПодтверждатьСМС") = Истина Тогда
				
				
			КонецЕсли;
			//
			crm_RetailCRMОбщий.АктивироватьКлиентаВПЛ(Объект.Ссылка, Успешно);
			Если Успешно = Истина Тогда 
				Элементы.СоздатьКлиентаВCRM.Заголовок = "Бонусный счет CRM";
			КонецЕсли;
			
			//БОНУСНЫЙ СЧЕТ	
		ИначеЕсли Элементы.СоздатьКлиентаВCRM.Заголовок = "Бонусный счет CRM" Тогда 
			crm_RetailCRMОбщий.ПолучитьДанныеБонусногоСчета(Объект.Ссылка, Структура);
		КонецЕсли;
		
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура crm_СоздатьКлиентаВCRMПосле(Команда) Экспорт 
	
	Если Элементы.СоздатьКлиентаВCRM.Заголовок = "Активировать в ПЛ" и crm_RetailCRMПовтИсп.ПолучитьЗначениеКонстанты("ПодтверждатьСМС") = Истина Тогда
		Оповещение = Новый ОписаниеОповещения("crm_АктивироватьКлиента", ЭтотОбъект);
		ПоказатьВопрос(Оповещение, "Для активации необходимо будет сообщить код, отправленный по номеру телефона. Продолжить активацию?", 
						РежимДиалогаВопрос.ДаНетОтмена, 0, КодВозвратаДиалога.Да, "Подтверждение по SMS");
	Иначе 
		Структура = Новый Структура;
		crm_СоздатьКлиентаВCRMПослеНаСервере(Структура); 
		
		Если Структура.Количество()>0 Тогда 
			ОткрытьФорму("ОбщаяФорма.crm_БонусныйСчет",Структура,,,,,,);	
		КонецЕсли;					
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура crm_АктивироватьКлиента (Результат, Параметры) Экспорт
	
	 Если Результат = КодВозвратаДиалога.Да Тогда
		Структура = Новый Структура;
		Сообщить("Активация клиента при включенном SMS подтверждении недоступна в рамках этой версии шаблонного модуля");
		//crm_СоздатьКлиентаВCRMПослеНаСервере(Структура); 
		
		Если Структура.Количество()>0 Тогда 
			ОткрытьФорму("ОбщаяФорма.crm_БонусныйСчет",Структура,,,,,,);	
		КонецЕсли;					
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура crm_ПриОткрытииПослеНаСервере()
	
	Элементы.ОбновитьКлиентаВCRM.Видимость = Ложь;
	
	Если crm_RetailCRMПовтИсп.ПолучитьЗначениеКонстанты("ИспользованиеПЛ") = Ложь Тогда 
   		Элементы.СоздатьКлиентаВCRM.Видимость = Ложь;
	Иначе 
	
		Если Объект.ЮрФизЛицо = Перечисления.КомпанияЧастноеЛицо.ЧастноеЛицо Тогда 
			
			СвойствоПартнеров = crm_RetailCRMОбработка.УТ11_ПолучитьСвойство("ИД", Справочники.НаборыДополнительныхРеквизитовИСведений.УдалитьСправочник_Партнеры);
			ИДПартнера 	= crm_RetailCRMОбработка.УТ11_ПолучитьЗначениеСвойстваОбъекта(Объект.Ссылка, СвойствоПартнеров);
			Если НЕ ЗначениеЗаполнено(ИДПартнера) Тогда 
				Элементы.СоздатьКлиентаВCRM.Заголовок = "Создать клиента в CRM";
			Иначе
				Элементы.ОбновитьКлиентаВCRM.Видимость = Истина;
				//проверяем регистрацию в ПЛ
				СвойствоПартнеров = crm_RetailCRMОбработка.УТ11_ПолучитьСвойство("ИДУчастияВПЛ", Справочники.НаборыДополнительныхРеквизитовИСведений.УдалитьСправочник_Партнеры);
				ИДУчастияВПЛ 	= crm_RetailCRMОбработка.УТ11_ПолучитьЗначениеСвойстваОбъекта(Объект.Ссылка, СвойствоПартнеров);
				Если НЕ ЗначениеЗаполнено(ИДУчастияВПЛ) Тогда 
					Элементы.СоздатьКлиентаВCRM.Заголовок = "Зарегистрировать в ПЛ";
				Иначе 
					СвойствоПартнеров = crm_RetailCRMОбработка.УТ11_ПолучитьСвойство("АктивенВПЛ", Справочники.НаборыДополнительныхРеквизитовИСведений.УдалитьСправочник_Партнеры);
					АктивенВПЛ 	= crm_RetailCRMОбработка.УТ11_ПолучитьЗначениеСвойстваОбъекта(Объект.Ссылка, СвойствоПартнеров);
					Если АктивенВПЛ = Ложь или АктивенВПЛ = Неопределено Тогда 
						Элементы.СоздатьКлиентаВCRM.Заголовок = "Активировать в ПЛ";
					Иначе 
						Элементы.СоздатьКлиентаВCRM.Заголовок = "Бонусный счет CRM";
					КонецЕсли;
					
				КонецЕсли;
				
			КонецЕсли;
		Иначе 
			Элементы.СоздатьКлиентаВCRM.Видимость = Ложь;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры


&НаКлиенте
Процедура crm_ПриОткрытииПосле(Отказ)
	crm_ПриОткрытииПослеНаСервере();
КонецПроцедуры


&НаСервере
Процедура crm_ОбновитьКлиентаВCRMПослеНаСервере()
	crm_RetailCRMОбщий.СоздатьКлиентаИзФормыКонтрагента(Объект.Ссылка, , Ложь, Истина);
КонецПроцедуры


&НаКлиенте
Процедура crm_ОбновитьКлиентаВCRMПосле(Команда)
	crm_ОбновитьКлиентаВCRMПослеНаСервере();
КонецПроцедуры

