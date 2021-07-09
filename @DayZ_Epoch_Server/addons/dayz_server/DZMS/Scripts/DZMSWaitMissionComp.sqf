// Start mission monitoring thread

local _mission = _this select 0;
local _coords = _this select 1;
local _aiType = _this select 2;
local _name = _this select 3;
local _msgwin = _this select 4;
local _msglose = _this select 5;
local _complete = false;
local _startTime = diag_tickTime;
local _staticTime = diag_tickTime;

uiSleep 2; // This sleep is necessary to let the mission data array populate.

local _numSpawned = (DZMSMissionData select _mission) select 0;
local _objects = (DZMSMissionData select _mission) select 1;
local _vehicles = (DZMSMissionData select _mission) select 2;
local _crates = (DZMSMissionData select _mission) select 3;
local _groups = (DZMSMissionData select _mission) select 4;
local _staticGuns = (DZMSMissionData select _mission) select 5;
local _killReq = _numSpawned - (DZMSRequiredKillPercent * _numSpawned);
local _markerColor = if (_aiType == "Hero") then {"ColorBlue";} else {"ColorRed";};
local _missionName = if (_aiType == "Hero") then {"Hero " + _name;} else {"Bandit " + _name;};
local _aiCount = 0;
local _text = _name;
local _playerNear = false;
local _acMarker = "";
local _acdot = "";
local _closestPlayer = objNull;
local _acArray = [];
local _claimed = false;
local _acTime = diag_tickTime;
local _claimTime = 0;
local _left = false;
local _leftTime	= 0;
local _warnArray = [];

diag_log format["%1 spawned at %2",_missionName,_coords];

// Create initial markers
if (DZMSAICount) then {_text = format["%1 (%2 %3s)",_name,_numSpawned,_aiType];};
local _marker = createMarker ["DZMS" + _aiType + str(_mission), _coords];
_marker setMarkerColor _markerColor;
_marker setMarkerShape "ELLIPSE";
_marker setMarkerBrush "Grid";
_marker setMarkerAlpha 0.5;
_marker setMarkerSize [175,175];
local _dot = createMarker ["DZMSDot" + _aiType + str(_mission), _coords];
_dot setMarkerColor "ColorBlack";
_dot setMarkerType "Vehicle";
_dot setMarkerText _text;
if (DZMSAutoClaim) then {
	_acMarker = createMarker ["DZMS" + _aiType + str(_mission) + "auto", _coords];
	_acMarker setMarkerShape "ELLIPSE";
	_acMarker setMarkerBrush "Border";
	_acMarker setMarkerColor "ColorRed";
	_acMarker setMarkerSize [DZMSAutoClaimAlertDistance,DZMSAutoClaimAlertDistance];
};

DZMSMarkerReady = true;

