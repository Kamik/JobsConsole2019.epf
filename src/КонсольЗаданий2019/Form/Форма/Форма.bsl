﻿
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Попытка
		Если АвтообновлениеСпискаРегламентныхЗаданий = Истина Тогда
			ПодключитьОбработчикОжидания("ОбработчикАвтообновленияРегламентныхЗаданий", ПериодАвтообновленияСпискаРегламентныхЗаданий);	
		КонецЕсли;		
		
		Если АвтообновлениеСпискаФоновыхЗаданий = Истина Тогда
			ПодключитьОбработчикОжидания("ОбработчикАвтообновленияФоновыхЗаданий", ПериодАвтообновленияСпискаФоновыхЗаданий);	
		КонецЕсли;		
		
		ОбновитьСписокРегламентныхЗаданий();
		ОбновитьСписокФоновыхЗаданий();
	Исключение	
		ПоказатьИнформациюОбОшибке(ИнформацияОбОшибке());
	КонецПопытки;

КонецПроцедуры

&НаСервере
Процедура ОбновитьСписокРегламентныхЗаданий()
	Перем ТекущийИдентификатор;
	
	ТекущаяСтрока = Элементы.СписокРегламентныхЗаданий.ТекущаяСтрока;
	Если ТекущаяСтрока <> Неопределено Тогда
		ТекСтрока = СписокРегламентныхЗаданий.НайтиПоИдентификатору(ТекущаяСтрока);
		ТекущийИдентификатор = ТекСтрока.Идентификатор;
	КонецЕсли;
	
	Идентификаторы = Новый Массив;
	
	ВыделенныеСтроки = Элементы.СписокРегламентныхЗаданий.ВыделенныеСтроки;
	Для Каждого ВыделеннаяСтрока из ВыделенныеСтроки Цикл
		ТекСтрока = СписокРегламентныхЗаданий.НайтиПоИдентификатору(ВыделеннаяСтрока);
		Идентификаторы.Добавить(ТекСтрока.Идентификатор);
	КонецЦикла;
	
	СписокРегламентныхЗаданий.Очистить();
	
	Отбор = Неопределено;
	Если ОтборРегламентныхЗаданийВключен = Истина Тогда
		Отбор = ОтборРегламентныхЗаданий;
	КонецЕсли;
	
	Попытка
		Регламентные = РегламентныеЗадания.ПолучитьРегламентныеЗадания(Отбор);
	Исключение
		//Элементы.СписокРегламентныхЗаданий.Доступность = Ложь;
		Возврат;
	КонецПопытки;
	
	//Элементы.СписокРегламентныхЗаданий.Доступность = Истина;
	
	Для Каждого Регламентное из Регламентные Цикл
		НоваяСтрока = СписокРегламентныхЗаданий.Добавить();
		НоваяСтрока.Метаданные = Регламентное.Метаданные.Представление();
		НоваяСтрока.Наименование = Регламентное.Наименование;
		НоваяСтрока.Ключ = Регламентное.Ключ;
		НоваяСтрока.Расписание = Регламентное.Расписание;
		НоваяСтрока.Пользователь = Регламентное.ИмяПользователя;
		НоваяСтрока.Предопределенное = Регламентное.Предопределенное;
		НоваяСтрока.Использование = Регламентное.Использование;
		НоваяСтрока.Идентификатор = Регламентное.УникальныйИдентификатор;
		
		Попытка
			ПоследнееЗадание = Регламентное.ПоследнееЗадание;
		Исключение
			ПоследнееЗадание = Неопределено;
		КонецПопытки;
		
		Если ПоследнееЗадание <> Неопределено Тогда
			НоваяСтрока.Выполнялось = ПоследнееЗадание.Начало;
			НоваяСтрока.Состояние = ПоследнееЗадание.Состояние;
		КонецЕсли;
	КонецЦикла;
	
	СписокРегламентныхЗаданий.Сортировать("Метаданные");
	
	Если ТекущийИдентификатор <> Неопределено Тогда
		Строки = СписокРегламентныхЗаданий.НайтиСтроки(Новый Структура("Идентификатор", ТекущийИдентификатор));
		Если Строки.Количество() > 0 Тогда
			Элементы.СписокРегламентныхЗаданий.ТекущаяСтрока = Строки[0].ПолучитьИдентификатор();
		КонецЕсли;
	КонецЕсли;

	Если Идентификаторы.Количество() > 0 Тогда
		ВыделенныеСтроки.Очистить();
	КонецЕсли;
	
	Для Каждого Идентификатор из Идентификаторы Цикл
		Строки = СписокРегламентныхЗаданий.НайтиСтроки(Новый Структура("Идентификатор", ТекущийИдентификатор));
		Если Строки.Количество() > 0 Тогда
			ВыделенныеСтроки.Добавить(Строки[0].ПолучитьИдентификатор());
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьСписокФоновыхЗаданий(ИдентификаторНовогоЗадания = Неопределено)
	Перем ТекущийИдентификатор;
	
	ТекущаяСтрока = Элементы.СписокФоновыхЗаданий.ТекущаяСтрока;
	Если ТекущаяСтрока <> Неопределено Тогда
		ТекСтрока = СписокФоновыхЗаданий.НайтиПоИдентификатору(ТекущаяСтрока);
		ТекущийИдентификатор = ТекСтрока.Идентификатор;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ИдентификаторНовогоЗадания) Тогда
		ТекущийИдентификатор = ИдентификаторНовогоЗадания;
	КонецЕсли;
	
	Идентификаторы = Новый Массив;
	
	ВыделенныеСтроки = Элементы.СписокФоновыхЗаданий.ВыделенныеСтроки;
	Для Каждого ВыделеннаяСтрока из ВыделенныеСтроки Цикл
		ТекСтрока = СписокФоновыхЗаданий.НайтиПоИдентификатору(ВыделеннаяСтрока);
		Идентификаторы.Добавить(ТекСтрока.Идентификатор);
	КонецЦикла;

	СписокФоновыхЗаданий.Очистить();
	
	Отбор = Неопределено;
	Если ОтборФоновыхЗаданийВключен = Истина Тогда
		Отбор = ОтборФоновыхЗаданий.Получить();
	КонецЕсли;
	
	Попытка
		Фоновые = ФоновыеЗадания.ПолучитьФоновыеЗадания(Отбор);
	Исключение
		//Элементы.СписокФоновыхЗаданий.Доступность = Ложь;
		Возврат;
	КонецПопытки;
	
	//Элементы.СписокФоновыхЗаданий.Доступность = Истина;
	Для Каждого Фоновое из Фоновые Цикл
		НоваяСтрока = СписокФоновыхЗаданий.Добавить();
		
		Если СписокФоновыхЗаданий.Индекс(НоваяСтрока) < 42 Тогда
			РегламентноеЗадание = Фоновое.РегламентноеЗадание;
			Если РегламентноеЗадание <> Неопределено Тогда
				Строка = РегламентноеЗадание.Метаданные.Имя;
				Если РегламентноеЗадание.Наименование <> "" Тогда
					Строка = Строка + ":" +	РегламентноеЗадание.Наименование;
				КонецЕсли;
				
				НоваяСтрока.Регламентное = Строка;
			КонецЕсли;
			НоваяСтрока.Сообщения = Фоновое.ПолучитьСообщенияПользователю().Количество();
		Иначе
			НоваяСтрока.Регламентное = Фоновое.УникальныйИдентификатор;
		КонецЕсли;
			
		НоваяСтрока.Наименование = Фоновое.Наименование;
		НоваяСтрока.Ключ = Фоновое.Ключ;
		НоваяСтрока.Метод = Фоновое.ИмяМетода;
		НоваяСтрока.Состояние = Фоновое.Состояние;
		НоваяСтрока.Начало = Фоновое.Начало;
		НоваяСтрока.Конец = Фоновое.Конец;
		НоваяСтрока.Сервер = Фоновое.Расположение;
		
		Если Фоновое.ИнформацияОбОшибке <> Неопределено Тогда
			НоваяСтрока.Ошибки = Фоновое.ИнформацияОбОшибке.Описание;
		КонецЕсли;
		
		НоваяСтрока.Идентификатор = Фоновое.УникальныйИдентификатор;
		НоваяСтрока.СостояниеЗадания = Фоновое.Состояние;
	КонецЦикла;
	
	Если ТекущийИдентификатор <> Неопределено Тогда
		Строки = СписокФоновыхЗаданий.НайтиСтроки(Новый Структура("Идентификатор", ТекущийИдентификатор));
		Если Строки.Количество() > 0 Тогда
			Элементы.СписокФоновыхЗаданий.ТекущаяСтрока = Строки[0].ПолучитьИдентификатор();
		КонецЕсли;
	КонецЕсли;

	Если Идентификаторы.Количество() > 0 Тогда
		ВыделенныеСтроки.Очистить();
	КонецЕсли;
	
	Для Каждого Идентификатор из Идентификаторы Цикл
		Строки = СписокФоновыхЗаданий.НайтиСтроки(Новый Структура("Идентификатор", ТекущийИдентификатор));
		Если Строки.Количество() > 0 Тогда
			ВыделенныеСтроки.Добавить(Строки[0].ПолучитьИдентификатор());
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьРегламентныеЗадания(Команда)
	ОбновитьСписокРегламентныхЗаданий();
