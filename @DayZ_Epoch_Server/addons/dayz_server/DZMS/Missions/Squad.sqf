/*
	Bandit Hunting Party by lazyink (Full credit to TheSzerdi & TAW_Tonic for the code)
	Updated to new format by Vampire
	Updated for DZMS 2.0 by JasonTM
*/
private ["_name","_coords","_aiType","_mission"];

_mission = count DZMSMissionData -1;
_aiType = _this select 0;
_name = "Patrol Squad";
_coords = call DZMSFindPos;

//DZMSAISpawn spawns AI to the mission.
//Usage: [_coords, count, skillLevel, Hero or Bandit, Mission Number]
[_coords,4,1,_aiType,_mission] call DZMSAISpawn;
[_coords,4,1,_aiType,_mission] call DZMSAISpawn;

// Start the mission loop.
[
	_mission,
	_coords,
	_aiType,
	_name,
	[_aiType,"STR_CL_DZMS_PS_TITLE","STR_CL_DZMS_PS_WIN"],
	[_aiType,"STR_CL_DZMS_PS_TITLE","STR_CL_DZMS_PS_FAIL"]
] spawn DZMSWaitMissionComp;

// Send the start message
[_aiType,"STR_CL_DZMS_PS_TITLE","STR_CL_DZMS_PS_START"] call DZMSMessage;
