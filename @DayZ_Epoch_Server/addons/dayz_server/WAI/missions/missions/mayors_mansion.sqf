local _mission = count WAI_MissionData -1;
local _aiType = _this select 0; // "Bandit" or "Hero"
local _position = [40] call WAI_FindPos;
local _name = "Mayors Mansion";
local _startTime = diag_tickTime;
local _difficulty = "Extreme";
local _localized = ["STR_CL_MISSION_BANDIT", "STR_CL_MISSION_HERO"] select (_aiType == "Hero");
local _localName = "STR_CL_MAYOR_TITLE";


diag_log format["[WAI]: %1 %2 started at %3.",_aiType,_name,_position];

local _messages = ["STR_CL_MAYOR_ANNOUNCE","STR_CL_MAYOR_WIN","STR_CL_MAYOR_FAIL"];

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
local _loot = if (_aiType == "Hero") then {Loot_Mayors select 0;} else {Loot_Mayors select 1;};
[[
	[_loot,WAI_CrateLg,[0,0,.25]]
],_position,_mission] call WAI_SpawnCrate;
 
// Spawn Objects
local _objects = [[
	["Land_A_Villa_EP1",[0,0]]
],_position,_mission] call WAI_SpawnObjects;

//Troops
[_position,5,_difficulty,"Random","AT","Random",WAI_GhillieSkin,"Random",_aiType,_mission] call WAI_SpawnGroup;
[_position,5,_difficulty,"Random","AA","Random",WAI_GhillieSkin,"Random",_aiType,_mission] call WAI_SpawnGroup;
[_position,5,_difficulty,"Random","","Random",WAI_GhillieSkin,"Random",_aiType,_mission] call WAI_SpawnGroup;
[_position,5,_difficulty,"Random","","Random",_aiType,"Random",_aiType,_mission] call WAI_SpawnGroup;
[_position,(ceil random 5),_difficulty,"Random","","Random",_aiType,"Random",_aiType,_mission] call WAI_SpawnGroup;
[_position,(ceil random 5),_difficulty,"Random","","Random",_aiType,"Random",_aiType,_mission] call WAI_SpawnGroup;

//The Mayor Himself
local _mayorGroup = [_position,1,_difficulty,"Random","","Random","Functionary2_EP1","Random",[_aiType,300],_mission] call WAI_SpawnGroup;
_mayorGroup setVariable ["DoNotFreeze", true];
local _mayor = leader _mayorGroup;

//Put the Mayor in his room
local _mansion = _objects select 0;
local _room = (6 + ceil(random(3)));
_mayor disableAI "MOVE";
_mayor setPos (_mansion buildingPos _room);

//Let him move once player is near
_mayor spawn {
	local _mayor = _this;
	local _playerNear = false;
	while {!_playerNear} do {
		_playerNear = [(position _mayor),30] call isNearPlayer;
		uiSleep 1;
	};
	_mayor enableAI "MOVE";
};

// Vehicle Patrol
[[(_position select 0) + 100, _position select 1, 0],[(_position select 0) + 100, _position select 1, 0],100,10,"UAZ_MG_TK_EP1_DZ","Random",_aiType,_aiType,_mission] call WAI_VehPatrol;

//Heli Paradrop
[_position,400,"UH1Y_M240_DZ","North",[3000,4000],150,1.0,100,10,"Random","Random","","Random",_aiType,"Random",_aiType,true,_mission] spawn WAI_HeliPara;

//Static guns
[[
	(_mansion modelToWorld [18.0557,-18.0991,1.9926]),
	(_mansion modelToWorld [-4.51855,-4.25928,1.98619]),
	(_mansion modelToWorld [-17.8154,18.0659,1.97169])
],"M2StaticMG",_difficulty,_aiType,_aiType,"Random","Random","Random",_mission] call WAI_SpawnStatic;

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
	["assassinate",_mayor], // Completion type: ["crate"], ["kill"], or ["assassinate", _unitGroup],
	_messages
] spawn WAI_MissionMonitor;
