/*																		//
	DZMSAISpawn.sqf by Vampire
	Updated for DZMS 2.0 by JasonTM
	Usage: [position,unitcount,skillLevel,AI type,mission number] call DZMSAISpawn;
		Position is the coordinates to spawn at [X,Y,Z]
		UnitCount is the number of units to spawn
		SkillLevel is the skill number defined in DZMSAIConfig.sqf
		AI type is either "Hero" or "Bandit" set in DZMSTimer.sqf
		Mission number is the count of the DZMSMissionData array (-1 because arrays are zero indexed) when the mission spawns
*/																		//

local _position = _this select 0;
local _unitcount = _this select 1;
local _skill = _this select 2;
local _aiType = _this select 3;
local _mission = nil;
if (count _this > 4) then {
	_mission = _this select 4;
};

local _wpRadius = 10;
local _xpos = _position select 0;
local _ypos = _position select 1;
local _aiskin = "";
local _unitGroup = createGroup east;

// Add the group to the mission data array
if !(isNil "_mission") then {
	((DZMSMissionData select _mission) select 4) set [count ((DZMSMissionData select _mission) select 4), _unitGroup];
};

for "_x" from 1 to _unitcount do {
	
	//Lets pick a skin from the array and assign as Hero or Bandit
	if (_aiType == "Bandit") then {
		_aiskin = DZMSBanditSkins call BIS_fnc_selectRandom;;
	} else {
		_aiskin = DZMSHeroSkins call BIS_fnc_selectRandom;
	};
	
	//Lets spawn the unit
	local _unit = _unitGroup createUnit [_aiskin, _position, [], 10, "PRIVATE"];
	
	//Make him join the correct team
	[_unit] joinSilent _unitGroup;
	
	//Add the behavior
	_unit setCombatMode "YELLOW";
	_unit setBehaviour "COMBAT";
	
	//Remove the items he spawns with by default
	removeAllWeapons _unit;
	removeAllItems _unit;
	
	//Now we need to figure out their loadout, and assign it
	local _wepArray = DZMSAIWeps call BIS_fnc_selectRandom;
	local _weapon = _wepArray call BIS_fnc_selectRandom;
	local _magazine = getArray (configFile >> "CfgWeapons" >> _weapon >> "magazines") select 0;
	
	for "_i" from 1 to 3 do {
		_unit addMagazine _magazine;
	};
	
	_unit addBackpack (DZMSPacks call BIS_fnc_selectRandom);
	_unit addWeapon _weapon;
	_unit selectWeapon _weapon;
	
	if (!DZMSOverwatch) then {
		local _attachments = configFile >> "CfgWeapons" >> _weapon >> "Attachments";
		if (isClass _attachments && {count _attachments > 0}) then {
			local _attach = configName (_attachments call BIS_fnc_selectRandom);
			if (_attach == "Attachment_Tws") then {
				if (DZMS_AllowThermal) then {
					_unit addMagazine _attach;
				};
			} else {
				_unit addMagazine _attach;
			};
		};
	};
	
	if (DZMSUseNVG) then {
		_unit addWeapon "NVGoggles";
	};
	
	//Get the gear array
	local _aigear = [DZMSGear0,DZMSGear1,DZMSGear2,DZMSGear3,DZMSGear4] call BIS_fnc_selectRandom;
	
	{
		_unit addMagazine _x;
	} count (_aigear select 0);
	
	{
		_unit addWeapon _x;
	} count (_aigear select 1);
	
	//Lets give a launcher to odd numbered AI if enabled
	if (DZMSUseRPG) then {
		if !(_x mod 2 == 0) then { // check if AI number is divisible by 2.
			_unit addWeapon "RPG7V";
			_unit addMagazine "PG7V";
			_unit addMagazine "PG7V";
		};
	};
	
	// New for 1.0.7 - Hero and bandit dog tags that can be traded for +/- humanity.
	if (_aitype == "Hero") then {
		if (random 1 <= DZMS_HeroDogTag) then {
			_unit addMagazine "ItemDogTagHero";
		};
	} else {
		if (random 1 <= DZMS_BanditDogTag) then {
			_unit addMagazine "ItemDogTagBandit";
		};
	};
	
	//Lets set the skills
	local _aicskill = call {
		if (_skill == 0) exitWith {DZMSSkills0;};
		if (_skill == 1) exitWith {DZMSSkills1;};
		if (_skill == 2) exitWith {DZMSSkills2;};
		if (_skill == 3) exitWith {DZMSSkills3;};
		DZMSSkills1;
	};
	
	{
		_unit setSkill [(_x select 0),(_x select 1)]
	} count _aicskill;
	
	_unit addEventHandler ["Killed",{ [(_this select 0), (_this select 1)] call DZMSAIKilled;}];
	
	if !(isNil "_mission") then {
		_unit setVariable ["DZMSAI" + dayz_serverKey, [_mission,_aiType]];
		DZMSMissionData select _mission set [0, ((DZMSMissionData select _mission) select 0) + 1];
	} else {
		_unit setVariable ["DZMSAI" + dayz_serverKey, [-1,_aiType]];
	};
};

// These are 4 waypoints in a NorthSEW around the center
local _wppos1 = [_xpos, _ypos + 20, 0];
local _wppos2 = [_xpos + 20, _ypos, 0];
local _wppos3 = [_xpos, _ypos - 20, 0];
local _wppos4 = [_xpos - 20, _ypos, 0];

_unitGroup allowFleeing 0;

// We add the 4 waypoints
local _wp1 = _unitGroup addWaypoint [_wppos1, _wpRadius];
_wp1 setWaypointType "MOVE";
local _wp2 = _unitGroup addWaypoint [_wppos2, _wpRadius];
_wp2 setWaypointType "MOVE";
local _wp3 = _unitGroup addWaypoint [_wppos3, _wpRadius];
_wp3 setWaypointType "MOVE";
local _wp4 = _unitGroup addWaypoint [_wppos4, _wpRadius];
_wp4 setWaypointType "MOVE";

// Then we add a center waypoint that tells them to visit the rest
local _wpfin = _unitGroup addWaypoint [[_xpos,_ypos, 0], _wpRadius];
_wpfin setWaypointType "CYCLE";

if (DZMSDebug) then {diag_log text format["[DZMS]: (%2) %1 AI Spawned.",count (units _unitGroup),_aiType];};
