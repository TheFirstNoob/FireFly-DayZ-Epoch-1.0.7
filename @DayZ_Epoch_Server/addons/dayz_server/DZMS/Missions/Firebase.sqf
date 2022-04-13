/*
	Fire Base Camp by lazyink (Full credit for original code to TheSzerdi & TAW_Tonic)
	Updated to New Mission Format by Vampire
	Updated for DZMS 2.0 by JasonTM
*/

local _mission = count DZMSMissionData -1;
local _aiType = _this select 0;
local _coords = call DZMSFindPos;
local _name = "Firebase";
local _localName = "STR_CL_DZMS_FB_TITLE";
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
[_aiType,_localName,"STR_CL_DZMS_FB_START"] call DZMSMessage;
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
	[_aiType,_localName,"STR_CL_DZMS_FB_FAIL"] call DZMSMessage;
	diag_log format["DZMS: %1 %2 aborted.",_aiType,_name];
};
//////////////////////////////// End //////////////////////////////////////

// Spawn Mission Objects
[[
	["MAP_fort_rampart",[8,-14],-30],
	["MAP_fort_rampart",[-9,15],-210],
	["MAP_fort_rampart",[-16.6,-8.9],60],
	["MAP_fort_rampart",[16,10],-120],
	["MAP_HBarrier5",[2.3,-8.5],-30],
	["MAP_HBarrier5",[-8.9,-2.3],60],
	["MAP_HBarrier5",[6.9,7.2],60],
	["MAP_HBarrier5",[-6.1,6.8],-30],
	["MAP_fort_watchtower",[4.4,14.3],60],
	["MAP_fort_watchtower",[-15.3,2.3],60],
	["MAP_fort_watchtower",[15.7,-2.5],-120],
	["MAP_fort_watchtower",[-4.6,-14.1],-120]
],_coords,_mission] call DZMSSpawnObjects;

[_mission,_coords,"DZ_AmmoBoxMedium1US","supply",[2,-4],-30] call DZMSSpawnCrate;
[_mission,_coords,"DZ_AmmoBoxMedium1US","supply2",[-2,4],-30] call DZMSSpawnCrate;
[_mission,_coords,"DZ_AmmoBoxMedium1US","weapons",[-5,-2.5],60] call DZMSSpawnCrate;
[_mission,_coords,"DZ_AmmoBoxMedium1US","weapons",[5,3.3],60] call DZMSSpawnCrate;

//DZMSAISpawn spawns AI to the mission.
//Usage: [_coords, count, skillLevel, Hero or Bandit, Mission Number]
[[(_coords select 0) + 12,(_coords select 1) - 23,0],6,0,_aiType,_mission] call DZMSAISpawn;
[[(_coords select 0) - 24,(_coords select 1) - 13,0],4,1,_aiType,_mission] call DZMSAISpawn;
[[(_coords select 0) - 13,(_coords select 1) + 25,0],4,2,_aiType,_mission] call DZMSAISpawn;
[[(_coords select 0) + 26,(_coords select 1) + 14,0],4,3,_aiType,_mission] call DZMSAISpawn;

// Spawn Static M2 Gunner positions if enabled.
if (DZMSM2Static) then {
	[[
		[(_coords select 0) + 18.45,(_coords select 1) - 8.41, 0],
		[(_coords select 0) + 12.85,(_coords select 1) + 18.51, 0],
		[(_coords select 0) - 18.09,(_coords select 1) + 9, 0],
		[(_coords select 0) - 13.46,(_coords select 1) - 17.78, 0]
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
	"STR_CL_DZMS_FB_WIN",
	"STR_CL_DZMS_FB_FAIL"
] spawn DZMSWaitMissionComp;
