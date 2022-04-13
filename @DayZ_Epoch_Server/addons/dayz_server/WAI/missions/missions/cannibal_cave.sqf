local _mission = count WAI_MissionData -1;
local _aiType = _this select 0; // "Bandit" or "Hero"
local _position = [80] call WAI_FindPos;
local _name = "Cannibal Cave";
local _startTime = diag_tickTime;
local _difficulty = "Hard";
local _localized = ["STR_CL_MISSION_BANDIT", "STR_CL_MISSION_HERO"] select (_aiType == "Hero");
local _localName = "STR_CL_CANNIBALCAVE_TITLE";

diag_log format["[WAI]: %1 %2 started at %3.",_aiType,_name,_position];

local _messages = ["STR_CL_CANNIBALCAVE_ANNOUNCE","STR_CL_CANNIBALCAVE_WIN","STR_CL_CANNIBALCAVE_FAIL"];

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
local _loot = if (_aiType == "Hero") then {Loot_CannibalCave select 0;} else {Loot_CannibalCave select 1;};
[[
	[_loot,WAI_CrateLg,[5,7]]
],_position,_mission] call WAI_SpawnCrate;

// Spawn Objects
[[
	["MAP_R2_RockWall",[10,28,-4.15]],
	["MAP_R2_RockWall",[-23,9,-6.55],-96.315],
	["MAP_R2_RockWall",[25,4,-7.74],262.32],
	["MAP_R2_RockWall",[1,7,10.81],-29.29],
	["MAP_R2_RockWall",[18,-11,-5.509],-222.72],
	["MAP_R2_RockWall",[-22,6,-11.55],-44.01],
	["MAP_t_picea2s",[-13,-32,-0.1]],
	["MAP_t_picea2s",[-17,6,-0.2]],
	["MAP_t_pinusN2s",[-24,-53,-0.2]],
	["MAP_t_pinusN1s",[-22,-42,-0.2]],
	["MAP_t_picea1s",[-22.3,-35,-0.2]],
	["MAP_t_picea2s",[-33,-53,-0.2]],
	["MAP_t_picea2s",[-3,-43,-0.2]],
	["MAP_t_picea2s",[28,-39,-0.2]],
	["MAP_t_picea2s",[13,43,-0.2]],
	["MAP_t_picea1s",[57,11,-0.2]],
	["MAP_t_quercus3s",[31,49.3,-0.2]],
	["MAP_t_quercus3s",[-47,20,-0.2]],
	["MAP_R2_Rock1",[-47,-45,-14.29]],
	["Land_Campfire_burning",[-0.01,-0.01]],
	["Mass_grave",[-6,-7,-0.02],-50.94],
	["SKODAWreck",[-11,-46],151.15],
	["datsun01Wreck",[-2,-60],34.54],
	["UralWreck",[-41.3,-26],19.15]
],_position,_mission] call WAI_SpawnObjects;

[[(_position select 0) + 12, (_position select 1) + 42.5, .01],5,_difficulty,"Random","AT","random",_aiType,"random",_aiType,_mission] call WAI_SpawnGroup;
[[(_position select 0) + 11, (_position select 1) + 41, .01],5,_difficulty,"Random","AA","random",_aiType,"random",_aiType,_mission] call WAI_SpawnGroup;
[[(_position select 0) - 12, (_position select 1) - 43, .01],5,_difficulty,"Random","","random",_aiType,"random",_aiType,_mission] call WAI_SpawnGroup;
[[(_position select 0) - 13, (_position select 1) - 43, .01],(ceil random 5),"random","Random","","random",_aiType,"random",_aiType,_mission] call WAI_SpawnGroup;
[[(_position select 0) - 20, (_position select 1) - 43, .01],(ceil random 5),"random","Random","","random",_aiType,"random",_aiType,_mission] call WAI_SpawnGroup;

[
	_mission,
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