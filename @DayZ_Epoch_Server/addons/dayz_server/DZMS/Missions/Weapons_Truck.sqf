/*
	Weapon Truck Crash by lazyink (Full credit for code to TheSzerdi & TAW_Tonic)
	Updated to new format by Vampire
	Updated for DZMS 2.0 by JasonTM
*/
private ["_name","_coords","_mission","_aiType"];

_mission = count DZMSMissionData -1;
_aiType = _this select 0;
_name = "Weapons Truck";
_coords = call DZMSFindPos;

//Add scenery
[[
	["UralWreck",[0,0]]
],_coords,_mission] call DZMSSpawnObjects;

// Spawn crates
[_mission,_coords,"USLaunchersBox","weapons",[3,0]] call DZMSSpawnCrate;
[_mission,_coords,"USLaunchersBox","weapons",[-3,0]] call DZMSSpawnCrate;
[_mission,_coords,"RULaunchersBox","weapons",[-6,0]] call DZMSSpawnCrate;


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
	[_aiType,"STR_CL_DZMS_WT_TITLE","STR_CL_DZMS_WT_WIN"],
	[_aiType,"STR_CL_DZMS_WT_TITLE","STR_CL_DZMS_WT_FAIL"]
] spawn DZMSWaitMissionComp;

// Send the start message
[_aiType,"STR_CL_DZMS_WT_TITLE","STR_CL_DZMS_WT_START"] call DZMSMessage;