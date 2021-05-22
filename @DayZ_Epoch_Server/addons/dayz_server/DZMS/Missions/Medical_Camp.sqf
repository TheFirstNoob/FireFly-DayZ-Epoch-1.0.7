/*
	Medical Supply Camp by lazyink (Full credit for original code to TheSzerdi & TAW_Tonic)
	Updated to New Mission Format by Vampire
	Updated for DZMS 2.0 by JasonTM
*/

private ["_name","_coords","_mission","_aiType","_toolbox"];

_mission = count DZMSMissionData -1;
_aiType = _this select 0;
_name = "Medical Camp";
_coords = call DZMSFindPos;

//Create the scenery
[[
	["Land_fort_artillery_nest",[-5.939,10.0459],-31.158424],
	["Land_fort_artillery_nest",[6.3374,-11.1944],-211.14516],
	["Land_fort_rampart",[12.2456,6.249],-120.93051],
	["Land_fort_rampart",[-11.4253,-7.628],59.42643],
	["Land_CamoNetVar_EAST",[4.1738,-7.9112],-27.004126],
	["PowGen_Big",[-0.8936,8.1582],-56.044361],
	["Barrel5",[-2.5074,7.3466]],
	["Barrel5",[-3.293,7.9179]],
	["Land_Campfire_burning",[3.1367,-5.087]],
	["FoldChair",[0.8589,-6.2676],-132.43658],
	["FoldChair",[2.6909,-7.4805],-184.45828],
	["FoldChair",[5.4175,-5.4903],96.993355],
	["FoldChair",[4.5722,-7.2305],142.91867],
	["FoldChair",[5.0542,-3.4649],55.969147]
],_coords,_mission] call DZMSSpawnObjects;

//Create the vehicles
[_mission,_coords,DZMSSmallVic,[-17.5078,5.2578]] call DZMSSpawnVeh;

//Create the loot
//[_mission,_coords,"USLaunchersBox","weapons",[-6.8277,5.6748]] call DZMSSpawnCrate;
[_mission,_coords,"DZ_MedBox","medical",[-7.1519,1.8144],-29.851013] call DZMSSpawnCrate;
[_mission,_coords,"DZ_MedBox","medical",[-7.4116,2.5244]] call DZMSSpawnCrate;

_toolbox = createVehicle ["WeaponHolder_ItemToolbox",[(_coords select 0) - 7.7041, (_coords select 1) + 3.332,0],[], 0, "CAN_COLLIDE"];
_toolbox setDir -106.46461;
_toolbox setVariable ["permaLoot",true];

//DZMSAISpawn spawns AI to the mission.
//Usage: [_coords, count, skillLevel, Hero or Bandit, Mission Number]
[[(_coords select 0) - 0.5635,(_coords select 1) + 0.3173,0],3,0,_aiType,_mission] call DZMSAISpawn;
[[(_coords select 0) - 0.5635,(_coords select 1) + 0.3173,0],3,1,_aiType,_mission] call DZMSAISpawn;
[[(_coords select 0) - 0.5635,(_coords select 1) + 0.3173,0],3,2,_aiType,_mission] call DZMSAISpawn;
[[(_coords select 0) - 0.5635,(_coords select 1) + 0.3173,0],3,3,_aiType,_mission] call DZMSAISpawn;

// Start the mission loop.
[
	_mission,
	_coords,
	_aiType,
	_name,
	[_aiType,"STR_CL_DZMS_MCAMP_TITLE","STR_CL_DZMS_MCAMP_WIN"],
	[_aiType,"STR_CL_DZMS_MCAMP_TITLE","STR_CL_DZMS_MCAMP_FAIL"]
] spawn DZMSWaitMissionComp;

// Send the start message
[_aiType,"STR_CL_DZMS_MCAMP_TITLE","STR_CL_DZMS_MCAMP_START"] call DZMSMessage;
