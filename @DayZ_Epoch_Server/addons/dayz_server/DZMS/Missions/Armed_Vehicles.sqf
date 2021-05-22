/*
	HMMWV Mission by lazyink (Full credit for original code to TheSzerdi & TAW_Tonic)
	Updated to New Mission Format by Vampire
	Updated for DZMS 2.0 by JasonTM
*/

private ["_name","_coords","_aiType","_mission"];

_mission = count DZMSMissionData -1;
_aiType = _this select 0;
_name = "Armed Vehicles";
_coords = call DZMSFindPos;

//We create the vehicles like normal
[_mission,_coords,if (DZMSEpoch) then {"ArmoredSUV_PMC_DZE"} else {"Offroad_DSHKM_INS"},[-6.8,-3.2],-61] call DZMSSpawnVeh;
[_mission,_coords,if (DZMSEpoch) then {"GAZ_Vodnik_DZE"} else {"Pickup_PK_INS"},[6.5,4.2],0] call DZMSSpawnVeh;

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
	[_aiType,"STR_CL_DZMS_AV_TITLE","STR_CL_DZMS_AV_WIN"],
	[_aiType,"STR_CL_DZMS_AV_TITLE","STR_CL_DZMS_AV_FAIL"]
] spawn DZMSWaitMissionComp;

// Send start message
[_aiType,"STR_CL_DZMS_AV_TITLE","STR_CL_DZMS_AV_START"] call DZMSMessage;
