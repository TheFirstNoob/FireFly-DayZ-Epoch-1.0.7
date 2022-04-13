local _mission = count WAI_MissionData -1;
local _aiType = _this select 0; // "Bandit" or "Hero"
local _position = [30] call WAI_FindPos;
local _name = "Drug Bust";
local _startTime = diag_tickTime;
local _difficulty = "Medium";
local _localized = ["STR_CL_MISSION_BANDIT", "STR_CL_MISSION_HERO"] select (_aiType == "Hero");
local _localName = "STR_CL_DRUGBUST_TITLE";

diag_log format["[WAI]: %1 %2 started at %3.",_aiType,_name,_position];

local _messages = if (_aiType == "Hero") then {
	["STR_CL_HERO_DRUGBUST_ANNOUNCE","STR_CL_HERO_DRUGBUST_WIN","STR_CL_HERO_DRUGBUST_FAIL"];
} else {
	["STR_CL_BANDIT_DRUGBUST_ANNOUNCE","STR_CL_BANDIT_DRUGBUST_WIN","STR_CL_BANDIT_DRUGBUST_FAIL"];
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
local _loot = if (_aiType == "Hero") then {Loot_DrugBust select 0;} else {Loot_DrugBust select 1;};
[[
	[_loot,WAI_CrateMd,[2.3,-3,.1]]
],_position,_mission] call WAI_SpawnCrate;

// Spawn Objects
[[
	["Land_dum_zboreny",[-0.01,0.02,-0.1]],
	["Land_Misc_Garb_Heap_EP1",[5.6,3.4,-0.01]],
	["MAP_Kitchenstove_Elec",[2,5,-0.1]],
	["MAP_P_toilet_b_02",[-4.4,-3.3,-0.01],-90.84],
	["MAP_P_bath",[-4.9,-5,-0.01]],
	["MAP_armchair",[-1.7,-4.6,-0.01],179.92],
	["MAP_SmallTable",[2.6,1.4,-0.15]],
	["MAP_kitchen_chair_a",[2.5,2.2,-0.01]],
	["Land_Boots_EP1",[8.4,-1.5,-0.01],-170.27],
	["Land_Blankets_EP1",[-6.3,4.8,0.01],-170.27],
	["Land_Bench_EP1",[-3.2,-2.2,0.015]],
	["Land_Water_pipe_EP1",[-1.4,-3,0.01],105.15],
	["Land_Bag_EP1",[-5.9,1.9,0.01]],
	["LADAWreck",[-8,-4,-0.01],-119.578],
	["SKODAWreck",[11,-3,-0.01]],
	["MAP_tv_a",[-2.7,-0.1,0.01]],
	["MAP_Dkamna_uhli",[-0.01,5,-0.1]],
	["MAP_Skrin_opalena",[1.2,0.1,0.05]],
	["MAP_Dhangar_whiteskrin",[0.9,1.6,0.05],91.19],
	["MAP_garbage_paleta",[5.3,-2,-0.01]],
	["MAP_t_salix2s",[-0.01,15,-0.01],47.639],
	["MAP_t_salix2s",[-0.01,-17,-0.01]],
	["MAP_t_salix2s",[25,-0.01,-0.01]],
	["MAP_t_salix2s",[-24,-0.01,-0.01]]
],_position,_mission] call WAI_SpawnObjects;

//Troops
[[(_position select 0) - 12, (_position select 1) - 15,0],5,_difficulty,"Random","AT","Random",_aiType,"Random",_aiType,_mission] call WAI_SpawnGroup;
[[(_position select 0) + 12, (_position select 1) + 15,0],5,_difficulty,"Random","AA","Random",_aiType,"Random",_aiType,_mission] call WAI_SpawnGroup;
[[(_position select 0), (_position select 1), 0],(ceil random 4),_difficulty,"Random","","Random",_aiType,"Random",_aiType,_mission] call WAI_SpawnGroup;
[[(_position select 0), (_position select 1), 0],(ceil random 4),_difficulty,"Random","","Random",_aiType,"Random",_aiType,_mission] call WAI_SpawnGroup;

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