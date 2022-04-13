/*
	AN-2 Bandit Supply Drop by Vampire
	Example Code by Halv
	Updated for DZMS 2.0 by JasonTM
*/
uiSleep 2;
local _markBox = true; // Mark the location of the crate once it's on the ground.
local _mission = count DZMSMissionData -1;
local _aiType = _this select 0;
local _name = "AN2 Supply Drop";
local _localName = "STR_CL_DZMS_AN2_TITLE";
local _coords = call DZMSFindPos;
local _hero = _aiType == "Hero";
local _markerColor = ["ColorRed","ColorBlue"] select _hero;
local _localized = ["STR_CL_MISSION_BANDIT","STR_CL_MISSION_HERO"] select _hero;
local _dotMarker = "DZMSDot" + str _mission;
local _startTime = diag_tickTime;

diag_log format["[DZMS]: %1 %2 starting at %3.",_aiType,_name,_coords];

////////////////////// Do not edit this section ///////////////////////////
//[position,createMarker,setMarkerColor,setMarkerType,setMarkerShape,setMarkerBrush,setMarkerSize,setMarkerText,setMarkerAlpha]
local _markers = [1,1,1,1,1];
_markers set [0, [_coords,"DZMS" + str _mission,_markerColor,"","ELLIPSE","Grid",[200,200],[],0]];
_markers set [1, [_coords,_dotMarker,"ColorBlack","Vehicle","","",[],[_localized,_localName],0]];
if (DZMSAutoClaim) then {_markers set [2, [_coords,"DZMSAuto" + str _mission,"ColorRed","","ELLIPSE","Border",[DZMSAutoClaimAlertDistance,DZMSAutoClaimAlertDistance],[],0]];};
DZE_ServerMarkerArray set [count DZE_ServerMarkerArray, _markers]; // Markers added to global array for JIP player requests.
local _markerIndex = count DZE_ServerMarkerArray - 1;
PVDZ_ServerMarkerSend = ["start",_markers];
publicVariable "PVDZ_ServerMarkerSend";
[_aiType,_localName,"STR_CL_DZMS_AN2_START"] call DZMSMessage;
DZMSMarkerReady = true;

// Add the mission's position to the global array so that other missions do not spawn near it.
DZE_MissionPositions set [count DZE_MissionPositions, _coords];
local _posIndex = count DZE_MissionPositions - 1;

// Wait until a player is within range or timeout is reached.
local _playerNear = false;
local _timeout = false;
while {!_playerNear && !_timeout} do {
	_playerNear = [_coords,DZMSTimeoutDistance] call DZMSNearPlayer;
	
	if (diag_tickTime - _startTime >= (DZMSMissionTimeOut * 60)) then {
		_timeout = true;
	};
	uiSleep 1;
};

if (_timeout) exitWith {
	[_mission, _aiType, _markerIndex, _posIndex] call DZMSAbortMission;
	[_aiType,_localName,"STR_CL_DZMS_AN2_FAIL"] call DZMSMessage;
	diag_log format["DZMS: %1 %2 aborted.",_aiType,_name];
};
//////////////////////////////// End //////////////////////////////////////

//Lets get the AN2 Flying
local _dist = 8000; // increase or decrease this number to adjust the time it takes the plane to get to the mission.
local _porM = if (random 1 > .5) then {"+"} else {"-"};
local _porM2 = if (random 1 > .5) then {"+"} else {"-"};
local _startPos = call compile format ["[(%1 select 0) %2 %4,(%1 select 1) %3 %4, 300]",_coords,_porM,_porM2,_dist];
local _plane = "AN2_DZ" createVehicle _startPos;
local _dir = [_plane, _coords] call BIS_fnc_relativeDirTo;
_plane setDir _dir;
_plane setPos _startPos;
_plane setVelocity [(sin _dir*150),(cos _dir*150),0];
_plane engineOn true;
_plane flyInHeight 150;
_plane forceSpeed 175;
dayz_serverObjectMonitor set [count dayz_serverObjectMonitor, _plane];

//Lets make AI for the plane and get them in it
local _aiGrp = createGroup east;

local _pilot = _aiGrp createUnit ["SurvivorW2_DZ",getPos _plane,[],0,"FORM"];
_pilot moveInDriver _plane;
//_pilot assignAsDriver _plane;

