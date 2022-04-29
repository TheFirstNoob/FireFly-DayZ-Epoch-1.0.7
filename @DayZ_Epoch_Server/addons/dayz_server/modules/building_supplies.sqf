/*
	Оригинальный "Строительная "IKEA"" Ивент от Aidem
	Оригинальный "crate visited" маркер система от Payden
	Модификация для DayZ Epoch 1.0.6+ от JasonTM
	Модификация для DayZ Epoch 1.0.7+ от JasonTM
	Последнее обновление: 06-01-2021
*/

local _spawnChance 		= 	 1; 					// Вероятность ивента в процентах. Число должно быть от 0 до 1. 1 = вероятность 100%.
local _chainsawChance 	= 	.25; 					// Вероятность появления в ящике Безопилы с топливом в процентах. Число должно быть от 0 до 1. 1 = вероятность 100%.
local _vaultChance 		= 	.25; 					// Вероятность появления в ящике Сейфа или Малого сейфа в процентах. Число должно быть от 0 до 1. 1 = вероятность 100%.
local _radius 			= 	350; 					// Радиус для спавна лута, а так же Радиус для Маркера.
local _timeout 			= 	-1; 					// Время на исчезновение ивента, если игрок не нашел его (В Минутах). Установите значение -1, чтобы отключить.
local _debug 			= 	true; 					// Включить режим диагностики? (Серверный RPT) (True - Да/False - Нет)
local _nameMarker 		= 	false; 					// Добавить название маркера? (True - Да/False - Нет)
local _markPos 			= 	false; 					// Ставить маркер именно там, где появиться лут? (True - Да/False - Нет)
local _lowerGrass 		= 	false; 					// Убирать траву в зоне Ящика? (True - Да/False - Нет)
local _lootAmount 		= 	15; 					// Число для количества лута. Будет выбираться случайным образом от 1 до _lootAmount.
local _type 			= 	"Hint"; 				// Тип вывода оповещения. Параметры: "Hint","TitleText". ***ВНИМАНИЕ: Hint появляется в том же месте экрана, что и обычные Hint где Дебаг монитор.
local _visitMark 		= 	false; 					// Ставить отметку (галочку) "Посещено" если игрок находится рядом с ящиком? (True - Да/False - Нет)
local _distance 		= 	20; 					// Расстояние (В Метрах) от ящика до того, как ящик считается «Посещенным».
local _crate 			= 	"DZ_AmmoBoxBigUS"; 		// Класснейм ящика.

#define TITLE_COLOR "#00FF11" 	// Hint параметры: Цвет верхней линии
#define TITLE_SIZE "2" 			// Hint параметры: Размер верхней линии
#define IMAGE_SIZE "4" 			// Hint параметры: Размер изображения

// Если перед массивом стоит номер, то это количество будет добавлено в ящик, если он будет выбран один раз.
// Каждый элемент может быть выбран несколько раз. Настройте конфигурацию массива в соответствии с вашими предпочтениями.
// Например: Если будет выбран массив [12,"CinderBlocks"] 2 раза, то итоговое значение будет 24 CinderBlocks в ящике.
local _lootList =
[
	 [3,"MortarBucket"]
	,"ItemWoodStairs"
	,[12,"CinderBlocks"]
	,"plot_pole_kit"
	,[12,"PartPlankPack"]
	,[12,"PartPlywoodPack"]
	,"m240_nest_kit"
	,"light_pole_kit"
	,"ItemWoodCrateKit"
	,"ItemFuelBarrel"
	,[4,"metal_floor_kit"]
	,[4,"ItemWoodFloor"]
	,[4,"half_cinder_wall_kit"]
	,[4,"metal_panel_kit"]
	,"fuel_pump_kit"
	,[4,"full_cinder_wall_kit"]

	,"ItemWoodWallWithDoorLgLocked"
	,"storage_shed_kit"
	,"sun_shade_kit"
	,"wooden_shed_kit",
	[2,"ItemComboLock"]
	,[4,"ItemWoodWallLg"]
	,"ItemWoodWallGarageDoorLocked"
	,[4,"ItemWoodWallWindowLg"]
	,"wood_ramp_kit"
	,[8,"ItemWoodFloorQuarter"]
	,"bulk_ItemSandbag"
	,"bulk_ItemTankTrap"
	,"bulk_ItemWire"
	,"bulk_PartGeneric"

	,"workbench_kit"
	,"cinder_garage_kit"
	,"cinder_door_kit"
	,"wood_shack_kit"
	,"deer_stand_kit"
	,[3,"ItemWoodWallThird"]
	,"ItemWoodLadder"
	,[3,"desert_net_kit"]
	,[3,"forest_net_kit"]
	,[2,"ItemSandbagLarge"]
];

