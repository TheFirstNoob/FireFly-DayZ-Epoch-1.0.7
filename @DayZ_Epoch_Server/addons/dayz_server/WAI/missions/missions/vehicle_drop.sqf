local _mission = count WAI_MissionData -1;
local _aiType = _this select 0;
local _hero = (_aiType == "Hero");
local _position = [30] call WAI_FindPos;
local _difficulty = "Medium";
local _completionType = ["crate"];
local _color = "ColorYellow";

//Armed Land Vehicle
local _vehclass = WAI_ArmedVeh call BIS_fnc_selectRandom;
local _vehname = getText (configFile >> "CfgVehicles" >> _vehclass >> "displayName");

// Plane
local _airClass = ["C130J_US_EP1_DZ","MV22_DZ"] call BIS_fnc_selectRandom;
local _airName = getText (configFile >> "CfgVehicles" >> _airClass >> "displayName");
local _name = format["%1 Air Drop",_airName];
local _localName = ["STR_CL_AIRDROP_TITLE",_airName];
_name = ["Bandit " + _name,"Hero " + _name] select _hero;
local _localized = ["STR_CL_MISSION_BANDIT","STR_CL_MISSION_HERO"] select _hero;
local _text = [_localized,_localName];

diag_log format["[WAI]: %1 started at %2.",_name,_position];

//Troops
[_position,5,_difficulty,"Random","AT","Random",_aiType,"Random",_aiType,_mission] call WAI_SpawnGroup;
[_position,5,_difficulty,"Random","AA","Random",_aiType,"Random",_aiType,_mission] call WAI_SpawnGroup;
[_position,(ceil random 4),_difficulty,"Random","","Random",_aiType,"Random",_aiType,_mission] call WAI_SpawnGroup;
[_position,(ceil random 4),_difficulty,"Random","","Random",_aiType,"Random",_aiType,_mission] call WAI_SpawnGroup;

if(WAI_DebugMode) then {
	diag_log format["WAI: [%3] %1 Vehicle Drop spawned a %2",_airName,_vehname,_aiType];
};

local _messages = if (_hero) then {
	[["STR_CL_HERO_AIRDROP_ANNOUNCE",_airName,_vehname],["STR_CL_HERO_AIRDROP_CRASH",_airName],["STR_CL_HERO_AIRDROP_DROP",_vehname],["STR_CL_HERO_AIRDROP_WIN",_vehname],["STR_CL_HERO_AIRDROP_FAIL",_vehname]];
} else {
	[["STR_CL_BANDIT_AIRDROP_ANNOUNCE",_airName,_vehname],["STR_CL_BANDIT_AIRDROP_CRASH",_airName],["STR_CL_BANDIT_AIRDROP_DROP",_vehname],["STR_CL_BANDIT_AIRDROP_WIN",_vehname],["STR_CL_BANDIT_AIRDROP_FAIL",_vehname]];
};

local _msgstart = _messages select 0;
local _msgcrash = _messages select 1;
local _msgdrop = _messages select 2;
local _msgwin = _messages select 3;
local _msglose = _messages select 4;
local _mines = [];

if(WAI_EnableMineField) then {
	_mines = [_position,50,75,100] call WAI_MineField;
};

local _startDist = 10000; // increase or decrease this number to adjust the time it takes the plane to get to the mission.
local _PorM = if (random 1 > .5) then {"+"} else {"-"};
local _PorM2 = if (random 1 > .5) then {"+"} else {"-"};
local _startPos = call compile format ["[(%1 select 0) %2 %4,(%1 select 1) %3 %4, 300]",_position,_PorM,_PorM2,_startDist];

uiSleep 2;

local _timeout = false;
local _playerNear = false;
local _complete = false;
local _starttime = diag_tickTime;
local _aiCount = (WAI_MissionData select _mission) select 0;
local _unitGroups = (WAI_MissionData select _mission) select 1;
//local _aiVehicles = (WAI_MissionData select _mission) select 3;
local _vehicles = (WAI_MissionData select _mission) select 4;
local _killpercent = _aiCount - (_aiCount * (WAI_KillPercent / 100));
local _loot = if (_hero) then {Loot_VehicleDrop select 0;} else {Loot_VehicleDrop select 1;};
local _playerArray = [];
local _timeStamp = diag_tickTime;
local _closestPlayer = objNull;
local _acArray = [];
local _claimed = false;
local _acTime = diag_tickTime;
local _claimTime = 0;
local _left = false;
local _leftTime = 0;
local _vehDropped = false;
local _onGround = false;
local _onGroundMarker = false;

