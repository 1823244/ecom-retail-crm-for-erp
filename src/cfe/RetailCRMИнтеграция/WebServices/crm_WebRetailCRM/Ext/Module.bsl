﻿
Функция EditOrder(Order)
	
	Если order <> Неопределено и ЗначениеЗаполнено(order) Тогда 	
		//Интаро_Общий.УстановитьЗначениеКонстанты("НомерЗагруженногоЗаказа",СокрЛП(order.idOrder));
		//Ответ = CRM_Общий.РедактироватьЗаказ(order);
		//Интаро_Общий.УстановитьЗначениеКонстанты("НомерЗагруженногоЗаказа","");
		Сообщить("Получилось!");
		Результат     = Order;
		//
		ОбработкаВыгрузки = crm_RetailCRMОбработка.Создать();	
		ОбработкаВыгрузки.Мод_ЗагрузитьЗаказПоИД(Order);
	
	    Возврат Результат;
	Иначе 
		Сообщить("Что то пошло не так!");
		Возврат 1;
	КонецЕсли;

КонецФункции
