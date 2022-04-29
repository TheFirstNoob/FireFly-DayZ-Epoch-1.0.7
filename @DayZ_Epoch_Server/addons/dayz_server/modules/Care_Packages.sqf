/*
Спавн Брошенных ящиков.

Единый параметр:
	integer		Количество ящиков для спавна.

Автор:
	Foxy
*/

#include "\z\addons\dayz_code\util\Math.hpp"
#include "\z\addons\dayz_code\util\Vector.hpp"
#include "\z\addons\dayz_code\loot\Loot.hpp"

// Количество ящиков для спавна
#define SPAWN_NUM 6

// Параметры для поиска позиций спавна ящиков
#define SEARCH_CENTER getMarkerPos "carepackages"
#define SEARCH_RADIUS (getMarkerSize "carepackages") select 0
#define SEARCH_DIST_MIN 30
#define SEARCH_SLOPE_MAX 25
#define SEARCH_BLACKLIST [[[12923,3643],[14275,2601]]]

#define CLUTTER_CUTTER 0 //0 = Лут спрятан в траве, 1 = Лут приподнят, 2 = Убрать траву рядом, 3 = Сфера откладки (красная сфера).

private ["_typeGroup","_position","_type","_class","_vehicle","_lootGroup","_lootNum","_lootPos","_lootVeh","_size","_marker","_marker_position","_starttime",
		 "_markerdot","_missiontype","_refreshmarker"];

_lootGroup 	= 	Loot_GetGroup("CarePackage");
_typeGroup 	= 	Loot_GetGroup("CarePackageType");

for "_i" from 1 to (SPAWN_NUM) do
{
	_startTime 			= 	time;
	_type 				= 	Loot_SelectSingle(_typeGroup);
	_class 				= 	_type select 1;
	_lootNum 			= 	round Math_RandomRange(_type select 2, _type select 3);
	_position 			= 	[SEARCH_CENTER, 0, SEARCH_RADIUS, SEARCH_DIST_MIN, 0, SEARCH_SLOPE_MAX, 0, SEARCH_BLACKLIST] call BIS_fnc_findSafePos;
	_position set [2, 0];	
	_marker_position 	= 	[_position,10,300,0,0,2000,0] call BIS_fnc_findSafePos;
	//_marker 			= 	createMarker [ format ["CarePackage_Marker_%1", _startTime], _marker_position];

	_markerdot = "mil_box";
	_missiontype = 0; //0=EPOCH_EVENT_RUNNING 1=SPECIAL_EVENT_RUNNING
	uiSleep 1;
	_refreshmarker = [_marker_position,_markerdot,_missiontype] execVM "\z\addons\dayz_server\modules\RefreshMarkers.sqf";
	
	diag_log format ["[СЕРВЕР]: [ЭВЕНТ]: [Брошенный ящик]: Создаем Брошенный ящик (%1) на %2 с %3 предметами.", _class, _position, _lootNum];
	
	_vehicle 	= 	_class createVehicle _position;
	dayz_serverObjectMonitor set [count dayz_serverObjectMonitor, _vehicle];
	_vehicle setVariable ["ObjectID", 1, true];
	_size 		= 	sizeOf _class;
	{
		_lootPos 	= 	Vector_Add(_position, Vector_Multiply(Vector_FromDir(random 360), _size * 0.6 + random _size));
		_lootPos set [2, 0];
		
		_lootVeh 	= 	Loot_Spawn(_x, _lootPos, "");
		_lootVeh setVariable ["permaLoot", true];
		
		call {
			if (CLUTTER_CUTTER == 1) exitWith
			{
				_lootPos set [2, 0.05]; _lootVeh setPosATL _lootpos;
			};

			if (CLUTTER_CUTTER == 2) exitWith
			{
				"ClutterCutter_small_2_EP1" createVehicle _lootPos;
			};

			if (CLUTTER_CUTTER == 3) exitWith
			{
				"Sign_sphere100cm_EP1" createVehicle _lootPos;
			};
		};
	} forEach  Loot_Select(_lootGroup, _lootNum);
};