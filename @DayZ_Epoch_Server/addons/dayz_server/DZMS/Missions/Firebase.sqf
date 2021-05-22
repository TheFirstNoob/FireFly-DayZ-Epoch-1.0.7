/*
	Fire Base Camp by lazyink (Full credit for original code to TheSzerdi & TAW_Tonic)
	Updated to New Mission Format by Vampire
	Updated for DZMS 2.0 by JasonTM
*/

private ["_name","_coords","_mission","_aiType"];

_mission = count DZMSMissionData -1;
_aiType = _this select 0;
_name = "Firebase";
_coords = call DZMSFindPos;

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

[_mission,_coords,"USVehicleBox","supply",[2,-4],-30] call DZMSSpawnCrate;
[_mission,_coords,"USVehicleBox","supply2",[-2,4],-30] call DZMSSpawnCrate;
[_mission,_coords,"USBasicWeaponsBox","weapons",[-5,-2.5],60] call DZMSSpawnCrate;
[_mission,_coords,"USBasicWeaponsBox","weapons",[5,3.3],60] call DZMSSpawnCrate;

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
	[_aiType,"STR_CL_DZMS_FB_TITLE","STR_CL_DZMS_FB_WIN"],
	[_aiType,"STR_CL_DZMS_FB_TITLE","STR_CL_DZMS_FB_FAIL"]
] spawn DZMSWaitMissionComp;

// Send the start message
[_aiType,"STR_CL_DZMS_FB_TITLE","STR_CL_DZMS_FB_START"] call DZMSMessage;
