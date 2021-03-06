﻿
&НаКлиенте
Процедура ОК(Команда)
	ИдентификаторЗадания = Неопределено;
	ВыполнитьФоновоеЗадание(ИдентификаторЗадания);
	Закрыть(ИдентификаторЗадания);
КонецПроцедуры

&НаСервере
Процедура ВыполнитьФоновоеЗадание(ИдентификаторЗадания)
	Попытка	
	    ФоновоеЗадание = ФоновыеЗадания.Выполнить(ИмяМетода,, Ключ, Наименование);
		ИдентификаторЗадания = ФоновоеЗадание.УникальныйИдентификатор;
	Исключение	
		Сообщить(ОписаниеОшибки(), СтатусСообщения.Внимание);
	КонецПопытки;
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ЗаданиеИД = Параметры.ИдентификаторЗадания;
	ФоновоеЗадание = РеквизитФормыВЗначение("Объект").ПолучитьОбъектФоновогоЗадания(ЗаданиеИД);
	Если ФоновоеЗадание <> Неопределено Тогда
		ИмяМетода = ФоновоеЗадание.ИмяМетода;
		Наименование = ФоновоеЗадание.Наименование;
		Ключ = ФоновоеЗадание.Ключ;
	Иначе
		//Ключ = Новый УникальныйИдентификатор;
	КонецЕсли;
КонецПроцедуры
