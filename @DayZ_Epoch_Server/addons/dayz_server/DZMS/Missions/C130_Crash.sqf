/*
	Medical C-130 Crash by lazyink (Full credit for original code to TheSzerdi & TAW_Tonic)
	Modified to new format by Vampire
	Updated for DZMS 2.0 by JasonTM
*/

private ["_name","_coords","_aiType","_mission","_wreck"];

_mission = count DZMSMissionData -1;
_aiType = _this select 0;
_name = "C130 Crash";
_coords = call DZMSFindPos;

// Spawn Mission Objects
_wreck = [[ // The last object in the list gets returned.
	["Barrels",[-7.4511,3.8544],61.911976],
	["Misc_palletsfoiled",[4.062,4.7216],-29.273479],
	["Paleta2",[-3.4033,-2.2256],52.402905],
	["Land_Pneu",[1.17,1.249],-117.27345],
	["Land_transport_crates_EP1",[3.9029,-1.8477],-70.372086],
	["Fort_Crate_wood",[-2.1181,5.9765],-28.122475],
	if (DZMSEpoch) then {["C130J",[-8.8681,15.3554],-30]} else {["C130J_wreck_EP1",[-8.8681,15.3554,-.55],149.834555]}
],_coords,_mission] call DZMSSpawnObjects;

if (typeOf _wreck == "C130J") then {
	_wreck setVehicleLock "LOCKED";
	_wreck animate ["ramp_top",1];
	_wreck animate ["ramp_bottom",1];
};

//We create the mission vehicles
[_mission,_coords,DZMSSmallVic,[14.1426,-0.6202]] call DZMSSpawnVeh;
[_mission,_coords,DZMSSmallVic,[-6.541,-11.5557]] call DZMSSpawnVeh;

//DZMSBoxFill fills the box, DZMSProtectObj prevents it from disappearing
[_mission,_coords,"USVehicleBox","supply",[-1.5547,2.3486]] call DZMSSpawnCrate;
[_mission,_coords,"USBasicWeaponsBox","supply2",[0.3428,-1.8985]] call DZMSSpawnCrate;

//DZMSAISpawn spawns AI to the mission.
//Usage: [_coords, count, skillLevel, Hero or Bandit, Mission Number]
[[(_coords select 0) - 10.5005,(_coords select 1) - 2.6465,0],6,0,_aiType,_mission] call DZMSAISpawn;
[[(_coords select 0) + 4.7027,(_coords select 1) + 12.2138,0],6,1,_aiType,_mission] call DZMSAISpawn;
[[(_coords select 0) + 2.918,(_coords select 1) - 9.0342,0],4,2,_aiType,_mission] call DZMSAISpawn;
[[(_coords select 0) + 2.918,(_coords select 1) - 9.0342,0],4,3,_aiType,_mission] call DZMSAISpawn;

// Spawn Static M2 Gunner positions if enabled.
if (DZMSM2Static) then {
	[[
		[(_coords select 0) - 28.4,(_coords select 1) + 6, 0],
		[(_coords select 0) + 8.9,(_coords select 1) + 27.43, 0]
	],0,_aiType,_mission] call DZMSM2Spawn;
};

// Start the mission loop.
[
	_mission,
	_coords,
	_aiType,
	_name,
	[_aiType,"STR_CL_DZMS_C130_TITLE","STR_CL_DZMS_C130_WIN"],
	[_aiType,"STR_CL_DZMS_C130_TITLE","STR_CL_DZMS_C130_FAIL"]
] spawn DZMSWaitMissionComp;

// Send the start message
[_aiType,"STR_CL_DZMS_C130_TITLE","STR_CL_DZMS_C130_START"] call DZMSMessage;