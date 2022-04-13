/*
	Medical C-130 Crash by lazyink (Full credit for original code to TheSzerdi & TAW_Tonic)
	Modified to new format by Vampire
	Updated for DZMS 2.0 by JasonTM
*/

local _mission = count DZMSMissionData -1;
local _aiType = _this select 0;
local _coords = call DZMSFindPos;
local _name = "C130 Crash";
local _localName = "STR_CL_DZMS_C130_TITLE";
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
[_aiType,_localName,"STR_CL_DZMS_C130_START"] call DZMSMessage;
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
	[_aiType,_localName,"STR_CL_DZMS_C130_FAIL"] call DZMSMessage;
	diag_log format["DZMS: %1 %2 aborted.",_aiType,_name];
};
//////////////////////////////// End //////////////////////////////////////

// Spawn Mission Objects
local _objects = [[ // The last object in the list gets returned.
	["Barrels",[-7.4511,3.8544],61.911976],
	["Misc_palletsfoiled",[4.062,4.7216],-29.273479],
	["Paleta2",[-3.4033,-2.2256],52.402905],
	["Land_Pneu",[1.17,1.249],-117.27345],
	["Land_transport_crates_EP1",[3.9029,-1.8477],-70.372086],
	["Fort_Crate_wood",[-2.1181,5.9765],-28.122475],
	([["C130J_wreck_EP1",[-8.8681,15.3554,-.55],149.834555],["C130J",[-8.8681,15.3554],-30]] select DZMSEpoch)
],_coords,_mission] call DZMSSpawnObjects;

local _wreck = _objects select 6;

if (typeOf _wreck == "C130J") then {
	_wreck setVehicleLock "LOCKED";
	_wreck animate ["ramp_top",1];
	_wreck animate ["ramp_bottom",1];
};

//We create the mission vehicles
[_mission,_coords,DZMSSmallVic,[14.1426,-0.6202]] call DZMSSpawnVeh;
[_mission,_coords,DZMSSmallVic,[-6.541,-11.5557]] call DZMSSpawnVeh;

//DZMSBoxFill fills the box, DZMSProtectObj prevents it from disappearing
[_mission,_coords,"DZ_AmmoBoxBigUS","supply",[-1.5547,2.3486]] call DZMSSpawnCrate;
[_mission,_coords,"DZ_AmmoBoxMedium1US","supply2",[0.3428,-1.8985]] call DZMSSpawnCrate;

//DZMSAISpawn spawns AI to the mission.
//Usage: [_coords, count, skillLevel, Hero or Bandit, Mission Number]
[[(_coords select 0) - 10.5005,(_coords select 1) - 2.6465,0],6,0,_aiType,_mission] call DZMSAISpawn;
[[(_coords select 0) + 4.7027,(_coords select 1) + 12.2138,0],6,1,_aiType,_mission] call DZMSAISpawn;
[[(_coords select 0) + 2.918,(_coords select 1) - 9.0342,0],4,2,_aiType,_mission] call DZMSAISpawn;
[[(_coords select 0) + 2.918,(_coords select 1) - 9.0342,0],4,3,_aiType,_mission] call DZMSAISpawn;

// Spawn Static M2 Gunner positions if enabled.
if (DZMSM2Static) then {
	[[
		[(_coords select 0) - 28.4,(_coords select 1) + 6, 0],
		[(_coords select 0) + 8.9,(_coords select 1) + 27.43, 0]
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
	"STR_CL_DZMS_C130_WIN",
	"STR_CL_DZMS_C130_FAIL"
] spawn DZMSWaitMissionComp;
