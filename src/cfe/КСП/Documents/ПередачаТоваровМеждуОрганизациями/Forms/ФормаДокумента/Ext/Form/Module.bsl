﻿&НаКлиенте
Процедура КСП_КСП_ПроцентСкидкиПриИзмененииПосле(Элемент)
	 СтрокаТабличнойЧасти = Элементы.Товары.ТекущиеДанные;  
	 СтрокаТабличнойЧасти.КСП_СправочнаяЦена = СтрокаТабличнойЧасти.Цена; 
	 СтрокаТабличнойЧасти.Цена =СтрокаТабличнойЧасти.Цена -(СтрокаТабличнойЧасти.КСП_ПроцентСкидки/100)*СтрокаТабличнойЧасти.Цена; 
КонецПроцедуры
