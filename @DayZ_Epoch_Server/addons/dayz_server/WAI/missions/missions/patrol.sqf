local _mission = count WAI_MissionData -1;
local _aiType = _this select 0; // "Hero" or "Bandit"
local _hero = (_aiType == "Hero");
local _loot = if (_aiType == "Hero") then {Loot_Patrol select 0;} else {Loot_Patrol select 1;};
local _localName = "STR_CL_WAIPATROL_TITLE";
local _difficulty = "Medium";
local _completionType = ["kill"];

//Armed Land Vehicle
local _vehclass = WAI_ArmedVeh call BIS_fnc_selectRandom;
local _vehname = getText (configFile >> "CfgVehicles" >> _vehclass >> "displayName");

local _locations = nearestLocations [getMarkerPos "center", ["NameCityCapital","NameCity","NameVillage"],15000];
local _location = _locations call BIS_fnc_selectRandom;
local _position = position _location;
local _locationName = text _location;
local _blacklist = ["Stary Sobor"];

{
	if ((text _x) == _locationName || (text _x) in _blacklist) then {
		_locations = [_locations,_forEachIndex] call fnc_deleteAt;
	};
} forEach _locations;

DZE_MissionPositions set [count DZE_MissionPositions, _position];
local _posIndex = count DZE_MissionPositions - 1;

diag_log format["[WAI]: %2 Patrol: Starting at %1",_position,_aiType];

//Spawn units
local _unitGroup = [[(_position select 0) + 4,(_position select 1),0.1],3,"Patrol","Random","","Random",_aiType,"Random",_aiType,_mission] call WAI_SpawnGroup;

//Spawn vehicles
local _vehicle = [_vehclass,_position,_mission] call WAI_PublishVeh;

// load the guns
[_vehicle,_vehclass] call WAI_LoadAmmo;

if (WAI_DebugMode) then {
	diag_log format["[WAI]: %2 patrol spawned a %1",_vehname,_aiType];
};

local _messages = if (_hero) then {
	[["STR_CL_HERO_PATROL_ANNOUNCE",_locationName],"STR_CL_HERO_PATROL_WIN","STR_CL_HERO_PATROL_FAIL"];
} else {
	[["STR_CL_BANDIT_PATROL_ANNOUNCE",_locationName],"STR_CL_BANDIT_PATROL_WIN","STR_CL_BANDIT_PATROL_FAIL"];
};

local _name = format["Patrol %1",_vehname];
_name = if (_hero) then {"Hero " + _name;} else {"Bandit " + _name;};
local _localized = if (_hero) then {"STR_CL_MISSION_HERO";} else {"STR_CL_MISSION_BANDIT";};
local _text = [_localized,_localName];
local _numWaypoints	= 3;
local _msgstart = _messages select 0;
local _msgwin = _messages select 1;
local _msglose = _messages select 2;
local _wayPoints = [];

for "_i" from 0 to _numWaypoints - 1 do {
	_location = _locations call BIS_fnc_selectRandom;
	_wayPoints set [_i, _location];
	{
		if ((text _x) == (text _location)) then {
			_locations = [_locations,_forEachIndex] call fnc_deleteAt;
		};
	} forEach _locations;
	_wp = _unitGroup addWayPoint [position _location,0];
	_wp setWaypointType "MOVE";
	_wp setWaypointSpeed "LIMITED";
	//_wp setWaypointSpeed "FULL";
	_wp setWaypointBehaviour "CARELESS";
	//_wp setWaypointCombatMode "YELLOW";
	_wp setWaypointCombatMode "SAFE";
	_wp setWaypointCompletionRadius 300;
};

uiSleep 2;

local _startMarker = false;
local _timeout = false;
local _playerNear = false;
local _complete = false;
local _starttime = diag_tickTime;
local _aiCount	= (WAI_MissionData select _mission) select 0;
local _killpercent = _aiCount - (_aiCount * (WAI_KillPercent / 100));
local _leader = leader _unitgroup;
_vehicle setDamage 0;
_vehicle removeAllEventHandlers "HandleDamage";
_vehicle addEventHandler ["HandleDamage",{_this call fnc_veh_handleDam}];
local _wpReached = true;
local _disabled = false;
local _currentWP = nil;
local _index = 1;
local _markers = [1,1];
local _markerIndex = -1;
local _unitGroup2 = grpNull;

