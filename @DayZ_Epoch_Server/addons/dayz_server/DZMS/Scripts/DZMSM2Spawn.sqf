/*																		//
	DZMSM2Spawn.sqf by JasonTM
	Usage: [positions,,skillLevel,AI type,mission number] call DZMSM2Spawn;
		Position is the coordinates to spawn at [X,Y,Z]
		SkillLevel is the skill number defined in DZMSAIConfig.sqf
		AI type is either "Hero" or "Bandit" set in DZMSTimer.sqf
		Mission number is the count of the DZMSMissionData array (-1 because arrays are zero indexed) when the mission spawns
*/			

private ["_positions","_skill","_aiType","_mission","_unitGroup","_aiskin","_unit","_wepArray","_weapon","_magazine","_aigearArray","_aigear","_gearmagazines","_geartools","_aipack","_attachments","_attach","_aicskill","_static"];

_positions = _this select 0;
_skill = _this select 1;
_aiType = _this select 2;
if (count _this > 3) then {
	_mission = _this select 3;
};

//Create the unit group. We use east by default.
_unitGroup = createGroup east;

// Add the group to the mission data array
if !(isNil "_mission") then {
	((DZMSMissionData select _mission) select 4) set [count ((DZMSMissionData select _mission) select 4), _unitGroup];
};

{
	
	//Lets pick a skin from the array and assign as Hero or Bandit
	if (_aiType == "Bandit") then {
		_aiskin = DZMSBanditSkins call BIS_fnc_selectRandom;;
	} else {
		_aiskin = DZMSHeroSkins call BIS_fnc_selectRandom;
	};
	
	//Lets spawn the unit
	_unit = _unitGroup createUnit [_aiskin, [0,0,0], [], 10, "PRIVATE"];
	
	//Make him join the correct team
	[_unit] joinSilent _unitGroup;
	
	//Add the behavior
	_unit enableAI "TARGET";
	_unit enableAI "AUTOTARGET";
	_unit enableAI "MOVE";
	_unit enableAI "ANIM";
	_unit enableAI "FSM";
	_unit setCombatMode "YELLOW";
	_unit setBehaviour "COMBAT";
	
	//Remove the items he spawns with by default
	removeAllWeapons _unit;
	removeAllItems _unit;
	
	//Now we need to figure out their loadout, and assign it
	_wepArray = DZMSAIWeps call BIS_fnc_selectRandom;
	_weapon = _wepArray call BIS_fnc_selectRandom;
	_magazine = getArray (configFile >> "CfgWeapons" >> _weapon >> "magazines") select 0;
	
	//Get the gear array
	_aigearArray = [DZMSGear0,DZMSGear1,DZMSGear2,DZMSGear3,DZMSGear4];
	_aigear = _aigearArray call BIS_fnc_selectRandom;
	_gearmagazines = _aigear select 0;
	_geartools = _aigear select 1;
	
	// select a random backpack
	_aipack = DZMSPacks call BIS_fnc_selectRandom;

	//Lets add it to the Unit
	for "_i" from 1 to 3 do {
		_unit addMagazine _magazine;
	};
	_unit addWeapon _weapon;
	
	if (!DZMSOverwatch) then {
		_attachments = configFile >> "CfgWeapons" >> _weapon >> "Attachments";
		if (isClass _attachments && count _attachments > 0) then {
			_attach = configName (_attachments call BIS_fnc_selectRandom);
			if !(_attach == "Attachment_Tws") then { // blacklist thermal scope
				_unit addMagazine _attach;
			};
		};
	};
	
	_unit addBackpack _aipack;
	
	if (DZMSUseNVG) then {
		_unit addWeapon "NVGoggles";
	};
	
	{
		_unit addMagazine _x
	} forEach _gearmagazines;
	
	{
		_unit addWeapon _x
	} forEach _geartools;
	
	//Lets set the skills
	_aicskill = call {
		if (_skill == 0) exitWith {DZMSSkills0;};
		if (_skill == 1) exitWith {DZMSSkills1;};
		if (_skill == 2) exitWith {DZMSSkills2;};
		if (_skill == 3) exitWith {DZMSSkills3;};
		DZMSSkills1;
	};
	
	{
		_unit setSkill [(_x select 0),(_x select 1)]
	} forEach _aicskill;
	
	//Lets prepare the unit for cleanup
	_unit addEventHandler ["Killed",{ [(_this select 0), (_this select 1)] call DZMSAIKilled;}];
	if !(isNil "_mission") then {
		_unit setVariable ["DZMSAI" + dayz_serverKey, [_mission,_aiType]];
	} else {
		_unit setVariable ["DZMSAI" + dayz_serverKey, [-1,_aiType]];
	};
	
	_unit addEventHandler ["Killed",{[_this select 0, _this select 1] call on_kill;}];
	
	// Lets spawn the M2 Static Gun
	_static = "M2StaticMG" createVehicle _x;
	
	if (surfaceIsWater _x) then {
		_static setPosASL _x;
	} else {
		_static setPosATL _x;
	};
	
	dayz_serverObjectMonitor set [count dayz_serverObjectMonitor,_static];
	
	_unit moveInGunner _static;
	
	_static addEventHandler ["GetOut",{
		_unit = _this select 2;
		_static = _this select 0;
		if (alive _unit) then {_unit moveInGunner _static};
	}];
	
	if (!isNil "_mission") then {
		DZMSMissionData select _mission set [0, ((DZMSMissionData select _mission) select 0) + 1];
		((DZMSMissionData select _mission) select 5) set [count ((DZMSMissionData select _mission) select 5), _static];
	};
	
} forEach _positions;

//if (DZMSDebug) then {diag_log text format["[DZMS]: (%2) %1 AI Spawned.",count (units _unitGroup),_aiType];};