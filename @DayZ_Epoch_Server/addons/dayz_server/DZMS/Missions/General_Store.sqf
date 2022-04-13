/*
	General Store Mission by JasonTM
*/

local _mission = count DZMSMissionData -1;
local _aiType = _this select 0;
local _coords = call DZMSFindPos;
local _name = "General Store";
local _localName = "STR_CL_DZMS_GS_TITLE";
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
[_aiType,_localName,"STR_CL_DZMS_GS_START"] call DZMSMessage;
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
	[_aiType,_localName,"STR_CL_DZMS_GS_FAIL"] call DZMSMessage;
	diag_log format["DZMS: %1 %2 aborted.",_aiType,_name];
};
//////////////////////////////// End //////////////////////////////////////

// Spawn Mission Objects
local _objects = [[
	["MAP_A_GeneralStore_01",[0,0],-120],
	["MAP_Ind_TankSmall",[10.9,-12.9],-30],
	["MAP_t_acer2s",[-6.1,-24.3]],
	["MAP_t_acer2s",[-21.1,2.6]],
	["MAP_t_acer2s",[7.9,19.6]],
	["MAP_t_acer2s",[23,-7.2]]
],_coords,_mission] call DZMSSpawnObjects;

local _store = _objects select 0;

// Spawn the crate
[_mission,(_store modelToWorld [-8.94629,-3.66602,-1.2164]),"DZ_AmmoBoxMedium2US","store",[0,0],-30] call DZMSSpawnCrate;
[_mission,(_store modelToWorld [-6.87158,-3.67188,-1.21259]),"DZ_AmmoBoxMedium2US","weapons",[0,0],-30] call DZMSSpawnCrate;

//Create the vehicle
[_mission,_coords,DZMSSmallVic,[16.8,-17.4],98.6] call DZMSSpawnVeh;

//DZMSAISpawn spawns AI to the mission.
//Usage: [_coords, count, skillLevel, Hero or Bandit, Mission Number]
[[(_coords select 0) + 12,(_coords select 1) - 23,0],3,0,_aiType,_mission] call DZMSAISpawn;
[[(_coords select 0) - 24,(_coords select 1) - 13,0],3,1,_aiType,_mission] call DZMSAISpawn;
[[(_coords select 0) - 13,(_coords select 1) + 25,0],3,2,_aiType,_mission] call DZMSAISpawn;
[[(_coords select 0) + 26,(_coords select 1) + 14,0],3,3,_aiType,_mission] call DZMSAISpawn;

// Spawn Static M2 Gunner positions if enabled.
if (DZMSM2Static) then {
	[[
		[(_coords select 0) + 25,(_coords select 1) - 25, 0],
		(_store modelToWorld [7.69385,11.2803,-1.19305])
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
	"STR_CL_DZMS_GS_WIN",
	"STR_CL_DZMS_GS_FAIL"
] spawn DZMSWaitMissionComp;