local _dropzone = "HeliHEmpty" createVehicle [0,0,0];
_dropzone setPos _position;

local _plane = _airClass createVehicle _startPos;
local _dir = [_plane, _dropzone] call BIS_fnc_relativeDirTo;
_plane setDir _dir;
_plane setPos _startPos;
dayz_serverObjectMonitor set [count dayz_serverObjectMonitor,_plane];
_plane engineOn true;
_plane setVelocity [(sin _dir*150),(cos _dir*150),0];
_plane flyInHeight 200;

local _aigroup = createGroup civilian;
local _pilot = _aigroup createUnit ["SurvivorW2_DZ",_startPos,[],0,"FORM"];
[_pilot] joinSilent _aigroup;
_pilot setSkill 1;
_pilot setCombatMode "BLUE";
_pilot moveInDriver _plane;
_pilot assignAsDriver _plane;
_aigroup setSpeedMode "LIMITED";

local _wp = _aigroup addWaypoint [_position, 0];
_wp setWaypointType "MOVE";
_wp setWaypointBehaviour "CARELESS";
_wp setWaypointCompletionRadius 50;

local _time = 0;
local _dropTime = 0;
local _vehicle = objNull;
local _parachute = objNull;
local _vehPos = [];

local _warnArray = [];
local _markers = [1,1,1,1,1];
local _newCount = 0;
local _dotMarker = "WAI" + str(_mission) + "dot";
local _autoMarkDot = "WAI" + str(_mission) + "autodot";
local _autoText = "";
local _player = objNull;

DZE_MissionPositions set [count DZE_MissionPositions, _position];
local _posIndex = count DZE_MissionPositions - 1;

// Create initial markers
if (WAI_ShowCount) then {
	_text = if (_hero) then {
		["STR_CL_MISSION_HERO_COUNT",_localName,_aiCount,"STR_CL_MISSION_HEROS"];
	} else {
		["STR_CL_MISSION_BANDIT_COUNT",_localName,_aiCount,"STR_CL_MISSION_BANDITS"];
	};
};

//[position,createMarker,setMarkerColor,setMarkerType,setMarkerShape,setMarkerBrush,setMarkerSize,setMarkerText,setMarkerAlpha]
_markers set [0, [_position, "WAI" + str(_mission), _color, "", "ELLIPSE", "Solid", [300,300], [], 0]];
_markers set [1, [_position, _dotMarker, "ColorBlack", "mil_dot", "", "", [], _text, 0]];
if (WAI_AutoClaim) then {_markers set [2, [_position, "WAI" + str(_mission) + "auto", "ColorRed", "", "ELLIPSE", "Border", [WAI_AcAlertDistance,WAI_AcAlertDistance], [], 0]];};
DZE_ServerMarkerArray set [count DZE_ServerMarkerArray, _markers]; // Markers added to global array for JIP player requests.
local _markerIndex = count DZE_ServerMarkerArray - 1;
PVDZ_ServerMarkerSend = ["start",_markers];
publicVariable "PVDZ_ServerMarkerSend";

WAI_MarkerReady = true;

[_difficulty,_msgstart] call WAI_Message;

