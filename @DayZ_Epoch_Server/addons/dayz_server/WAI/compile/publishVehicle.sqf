local _class = _this select 0;
local _position = _this select 1;
local _mission = _this select 2;
local _max_distance = 17;
local _position_fixed = false;
local _dir = floor(round(random 360));
local _vehpos = _position;

if (typeName _class == "ARRAY") then {
	_class = _class call BIS_fnc_selectRandom;
};

if (count _this > 3) then {
	_position_fixed = _this select 3;
};

if (count _this > 4) then {
	_dir = _this select 4;
};

if (!_position_fixed) then {
	_vehpos = [0,0,0];
	while {count _vehpos > 2} do { 
		_vehpos = [_position,12,_max_distance,10,0,0.7,0] call BIS_fnc_findSafePos; // Works better
		//_vehpos = _position findEmptyPosition[20,_max_distance,_class]; 
		_max_distance = (_max_distance + 10);
	};
};

local _vehicle = _class createVehicle _vehpos;
_vehicle setDir _dir;
_vehicle setPos _vehpos;
//_vehicle setVectorUp surfaceNormal position _vehicle;
_vehicle setVariable ["ObjectID","1",true];
_vehicle setVariable ["CharacterID","1",true]; // Set character ID to non-zero number so players see the red "Vehicle Locked" message
_vehicle setVariable ["mission" + dayz_serverKey,_mission, false];
clearWeaponCargoGlobal _vehicle;
clearMagazineCargoGlobal _vehicle;
_vehicle setVehicleLock "locked";

((WAI_MissionData select _mission) select 4) set [count ((WAI_MissionData select _mission) select 4), _vehicle];

if (WAI_DebugMode) then {diag_log format["WAI: Spawned %1 at %2",_class,_vehpos];};

if (getNumber(configFile >> "CfgVehicles" >> _class >> "isBicycle") != 1) then {
	{
		local _dam = (random((WAI_VehDam select 1) - (WAI_VehDam select 0)) + (WAI_VehDam select 0)) / 100;
		local _selection = getText(configFile >> "cfgVehicles" >> _class >> "HitPoints" >> _x >> "name");
		if (_dam > 0.8) then {_dam = 0.8;};

		if(!(["glass", _selection] call fnc_inString) && {_dam > 0.1}) then {
			local _strH = "hit_" + (_selection);
			_vehicle setHit[_selection,_dam];
			_vehicle setVariable [_strH,_dam,true];
			if (WAI_DebugMode) then {diag_log format ["WAI: Calculated damage for %1 is %2", _selection, _dam];};
		};
	} count (_vehicle call vehicle_getHitpoints);
	
	local _fuel = (random((WAI_VehFuel select 1) - (WAI_VehFuel select 0)) + (WAI_VehFuel select 0)) / 100;
	_vehicle setFuel _fuel;
	if (WAI_DebugMode) then {diag_log format["WAI: Added %1 percent fuel to vehicle",_fuel];};
};

if (WAI_GodModeVeh) then {
	_vehicle addEventHandler ["HandleDamage",{0}];
} else {
	_vehicle addEventHandler ["HandleDamage",{_this call fnc_veh_handleDam}];
};

dayz_serverObjectMonitor set [count dayz_serverObjectMonitor,_vehicle];

if (WAI_KeepVeh) then {
	
	_vehicle addEventHandler ["GetIn", {
		if !(isPlayer (_this select 2)) exitWith {/*Needed for Patrol mission*/};
		local _vehicle = _this select 0;
		_vehicle setVariable ["mission" + dayz_serverKey, nil];
		local _class = typeOf _vehicle;
		local _worldspace = [getDir _vehicle, getPosATL _vehicle];
		local _uid = _worldspace call dayz_objectUID2;
		local _array = [];
		{
			local _hit = ([_vehicle,_x] call object_getHit) select 0; //Update for 1.0.7
			local _selection = getText (configFile >> "CfgVehicles" >> (typeOf _vehicle) >> "HitPoints" >> _x >> "name");
			if (_hit > 0) then {_array set [count _array,[_selection,_hit]]};
			if (WAI_DebugMode) then {diag_log format ["Section Part: %1, Dmg: %2",_selection,_hit];};
		} count (_vehicle call vehicle_getHitpoints);

		format ["CHILD:308:%1:%2:%3:%4:%5:%6:%7:%8:%9:", dayZ_instance, _class, damage _vehicle, _vehicle getVariable ["CharacterID", "0"], _worldspace, [getWeaponCargo _vehicle, getMagazineCargo _vehicle, getBackpackCargo _vehicle],_array,fuel _vehicle,_uid] call server_hiveWrite;
		local _key = format["CHILD:388:%1:",_uid];
		local _result = _key call server_hiveReadWrite;
		
		if ((_result select 0) != "PASS") then {
			deleteVehicle _vehicle;
			diag_log format ["WAI Publish Vehicle: failed to get id for %1: UID %2",_class, _uid];
		} else {
			_vehicle setVariable ["ObjectID", (_result select 1), true];
			_vehicle setVariable ["lastUpdate",diag_tickTime];
			_vehicle call fnc_veh_ResetEH;
			PVDZE_veh_Init = _vehicle;
			publicVariable "PVDZE_veh_Init";

			diag_log ("WAI Publish Vehicle: Created " + _class + " with ID " + str(_uid));
			
			if (WAI_VehMessage) then {
				[nil,(_this select 2),"loc",rTitleText,"This vehicle is saved to the database.","PLAIN",5] call RE;
			};
		};
	}];

} else {
	_vehicle addEventHandler ["GetIn", {
		if !(isPlayer (_this select 2)) exitWith {/*Needed for Patrol mission*/};
		local _vehicle = _this select 0;
		
		if (WAI_VehMessage) then {
			[nil,(_this select 2),"loc",rTitleText,"WARNING: This vehicle will be deleted at restart!","PLAIN",5] call RE;
		};
		
		local _check = _vehicle getVariable ("mission" + dayz_serverKey);
		if (isNil "_check") exitWith {};
		_vehicle setVariable ["mission" + dayz_serverKey, nil];
		_vehicle removeAllEventHandlers "HandleDamage";
		_vehicle addEventHandler ["HandleDamage",{_this call fnc_veh_handleDam}];
		//diag_log format ["WAI set HandleDamage EV for %1", (typeOf _vehicle)]; // For testing.
	}];
};

_vehicle
