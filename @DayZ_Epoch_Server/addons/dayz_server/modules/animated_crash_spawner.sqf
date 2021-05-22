private["_exploRange","_blackList","_lootArray","_crashSelect","_ran15","_missionEnd","_isClose1","_isClose2","_isClose3","_inFlight","_plane","_porh","_lootVeh","_finder","_crash","_crashDamage","_preWaypointPos","_endTime","_startTime","_heliStart","_heliModel","_lootPos","_wp2","_landingzone","_aigroup","_wp","_helipilot","_crashwreck","_pos","_dir","_mdot","_position","_num","_crashModel","_crashName","_marker","_itemTypes"];

#include "\z\addons\dayz_code\loot\Loot.hpp"

// Конфигурация
#define DEBUG_MODE 		True  	// Режим Диагностики (server.rpt)?
#define CRASH_TIMEOUT 	14400	// Время на исчезновение эвента, если игрок не нашел его (сек) 
#define SPAWN_CHANCE 	100	 	// Шанс спавна Эвента (0-100) 
#define GUARANTEED_LOOT	10	 	// Гарантированное количество лута
#define RANDOM_LOOT		10		// Рандомное дополнительное количество лута
#define SPAWN_FIRE 		True 	// Создать Дым/Огонь над ХелиКрашем?
#define FADE_FIRE 		False	// Дым/Огонь исчезнет со временем?
#define PREWAYPOINTS 	2		// Количество точек, который должен пройти вертолет, чтобы упасть
#define MIN_LOOT_RADIUS 8	 	// Минимальный радиус спавна лута от ХелиКраша (м)
#define MAX_LOOT_RADIUS 35	 	// Максимальный радиус спавна лута от ХелиКраша (м)
#define SHOW_MARKER		True	// Показывать маркер ХелиКраша?
#define LOWER_GRASS		False	// Убирать траву в зоне ХелиКраша
_crashDamage			= 0.5;	// Количество Урона, который может выдержать ХелиКраш до падения. Чем меньше значение, тем меньше выдержит!
_exploRange				= 300;	// Как далеко пролетит ХелиКраш перед падением, при поврежденном состоянии

// Параметры для поиска позиции
#define SEARCH_CENTER getMarkerPos "crashsites"
#define SEARCH_RADIUS (getMarkerSize "crashsites") select 0
#define SEARCH_DIST_MIN 20
#define SEARCH_SLOPE_MAX 2

_ran15		= 0;
_isClose1	= false;
_isClose2	= false;
_isClose3	= false;
_inFlight 	= true;
_missionEnd	= false;
_lootArray	= [];

_crashSelect = [["Mi17_DZ","Mi17Wreck",false],["UH60M_MEV_EP1","MH60Wreck",false]] call BIS_fnc_selectRandom;
_heliModel	 = _crashSelect select 0;
_crashModel	 = _crashSelect select 1;
_plane		 = _crashSelect select 2;
_porh		 = "helicopter";
_crashName	 = getText (configFile >> "CfgVehicles" >> _heliModel >> "displayName");
#define SPAWN_ROLL round(random 100)

call
{
	if (toLower worldName == "chernarus") exitWith {_blackList = [[[2092,14167],[10558,12505]]]; _heliStart = [[1000.0,2.0],[3500.0,2.0],[5000.0,2.0],[7500.0,2.0],[9712.0,663.067],[12304.0,1175.07],[14736.0,2500.0],[16240.0,5000.0],[16240.0,7500.0],[16240.0,10000.0]] call BIS_fnc_selectRandom;};
	if (toLower worldName == "napf") exitWith {_blackList = []; _heliStart = [[3458.7625, 2924.917],[11147.994, 1516.9348],[14464.443, 2533.0981],[18155.545, 1416.5674],[16951.584, 5436.3516],[16140.807, 12714.08],[14576.426, 14440.467],[8341.2383, 15756.525],[2070.4771, 8910.4111],[16316.533, 17309.357]] call BIS_fnc_selectRandom;};
};

if (DEBUG_MODE) then
{
	diag_log(format["[СЕРВЕР]: [ЭВЕНТ]: [Аним. ХелиКраш]: %1%2 Шанс спавна %3", SPAWN_CHANCE, '%', _crashName]);
};

