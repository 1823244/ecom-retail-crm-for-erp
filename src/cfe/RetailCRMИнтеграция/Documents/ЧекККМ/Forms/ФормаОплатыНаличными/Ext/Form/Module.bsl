﻿
&НаКлиенте
Процедура crm_ПередЗакрытиемПосле(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	//Действие = "ВыгрузитьЧекБезПЛ";
	//
	//Если crm_RetailCRMПовтИсп.ПолучитьЗначениеКонстанты("ВыгружатьЧек") = Истина и crm_RetailCRMПовтИсп.ПолучитьЗначениеКонстанты("ИспользованиеПЛ") = Ложь Тогда
	//	//Если ЭтотОбъект.СуммаДоплаты = 0 и ЭтотОбъект.РезультатОплаты <> "Отмена" Тогда
	//	//	ЭтотОбъект.Документ
	//	Если ЭтотОбъект.Документ.Проведен = Истина Тогда 	
	//		crm_RetailCRMОбщий.ВыгрузитьЧекВCRM(ЭтотОбъект.Документ, Ложь, Неопределено, Действие);
	//	КонецЕсли;
	//КонецЕсли;

	//Если crm_RetailCRMПовтИсп.ПолучитьЗначениеКонстанты("ВыгружатьЧеки") = Истина Тогда
	//	Если ЭтотОбъект.СуммаДоплаты = 0 и ЭтотОбъект.РезультатОплаты <> "Отмена" Тогда 
	//		crm_RetailCRMОбщий.ВыгрузитьЧекВCRM(ЭтотОбъект.Документ, Ложь, Неопределено);
	//	КонецЕсли;
	//	
	//	Если ПараметрыЗаписи.РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда 
	//		Если ТекущийОбъект.ПометкаУдаления Тогда 
	//			Отменить = Истина;
	//		КонецЕсли;
	//		Если ТекущийОбъект.ФормаОплаты = Перечисления.ФормыОплаты.Наличная Тогда 
	//			Если ТекущийОбъект.ПолученоНаличными > 0 Тогда
	//				Если ЭтотОбъект.СуммаДоплаты = 0 и ЭтотОбъект.РезультатОплаты <> "Отмена" Тогда 
	//					crm_RetailCRMОбщий.ВыгрузитьЧекВCRM(ЭтотОбъект.Документ, Истина, Неопределено, Ложь, Неопределено);
	//				КонецЕсли;
	//			КонецЕсли;
	//		КонецЕсли;	
	//	ИначеЕсли ПараметрыЗаписи.РежимЗаписи = РежимЗаписиДокумента.ОтменаПроведения Тогда
	//		Отменить = Истина;
	//		crm_RetailCRMОбщий.ВыгрузитьЗаказВCRM(ТекущийОбъект.Ссылка,Отменить, Неопределено);
	//	КонецЕсли;
	//КонецЕсли;
	
КонецПроцедуры
