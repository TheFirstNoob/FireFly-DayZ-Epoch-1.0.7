local _mission = count WAI_MissionData -1;
local _aiType = _this select 0; // "Bandit" or "Hero"
local _position = [30] call WAI_FindPos;
local _vehclass = WAI_ArmedHeli call BIS_fnc_selectRandom; // Military Chopper
local _vehname = getText (configFile >> "CfgVehicles" >> _vehclass >> "displayName");
local _name = format["Sniper Extraction %1",_vehname];
local _startTime = diag_tickTime;
local _difficulty = "Hard";
local _localized = ["STR_CL_MISSION_BANDIT", "STR_CL_MISSION_HERO"] select (_aiType == "Hero");
local _localName = ["STR_CL_EXTRACTION_TITLE",_vehname];

diag_log format["[WAI]: %1 %2 started at %3.",_aiType,_name,_position];

local _messages = if (_aiType == "Hero") then {
	["STR_CL_HERO_MILCHOPPER_ANNOUNCE","STR_CL_HERO_MILCHOPPER_WIN","STR_CL_HERO_MILCHOPPER_FAIL"];
} else {
	["STR_CL_BANDIT_EXTRACTION_ANNOUNCE","STR_CL_BANDIT_EXTRACTION_WIN","STR_CL_BANDIT_EXTRACTION_FAIL"];
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
local _loot = if (_aiType == "Hero") then {Loot_Extraction select 0;} else {Loot_Extraction select 1;};
[[
	[_loot,WAI_CrateMd,[0,10]]
],_position,_mission] call WAI_SpawnCrate;

//Troops
[_position,5,_difficulty,"Random","AT","Random",WAI_AcrSkin,"Random",_aiType,_mission] call WAI_SpawnGroup;
[_position,5,_difficulty,"Random","AA","Random",WAI_AcrSkin,"Random",_aiType,_mission] call WAI_SpawnGroup;
[_position,5,_difficulty,"Random","","Random",WAI_AcrSkin,"Random",_aiType,_mission] call WAI_SpawnGroup;
[_position,(ceil random 5),_difficulty,WAI_Sniper,"","Random",WAI_AcrSkin,"Random",_aiType,_mission] call WAI_SpawnGroup;
[_position,(ceil random 5),_difficulty,WAI_Sniper,"","Random",WAI_AcrSkin,"Random",_aiType,_mission] call WAI_SpawnGroup;

//Static Guns
[[
	[(_position select 0) + 30, (_position select 1) - 30, 0],
	[(_position select 0) + 30, (_position select 1) + 30, 0],
	[(_position select 0) - 30, (_position select 1) - 30, 0],
	[(_position select 0) - 30, (_position select 1) + 30, 0]
],"M2StaticMG",_difficulty,_aiType,_aiType,"Random","Random","Random",_mission] call WAI_SpawnStatic;

//Spawn vehicle
local _vehicle = [_vehclass,_position,_mission] call WAI_PublishVeh;
[_vehicle,_vehclass,2] call WAI_LoadAmmo;

if(WAI_DebugMode) then {
	diag_log format["WAI: [%2] sniper_extraction spawned a %1",_vehname,_aiType];
};

// Array of mission variables to send
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
