local _mission = count WAI_MissionData -1;
local _aiType = _this select 0; // "Bandit" or "Hero"
local _position = [80] call WAI_FindPos;
local _name = "Crop Raider";
local _startTime = diag_tickTime;
local _difficulty = "Hard";
local _localized = ["STR_CL_MISSION_BANDIT", "STR_CL_MISSION_HERO"] select (_aiType == "Hero");
local _localName = "STR_CL_CROPRADIER_TITLE";

diag_log format["[WAI]: %1 %2 started at %3.",_aiType,_name,_position];

local _messages = ["STR_CL_CROPRAIDER_ANNOUNCE","STR_CL_CROPRAIDER_WIN","STR_CL_CROPRAIDER_FAIL"];

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
local _loot = if (_aiType == "Hero") then {Loot_CropRaider select 0;} else {Loot_CropRaider select 1;};
[[
	[_loot,WAI_CrateSm,[2,0,.1]]
],_position,_mission] call WAI_SpawnCrate;

// Spawn Objects
[[
	["fiberplant",[-10.8,-16.3]],
	["fiberplant",[16.2,-17.6]],
	["fiberplant",[-17.3,21]],
	["fiberplant",[28.6,29]],
	["fiberplant",[-29.8,-31.1]],
	["fiberplant",[30.2,-33]],
	["fiberplant",[-32,28.7]],
	["fiberplant",[-32,-1.1]],
	["fiberplant",[1.3,-28]],
	["fiberplant",[27,2]],
	["fiberplant",[-0.3,26]],
	["fiberplant",[35.9,39]],
	["fiberplant",[-39,-40.3]],
	["fiberplant",[-36.9,-38.6]],
	["fiberplant",[38,-38.9]],
	["fiberplant",[-37,39.7]],
	["fiberplant",[-0.1,42.3]],
	["fiberplant",[42.1,-0.1]],
	["fiberplant",[0.1,-40.2]],
	["hruzdum",[-0.01,-0.01]],
	["fiberplant",[-10,-11]],
	["fiberplant",[13,12.2]],
	["fiberplant",[12.3,-10.6]],
	["fiberplant",[-11.3,12.7]],
	["fiberplant",[15,10]]
],_position,_mission] call WAI_SpawnObjects;

//Group Spawning
[[(_position select 0) + 9, (_position select 1) - 13, 0],5,_difficulty,"Random","AT","Random",WAI_RockerSkin,"Random",_aiType,_mission] call WAI_SpawnGroup;
[[(_position select 0) + 13, (_position select 1) + 15, 0],5,_difficulty,"Random","AA","Random",WAI_RockerSkin,"Random",_aiType,_mission] call WAI_SpawnGroup;
[[(_position select 0) + 13, (_position select 1) + 15, 0],5,_difficulty,"Random","","Random",WAI_RockerSkin,"Random",_aiType,_mission] call WAI_SpawnGroup;
[[(_position select 0) - 13, (_position select 1) + 15, 0],(ceil random 5),_difficulty,"Random","","Random","RU_Policeman_DZ","Random",_aiType,_mission] call WAI_SpawnGroup;
[[_position select 0, _position select 1, 0],(ceil random 5),_difficulty,"Random","","Random","RU_Policeman_DZ","Random",_aiType,_mission] call WAI_SpawnGroup;

// Vehicle Patrol
[[(_position select 0) + 55, _position select 1, 0],[(_position select 0) + 50, _position select 1, 0],50,2,"HMMWV_Armored",_difficulty,_aiType,_aiType,_mission] call WAI_VehPatrol;

//Static Guns
[[
	[(_position select 0) - 48, (_position select 1) + 0.1, 0],
	[(_position select 0) + 2, (_position select 1) + 48, 0]
],"M2StaticMG",_difficulty,"RU_Policeman_DZ",_aiType,"Random","Random","Random",_mission] call WAI_SpawnStatic;

//Heli Paradrop
[_position,200,"UH1H_DZ","East",[3000,4000],150,1.0,200,10,_difficulty,"Random","","Random",_aiType,"Random",_aiType,true,_mission] spawn WAI_HeliPara;

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
