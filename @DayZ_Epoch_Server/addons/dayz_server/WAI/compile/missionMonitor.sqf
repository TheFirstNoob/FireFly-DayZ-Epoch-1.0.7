local _mission = _this select 0;
local _position = _this select 1;
local _difficulty = _this select 2;
local _name = _this select 3;
local _localName = _this select 4;
local _aiType = _this select 5;
local _markerIndex = _this select 6;
local _posIndex = _this select 7;
local _claimPlayer = _this select 8;
local _showMarker = _this select 9;
local _enableMines = _this select 10;
local _completionType = _this select 11;
local _msgwin = (_this select 12) select 1;
local _msglose = (_this select 12) select 2;
local _hero = (_aiType == "Hero");
_name = ["Bandit " + _name, "Hero " + _name] select _hero;
local _playerNear = false;
local _complete = false;
local _starttime = diag_tickTime;
local _data = WAI_MissionData select _mission;
local _aiCount = _data select 0;
local _unitGroups = _data select 1;
local _crates = _data select 2;
local _aiVehicles = _data select 3;
local _vehicles = _data select 4;
local _objects = _data select 5;
local _killpercent = _aiCount - (_aiCount * (WAI_KillPercent / 100));
local _playerArray = [];
local _mines = [];
local _time = diag_tickTime;
local _closestPlayer = objNull;
local _acArray = [];
local _claimed = false;
local _acTime = diag_tickTime;
local _claimTime = 0;
local _left = false;
local _leftTime = 0;
local _player = objNull;
local _warnArray = [];
local _markers = DZE_ServerMarkerArray select _markerIndex;
local _newCount = 0;
local _dotMarker = "WAI" + str(_mission) + "dot";
local _autoMarkDot = "WAI" + str(_mission) + "autodot";
local _autoText = "";
local _cacheTime = diag_tickTime;
local _frozen = false;
local _wanderTime = diag_tickTime;

if (WAI_EnableMineField && _enableMines) then {
	_mines = [_position,50,75,100] call WAI_MineField;
};

// Add AI counter if enabled.
if (_showMarker && WAI_ShowCount) then {
	local _text = if (_hero) then {
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
	// Update marker text for AI counter if AI count changes
	if (_showMarker && WAI_ShowCount) then {
		// Check to see if the AI count has changed and update the marker.
		_newCount = (WAI_MissionData select _mission) select 0;
		if (_newCount != _aiCount) then {
			_aiCount = _newCount;
			local _text = if (_hero) then {
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
	
	if (WAI_AutoClaim && _showMarker) then {
		#include "\z\addons\dayz_server\WAI\compile\auto_claim.sqf"	
	};
	
	// Monitor the mine field for player proximity
	if (count _mines > 0) then {
		{
			_player = _x;
			if (vehicle _player != _player && {_player distance _position < 300} && {!(_player in _playerArray)}) then {
				RemoteMessage = ["dynamic_text",["","STR_CL_MINEFIELD_WARNING"], ["0","#FFFFFF","0.50","#ff3300",0,.3,10,0.5]];
				(owner _player) publicVariableClient "RemoteMessage";
				_playerArray set [count _playerArray, _player];
			};
			
			if (vehicle _player != _player && {_player distance _position < 75} && {alive _player} && {(([vehicle _player] call FNC_GetPos) select 2) < 1}) then {
				"Bo_GBU12_lgb" createVehicle ([vehicle _player] call FNC_GetPos);
			};
		} count playableUnits;
	};
	
	// AI vehicles need to be refueled and filled with ammo 
	if (count _aiVehicles > 0) then {
		_aiVehicles call WAI_VehMonitor;
		// JIP invisible gunner fix
		if ((diag_tickTime - _time) > 180) then {
			{
				if (_x isKindOf "StaticWeapon") then {
					(gunner _x) action ["getout",_x];
				};
			} count _aiVehicles;
			_time = diag_tickTime;
		};
	};
	
	// Timeout check
	_playerNear = [_position,WAI_TimeoutDist] call isNearPlayer;
	if (diag_tickTime - _starttime >= (WAI_Timeout * 60) && !_playerNear) then {
		_complete = true;
		
		[_position, _mission, _objects, _vehicles, _crates, _unitGroups, _aiVehicles, _posIndex, true] spawn WAI_CleanUp;
		
		[_difficulty,_msglose] call WAI_Message;
		
		diag_log format["WAI: %1 timed out at %2",_name,_position];
	} else {
		if (_playerNear) then {_starttime = diag_tickTime;};
	};
	
	// AI Caching
	if (WAI_Caching) then {
		if (!_playerNear && !_frozen && {diag_tickTime - _cacheTime > 15}) then {
			_unitGroups call WAI_Freeze;
			_cacheTime = diag_tickTime;
			_frozen = true;
		};
		
		if (_playerNear && _frozen && {diag_tickTime - _cacheTime > 15}) then {
			_unitGroups call WAI_UnFreeze;
			_cacheTime = diag_tickTime;
			_frozen = false;
		};
	};
	
	_unitGroups = (WAI_MissionData select _mission) select 1;
	
	{
		// remove empty groups
		if (count units _x == 0) then {
			deleteGroup _x;
		};

		// remove null groups from the array
		if (isNull _x) then {
			_unitGroups = _unitGroups - [_x];
		};
	} forEach _unitGroups;
	
	// Completion check
	if ([_mission,_completionType,_killpercent,_position] call WAI_CompletionCheck || count _unitGroups == 0) then {
		_complete = true;
		
		{
			[_x,_mission,_crates] call WAI_GenerateVehKey;
		} count _vehicles;
		
		{
			[(_x select 0),(_x select 1),_complete] call WAI_DynCrate;
		} count _crates;
		
		if (({[_x,_name] call fnc_inString;} count WAI_CleanWhenClear) != 0) then {
			[_position, _mission, _objects, _vehicles, _crates, _unitGroups, _aiVehicles, _posIndex, true] spawn WAI_CleanUp;
		} else {
			[_position, _mission, _objects, _vehicles, _crates, _unitGroups, _aiVehicles, _posIndex, false] spawn WAI_CleanUp;
		};
		
		[_difficulty,_msgwin] call WAI_Message;
		
		diag_log format["WAI: %1 completed at %2",_name,_position];
	};
	
	uiSleep 2;
};

// Remove all mines if they exist
{deleteVehicle _x;} count _mines;

// Tell all clients to remove the markers from the map
local _remove = [];
{
	if (typeName _x == "ARRAY") then {
		_remove set [count _remove, (_x select 1)];
	};
} count _markers;

PVDZ_ServerMarkerSend = ["end",_remove];
publicVariable "PVDZ_ServerMarkerSend";

if (_hero) then {
	WAI_HeroRunning = WAI_HeroRunning - 1;
	WAI_HeroStartTime = diag_tickTime;
} else {
	WAI_BanditRunning = WAI_BanditRunning - 1;
	WAI_BanditStartTime = diag_tickTime;
};

DZE_ServerMarkerArray set [_markerIndex, -1];
WAI_MissionData set [_mission, -1];