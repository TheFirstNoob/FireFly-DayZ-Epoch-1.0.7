/*
	AN-2 Bandit Supply Drop by Vampire
	Example Code by Halv
	Updated for DZMS 2.0 by JasonTM
*/
uiSleep 2;
private ["_aiCount","_marker","_dot","_missionName","_groups","_crates","_complete","_text","_mission","_aiType","_coords","_name","_plane","_aiGrp","_pilot","_wp","_wp_pos","_loop","_half","_newPos","_chute","_box","_dropDir","_wp2","_fallCount","_dropped"];

_mission = count DZMSMissionData -1;
_aiType = _this select 0;
_name = "AN2 Supply Drop";
_coords = call DZMSFindPos;

DZMSMarkerReady = true;

[_aiType,"STR_CL_DZMS_AN2_TITLE","STR_CL_DZMS_AN2_START"] call DZMSMessage;

//Lets get the AN2 Flying
_plane = createVehicle ["AN2_DZ", [0,0,500], [], 0, "FLY"];
dayz_serverObjectMonitor set [count dayz_serverObjectMonitor, _plane];
_plane engineOn true;
_plane flyInHeight 150;
_plane forceSpeed 175;

//Lets make AI for the plane and get them in it
_aiGrp = createGroup east;

_pilot = _aiGrp createUnit ["SurvivorW2_DZ",getPos _plane,[],0,"FORM"];
_pilot moveInDriver _plane;
_pilot assignAsDriver _plane;

_wp = _aiGrp addWaypoint [[(_coords select 0), (_coords select 1),150], 0];
_wp setWaypointType "MOVE";
_wp setWaypointBehaviour "CARELESS";
_wp_pos = waypointPosition [_aiGrp,1];

//DZMSAISpawn spawns AI to the mission.
//Usage: [_coords, count, skillLevel, Hero or Bandit, Mission Number]
[_coords,6,1,_aiType,_mission] call DZMSAISpawn;
[_coords,6,2,_aiType,_mission] call DZMSAISpawn;
[_coords,4,3,_aiType,_mission] call DZMSAISpawn;

uiSleep 2;

_numSpawned = (DZMSMissionData select _mission) select 0;
_groups = (DZMSMissionData select _mission) select 4;
_staticGuns = (DZMSMissionData select _mission) select 5;
_killReq = _numSpawned - (DZMSRequiredKillPercent * _numSpawned);
_markerColor = if (_aiType == "Hero") then {"ColorBlue";} else {"ColorRed";};
_missionName = if (_aiType == "Hero") then {"Hero " + _name;} else {"Bandit " + _name;};

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

_half = false;
_complete = false;
_startTime = diag_tickTime;
_crashed = true;
_dropped =  false;
_crates = [];
_text = "";

while {!_complete} do {

	_aiCount = (DZMSMissionData select _mission) select 0;
	
	if (!alive _plane) exitWith {

		deleteVehicle _pilot;

		[_coords,_mission,[],[],[],_groups,_staticGuns,true] spawn DZMSCleanupThread;
		[_aiType,"STR_CL_DZMS_AN2_TITLE","STR_CL_DZMS_AN2_DEST"] call DZMSMessage;
	};
	
	if ((_plane distance _wp_pos) <= 1200 && !_half) then {
		[_aiType,"STR_CL_DZMS_AN2_TITLE","STR_CL_DZMS_AN2_CLOSE"] call DZMSMessage;
		
		//Keep on truckin'
		_plane forceSpeed 175;
		_plane flyInHeight 135;
		_plane setSpeedMode "LIMITED";
		_half = true;
	};
	
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
	
	// Check for near players
	_playerNear = [_coords,800] call DZMSNearPlayer;
	
	// If player is within range of the mission reset the start timer.
	if (_playerNear) then {_startTime = diag_tickTime;};
	
	if ((_plane distance _wp_pos) <= 200 AND !_dropped) then {
		//Drop the package
		uiSleep 2; // let the plane get close to the mission center
		_dropDir = getDir _plane;
		//_newPos = getPos _plane;
		_newPos = [(getPosATL _plane select 0) - 15*sin(_dropDir), (getPosATL _plane select 1) - 15*cos(_dropDir), (getPosATL _plane select 2) - 10];
		[_aiType,"STR_CL_DZMS_AN2_TITLE","STR_CL_DZMS_AN2_DROP"] call DZMSMessage;
		
		_chute = createVehicle ["ParachuteMediumEast", _newPos, [], 0, "FLY"];
		_chute setPos _newPos;
		_box = [_mission,_coords,"USBasicWeaponsBox","weapons",[0,0,200]] call DZMSSpawnCrate;
		_box attachTo [_chute, [0, 0, 1]];
		
		deleteWaypoint [_aiGrp, 1];
		_wp2 = _aiGrp addWaypoint [[0,0,150], 0];
		_wp2 setWaypointType "MOVE";
		_wp2 setWaypointBehaviour "CARELESS";
		_plane forceSpeed 350;
		_plane setSpeedmode "FULL";
		
		_dropped = true;
	};
	
	//The box was dropped, lets get it on the ground.
	// If the descent takes more than 45 seconds the chute is probably stuck in a tree.
	if (_dropped && isNil "_fallCount") then {
		_fallCount = 0;
		while {_fallCount < 45} do {
			if ((([_chute] call FNC_GetPos) select 2) < 6) then {_fallCount = 46};
			uiSleep 1;
			_fallCount = _fallCount + 1;
		};
		detach _box;
		_box setPos [(getPos _box select 0), (getPos _box select 1), 0];
		_coords = getPos _box;
		deleteVehicle _chute;
	};
	
	// Timeout the mission if a player is not near
	if (_dropped && (diag_tickTime - _startTime) > DZMSMissionTimeOut*60 && !_playerNear) then {
		[_coords,_mission,[],[],_crates,_groups,_staticGuns,true] spawn DZMSCleanupThread;
		[_aiType,"STR_CL_DZMS_AN2_TITLE","STR_CL_DZMS_AN2_FAIL"] call DZMSMessage;
		_complete = true;
	};
	
	// Check for completion
	if (_dropped) then {
		if (((DZMSMissionData select _mission) select 0) <= _killReq) then {
			if ([getPos _box,10] call DZMSNearPlayer) then {
				_complete = true;
				[_aiType,"STR_CL_DZMS_AN2_TITLE","STR_CL_DZMS_AN2_WIN"] call DZMSMessage;
				
				// Spawn loot in the crate
				_crates = (DZMSMissionData select _mission) select 3;
				if (count _crates > 0) then {
					{
						[(_x select 0),(_x select 1)] call DZMSBoxSetup;
					} count _crates;
				};
				
				if (DZMSSceneryDespawnTimer > 0) then {
					[_coords,_mission,[],[],_crates,_groups,_staticGuns,false] spawn DZMSCleanupThread;
				};
			};
		};
	};
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

//Clean up the pilot and plane (if they exist)
if (!isNull _plane) then {deleteVehicle _plane;};
if (!isNull _pilot) then {deleteVehicle _pilot;};

waitUntil{uiSleep 1; count units _aiGrp == 0};
deleteGroup _aiGrp;

diag_log text format["[DZMS]: %1 has Ended.",_missionName];