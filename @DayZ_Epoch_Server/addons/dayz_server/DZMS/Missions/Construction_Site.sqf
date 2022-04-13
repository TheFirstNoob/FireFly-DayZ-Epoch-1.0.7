/*
	Constructors Mission by lazyink (Full credit for original code to TheSzerdi & TAW_Tonic)
	Updated to New Mission Format by Vampire
	Updated for DZMS 2.0 by JasonTM
*/

local _mission = count DZMSMissionData -1;
local _aiType = _this select 0;
local _coords = call DZMSFindPos;
local _name = "Construction Site";
local _localName = "STR_CL_DZMS_CONST_TITLE";
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
[_aiType,_localName,"STR_CL_DZMS_CONST_START"] call DZMSMessage;
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
	[_aiType,_localName,"STR_CL_DZMS_CONST_FAIL"] call DZMSMessage;
	diag_log format["DZMS: %1 %2 aborted.",_aiType,_name];
};
//////////////////////////////// End //////////////////////////////////////

// Spawn Mission Objects
local _objects = [[
	["MAP_A_BuildingWIP",[-2,1,.04],-30],
	["Land_Ind_TankBig",[37,-7]],
	["Land_Ind_TankBig",[-13,-35]],
	["Land_Ind_Workshop01_01",[-27,-15],-31.6],
	["Land_Ind_Workshop01_03",[9,38],-72],
	["Land_Misc_Cargo1Ao",[31,20],99.8],
	["Land_Misc_Cargo1B",[-36,2]],
	["Land_Ind_TankSmall",[18,21],59]
],_coords,_mission] call DZMSSpawnObjects;

local _wipBuilding = _objects select 0;

//Create the vehicles
[_mission,_coords,DZMSLargeVic,[-3,28]] call DZMSSpawnVeh;
[_mission,_coords,DZMSSmallVic,[-26,14]] call DZMSSpawnVeh;

//Create the loot
[_mission,(_wipBuilding modelToWorld [-2.06445,5.56738,-6.51697]),"DZ_AmmoBoxBigUS","supply",[0,0],-30] call DZMSSpawnCrate;
[_mission,(_wipBuilding modelToWorld [6.11914,5.56396,-6.40808]),"DZ_AmmoBoxBigUS","supply2",[0,0],-30] call DZMSSpawnCrate;
[_mission,(_wipBuilding modelToWorld [0.636719,5.57471,-6.43134]),"DZ_AmmoBoxBigUS","supply2",[0,0],-30] call DZMSSpawnCrate;

//DZMSAISpawn spawns AI to the mission.
//Usage: [_coords, count, skillLevel, Hero or Bandit, Mission Number]
[[(_coords select 0) - 21,(_coords select 1) + 32,0],6,0,_aiType,_mission] call DZMSAISpawn;
[[(_coords select 0) + 56,(_coords select 1) + 27,0],6,1,_aiType,_mission] call DZMSAISpawn;
[[(_coords select 0) + 27,(_coords select 1) - 52,0],6,2,_aiType,_mission] call DZMSAISpawn;
[[(_coords select 0) - 41,(_coords select 1) - 20,0],6,3,_aiType,_mission] call DZMSAISpawn;

// Spawn Static M2 Gunner positions if enabled.
if (DZMSM2Static) then {
	[[
		(_wipBuilding modelToWorld [3.88672,11.9736,5.3772]),
		(_wipBuilding modelToWorld [-25.041,12.5439,5.8855]),
		((_objects select 2) modelToWorld [-5.40625,-4.40625,5.35645]),
		((_objects select 1) modelToWorld [4.62305,2.0127,5.35931])
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
	"STR_CL_DZMS_CONST_WIN",
	"STR_CL_DZMS_CONST_FAIL"
] spawn DZMSWaitMissionComp;
