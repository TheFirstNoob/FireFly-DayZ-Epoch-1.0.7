if (!WAI_EnableParadrops) exitWith {};

local _position = _this select 0;
local _triggerdis = _this select 1;
local _heliClass = _this select 2;
local _heliStartDir = _this select 3;
local _distance = _this select 4;
local _flyinheight = _this select 5;
local _timebtwdrops = _this select 6;
local _starttodrop = _this select 7;
local _paranumber = _this select 8;
local _skill = _this select 9;
local _gun = _this select 10;
local _launcher = _this select 11;
local _backpack = _this select 12;
local _skin = _this select 13;
local _gear = _this select 14;
local _aitype = _this select 15;
local _helipatrol = _this select 16;
local _mission = _this select 17;
local _missionrunning = true;
local _playerPresent = false;
local _hero = _aitype == "Hero";
local _bandit = _aitype == "Bandit";
local _pack = _backpack;

if (WAI_DebugMode) then {diag_log "WAI: Paradrop waiting for player";};

// Wait until a player is within the trigger distance or mission times out.
while {!_playerPresent && _missionrunning} do {
	_playerPresent = [_position,_triggerdis] call isNearPlayer;
	_missionrunning = (typeName (WAI_MissionData select _mission) == "ARRAY");
	uiSleep 5;
};

if (!_missionrunning) exitWith {
	if (WAI_DebugMode) then {diag_log format["WAI: Mission at %1 already ended, aborting para drop",_position];};
};

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

if (typeName _aiskin == "ARRAY") then {
	_aiskin = _aiskin call BIS_fnc_selectRandom;
};

if (WAI_DebugMode) then {diag_log format ["WAI: Spawning a %1 with %2 units to be para dropped at %3",_heliClass,_paranumber,_position];};

local _unitGroup = [createGroup EAST, createGroup RESISTANCE] select _hero;

local _pilot = _unitGroup createUnit [_aiskin,[0,0,0],[],1,"NONE"];
[_pilot] joinSilent _unitGroup;

// This random number is used to start the helicopter a random distance from the mission
local _rndnum = (random ((_distance select 1) - (_distance select 0)) + (_distance select 0));

local _heliPos = call {
	if (_heliStartDir == "North") exitWith {[(_position select 0),(_position select 1) + _rndnum,100];};
	if (_heliStartDir == "South") exitWith {[(_position select 0),(_position select 1) - _rndnum,100];};
	if (_heliStartDir == "East") exitWith {[(_position select 0) + _rndnum,(_position select 1),100];};
	if (_heliStartDir == "West") exitWith {[(_position select 0) - _rndnum,(_position select 1),100];};
};

local _helicopter = createVehicle [_heliClass, _heliPos, [], 0, "FLY"];
local _startPos = position _helicopter;
local _turrets = _heliClass call WAI_GetTurrets;

dayz_serverObjectMonitor set [count dayz_serverObjectMonitor,_helicopter];

if (WAI_DebugMode) then {
	local _diag_distance = _helicopter distance _position;
	diag_log format["WAI: the Paratrooper Drop has started %1 from the mission",_diag_distance];
};

_helicopter flyInHeight _flyinheight;
_helicopter addEventHandler ["GetOut",{(_this select 0) setDamage 1;}];

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
	_gunner2 = _unitGroup createUnit [_aiskin,[0,0,0],[],1,"NONE"];
	//_gunner2 assignAsGunner _helicopter; -  Not necessary. Used with orderGetIn command
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
} forEach (units _unitgroup);

((WAI_MissionData select _mission) select 1) set [count ((WAI_MissionData select _mission) select 1), _unitGroup];
((WAI_MissionData select _mission) select 3) set [count ((WAI_MissionData select _mission) select 3), _helicopter];

_unitGroup allowFleeing 0;
_unitGroup setBehaviour "CARELESS";
_unitGroup setCombatMode "BLUE";
_unitGroup setVariable ["DoNotFreeze", true];

