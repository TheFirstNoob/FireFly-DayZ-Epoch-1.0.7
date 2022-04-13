/*
	Weapon Truck Crash by lazyink (Full credit for code to TheSzerdi & TAW_Tonic)
	Updated to new format by Vampire
	Updated for DZMS 2.0 by JasonTM
*/

local _mission = count DZMSMissionData -1;
local _aiType = _this select 0;
local _coords = call DZMSFindPos;
local _name = "Weapons Truck";
local _localName = "STR_CL_DZMS_WT_TITLE";
local _hero = _aiType == "Hero";
local _markerColor = ["ColorRed","ColorBlue"] select _hero;
local _localized = ["STR_CL_MISSION_BANDIT","STR_CL_MISSION_HERO"] select _hero;
local _startTime = diag_tickTime;

diag_log format["[DZMS]: %1 %2 starting at %3.",_aiType,_name,_coords];

////////////////////// Do not edit this section ///////////////////////////
//[position,createMarker,setMarkerColor,setMarkerType,setMarkerShape,setMarkerBrush,setMarkerSize,setMarkerText,setMarkerAlpha]
local _markers = [1,1,1,1];
_markers set [0, [_coords,"DZMS" + str _mission,_markerColor,"","ELLIPSE","Grid",[200,200],[],0]];
_markers set [1, [_coords,"DZMSDot" + str _mission,"ColorBlack","Vehicle","","",[],[_localized,_localName],0]];
if (DZMSAutoClaim) then {_markers set [2, [_coords,"DZMSAuto" + str _mission,"ColorRed","","ELLIPSE","Border",[DZMSAutoClaimAlertDistance,DZMSAutoClaimAlertDistance],[],0]];};
DZE_ServerMarkerArray set [count DZE_ServerMarkerArray, _markers]; // Markers added to global array for JIP player requests.
local _markerIndex = count DZE_ServerMarkerArray - 1;
PVDZ_ServerMarkerSend = ["start",_markers];
publicVariable "PVDZ_ServerMarkerSend";
[_aiType,_localName,"STR_CL_DZMS_WT_START"] call DZMSMessage;
DZMSMarkerReady = true;

// Add the mission's position to the global array so that other missions do not spawn near it.
DZE_MissionPositions set [count DZE_MissionPositions, _coords];
local _posIndex = count DZE_MissionPositions - 1;

// Wait until a player is within range or timeout is reached.
local _playerNear = false;
local _timeout = false;
while {!_playerNear && !_timeout} do {
	_playerNear = [_coords,DZMSTimeoutDistance] call DZMSNearPlayer;
	
	if (diag_tickTime - _startTime >= (DZMSMissionTimeOut * 60)) then {
		_timeout = true;
	};
	uiSleep 1;
};

if (_timeout) exitWith {
	[_mission, _aiType, _markerIndex, _posIndex] call DZMSAbortMission;
	[_aiType,_localName,"STR_CL_DZMS_WT_FAIL"] call DZMSMessage;
	diag_log format["DZMS: %1 %2 aborted.",_aiType,_name];
};
//////////////////////////////// End //////////////////////////////////////

//Add scenery
[[
	["UralWreck",[0,0]]
],_coords,_mission] call DZMSSpawnObjects;

// Spawn crates
[_mission,_coords,"DZ_AmmoBoxLong2RU","weapons",[3,0]] call DZMSSpawnCrate;
[_mission,_coords,"DZ_AmmoBoxLongGUE","weapons",[-3,0]] call DZMSSpawnCrate;
[_mission,_coords,"DZ_AmmoBoxMedium2US","weapons",[-6,0]] call DZMSSpawnCrate;


//DZMSAISpawn spawns AI to the mission.
//Usage: [_coords, count, skillLevel, Hero or Bandit, Mission Number]
[_coords,3,0,_aiType,_mission] call DZMSAISpawn;
[_coords,3,1,_aiType,_mission] call DZMSAISpawn;
[_coords,3,2,_aiType,_mission] call DZMSAISpawn;
[_coords,3,3,_aiType,_mission] call DZMSAISpawn;

// Spawn Static M2 Gunner positions if enabled.
if (DZMSM2Static) then {
	[[
		[(_coords select 0) + 3.1,(_coords select 1) - 21.9, 0],
		[(_coords select 0) - 0.27,(_coords select 1) + 17.7, 0]
	],0,_aiType,_mission] call DZMSM2Spawn;
};

// Start the mission loop.
[
	_mission,
	_coords,
	_aiType,
	_name,
	_localName,
	_markerIndex,
	_posIndex,
	"STR_CL_DZMS_WT_WIN",
	"STR_CL_DZMS_WT_FAIL"
] spawn DZMSWaitMissionComp;
