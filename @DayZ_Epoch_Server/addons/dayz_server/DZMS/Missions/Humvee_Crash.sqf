/*
	Hummer Wreck by lazyink (Full credit for code to TheSzerdi & TAW_Tonic)
	Updated to new format by Vampire
	Updated for DZMS 2.0 by JasonTM
*/
private ["_name","_coords","_mission","_aiType"];

_mission = count DZMSMissionData -1;

// "Hero" or "Bandit" acquired from the timer
_aiType = _this select 0;

//Name of the Mission
_name = "Humvee Crash";

//DZMSFindPos loops BIS_fnc_findSafePos until it gets a valid result
_coords = call DZMSFindPos;

[[
	["HMMWVwreck",[0,0]]
],_coords,_mission] call DZMSSpawnObjects;

// Spawn crate
[_mission,_coords,"RULaunchersBox","weapons",[-14,0]] call DZMSSpawnCrate;

//DZMSAISpawn spawns AI to the mission.
//Usage: [_coords, count, skillLevel, AI type, mission number]
[_coords,3,1,_aiType,_mission] call DZMSAISpawn;
[_coords,3,1,_aiType,_mission] call DZMSAISpawn;

// Start the mission loop.
[
	_mission,
	_coords,
	_aiType,
	_name,
	[_aiType,"STR_CL_DZMS_HUM_TITLE","STR_CL_DZMS_HUM_WIN"],
	[_aiType,"STR_CL_DZMS_HUM_TITLE","STR_CL_DZMS_HUM_FAIL"]
] spawn DZMSWaitMissionComp;

// Send the start message
[_aiType,"STR_CL_DZMS_HUM_TITLE","STR_CL_DZMS_HUM_START"] call DZMSMessage;