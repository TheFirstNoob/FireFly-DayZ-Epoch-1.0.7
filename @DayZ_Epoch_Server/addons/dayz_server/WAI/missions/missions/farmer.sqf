local _mission = count WAI_MissionData -1;
local _aiType = _this select 0; // Type of AI - opposite of mission type
local _position = [30] call WAI_FindPos;
local _name = "Farmer";
local _startTime = diag_tickTime;
local _difficulty = "Easy";
local _localized = ["STR_CL_MISSION_BANDIT", "STR_CL_MISSION_HERO"] select (_aiType == "Hero");
local _localName = "STR_CL_FARMER_TITLE";

diag_log format["[WAI]: %1 %2 started at %3.",_aiType,_name,_position];

local _messages = if (_aiType == "Hero") then {
	["STR_CL_HERO_FARMER_ANNOUNCE","STR_CL_HERO_FARMER_WIN","STR_CL_HERO_FARMER_FAIL"];
} else {
	["STR_CL_BANDIT_FARMER_ANNOUNCE","STR_CL_BANDIT_FARMER_WIN","STR_CL_BANDIT_FARMER_FAIL"];
};

////////////////////// Do not edit this section ///////////////////////////
local _markers = [1,1,1,1];
//[position,createMarker,setMarkerColor,setMarkerType,setMarkerShape,setMarkerBrush,setMarkerSize,setMarkerText,setMarkerAlpha]
_markers set [0, [_position, "WAI" + str(_mission), "ColorGreen", "", "ELLIPSE", "Solid", [300,300], [], 0]];
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
local _loot = if (_aiType == "Hero") then {Loot_Farmer select 0;} else {Loot_Farmer select 1;};
[[
	[_loot,WAI_CrateMd,[.3,0,.4]]
],_position,_mission] call WAI_SpawnCrate;

// Spawn Objects
[[
	["MAP_HouseV2_01A",[-37,15],-107],
	["MAP_Farm_WTower",[-17,32]],
	["MAP_sara_stodola3",[12,36.5],20.6],
	["MAP_Misc_Cargo1C",[17,4],5.9],
	["MAP_Misc_Cargo1C",[15,12],-41.2],
	["MAP_t_picea2s",[-17.5,9]],
	["MAP_t_picea2s",[-1,-13]],
	["MAP_t_picea2s",[-8.5,51.5]],
	["MAP_t_picea2s",[18.5,-9.4]],
	["Haystack",[7,24.5],15.3],
	["MAP_stodola_old_open",[0,-2,0.4],-80.8]
],_position,_mission] call WAI_SpawnObjects;

//Troops
[[(_position select 0) -17,(_position select 1) +29,0],5,_difficulty,"Random","AT","Random","RU_Villager2","Random",_aiType,_mission] call WAI_SpawnGroup;
[[(_position select 0) -12,(_position select 1) +20,0],(ceil random 3),_difficulty,"Random","AA","Random","Citizen2_EP1","Random",_aiType,_mission] call WAI_SpawnGroup;
[[(_position select 0) -17,(_position select 1) +29,0],(ceil random 3),_difficulty,"Random","","Random","RU_Villager2","Random",_aiType,_mission] call WAI_SpawnGroup;

//Spawn vehicles
["Tractor_DZE",[(_position select 0) -6.5, (_position select 1) +12.7],_mission,true,46.7] call WAI_PublishVeh;

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
	["kill"], // Completion type: ["crate"], ["kill"], or ["assassinate", _unitGroup],
	_messages
] spawn WAI_MissionMonitor;
