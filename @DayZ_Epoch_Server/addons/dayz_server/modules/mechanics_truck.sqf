/*
	"Техника снабжения" Ивент от JasonTM
	Оригинальный "crate visited" маркер система от Payden
	Модификация для DayZ Epoch 1.0.7+ от JasonTM
	Последнее обновление: 07-08-2021
	
	***ВНИМАНИЕ: Ивент создает грузовик или другую технику внутри посторойки "Land_Hangar_2" с определенным лутом.
	Эта техника сохраняется в Базу Данных и Имеет\Не имеет ключ ТОЛЬКО когда игрок сядет в эту Технику.
*/

local _spawnChance 	= 	1; 			// Вероятность ивента в процентах. Число должно быть от 0 до 1. 1 = вероятность 100%.
local _timeout 		= 	-1; 		// Время на исчезновение ивента, если игрок не нашел его (В Минутах). Установите значение -1, чтобы отключить.
local _key 			= 	true; 		// Создавать ключ от техники? (Будет лежать внутри самой Техники) (True - Да/False - Нет)
local _numpacks 	= 	2; 			// Сколько рюкзаков будет создано в Технике? (Число)
local _nameMarker 	= 	false; 		// Добавить название маркера? (True - Да/False - Нет)
local _visitMark 	= 	false; 		// Ставить отметку (галочку) "Посещено" если игрок находится рядом с ящиком? (True - Да/False - Нет)
local _distance 	= 	20; 		// Расстояние (В Метрах) от ящика до того, как ящик считается «Посещенным».
local _type 		= 	"Hint"; 	// Тип вывода оповещения. Параметры: "Hint","TitleText". ***ВНИМАНИЕ: Hint появляется в том же месте экрана, что и обычные Hint где Дебаг монитор.

#define TITLE_COLOR "#00FF11" 		// Hint параметры: Цвет верхней линии
#define TITLE_SIZE "2" 				// Hint параметры: Размер верхней линии
#define IMAGE_SIZE "4" 				// Hint параметры: Размер изображения

#define DEBUG false					// Включить режим диагностики? (Серверный RPT) (True - Да/False - Нет)

diag_log "[Техника снабжения]: Запуск...";

//if (random 1 > _spawnChance and !_debug) exitWith {};

// Получим список всех Ангаров на карте
local _list 	= 	(getMarkerPos "center") nearObjects ["Land_Hangar_2", 20000];

if (count _list == 0) exitWith
{
	diag_log "[Техника снабжения]: На карте нет Land_Hangar_2.";
};

local _garage 	= 	objNull;
local _pos 		= 	[];
local _i 		= 	1;
local _success 	= 	false;

while {_i < 50} do {
	_garage 	= 	_list call BIS_fnc_selectRandom;
	_pos 		= 	getPosATL _garage;
	
	local _nearPlayer 	= 	false;
	{
		if (_x distance _pos < 50) exitWith
		{
			_nearPlayer 	= 	true;
		};
	} count playableUnits;
	
	// Проверяем рядом Технику и Строй.Столбы игроков
	if (count (_pos nearObjects ["LandVehicle", 20]) == 0 && !_nearPlayer && {count (_pos nearEntities ["Plastic_Pole_EP1_DZ", 100]) == 0}) exitWith
	{
		_success = true;
	};
	_i 	= 	_i + 1;
};

if (!_success) exitWith
{
	diag_log "[Техника снабжения]: Подходящие места не найдены.";
};

local _near 	= 	nearestLocations [_pos,["NameCityCapital","NameCity","NameVillage","NameLocal"],1000];
local _loc 		= 	"Неизвестная локация или Лес";

if (count _near > 0) then
{
	_loc = text (_near select 0);
};

diag_log format["[Техника снабжения]: Создаем Технику рядом с: %1, На позции: %2", _loc, _pos];

// Vehicle Upgrade kits - these include all parts to fully upgrade a DZE vehicle.
local _kit = [
	[["ItemTruckORP",1],["ItemTruckAVE",1],["ItemTruckLRK",1],["ItemTruckTNK",1],["PartEngine",2],["PartWheel",6],["ItemScrews",8],["PartGeneric",10],["equip_metal_sheet",5],["ItemWoodCrateKit",2],["PartFueltank",3],["ItemGunRackKit",2],["ItemFuelBarrel",2]],
	[["ItemORP",1],["ItemAVE",1],["ItemLRK",1],["ItemTNK",1],["PartEngine",2],["PartWheel",4],["ItemScrews",8],["equip_metal_sheet",6],["PartGeneric",8],["ItemWoodCrateKit",2],["ItemGunRackKit",2],["PartFueltank",2],["ItemFuelBarrel",1]],
	[["ItemHeliAVE",1],["ItemHeliLRK",1],["ItemHeliTNK",1],["equip_metal_sheet",5],["ItemScrews",2],["ItemTinBar",3],["equip_scrapelectronics",5],["equip_floppywire",5],["PartGeneric",4],["ItemWoodCrateKit",1],["ItemGunRackKit",1],["PartFueltank",2],["ItemFuelBarrel",1]],
	[["ItemTankORP",1],["ItemTankAVE",1],["ItemTankLRK",1],["ItemTankTNK",1],["PartEngine",6],["PartGeneric",6],["ItemScrews",6],["equip_metal_sheet",8],["ItemWoodCrateKit",2],["ItemGunRackKit",2],["PartFueltank",6],["ItemFuelBarrel",4]]
] call BIS_fnc_selectRandom;

