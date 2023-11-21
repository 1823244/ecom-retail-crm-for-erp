﻿
&НаСервере
Процедура crm_ПослеЗаписиНаСервереПосле(ТекущийОбъект, ПараметрыЗаписи)
	
	Если crm_RetailCRMОбщий.ПолучитьЗначениеКонстанты("ВыгрузкаРеализаций") = Истина и ЗначениеЗаполнено(ТекущийОбъект.ЗаказКлиента) Тогда
		Если ПараметрыЗаписи.РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда 
			Если ТекущийОбъект.ПометкаУдаления Тогда 
				Отменить = Истина;
			КонецЕсли;	
			crm_RetailCRMОбщий.ВыгрузитьРеализациюВCRM(ТекущийОбъект.Ссылка, Отменить);
		ИначеЕсли ПараметрыЗаписи.РежимЗаписи = РежимЗаписиДокумента.ОтменаПроведения Тогда
			Отменить = Истина;
			crm_RetailCRMОбщий.ВыгрузитьРеализациюВCRM(ТекущийОбъект.Ссылка,Отменить);
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры
