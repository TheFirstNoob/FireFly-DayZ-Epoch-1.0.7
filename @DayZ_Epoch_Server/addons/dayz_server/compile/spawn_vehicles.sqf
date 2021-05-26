private ["_random","_lastIndex","_index","_vehicle","_velimit","_qty","_isCessna","_isMV22","_isShip","_isHeli","_isC130","_isPlane","_position","_dir","_istoomany","_veh","_objPosition","_iClass","_num","_allCfgLoots"];
#include "\z\addons\dayz_code\loot\Loot.hpp"

while {count AllowedVehiclesList > 0} do {
	_index 		= 	floor random count AllowedVehiclesList;
	_random 	= 	AllowedVehiclesList select _index;
	_vehicle 	= 	_random select 0;
	_velimit 	= 	_random select 1;

	_qty 	=
	{
		_x == _vehicle
	} count _serverVehicleCounter;

	if (_qty <= _velimit) exitWith {};

	// Достигнут лимит на количество техники, удаляем технику из списка
	// Поскольку элементы не могут быть удалены из массива, перезаписываем его последним элементом и вырезаем последний элемент (если порядок не важен)
	_lastIndex 	= 	(count AllowedVehiclesList) - 1;
	if (_lastIndex != _index) then {AllowedVehiclesList set [_index, AllowedVehiclesList select _lastIndex];};
	AllowedVehiclesList resize _lastIndex;
};

if (count AllowedVehiclesList == 0) then
{
	diag_log "[СЕРВЕР]: [spawn_vehicle.sqf]: [ОТКЛАДКА]: Невозможно найти подходящую случайную технику для появления";
}
else
{
	// Добавим технику в счетчик для следующего запроса
	_serverVehicleCounter set [count _serverVehicleCounter,_vehicle];

	// Найдем тип техники, чтобы лучше контролировать спавн.
	// ВНИМАТЕЛЬНО СМОТРИМ НА ID ТЕХНИКИ!
	_isShip 	= 	_vehicle isKindOf "Ship"; 			// Любой тип Водной техники.
	_isMV22 	= 	_vehicle == "MV22_DZ"; 				// MV-22 является самолетом с Вертикальным взлетом.
	_isHeli 	= 	_vehicle isKindOf "Helicopter"; 	// Все вертолеты.
	_isC130 	= 	_vehicle == "C130J_US_EP1_DZ"; 		// C130 слишком большие чтобы появляться в Ангарах.
	_isCessna 	= 	_vehicle in ["GNT_C185C_DZ","GNT_C185R_DZ","GNT_C185_DZ","GNT_C185U_DZ"]; 	// Cessna модели нестабильны и не должны появляться в ангарах.
	_isPlane 	= 	(_vehicle isKindOf "Plane" && {!_isCessna} && {!_isMV22} && {!_isC130}); 	// Cessna, MV-22, и C130 которым нельзя появляться в Ангарах.
	
	call {
		// Создадим Лодки на берегу, на воде
		if (_isShip) exitWith
		{
			_position 	= 	[getMarkerPos "center",0,((getMarkerSize "center") select 1),10,1,2000,1] call BIS_fnc_findSafePos;
		};
		// Создадим Вертолеты относительно ровной поверхности
		if (_isHeli || {_isMV22}) exitWith
		{
			_position 	= 	[getMarkerPos "center",0,((getMarkerSize "center") select 1),10,0,.15,0] call BIS_fnc_findSafePos;
		};
		// Создадим AN2 и GyroCopter в Ангаре и на Взлетно-Посадочной полосе
		if (_isPlane) exitWith
		{
			// Дополнительные позиции для Аэродромов разрешены
			if (count DZE_AllAircraftPositions > 0) then
			{
				_position 	= 	DZE_AllAircraftPositions call BIS_fnc_selectRandom;
				_dir 		= 	_position select 1;
				_position 	= 	_position select 0;
			}
			else
			{
				_position 	= 	[getMarkerPos "center",0,((getMarkerSize "center") select 1),10,0,.15,0] call BIS_fnc_findSafePos;
			};
		};
		// Создадим C130 и Cessna на взлетно-посадочной полосе
		if (_isCessna || {_isC130}) exitWith
		{
			// Дополнительные позиции для Аэродромов разрешены
			if (count DZE_Runway_Positions > 0) then
			{
				_position 	= 	DZE_Runway_Positions call BIS_fnc_selectRandom;
				_dir 		= 	_position select 1;
				_position 	= 	_position select 0;
			}
			else
			{
				_position 	= 	[getMarkerPos "center",0,((getMarkerSize "center") select 1),10,0,.15,0] call BIS_fnc_findSafePos;
			};
		};
		// Создадим Наземную технику вокруг зданий и 50% возле дорог.
		if ((random 1) > 0.5) then
		{	
			_position 	= 	_roadList call BIS_fnc_selectRandom;	
			_position 	= 	_position modelToWorld [0,0,0];	
			_position 	= 	[_position,0,10,10,0,2000,0] call BIS_fnc_findSafePos;	
			//diag_log("[СЕРВЕР]: [spawn_vehicle.sqf]: [ОТКЛАДКА]: Создано возле Дорог техники: " + str(_position));
		}
		else
		{
			_position 	= 	_buildingList call BIS_fnc_selectRandom;	
			_position 	= 	_position modelToWorld [0,0,0];
			_position 	= 	[_position,0,40,5,0,2000,0] call BIS_fnc_findSafePos;	
			//diag_log("[СЕРВЕР]: [spawn_vehicle.sqf]: [ОТКЛАДКА]: Создано возле Зданий техники " + str(_position));
		};
	};
	
	// Работает только если Два параметра! Иначе BIS_fnc_findSafePos не отработает корректно и техника появится в воздухе
	if ((count _position) == 2) then
	{
		_position set [2,0];

		if (isNil "_dir") then
		{
			_dir = round(random 180);
		};

		_istoomany 	= 	_position nearObjects ["AllVehicles",50];
		if ((count _istoomany) > 0) exitWith {};

		_veh 			= 	_vehicle createVehicle [0,0,0];
		_veh setDir _dir;
		_veh setPos _position;
		_objPosition 	= 	getPosATL _veh;
	
		clearWeaponCargoGlobal _veh;
		clearMagazineCargoGlobal _veh;
		
		// Добавим 0-6 предметов в технику используя случайные loot groups (Меняйте как душе угодно!)
		_num 			= 	floor(random 6);
		_allCfgLoots 	= 	["Trash","Trash","Consumable","Consumable","Generic","Generic","MedicalLow","MedicalLow","clothes","tents","backpacks","Parts","pistols","AmmoCivilian"];
		
		for "_x" from 1 to _num do {
			_iClass 			= 	_allCfgLoots call BIS_fnc_selectRandom;
			_lootGroupIndex 	= 	dz_loot_groups find _iClass;
			Loot_InsertCargo(_veh, _lootGroupIndex, 1);
		};

		[_veh,[_dir,_objPosition],_vehicle,true,"0"] call server_publishVeh;
		
		if (_num > 0) then
		{
			_vehiclesToUpdate set [count _vehiclesToUpdate,_veh];
		};
	};
};
