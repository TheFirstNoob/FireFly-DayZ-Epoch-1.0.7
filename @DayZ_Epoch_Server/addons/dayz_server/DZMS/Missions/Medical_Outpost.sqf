/*
	Medical Outpost by lazyink (Full credit for code to TheSzerdi & TAW_Tonic)
	Updated to new format by Vampire
	Updated for DZMS 2.0 by JasonTM
*/
private ["_name","_coords","_mission","_aiType"];

_mission = count DZMSMissionData -1;
_aiType = _this select 0;
_name = "Medical Outpost";
_coords = call DZMSFindPos;

// Spawn Mission Objects
[[
	//["US_WarfareBFieldhHospital_Base_EP1",[2,5,-0.3]],
	["US_WarfareBFieldhHospital_Base_EP1",[2,5]],
	["MASH_EP1",[-24,-5]],
	["MASH_EP1",[-17,-5]],
	["MASH_EP1",[-10,-5]]
],_coords,_mission] call DZMSSpawnObjects;

//We create the vehicles
[_mission,_coords,DZMSSmallVic,[10,-5]] call DZMSSpawnVeh;
[_mission,_coords,DZMSSmallVic,[15,-5]] call DZMSSpawnVeh;

//We create and fill the crates
[_mission,_coords,"DZ_MedBox","medical",[-3,0,0.15]] call DZMSSpawnCrate;
[_mission,_coords,"USLaunchersBox","weapons",[-8,0]] call DZMSSpawnCrate;

//DZMSAISpawn spawns AI to the mission.
//Usage: [_coords, count, skillLevel, Hero or Bandit, Mission Number]
[[(_coords select 0) - 20, (_coords select 1) - 15,0],4,0,_aiType,_mission] call DZMSAISpawn;
[[(_coords select 0) + 10, (_coords select 1) + 15,0],4,1,_aiType,_mission] call DZMSAISpawn;
[[(_coords select 0) - 10, (_coords select 1) - 15,0],4,2,_aiType,_mission] call DZMSAISpawn;
[[(_coords select 0) + 20, (_coords select 1) + 15,0],4,3,_aiType,_mission] call DZMSAISpawn;

// Start the mission loop.
[
	_mission,
	_coords,
	_aiType,
	_name,
	[_aiType,"STR_CL_DZMS_MOP_TITLE","STR_CL_DZMS_MOP_WIN"],
	[_aiType,"STR_CL_DZMS_MOP_TITLE","STR_CL_DZMS_MOP_FAIL"]
] spawn DZMSWaitMissionComp;

// Send the start message
[_aiType,"STR_CL_DZMS_MOP_TITLE","STR_CL_DZMS_MOP_START"] call DZMSMessage;