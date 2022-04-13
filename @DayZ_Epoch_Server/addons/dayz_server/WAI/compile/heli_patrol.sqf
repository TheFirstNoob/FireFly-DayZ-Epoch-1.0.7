local _position = _this select 0;
local _radius = _this select 1;
local _wpnum = _this select 2;
local _heliClass = _this select 3;
local _skill = _this select 4;
local _skin	= _this select 5;
local _aitype = _this select 6;
local _hero = _aitype == "Hero";
local _bandit = _aitype == "Bandit";
local _mission = _this select 7;
local _wp = [];

local _aicskill = call {
	if (_skill == "easy") exitWith {WAI_SkillEasy;};
	if (_skill == "medium") exitWith {WAI_SkillMedium;};
	if (_skill == "hard") exitWith {WAI_SkillHard;};
	if (_skill == "extreme") exitWith {WAI_SkillExtreme;};
	WAI_SkillRandom call BIS_fnc_selectRandom;
};

local _aiskin = call {
	if (typeName _skin == "ARRAY") then {
		_skin call BIS_fnc_selectRandom;
	} else {
		if (_skin == "Hero") exitWith {WAI_HeroSkin call BIS_fnc_selectRandom;};
		if (_skin == "Bandit") exitWith {WAI_BanditSkin call BIS_fnc_selectRandom;};
		if (_skin == "Random") exitWith {WAI_AllSkin call BIS_fnc_selectRandom;};
		_skin;
	};
};

if(typeName _aiskin == "ARRAY") then {
	_aiskin = _aiskin call BIS_fnc_selectRandom;
};

local _unitGroup = [createGroup EAST, createGroup RESISTANCE] select _hero;

local _pilot = _unitGroup createUnit [_aiskin, [0,0,0], [], 1, "NONE"];

[_pilot] joinSilent _unitGroup;

// This random number is used to start the helicopter from 3000 to 4000 meters from the mission.
local _rndnum = 3000 + round (random 1000);

local _helicopter = createVehicle [_heliClass,[(_position select 0) + _rndnum,(_position select 1),100],[],0,"FLY"];

if (WAI_DebugMode) then {
	diag_log format["WAI: the Heli Patrol has started %1 from the mission",(_helicopter distance _position)];
};
_helicopter setFuel 1;
_helicopter engineOn true;
_helicopter setVehicleAmmo 1;
_helicopter flyInHeight 150;
_helicopter lock true;
_helicopter addEventHandler ["GetOut",{(_this select 0) setDamage 1;}];
dayz_serverObjectMonitor set [count dayz_serverObjectMonitor,_helicopter];

local _turrets = _heliClass call WAI_GetTurrets;

_pilot assignAsDriver _helicopter;
_pilot moveInDriver _helicopter;

{
	_pilot setSkill [_x,1];
} count ["aimingAccuracy","aimingShake","aimingSpeed","endurance","spotDistance","spotTime","courage","reloadSpeed","commanding","general"];

local _gunner = objNull;
if (count _turrets > 0) then {
	local _gunner = _unitGroup createUnit [_aiskin, [0,0,0], [], 1, "NONE"];
	//_gunner assignAsGunner _helicopter;
	_gunner moveInTurret [_helicopter,(_turrets select 0)];
	[_gunner] joinSilent _unitGroup;
	{
		_gunner setSkill [(_x select 0),(_x select 1)];
	} count _aicskill;
};

local _gunner2 = objNull;
if (count _turrets > 1) then {
	_gunner2 = _unitGroup createUnit [_aiskin, [0,0,0], [], 1, "NONE"];
	//_gunner2 assignAsGunner _helicopter;
	_gunner2 moveInTurret [_helicopter,(_turrets select 1)];
	[_gunner2] joinSilent _unitGroup;
	{
		_gunner2 setSkill [(_x select 0),(_x select 1)];
	} count _aicskill;
};

{
	_x addWeapon "Makarov_DZ";
	_x addMagazine "8Rnd_9x18_Makarov";
	_x addMagazine "8Rnd_9x18_Makarov";
	if (_hero) then {_x setVariable ["Hero", true]; _x setVariable ["humanity", WAI_RemoveHumanity];};
	if (_bandit) then {_x setVariable ["Bandit", true]; _x setVariable ["humanity", WAI_AddHumanity];};
	_x addEventHandler ["Killed",{[_this select 0, _this select 1] call WAI_Onkill;}];
} forEach (units _unitgroup);

((WAI_MissionData select _mission) select 1) set [count ((WAI_MissionData select _mission) select 1), _unitGroup];
((WAI_MissionData select _mission) select 3) set [count ((WAI_MissionData select _mission) select 3), _helicopter];


_unitGroup allowFleeing 0;
_unitGroup setBehaviour "AWARE";
_unitGroup setCombatMode "RED";
_unitGroup setVariable ["DoNotFreeze", true];

if(_wpnum > 0) then {
	for "_i" from 1 to _wpnum do {
		_wp = _unitGroup addWaypoint [[(_position select 0),(_position select 1),0],_radius];
		_wp setWaypointType "MOVE";
		_wp setWaypointCompletionRadius 200;
	};
};

_wp = _unitGroup addWaypoint [[(_position select 0),(_position select 1),0],100];
_wp setWaypointType "CYCLE";
_wp setWaypointCompletionRadius 200;

_unitGroup
