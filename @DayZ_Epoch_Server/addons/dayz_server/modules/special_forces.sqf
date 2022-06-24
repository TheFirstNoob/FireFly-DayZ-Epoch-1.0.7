/*
	Оригинальный "Военный тайник" Ивент от Aidem
	Оригинальный "crate visited" маркер система от Payden
	Модификация для DayZ Epoch 1.0.6+ от JasonTM
	Модификация для DayZ Epoch 1.0.7+ от JasonTM
	Последнее обновление: 06-01-2021
*/

local _spawnChance 		= 	1; 						// Вероятность ивента в процентах. Число должно быть от 0 до 1. 1 = вероятность 100%.
local _sniperChance 	= 	.25; 					// Вероятность появления в ящике Снайперских Винтовок в процентах. Число должно быть от 0 до 1. 1 = вероятность 100%.
local _radius 			= 	350; 					// Радиус для спавна лута, а так же Радиус для Маркера.
local _timeout 			= 	-1; 					// Время на исчезновение ивента, если игрок не нашел его (В Минутах). Установите значение -1, чтобы отключить.
local _debug 			= 	true; 					// Включить режим диагностики? (Серверный RPT) (True - Да/False - Нет)
local _nameMarker 		= 	false; 					// Добавить название маркера? (True - Да/False - Нет)
local _markPos 			= 	false; 					// Ставить маркер именно там, где появиться лут? (True - Да/False - Нет)
local _lowerGrass 		= 	false; 					// Убирать траву в зоне Ящика? (True - Да/False - Нет)
local _lootAmount 		= 	10; 					// Число для количества лута. Будет выбираться случайным образом от 1 до _lootAmount.
local _type 			= 	"Hint"; 				// Тип вывода оповещения. Параметры: "Hint","TitleText". ***ВНИМАНИЕ: Hint появляется в том же месте экрана, что и обычные Hint где Дебаг монитор.
local _visitMark 		= 	false; 					// Ставить отметку (галочку) "Посещено" если игрок находится рядом с ящиком? (True - Да/False - Нет)
local _distance 		= 	20; 					// Расстояние (В Метрах) от ящика до того, как ящик считается «Посещенным».
local _crate 			= 	"DZ_AmmoBoxBigUS"; 		// Класснейм ящика

local _weapons = ["M16A4_DZ","M4A1_DZ","M4A1_SD_DZ","SA58_RIS_DZ","L85A2_DZ","L85A2_SD_DZ","AKM_DZ","G36C_DZ","G36C_SD_DZ","CTAR21_DZ","ACR_BL_DZ","ACR_BL_SD_DZ","AK74_DZ","AK74_SD_DZ","AK107_DZ","CZ805_A1_DZ","CZ805_A1_GL_DZ","CZ805_A2_DZ","CZ805_A2_SD_DZ","CZ805_B_GL_DZ","Famas_DZ","Famas_SD_DZ","G3_DZ","HK53A3_DZ","HK416_DZ","HK416_SD_DZ","HK417_DZ","HK417_SD_DZ","HK417C_DZ","M1A_SC16_BL_DZ","M1A_SC16_TAN_DZ","M1A_SC2_BL_DZ","Masada_DZ","Masada_SD_DZ","Masada_BL_DZ","Masada_BL_SD_DZ","MK14_DZ","MK14_SD_DZ","MK16_DZ","MK16_CCO_SD_DZ","MK16_BL_CCO_DZ","MK16_BL_Holo_SD_DZ","MK17_DZ","MK17_CCO_SD_DZ","MK17_ACOG_SD_DZ","MK17_BL_Holo_DZ","MK17_BL_GL_ACOG_DZ","MR43_DZ","PDR_DZ","RK95_DZ","RK95_SD_DZ","SCAR_H_AK_DZ","SteyrAug_A3_Black_DZ"];
local _snipers = ["KSVK_DZE"];

#define TITLE_COLOR "#00FF11" 	// Hint параметры: Цвет верхней линии
#define TITLE_SIZE "2" 			// Hint параметры: Размер верхней линии
#define IMAGE_SIZE "4" 			// Hint параметры: Размер изображения

diag_log "[Военный тайник]: Запуск...";

if (random 1 > _spawnChance and !_debug) exitWith {};

local _pos 	= 	[getMarkerPos "center",0,(((getMarkerSize "center") select 1)*0.75),10,0,.3,0] call BIS_fnc_findSafePos;

diag_log format["[Военный тайник]: Появился на позиции: %1", _pos];

local _lootPos 	= 	[_pos,0,(_radius - 100),10,0,2000,0] call BIS_fnc_findSafePos;

