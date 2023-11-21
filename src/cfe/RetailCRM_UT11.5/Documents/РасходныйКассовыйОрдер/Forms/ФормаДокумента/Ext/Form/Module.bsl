﻿
&НаСервере
Процедура crm_ПослеЗаписиНаСервереПосле(ТекущийОбъект, ПараметрыЗаписи)
	
	Если crm_RetailCRMОбщий.ПолучитьЗначениеКонстанты("ВыгрузкаВозвратовОплатыВCRM") = Истина Тогда 
		Если ТекущийОбъект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВозвратОплатыКлиенту Тогда
			
			Свойство = Обработки.crm_RetailCRMОбработка.УТ11_ПолучитьСвойство("ИДоплатыВозврат", Справочники.НаборыДополнительныхРеквизитовИСведений.УдалитьДокумент_РасходныйКассовыйОрдер);
			ИДоплатыВозврат = Обработки.crm_RetailCRMОбработка.УТ11_ПолучитьЗначениеСвойстваОбъекта(ТекущийОбъект.Ссылка,Свойство);
			
			СвойствоТип = Обработки.crm_RetailCRMОбработка.УТ11_ПолучитьСвойство("ТипОплаты", Справочники.НаборыДополнительныхРеквизитовИСведений.УдалитьДокумент_РасходныйКассовыйОрдер);
			КодОплаты = Обработки.crm_RetailCRMОбработка.УТ11_ПолучитьЗначениеСвойстваОбъекта(ТекущийОбъект.Ссылка,СвойствоТип);
			
			ТипДокументаОплаты = "Расходный кассовый ордер";
			//если ИД пустой - создаем оплату, если заполнен - редактируем
			//Если Не ЗначениеЗаполнено(ИДоплатыВозврат) И Не ТекущийОбъект.Проведен Тогда
			//	Возврат;
			//КонецЕсли;
			
			Если ПараметрыЗаписи.РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
				//при пометке удаления отменяем оплату
				Отменить = Ложь;
				Если ТекущийОбъект.ПометкаУдаления Тогда 
					Отменить = Истина;
				КонецЕсли;	
				crm_RetailCRMОбщий.ВыгрузитьВозвратОплатыВCRM(ТекущийОбъект.Ссылка, Отменить, ИДоплатыВозврат, ТипДокументаОплаты, КодОплаты);
			ИначеЕсли ПараметрыЗаписи.РежимЗаписи = РежимЗаписиДокумента.ОтменаПроведения Тогда
				Отменить = Истина;
				crm_RetailCRMОбщий.ВыгрузитьВозвратОплатыВCRM(ТекущийОбъект.Ссылка, Отменить,ИДоплатыВозврат, ТипДокументаОплаты, КодОплаты);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры
