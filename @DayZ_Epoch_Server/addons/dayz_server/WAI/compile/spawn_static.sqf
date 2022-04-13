if (!WAI_EnableStaticGuns) exitWith {};

local _position = _this select 0;
local _class = _this select 1;
local _skill = _this select 2;
local _skin = _this select 3;
local _aitype = _this select 4;
local _gun = _this select 5;
local _backpack = _this select 6;
local _gear = _this select 7;
local _mission = _this select 8;
local _hero = _aitype == "Hero";
local _bandit = _aitype == "Bandit";
local _unitGroup = [createGroup EAST, createGroup RESISTANCE] select _hero;
local _weapon = "";
local _unarmed = false;
local _pack = _backpack;

((WAI_MissionData select _mission) select 1) set [count ((WAI_MissionData select _mission) select 1), _unitGroup];

{
	local _aiskin = call {
		if (typeName _skin == "ARRAY") then {
			_skin call BIS_fnc_selectRandom;
		} else {
			if (_skin == "hero") exitWith {WAI_HeroSkin call BIS_fnc_selectRandom;};
			if (_skin == "bandit") exitWith {WAI_BanditSkin call BIS_fnc_selectRandom;};
			_skin;
		};
	};

	if (_class == "Random") then {_class = WAI_StaticWeapons call BIS_fnc_selectRandom;};

	local _unit = _unitGroup createUnit [_aiskin, [0,0,0], [], 10, "PRIVATE"];
	
	removeAllWeapons _unit;
	removeAllItems _unit;
	
	local _static = _class createVehicle _x;
	
	if (surfaceIsWater _x) then {
		_static setPosASL _x;
	} else {
		_static setPosATL _x;
	};
	
	[_unit] joinSilent _unitGroup;

	if (_hero) then {_unit setVariable ["Hero",true,false]; _unit setVariable ["humanity", WAI_RemoveHumanity];};
	if (_bandit) then {_unit setVariable ["Bandit",true,false]; _unit setVariable ["humanity", WAI_AddHumanity];};
	
	if (WAI_StaticUseWeapon) then {
	
		call {
			if (typeName _gun == "ARRAY") then {
				_weapon = _gun call BIS_fnc_selectRandom;
			} else {
				if (_gun == "Random") exitWith {_weapon = WAI_RandomWeapon call BIS_fnc_selectRandom;};
				if (_gun == "Unarmed") exitWith {_unarmed = true;};
				_weapon = _gun;
			};
		};
		
		if (!_unarmed) then {
			if (typeName _weapon == "ARRAY") then {
				_weapon = _weapon call BIS_fnc_selectRandom;
			};
			
			if !(isClass (configFile >> "CfgWeapons" >> _weapon)) then {
				diag_log text format ["WAI Error: Weapon classname (%1) is not valid!",_weapon];
				_weapon = "M16A2_DZ"; // Replace with known good classname.
			};
			
			local _magazine = _weapon call WAI_FindAmmo;
			local _mags = (round (random((WAI_AIMags select 1) - (WAI_AIMags select 0))) + (WAI_AIMags select 0));
			for "_i" from 1 to _mags do {
				_unit addMagazine _magazine;
			};
			_unit addWeapon _weapon;
			_unit selectWeapon _weapon;
			
			local _aigear = call {
				if (typeName _gear == "SCALAR") then {
					if (_gear == 0) exitWith {WAI_Gear0;};
					if (_gear == 1) exitWith {WAI_Gear1;};
					if (_gear == 2) exitWith {WAI_Gear2;};
					[];
				} else {
					if (_gear == "random") exitWith {WAI_GearRandom call BIS_fnc_selectRandom;};
					[];
				};
			};
	
			if (count _aigear > 0) then {		
				for "_i" from 1 to (_aigear select 0) do {
					_unit addMagazine (WAI_Food call BIS_fnc_selectRandom);
				};
				
				for "_i" from 1 to (_aigear select 1) do {
					_unit addMagazine (WAI_Drink call BIS_fnc_selectRandom);
				};
				
				for "_i" from 1 to (_aigear select 2) do {
					_unit addMagazine (WAI_Medical call BIS_fnc_selectRandom);
				};
				
				local _tools = []; // tools cannot be duplicated in inventory so we add them to a temp array when selected
				local _i = 0;
				while {_i < (_aigear select 3)} do {
					local _tool = WAI_ToolsAll call BIS_fnc_selectRandom;
					if !(_tool in _tools) then {
						_unit addWeapon _tool;
						_tools set [count _tools, _tool];
						_i = _i + 1;
					};
				};
				
				if (random 1 <= (_aigear select 4)) then {
					_unit addMagazine "ItemDocument";
				};
			};
			
			call {
				if (typeName _backpack == "ARRAY") then {
					_pack = _backpack call BIS_fnc_selectRandom;
				} else {
					if (_backpack == "random") exitWith {_pack = WAI_PacksAll call BIS_fnc_selectRandom;};
					if (_backpack == "none") exitWith {_pack = "";};
				};
			};
			
			if (_pack != "") then {
				_unit addBackpack _pack;
			};
		};
	};
	
	// New for 1.0.7 - Hero and bandit dog tags that can be traded for +/- humanity.
	if (_hero) then {
		if (random 1 <= WAI_HeroDogtagChance) then {
			_unit addMagazine "ItemDogTagHero";
		};
	};
	if (_bandit) then {
		if (random 1 <= WAI_BanditDogtagChance) then {
			_unit addMagazine "ItemDogTagBandit";
		};
	};
			
	if (WAI_StaticSkills) then {
		{
			_unit setSkill [(_x select 0),(_x select 1)]
		} count WAI_StaticSkillArray;
	} else {
		local _aicskill = call {
			if (_skill == "easy") exitWith {WAI_SkillEasy;};
			if (_skill == "medium") exitWith {WAI_SkillMedium;};
			if (_skill == "hard") exitWith {WAI_SkillHard;};
			if (_skill == "extreme") exitWith {WAI_SkillExtreme;};
			WAI_SkillRandom call BIS_fnc_selectRandom;
		};

		{
			_unit setSkill [(_x select 0),(_x select 1)]
		} count _aicskill;
	};
	
	_unit addEventHandler ["Killed",{[_this select 0, _this select 1] call WAI_Onkill;}];
	
	_static addEventHandler ["GetOut",{
		_unit = _this select 2;
		_static = _this select 0;
		if (alive _unit) then {_unit moveInGunner _static};
	}];
		
	dayz_serverObjectMonitor set [count dayz_serverObjectMonitor,_static];
		
	if (sunOrMoon != 1 && {!("NVGoggles" in (weapons _unit))} && {!("NVGoggles_DZE" in (weapons _unit))}) then {
		_unit addWeapon "NVGoggles";
	};
	
	_unit assignAsGunner _static;
	_unit moveInGunner _static;
	_unit setVariable ["noKey",true];

	WAI_MissionData select _mission set [0, (((WAI_MissionData select _mission) select 0) + 1)];
	((WAI_MissionData select _mission) select 3) set [count ((WAI_MissionData select _mission) select 3), _static];
	_static setVariable ["mission" + dayz_serverKey, _mission, false];
	_unit setVariable ["mission" + dayz_serverKey, _mission, false];

} forEach _position;

_unitGroup selectLeader ((units _unitGroup) select 0);
_unitGroup setVariable ["DoNotFreeze", true];

if(_hero) then {
	_unitGroup setCombatMode WAI_HeroCombatmode;
	_unitGroup setBehaviour WAI_HeroBehaviour;
} else {
	_unitGroup setCombatMode WAI_BanditCombatMode;
	_unitGroup setBehaviour WAI_BanditBehaviour;
};

if (WAI_DebugMode) then {diag_log format ["WAI: Spawned in %1 %2",(count _position),_class];};
