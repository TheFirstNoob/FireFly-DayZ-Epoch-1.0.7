/*
	DayZ Mission System Functions by Vampire
	Updated for DZMS 2.0 by JasonTM
*/

DZMSSpawnCrate = {
	private ["_mission","_cratePos","_boxType","_lootType","_offset","_cratePosition","_crate"];

	_mission = _this select 0;
	_cratePos = _this select 1;
	_boxType = _this select 2;
	_lootType = _this select 3;
	_offset = _this select 4;
	
	_cratePosition = [(_cratePos select 0) + (_offset select 0), (_cratePos select 1) + (_offset select 1), 0];
	
	if (count _offset > 2) then {
		_cratePosition set [2, (_offset select 2)];
	};
	
	// Override regular crates because of Vanilla blacklisting
	if (!DZMSEpoch) then {
		if !(_boxType in ["DZ_AmmoBoxUS","DZ_AmmoBoxRU","DZ_MedBox"]) then {
			_boxType = "AmmoBoxBig";
		};
	};
	
	_crate = _boxType createVehicle _cratePosition;
		
	if (count _this > 5) then {
		_crate setDir (_this select 5);
	};
	
	_crate setPos _cratePosition;
	_crate setVariable ["permaLoot",true];
	clearWeaponCargoGlobal _crate;
	clearMagazineCargoGlobal _crate;
	_crate addEventHandler ["HandleDamage", {0}];
	_crate enableSimulation false;
	((DZMSMissionData select _mission) select 3) set [count ((DZMSMissionData select _mission) select 3), [_crate,_lootType]];
	_crate // return crate object for AN2 mission
};

DZMSNearPlayer = {
	private["_result","_position","_radius"];

	_result 	= false;
	_position 	= _this select 0;
	_radius 	= _this select 1;

	{
		if ((isPlayer _x) && (_x distance _position <= _radius)) then {
			_result = true;
		};
	} count playableUnits;

	_result
};

DZMSCleanupThread = {
	private ["_staticGuns","_groups","_mission","_coords","_objects","_vehicles","_cleaned","_time","_crates","_time0ut"];
	
	_coords = _this select 0;
	_mission = _this select 1;
	_objects = _this select 2;
	_vehicles = _this select 3;
	_crates = _this select 4;
	_groups = _this select 5;
	_staticGuns = _this select 6;
	_time0ut = _this select 7;
	_cleaned = false;
	_time = diag_tickTime;
	
	while {!_cleaned} do {
		
		if (DZMSSceneryDespawnTimer > 0 || _time0ut) then {
			if ((diag_tickTime - _time) > DZMSSceneryDespawnTimer*60 || _time0ut) then {
				
				// delete mission objects
				if (count _objects > 0) then {
					{
						_x call sched_co_deleteVehicle;
					} count _objects;
				};
				
				// delete vehicles if they are not claimed
				if (count _vehicles > 0) then {
					{
						if (_x getVariable ["DZMSCleanup" + dayz_serverKey,false]) then {
							_x call sched_co_deleteVehicle;
						};
					
					} count _vehicles;
				};
				
				// Delete Remaining AI that are alive
				{
					if ((_x getVariable ["DZMSAI" + dayz_serverKey,nil]) select 0 == _mission) then {
						_x call sched_co_deleteVehicle;
					};
				} count allunits;
				
				// Delete Static Guns
				if ((count _staticGuns) > 0) then {
					{
						_x call sched_co_deleteVehicle;
					} count _staticGuns;
				};
				
				uiSleep 10; // Need to sleep to let the group count get to zero
				
				// Remove AI groups if mission times out
					if (count _groups > 0) then {
						{
							if (count units _x == 0) then {
								deleteGroup _x;
								_groups = _groups - [_x];
								//diag_log format ["DZMS: Group %1 deleted.",_x];
								if (count _groups > 0) then {
									diag_log format ["DZMS: Group array %1",_groups];
								};
							};
						} count _groups;
					};
				
				// delete mission crates if enabled
				if (DZMSSceneryDespawnLoot || _time0ut) then {
					if (count _crates > 0) then {
						// Wait until players are at least 50 meters away
						if !([_coords,50] call DZMSNearPlayer) then {
							{
								(_x select 0) call sched_co_deleteVehicle;
							} count _crates;
							_cleaned = true;
						};
					};
				} else {
					_cleaned = true;
				};
			};
		};
	};
	diag_log format ["DZMS: Cleanup for mission %1 complete.",_mission];
};

// Generates the keys for mission vehicles - Epoch/Overpoch only
DZMSVehKey = {
	private ["_keyColor","_keyNumber","_vehicle","_keySelected","_characterID"];
	
	_vehicle = _this;
	
	_keyColor = DZE_keyColors call BIS_fnc_selectRandom;
	_keyNumber = (floor(random 2500)) + 1;
	_keySelected = format["ItemKey%1%2",_keyColor,_keyNumber];
	_isKeyOK = isClass(configFile >> "CfgWeapons" >> _keySelected);
	_characterID = str(getNumber(configFile >> "CfgWeapons" >> _keySelected >> "keyid"));
	
	if (_isKeyOK) then {
		_vehicle addWeaponCargoGlobal [_keySelected,1];
		_vehicle setVariable ["CharacterID",_characterID,true];	
	} else {
		_vehicle setVariable ["CharacterID","0",true];
		diag_log format["There was a problem generating a key for vehicle %1",_vehicle];
	};
};

DZMSMessage = {
	private ["_color","_title","_type","_message"];
	_type = _this select 0;
	_title = _this select 1;
	_message = _this select 2;
	
	call {
		if (DZMSAnnounceType == "Hint") exitWith {
			_color = if (_type == "Hero") then {"#0D00FF";} else {"#990000";}; // Blue and Red
			RemoteMessage = ["hintNoImage",[_title,_message],[_color,"1.75"]];
		};
		if (DZMSAnnounceType == "titleText") exitWith {
			RemoteMessage = ["titleText",_message];
		};
		if (DZMSAnnounceType == "rollingMessages") exitWith {
			RemoteMessage = ["rollingMessages",_message];
		};
		if (DZMSAnnounceType == "DynamicText") exitWith {
			_color = if (_type == "Hero") then {"#0D00FF";} else {"#990000";}; // Blue and Red
			_params = ["0.40","#FFFFFF","0.60",_color,0,-.35,10,0.5];
			RemoteMessage = ["dynamic_text", ["DZMS",_message],_params];
		};
	};
	publicVariable "RemoteMessage";
};

//------------------------------------------------------------------//
if (DZMSDebug) then {diag_log text format ["[DZMS]: Mission Functions Script Loaded!"];};
