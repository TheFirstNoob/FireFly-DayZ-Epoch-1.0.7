// This is a modified version of the DayZ Epoch file fn_spawnObjects.sqf used to spawn WAI mission objects.

local _objects = _this select 0;
local _pos = _this select 1;
local _mission = _this select 2;
local _object = objNull;
local _list = [];

local _fires = [
	"Base_Fire_DZ",
	"flamable_DZ",
	"Land_Camp_Fire_DZ",
	"Land_Campfire",
	"Land_Campfire_burning",
	"Land_Fire",
	"Land_Fire_burning",
	"Land_Fire_DZ",
	"Land_Fire_barrel",
	"Land_Fire_barrel_burning",
	"Misc_TyreHeap"
];

// Override god mode on these objects so they can be destroyed if WAI_GodModeObj enabled.
local _destructables = [
	"Gold_Vein_DZE",
	"Iron_Vein_DZE",
	"Silver_Vein_DZE",
	"Supply_Crate_DZE"
];

// Mission objects that need to be locked so players can't access them.
local _locked = [
	"MQ9PredatorB"
];

{
	local _type = _x select 0;
	local _offset = _x select 1;
	local _position = [(_pos select 0) + (_offset select 0), (_pos select 1) + (_offset select 1), 0];
	
	if (count _offset > 2) then {
		_position set [2, (_offset select 2)];
	};
	
	_object = _type createVehicle [0,0,0];
	
	if (_type in _locked) then {
		_object setVehicleLock "LOCKED";
	};
	
	if (count _x > 2) then {
		_object setDir (_x select 2);
	};
	
	_object setPos _position;
	_object setVectorUp surfaceNormal position _object;
	
	if (WAI_GodModeObj) then {
		if !(_type in _destructables) then {
			_object addEventHandler ["HandleDamage",{0}];
			if !(_type in _fires) then {_object enableSimulation false;};
		};
	};
	
	_list set [count _list, _object];
	((WAI_MissionData select _mission) select 5) set [count ((WAI_MissionData select _mission) select 5), _object];
} forEach _objects;

_list
