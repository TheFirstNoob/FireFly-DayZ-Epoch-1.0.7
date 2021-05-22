/*
	Bandit Stash House by lazyink (Full credit for code to TheSzerdi & TAW_Tonic)
	Updated to new format by Vampire
	Updated for DZMS 2.0 by JasonTM
*/
private ["_name","_coords","_mission","_aiType"];

_mission = count DZMSMissionData -1;
_aiType = _this select 0;
_name = "Stash House";
_coords = call DZMSFindPos;

//We create the scenery
[[
	["MAP_HouseV_1I4",[0,0],152.66766],
	["Land_kulna",[5.4585,-2.885],-28.282881]
],_coords,_mission] call DZMSSpawnObjects;


//We create the vehicle
[_mission,_coords,DZMSSmallVic,[-10.6206,-0.49]] call DZMSSpawnVeh;

//We create and fill the crate
[_mission,_coords,"USBasicAmmunitionBox","weapons",[0.7408,1.565,0.10033049]] call DZMSSpawnCrate;
[_mission,_coords,"USBasicAmmunitionBox","weapons",[-0.2387,1.043,0.10033049]] call DZMSSpawnCrate;

//DZMSAISpawn spawns AI to the mission.
//Usage: [_coords, count, skillLevel, Hero or Bandit, Mission Number]
[[(_coords select 0) - 4.0796, (_coords select 1) - 11.709,0],6,2,_aiType,_mission] call DZMSAISpawn;
[[(_coords select 0) + 2.8872, (_coords select 1) + 18.964,0],6,2,_aiType,_mission] call DZMSAISpawn;

// Spawn Static M2 Gunner positions if enabled.
if (DZMSM2Static) then {
	[[
		[(_coords select 0) - 7.9,(_coords select 1) + 13.78, 0],
		[(_coords select 0) + 9.34,(_coords select 1) - 14.17, 0]
	],0,_aiType,_mission] call DZMSM2Spawn;
};

// Start the mission loop.
[
	_mission,
	_coords,
	_aiType,
	_name,
	[_aiType,"STR_CL_DZMS_STASH_TITLE","STR_CL_DZMS_STASH_WIN"],
	[_aiType,"STR_CL_DZMS_STASH_TITLE","STR_CL_DZMS_STASH_FAIL"]
] spawn DZMSWaitMissionComp;

// Send the start message
[_aiType,"STR_CL_DZMS_STASH_TITLE","STR_CL_DZMS_STASH_START"] call DZMSMessage;