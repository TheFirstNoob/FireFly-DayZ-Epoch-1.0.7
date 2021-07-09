/*																					//
	Weapons Cache Mission by lazyink (Original Full Code by TheSzerdi & TAW_Tonic)
	New Mission Format by Vampire
	Updated for DZMS 2.0 by JasonTM
*/																					//

private ["_name","_coords","_mission","_aiType"];

_mission = count DZMSMissionData -1;
_aiType = _this select 0;
_name = "Weapons Cache";
_coords = call DZMSFindPos;

//Lets add the scenery
[[
	["Land_CamoNetB_NATO",[-0.0649,0.6025]]
],_coords,_mission] call DZMSSpawnObjects;

//We create the vehicles like normal
[_mission,_coords,DZMSSmallVic,[10.0303,-12.2979]] call DZMSSpawnVeh;
[_mission,_coords,DZMSLargeVic,[-6.2764,-14.086]] call DZMSSpawnVeh;

[_mission,_coords,"USVehicleBox","weapons2",[0,0]] call DZMSSpawnCrate;

//DZMSAISpawn spawns AI to the mission.
//Usage: [_coords, count, skillLevel, Hero or Bandit, Mission Number]
[[(_coords select 0) + 0.0352,(_coords select 1) - 6.8799, 0],4,0,_aiType,_mission] call DZMSAISpawn;
[[(_coords select 0) + 0.0352,(_coords select 1) - 6.8799, 0],4,1,_aiType,_mission] call DZMSAISpawn;
[[(_coords select 0) + 0.0352,(_coords select 1) - 6.8799, 0],4,2,_aiType,_mission] call DZMSAISpawn;
[[(_coords select 0) + 0.0352,(_coords select 1) - 6.8799, 0],4,3,_aiType,_mission] call DZMSAISpawn;

// Spawn Static M2 Gunner positions if enabled.
if (DZMSM2Static) then {
	[[
		[(_coords select 0) + 25,(_coords select 1) - 25, 0],
		[(_coords select 0) - 25,(_coords select 1) + 25, 0]
	],0,_aiType,_mission] call DZMSM2Spawn;
};

// Start the mission loop.
[
	_mission,
	_coords,
	_aiType,
	_name,
	[_aiType,"STR_CL_DZMS_WCACHE_TITLE","STR_CL_DZMS_WCACHE_WIN"],
	[_aiType,"STR_CL_DZMS_WCACHE_TITLE","STR_CL_DZMS_WCACHE_FAIL"]
] spawn DZMSWaitMissionComp;

// Send the start message
[_aiType,"STR_CL_DZMS_WCACHE_TITLE","STR_CL_DZMS_WCACHE_START"] call DZMSMessage;