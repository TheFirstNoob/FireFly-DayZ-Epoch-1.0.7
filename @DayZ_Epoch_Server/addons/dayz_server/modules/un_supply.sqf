/*
	Оригинальный "Гуманитарная помощь" Ивент от Aidem
	Оригинальный "crate visited" маркер система от Payden
	Модификация для DayZ Epoch 1.0.6+ от JasonTM
	Модификация для DayZ Epoch 1.0.7+ от JasonTM
	Последнее обновление: 06-01-2021
*/

local _spawnChance 		= 	1; 					// Вероятность ивента в процентах. Число должно быть от 0 до 1. 1 = вероятность 100%.
local _vaultChance 		= 	.25; 				// Percentage chance of safe or lockbox being added to the crate. The number must be between 0 and 1. 1 = 100% chance.
local _radius 			= 	350; 				// Радиус для спавна лута, а так же Радиус для Маркера.
local _timeout 			= 	-1; 				// Время на исчезновение ивента, если игрок не нашел его (В Минутах). Установите значение -1, чтобы отключить.
local _debug 			= 	true; 				// Включить режим диагностики? (Серверный RPT) (True - Да/False - Нет)
local _nameMarker 		= 	false; 				// Добавить название маркера? (True - Да/False - Нет)
local _markPos 			= 	false; 				// Ставить маркер именно там, где появиться лут? (True - Да/False - Нет)
local _lowerGrass 		= 	false; 				// Убирать траву в зоне Ящика? (True - Да/False - Нет)
local _lootAmount 		= 	50; 				// Число для количества лута. Будет выбираться случайным образом от 1 до _lootAmount.
local _toolAmount		= 	3;					// Число для количества Инструментов. Будет выбираться случайным образом от 1 до _toolAmount.
local _type 			= 	"Hint"; 			// Тип вывода оповещения. Параметры: "Hint","TitleText". ***ВНИМАНИЕ: Hint появляется в том же месте экрана, что и обычные Hint где Дебаг монитор.
local _visitMark 		= 	false; 				// Ставить отметку (галочку) "Посещено" если игрок находится рядом с ящиком? (True - Да/False - Нет)
local _distance 		= 	20; 				// Расстояние (В Метрах) от ящика до того, как ящик считается «Посещенным».
local _crate 			= 	"DZ_AmmoBoxBigUS"; 	// Класснейм ящика

#define TITLE_COLOR "#00FF11" 	// Hint параметры: Цвет верхней линии
#define TITLE_SIZE "2" 			// Hint параметры: Размер верхней линии
#define IMAGE_SIZE "4" 			// Hint параметры: Размер изображения

diag_log "[Гуманитарная помощь]: Запуск...";

local _bloodbag = ["bloodBagONEG","ItemBloodbag"] select dayz_classicBloodBagSystem;

local _lootList =
[
	"ItemAntibiotic3","ItemEpinephrine","ItemHeatPack","ItemMorphine","ItemBandage","ItemAntibacterialWipe","ItemPainkiller6","ItemSepsisBandage","equip_woodensplint","ItemKiloHemp",_bloodbag, // meds
	"FoodCanBakedBeans","FoodCanFrankBeans","FoodCanPasta","FoodCanSardines","FoodCanBeef","FoodCanPotatoes","FoodCanGriff","FoodCanBadguy","FoodCanBoneboy","FoodCanCorn","FoodCanCurgon","FoodCanDemon","FoodCanFraggleos","FoodCanHerpy","FoodCanDerpy","FoodCanOrlok","FoodCanPowell","FoodCanTylers","FoodCanUnlabeled","FoodCanRusUnlabeled","FoodCanRusStew","FoodCanRusPork","FoodCanRusPeas","FoodCanRusMilk","FoodCanRusCorn","FoodChipsSulahoops","FoodChipsMysticales","FoodChipsChocolate","FoodCandyChubby","FoodCandyAnders","FoodCandyLegacys","FoodCakeCremeCakeClean","FoodCandyMintception","FoodPistachio","FoodNutmix","FoodMRE","FoodbaconCooked","FoodbeefCooked","FoodchickenCooked","FoodGoatCooked","FoodmuttonCooked","FoodrabbitCooked","FishCookedTrout","FishCookedSeaBass","FishCookedTuna", // food
	"ItemSodaCoke","ItemSodaPepsi","ItemSodaMdew","ItemSodaMtngreen","ItemSodaR4z0r","ItemSodaClays","ItemSodaSmasht","ItemSodaDrwaste","ItemSodaFranka","ItemSodaLemonade","ItemSodaLirik","ItemSodaLvg","ItemSodaMzly","ItemSodaPeppsy","ItemSodaRabbit","ItemSodaSacrite","ItemSodaRocketFuel","ItemSodaGrapeDrink","ItemSherbet","ItemSodaRbull","ItemSodaOrangeSherbet","ItemWaterbottle","ItemWaterBottleSafe","ItemWaterBottleBoiled","ItemWaterBottleHerbal","ItemPlasticWaterBottleSafe","ItemPlasticWaterBottleBoiled","ItemPlasticWaterBottleHerbal", // drink
	"PartFueltank","PartWheel","PartEngine","PartGlass","PartGeneric","PartVRotor","ItemJerrycan","ItemFuelBarrel","equip_hose", // vehicle parts
	"ItemCanvas","ItemTent","ItemTentWinter","ItemDomeTent","ItemWinterDomeTent","ItemDesertTent","equip_floppywire","equip_scrapelectronics","equip_rope","equip_tent_poles" // tents and stuff
];

