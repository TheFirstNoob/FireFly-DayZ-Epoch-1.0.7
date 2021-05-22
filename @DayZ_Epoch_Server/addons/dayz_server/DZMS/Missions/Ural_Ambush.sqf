/*
	Medical Ural Attack by lazyink (Full credit for original code to TheSzerdi & TAW_Tonic)
	Updated to New Format by Vampire
	Updated for DZMS 2.0 by JasonTM
*/

private ["_aiType","_name","_coords","_mission"];

_mission = count DZMSMissionData -1;
_aiType = _this select 0;
_name = "Ural Ambush";
_coords = call DZMSFindPos;

// Spawn Mission Objects
[[
	["UralWreck",[0,0],149.64919],
	["Body",[-2.2905,-3.3438],61.798588],
	["Body",[-2.8511,-2.4346],52.402905],
	["Body",[-3.435,-1.4297],-117.27345],
	["Body2",[-4.0337,0.5],23.664057]
],_coords,_mission] call DZMSSpawnObjects;

//We create the vehicles like normal
[_mission,_coords,DZMSSmallVic,[5.7534,-9.2149]] call DZMSSpawnVeh;

// Spawn crates
[_mission,_coords,"USBasicWeaponsBox","supply",[2.6778,-3.0889],-28.85478] call DZMSSpawnCrate;
[_mission,_coords,"DZ_MedBox","medical",[1.4805,-3.7432],62.744293] call DZMSSpawnCrate;
[_mission,_coords,"USBasicAmmunitionBox","weapons",[2.5405,-4.1612],-27.93351] call DZMSSpawnCrate;

//DZMSAISpawn spawns AI to the mission.
//Usage: [_coords, count, skillLevel, AI type, mission number]
[[(_coords select 0) - 6.9458,(_coords select 1) - 3.5352, 0],6,1,_aiType,_mission] call DZMSAISpawn;
[[(_coords select 0) + 4.4614,(_coords select 1) + 2.5898, 0],6,1,_aiType,_mission] call DZMSAISpawn;
[[(_coords select 0) + 4.4614,(_coords select 1) + 2.5898, 0],4,1,_aiType,_mission] call DZMSAISpawn;

// Spawn Static M2 Gunner positions if enabled.
if (DZMSM2Static) then {
	[[
	[(_coords select 0) + 11.64,(_coords select 1) + 11.5, 0],
	[(_coords select 0) - 9.37,(_coords select 1) - 14.58, 0]
	],0,_aiType,_mission] call DZMSM2Spawn;
};

// Start the mission loop.
[
	_mission,
	_coords,
	_aiType,
	_name,
	[_aiType,"STR_CL_DZMS_URAL_TITLE","STR_CL_DZMS_URAL_WIN"],
	[_aiType,"STR_CL_DZMS_URAL_TITLE","STR_CL_DZMS_URAL_FAIL"]
] spawn DZMSWaitMissionComp;

// Send the start message
[_aiType,"STR_CL_DZMS_URAL_TITLE","STR_CL_DZMS_URAL_START"] call DZMSMessage;