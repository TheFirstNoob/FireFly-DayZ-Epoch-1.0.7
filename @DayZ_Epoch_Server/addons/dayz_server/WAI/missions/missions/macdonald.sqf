local _mission = count WAI_MissionData -1;
local _aiType = _this select 0; // "Bandit" or "Hero"
local _position = [30] call WAI_FindPos;
local _name = "The Farm";
local _startTime = diag_tickTime;
local _difficulty = "Hard";
local _localized = ["STR_CL_MISSION_BANDIT", "STR_CL_MISSION_HERO"] select (_aiType == "Hero");
local _localName = "STR_CL_FARM_TITLE";

diag_log format["[WAI]: %1 %2 started at %3.",_aiType,_name,_position];

local _messages = ["STR_CL_FARM_ANNOUNCE","STR_CL_FARM_WIN","STR_CL_FARM_FAIL"];

////////////////////// Do not edit this section ///////////////////////////
local _markers = [1,1,1,1];
//[position,createMarker,setMarkerColor,setMarkerType,setMarkerShape,setMarkerBrush,setMarkerSize,setMarkerText,setMarkerAlpha]
_markers set [0, [_position, "WAI" + str(_mission), "ColorRed", "", "ELLIPSE", "Solid", [300,300], [], 0]];
_markers set [1, [_position, "WAI" + str(_mission) + "dot", "ColorBlack", "mil_dot", "", "", [], [_localized,_localName], 0]];
if (WAI_AutoClaim) then {_markers set [2, [_position, "WAI" + str(_mission) + "auto", "ColorRed", "", "ELLIPSE", "Border", [WAI_AcAlertDistance,WAI_AcAlertDistance], [], 0]];};
DZE_ServerMarkerArray set [count DZE_ServerMarkerArray, _markers]; // Markers added to global array for JIP player requests.
_markerIndex = count DZE_ServerMarkerArray - 1;
PVDZ_ServerMarkerSend = ["start",_markers];
publicVariable "PVDZ_ServerMarkerSend";

WAI_MarkerReady = true;

// Add the mission's position to the global array so that other missions do not spawn near it.
DZE_MissionPositions set [count DZE_MissionPositions, _position];
local _posIndex = count DZE_MissionPositions - 1;

// Send announcement
[_difficulty,(_messages select 0)] call WAI_Message;

// Wait until a player is within range or timeout is reached.
local _timeout = false;
local _claimPlayer = objNull;

while {WAI_WaitForPlayer && !_timeout && {isNull _claimPlayer}} do {
	_claimPlayer = [_position, WAI_TimeoutDist] call isClosestPlayer;
	
	if (diag_tickTime - _startTime >= (WAI_Timeout * 60)) then {
		_timeout = true;
	};
	uiSleep 1;
};

if (_timeout) exitWith {
	[_mission, _aiType, _markerIndex, _posIndex] call WAI_AbortMission;
	[_difficulty,(_messages select 2)] call WAI_Message;
	diag_log format["WAI: %1 %2 aborted.",_aiType,_name,_position];
};
//////////////////////////////// End //////////////////////////////////////

//Spawn Crates
local _loot = if (_aiType == "Hero") then {Loot_MacDonald select 0;} else {Loot_MacDonald select 1;};
[[
	[_loot,WAI_CrateSm,[.02,0,.15]]
],_position,_mission] call WAI_SpawnCrate;

// Spawn Objects
[[
	["MAP_sara_stodola",[4,-5,-0.12]],
	["MAP_HouseV_2T2",[18,-11,-0.14]],
	["MAP_t_quercus3s",[32.4,-32,-0.14]],
	["MAP_t_quercus2f",[14,-3,-0.14]],
	["MAP_t_pinusN2s",[-12,5,-0.14]],
	["datsun01Wreck",[-10,-1,-0.02]],
	["Haystack",[-1,-32,-0.02]],
	["Haystack_small",[-25,-36,-0.16]],
	["Haystack_small",[33,-43,-0.02]],
	["Haystack_small",[10,-49,-0.02]],
	["Haystack_small",[13,60,-0.02]],
	["Haystack_small",[-33,-51,-0.02]],
	["Haystack_small",[20,-67,-0.02]],
	["Land_Shed_wooden",[10,-24,-0.02]],
	["fiberplant",[12,-23,-0.02]]
],_position,_mission] call WAI_SpawnObjects;

//Troops
[[(_position select 0) - 1, (_position select 1) - 10, 0],5,_difficulty,"Random","AT","Random",_aiType,"Random",_aiType,_mission] call WAI_SpawnGroup;
[[(_position select 0) - 2, (_position select 1) - 50, 0],5,_difficulty,"Random","AA","Random",_aiType,"Random",_aiType,_mission] call WAI_SpawnGroup;
[[(_position select 0) - 1, (_position select 1) + 11, 0],5,_difficulty,"Random","","Random",_aiType,"Random",_aiType,_mission] call WAI_SpawnGroup;
[[(_position select 0) - 1, (_position select 1) + 11, 0],(ceil random 5),_difficulty,"Random","","Random",_aiType,"Random",_aiType,_mission] call WAI_SpawnGroup;
[[(_position select 0) - 1, (_position select 1) + 11, 0],(ceil random 5),_difficulty,"Random","","Random",_aiType,"Random",_aiType,_mission] call WAI_SpawnGroup;

//Humvee Patrol
[[(_position select 0) - 27, (_position select 1) - 18, 0],[(_position select 0) + 32, (_position select 1) + 1, 0],50,2,"Offroad_DSHKM_Gue_DZ",_difficulty,_aiType,_aiType,_mission] call WAI_VehPatrol;
 
//Static Guns
[[[(_position select 0) - 12, (_position select 1) - 18, 0]],"M2StaticMG",_difficulty,_aiType,_aiType,"Random","Random","Random",_mission] call WAI_SpawnStatic;

[
	_mission, // Mission number
	_position, // Position of mission
	_difficulty, // Difficulty
	_name, // Name of Mission
	_localName, // localized marker text
	_aiType, // "Bandit" or "Hero"
	_markerIndex,
	_posIndex,
	_claimPlayer,
	true, // show mission marker?
	true, // make minefields available for this mission
	["crate"], // Completion type: ["crate"], ["kill"], or ["assassinate", _unitGroup],
	_messages
] spawn WAI_MissionMonitor;