local _mission = count WAI_MissionData -1;
local _aiType = _this select 0; // "Bandit" or "Hero"
local _position = [50] call WAI_FindPos;
local _name = "President's in Town";
local _startTime = diag_tickTime;
local _difficulty = "Extreme";
local _localized = ["STR_CL_MISSION_BANDIT", "STR_CL_MISSION_HERO"] select (_aiType == "Hero");
local _localName = "STR_CL_PRESIDENT_TITLE";

diag_log format["[WAI]: %1 %2 started at %3.",_aiType,_name,_position];

local _messages = ["STR_CL_PRESIDENT_ANNOUNCE","STR_CL_PRESIDENT_WIN","STR_CL_PRESIDENT_FAIL"];

////////////////////// Do not edit this section ///////////////////////////
local _markers = [1,1,1,1];
//[position,createMarker,setMarkerColor,setMarkerType,setMarkerShape,setMarkerBrush,setMarkerSize,setMarkerText,setMarkerAlpha]
_markers set [0, [_position, "WAI" + str(_mission), "ColorBlack", "", "ELLIPSE", "Solid", [300,300], [], 0]];
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
local _loot = if (_aiType == "Hero") then {Loot_Presidents select 0;} else {Loot_Presidents select 1;};
[[
	[_loot,"DZ_AmmoBoxBigUS",[0,0,.25]]
],_position,_mission] call WAI_SpawnCrate;

// Spawn Objects
local _objects = [[
	["Land_A_Office01",[0,0]]
],_position,_mission] call WAI_SpawnObjects;

//Troops
[_position,5,_difficulty,"Random","AT","Random",WAI_StalkerSkin,"Random",_aiType,_mission] call WAI_SpawnGroup;
[_position,5,_difficulty,"Random","AA","Random",WAI_StalkerSkin,"Random",_aiType,_mission] call WAI_SpawnGroup;
[_position,5,_difficulty,"Random","","Random",WAI_StalkerSkin,"Random",_aiType,_mission] call WAI_SpawnGroup;
[_position,5,_difficulty,"Random","","Random",WAI_StalkerSkin,"Random",_aiType,_mission] call WAI_SpawnGroup;
[_position,(ceil random 5),_difficulty,"Random","","Random",WAI_StalkerSkin,"Random",_aiType,_mission] call WAI_SpawnGroup;
[_position,(ceil random 5),_difficulty,"Random","","Random",WAI_StalkerSkin,"Random",_aiType,_mission] call WAI_SpawnGroup;

//The President and First Lady
local _office = _objects select 0;
local _presGroup = [(_office modelToWorld [4.34668,1.2998,-2.028]),1,_difficulty,"Random","","none","Functionary2_EP1","Random",[_aiType,500],_mission] call WAI_SpawnGroup;
local _firstladyGroup = [(_office modelToWorld [6.52441,1.25781,-2.028]),1,_difficulty,"unarmed","","none","Secretary1","none",[_aiType,0],_mission] call WAI_SpawnGroup;	
_presGroup setVariable ["DoNotFreeze", true];
_firstladyGroup setVariable ["DoNotFreeze", true];
local _president = leader _presGroup;
local _firstlady = leader _firstladyGroup;
_president disableAI "MOVE";
_firstlady disableAI "MOVE";

//Let him move once player is near
_president spawn {
	local _president = _this;
	local _playerNear = false;
	while {!_playerNear} do {
		_playerNear = [(position _president),50] call isNearPlayer;
		uiSleep 1;
	};
	_president enableAI "MOVE";
};

// Vehicle Patrol
[[(_position select 0) + 100, _position select 1, 0],[(_position select 0) + 100, _position select 1, 0],50,2,"BAF_Jackal2_L2A1_D_DZ","Random",_aiType,_aiType,_mission] call WAI_VehPatrol;

//Heli Paradrop
[_position,400,"MH60S_DZ","East",[3000,4000],150,1.0,200,10,"Random","Random","AT","Random",WAI_StalkerSkin,"Random",_aiType,true,_mission] spawn WAI_HeliPara;

//Static guns
[[
	(_office modelToWorld [15.1953,6.62402,0.471999]),
	(_office modelToWorld [-13.249,6.74121,0.472008]),
	(_office modelToWorld [2.39844,-1.79785,6.71491])
],"M2StaticMG",_difficulty,WAI_StalkerSkin,_aiType,"Random","Random","Random",_mission] call WAI_SpawnStatic;

[
	_mission, // Mission number
	_position, // Position of mission
	_difficulty, // Difficulty
	_name, // Name of Mission
	_localName,
	_aiType, // "Bandit" or "Hero"
	_markerIndex,
	_posIndex,
	_claimPlayer,
	true, // show mission marker?
	true, // make minefields available for this mission
	["assassinate",_president], // Completion type: ["crate"], ["kill"], or ["assassinate", _unitGroup],
	_messages
] spawn WAI_MissionMonitor;