local _wp = _aiGrp addWaypoint [[(_coords select 0), (_coords select 1),150], 0];
_wp setWaypointType "MOVE";
_wp setWaypointBehaviour "CARELESS";
_wp_pos = waypointPosition [_aiGrp,1];

//DZMSAISpawn spawns AI to the mission.
//Usage: [_coords, count, skillLevel, Hero or Bandit, Mission Number]
[_coords,6,1,_aiType,_mission] call DZMSAISpawn;
[_coords,6,2,_aiType,_mission] call DZMSAISpawn;
[_coords,4,3,_aiType,_mission] call DZMSAISpawn;

uiSleep 2;

local _aiCount = (DZMSMissionData select _mission) select 0;
local _groups = (DZMSMissionData select _mission) select 4;
local _staticGuns = (DZMSMissionData select _mission) select 5;
local _killReq = _aiCount - (DZMSRequiredKillPercent * _aiCount);
local _markerColor = ["ColorRed","ColorBlue"] select _hero;
local _missionName = ["Bandit " + _name,"Hero " + _name] select _hero;
local _text = "";
local _autoMarkDot = "DZMSAutoDot" + str _mission;
local _autoText = "";

// Add AI counter if enabled.
if (DZMSAICount) then {
	_text = if (_hero) then {
		["STR_CL_MISSION_HERO_COUNT",_localName,_aiCount,"STR_CL_MISSION_HEROS"];
	} else {
		["STR_CL_MISSION_BANDIT_COUNT",_localName,_aiCount,"STR_CL_MISSION_BANDITS"];
	};
	PVDZ_ServerMarkerSend = ["textSingle",[_dotMarker,_text]];
	publicVariable "PVDZ_ServerMarkerSend";
	(_markers select 1) set [7, _text];
	DZE_ServerMarkerArray set [_markerIndex, _markers];
};

local _half = false;
local _complete = false;
local _dropped = false;
local _crates = [];
local _chute = "";
local _box = "";
local _closestPlayer = objNull;
local _acArray = [];
local _claimed = false;
local _acTime = diag_tickTime;
local _claimTime = 0;
local _left = false;
local _leftTime	= 0;
local _warnArray = [];
local _playerNear = false;
local _newCount = 0;
local _fallCount = -1;