// Инструменты.
local _tools = ["ItemToolbox","ItemCrowbar","ItemSolder_DZE"];

// Техника
local _class =
[
	 "Hummer_DZE"
	,"HMMWV_DZ"
	,"HMMWV_Ambulance_DZE"
	,"HMMWV_M1035_DES_EP1_DZE"
	,"Skoda_DZE"
	,"SkodaBlue_DZE"
	,"SkodaRed_DZE"
	,"SkodaGreen_DZE"
	,"UAZ_RU_DZE"
	,"UAZ_CDF_DZE"
	,"UAZ_INS_DZE"
	,"datsun1_civil_1_open_DZE"
	,"datsun1_civil_2_covered_DZE"
	,"datsun1_civil_3_open_DZE"
	,"car_hatchback_DZE"
	,"car_hatchback_red_DZE"
	,"car_sedan_DZE"
	,"Lada1_DZE"
	,"Lada1_TK_CIV_EP1_DZE"
	,"Lada2_DZE"
	,"Lada2_TK_CIV_EP1_DZE"
	,"LadaLM_DZE"
	,"hilux1_civil_1_open_DZE"
	,"hilux1_civil_2_covered_DZE"
	,"hilux1_civil_3_open_DZE"
	,"GLT_M300_LT_DZE"
	,"GLT_M300_ST_DZE"
	,"Ikarus_DZE"
	,"Ikarus_White_DZE"
	,"Ikarus_TK_CIV_EP1_DZE"
	,"VWGolf_DZE"
	,"Mini_Cooper_DZE"
	,"LandRover_TK_CIV_EP1_DZE"
	,"S1203_TK_CIV_EP1_DZE"
	,"S1203_ambulance_EP1_DZE"
	,"Volha_1_TK_CIV_EP1_DZE"
	,"Volha_2_TK_CIV_EP1_DZE"
	,"VolhaLimo_TK_CIV_EP1_DZE"
] call BIS_fnc_selectRandom;

if (_type == "Hint") then
{
	local _img 		= 	(getText (configFile >> "CfgVehicles" >> _class >> "picture"));
	RemoteMessage 	= 	["hintWithImage",["STR_CL_ESE_MECHANIC_TITLE",["STR_CL_ESE_MECHANIC_START",_loc]],[_img,TITLE_COLOR,TITLE_SIZE,IMAGE_SIZE]];
} else {
	RemoteMessage 	= 	["titleText",["STR_CL_ESE_MECHANIC_START",_loc]];
};
publicVariable "RemoteMessage";

local _truck 	= 	_class createVehicle _pos;
_truck setDir (getDir _garage - 180); 	// Повернем технику Лицом к Двери.
_truck setPosATL (_garage modelToWorld [8.56738,2.10254,-2.55316]);
_truck setVariable ["ObjectID","1", true];
_truck setVariable ["CharacterID","0",true];
dayz_serverObjectMonitor set [count dayz_serverObjectMonitor,_truck];
clearWeaponCargoGlobal _truck;
clearMagazineCargoGlobal _truck;
_truck setVariable["Cleanup" + dayz_serverKey,true];

// Назначение хитпойнтов
{
	local _selection = getText(configFile >> "cfgVehicles" >> _class >> "HitPoints" >> _x >> "name");
	local _strH = "hit_" + (_selection);
	_truck setHit[_selection,0];
	_truck setVariable [_strH,0,true];
} count (_truck call vehicle_getHitpoints);

if (_key) then
{
	local _keyColor 	= 	["Green","Red","Blue","Yellow","Black"] call BIS_fnc_selectRandom;
	local _keyNumber 	= 	(floor(random 2500)) + 1;
	local _keySelected 	= 	format["ItemKey%1%2",_keyColor,_keyNumber];
	local _isKeyOK 		= 	isClass(configFile >> "CfgWeapons" >> _keySelected);
	local _characterID 	= 	str(getNumber(configFile >> "CfgWeapons" >> _keySelected >> "keyid"));

	if (_isKeyOK) then
	{
		_truck addWeaponCargoGlobal [_keySelected,1];
		_truck setVariable ["CharacterID",_characterID,true];	
	}
	else
	{
		diag_log format ["[Техника снабжения]: Проблема с созданием ключа для: %1", _truck];
	};
};

// Добавляем лут
{
	_truck addMagazineCargoGlobal [(_x select 0),(_x select 1)];
} count _kit;


{
	_truck addWeaponCargoGlobal [_x,1];
} count _tools;

