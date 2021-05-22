private["_staticGuns","_groups","_missionName","_playerNear","_text","_markerColor","_marker","_dot","_objects","_vehicles","_crates","_mission","_coords","_name","_msgwin","_msglose","_aiType","_numSpawned","_killReq","_complete","_startTime"];

_mission = _this select 0;
_coords = _this select 1;
_aiType = _this select 2;
_name = _this select 3;
_msgwin = _this select 4;
_msglose = _this select 5;
_complete = false;
_startTime = diag_tickTime;
_staticTime = diag_tickTime;

uiSleep 2; // This sleep is necessary to let the mission data array populate.

_numSpawned = (DZMSMissionData select _mission) select 0;
_objects = (DZMSMissionData select _mission) select 1;
_vehicles = (DZMSMissionData select _mission) select 2;
_crates = (DZMSMissionData select _mission) select 3;
_groups = (DZMSMissionData select _mission) select 4;
_staticGuns = (DZMSMissionData select _mission) select 5;
_killReq = _numSpawned - (DZMSRequiredKillPercent * _numSpawned);
_markerColor = if (_aiType == "Hero") then {"ColorBlue";} else {"ColorRed";};
_missionName = if (_aiType == "Hero") then {"Hero " + _name;} else {"Bandit " + _name;};

diag_log format["%1 spawned at %2",_missionName,_coords];

// Create initial markers
if (DZMSAICount) then {
	_text = format["%1 (%2 %3s)",_name,_numSpawned,_aiType];
} else {
	_text = _name;
};
_marker = createMarker ["DZMS" + _aiType + str(_mission), _coords];
_marker setMarkerColor _markerColor;
_marker setMarkerShape "ELLIPSE";
_marker setMarkerBrush "Grid";
_marker setMarkerAlpha 0.5;
_marker setMarkerSize [175,175];
_dot = createMarker ["DZMSDot" + _aiType + str(_mission), _coords];
_dot setMarkerColor "ColorBlack";
_dot setMarkerType "Vehicle";
_dot setMarkerText _text;

DZMSMarkerReady = true;

while {!_complete} do {
	
	_aiCount = (DZMSMissionData select _mission) select 0;
	
	// Refresh markers
	if (DZMSAICount) then {
		deleteMarker _marker;
		deleteMarker _dot;
		_text = format["%1 (%2 %3s)",_name,_aiCount,_aiType];
		_marker = createMarker ["DZMS" + _aiType + str(_mission), _coords];
		_marker setMarkerColor _markerColor;
		_marker setMarkerShape "ELLIPSE";
		_marker setMarkerBrush "Grid";
		_marker setMarkerAlpha 0.5;
		_marker setMarkerSize [175,175];
		_dot = createMarker ["DZMSDot" + _aiType + str(_mission), _coords];
		_dot setMarkerColor "ColorBlack";
		_dot setMarkerType "Vehicle";
		_dot setMarkerText format["%1 (%2 %3s)",_name,_aiCount,_aiType];;
	} else {
		// Only reset every 30 seconds if AI counter is disabled to reduce network traffic
		if (diag_tickTime - _startTime > 30) then {
			deleteMarker _marker;
			deleteMarker _dot;
			_marker = createMarker ["DZMS" + _aiType + str(_mission), _coords];
			_marker setMarkerColor _markerColor;
			_marker setMarkerShape "ELLIPSE";
			_marker setMarkerBrush "Grid";
			_marker setMarkerAlpha 0.5;
			_marker setMarkerSize [175,175];
			_dot = createMarker ["DZMSDot" + _aiType + str(_mission), _coords];
			_dot setMarkerColor "ColorBlack";
			_dot setMarkerType "Vehicle";
			_dot setMarkerText _name;
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
	DZMSMarkers = DZMSMarkers - [("DZMS" + _aiType + str(_mission))];
	DZMSMissionData set [_mission, -1];

diag_log text format["[DZMS]: %1 has Ended.",_missionName];