while {!_complete} do {
	_newCount = (DZMSMissionData select _mission) select 0;
	if (DZMSAICount) then {
		// Check to see if the AI count has changed and update the marker.
		if (_newCount != _aiCount) then {
			_aiCount = _newCount;
			_text = if (_hero) then {
				["STR_CL_MISSION_HERO_COUNT",_localName,_aiCount,"STR_CL_MISSION_HEROS"];
			} else {
				["STR_CL_MISSION_BANDIT_COUNT",_localName,_aiCount,"STR_CL_MISSION_BANDITS"];
			};
			(_markers select 1) set [7, _text];
			PVDZ_ServerMarkerSend = ["textSingle",[_dotMarker,_text]];
			publicVariable "PVDZ_ServerMarkerSend";
			DZE_ServerMarkerArray set [_markerIndex, _markers];
		};
	};
	
	if (DZMSAutoClaim) then {
		#include "\z\addons\dayz_server\DZMS\Scripts\DZMSAutoClaim.sqf"	
	};
	
	if (!alive _plane && !_dropped) exitWith {
		deleteVehicle _pilot;
		[_coords,_mission,[],[],[],_groups,_staticGuns,_posIndex,true] spawn DZMSCleanupThread;
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
	
	// Check for near players
	_playerNear = [_coords,DZMSTimeoutDistance] call DZMSNearPlayer;
	
	// If player is within range of the mission reset the start timer.
	if (_playerNear) then {_startTime = diag_tickTime;};
	
	if ((_plane distance _wp_pos) <= 200 && !_dropped) then {
		//Drop the package
		uiSleep 2; // let the plane get close to the mission center
		local _dropDir = getDir _plane;
		local _newPos = [(getPosATL _plane select 0) - 15*sin(_dropDir), (getPosATL _plane select 1) - 15*cos(_dropDir), (getPosATL _plane select 2) - 10];
		[_aiType,"STR_CL_DZMS_AN2_TITLE","STR_CL_DZMS_AN2_DROP"] call DZMSMessage;
		
		_chute = createVehicle ["ParachuteMediumEast", _newPos, [], 0, "FLY"];
		_chute setPos _newPos;
		_box = (["AmmoBoxBig","DZ_AmmoBoxBigUS"] select DZMSEpoch) createVehicle [(_coords select 0),(_coords select 1),200];
		_box attachTo [_chute, [0, 0, 1]];
		
		deleteWaypoint [_aiGrp, 1];
		local _wp2 = _aiGrp addWaypoint [[0,0,150], 0];
		_wp2 setWaypointType "MOVE";
		_wp2 setWaypointBehaviour "CARELESS";
		_plane forceSpeed 350;
		_plane setSpeedmode "FULL";
		_dropped = true;
	};
	
	if (_dropped) then {
		//The box was dropped, lets get it on the ground.
		// If the descent takes more than 45 seconds the chute is probably stuck in a tree.
		if (_fallCount < 0) then {
			_fallCount = 0;
			while {_fallCount < 90} do {
				uiSleep .5;
				//if ((([_chute] call FNC_GetPos) select 2) < 2) then {_fallCount = 91};
				if ((([_box] call FNC_GetPos) select 2) < 2) then {_fallCount = 91};
				_fallCount = _fallCount + .5;
			};
			detach _box;
			_coords = [(getPos _box select 0), (getPos _box select 1), 0];
			
			// Sometimes players are unable to access the crate object after being attached/detached server side. So the fix is to delete the box and create a new one.
			deleteVehicle _box;
			_box = [_mission,_coords,"DZ_AmmoBoxBigUS","weapons",[0,0]] call DZMSSpawnCrate;
			_box setPos _coords;
			deleteVehicle _chute;
			
			if (_markBox) then {
				_markers set [4, [_coords,"DZMSCrateDot" + str _coords,"ColorBlack","Vehicle","","",[],["STR_EPOCH_BULK_NAME"],0]];
				DZE_ServerMarkerArray set [_markerIndex, _markers];
				PVDZ_ServerMarkerSend = ["createSingle",(_markers select 4)];
				publicVariable "PVDZ_ServerMarkerSend";
			};
		};
		
		// Timeout the mission if a player is not near
		if ((diag_tickTime - _startTime) > (DZMSMissionTimeOut * 60) && !_playerNear) then {
			_crates = (DZMSMissionData select _mission) select 3;
			[_coords,_mission,[],[],_crates,_groups,_staticGuns,_posIndex,true] spawn DZMSCleanupThread;
			[_aiType,"STR_CL_DZMS_AN2_TITLE","STR_CL_DZMS_AN2_FAIL"] call DZMSMessage;
			_complete = true;
		};
		
		// Check for completion
		if (_newCount <= _killReq) then {
			if ([_coords,10] call DZMSNearPlayer) then {
				_complete = true;
				[_aiType,"STR_CL_DZMS_AN2_TITLE","STR_CL_DZMS_AN2_WIN"] call DZMSMessage;
				
				// Spawn loot in the crate
				_crates = (DZMSMissionData select _mission) select 3;
				{
					[(_x select 0),(_x select 1)] call DZMSBoxSetup;
				} count _crates;
				
				if (DZMSSceneryDespawnTimer > 0) then {
					[_coords,_mission,[],[],_crates,_groups,_staticGuns,_posIndex,false] spawn DZMSCleanupThread;
				};
			};
		};
	};
	uiSleep 2;
};

// Tell all clients to remove the markers from the map
local _remove = [];
{
	if (typeName _x == "ARRAY") then {
		_remove set [count _remove, (_x select 1)];
	};
} count _markers;
PVDZ_ServerMarkerSend = ["end",_remove];
publicVariable "PVDZ_ServerMarkerSend";

//Let the timer know the mission is over
if (_hero) then {
	DZMSHeroEndTime = diag_tickTime;
	DZMSHeroRunning = DZMSHeroRunning - 1;
} else {
	DZMSBanditEndTime = diag_tickTime;
	DZMSBanditRunning = DZMSBanditRunning - 1;
};

// Remove marker and mission data
DZE_ServerMarkerArray set [_markerIndex, -1];
DZE_MissionPositions set [_posIndex, -1];
DZMSMissionData set [_mission, -1];

//Clean up the pilot and plane (if they exist)
if (!isNull _plane) then {deleteVehicle _plane;};
if (!isNull _pilot) then {deleteVehicle _pilot;};

waitUntil{uiSleep 1; count units _aiGrp == 0};
deleteGroup _aiGrp;

diag_log text format["[DZMS]: %1 has Ended.",_missionName];
