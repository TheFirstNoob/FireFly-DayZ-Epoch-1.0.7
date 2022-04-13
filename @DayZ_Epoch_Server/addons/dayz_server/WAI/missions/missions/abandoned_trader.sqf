local _mission = count WAI_MissionData -1;
local _aiType = _this select 0; // "Bandit" or "Hero"
local _position = [30] call WAI_FindPos;
local _name = "Abandoned Trader";
local _startTime = diag_tickTime;
local _difficulty = "Medium";
local _localized = ["STR_CL_MISSION_BANDIT", "STR_CL_MISSION_HERO"] select (_aiType == "Hero");
local _localName = "STR_CL_ABANDONEDTRADER_TITLE";

diag_log format["[WAI]: %1 %2 started at %3.",_aiType,_name,_position];

local _messages = if (_aiType == "Hero") then {
	["STR_CL_HERO_ABANDONEDTRADER_ANNOUNCE","STR_CL_HERO_ABANDONEDTRADER_WIN","STR_CL_HERO_ABANDONEDTRADER_FAIL"];
} else {
	["STR_CL_BANDIT_ABANDONEDTRADER_ANNOUNCE","STR_CL_BANDIT_ABANDONEDTRADER_WIN","STR_CL_BANDIT_ABANDONEDTRADER_FAIL"];
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
local _loot = if (_aiType == "Hero") then {Loot_AbandonedTrader select 0;} else {Loot_AbandonedTrader select 1;};
[[
	[_loot,WAI_CrateMd,[.3,0]]
],_position,_mission] call WAI_SpawnCrate;

// Spawn Objects
[[
	["Land_Misc_Garb_Heap_EP1",[-0.9,4.2,-0.01]],
	["Land_Misc_Garb_Heap_EP1",[-18,1.5,-0.01]],
	["Land_Shed_W03_EP1",[-4,4.7,-0.01]],
	["Land_Shed_M01_EP1",[-10,5,-0.01]],
	["Land_Market_shelter_EP1",[-10,-0.4,-0.01]],
	["Land_Market_stalls_02_EP1",[-10,-5.8,-0.01],-2.5],
	["Land_Market_stalls_01_EP1",[11,5,-0.01],-0.34],
	["Land_Market_stalls_02_EP1",[10,-5.8,-0.01]],
	["Land_Market_shelter_EP1",[10,-0.4,-0.01],2.32],
	["Land_transport_crates_EP1",[22,2,-0.01],-43.88],
	["Fort_Crate_wood",[18,-1,-0.01]],
	["UralWreck",[27,-3,-0.01],-67.9033],
	["Land_Canister_EP1",[18,1.4,-0.01],28.73],
	["MAP_ground_garbage_square5",[13.6,-2,-0.01]],
	["MAP_ground_garbage_square5",[-16,-2,-0.01]],
	["MAP_ground_garbage_long",[-0.4,-2,-0.01]],
	["MAP_garbage_misc",[-8,-2,-0.01]]
],_position,_mission] call WAI_SpawnObjects;

//Troops
[_position,5,_difficulty,"random","AT","random",_aiType,"random",_aiType,_mission] call WAI_SpawnGroup;
[_position,5,_difficulty,"random","AA","random","Hero","random",_aiType,_mission] call WAI_SpawnGroup;
[_position,(ceil random 4),_difficulty,"random","","random",_aiType,"random",_aiType,_mission] call WAI_SpawnGroup;
[_position,(ceil random 4),_difficulty,"random","","random",_aiType,"random",_aiType,_mission] call WAI_SpawnGroup;

//Static Guns
[[
	[(_position select 0) + 0.1, (_position select 1) + 20, 0],
	[(_position select 0) + 0.1, (_position select 1) - 20, 0]
],"M2StaticMG","Easy",_aiType,_aiType,"random","random","random",_mission] call WAI_SpawnStatic;
uiSleep 30; // simulate shitty server hardware.
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