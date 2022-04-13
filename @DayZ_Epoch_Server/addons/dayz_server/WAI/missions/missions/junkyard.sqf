local _mission = count WAI_MissionData -1;
local _aiType = _this select 0; // "Bandit" or "Hero"
local _position = [30] call WAI_FindPos;
local _name = "Junk Yard";
local _startTime = diag_tickTime;
local _difficulty = "Medium";
local _localized = ["STR_CL_MISSION_BANDIT", "STR_CL_MISSION_HERO"] select (_aiType == "Hero");
local _localName = "STR_CL_JUNKYARD_TITLE";

diag_log format["[WAI]: %1 %2 started at %3.",_aiType,_name,_position];

local _messages = if (_aiType == "Hero") then {
	["STR_CL_HERO_JUNKYARD_ANNOUNCE","STR_CL_HERO_JUNKYARD_WIN","STR_CL_HERO_JUNKYARD_FAIL"];
} else {
	["STR_CL_BANDIT_JUNKYARD_ANNOUNCE","STR_CL_BANDIT_JUNKYARD_WIN","STR_CL_BANDIT_JUNKYARD_FAIL"];
};

////////////////////// Do not edit this section ///////////////////////////
local _markers = [1,1,1,1];
//[position,createMarker,setMarkerColor,setMarkerType,setMarkerShape,setMarkerBrush,setMarkerSize,setMarkerText,setMarkerAlpha]
_markers set [0, [_position, "WAI" + str(_mission), "ColorYellow", "", "ELLIPSE", "Solid", [300,300], [], 0]];
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
local _loot = if (_aiType == "Hero") then {Loot_Junkyard select 0;} else {Loot_Junkyard select 1;};
[[
	[_loot,WAI_CrateSm,[.2,0]]
],_position,_mission] call WAI_SpawnCrate;

// Spawn Objects
[[
	["Mi8Wreck",[31,-12.4,-0.12]],
	["UralWreck",[-7,-9,-0.04],-49.99],
	["UralWreck",[23,4,-0.04],201.46],
	["UralWreck",[-7,23,-0.04],80.879],
	["HMMWVWreck",[-8,7,-0.04],44.77],
	["BMP2Wreck",[-4,24,-0.02],-89],
	["T72Wreck",[11,-13,-0.02],27],
	["UralWreck",[14,10,-0.02],162],
	["T72Wreck",[4,16,-0.02]],
	["UH60_ARMY_Wreck_DZ",[7,1.3,-0.02],-41],
	["Land_Dirthump01",[9,1,-1.59],25],
	["Land_Dirthump01",[8,0.2,-1.59],53],
	["Mi8Wreck",[5,-34,-0.02],94],
	["BRDMWreck",[-1,-20,-0.12],-1.7],
	["T72Wreck",[-9,-21,-0.02],-75],
	["Mi8Wreck",[-21,-5,-0.02],-24],
	["Land_Misc_Rubble_EP1",[-10.02,7,-0.1]],
	["Land_Shed_W03_EP1",[-7,-1.4,-0.02],-99],
	["Land_Misc_Garb_Heap_EP1",[-6,1,-0.02]],
	["Land_Misc_Garb_Heap_EP1",[18,10,-0.02]],
	["Land_Misc_Garb_Heap_EP1",[-10,-12,-0.02]],
	["MAP_garbage_misc",[5,-21,-0.02]],
	["MAP_garbage_misc",[7,18,-0.02],-178],
	["MAP_garbage_paleta",[-12,14,-0.02],-91],
	["MAP_Kitchenstove_Elec",[-11,1.5,-0.02],146],
	["MAP_tv_a",[-12,-0.01,-0.02],108],
	["MAP_washing_machine",[-11,-1,-0.02],100],
	["MAP_P_toilet_b_02",[-16,0.01,-0.02],36],
	["Land_Misc_Garb_Heap_EP1",[-17,-3,-0.02],93],
	["MAP_garbage_paleta",[-11,-0.01,-0.02],21],
	["Land_Fire_barrel_burning",[-13,-3,-0.02]],
	["Land_Fire_barrel_burning",[2,-9,-0.02]]
],_position,_mission] call WAI_SpawnObjects;

//Troops
[[(_position select 0) - 2, (_position select 1) - 5, 0],5,_difficulty,"Random","AT","Random",_aiType,"Random",_aiType,_mission] call WAI_SpawnGroup;
[[(_position select 0) - 19, (_position select 1) + 19, 0],5,_difficulty,"Random","AA","Random",_aiType,"Random",_aiType,_mission] call WAI_SpawnGroup;
[[(_position select 0) + 17, (_position select 1) + 21, 0],(ceil random 4),_difficulty,"Random","","Random",_aiType,"Random",_aiType,_mission] call WAI_SpawnGroup;
[[(_position select 0) + 17, (_position select 1) + 21, 0],(ceil random 4),_difficulty,"Random","","Random",_aiType,"Random",_aiType,_mission] call WAI_SpawnGroup;

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