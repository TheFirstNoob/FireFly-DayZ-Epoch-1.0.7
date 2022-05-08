/*
	"Подрыв Заправки" Ивент от JasonTM
	Автор оригинала: juandayz "Случайные взрывы на заправках" Ивент.
	Оригинальный "crate visited" маркер система от Payden
	Модификация для DayZ Epoch 1.0.7+ от JasonTM
	Последнее обновление: 06-01-2021
	
	***ВНИМАНИЕ: Ивент работает с позициями карты Napf. Смотрите координаты ниже и меняйте под себя.
*/

local _spawnChance		= 	1;				// Вероятность ивента в процентах. Число должно быть от 0 до 1. 1 = вероятность 100%.
local _timeout 			= 	-1; 			// Время на исчезновение ивента, если игрок не нашел его (В Минутах). Установите значение -1, чтобы отключить.
local _delay 			= 	25; 			// Время через которое взорвется заправка (В минутах). Выбирается случайно от 0 до _delay
local _debug 			= 	true; 			// Включить режим диагностики? (Серверный RPT) (True - Да/False - Нет)
local _lowerGrass 		= 	false; 			// Убирать траву в зоне Заправки? (True - Да/False - Нет)
local _visitMark 		= 	false; 			// Ставить отметку (галочку) "Посещено" если игрок находится рядом с ящиком? (True - Да/False - Нет)
local _distance 		= 	20; 			// Расстояние (В Метрах) от Заправки до того, как ящик считается «Посещенным».
local _nameMarker 		= 	false; 			// Center marker with the name of the mission.
local _type 			= 	"titleText"; 	// Тип вывода оповещения. Параметры: "Hint","TitleText". ***ВНИМАНИЕ: Hint появляется в том же месте экрана, что и обычные Hint где Дебаг монитор.
local _spawn_fire 		= 	true;			// Создать Дым/Огонь после Взрыва? (True - Да/False - Нет)
local _fade_fire 		= 	false;			// Дым/Огонь исчезнет со временем?
local _disableDMGPump 	= 	false;			// Отключать урон по Заправочным колонкам? (True - Да. Игроки смогут заправляться и т.п./False - Нет. Игроки смогут заправляться и т.п.)

#define TITLE_COLOR "#00FF11" 	// Hint параметры: Цвет верхней линии
#define TITLE_SIZE "2" 			// Hint параметры: Размер верхней линии
#define IMAGE_SIZE "4" 			// Hint параметры: Размер изображения

// Вы можете настроить эти варианты лута по своему вкусу. Но Только magazine/item слот class name, Нельзя Оружие и Инструменты.
// Массивы - это случайное от 1 до указанное количество каждого элемента и название класса элемента.
/*
local _lootArrays = [
	[[6,"full_cinder_wall_kit"],[1,"cinder_door_kit"],[1,"cinder_garage_kit"],[4,"forest_large_net_kit"]],
	[[6,"metal_floor_kit"],[6,"ItemWoodFloor"],[2,"ItemWoodStairs"],[10,"ItemSandbag"]],
	[[24,"CinderBlocks"],[8,"MortarBucket"]]
];
*/

// Vehicle Upgrade kits
local _lootArrays = [
/*Truck*/		[["ItemTruckORP",1],["ItemTruckAVE",1],["ItemTruckLRK",1],["ItemTruckTNK",1],["PartEngine",2],["PartWheel",6],["ItemScrews",8],["PartGeneric",10],["equip_metal_sheet",5],["ItemWoodCrateKit",2],["PartFueltank",3],["ItemGunRackKit",2],["ItemFuelBarrel",2]],
/*Vehicle*/		[["ItemORP",1],["ItemAVE",1],["ItemLRK",1],["ItemTNK",1],["PartEngine",2],["PartWheel",4],["ItemScrews",8],["equip_metal_sheet",6],["PartGeneric",8],["ItemWoodCrateKit",2],["ItemGunRackKit",2],["PartFueltank",2],["ItemFuelBarrel",1]],
/*Helicopter*/	[["ItemHeliAVE",1],["ItemHeliLRK",1],["ItemHeliTNK",1],["equip_metal_sheet",5],["ItemScrews",2],["ItemTinBar",3],["equip_scrapelectronics",5],["equip_floppywire",5],["PartGeneric",4],["ItemWoodCrateKit",1],["ItemGunRackKit",1],["ItemFuelBarrel",1]],
/*Tank-APC*/	[["ItemTankORP",1],["ItemTankAVE",1],["ItemTankLRK",1],["ItemTankTNK",1],["PartEngine",6],["PartGeneric",6],["ItemScrews",6],["equip_metal_sheet",8],["ItemWoodCrateKit",2],["ItemGunRackKit",2],["PartFueltank",6],["ItemFuelBarrel",4]]
];

diag_log "[Подрыв Заправки]: Запуск...";