diag_log "[Строительная IKEA]: Запуск...";

if (random 1 > _spawnChance and !_debug) exitWith {};

local _pos 	= 	[getMarkerPos "center",0,(((getMarkerSize "center") select 1)*0.75),10,0,.3,0] call BIS_fnc_findSafePos;

diag_log format ["[Строительная IKEA]: Появился на позиции: %1",_pos];

local _lootPos 	= 	[_pos,0,(_radius - 100),10,0,2000,0] call BIS_fnc_findSafePos;

if (_debug) then
{
	diag_log format ["[Строительная IKEA]: Создаем ящик на позиции: %1",_lootPos];
};

local _box 	= 	_crate createVehicle [0,0,0];
_box setPos _lootPos;
clearMagazineCargoGlobal _box;
clearWeaponCargoGlobal _box;

if (_lowerGrass) then
{
	local _cutGrass 	= 	createVehicle ["ClutterCutter_EP1",_lootPos,[],0,"CAN_COLLIDE"];
	_cutGrass setPos _lootPos;
};

if (random 1 < _vaultChance) then
{
	local _vault 	= 	["ItemVault","ItemLockbox"] call BIS_fnc_selectRandom;
	_box addMagazineCargoGlobal [_vault,1];
};

if (random 1 < _chainsawChance) then
{
	local _saw 	= 	["Chainsaw","ChainSawB","ChainsawG","ChainsawP"] call BIS_fnc_selectRandom;
	_box addMagazineCargoGlobal ["ItemJerryMixed",2];
	_box addWeaponCargoGlobal [_saw,1];
};

for "_i" from 1 to _lootAmount do {
	local _loot 	= 	_lootList call BIS_fnc_selectRandom;
	
	if ((typeName _loot) == "ARRAY") then
	{
		_box addMagazineCargoGlobal [_loot select 1,_loot select 0];
	}
	else
	{
		_box addMagazineCargoGlobal [_loot,1];
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
	local _img 		= 	(getText (configFile >> "CfgMagazines" >> "MortarBucket" >> "picture"));
	RemoteMessage 	= 	["hintWithImage",["STR_CL_ESE_IKEA_TITLE","STR_CL_ESE_IKEA"],[_img,TITLE_COLOR,TITLE_SIZE,IMAGE_SIZE]];
}
else
{
	RemoteMessage 	= 	["titleText","STR_CL_ESE_IKEA"];
};
publicVariable "RemoteMessage";

if (_debug) then
{
	diag_log format ["[Строительная IKEA]: Параметры получены. Настройка завершена, Ожидаю %1 минут для timeout",_timeout];
};

local _time 	= 	diag_tickTime;
local _done 	= 	false;
local _visited 	= 	false;
local _isNear 	= 	true;
local _markers 	= 	[1,1,1,1];

//[position,createMarker,setMarkerColor,setMarkerType,setMarkerShape,setMarkerBrush,setMarkerSize,setMarkerText,setMarkerAlpha]
_markers set [0, [_pos, format ["eventMark%1",_time],"","Depot","","",[],[],1]];

if (_nameMarker) then
{
	_markers set [1, [_pos, format ["eventDot%1",_time],"ColorBlack","mil_dot","ICON","",[],["STR_CL_ESE_IKEA_TITLE"],1]];
};

if (_markPos) then
{
	_markers set [2, [_lootPos, format ["eventDebug%1",_time],"ColorGreen","mil_dot","ICON","",[],[],1]];
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
				_markers set [3, [[(_pos select 0),(_pos select 1)+25], format ["EventVisit%1",_time],"ColorBlack","hd_pickup","ICON","",[],[],0]];
				DZE_ServerMarkerArray set [_markerIndex,_markers];
				PVDZ_ServerMarkerSend 	= 	["createSingle",(_markers select 3)];
				publicVariable "PVDZ_ServerMarkerSend";
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
			_isNear 	= 	true;
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

diag_log "[Строительная IKEA]: Завершено!";