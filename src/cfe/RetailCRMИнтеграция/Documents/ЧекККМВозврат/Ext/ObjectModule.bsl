﻿
&После("ОбработкаПроведения")
Процедура crm_ОбработкаПроведения(Отказ, РежимПроведения)
	
	Если crm_RetailCRMПовтИсп.ПолучитьЗначениеКонстанты("ВыгружатьЧекВозврат") = Истина Тогда
		Попытка
			crm_RetailCRMОбщий.ВыгрузитьЧекВозвратВCRM(ЭтотОбъект);
		Исключение
			Сообщить("Чек не был выгружен в RetailCRM");
		КонецПопытки;
	КонецЕсли;
	
КонецПроцедуры