{
	if (_leader == _x) then {
		_x assignAsDriver _vehicle;
		_x moveInDriver _vehicle;
	} else {
		if ((_vehicle emptyPositions "gunner") > 0) then {
			_x assignAsGunner _vehicle;
			_x moveInGunner _vehicle;
		} else {
			if ((_vehicle emptyPositions "commander") > 0) then {
				_x assignAsCommander _vehicle;
				_x moveInCommander _vehicle;
			} else {
			_x moveInCargo _vehicle;
		};
	};
} count (units _unitgroup);

_vehicle addEventHandler ["GetOut",{
	local _veh = _this select 0;
	local _role = _this select 1;
	local _unit = _this select 2;
	if (_role == "gunner") then {
		_unit moveInGunner _veh;
	};
}];

WAI_MarkerReady = true;

[_difficulty,_msgstart] call WAI_Message;

while {!_timeout && !_complete} do {
	
	if (count _wayPoints == 0 && _wpReached) then {
		_timeout = true;
		[_position, _mission, [], [_vehicle], [], [_unitGroup], [], _posIndex, true] spawn WAI_CleanUp;
		diag_log format["WAI: [Mission: %1]: Timed out at %2",_name,_position];
	};
	
	if (count _wayPoints > 0 && _wpReached) then {
		
		if (!isNil "_currentWP") then {
			_wayPoints = [_wayPoints, 0] call fnc_deleteAt;
		};
		
		_unitGroup setCurrentWaypoint [_unitGroup, _index];
		_currentWP = _wayPoints select 0;
		_wpReached = false;
		uiSleep 10;
		[_difficulty,["STR_CL_PATROL_MOVE",(text _currentWP)]] call WAI_Message;
		if (WAI_DebugMode) then {diag_log format ["Patrol Mission: Current waypoint for group %1: %2, Current Index: %3", _unitGroup, (currentWaypoint _unitGroup), _index];};
		_index = _index + 1;
	};
	
	if (count crew _vehicle > 0) then {
		_vehicle setVehicleAmmo 1;
		_vehicle setFuel 1;
	};
	
	if (!_disabled && (!(canMove _vehicle) || !(alive _leader))) then {
		[_difficulty,["STR_CL_PATROL_DISABLED",(["Bandit", "Hero"] select _hero)]] call WAI_Message;
		_disabled = true;
		_startMarker = true;
		_position = getPos _vehicle;
		_unitGroup2 = createGroup EAST; // Creating a new group seems to be the best solution here
		{[_x] joinSilent _unitGroup2} forEach (units _unitGroup);
		_unitGroup2 selectLeader ((units _unitGroup2) select 0);
		_unitGroup2 setFormation "ECH LEFT";
		_unitGroup2 setCombatMode "RED";
		_unitGroup2 setBehaviour "COMBAT";
		[_unitGroup2,_position,"easy"] call WAI_SetWaypoints;
	};
	
	if (_startMarker) then {
		_startMarker = false;
		//[position,createMarker,setMarkerColor,setMarkerType,setMarkerShape,setMarkerBrush,setMarkerSize,setMarkerText,setMarkerAlpha]
		_markers set [0, [_position, "WAI" + str(_mission), "ColorYellow", "", "ELLIPSE", "Solid", [300,300], [], 0]];
		_markers set [1, [_position, "WAI" + str(_mission) + "dot", "ColorBlack", "mil_dot", "", "", [], _text, 0]];
		DZE_ServerMarkerArray set [count DZE_ServerMarkerArray, _markers]; // Markers added to global array for JIP player requests.
		_markerIndex = count DZE_ServerMarkerArray - 1;
		PVDZ_ServerMarkerSend = ["start",_markers];
		publicVariable "PVDZ_ServerMarkerSend";
	};
	
	if (!_wpReached) then {
		if (_vehicle distance (position _currentWP) < 300) then {
			_wpReached = true;
			[_difficulty,["STR_CL_PATROL_ARRIVE",text _currentWP]] call WAI_Message;
		};
	};
	
	// Timeout check
	_playerNear = [_position,WAI_TimeoutDist] call isNearPlayer;
	if (diag_tickTime - _starttime >= WAI_Timeout && !_playerNear) then {
		_timeout = true;
		[_position, _mission, [], [_vehicle], [], [_unitGroup], [], _posIndex, true] spawn WAI_CleanUp;
		diag_log format["WAI: [Mission: %1]: Timed out at %2",_name,_position];
	} else {
		if (_playerNear) then {_starttime = diag_tickTime;};
	};
	
	// Completion check
	if ([_mission,_completionType,_killpercent,_position] call WAI_CompletionCheck) then {
		_complete = true;
		[_vehicle,_mission,[[_vehicle]]] call WAI_GenerateVehKey;
		_vehicle setVehicleLock "UNLOCKED";
	
		[_vehicle,_loot] call WAI_DynCrate; // put loot in the vehicle
		
		[_position, _mission, [], [], [], [_unitGroup], [], _posIndex, false] spawn WAI_CleanUp;
		[_difficulty,_msgwin] call WAI_Message;
		diag_log format["WAI: [Mission: %1]: Completed at %2",_name,_position];
	};
	
	uiSleep 2;
};

// Tell all clients to remove the markers from the map
local _remove = [];
{
	if (typeName _x == "ARRAY") then {
		_remove set [count _remove, (_x select 1)];
	};
} count _markers;
PVDZ_ServerMarkerSend = ["end",_remove];
publicVariable "PVDZ_ServerMarkerSend";

if (_hero) then {
	WAI_HeroRunning = WAI_HeroRunning - 1;
	WAI_HeroStartTime = diag_tickTime;
} else {
	WAI_BanditRunning = WAI_BanditRunning - 1;
	WAI_BanditStartTime = diag_tickTime;
};

if (_markerIndex != -1) then {
	DZE_ServerMarkerArray set [_markerIndex, -1];
};
WAI_MissionData set [_mission, -1];