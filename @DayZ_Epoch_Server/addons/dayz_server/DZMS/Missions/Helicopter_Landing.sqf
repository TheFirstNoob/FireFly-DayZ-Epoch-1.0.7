/*
	Bandit Supply Heli Crash by lazyink (Full credit for original code to TheSzerdi & TAW_Tonic)
	New Mission Format by Vampire
	Updated for DZMS 2.0 by JasonTM
*/

private ["_name","_coords","_mission","_aiType"];

_mission = count DZMSMissionData -1;
_aiType = _this select 0;
_name = "Helicopter Landing";
_coords = call DZMSFindPos;

// Spawn Mission Objects
[[
	["Body1",[-3.0185,-0.084]],
	["Body2",[1.9248,2.1201]]
],_coords,_mission] call DZMSSpawnObjects;

//We create the vehicles like normal
[_mission,_coords,DZMSChoppers,[0,0],-36.279881] call DZMSSpawnVeh;
[_mission,_coords,"HMMWV_DZ",[-8.7802,6.874]] call DZMSSpawnVeh;

//DZMSBoxFill fills the box, DZMSProtectObj prevents it from disappearing
[_mission,_coords,"USLaunchersBox","weapons",[-6.1718,0.6426]] call DZMSSpawnCrate;
[_mission,_coords,"USLaunchersBox","store",[-7.1718,1.6426]] call DZMSSpawnCrate;

//DZMSAISpawn spawns AI to the mission.
//Usage: [_coords, count, skillLevel, Hero or Bandit, Mission Number]
[[(_coords select 0) - 8.4614,(_coords select 1) - 5.0527,0],4,0,_aiType,_mission] call DZMSAISpawn;
[[(_coords select 0) - 8.4614,(_coords select 1) - 5.0527,0],4,1,_aiType,_mission] call DZMSAISpawn;
[[(_coords select 0) + 7.5337,(_coords select 1) + 4.2656,0],4,2,_aiType,_mission] call DZMSAISpawn;
[[(_coords select 0) + 7.5337,(_coords select 1) + 4.2656,0],4,3,_aiType,_mission] call DZMSAISpawn;

// Spawn Static M2 Gunner positions if enabled.
if (DZMSM2Static) then {
	[[
	[(_coords select 0) + 13.28,(_coords select 1) - 16.46, 0],
	[(_coords select 0) - 11.29,(_coords select 1) + 15.89, 0]
	],0,_aiType,_mission] call DZMSM2Spawn;
};

// Start the mission loop.
[
	_mission,
	_coords,
	_aiType,
	_name,
	[_aiType,"STR_CL_DZMS_HL_TITLE","STR_CL_DZMS_HL_WIN"],
	[_aiType,"STR_CL_DZMS_HL_TITLE","STR_CL_DZMS_HL_FAIL"]
] spawn DZMSWaitMissionComp;

// Send the start message
[_aiType,"STR_CL_DZMS_HL_TITLE","STR_CL_DZMS_HL_START"] call DZMSMessage;
