local _mission = count WAI_MissionData -1;
local _aiType = _this select 0; // "Bandit" or "Hero"
local _position = [80] call WAI_FindPos;
local _name = "Drone Pilot";
local _startTime = diag_tickTime;
local _difficulty = "Hard";
local _localized = ["STR_CL_MISSION_BANDIT", "STR_CL_MISSION_HERO"] select (_aiType == "Hero");
local _localName = "STR_CL_DRONE_TITLE";

diag_log format["[WAI]: %1 %2 started at %3.",_aiType,_name,_position];

local _messages = if (_aiType == "Hero") then {
	["STR_CL_HERO_DRONE_ANNOUNCE","STR_CL_HERO_DRONE_WIN","STR_CL_HERO_DRONE_FAIL"];
} else {
	["STR_CL_BANDIT_DRONEPILOT_ANNOUNCE","STR_CL_BANDIT_DRONEPILOT_WIN","STR_CL_BANDIT_DRONEPILOT_FAIL"];
};

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
local _loot = if (_aiType == "Hero") then {Loot_DronePilot select 0;} else {Loot_DronePilot select 1;};
[[
	[_loot,WAI_CrateLg,[2,0]]
],_position,_mission] call WAI_SpawnCrate;

// Spawn Objects
[[
	["MQ9PredatorB",[11,-28]],
	["TK_WarfareBUAVterminal_EP1",[-6,-15],-153.81],
	["Land_budova4_in",[-13,3.5]],
	["Land_Vysilac_FM",[-10,-7]],
	["MAP_runway_poj_draha",[10,5]],
	["ClutterCutter_EP1",[10,36]],
	["ClutterCutter_EP1",[10,30]],
	["ClutterCutter_EP1",[10,24]],
	["ClutterCutter_EP1",[10,18]],
	["ClutterCutter_EP1",[10,12]],
	["ClutterCutter_EP1",[10,6]],
	["ClutterCutter_EP1",[10,0.1]],
	["ClutterCutter_EP1",[10,-6]],
	["ClutterCutter_EP1",[10,-12]],
	["ClutterCutter_EP1",[10,-18]],
	["ClutterCutter_EP1",[10,-24]],
	["ClutterCutter_EP1",[-4,-5]]
],_position,_mission] call WAI_SpawnObjects;

// Troops
[[(_position select 0) + 17, (_position select 1) - 18, 0],5,_difficulty,"Random","AT","Random",_aiType,"Random",_aiType,_mission] call WAI_SpawnGroup;
[[(_position select 0) - 11, (_position select 1) + 9, 0],5,_difficulty,"Random","AA","Random",_aiType,"Random",_aiType,_mission] call WAI_SpawnGroup;
[[(_position select 0) + 15, (_position select 1) - 15, 0],5,_difficulty,"Random","","Random",_aiType,"Random",_aiType,_mission] call WAI_SpawnGroup;
[[(_position select 0) + 2, (_position select 1) + 18, 0],(ceil random 5),_difficulty,"Random","","Random",_aiType,"Random",_aiType,_mission] call WAI_SpawnGroup;
[[(_position select 0) + 2, (_position select 1) + 18, 0],(ceil random 5),_difficulty,"Random","","Random",_aiType,"Random",_aiType,_mission] call WAI_SpawnGroup;

// Vehicle Patrol
[[(_position select 0) + 55, _position select 1, 0],[(_position select 0) + 17, _position select 1, 0],50,2,"LandRover_MG_TK_EP1_DZ",_difficulty,_aiType,_aiType,_mission] call WAI_VehPatrol;

//Static Guns
[[[(_position select 0) - 7, (_position select 1) + 19, 0]],"KORD_high_TK_EP1",_difficulty,_aiType,_aiType,"Random","Random","Random",_mission] call WAI_SpawnStatic;

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