// Add waypoints to the chopper group.
local _wp = _unitGroup addWaypoint [[(_position select 0), (_position select 1)], 0];
_wp setWaypointType "MOVE";
_wp setWaypointCompletionRadius 100;

local _drop = true;
local _weapon = "";
local _unarmed = false;
local _para = objNull;

while {(alive _helicopter) && _drop} do {
	uiSleep 1;
	_heliPos = getPos _helicopter;

	if (_heliPos distance [(_position select 0),(_position select 1),100] <= _starttodrop) then {
	
		local _pgroup = [createGroup EAST, createGroup RESISTANCE] select _hero;
		
		if (typeName (WAI_MissionData select _mission) == "ARRAY") then {
			((WAI_MissionData select _mission) select 1) set [count ((WAI_MissionData select _mission) select 1), _pgroup];
		};

		for "_x" from 1 to _paranumber do {

			_heliPos = getPos _helicopter;

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

			_para = _pgroup createUnit [_aiskin,[0,0,0],[],1,"FORM"];
			
			removeAllWeapons _para;
			removeAllItems _para;
			
			call {
				if (typeName _gun == "ARRAY") then {
					_weapon = _gun call BIS_fnc_selectRandom;
				} else {
					if (_gun == "random") exitWith {_weapon = WAI_RandomWeapon call BIS_fnc_selectRandom;};
					if (_gun == "unarmed") exitWith {_unarmed = true;};
					_weapon = _gun;
				};
			};

			if (!_unarmed) then {
				if (typeName _weapon == "ARRAY") then {
					_weapon = _weapon select (floor (random (count _weapon)));
				};
				
				if !(isClass (configFile >> "CfgWeapons" >> _weapon)) then {
					diag_log text format ["WAI Error: Weapon classname (%1) is not valid!",_weapon];
					_weapon = "M16A2_DZ"; // Replace with known good classname.
				};
				
				local _magazine = _weapon call WAI_FindAmmo;
				local _mags = (round (random((WAI_AIMags select 1) - (WAI_AIMags select 0))) + (WAI_AIMags select 0));
				for "_i" from 1 to _mags do {
					_para addMagazine _magazine;
				};
				_para addWeapon _weapon;
				_para selectWeapon _weapon;
				
				// New for 1.0.7 - Hero and bandit dog tags that can be traded for +/- humanity.
				if (_hero) then {
					if (random 1 <= WAI_HeroDogtagChance) then {
						_para addMagazine "ItemDogTagHero";
					};
				};
				if (_bandit) then {
					if (random 1 <= WAI_BanditDogtagChance) then {
						_para addMagazine "ItemDogTagBandit";
					};
				};
				
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
						_para addMagazine (WAI_Food call BIS_fnc_selectRandom);
					};
					
					for "_i" from 1 to (_aigear select 1) do {
						_para addMagazine (WAI_Drink call BIS_fnc_selectRandom);
					};
					
					for "_i" from 1 to (_aigear select 2) do {
						_para addMagazine (WAI_Medical call BIS_fnc_selectRandom);
					};
					
					local _tools = []; // tools cannot be duplicated in inventory so we add them to a temp array when selected
					local _i = 0;
					while {_i < (_aigear select 3)} do {
						local _tool = WAI_ToolsAll call BIS_fnc_selectRandom;
						if !(_tool in _tools) then {
							_para addWeapon _tool;
							_tools set [count _tools, _tool];
							_i = _i + 1;
						};
					};
					
					if (random 1 <= (_aigear select 4)) then {
						_para addMagazine "ItemDocument";
					};
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
			
			if (typeName _pack == "ARRAY") then {
				_pack = _pack call BIS_fnc_selectRandom;
			};
			
			if (_pack != "") then {
				_para addBackpack _pack;
			};
	
			if (sunOrMoon != 1 && {!("NVGoggles" in (weapons _unit))} && {!("NVGoggles_DZE" in (weapons _unit))}) then {
				_para addWeapon "NVGoggles";
			};
			
			{
				_para setSkill [(_x select 0),(_x select 1)]
			} count _aicskill;
			
			_para addEventHandler ["Killed",{[_this select 0, _this select 1] call WAI_Onkill;}];
			local _chute = createVehicle ["ParachuteWest", _heliPos, [], 0, "NONE"];
			_para moveInDriver _chute;
			[_para] joinSilent _pgroup;
			
			// Adjusting this number changes the spread of the AI para drops
			uiSleep _timebtwdrops;
			
			_para setVariable ["mission" + dayz_serverKey, _mission, false];
			if (typeName (WAI_MissionData select _mission) == "ARRAY") then {
				WAI_MissionData select _mission set [0, (((WAI_MissionData select _mission) select 0) + 1)];
			};
		};
		
		if (_launcher != "" && WAI_UseLaunchers) then {
			_launcher = call {
				if (_launcher == "AT") exitWith {WAI_LaunchersAT call BIS_fnc_selectRandom;};
				if (_launcher == "AA") exitWith {WAI_LaunchersAA call BIS_fnc_selectRandom;};
				"M136";
			};
			local _rocket = _launcher call WAI_FindAmmo;
			_para addMagazine _rocket;
			_para addMagazine _rocket;
			_para addWeapon _launcher;
		};

		if (_hero) then {{_x setVariable ["Hero",true,false];  _x setVariable ["humanity", WAI_RemoveHumanity];} count (units _pgroup);};
		if (_bandit) then {{_x setVariable ["Bandit",true,false]; _x setVariable ["humanity", WAI_AddHumanity];} count (units _pgroup);};
		
		_drop = false;
		_pgroup selectLeader ((units _pgroup) select 0);

		if (WAI_DebugMode) then {diag_log format ["WAI: Spawned in %1 units for paradrop",_paranumber];};

		[_pgroup,_position,_skill] call WAI_SetWaypoints;
		
		if(_hero) then {
			_pgroup setCombatMode WAI_HeroCombatmode;
			_pgroup setBehaviour WAI_HeroBehaviour;
		} else {
			_pgroup setCombatMode WAI_BanditCombatMode;
			_pgroup setBehaviour WAI_BanditBehaviour;
		};
	};
};

