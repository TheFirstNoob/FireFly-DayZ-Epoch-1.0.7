/*
	Medical Supply Camp by lazyink (Full credit for original code to TheSzerdi & TAW_Tonic)
	Updated to New Mission Format by Vampire
	Updated for DZMS 2.0 by JasonTM
*/

private ["_name","_coords","_aiType","_mission"];

_mission = count DZMSMissionData -1;
_aiType = _this select 0;
_name = "APCs";
_coords = call DZMSFindPos;

//We create the vehicles like normal
//[_mission,_coords,"BTR60_TK_EP1",[-10,-10]] call DZMSSpawnVeh;
//[_mission,_coords,"LAV25_DZE",[20,-5]] call DZMSSpawnVeh;
//[_mission,_coords,"LAV25_HQ_DZE",[30,-5]] call DZMSSpawnVeh;

//We create the vehicles like normal
[_mission,_coords,"BTR60_TK_EP1",[2.4,-4.3],150.5] call DZMSSpawnVeh;
[_mission,_coords,"LAV25_DZE",[2.7,4.8],14.2] call DZMSSpawnVeh;
[_mission,_coords,"LAV25_HQ_DZE",[-6,-0.2],-74] call DZMSSpawnVeh;

//DZMSAISpawn spawns AI to the mission.
//Usage: [_coords, count, skillLevel, Hero or Bandit, Mission Number]
[[(_coords select 0) - 8.4614,(_coords select 1) - 5.0527,0],6,1,_aiType,_mission] call DZMSAISpawn;
[[(_coords select 0) - 8.4614,(_coords select 1) - 5.0527,0],4,1,_aiType,_mission] call DZMSAISpawn;
[[(_coords select 0) + 7.5337,(_coords select 1) + 4.2656,0],4,1,_aiType,_mission] call DZMSAISpawn;
[[(_coords select 0) + 7.5337,(_coords select 1) + 4.2656,0],4,1,_aiType,_mission] call DZMSAISpawn;

// Spawn Static M2 Gunner positions if enabled.
if (DZMSM2Static) then {
	[[
		[(_coords select 0) + 7.3,(_coords select 1) + 17, 0],
		[(_coords select 0) - 18.4,(_coords select 1) + 2, 0],
		[(_coords select 0) + 8,(_coords select 1) - 14.7, 0]
	],0,_aiType,_mission] call DZMSM2Spawn;
};

// Start the mission loop.
[
	_mission,
	_coords,
	_aiType,
	_name,
	[_aiType,"STR_CL_DZMS_APC_TITLE","STR_CL_DZMS_APC_WIN"],
	[_aiType,"STR_CL_DZMS_APC_TITLE","STR_CL_DZMS_APC_FAIL"]
] spawn DZMSWaitMissionComp;

// Send start message
[_aiType,"STR_CL_DZMS_APC_TITLE","STR_CL_DZMS_APC_START"] call DZMSMessage;