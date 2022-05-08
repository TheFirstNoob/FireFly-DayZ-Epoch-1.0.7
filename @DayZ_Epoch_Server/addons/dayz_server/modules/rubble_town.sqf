/*
	Оригинальный "Заваленный город" Ивент от CaveMan
	Оригинальный "crate visited" маркер система от Payden
	Модификация для DayZ Epoch 1.0.6+ от JasonTM
	Модификация для DayZ Epoch 1.0.7+ от JasonTM
	Последнее обновление: 06-01-2021
*/

local _spawnChance 		= 	 1; 					// Вероятность ивента в процентах. Число должно быть от 0 до 1. 1 = вероятность 100%.
local _chainsawChance 	= 	.25; 					// Вероятность появления в ящике Безопилы с топливом в процентах. Число должно быть от 0 до 1. 1 = вероятность 100%.
local _radius 			= 	350; 					// Радиус для спавна лута, а так же Радиус для Маркера.
local _timeout 			= 	-1; 					// Время на исчезновение ивента, если игрок не нашел его (В Минутах). Установите значение -1, чтобы отключить.
local _debug 			= 	true; 					// Включить режим диагностики? (Серверный RPT) (True - Да/False - Нет)
local _nameMarker 		= 	false; 					// Добавить название маркера? (True - Да/False - Нет)
local _markPos 			= 	false; 					// Ставить маркер именно там, где появиться лут? (True - Да/False - Нет)
local _lowerGrass 		= 	false; 					// Убирать траву в зоне Ящика? (True - Да/False - Нет)
local _lootAmount 		= 	30; 					// Число для количества лута. Будет выбираться случайным образом от 1 до _lootAmount.
local _wepAmount 		= 	4; 						// Количество оружий в ящике.
local _messageType 		= 	"Hint"; 				// Тип вывода оповещения. Параметры: "Hint","TitleText". ***ВНИМАНИЕ: Hint появляется в том же месте экрана, что и обычные Hint где Дебаг монитор.
local _visitMark 		= 	false; 					// Ставить отметку (галочку) "Посещено" если игрок находится рядом с ящиком? (True - Да/False - Нет)
local _distance 		= 	20; 					// Расстояние (В Метрах) от ящика до того, как ящик считается «Посещенным».
local _crate 			= 	"GuerillaCacheBox"; 	// Класснейм ящика

#define TITLE_COLOR "#00FF11" 	// Hint параметры: Цвет верхней линии
#define TITLE_SIZE "2" 			// Hint параметры: Размер верхней линии
#define IMAGE_SIZE "4" 			// Hint параметры: Размер изображения

local _bloodbag = ["bloodBagONEG","ItemBloodbag"] select dayz_classicBloodBagSystem;

local _lootList =
[
	 _bloodbag
	,"ItemBandage"
	,"ItemAntibiotic"
	,"ItemEpinephrine"
	,"ItemMorphine"
	,"ItemPainkiller"
	,"ItemAntibacterialWipe"
	,"ItemHeatPack"
	,"ItemKiloHemp" // meds

	,"Skin_Camo1_DZ"
	,"Skin_CZ_Soldier_Sniper_EP1_DZ"
	,"Skin_CZ_Special_Forces_GL_DES_EP1_DZ"
	,"Skin_Drake_Light_DZ"
	,"Skin_FR_OHara_DZ"
	,"Skin_FR_Rodriguez_DZ"
	,"Skin_Graves_Light_DZ"
	,"Skin_Sniper1_DZ"
	,"Skin_Soldier1_DZ"
	,"Skin_Soldier_Bodyguard_AA12_PMC_DZ" // skins

	,"ItemSodaSmasht"
	,"ItemSodaClays"
	,"ItemSodaR4z0r"
	,"ItemSodaPepsi"
	,"ItemSodaCoke"
	,"FoodCanBakedBeans"
	,"FoodCanPasta"
	,"FoodCanSardines"
	,"FoodMRE"
	,"ItemWaterBottleBoiled"
	,"ItemSodaRbull"
	,"FoodBeefCooked"
	,"FoodMuttonCooked"
	,"FoodChickenCooked"
	,"FoodRabbitCooked"
	,"FoodBaconCooked"
	,"FoodGoatCooked"
	,"FoodDogCooked"
	,"FishCookedTrout"
	,"FishCookedSeaBass"
	,"FishCookedTuna" // food

	,"PartFueltank"
	,"PartWheel"
	,"PartEngine"
	,"PartGlass"
	,"PartGeneric"
	,"PartVRotor"
	,"ItemJerrycan"
	,"ItemFuelBarrel"
	,"equip_hose" // vehicle parts

	,"ItemDesertTent"
	,"ItemDomeTent"
	,"ItemTent" // tents
];