if (_debug) then
{
	diag_log format["[Военный тайник]: Создаем ящик на позиции: %1",_lootPos];
};


local _box 	= 	_crate createVehicle [0,0,0];
_box setPos _lootPos;
clearMagazineCargoGlobal _box;
clearWeaponCargoGlobal _box;
_box setVariable ["permaLoot", true];

if (random 1 < _sniperChance) then
{
	local _wep 	= 	_snipers call BIS_fnc_selectRandom;
	_box addWeaponCargoGlobal [_wep,1];
	
	local _ammoArray 	= 	getArray (configFile >> "CfgWeapons" >> _wep >> "magazines");

	if (count _ammoArray > 0) then
	{
		local _mag 	= 	_ammoArray select 0;
		_box addMagazineCargoGlobal [_mag,(3 + round(random 2))];
	};
};

for "_i" from 1 to _lootAmount do {

	local _wep 	= 	_weapons call BIS_fnc_selectRandom;
	_box addWeaponCargoGlobal [_wep,1];

	local _ammoArray 	= 	getArray (configFile >> "CfgWeapons" >> _wep >> "magazines");

	if (count _ammoArray > 0) then
	{
		local _mag 	= 	_ammoArray select 0;
		_box addMagazineCargoGlobal [_mag,(3 + floor(random 3))];
	};

	local _cfg 	= 	configFile >> "CfgWeapons" >> _wep >> "Attachments";

	if (isClass _cfg && count _cfg > 0) then
	{
		local _attach = configName (_cfg call BIS_fnc_selectRandom);

		// Никаких Теплоков на пушках (модуль)
		if !(_attach == "Attachment_Tws") then
		{
			_box addMagazineCargoGlobal [_attach,1];
		};
	};
};

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
_box addBackpackCargoGlobal [_pack,1];

if (_type == "Hint") then
{
	local _img 		= 	getText (configFile >> "CfgWeapons" >> "KSVK_DZE" >> "picture");
	RemoteMessage 	= 	["hintWithImage",["STR_CL_ESE_MILITARY_TITLE","STR_CL_ESE_MILITARY"],[_img,TITLE_COLOR,TITLE_SIZE,IMAGE_SIZE]];
}
else 
{
	RemoteMessage 	= 	["titleText","STR_CL_ESE_MILITARY"];
};
publicVariable "RemoteMessage";

if (_debug) then
{
	diag_log format["[Военный тайник]: Параметры получены. Настройка завершена, Ожидаю %1 минут для timeout",_timeout];
};

local _time 	= 	diag_tickTime;
local _done 	= 	false;
local _visited 	= 	false;
local _isNear 	= 	true;
local _markers 	= 	[1,1,1,1];

if (_lowerGrass) then
{
	local _cutGrass 	= 	createVehicle ["ClutterCutter_EP1",_lootPos,[],0,"CAN_COLLIDE"];
	_cutGrass setPos _lootPos;
};

//[position,createMarker,setMarkerColor,setMarkerType,setMarkerShape,setMarkerBrush,setMarkerSize,setMarkerText,setMarkerAlpha]

_markers set [0, [_pos, format ["eventMark%1",_time],"","AntiAir","","",[],[],1]];

if (_nameMarker) then
{
	_markers set [1, [_pos, format ["eventDot%1",_time],"ColorBlack","mil_dot","ICON","",[],["STR_CL_ESE_MILITARY_TITLE"],0]];
};

if (_markPos) then
{
	_markers set [2, [_lootPos, format ["eventDebug%1",_time],"ColorRed","mil_dot","ICON","",[],[],0]];
};

DZE_ServerMarkerArray set [count DZE_ServerMarkerArray, _markers]; 	// Маркера добавляются в запросы JIP игроков.
local _markerIndex 		= 	count DZE_ServerMarkerArray - 1;
PVDZ_ServerMarkerSend 	= 	["start",_markers];
publicVariable "PVDZ_ServerMarkerSend";

while {!_done} do {
	uiSleep 3;

	if (_visitMark && !_visited) then
	{
		{
			if (isPlayer _x && {_x distance _box <= _distance}) exitWith
			{
				_visited 				= 	true;
				_markers set [3, [[(_pos select 0), (_pos select 1) + 25], format ["EventVisit%1", _time],"ColorBlack","hd_pickup","ICON","",[],[],0]];
				PVDZ_ServerMarkerSend 	= 	["createSingle",(_markers select 3)];
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
		if (isPlayer _x && _x distance _box <= _distance) exitWith
		{
			_isNear = true;
		};
	} count playableUnits;
};

// Чистим
deleteVehicle _box;

if (_lowerGrass) then
{
	deleteVehicle _cutGrass;
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

diag_log "[Военный тайник]: Завершено!";