if (_helipatrol) then {
	
	// Experimental below
	local _wp_rad = 500;
	local _pos_x = _position select 0;
	local _pos_y = _position select 1;
	_unitGroup setBehaviour "AWARE";
	_unitGroup setCombatMode "RED";
	
	{
		_wp = _unitGroup addWaypoint [_x,0];
		_wp setWaypointType "SAD";
		_wp setWaypointCompletionRadius 100;

	} count [[_pos_x,(_pos_y+_wp_rad),0],[_pos_x,(_pos_y-_wp_rad),0],[(_pos_x-_wp_rad),_pos_y,0],[(_pos_x+_wp_rad),_pos_y,0]];
	/*
	local _wp1 = _unitGroup addWaypoint [[(_position select 0),(_position select 1)], 100];
	_wp1 setWaypointType "SAD";
	_wp1 setWaypointCompletionRadius 150;
	_unitGroup setBehaviour "AWARE";
	_unitGroup setSpeedMode "FULL";
	*/
	
	{
		_x addEventHandler ["Killed",{[_this select 0, _this select 1] call WAI_Onkill;}];
	} forEach (units _unitgroup);
} else {
	{
		_x doMove [(_startPos select 0), (_startPos select 1), 100]
	} count (units _unitGroup);
	
	_cleanheli = true;
	while {_cleanheli} do {
		uiSleep 5;
		if (((getPos _helicopter) distance [(_startPos select 0),(_startPos select 1),100] <= 2000) || (!alive _helicopter)) then {
			deleteVehicle _helicopter;
			{
				deleteVehicle _x;
			} count (units _unitgroup);
			uiSleep 10;
			deleteGroup _unitGroup;
			if (WAI_DebugMode) then { diag_log "WAI: Paradrop helicopter cleaned"; };
			_cleanheli = false;
		};

	};
	
};