// Оружие
local _weapons =
[
	 "M16A2_DZ"
	,"M4A1_DZ"
	,"M4A1_SD_DZ"
	,"SA58_RIS_DZ"
	,"L85A2_DZ"
	,"L85A2_SD_DZ"
	,"AKM_DZ"
	,"G36C_DZ"
	,"G36C_SD_DZ"
	,"G36A_Camo_DZ"
	,"G36K_Camo_DZ"
	,"G36K_Camo_SD_DZ"
	,"CTAR21_DZ"
	,"ACR_WDL_DZ"
	,"ACR_WDL_SD_DZ"
	,"ACR_BL_DZ"
	,"ACR_BL_SD_DZ"
	,"ACR_DES_DZ"
	,"ACR_DES_SD_DZ"
	,"ACR_SNOW_DZ"
	,"ACR_SNOW_SD_DZ"
	,"AK74_DZ"
	,"AK74_SD_DZ"
	,"AK107_DZ"
	,"CZ805_A1_DZ"
	,"CZ805_A1_GL_DZ"
	,"CZ805_A2_DZ"
	,"CZ805_A2_SD_DZ"
	,"CZ805_B_GL_DZ"
	,"Famas_DZ"
	,"Famas_SD_DZ"
	,"G3_DZ"
	,"HK53A3_DZ"
	,"HK416_DZ"
	,"HK416_SD_DZ"
	,"HK417_DZ"
	,"HK417_SD_DZ"
	,"HK417C_DZ"
	,"M1A_SC16_BL_DZ"
	,"M1A_SC16_TAN_DZ"
	,"M1A_SC2_BL_DZ"
	,"Masada_DZ"
	,"Masada_SD_DZ"
	,"Masada_BL_DZ"
	,"Masada_BL_SD_DZ"
	,"MK14_DZ"
	,"MK14_SD_DZ"
	,"MK16_DZ"
	,"MK16_CCO_SD_DZ"
	,"MK16_BL_CCO_DZ"
	,"MK16_BL_Holo_SD_DZ"
	,"MK17_DZ"
	,"MK17_CCO_SD_DZ"
	,"MK17_ACOG_SD_DZ"
	,"MK17_BL_Holo_DZ"
	,"MK17_BL_GL_ACOG_DZ"
	,"MR43_DZ"
	,"PDR_DZ"
	,"RK95_DZ"
	,"RK95_SD_DZ"
	,"SCAR_H_AK_DZ"
	,"SteyrAug_A3_Green_DZ"
	,"SteyrAug_A3_Black_DZ"
	,"SteyrAug_A3_Blue_DZ"
];

diag_log "[Заваленный город]: Запуск...";

if (random 1 > _spawnChance and !_debug) exitWith {};
local _pos 	= 	[getMarkerPos "center",0,(((getMarkerSize "center") select 1)*0.75),10,0,.3,0] call BIS_fnc_findSafePos;

diag_log format["[Заваленный город]: Появился на позиции: %1", _pos];

