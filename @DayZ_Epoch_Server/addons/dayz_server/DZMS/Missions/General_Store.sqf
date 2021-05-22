/*
	General Store Mission by JasonTM
*/
private ["_name","_coords","_aiType","_mission"];

_mission = count DZMSMissionData -1;
_aiType = _this select 0;
_name = "General Store";
_coords = call DZMSFindPos;

// Spawn Mission Objects
[[
	["MAP_A_GeneralStore_01",[0,0],-120],
	["MAP_Ind_TankSmall",[10.9,-12.9],-30],
	["MAP_t_acer2s",[-6.1,-24.3]],
	["MAP_t_acer2s",[-21.1,2.6]],
	["MAP_t_acer2s",[7.9,19.6]],
	["MAP_t_acer2s",[23,-7.2]]
],_coords,_mission] call DZMSSpawnObjects;

// Spawn the crate
[_mission,_coords,"USBasicWeaponsBox","store",[5.9,-7.5,1.2],-30] call DZMSSpawnCrate;
[_mission,_coords,"USBasicWeaponsBox","weapons",[3.91,-5.06,1.2],-30] call DZMSSpawnCrate;

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
		[(_coords select 0) - 14,(_coords select 1) - 1.09, 1.17963]
	],0,_aiType,_mission] call DZMSM2Spawn;
};

// Start the mission loop.
[
	_mission,
	_coords,
	_aiType,
	_name,
	[_aiType,"STR_CL_DZMS_GS_TITLE","STR_CL_DZMS_GS_WIN"],
	[_aiType,"STR_CL_DZMS_GS_TITLE","STR_CL_DZMS_GS_FAIL"]
] spawn DZMSWaitMissionComp;

// Send start message
[_aiType,"STR_CL_DZMS_GS_TITLE","STR_CL_DZMS_GS_START"] call DZMSMessage;