/*
	Bandit Heli Down! by lazyink (Full credit for code to TheSzerdi & TAW_Tonic)
	Updated to new format by Vampire
	Updated for DZMS 2.0 by JasonTM
*/
private ["_name","_coords","_aiType","_mission"];

_mission = count DZMSMissionData -1;
_aiType = _this select 0;
_name = "Helicopter Crash";
_coords = call DZMSFindPos;

// Spawn Mission Objects
[[
	["CrashSite_US",[0,0]]
],_coords,_mission] call DZMSSpawnObjects;

[_mission,_coords,"USLaunchersBox","weapons",[-6,0]] call DZMSSpawnCrate;

//DZMSAISpawn spawns AI to the mission.
//Usage: [_coords, count, skillLevel, Hero or Bandit, Mission Number]
[_coords,3,0,_aiType,_mission] call DZMSAISpawn;
[_coords,3,1,_aiType,_mission] call DZMSAISpawn;
[_coords,3,2,_aiType,_mission] call DZMSAISpawn;

// Start the mission loop.
[
	_mission,
	_coords,
	_aiType,
	_name,
	[_aiType,"STR_CL_DZMS_HC_TITLE","STR_CL_DZMS_HC_WIN"],
	[_aiType,"STR_CL_DZMS_HC_TITLE","STR_CL_DZMS_HC_FAIL"]
] spawn DZMSWaitMissionComp;

// Send the start message
[_aiType,"STR_CL_DZMS_HC_TITLE","STR_CL_DZMS_HC_START"] call DZMSMessage;