for "_i" from 1 to _numpacks do {
	// Рюкзаки
	local _pack =
	[
		 "GymBag_Camo_DZE1"
		,"Patrol_Pack_DZE1"
		,"Czech_Vest_Pouch_DZE1"
		,"Assault_Pack_DZE1"
		,"TerminalPack_DZE1"
		,"TinyPack_DZE1"
		,"ALICE_Pack_DZE1"
		,"TK_Assault_Pack_DZE1"
		,"School_Bag_DZE1"
		,"CompactPack_DZE1"
		,"British_ACU_DZE1"
		,"AirwavesPack_DZE1"
		,"GunBag_DZE1"
		,"NightPack_DZE1"
		,"PartyPack_DZE1"
	] call BIS_fnc_selectRandom;
	_truck addBackpackCargoGlobal [_pack,1];
};

// Публикуем 
_truck addEventHandler ["GetIn", {
	local _truck 		= 	_this select 0;
	RemoteMessage 		= 	["rollingMessages","STR_CL_DZMS_VEH1"];
	(owner (_this select 2)) publicVariableClient "RemoteMessage";
	local _class 		= 	typeOf _truck;
	local _worldspace 	= 	[getDir _truck, getPosATL _truck];
	_truck setVariable["Cleanup" + dayz_serverKey, false];
	local _uid 			= 	_worldspace call dayz_objectUID2;
	format ["CHILD:308:%1:%2:%3:%4:%5:%6:%7:%8:%9:",dayZ_instance,_class,0,(_truck getVariable ["CharacterID","0"]),_worldspace,[getWeaponCargo _truck,getMagazineCargo _truck,getBackpackCargo _truck],[],1,_uid] call server_hiveWrite;
	local _result = (format["CHILD:388:%1:", _uid]) call server_hiveReadWrite;
	
	if ((_result select 0) != "PASS") then
	{
		deleteVehicle _truck;

		diag_log format ["[Техника снабжения]: [PublishVeh]: [ОШИБКА]: Ошибка получения ID: %1 UID: %2.",_class, _uid];
	}else
	{
		_truck setVariable ["ObjectID", (_result select 1), true];
		_truck setVariable ["lastUpdate",diag_tickTime];
		_truck call fnc_veh_ResetEH;
		PVDZE_veh_Init 	= 	_truck;
		publicVariable "PVDZE_veh_Init";

		if (DEBUG) then
		{
			diag_log ("[Техника снабжения]: [PublishVeh]: [ПУБЛИКАЦИЯ]: Создан " + (_class) + " с ID: " + str(_uid));
		};
	};
}];

local _time 	= 	diag_tickTime;
local _done 	= 	false;
local _visited 	= 	false;
local _isNear 	= 	true;
local _markers 	= 	[1,1,1];

//[position,createMarker,setMarkerColor,setMarkerType,setMarkerShape,setMarkerBrush,setMarkerSize,setMarkerText,setMarkerAlpha]
_markers set [0, [_pos,"MechanicsVeh" + str _time,"","n_maint","","",[],[],1]];

if (_nameMarker) then
{
	_markers set [1, [_pos,"MechanicsVehDot" + str _time,"ColorBlack","mil_dot","ICON","",[],["STR_CL_ESE_MECHANIC_TITLE"],0]];
};
DZE_ServerMarkerArray set [count DZE_ServerMarkerArray,_markers]; 	// Маркера добавляются в запросы JIP игроков.
local _markerIndex 		= 	count DZE_ServerMarkerArray - 1;
PVDZ_ServerMarkerSend 	= 	["start",_markers];
publicVariable "PVDZ_ServerMarkerSend";

while {!_done} do {
	uiSleep 3;

	if (_visitMark && !_visited) then
	{
		{
			if (isPlayer _x && {_x distance _pos <= _distance}) exitWith
			{
				_visited 				= 	true;
				_markers set [2, [[(_pos select 0), (_pos select 1) + 25],"MechanicsVehVmarker" + str _time,"ColorBlack","hd_pickup","ICON","",[],[],0]];
				PVDZ_ServerMarkerSend 	= 	["createSingle",(_markers select 2)];
				publicVariable "PVDZ_ServerMarkerSend";
				DZE_ServerMarkerArray set [_markerIndex, _markers];
			};
		} count playableUnits;
	};

	if (_timeout != -1) then
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
		if (isPlayer _x && _x distance _truck <= _distance) exitWith
		{
			_isNear 	= 	true;
		};
	} count playableUnits;
};

// Передаем всем клиентам что маркер нужно удалить
local _remove 	= 	[];
{
	if (typeName _x == "ARRAY") then
	{
		_remove set [count _remove, (_x select 1)];
	};
} count _markers;

// Чистим.
if (_truck getVariable ("Cleanup" + dayz_serverKey)) then
{
	deleteVehicle _truck;
};

PVDZ_ServerMarkerSend 	= 	["end",_remove];
publicVariable "PVDZ_ServerMarkerSend";
DZE_ServerMarkerArray set [_markerIndex,-1];

diag_log "[Техника снабжения]: Завершено!";