КонецПроцедуры

&НаКлиенте
Процедура Расписание(Команда)
	ВыделенныеСтроки = Элементы.СписокРегламентныхЗаданий.ВыделенныеСтроки;
	Если ВыделенныеСтроки.Количество() > 0 Тогда
		
		Строка = СписокРегламентныхЗаданий.НайтиПоИдентификатору(ВыделенныеСтроки.Получить(0));
		Расписание = ПолучитьРасписаниеРегламентногоЗадания(Строка.Идентификатор);
		Диалог = Новый ДиалогРасписанияРегламентногоЗадания(Расписание);
		ОписаниеОповещенияОЗакрытии = Новый ОписаниеОповещения("ДиалогРасписанияРегламентногоЗаданияОткрытьЗавершение", ЭтаФорма);
		
		Диалог.Показать(ОписаниеОповещенияОЗакрытии);

	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ДиалогРасписанияРегламентногоЗаданияОткрытьЗавершение(Расписание, ДополнительныеПараметры) Экспорт
	Если Расписание <> Неопределено Тогда
		ВыделенныеСтроки = Элементы.СписокРегламентныхЗаданий.ВыделенныеСтроки;
		Если ВыделенныеСтроки.Количество() > 0 Тогда
			Строка = СписокРегламентныхЗаданий.НайтиПоИдентификатору(ВыделенныеСтроки.Получить(0));
			УстановитьРасписаниеРегламентногоЗадания(Строка.Идентификатор, Строка.Наименование, Расписание, Строка.Метаданные);
			Строка.Расписание = Расписание;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СписокРегламентныхЗаданийПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	Отказ = Истина;
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("ИдентификаторЗадания", "");
	
	ОписаниеОповещенияОЗакрытии = Новый ОписаниеОповещения("СписокРегламентныхЗаданийПередНачаломДобавленияЗавершение", ЭтаФорма);
	
	ОткрытьФорму(ПолучитьПолноеИмяФормы("ДиалогРегламентногоЗадания"), СтруктураПараметров, ЭтаФорма,,,,ОписаниеОповещенияОЗакрытии, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
КонецПроцедуры

&НаКлиенте
Процедура СписокРегламентныхЗаданийПередНачаломДобавленияЗавершение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	Если РезультатЗакрытия <> Неопределено Тогда
		ОбновитьСписокРегламентныхЗаданий();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СписокРегламентныхЗаданийПередНачаломИзменения(Элемент, Отказ)
	Отказ = Истина;
	ВыделенныеСтроки = Элементы.СписокРегламентныхЗаданий.ВыделенныеСтроки;
	Если ВыделенныеСтроки.Количество() > 0 Тогда
		
		Строка = СписокРегламентныхЗаданий.НайтиПоИдентификатору(ВыделенныеСтроки.Получить(0));
		
		СтруктураПараметров = Новый Структура;
		Ид = Строка.Идентификатор;
		СтруктураПараметров.Вставить("ИдентификаторЗадания", Ид);
	
		ОписаниеОповещенияОЗакрытии = Новый ОписаниеОповещения("СписокРегламентныхЗаданийПередНачаломИзмененияЗавершение", ЭтаФорма);
		
		ОткрытьФорму(ПолучитьПолноеИмяФормы("ДиалогРегламентногоЗадания"), СтруктураПараметров, ЭтаФорма,,,,ОписаниеОповещенияОЗакрытии, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);

	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СписокРегламентныхЗаданийПередНачаломИзмененияЗавершение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	Если РезультатЗакрытия <> Неопределено Тогда
		ОбновитьСписокРегламентныхЗаданий();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте 
Функция ПолучитьПолноеИмяФормы(ИмяФормы) 
	Возврат Лев(ЭтаФорма.ИмяФормы, Найти(ЭтаФорма.ИмяФормы,".Форма.")+6) + ИмяФормы; 
КонецФункции

&НаКлиенте
Процедура СписокРегламентныхЗаданийПередУдалением(Элемент, Отказ)
	Попытка
		Отказ = Истина;
		УдалитьРегламентноеЗадание();
		
		ОбновитьСписокРегламентныхЗаданий();
	Исключение
		ПоказатьИнформациюОбОшибке(ИнформацияОбОшибке());
	КонецПопытки;
КонецПроцедуры

&НаСервере
Процедура УдалитьРегламентноеЗадание()
	ВыделенныеСтроки = Элементы.СписокРегламентныхЗаданий.ВыделенныеСтроки;
	Для Каждого Стр из ВыделенныеСтроки Цикл
		Строка = СписокРегламентныхЗаданий.НайтиПоИдентификатору(Стр);
		
		РегламентноеЗадание = РеквизитФормыВЗначение("Объект").ПолучитьОбъектРегламентногоЗадания(Строка.Идентификатор);
		Если РегламентноеЗадание.Предопределенное Тогда
			ВызватьИсключение("Нельзя удалить предопределенное задание: " + РегламентноеЗадание.Наименование);
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого Стр из ВыделенныеСтроки Цикл
		Строка = СписокРегламентныхЗаданий.НайтиПоИдентификатору(Стр);
		РегламентноеЗадание = РеквизитФормыВЗначение("Объект").ПолучитьОбъектРегламентногоЗадания(Строка.Идентификатор);
		РегламентноеЗадание.Удалить();
	КонецЦикла
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьФоновыеЗадания(Команда)
	ОбновитьСписокФоновыхЗаданий();
КонецПроцедуры

&НаКлиенте
Процедура СписокФоновыхЗаданийПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	Отказ = Истина;
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("ИдентификаторЗадания", "");

	ОписаниеОповещенияОЗакрытии = Новый ОписаниеОповещения("СписокФоновыхЗаданийПередНачаломДобавленияЗавершение", ЭтаФорма);
	
	ОткрытьФорму(ПолучитьПолноеИмяФормы("ДиалогФоновогоЗадания"), СтруктураПараметров, ЭтаФорма,,,,ОписаниеОповещенияОЗакрытии, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
КонецПроцедуры

&НаКлиенте
Процедура СписокФоновыхЗаданийПередНачаломДобавленияЗавершение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	Если РезультатЗакрытия <> Неопределено Тогда
	    ОбновитьСписокФоновыхЗаданий();			
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция ПолучитьРасписаниеРегламентногоЗадания(УникальныйНомерЗадания)
	ОбъектЗадания = РеквизитФормыВЗначение("Объект").ПолучитьОбъектРегламентногоЗадания(УникальныйНомерЗадания);
	Если ОбъектЗадания = Неопределено Тогда
		Возврат Новый РасписаниеРегламентногоЗадания;
	КонецЕсли;
	
	Возврат ОбъектЗадания.Расписание;
КонецФункции

&НаСервере
Функция УстановитьРасписаниеРегламентногоЗадания(Идентификатор, Наименование, Расписание, ИмяЗадания)
	ОбъектЗадания = РеквизитФормыВЗначение("Объект").ПолучитьОбъектРегламентногоЗадания(Идентификатор);		
	Если ОбъектЗадания = Неопределено Тогда
		РедОбъектЗадания = РегламентныеЗадания.СоздатьРегламентноеЗадание(ИмяЗадания);
		РедОбъектЗадания.Наименование = Наименование;
		РедОбъектЗадания.Использование = Истина;
	Иначе
		РедОбъектЗадания = ОбъектЗадания;
	КонецЕсли;
	
	РедОбъектЗадания.Расписание = Расписание;
	Попытка
		РедОбъектЗадания.Записать();
	Исключение
		ВызватьИсключение "Произошла ошибка при сохранении расписания выполнения обменов. Возможно данные расписания были изменены. Закройте форму настройки и повторите попытку изменения расписания еще раз.
		|Подробное описание ошибки: " + ОписаниеОшибки();
	КонецПопытки;
	
	Возврат Истина;
КонецФункции

&НаКлиенте
Процедура СписокФоновыхЗаданийПередНачаломИзменения(Элемент, Отказ)
	Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура СписокФоновыхЗаданийПередУдалением(Элемент, Отказ)
	Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьФоновоеЗадание(Команда)
	Отказ = Истина;
	Попытка
		ОтменитьФоновыеЗадания();
		ОбновитьСписокФоновыхЗаданий();
	Исключение	
		ПоказатьИнформациюОбОшибке(ИнформацияОбОшибке());
	КонецПопытки;
КонецПроцедуры

&НаСервере
Процедура ОтменитьФоновыеЗадания()
	ВыделенныеСтроки = Элементы.СписокФоновыхЗаданий.ВыделенныеСтроки;
	Для Каждого Стр из ВыделенныеСтроки Цикл
		Строка = СписокФоновыхЗаданий.НайтиПоИдентификатору(Стр);
		ТекИдентификатор = Новый УникальныйИдентификатор(Строка.Идентификатор);
		ФоновоеЗадание = ФоновыеЗадания.НайтиПоУникальномуИдентификатору(ТекИдентификатор);
		ФоновоеЗадание.Отменить();
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура НастройкаСпискаРегламентныхЗаданий(Команда)
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("Автообновление", АвтообновлениеСпискаРегламентныхЗаданий);
	СтруктураПараметров.Вставить("ПериодАвтообновления", ПериодАвтообновленияСпискаРегламентныхЗаданий);
	
	ОписаниеОповещенияОЗакрытии = Новый ОписаниеОповещения("НастройкаСпискаРегламентныхЗаданийЗавершение", ЭтаФорма);
	
	ОткрытьФорму(ПолучитьПолноеИмяФормы("ДиалогНастроекСписка"), СтруктураПараметров, ЭтаФорма,,,,ОписаниеОповещенияОЗакрытии, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
КонецПроцедуры

&НаКлиенте
Процедура НастройкаСпискаРегламентныхЗаданийЗавершение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	Если ТипЗнч(РезультатЗакрытия) = Тип("Структура") Тогда
		АвтообновлениеСпискаРегламентныхЗаданий = РезультатЗакрытия.Автообновление;
		ПериодАвтообновленияСпискаРегламентныхЗаданий = РезультатЗакрытия.ПериодАвтообновления;
		
		ОтключитьОбработчикОжидания("ОбработчикАвтообновленияРегламентныхЗаданий");
		Если АвтообновлениеСпискаРегламентныхЗаданий = Истина Тогда
			ПодключитьОбработчикОжидания("ОбработчикАвтообновленияРегламентныхЗаданий", ПериодАвтообновленияСпискаРегламентныхЗаданий);	
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура НастройкаСпискаФоновыхЗаданий(Команда)
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("Автообновление", АвтообновлениеСпискаФоновыхЗаданий);
	СтруктураПараметров.Вставить("ПериодАвтообновления", ПериодАвтообновленияСпискаФоновыхЗаданий);
	
	ОписаниеОповещенияОЗакрытии = Новый ОписаниеОповещения("НастройкаСпискаФоновыхЗаданийЗавершение", ЭтаФорма);
	
	ОткрытьФорму(ПолучитьПолноеИмяФормы("ДиалогНастроекСписка"), СтруктураПараметров, ЭтаФорма,,,,ОписаниеОповещенияОЗакрытии, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
КонецПроцедуры

&НаКлиенте
Процедура НастройкаСпискаФоновыхЗаданийЗавершение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	Если ТипЗнч(РезультатЗакрытия) = Тип("Структура") Тогда
		АвтообновлениеСпискаФоновыхЗаданий = РезультатЗакрытия.Автообновление;
		ПериодАвтообновленияСпискаФоновыхЗаданий = РезультатЗакрытия.ПериодАвтообновления;
		
		ОтключитьОбработчикОжидания("ОбработчикАвтообновленияФоновыхЗаданий");
		Если АвтообновлениеСпискаФоновыхЗаданий = Истина Тогда
			ПодключитьОбработчикОжидания("ОбработчикАвтообновленияФоновыхЗаданий", ПериодАвтообновленияСпискаФоновыхЗаданий);	
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОбработчикАвтообновленияФоновыхЗаданий()
	//Попытка
		ОбновитьСписокФоновыхЗаданий();
	//Исключение
	//	// Может возикать ошибка "Неизвестный идентификатор формы"
	//КонецПопытки;
КонецПроцедуры

&НаКлиенте
Процедура ОбработчикАвтообновленияРегламентныхЗаданий()
	//Попытка
		ОбновитьСписокРегламентныхЗаданий();
	//Исключение
	//	// Может возикать ошибка "Неизвестный идентификатор формы"
	//КонецПопытки;
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтборРегламентныхЗаданий(Команда)
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("Отбор", ОтборРегламентныхЗаданий);
	
	ОписаниеОповещенияОЗакрытии = Новый ОписаниеОповещения("УстановитьОтборРегламентныхЗаданийЗавершение", ЭтаФорма);
	
	ОткрытьФорму(ПолучитьПолноеИмяФормы("ДиалогОтбораРегламентногоЗадания"), СтруктураПараметров, ЭтаФорма,,,,ОписаниеОповещенияОЗакрытии, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтборРегламентныхЗаданийЗавершение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	Если ТипЗнч(РезультатЗакрытия) = Тип("Структура") Тогда
		ОтборРегламентныхЗаданий = РезультатЗакрытия;
		ОтборРегламентныхЗаданийВключен = Истина;
		ОбновитьСписокРегламентныхЗаданий();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОтключитьОтборРегламентныхЗаданий(Команда)
	ОтборРегламентныхЗаданийВключен = Ложь;
	ОбновитьСписокРегламентныхЗаданий();
КонецПроцедуры

&НаКлиенте
Процедура ОтключитьОтборФоновыхЗаданий(Команда)
	ОтборФоновыхЗаданийВключен = Ложь;
	ОбновитьСписокФоновыхЗаданий();
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтборФоновыхЗаданий(Команда)
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("Отбор", ОтборФоновыхЗаданий);
	
	ОписаниеОповещенияОЗакрытии = Новый ОписаниеОповещения("УстановитьОтборФоновыхЗаданийЗавершение", ЭтаФорма);
	
	ОткрытьФорму(ПолучитьПолноеИмяФормы("ДиалогОтбораФоновогоЗадания"), СтруктураПараметров, ЭтаФорма,,,,ОписаниеОповещенияОЗакрытии, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтборФоновыхЗаданийЗавершение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	Если ТипЗнч(РезультатЗакрытия) = Тип("ХранилищеЗначения") Тогда
		ОтборФоновыхЗаданий = РезультатЗакрытия;
		ОтборФоновыхЗаданийВключен = Истина;
		ОбновитьСписокФоновыхЗаданий();
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура СписокФоновыхЗаданийПриАктивизацииСтрокиНаСервере(ИдентификаторСтроки)
	ТекущаяСтрока = СписокФоновыхЗаданий.НайтиПоИдентификатору(ИдентификаторСтроки);
	Фоновое = ФоновыеЗадания.НайтиПоУникальномуИдентификатору(ТекущаяСтрока.Идентификатор);
	Если Фоновое <> Неопределено Тогда
		РегламентноеЗадание = Фоновое.РегламентноеЗадание;
		Если Фоновое.РегламентноеЗадание <> Неопределено Тогда
			Строка = РегламентноеЗадание.Метаданные.Имя;
			Если РегламентноеЗадание.Наименование <> "" Тогда
				Строка = Строка + ":" +	РегламентноеЗадание.Наименование;
			КонецЕсли;
			
			ТекущаяСтрока.Регламентное = Строка;
		Иначе
			ТекущаяСтрока.Регламентное = "";
		КонецЕсли;
		ТекущаяСтрока.Сообщения = Фоновое.ПолучитьСообщенияПользователю().Количество();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СписокФоновыхЗаданийПриАктивизацииСтроки(Элемент)
	ТекущаяСтрока = Элементы.СписокФоновыхЗаданий.ТекущаяСтрока;//первые 7
	Если ТекущаяСтрока <> Неопределено Тогда
		Для ИденификаторТекСтроки = ТекущаяСтрока По ТекущаяСтрока Цикл
			ТекСтрока = ЭтаФорма.СписокФоновыхЗаданий.НайтиПоИдентификатору(ИденификаторТекСтроки);
			Если ТекСтрока <> Неопределено И ТипЗнч(ТекСтрока.Регламентное) = Тип("УникальныйИдентификатор") Тогда
				СписокФоновыхЗаданийПриАктивизацииСтрокиНаСервере(ТекСтрока.ПолучитьИдентификатор());
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры


&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	ОтключитьОбработчикОжидания("ОбработчикАвтообновленияФоновыхЗаданий");
	ОтключитьОбработчикОжидания("ОбработчикАвтообновленияРегламентныхЗаданий");
КонецПроцедуры


&НаКлиенте
Процедура ЗапуститьЗадание(Команда)
	ТекущаяСтрока = Элементы.СписокРегламентныхЗаданий.ТекущиеДанные;
	Если ТекущаяСтрока <> Неопределено Тогда
		ЗапуститьЗаданиеНаСервере(ТекущаяСтрока.Идентификатор);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ЗапуститьЗаданиеНаСервере(УникальныйИдентификатор)
	
	Идентификатор = Новый УникальныйИдентификатор(УникальныйИдентификатор);
	Задание = РегламентныеЗадания.НайтиПоУникальномуИдентификатору(Идентификатор);
	//Если Задание.Использование Тогда
		
		//проверка на выполнение в текущий момент
		Отбор=Новый Структура;
		Отбор.Вставить("Ключ",Строка(Задание.УникальныйИдентификатор));
		Отбор.Вставить("Состояние ",СостояниеФоновогоЗадания.Активно);		
		МассивЗаданий=ФоновыеЗадания.ПолучитьФоновыеЗадания(Отбор);
		
		ИдентификаторНовогоЗадания = Неопределено;
		
		Если МассивЗаданий.Количество()=0 Тогда 
			НаименованиеФоновогоЗадания = "Запуск вручную: "+ Задание.Метаданные.Синоним;
			ФоновоеЗадание = ФоновыеЗадания.Выполнить(Задание.Метаданные.ИмяМетода, Задание.Параметры, Строка(Задание.УникальныйИдентификатор), НаименованиеФоновогоЗадания);
			ИдентификаторНовогоЗадания = ФоновоеЗадание.УникальныйИдентификатор;
		Иначе
			Сообщить("Задание уже запущено");
		КонецЕсли;
		
	//КонецЕсли;
	ОбновитьСписокРегламентныхЗаданий();
	ОбновитьСписокФоновыхЗаданий(ИдентификаторНовогоЗадания);
КонецПроцедуры


&НаСервере
Процедура ВыполнитьЗаданиеВручнуюНаСервере(УникальныйИдентификатор)
	Идентификатор = Новый УникальныйИдентификатор(УникальныйИдентификатор);
	Задание = РегламентныеЗадания.НайтиПоУникальномуИдентификатору(Идентификатор);
	
	ИмяМетода = Задание.Метаданные.ИмяМетода;
		
	// Подготовка команды для выполнения метода вместо фонового задания.
	СтрокаПараметров = "";
	Индекс = 0;
	Пока Индекс < Задание.Параметры.Количество() Цикл
		СтрокаПараметров = СтрокаПараметров + "Задание.Параметры[" + Индекс + "]";
		Если Индекс < (Задание.Параметры.Количество()-1) Тогда
			СтрокаПараметров = СтрокаПараметров + ",";
		КонецЕсли;
		Индекс = Индекс + 1;
	КонецЦикла;
	
	Выполнить("" + ИмяМетода + "(" + СтрокаПараметров + ");");

КонецПроцедуры


&НаКлиенте
Процедура ВыполнитьЗаданиеВручную(Команда)
	ТекущаяСтрока = Элементы.СписокРегламентныхЗаданий.ТекущиеДанные;
	Если ТекущаяСтрока <> Неопределено Тогда
		ВыполнитьЗаданиеВручнуюНаСервере(ТекущаяСтрока.Идентификатор);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура СписокФоновыхЗаданийСообщенияВыборНаСервере(ИдентификаторСтроки)
	ТекущаяСтрока = СписокФоновыхЗаданий.НайтиПоИдентификатору(ИдентификаторСтроки);
	Фоновое = ФоновыеЗадания.НайтиПоУникальномуИдентификатору(ТекущаяСтрока.Идентификатор);
	Если Фоновое <> Неопределено Тогда
		СообщенияПользователю = Фоновое.ПолучитьСообщенияПользователю();
		Для Каждого Сообщение Из СообщенияПользователю Цикл;
			Сообщить(Сообщение.Текст);
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СписокФоновыхЗаданийВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	Если Поле.Имя = "СписокФоновыхЗаданийСообщения" Тогда
		СписокФоновыхЗаданийСообщенияВыборНаСервере(ВыбраннаяСтрока);
	КонецЕсли;
КонецПроцедуры
