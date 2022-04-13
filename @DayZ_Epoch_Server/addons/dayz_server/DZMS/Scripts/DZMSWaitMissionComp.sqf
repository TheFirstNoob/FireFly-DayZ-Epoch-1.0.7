// Start mission monitoring thread

local _mission = _this select 0;
local _coords = _this select 1;
local _aiType = _this select 2;
local _name = _this select 3;
local _localName = _this select 4;
local _markerIndex = _this select 5;
local _posIndex = _this select 6;
local _msgwin = _this select 7;
local _msglose = _this select 8;
local _complete = false;
local _startTime = diag_tickTime;
local _staticTime = diag_tickTime;
local _hero = _aiType == "Hero";
local _data = DZMSMissionData select _mission;
local _aiCount = _data select 0;
local _objects = _data select 1;
local _vehicles = _data select 2;
local _crates = _data select 3;
local _groups = _data select 4;
local _staticGuns = _data select 5;
local _killReq = _aiCount - (DZMSRequiredKillPercent * _aiCount);
local _markerColor = ["ColorRed","ColorBlue"] select _hero;
local _missionName = ["Bandit " + _name,"Hero " + _name] select _hero;
local _localized = ["STR_CL_MISSION_BANDIT","STR_CL_MISSION_HERO"] select _hero;
local _text = "";
local _playerNear = false;
local _closestPlayer = objNull;
local _acArray = [];
local _claimed = false;
local _acTime = diag_tickTime;
local _claimTime = 0;
local _left = false;
local _leftTime	= 0;
local _warnArray = [];
local _markers = DZE_ServerMarkerArray select _markerIndex;
local _newCount = 0;
local _dotMarker = "DZMSDot" + str _mission;
local _autoMarkDot = "DZMSAutoDot" + str _mission;
local _autoText = "";
local _frozen = false;
local _cacheTime = diag_tickTime;

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
			PVDZ_ServerMarkerSend = ["textSingle",[_dotMarker,_text]];
			publicVariable "PVDZ_ServerMarkerSend";
			(_markers select 1) set [7, _text];
			DZE_ServerMarkerArray set [_markerIndex, _markers];
		};
	};
	
	// AI Caching
	if (DZMSAICaching) then {
		if (!_playerNear && !_frozen && {diag_tickTime - _cacheTime > 15}) then {
			_groups call DZMSFreeze;
			_cacheTime = diag_tickTime;
			_frozen = true;
		};
		
		if (_playerNear && _frozen && {diag_tickTime - _cacheTime > 15}) then {
			_groups call DZMSUnFreeze;
			_cacheTime = diag_tickTime;
			_frozen = false;
		};
	};
	
	if (DZMSAutoClaim) then {
		#include "\z\addons\dayz_server\DZMS\Scripts\DZMSAutoClaim.sqf"
	};
	
	// JIP player "invisible static gunner" glitch fix
	if ((count _staticGuns) > 0 && {(diag_tickTime - _staticTime) > 180}) then {
		{
			(gunner _x) action ["getout",_x];
		} count _staticGuns;
		_staticTime = diag_tickTime;
	};
	
	// Replenish the ammo in the static guns and check for dead gunner
	{
		if (alive _x && ({alive _x} count crew _x > 0)) then {
			_x setVehicleAmmo 1;
		} else {
			_x setDamage 1;
		};
	} count _staticGuns;

	// Check for completion
	if (_newCount <= _killReq) then {
		if ([_coords,30] call DZMSNearPlayer) then {
			_complete = true;
			[_aiType,_localName,_msgwin] call DZMSMessage;
			
			// Address mission vehicles
			{
				if (DZMSSaveVehicles && {DZMSMakeVehKey}) then {
					_x call DZMSVehKey;
				} else {
					_x setVariable ["CharacterID", "0", true];
				};
				_x setVehicleLock "unlocked";
			} count _vehicles;
			
			// Spawn loot in the crates
			{
				[(_x select 0),(_x select 1)] call DZMSBoxSetup;
			} count _crates;
			
			if (DZMSSceneryDespawnTimer > 0) then {
				[_coords,_mission,_objects,_vehicles,_crates,_groups,_staticGuns,_posIndex,false] spawn DZMSCleanupThread;
			};
			diag_log text format["[DZMS]: %1 has been completed.",_missionName];
		};
	};
	
	// Check for near players
	_playerNear = [_coords,DZMSTimeoutDistance] call DZMSNearPlayer;
	
	// Timeout the mission if a player is not near
	if (diag_tickTime - _startTime > DZMSMissionTimeOut*60 && !_playerNear) then {
		_complete = true;
		[_coords,_mission,_objects,_vehicles,_crates,_groups,_staticGuns,_posIndex,true] spawn DZMSCleanupThread;
		[_aiType,_localName,_msglose] call DZMSMessage;
		diag_log text format["[DZMS]: %1 has timed out.",_missionName];
	};
	
	// If player is within range of the mission reset the start timer.
	if (_playerNear) then {_startTime = diag_tickTime;};
	
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

DZE_ServerMarkerArray set [_markerIndex, -1];
DZMSMissionData set [_mission, -1];