local _posarray =
[
	 [(_pos select 0) - 39.8, 	(_pos select 1) + 11]
	,[(_pos select 0) - 47.7, 	(_pos select 1) + 37.8]
	,[(_pos select 0) - 24.3, 	(_pos select 1) + 38.2]
	,[(_pos select 0) - 6.6, 	(_pos select 1) + 42.7]
	,[(_pos select 0) - 16.5, 	(_pos select 1) - 6.5]
	,[(_pos select 0) - 56.8, 	(_pos select 1) + 30.3]
	,[(_pos select 0) - 23.3, 	(_pos select 1) + 22.5]
	,[(_pos select 0) + 1, 		(_pos select 1) + 20.7]
	,[(_pos select 0) - 21.7, 	(_pos select 1) + 6.7]
	,[(_pos select 0) - 8.7, 	(_pos select 1) + 29.6]
	,[(_pos select 0) + 9.3, 	(_pos select 1) + 9.4]
];

local _spawnObjects =
{
	local _pos 			= 	_this select 1;
	local _objArray 	= 	[];
	local _obj 			= 	objNull;
	{
		local _offset 		= 	_x select 1;
		local _position 	= 	[(_pos select 0) + (_offset select 0), (_pos select 1) + (_offset select 1), 0];
		local _obj 			= 	(_x select 0) createVehicle [0,0,0];

		if (count _x > 2) then
		{
			_obj setDir (_x select 2);
		};

		_obj setPos _position;
		_obj setVectorUp surfaceNormal position _obj;
		_obj addEventHandler ["HandleDamage",{0}];
		_obj enableSimulation false;
		_objArray set [count _objArray, _obj];
	} count (_this select 0);
	_objArray
};

local _lootPos 	= 	_posarray call BIS_fnc_selectRandom;

if (_debug) then
{
	diag_log format["[Заваленный город]: Создаем ящик на позиции: %1",_lootPos];
};

local _box 	= 	_crate createVehicle [0,0,0];
_box setPos _lootPos;
clearMagazineCargoGlobal _box;
clearWeaponCargoGlobal _box;
_box setVariable ["permaLoot", true];

if (_lowerGrass) then
{
	local _cutGrass 	= 	createVehicle ["ClutterCutter_EP1",_lootPos,[],0,"CAN_COLLIDE"];
	_cutGrass setPos _lootPos;
};

local _objects =
[
	[
		 ["MAP_HouseBlock_B2_ruins",[0,0]]
		,["MAP_rubble_rocks_01",[-37,-5.8]]
		,["MAP_HouseBlock_A1_1_ruins",[-52,13]]
		,["MAP_rubble_bricks_02",[-22.5,-7.2]]
		,["MAP_rubble_bricks_03",[-22.8,2.8]]
		,["MAP_rubble_bricks_04",[-32.7,27.6]]
		,["MAP_HouseV_2L_ruins",[-21.3,14.6]]
		,["MAP_HouseBlock_B3_ruins",[-12.8,-15.7]]
		,["MAP_A_MunicipalOffice_ruins",[26,-1.6]]
		,["MAP_HouseBlock_A2_ruins",[-67.3,36.3]]
		,["MAP_Ind_Stack_Big_ruins",[15,43.3]]
		,["MAP_Nasypka_ruins",[-24,26.7]]
		,["MAP_R_HouseV_2L",[-8.2,22.7]]
		,["MAP_ruin_01",[.6,41.5]]
		,["MAP_ruin_01",[-36.7,35.7]]
		,["HMMWVWreck",[-14.4,-7.3]]
		,["T72Wreck",[6,-9.7]]
		,["UralWreck",[-31.3,36.6],-19.75]
		,["UralWreck",[-37,11]]
		,["UralWreck",[3.7,20.4],35.5]
		,["UH60_ARMY_Wreck_DZ",[-21.7,38.3]]
	],
_pos
] call _spawnObjects;

if (random 1 < _chainsawChance) then
{
	local _saw 	= 	["ChainSaw","ChainSawB","ChainSawG","ChainSawP","ChainSawR"] call BIS_fnc_selectRandom;
	_box addWeaponCargoGlobal [_saw,1];
	_box addMagazineCargoGlobal ["ItemJerryMixed",2];
};

for "_i" from 1 to _lootAmount do {
	local _loot 	= 	_lootList call BIS_fnc_selectRandom;
	_box addMagazineCargoGlobal [_loot,1];
};

