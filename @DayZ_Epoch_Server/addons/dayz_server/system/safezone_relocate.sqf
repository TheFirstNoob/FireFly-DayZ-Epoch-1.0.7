/*
	Название: Safe Zone Relocate 
	Автор: salival (https://github.com/oiad)
*/

private ["_customPosition","_minDist","_maxDist","_maxDamage","_nearVehicles","_objDist","_position","_safeZonePos","_safeZoneRadius","_useCustomPosition","_unlock"];

_useCustomPosition 	= 	false; 					// Включить "Свою" позицию для переносе техники с Торговой зоны?
_customPosition 	= 	[6942.64,15121.6,0]; 	// Позиция куда техника с Торговой зоны будет перемещена. Только если _useCustomPosition = true;
_minDist 			= 	5; 						// Мин. расстояние от "Своей" позиции для перемещения транспортных средств на...
_maxDist 			= 	300; 					// Макс. расстояние от Торговой зоны, чтобы найти безопасную позицию или "Свою" позицию для перемещения. Установка малого значения может привести к тому, что техника будет появляться очень близко к другой технике.
_objDist 			= 	15; 					// Мин. расстояние от Торговой зоны для перемещения до центра ближайшего объекта. Установка большого значения замедлит работу функции и часто может привести к невозможности найти подходящую позицию.
_unlock 			= 	false; 					// Открыть технику после перемещения из Торговой зоны?
_maxDamage 			= 	0.75; 					// Техника выше или равная этому значению повреждений будет удалена (0-1).

{
	_safeZonePos 		= 	_x select 0;
	_safeZoneRadius 	= 	_x select 1;
	_nearVehicles 		= 	_safeZonePos nearEntities [["Air","LandVehicle","Ship"],_safeZoneRadius];
	{
		if (damage _x >= _maxDamage) then
		{
			diag_log format ["[СЕРВЕР]: [SafeZone_Relocate.sqf]: [Релокация техники]: %1 был удален с сервера из-за того, что был слишком поврежден перед перемещением на: @%2 %3",typeOf _x,mapGridPosition _x,getPosATL _x];			
			[_x getVariable["ObjectID","0"],_x getVariable["ObjectUID","0"],_x] call server_deleteObjDirect;
			deleteVehicle _x;
		}
		else
		{
			if (_useCustomPosition) then
			{
				_position 	= 	[_customPosition,_minDist,_maxDist,_objDist,1,0,0,[]] call BIS_fnc_findSafePos;
			}
			else
			{
				_position 	= 	[_safeZonePos,(_safeZoneRadius + 50),_maxDist,_objDist,if (_x isKindOf "Ship") then {2} else {0},0,0,[],[_safeZonePos,_safeZonePos]] call BIS_fnc_findSafePos;
			};

			_x setPos _position;
			[_x,"position"] call server_updateObject;

			if (_unlock && {locked _x}) then
			{
				_x setVehicleLock "UNLOCKED"
			};

			diag_log format ["[СЕРВЕР]: [SafeZone_Relocate.sqf]: [Релокация техники]: %1 была перемещена из Торговой зоны на: @%2 %3",typeOf _x,mapGridPosition _position,_position];
		};
	} forEach _nearVehicles;
} forEach DZE_safeZonePosArray;