if (random 1 > _spawnChance and !_debug) exitWith {};

local _loot = _lootArrays call BIS_fnc_selectRandom;
local _rndDelay = (random _delay);

// ИНИЦИАЛИЗАЦИЯ КООРДИНАТ (NAPF)
if (isNil "FuelStationEventArray") then
{
	FuelStationEventArray 	=
	[
		// [Угол техники, [Позиция X, Z, Y], Имя]
		 [21,	[8897,16165,	0],		"Ленцбург"]
		,[198,	[9670,15655,	0],		"Ленцбург"]
		,[2,	[5884,15590,	0],		"Зельтисберг"]
		,[80,	[6305,13722,	0],		"Нойе Велт"]
		,[245,	[13963,14150,	0],		"Люцерн"]
		,[189,	[14770,13779,	0],		"Люцерн"]
		,[266,	[14297,12599,	0],		"Вольхузен"]
		,[115,	[15163,15970,	0],		"Северный Аэропорт"]
		,[304,	[12933,9940,	0],		"Листаль"]
		,[87,	[6506,9611,		0],		"Мюнхенштайн"]
		,[221,	[7702,9319,		0],		"Хацбах"]
		,[83,	[8908,5309,		0],		"Шанген"]
		,[42,	[3740,7867,		0],		"Мюнзинген"]
	];
};

// Не создаем ивент если игрок рядом с выбранной заправкой. Сделаем сначала проверку.
local _validSpot 	= 	false;
local _random 		= 	[];
local _pos 			= 	[0,0,0];

while {!_validSpot} do {
	_random 	= 	FuelStationEventArray call BIS_fnc_selectRandom;
	_pos 		= 	_random select 1;
	{
		if (isPlayer _x && _x distance _pos >= 100) then
		{
			_validSpot 	= 	true
		};
	} count playableUnits; 	// Игроки находятся на расстоянии не менее 100 метров.
};

local _dir 		= 	_random select 0;
local _name 	= 	_random select 2;

diag_log format["[Подрыв Заправки]: Появился на позиции: %1",_pos];

if (_debug) then
{
	diag_log format["[Подрыв Заправки]: Создаем Грузовик на позиции: %1, Угол: %2, Место: 3% Выбранная задержка: %4",_pos,_dir,_name,_rndDelay];
};

// Удалим текущее местоположение из массива, чтобы не было повторов
{
	if (_name == (_x select 2)) exitWith
	{
		FuelStationEventArray 	= 	[FuelStationEventArray,_forEachIndex] call fnc_deleteAt;
	};
} forEach FuelStationEventArray;

// Если все позиции были удалены, то сбросим исходный массив, уничтожив глобальную переменную
if (count FuelStationEventArray == 0) then
{
	FuelStationEventArray 	= 	nil;
};

if (_type == "Hint") then
{
	local _img 		= 	(getText (configFile >> "CfgVehicles" >> "ItemFuelBarrel" >> "picture"));
	RemoteMessage 	= 	["hintWithImage",["STR_CL_ESE_FUELBOMB_TITLE",["STR_CL_ESE_FUELBOMB_START", _name, _rndDelay]],[_img,TITLE_COLOR,TITLE_SIZE,IMAGE_SIZE]];
}
else
{
	//RemoteMessage = ["titleText",["STR_CL_ESE_FUELBOMB_START", _name, _rndDelay]];
	RemoteMessage = ["titleText",["%1 %2", _name, _rndDelay]];
};
publicVariable "RemoteMessage";

// Создаем Грузовик
local _class 	= 
[
	 "UralRefuel_CDF_DZE"
	,"KamazRefuel_DZ"
	,"MtvrRefuel_DZ"
	,"V3S_Refuel_TK_GUE_EP1_DZ"
] call BIS_fnc_selectRandom;

local _truck 	= 	_class createVehicle _pos;
_truck setDir _dir;
_truck setPos _pos;
_truck setVehicleLock "locked";
_truck setVariable ["CharacterID","9999",true];
_truck setVariable ["permaLoot", true];

if (_disableDMGPump) then
{
	{
		_x allowDamage false;
	} count (_pos nearObjects ["Land_A_FuelStation_Feed",30]);
};

local _time 		= diag_tickTime;
local _done 		= false;
local _visited 		= false;
local _isNear 		= true;
local _spawned 		= false;
//local _lootArray 	= [];
//local _grassArray = [];
local _lootRad 		= 0;
local _lootPos 		= [0,0,0];
local _lootVeh 		= objNull;
local _lootArray 	= [];
local _grass 		= objNull;
local _grassArray 	= [];
local _markers 		= [1,1,1];

if (_debug) then
{
	diag_log format["[Подрыв Заправки]: Параметры получены. Настройка завершена, Ожидаю %1 минут для timeout",_timeout];
};