while {!_complete} do {

	if (!alive _plane && {!_vehDropped}) exitWith {
		[_difficulty,_msgcrash] call WAI_Message;
		[_position, _mission, [], _vehicles, [], _unitGroups, [], _posIndex, true] spawn WAI_CleanUp;
		diag_log format["WAI: [Mission: %1]: The %2 crashed at %3",_name, _airName, _position];
	};

	if ((_plane distance _position < 230) && {!_vehDropped}) then {
		uiSleep 1; // This gets the drop near the center of the mission
		local _planePos = [_plane] call FNC_GetPos;
		uiSleep 1; // need to do this otherwise the C130 blows up
		_parachute = createVehicle ["ParachuteMediumEast", _planePos, [], 0, "FLY"];
		_parachute setPos _planePos;
		_vehicle = [_vehclass,_planePos,_mission] call WAI_PublishVeh;
		_vehicle attachTo [_parachute, [0, 0, 1]];
		_time = diag_tickTime;
		[_difficulty,_msgdrop] call WAI_Message;
		local _return = _aigroup addWaypoint [_startPos, 0];
		_return setWaypointType "MOVE";
		_return setWaypointBehaviour "CARELESS";
		[_plane,_aigroup] spawn WAI_CleanAircraft;
		_vehDropped = true;
	};
	
	if (_vehDropped && {!_onGround}) then {
		_dropTime = diag_tickTime - _time; // used to override if stuck in a tree or on top of a building
		if (((([_parachute] call FNC_GetPos) select 2) < 6) || {_dropTime > 55}) then {
			detach _vehicle;
			deleteVehicle _parachute;
			_vehPos = [_vehicle] call FNC_GetPos;
			//_vehPos set [2,0];
			//_position = _vehPos;
			_onGround = true;
		};
	};
	
	if (count _mines > 0) then {
		{
			_player = _x;
			if (vehicle _player != _player && {_player distance _position < 300} && {!(_player in _playerArray)}) then {
				RemoteMessage = ["dynamic_text",["","STR_CL_MINEFIELD_WARNING"], ["0","#FFFFFF","0.50","#ff3300",0,.3,10,0.5]];
				(owner _player) publicVariableClient "RemoteMessage";
				_playerArray set [count _playerArray, _player];
			};
			
			if (vehicle _player != _player && {_player distance _position < 75} && {alive _player} && {(([vehicle _player] call FNC_GetPos) select 2) < 1}) then {
				"Bo_GBU12_lgb" createVehicle ([vehicle _player] call FNC_GetPos);
			};
		} count playableUnits;
	};
	
	if (WAI_AutoClaim) then {
		#include "\z\addons\dayz_server\WAI\compile\auto_claim.sqf"	
	};
	
	if (WAI_ShowCount) then {
		_newCount = (WAI_MissionData select _mission) select 0;
		if (_newCount != _aiCount) then {
			_aiCount = _newCount;
			_text = if (_hero) then {
				["STR_CL_MISSION_HERO_COUNT",_localName,_aiCount,"STR_CL_MISSION_HEROS"];
			} else {
				["STR_CL_MISSION_BANDIT_COUNT",_localName,_aiCount,"STR_CL_MISSION_BANDITS"];
			};
			PVDZ_ServerMarkerSend = ["textSingle",[_dotMarker,_text]];
			publicVariable "PVDZ_ServerMarkerSend";
			(_markers select 1) set [7, _text];
			DZE_ServerMarkerArray set [_markerIndex, _markers];
		};
	};
	
	if (_onGround && !_onGroundMarker) then {
		_onGroundMarker = true;
		//[position,createMarker,setMarkerColor,setMarkerType,setMarkerShape,setMarkerBrush,setMarkerSize,setMarkerText,setMarkerAlpha]
		_markers set [4, [_vehPos, "WAI" + str(_mission) + "vehicle", "ColorBlack", "mil_dot", "", "", [], [_vehclass], 0]];
		DZE_ServerMarkerArray set [_markerIndex, _markers];
		PVDZ_ServerMarkerSend = ["createSingle",(_markers select 4)];
		publicVariable "PVDZ_ServerMarkerSend";
	};
	
	// Timeout check
	_playerNear = [_position,WAI_TimeoutDist] call isNearPlayer;
	if (diag_tickTime - _starttime >= (WAI_Timeout * 60) && !_playerNear) then {
		_complete = true;
		[_position, _mission, [], _vehicles, [], _unitGroups, [], _posIndex, true] spawn WAI_CleanUp;
		[_difficulty,_msglose] call WAI_Message;
		diag_log format["WAI: [Mission: %1]: Timed out at %2",_name,_position];
	} else {
		if (_playerNear) then {_starttime = diag_tickTime;};
	};
	
	// Completion check
	if (_onGround) then {
		if ([_mission,_completionType,_killpercent,_vehPos] call WAI_CompletionCheck) then {
			_complete = true;
			[_vehicle,_mission,[[_vehicle]]] call WAI_GenerateVehKey;
			_vehicle setVehicleLock "unlocked";
			[_vehicle,_vehclass,2] call WAI_LoadAmmo;
			[_vehicle,_loot] call WAI_DynCrate;
			[_position, _mission, [], _vehicles, [], _unitGroups, [], _posIndex, false] spawn WAI_CleanUp;
			[_difficulty,_msgwin] call WAI_Message;
			diag_log format["WAI: [Mission: %1]: Completed at %2",_name,_position];
		};
	};
	uiSleep 1;
};

// Remove the plane and crew
if (alive _plane) then {
	[_plane,_aigroup] spawn WAI_CleanAircraft;
};

// Remove all mines if they exist
{deleteVehicle _x;} count _mines;

deleteVehicle _dropzone;

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

DZE_ServerMarkerArray set [_markerIndex, -1];
WAI_MissionData set [_mission, -1];