while {!_complete} do {
	if (DZMSAutoClaim) then {
		#include "\z\addons\dayz_server\DZMS\Scripts\DZMSAutoClaim.sqf"	
	};
	
	_aiCount = (DZMSMissionData select _mission) select 0;
	deleteMarker _marker;
	deleteMarker _dot;
	if (!isNil "_acMarker") then {deleteMarker _acMarker;};
	if (!isNil "_acdot") then {deleteMarker _acdot;};
	if (DZMSAICount) then {_text = format["%1 (%2 %3s)",_name,_aiCount,_aiType];};
	_marker = createMarker ["DZMS" + _aiType + str(_mission), _coords];
	_marker setMarkerColor _markerColor;
	_marker setMarkerShape "ELLIPSE";
	_marker setMarkerBrush "Grid";
	_marker setMarkerAlpha 0.5;
	_marker setMarkerSize [200,200];
	_dot = createMarker ["DZMSDot" + _aiType + str(_mission), _coords];
	_dot setMarkerColor "ColorBlack";
	_dot setMarkerType "Vehicle";
	_dot setMarkerText _text;
	if (DZMSAutoClaim) then {
		_acMarker = createMarker ["DZMS" + _aiType + str(_mission) + "auto", _coords];
		_acMarker setMarkerShape "ELLIPSE";
		_acMarker setMarkerBrush "Border";
		_acMarker setMarkerColor "ColorRed";
		_acMarker setMarkerSize [DZMSAutoClaimAlertDistance,DZMSAutoClaimAlertDistance];
	
		if (_claimed) then {
			_acdot = createMarker ["DZMS" + str(_mission) + "autodot", [(_coords select 0) + 100, (_coords select 1) + 100]];
			_acdot setMarkerColor "ColorBlack";
			_acdot setMarkerType "mil_objective";
			if (_left) then {
				_acdot setMarkerText format["%1 Claim Timeout [%2]",(_acArray select 1),_leftTime];
			} else {
				_acdot setMarkerText format["Claimed by %1",(name _closestPlayer)];
			};
		};
	};
	
	// JIP player "invisible static gunner" glitch fix
	if ((count _staticGuns) > 0 && {(diag_tickTime - _staticTime) > 180}) then {
		{
			(gunner _x) action ["getout",_x];
		} count _staticGuns;
		_staticTime = diag_tickTime;
	};
	
	// Replenish the ammo in the static guns and check for dead gunner
	if ((count _staticGuns) > 0) then {
		{
			if (alive _x && ({alive _x} count crew _x > 0)) then {
				_x setVehicleAmmo 1;
			} else {
				_x setDamage 1;
			};
		} count _staticGuns;
	};

	// Check for completion
	if (_aiCount <= _killReq) then {
		if ([_coords,30] call DZMSNearPlayer) then {
			_complete = true;
			_msgwin call DZMSMessage;
			
			// Address mission vehicles
			if (count _vehicles > 0) then {
				{
					if (DZMSSaveVehicles && {DZMSMakeVehKey}) then {
						_x call DZMSVehKey;
					} else {
						_x setVariable ["CharacterID", "0", true];
					};
					_x setVehicleLock "unlocked";
				} count _vehicles;
			};
			
			// Spawn loot in the crates
			if (count _crates > 0) then {
				{
					[(_x select 0),(_x select 1)] call DZMSBoxSetup;
				} count _crates;
			};
			
			if (DZMSSceneryDespawnTimer > 0) then {
				[_coords,_mission,_objects,_vehicles,_crates,_groups,_staticGuns,false] spawn DZMSCleanupThread;
			};
		};
	};
	
	// Check for near players
	_playerNear = [_coords,800] call DZMSNearPlayer;
	
	// Timeout the mission if a player is not near
	if (diag_tickTime - _startTime > DZMSMissionTimeOut*60 && !_playerNear) then {
		_complete = true;
		[_coords,_mission,_objects,_vehicles,_crates,_groups,_staticGuns,true] spawn DZMSCleanupThread;
		_msglose call DZMSMessage;
	};
	
	// If player is within range of the mission reset the start timer.
	if (_playerNear) then {_startTime = diag_tickTime;};
	
	uiSleep 2;
};

//Let the timer know the mission is over
	if (_aiType == "Bandit") then {
		DZMSBanditEndTime = diag_tickTime;
		DZMSBanditRunning = DZMSBanditRunning - 1;
	} else {
		DZMSHeroEndTime = diag_tickTime;
		DZMSHeroRunning = DZMSHeroRunning - 1;
	};
	
	// Remove marker and mission data
	deleteMarker _marker;
	deleteMarker _dot;
	if (!isNil "_acMarker") then {deleteMarker _acMarker;};
	if (!isNil "_acdot") then {deleteMarker _acdot;};
	DZMSMarkers = DZMSMarkers - [("DZMS" + _aiType + str(_mission))];
	DZMSMissionData set [_mission, -1];

diag_log text format["[DZMS]: %1 has Ended.",_missionName];
