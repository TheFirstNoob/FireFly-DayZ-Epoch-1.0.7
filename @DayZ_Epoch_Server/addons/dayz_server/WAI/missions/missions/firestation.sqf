local _mission = count WAI_MissionData -1;
local _aiType = _this select 0; // "Bandit" or "Hero"
local _position = [50] call WAI_FindPos;
local _name = "Fire Station";
local _startTime = diag_tickTime;
local _difficulty = "Extreme";
local _localized = ["STR_CL_MISSION_BANDIT", "STR_CL_MISSION_HERO"] select (_aiType == "Hero");
local _localName = "STR_CL_FIRESTATION_TITLE";

diag_log format["[WAI]: %1 %2 started at %3.",_aiType,_name,_position];

local _messages = if (_aiType == "Hero") then {
	["STR_CL_HERO_FIRESTATION_ANNOUNCE","STR_CL_HERO_FIRESTATION_WIN","STR_CL_HERO_FIRESTATION_FAIL"];
} else {
	["STR_CL_BANDIT_FIRESTATION_ANNOUNCE","STR_CL_BANDIT_FIRESTATION_WIN","STR_CL_BANDIT_FIRESTATION_FAIL"];
};

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
local _loot1 = if (_aiType == "Hero") then {Loot_Firestation1 select 0;} else {Loot_Firestation1 select 1;};
local _loot2 = if (_aiType == "Hero") then {Loot_Firestation2 select 0;} else {Loot_Firestation2 select 1;};
[[
	[_loot1,WAI_CrateLg,[-3.6,-4.4],-30],
	[_loot2,WAI_CrateLg,[2,-1.1],-30]
],_position,_mission] call WAI_SpawnCrate;

// Spawn Objects
local _objects = [[
	["MAP_a_stationhouse",[0,0],-210],
	["Land_fort_bagfence_round",[3.5,-20],68],
	["Land_fort_bagfence_round",[-1,-23.3],219]
],_position,_mission] call WAI_SpawnObjects;

// Get the fire station object for spawning static guns on the roof using relative building positions.
local _fireStation = _objects select 0;

//Troops
[_position,5,_difficulty,"Random","AT","Random",WAI_FirefighterSkin,"Random",_aiType,_mission] call WAI_SpawnGroup;
[_position,5,_difficulty,"Random","AA","Random",WAI_FirefighterSkin,"Random",_aiType,_mission] call WAI_SpawnGroup;
[_position,5,_difficulty,"Random","","Random",WAI_FirefighterSkin,"Random",_aiType,_mission] call WAI_SpawnGroup;
[_position,5,_difficulty,"Random","","Random",WAI_FirefighterSkin,"Random",_aiType,_mission] call WAI_SpawnGroup;
[_position,(ceil random 5),_difficulty,"Random","","Random",WAI_FirefighterSkin,"Random",_aiType,_mission] call WAI_SpawnGroup;
[_position,(ceil random 5),_difficulty,"Random","","Random",WAI_FirefighterSkin,"Random",_aiType,_mission] call WAI_SpawnGroup;

// Spawn Vehicle
local _vehicle = [WAI_ArmedVeh ,[(_position select 0) -9.5, (_position select 1) -6.8],_mission,true,-29] call WAI_PublishVeh;
[_vehicle,(typeOf _vehicle),2] call WAI_LoadAmmo;

//Humvee Patrol
[[(_position select 0) + 100, _position select 1, 0],[(_position select 0) + 100, _position select 1, 0],50,2,"ArmoredSUV_PKT_DZ","Random",_aiType,_aiType,_mission] call WAI_VehPatrol;

//Heli Paradrop
[_position,400,"Mi171Sh_CZ_EP1_DZ","East",[3000,4000],150,1.0,200,10,"Random","Random","","Random",_aiType,"Random",_aiType,false,_mission] spawn WAI_HeliPara;

//Static guns
[[
	(_fireStation modelToWorld [-17.8105,9.30957,-0.507904]),
	(_fireStation modelToWorld [18.8481,-7.45313,-4.5079]),
	(_fireStation modelToWorld [-3.56787,-8.27832,8.4921]),
	[(_position select 0) + 0.9, (_position select 1) - 20.9, 0]
],"M2StaticMG",_difficulty,WAI_FirefighterSkin,_aiType,"Random","Random","Random",_mission] call WAI_SpawnStatic;

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