for "_i" from 1 to _wepAmount do {
	local _weapon 	= 	_weapons call BIS_fnc_selectRandom;
	_box addWeaponCargoGlobal [_weapon,1];
	
	local _ammoArray 	= 	getArray (configFile >> "CfgWeapons" >> _weapon >> "magazines");
	if (count _ammoArray > 0) then
	{
		local _mag 		= 	_ammoArray select 0;
		_box addMagazineCargoGlobal [_mag, (3 + round(random 2))];
	};
	
	local _cfg 	= 	configFile >> "CfgWeapons" >> _weapon >> "Attachments";
	if (isClass _cfg && {count _cfg > 0}) then
	{
		local _attach = configName (_cfg call BIS_fnc_selectRandom);

		// Без теплаков
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

if (_messageType == "Hint") then
{
	local _img 		= 	(getText (configFile >> "CfgVehicle" >> "MAP_HouseBlock_B2_ruins" >> "icon"));
	RemoteMessage 	= 	["hintWithImage",["STR_CL_ESE_RUBBLETOWN_TITLE","STR_CL_ESE_RUBBLETOWN"],[_img,TITLE_COLOR,TITLE_SIZE,IMAGE_SIZE]];
}
else
{
	RemoteMessage 	= 	["titleText","STR_CL_ESE_RUBBLETOWN"];
};
publicVariable "RemoteMessage";

if (_debug) then
{
	diag_log format ["[Заваленный город]: Параметры получены. Настройка завершена, Ожидаю %1 минут для timeout",_timeout];
};

local _time 		= 	diag_tickTime;
local _finished 	= 	false;
local _visited 		= 	false;
local _isNear 		= 	true;
local _markers 		= 	[1,1,1,1];

//[position,createMarker,setMarkerColor,setMarkerType,setMarkerShape,setMarkerBrush,setMarkerSize,setMarkerText,setMarkerAlpha]
_markers set [0, [_pos, format ["eventMark%1",_time],"","City","","",[],[],1]];

if (_nameMarker) then
{
	_markers set [1, [_pos, format ["eventDot%1",_time],"ColorBlack","mil_dot","ICON","",[],["STR_CL_ESE_RUBBLETOWN_TITLE"],0]];
};

if (_markPos) then
{
	_markers set [2, [_lootPos, format ["eventDebug%1",_time],"ColorOrange","mil_dot","ICON","",[],[],0]];
};

DZE_ServerMarkerArray set [count DZE_ServerMarkerArray, _markers]; 	// Маркера добавляются в запросы JIP игроков.
local _markerIndex 		= 	count DZE_ServerMarkerArray - 1;
PVDZ_ServerMarkerSend 	= 	["start",_markers];
publicVariable "PVDZ_ServerMarkerSend";

while {!_finished} do {
	uiSleep 3;

	if (_visitMark && !_visited) then
	{
		{
			if (isPlayer _x && {_x distance _box <= _distance}) exitWith
			{
				_visited 	= 	true;
				_markers set [3, [[(_pos select 0), (_pos select 1) + 25], format ["EventVisit%1",_time],"ColorBlack","hd_pickup","ICON","",[],[],0]];
				PVDZ_ServerMarkerSend = ["createSingle",(_markers select 3)];
				publicVariable "PVDZ_ServerMarkerSend";
				DZE_ServerMarkerArray set [_markerIndex,_markers];
			};
		} count playableUnits;
	};
	
	if (_timeout != -1) then
	{
		if (diag_tickTime - _time >= _timeout*60) then
		{
			_finished 	= 	true;
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
	if (typeName _x == "ARRAY") then {
		_remove set [count _remove, (_x select 1)];
	};
} count _markers;
PVDZ_ServerMarkerSend 	= 	["end",_remove];
publicVariable "PVDZ_ServerMarkerSend";
DZE_ServerMarkerArray set [_markerIndex,-1];

{
	deleteVehicle _x;
} count _objects;

diag_log "[Заваленный город]: Завершено!";