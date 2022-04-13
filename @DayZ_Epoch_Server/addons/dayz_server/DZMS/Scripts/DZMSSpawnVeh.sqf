local _mission = _this select 0;
local _coords = _this select 1;
local _type = _this select 2;
local _offset = _this select 3;

if (typeName _type == "ARRAY") then {
	_type = _type call BIS_fnc_selectRandom;
};

local _position = [(_coords select 0) + (_offset select 0),(_coords select 1) + (_offset select 1),0];

if ((count _offset) > 2) then {
	_position set [2, (_this select 2)];
};

local _veh = _type createVehicle _position;

if (count _this > 4) then {
	_veh setDir (_this select 4);
} else {
	_veh setDir (round(random 360));
};
_veh setPos _position;
_veh setVariable ["CharacterID","1",true];
_veh setVariable ["ObjectID","1", true];
_veh setVariable ["DZMSCleanup" + dayz_serverKey,true,false];
dayz_serverObjectMonitor set [count dayz_serverObjectMonitor, _veh];
clearWeaponCargoGlobal _veh;
clearMagazineCargoGlobal _veh;
_veh setVehicleLock "locked";
local _ranFuel = random 1;
if (_ranFuel < .1) then {_ranFuel = .1;};

if (getNumber(configFile >> "CfgVehicles" >> _type >> "isBicycle") != 1) then {
	local _hitpoints = _veh call vehicle_getHitpoints;
	{
		local _selection = getText(configFile >> "cfgVehicles" >> _type >> "HitPoints" >> _x >> "name");
		local _strH = "hit_" + (_selection);
		_veh setHit[_selection,0];
		_veh setVariable [_strH,0,true];
	} count _hitpoints;

	_veh setFuel _ranFuel;
};

if (DZMSVehDamageOff) then {
	_veh addEventHandler ["HandleDamage",{false}];
} else {
	_veh addEventHandler ["HandleDamage",{_this call fnc_veh_handleDam}];
};

((DZMSMissionData select _mission) select 2) set [count ((DZMSMissionData select _mission) select 2), _veh];

// Set "GetIn" event handlers
if (DZMSSaveVehicles) then {
	if (DZMSEpoch) then {
		_veh addEventHandler ["GetIn", {
			local _veh = _this select 0;
			local _class = typeOf _veh;
			local _worldspace = [getDir _veh, getPosATL _veh];
			_veh setVariable["DZMSCleanup" + dayz_serverKey, nil];
			local _uid = _worldspace call dayz_objectUID2;
			format ["CHILD:308:%1:%2:%3:%4:%5:%6:%7:%8:%9:", dayZ_instance, _class, 0, (_veh getVariable ["CharacterID", "0"]), _worldspace, [getWeaponCargo _veh,getMagazineCargo _veh,getBackpackCargo _veh], [], (fuel _veh), _uid] call server_hiveWrite;
			local _result = (format["CHILD:388:%1:", _uid]) call server_hiveReadWrite;
			
			if ((_result select 0) != "PASS") then {
				deleteVehicle _veh;
				diag_log  format ["DZMS PublishVeh Error: failed to get id for %1 : UID %2.",_class, _uid];
			} else {
				_veh setVariable ["ObjectID", (_result select 1), true];
				_veh setVariable ["lastUpdate",diag_tickTime];
				_veh call fnc_veh_ResetEH;
				PVDZE_veh_Init = _veh;
				publicVariable "PVDZE_veh_Init";

				if (DZMSDebug) then {diag_log ("DZMS PublishVeh: Created " + (_class) + " with ID " + str(_uid));};
				
				// Send message to player
				if (DZMSMakeVehKey) then {
					RemoteMessage = ["rollingMessages","STR_CL_DZMS_VEH1"];
					(owner (_this select 2)) publicVariableClient "RemoteMessage";
				} else {
					RemoteMessage = ["rollingMessages","STR_CL_DZMS_VEH2"];
					(owner (_this select 2)) publicVariableClient "RemoteMessage";
				};
			};
		}];
	} else {
		// DayZ Vanilla Mod
		_veh addEventHandler ["GetIn", {
			local _veh = _this select 0;
			_veh setVariable["DZMSCleanup" + dayz_serverKey, nil];
			_veh removeAllEventHandlers "HandleDamage";
			_veh addEventHandler ["HandleDamage",{_this call fnc_veh_handleDam}];
			RemoteMessage = ["rollingMessages","STR_CL_DZMS_VEH3"];
			(owner (_this select 2)) publicVariableClient "RemoteMessage";
		}];
		
		// Save the vehicle when the player gets out
		_veh addEventHandler ["GetOut", {
			local _veh = _this select 0;
			local _worldspace = [getDir _veh, getPosATL _veh];
			local _objectUID = _worldspace call dayz_objectUID2;
			_object setVariable ["ObjectUID",_objectUID,true];
			
			if !((([_veh] call fnc_getPos) select 2) > 2) then { // Prevent helicopters from saving if the player bails out during flight.
				format ["CHILD:308:%1:%2:%3:%4:%5:%6:%7:%8:%9:", dayZ_instance, typeOf _veh, 0, 0, _worldspace, [[[],[]],[[],[]],[[],[]]], [], fuel _veh, _objectUID] call server_hiveWrite;
				RemoteMessage = ["rollingMessages","STR_CL_DZMS_VEH4"];
				(owner (_this select 2)) publicVariableClient "RemoteMessage";
			};
				
			_veh call fnc_veh_ResetEH; // No PV for this in Vanilla Mod, so I made one to get the repair feature to work before restart.
			PVCDZ_veh_Init = _veh;
			publicVariable "PVCDZ_veh_Init";
		}];
	};
} else {
	_veh addEventHandler ["GetIn",{
		local _veh = _this select 0;
		RemoteMessage = ["rollingMessages","STR_CL_DZMS_VEH5"];
		(owner (_this select 2)) publicVariableClient "RemoteMessage";
		if !(_veh getVariable ["DZMSCleanup" + dayz_serverKey, true]) exitWith {}; // Check to prevent handlers from resetting every time the player exits and re-enters the vehicle.
		_veh setVariable["DZMSCleanup" + dayz_serverKey, false];
		
		if (DZMSEpoch) then {
			PVDZE_veh_Init = _veh;
			publicVariable "PVDZE_veh_Init";
		} else {
			_veh removeAllEventHandlers "HandleDamage";
			_veh addEventHandler ["HandleDamage",{_this call fnc_veh_handleDam}];
			PVCDZ_veh_Init = _veh;
			publicVariable "PVCDZ_veh_Init";
		};
	}];
};

_veh