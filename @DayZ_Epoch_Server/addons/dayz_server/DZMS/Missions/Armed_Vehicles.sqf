/*
	HMMWV Mission by lazyink (Full credit for original code to TheSzerdi & TAW_Tonic)
	Updated to New Mission Format by Vampire
	Updated for DZMS 2.0 by JasonTM
*/

local _mission = count DZMSMissionData -1;
local _aiType = _this select 0;
local _coords = call DZMSFindPos;
local _name = "Armed Vehicles";
local _localName = "STR_CL_DZMS_AV_TITLE";
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
[_aiType,_localName,"STR_CL_DZMS_AV_START"] call DZMSMessage;
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
	[_aiType,_localName,"STR_CL_DZMS_AV_FAIL"] call DZMSMessage;
	diag_log format["DZMS: %1 %2 aborted.",_aiType,_name,_coords];
};
//////////////////////////////// End //////////////////////////////////////

//We create the vehicles like normal
[_mission,_coords,["Offroad_DSHKM_INS",(["HMMWV_GPK_M2_WINTER_DZE","ArmoredSUV_PMC_DZE","LandRover_MG_TK_EP1_DZE","HMMWV_M1114_DSHKM_ACR_DZE"] call BIS_fnc_selectRandom)] select DZMSEpoch,[-6.8,-3.2],-61] call DZMSSpawnVeh;
[_mission,_coords,["Pickup_PK_INS",(["GAZ_Vodnik_DZE","BTR40_MG_TK_INS_EP1_DZE","UAZ_MG_WINTER_DZE","HMMWV_M2_DZE"] call BIS_fnc_selectRandom)] select DZMSEpoch,[6.5,4.2],0] call DZMSSpawnVeh;

// Put a crate in the middle
[_mission,_coords,"DZ_AmmoBoxMedium1US","ArmedVehicle",[0,0]] call DZMSSpawnCrate;

//DZMSAISpawn spawns AI to the mission.
//Usage: [_coords, count, skillLevel, Hero or Bandit, Mission Number]
[[(_coords select 0) - 8.4614,(_coords select 1) - 5.0527,0],4,0,_aiType,_mission] call DZMSAISpawn;
[[(_coords select 0) - 8.4614,(_coords select 1) - 5.0527,0],4,1,_aiType,_mission] call DZMSAISpawn;
[[(_coords select 0) + 7.5337,(_coords select 1) + 4.2656,0],4,2,_aiType,_mission] call DZMSAISpawn;
[[(_coords select 0) + 7.5337,(_coords select 1) + 4.2656,0],4,3,_aiType,_mission] call DZMSAISpawn;

// Spawn Static M2 Gunner positions if enabled.
if (DZMSM2Static) then {
	[[
	[(_coords select 0) + 15.5,(_coords select 1) - 13.2, 0],
	[(_coords select 0) - 16,(_coords select 1) + 14.5, 0]
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
	"STR_CL_DZMS_AV_WIN",
	"STR_CL_DZMS_AV_FAIL"
] spawn DZMSWaitMissionComp;