local _tools =
[
	 "ItemToolbox"
	,"ItemToolbox"
	,"ItemKnife"
	,"ItemEtool"
	,"ItemGPS"
	,"Binocular_Vector"
	,"NVGoggles_DZE"
	,"ItemHatchet"
	,"ItemCrowbar"
	,"ItemSledge"
];

if (random 1 > _spawnChance and !_debug) exitWith {};

local _pos 	= 	[getMarkerPos "center",0,(((getMarkerSize "center") select 1)*0.75),10,0,.3,0] call BIS_fnc_findSafePos;

diag_log format["[Гуманитарная помощь]: Появился на позиции: %1",_pos];

local _lootPos 	= 	[_pos,0,(_radius * .75),10,0,2000,0] call BIS_fnc_findSafePos;

if (_debug) then
{
	diag_log format["[Гуманитарная помощь]: Создаем ящик на позиции: %1",_lootPos];
};

local _box 	= 	_crate createVehicle [0,0,0];
_box setPos _lootPos;
clearMagazineCargoGlobal _box;
clearWeaponCargoGlobal _box;
_box setVariable ["permaLoot", true];

if (random 1 < _vaultChance) then
{
	local _vault 	= 	["ItemVault","ItemLockbox"] call BIS_fnc_selectRandom;
	_box addMagazineCargoGlobal [_vault,1];
};

for "_i" from 1 to _lootAmount do {
	local _loot 	= 	_lootList call BIS_fnc_selectRandom;
	_box addMagazineCargoGlobal [_loot,1];
};

for "_i" from 1 to _toolAmount do {
	local _tool 	= 	_tools call BIS_fnc_selectRandom;
	_box addWeaponCargoGlobal [_tool,1];
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
	local _img 		= 	(getText (configFile >> "CfgVehicles" >> "DZ_AmmoBoxBigUS" >> "icon"));
	RemoteMessage 	= 	["hintWithImage",["STR_CL_ESE_UNSUPPLY_TITLE","STR_CL_ESE_UNSUPPLY"],[_img,TITLE_COLOR,TITLE_SIZE,IMAGE_SIZE]];
}
else
{
	RemoteMessage 	= 	["titleText","STR_CL_ESE_UNSUPPLY"];
};
publicVariable "RemoteMessage";

if (_debug) then
{
	diag_log format["[Гуманитарная помощь]: Параметры получены. Настройка завершена, Ожидаю %1 минут для timeout",_timeout];
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
_markers set [0, [_pos, format ["eventMark%1", _time],"","Heliport","","",[],[],1]];

if (_nameMarker) then
{
	_markers set [1, [_pos, format ["eventDot%1",_time],"ColorBlack","mil_dot","ICON","",[],["STR_CL_ESE_UNSUPPLY_TITLE"],0]];
};

if (_markPos) then
{
	_markers set [2, [_lootPos, format ["eventDebug%1",_time],"ColorBlue","mil_dot","ICON","",[],[],0]];
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
			if (isPlayer _x && {_x distance _box <= _distance}) exitWith
			{
				_visited 				= 	true;
				_markers set [3, [[(_pos select 0), (_pos select 1) + 25], format ["EventVisit%1",_time],"ColorBlack","hd_pickup","ICON","",[],[],0]];
				PVDZ_ServerMarkerSend 	= 	["createSingle",(_markers select 3)];
				publicVariable "PVDZ_ServerMarkerSend";
				DZE_ServerMarkerArray set [_markerIndex,_markers];
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
		_remove set [count _remove, (_x select 1)];
	};
} count _markers;
PVDZ_ServerMarkerSend 	= 	["end",_remove];
publicVariable "PVDZ_ServerMarkerSend";
DZE_ServerMarkerArray set [_markerIndex, -1];

diag_log "[Гуманитарная помощь]: Завершено!";