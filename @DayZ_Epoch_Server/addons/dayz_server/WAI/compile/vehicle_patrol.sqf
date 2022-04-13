if (!WAI_EnablePatrols) exitWith {};
local _position	= _this select 0;
local _startingpos = _this select 1;
local _radius = _this select 2;
local _wpnum = _this select 3;
local _vehClass = _this select 4;
local _skill = _this select 5;
local _skin	= _this select 6;
local _aitype = _this select 7;
local _hero = _aitype == "Hero";
local _bandit = _aitype == "Bandit";
local _mission = _this select 8;
local _wp = [];

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

local _driver = _unitGroup createUnit [_aiskin, [0,0,0], [], 1, "NONE"];
[_driver] joinSilent _unitGroup;

local _vehicle = createVehicle [_vehClass, [(_startingpos select 0),(_startingpos select 1), 0], [], 0, "CAN_COLLIDE"];
_vehicle setFuel 1;
_vehicle engineOn true;
_vehicle setVehicleAmmo 1;
_vehicle allowCrewInImmobile true; 
_vehicle lock true;
local _turrets = _vehClass call WAI_GetTurrets;

_vehicle addEventHandler ["GetOut",{
	local _veh = _this select 0;
	local _role = _this select 1;
	local _unit = _this select 2;
	if (_role == "driver") then {_unit moveInDriver _veh;};
	if (_role == "commander") then {_unit moveInCommander _veh;};
	if (_role == "gunner") then {_unit moveInGunner _veh;};
}];

dayz_serverObjectMonitor set [count dayz_serverObjectMonitor,_vehicle];

//_driver assignAsDriver _vehicle;
_driver moveInDriver _vehicle;
_driver setSkill 1;

local _gunner = objNull;
if (count _turrets > 0) then {
	local _gunner = _unitGroup createUnit [_aiskin, [0,0,0], [], 1, "NONE"];
	//_gunner assignAsGunner _helicopter;
	_gunner moveInTurret [_vehicle,(_turrets select 0)];
	[_gunner] joinSilent _unitGroup;
	_gunner setSkill .5;
};

local _gunner2 = objNull;
if (count _turrets > 1) then {
	_gunner2 = _unitGroup createUnit [_aiskin, [0,0,0], [], 1, "NONE"];
	//_gunner2 assignAsCommander _vehicle;
	//_gunner2 moveInCommander _vehicle;
	_gunner2 moveInTurret [_vehicle,(_turrets select 1)];
	[_gunner2] joinSilent _unitGroup;
	_gunner2 setSkill .5;
	//[_driver, _gunner, _gunner2] orderGetIn true;
} else {
	//[_driver, _gunner] orderGetIn true;
};

{
	_x addWeapon "Makarov_DZ";
	_x addMagazine "8Rnd_9x18_Makarov";
	_x addMagazine "8Rnd_9x18_Makarov";
	_x addEventHandler ["Killed",{[_this select 0, _this select 1, "vehicle"] call WAI_Onkill;}];
	if (_hero) then {_x setVariable ["Hero",true,false]; _x setVariable ["humanity", WAI_RemoveHumanity];};
	if (_bandit) then {_x setVariable ["Bandit",true,false]; _x setVariable ["humanity", WAI_AddHumanity];};
	WAI_MissionData select _mission set [0, (((WAI_MissionData select _mission) select 0) + 1)];
	_x setVariable ["mission" + dayz_serverKey, _mission, false];
	_x setVariable ["noKey",true, false];
} forEach (units _unitgroup);

_vehicle setVariable ["mission" + dayz_serverKey, _mission, false];
((WAI_MissionData select _mission) select 1) set [count ((WAI_MissionData select _mission) select 1), _unitGroup];
((WAI_MissionData select _mission) select 3) set [count ((WAI_MissionData select _mission) select 3), _vehicle];

_unitGroup allowFleeing 0;
_unitGroup setCombatMode "RED";
_unitGroup setBehaviour "Combat";
_unitGroup setVariable ["DoNotFreeze", true];

if(_wpnum > 0) then {

	for "_x" from 1 to _wpnum do
	{		
		_wp = _unitGroup addWaypoint [[(_position select 0),(_position select 1),0],_radius];
		_wp setWaypointType "SAD";
		_wp setWaypointCompletionRadius 200;
	};

};

_wp = _unitGroup addWaypoint [[(_position select 0),(_position select 1),0],100];
_wp setWaypointType "CYCLE";
_wp setWaypointCompletionRadius 200;

_unitGroup

