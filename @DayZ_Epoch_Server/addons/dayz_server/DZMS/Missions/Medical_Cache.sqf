/*
	Medical Crate by lazyink (Full credit for original code to TheSzerdi & TAW_Tonic)
	Updated to new format by Vampire
	Updated for DZMS 2.0 by JasonTM
*/

private ["_name","_coords","_aiType","_mission"];

_mission = count DZMSMissionData -1;
_aiType = _this select 0;
_name = "Medical Cache";
_coords = call DZMSFindPos;

//Lets add the scenery
[[
	["Land_CamoNetB_NATO",[-0.0649,0.6025]]
],_coords,_mission] call DZMSSpawnObjects;

//We create the vehicles like normal
[_mission,_coords,DZMSSmallVic,[10.0303,-12.2979]] call DZMSSpawnVeh;
[_mission,_coords,DZMSLargeVic,[-6.2764,-14.086]] call DZMSSpawnVeh;

//[_mission,_coords,"USVehicleBox","medical",[0,0]] call DZMSSpawnCrate;
[_mission,_coords,"DZ_MedBox","medical",[-3.7251,-2.3614]] call DZMSSpawnCrate;
[_mission,_coords,"DZ_MedBox","medical",[-3.4346,0]] call DZMSSpawnCrate;
[_mission,_coords,"DZ_MedBox","medical",[4.0996,3.9072]] call DZMSSpawnCrate;

//DZMSAISpawn spawns AI to the mission.
//Usage: [_coords, count, skillLevel, Hero or Bandit, Mission Number]
[[(_coords select 0) + 0.0352,(_coords select 1) - 6.8799, 0],4,0,_aiType,_mission] call DZMSAISpawn;
[[(_coords select 0) + 0.0352,(_coords select 1) - 6.8799, 0],4,1,_aiType,_mission] call DZMSAISpawn;
[[(_coords select 0) + 0.0352,(_coords select 1) - 6.8799, 0],4,2,_aiType,_mission] call DZMSAISpawn;
[[(_coords select 0) + 0.0352,(_coords select 1) - 6.8799, 0],4,3,_aiType,_mission] call DZMSAISpawn;

// Start the mission loop.
[
	_mission,
	_coords,
	_aiType,
	_name,
	[_aiType,"STR_CL_DZMS_MCACHE_TITLE","STR_CL_DZMS_MCACHE_WIN"],
	[_aiType,"STR_CL_DZMS_MCACHE_TITLE","STR_CL_DZMS_MCACHE_FAIL"]
] spawn DZMSWaitMissionComp;

// Send the start message
[_aiType,"STR_CL_DZMS_MCACHE_TITLE","STR_CL_DZMS_MCACHE_START"] call DZMSMessage;