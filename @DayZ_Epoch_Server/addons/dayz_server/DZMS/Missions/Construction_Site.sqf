/*
	Constructors Mission by lazyink (Full credit for original code to TheSzerdi & TAW_Tonic)
	Updated to New Mission Format by Vampire
	Updated for DZMS 2.0 by JasonTM
*/

private ["_name","_coords","_mission","_aiType"];

_mission = count DZMSMissionData -1;
_aiType = _this select 0;
_name = "Construction Site";
_coords = call DZMSFindPos;

// Spawn Mission Objects
[[
	["MAP_A_BuildingWIP",[-2,1,.04],-30],
	["Land_Ind_Workshop01_01",[-27,-15],-31.6],
	["Land_Ind_Workshop01_03",[9,38],-72],
	["Land_Misc_Cargo1Ao",[31,20],99.8],
	["Land_Misc_Cargo1B",[-36,2]],
	["Land_Ind_TankSmall",[18,21],59],
	["Land_Ind_TankBig",[37,-7]],
	["Land_Ind_TankBig",[-13,-35]]
],_coords,_mission] call DZMSSpawnObjects;

//Create the vehicles
[_mission,_coords,DZMSLargeVic,[-3,28]] call DZMSSpawnVeh;
[_mission,_coords,DZMSSmallVic,[-26,14]] call DZMSSpawnVeh;

//Create the loot
[_mission,_coords,"USVehicleBox","supply",[-.6,6.9,0.37],-30] call DZMSSpawnCrate;
[_mission,_coords,"USVehicleBox","supply2",[7.6,10.3,0.50],-30] call DZMSSpawnCrate;

//DZMSAISpawn spawns AI to the mission.
//Usage: [_coords, count, skillLevel, Hero or Bandit, Mission Number]
[[(_coords select 0) - 21,(_coords select 1) + 32,0],6,0,_aiType,_mission] call DZMSAISpawn;
[[(_coords select 0) + 56,(_coords select 1) + 27,0],6,1,_aiType,_mission] call DZMSAISpawn;
[[(_coords select 0) + 27,(_coords select 1) - 52,0],6,2,_aiType,_mission] call DZMSAISpawn;
[[(_coords select 0) - 41,(_coords select 1) - 20,0],6,3,_aiType,_mission] call DZMSAISpawn;

// Spawn Static M2 Gunner positions if enabled.
if (DZMSM2Static) then {
	[[
		[(_coords select 0) + 42.57,(_coords select 1) - 4.7, 10],
		[(_coords select 0) - 16.45,(_coords select 1) - 38.5, 10],
		[(_coords select 0) + 2.05,(_coords select 1) + 16, 12.3]
	],0,_aiType,_mission] call DZMSM2Spawn;
};

// Start the mission loop.
[
	_mission,
	_coords,
	_aiType,
	_name,
	[_aiType,"STR_CL_DZMS_CONST_TITLE","STR_CL_DZMS_CONST_WIN"],
	[_aiType,"STR_CL_DZMS_CONST_TITLE","STR_CL_DZMS_CONST_FAIL"]
] spawn DZMSWaitMissionComp;

// Send the start message
[_aiType,"STR_CL_DZMS_CONST_TITLE","STR_CL_DZMS_CONST_START"] call DZMSMessage;