if (SPAWN_ROLL <= SPAWN_CHANCE) then
{
	if (_plane) then
	{
		_porh = "plane";
	};
	
	// Если вам нужно сообщение о старте Эвента, то раскомментируйте
	[nil,nil,rTitleText,format["Хелик %1 вылетел!",_porh], "PLAIN",10] call RE;
	
	_position = [SEARCH_CENTER, 0, SEARCH_RADIUS, SEARCH_DIST_MIN, 0, SEARCH_SLOPE_MAX, 0, _blackList] call BIS_fnc_findSafePos;
	_position set [2, 0];
	
	if (DEBUG_MODE) then
	{
		diag_log(format["[СЕРВЕР]: [ЭВЕНТ]: [Аним. ХелиКраш]:  %1 начал полет от %2 к %3 СЕЙЧАС!(ВРЕМЯ:%4)", _crashName,  str(_heliStart), str(_position), round(time)]);
	};
	
	_startTime		=	time;
	_crashwreck		=	createVehicle [_heliModel,_heliStart, [], 0, "FLY"];
	dayz_serverObjectMonitor set [count dayz_serverObjectMonitor,_crashwreck];
	_crashwreck	engineOn true;
	_crashwreck	flyInHeight 150;

	if (_plane) then
	{
		_crashDamage = .5;
		_crashwreck setDamage .4;
		_crashwreck forceSpeed 250;
		_crashwreck setspeedmode "LIMITED";
	}
	else
	{
		_crashwreck forceSpeed 150;
		_crashwreck setspeedmode "NORMAL";
	};
	
	_landingzone	=	createVehicle ["HeliHEmpty", [_position select 0, _position select 1,0], [], 0, "CAN_COLLIDE"];
	_aigroup		=	creategroup civilian;
	_helipilot		=	_aigroup createUnit ["SurvivorW2_DZ",getPos _crashwreck,[],0,"FORM"];
	_helipilot setCombatMode "BLUE";
	_helipilot moveindriver _crashwreck;
	_helipilot assignAsDriver _crashwreck;
	
	uiSleep 0.5;
	
	if (PREWAYPOINTS > 0) then
	{
		for "_x" from 1 to PREWAYPOINTS do
		{
			_preWaypointPos = [SEARCH_CENTER,0,SEARCH_RADIUS,10,0,2000,0] call BIS_fnc_findSafePos;
			_wp = _aigroup addWaypoint [_preWaypointPos, 0];
			_wp setWaypointType "MOVE";
			_wp setWaypointBehaviour "CARELESS";
		};
	};
 
	_wp2 = _aigroup addWaypoint [position _landingzone, 0];
	_wp2 setWaypointType "MOVE";
	_wp2 setWaypointBehaviour "CARELESS";
	_wp2 setWaypointStatements ["true", "_crashwreck setDamage 1;"];
	
	while {_inFlight} do 
	{
		if ((_crashwreck distance _position) <= 1000 && !_isClose1) then 
		{
			if (_plane) then
			{
				_crashwreck flyInHeight 100;
				_crashwreck forceSpeed 150;
				_crashwreck setspeedmode "NORMAL";
				_exploRange = 360;
			}
			else
			{
				_crashwreck flyInHeight 100;
				_crashwreck forceSpeed 100;
				_crashwreck setspeedmode "NORMAL";
			};
			_isClose1 = true;
		};

		if ((_crashwreck distance _position) <= _exploRange && !_isClose2) then
		{
			if (_plane) then
			{
				_crashwreck setDamage 1;
				_vel	=	velocity _crashwreck;
				_dir	=	direction _crashwreck;
				_speed	=	100;
				_crashwreck setVelocity [(_vel select 0)-(sin _dir*_speed),(_vel select 1)-(cos _dir*_speed),(_vel select 2) - 30];
			}
			else
			{
				_crashwreck setHit ["mala vrtule", 1];
				_ran15	=	random 15;
				_crashwreck setVelocity [_ran15,_ran15,-25];
				_crashwreck setDamage .9;
			};
			_isClose2 = true;
		};

		if (getPos _crashwreck select 2 <= 30 && !_isClose3) then
		{
			_crashwreck setVelocity [_ran15,_ran15,-20];
			_isClose3 = true;
		};

		if (getPos _crashwreck select 2 <= 5) then
		{
			deleteVehicle _helipilot;
			_crashwreck setDamage 1;
			_inFlight = false;
		};
		uiSleep 1;
	};
	
	if (DEBUG_MODE) then
	{
		diag_log(format["[СЕРВЕР]: [ЭВЕНТ]: [Аним. ХелиКраш]: %1 упал в %2!", _crashName, getPos _crashwreck]);
	};
	
	_pos = [getPos _crashwreck select 0, getPos _crashwreck select 1,0];
	_dir = getDir _crashwreck;

	deleteVehicle _crashwreck;
	deleteVehicle _landingzone;

	_isWater = surfaceIsWater [getPos _crashwreck select 0, getPos _crashwreck select 1];
	
	// Упал в Воду
	if (_isWater) then
	{
		// Текст о падении в Воду (Если нужно, раскомментируйте)
		[nil,nil,rTitleText,format["Хелик %1 ебнулся в воду",_porh], "PLAIN",10] call RE;
	}
	else
	{
		_crash = createVehicle [_crashModel, _pos, [], 0, "CAN_COLLIDE"];
		_crash setDir _dir;
		
		if (SPAWN_FIRE) then
		{
			PVDZ_obj_Fire = [_crash, 4, time, false, FADE_FIRE];
			publicVariable "PVDZ_obj_Fire";
		};
		
		_num = round(random RANDOM_LOOT) + GUARANTEED_LOOT;
		
		_itemTypes = Loot_SelectSingle(Loot_GetGroup("CrashSiteType"));
		_lootGroup = Loot_GetGroup(_itemTypes select 2);
		{
			_maxLootRadius 	= (random MAX_LOOT_RADIUS) + MIN_LOOT_RADIUS;
			_lootPos 		= [_pos, _maxLootRadius, random 360] call BIS_fnc_relPos;
			_lootPos set [2, 0];
			_lootVeh = Loot_Spawn(_x, _lootPos, "");
			_lootVeh setVariable ["permaLoot", true];
			_lootArray set[count _lootArray, _lootVeh];

			if (LOWER_GRASS) then
			{
				createVehicle ["ClutterCutter_small_2_EP1", _lootPos, [], 0, "CAN_COLLIDE"];
			};
			
		} forEach Loot_Select(_lootGroup, _num);
			
		if (DEBUG_MODE) then
		{
			diag_log(format["[СЕРВЕР]: [ЭВЕНТ]: [Аним. ХелиКраш]: Лут отспавнен на позиции: '%1' Группа лута: '%2'", _lootPos, (_itemTypes select 2)]);
		};
		
		_endTime	=	time - _startTime;
		_startTime	=	time;
		
		// Текст о падении ХелиКраша (Если нужно, раскомментируйте)
		[nil,nil,rTitleText,format["Хелик %1 ебнулся где-то на карте!",_porh], "PLAIN",10] call RE;
		
		if (DEBUG_MODE) then
		{
			diag_log(format["[СЕРВЕР]: [ЭВЕНТ]: [Аним. ХелиКраш]: ХелиКраш выполнен! Модель: %2 - Время: %1 секунд || Дистанция пройдена POC: %3 метров", round(_endTime), str(_pos), round(_position distance _crash)]);
		};
		
		_marker_position = [_pos,0,800,0,1,2000,0] call BIS_fnc_findSafePos;
		
		if (SHOW_MARKER) then
		{
			_marker = createMarker [format ["dot_%1", _startTime], _marker_position];
			_marker setMarkerType "FOB";
			
			//uiSleep 120; 

			//deleteMarker _marker;
		}; 

		while {!_missionEnd} do
		{
			if ((time - _startTime) >= CRASH_TIMEOUT) then
			{
				deleteVehicle _crash;
				{deleteVehicle _x;} forEach _lootArray;
				{deleteVehicle _x;} forEach nearestObjects [_pos, ["CraterLong"], 15];
				
				// Текст об исчезновении ХелиКраша (время на поиск вышло) (если нужно, раскомментируйте)
				//[nil,nil,rTitleText,format["Survivors did not secure the %1 crash site!",_crashName], "PLAIN",10] call RE;
				
				if (DEBUG_MODE) then
				{
					diag_log(format["[СЕРВЕР]: [ЭВЕНТ]: [Аним. ХелиКраш]: %1 ХелиКраш - Время вышло, удаляем все!",_crashName]);
				};
				_missionEnd = true;
			};

			{
				if ((isPlayer _x) && (_x distance _pos <= 25)) then
				{
					_finder = name _x;
					
					// Текст о нахождении ХелиКраша (Если нужно, раскомментируйте)
					//[nil,nil,rTitleText,format["Survivors have secured the crash site!"], "PLAIN",10] call RE;
					
					if (DEBUG_MODE) then
					{
						diag_log(format["[СЕРВЕР]: [ЭВЕНТ]: [Аним. ХелиКраш]: ХелиКраш был найден игроком: %1, удаляем маркер" , _finder]);
					};
					_missionEnd = true;
				};
			} forEach playableUnits;

			if (!SHOW_MARKER) then
			{
				uiSleep 3;
			};
		};
	};
};

deleteGroup _aigroup;