//[position,createMarker,setMarkerColor,setMarkerType,setMarkerShape,setMarkerBrush,setMarkerSize,setMarkerText,setMarkerAlpha]
_markers set [0, [_pos,"fuel" + str _time,"","Tank","","",[],[],1]];

if (_nameMarker) then
{
	_markers set [1, [_pos,"explosion" + str _time,"ColorBlack","mil_dot","ICON","",[],["STR_CL_ESE_FUELBOMB_TITLE"],0]];
};
DZE_ServerMarkerArray set [count DZE_ServerMarkerArray, _markers]; 	// Маркера добавляются в запросы JIP игроков.
local _markerIndex 		= 	count DZE_ServerMarkerArray - 1;
PVDZ_ServerMarkerSend 	= 	["start",_markers];
publicVariable "PVDZ_ServerMarkerSend";

// Запуск Мониторинга
while {!_done} do {
	uiSleep 3;

	if (_visitMark && !_visited) then
	{
		{
			if (isPlayer _x && {_x distance _pos <= _distance}) exitWith
			{
				_visited 				= 	true;
				_markers set [2, [[(_pos select 0), (_pos select 1) + 25],"fuelVmarker" + str _time,"ColorBlack","hd_pickup","ICON","",[],[],0]];
				PVDZ_ServerMarkerSend 	= 	["createSingle",(_markers select 2)];
				publicVariable "PVDZ_ServerMarkerSend";
				DZE_ServerMarkerArray set [_markerIndex,_markers];
			};
		} count playableUnits;
	};
	
	if (!_spawned && {diag_tickTime - _time >= _rndDelay * 60}) then
	{
		if (_type == "Hint") then
		{
			RemoteMessage = ["hintNoImage",["STR_CL_ESE_FUELBOMB_TITLE",["STR_CL_ESE_FUELBOMB_END",_name]],[TITLE_COLOR,TITLE_SIZE]];
		} else {
			//RemoteMessage = ["titleText",["STR_CL_ESE_FUELBOMB_END",_name]];
			RemoteMessage = ["titleText",["%1 %2",_name, _rndDelay]];
		};
		publicVariable "RemoteMessage";
		
		deleteVehicle _truck;
		uiSleep 1;
		
		// Взрываем технику
		"Bo_GBU12_LGB" createVehicle _pos;
		uiSleep 1;
		"Bo_GBU12_LGB" createVehicle _pos;
		uiSleep 3;
		
		local _crash 	= 	"UralWreck" createVehicle [0,0,0];
		_crash setDir _dir;
		_crash setPos _pos;
		_crash setVariable ["permaLoot",true];
		
		if (_spawn_fire) then
		{
			PVDZ_obj_Fire = [_crash, 6, time, false, _fade_fire];
			publicVariable "PVDZ_obj_Fire";
		};
		
		// Создаем лут у Техники (рядом_
		{
			for "_i" from 1 to (_x select 1) do {
				_lootRad 	= 	(random 10) + 4;
				_lootPos 	= 	[_pos, _lootRad, random 360] call BIS_fnc_relPos;
				_lootPos set [2,0];
				_lootVeh 	= 	createVehicle ["WeaponHolder",_lootPos,[],0,"CAN_COLLIDE"];
				_lootVeh setVariable ["permaLoot",true];
				_lootVeh addMagazineCargoGlobal [(_x select 0), 1];
				_lootArray set[count _lootArray,_lootVeh];
				
				if (_lowerGrass) then
				{
					_grass 	= 	createVehicle ["ClutterCutter_small_2_EP1", _lootPos, [], 0, "CAN_COLLIDE"];
					_grassArray set[count _grassArray, _grass];
				};
			};
		} count _loot;
		
		// Сбросим таймер как только появиться лут
		_time 		= 	diag_tickTime;
		_spawned 	= 	true;
	};
	
	if (_spawned && {_timeout != -1}) then
	{
		if (diag_tickTime - _time >= _timeout*60) then
		{
			_done 	= 	true;
		};
	};
};

while {_isNear} do {
	uiSleep 3;

	_isNear 	= 	false;
	{
		if (isPlayer _x && _x distance _box <= _distance) exitWith
		{
			_isNear = true;
		};
	} count playableUnits;
};

// Чистим
{
	deleteVehicle _x;
} count _lootArray;

if (count _grassArray > 0) then
{
	{
		deleteVehicle _x;
	} count _grassArray;
};

// Передаем всем клиентам что маркер нужно удалить
local _remove 	= 	[];
{
	if (typeName _x == "ARRAY") then
	{
		_remove set [count _remove,(_x select 1)];
	};
} count _markers;
PVDZ_ServerMarkerSend 	= 	["end",_remove];
publicVariable "PVDZ_ServerMarkerSend";
DZE_ServerMarkerArray set [_markerIndex,-1];

diag_log "[Подрыв Заправки]: Завершено!";