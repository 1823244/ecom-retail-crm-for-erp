﻿
&НаСервере
Процедура crm_ПослеЗаписиНаСервереПосле(ТекущийОбъект, ПараметрыЗаписи)
	
	Если crm_RetailCRMОбщий.ПолучитьЗначениеКонстанты("ВыгрузкаОплатВCRM") = Истина Тогда
		
		Свойство = crm_RetailCRMОбработка.УТ11_ПолучитьСвойство("ИДоплаты", Справочники.НаборыДополнительныхРеквизитовИСведений.УдалитьДокумент_ПоступлениеБезналичныхДенежныхСредств);
		ИДОплаты = crm_RetailCRMОбработка.УТ11_ПолучитьЗначениеСвойстваОбъекта(ТекущийОбъект.Ссылка,Свойство);
		
		СвойствоТип = crm_RetailCRMОбработка.УТ11_ПолучитьСвойство("ТипОплаты", Справочники.НаборыДополнительныхРеквизитовИСведений.УдалитьДокумент_ПоступлениеБезналичныхДенежныхСредств);
		КодОплаты = crm_RetailCRMОбработка.УТ11_ПолучитьЗначениеСвойстваОбъекта(ТекущийОбъект.Ссылка,СвойствоТип);
	
		ТипДокументаОплаты = "Поступление безналичных ДС";
		//если ИД пустой - создаем оплату, если заполнен - редактируем
		Если Не ЗначениеЗаполнено(ИДОплаты) И Не ТекущийОбъект.Проведен Тогда
	    	Возврат;
	    КонецЕсли;
		
		Если ТекущийОбъект.ХозяйственнаяОперация <> Перечисления.ХозяйственныеОперации.ПоступлениеОплатыОтКлиента Тогда 
			Возврат;
		КонецЕсли;
		
		Если ПараметрыЗаписи.РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда 
			//при пометке удаления отменяем оплату
			Если ТекущийОбъект.ПометкаУдаления Тогда 
				Отменить = Истина;
			КонецЕсли;	
			crm_RetailCRMОбщий.ВыгрузитьОплатуВCRM(ТекущийОбъект.Ссылка, Отменить, ИДОплаты,ТипДокументаОплаты, КодОплаты);
		ИначеЕсли ПараметрыЗаписи.РежимЗаписи = РежимЗаписиДокумента.ОтменаПроведения Тогда
			Отменить = Истина;
			crm_RetailCRMОбщий.ВыгрузитьОплатуВCRM(ТекущийОбъект.Ссылка,Отменить,ИДОплаты,ТипДокументаОплаты, КодОплаты);
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

