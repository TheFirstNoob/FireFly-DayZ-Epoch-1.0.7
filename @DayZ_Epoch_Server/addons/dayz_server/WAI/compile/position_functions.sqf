isNearWater = {
	local _result = false;
	local _position = _this select 0;
	local _radius = _this select 1;
	
	for "_i" from 0 to 359 step 45 do {
		_position = [(_position select 0) + (sin(_i)*_radius), (_position select 1) + (cos(_i)*_radius)];
		if (surfaceIsWater _position) exitWith {
			_result = true; 
		};
	};
	_result
};

isNearTown = {
	local _result = false;
	local _position = _this select 0;
	local _radius = _this select 1;
	local _locations = [["NameCityCapital","NameCity","NameVillage"],[_position,_radius]] call BIS_fnc_locations;

	if (count _locations > 0) then { 
		_result = true; 
	};
	_result
};

isNearRoad = {
	local _result = false;
	local _position = _this select 0;
	local _radius = _this select 1;
	local _roads = _position nearRoads _radius;

	if (count _roads > 0) then {
		_result = true;
	};
	_result
};

isNearPlayer = {
	local _result = false;
	local _position = _this select 0;
	local _radius = _this select 1;

	{
		if ((isPlayer _x) && (_x distance _position <= _radius)) exitWith {
			_result = true;
		};
	} count playableUnits;
	_result
};

isValidSpot = {
	local _positions = _this select 0;
	local _validspot = false;
	local _count = 1;
	local _position = [];
	
	while {!_validspot && {_count < (count _positions)}} do {
		_positions = [_positions, 25] call fn_shuffleArray;
		_position = _positions select 0;
		_positions = [_positions,0] call fnc_deleteAt;
		_validspot = true;
		
		if (WAI_AvoidMissions != 0) then {
			{
				if ((typeName _x) == "ARRAY" && {_position distance _x < WAI_AvoidMissions}) exitWith {
					if (WAI_DebugMode) then {diag_log format ["WAI: Invalid Position: %1", _x];};
					_validspot = false;
				};
			} count DZE_MissionPositions;
		};
		
		if (WAI_AvoidPlayers != 0) then {
			if ([_position, WAI_AvoidPlayers] call isNearPlayer) then {
				if (WAI_DebugMode) then {diag_log "WAI: Invalid Position (player)";};
				_validspot = false;
			};
		};
		
		if(_validspot) then {
			if(WAI_DebugMode) then { diag_log("WAI: valid position found at" + str(_position));};
		};
		
		_count = _count + 1;
	};
	_position
};

isClosestPlayer = {
	local _position = _this select 0;
	local _scandist = _this select 1;
	local _closest = objNull;
	
	{
		local _dist = vehicle _x distance _position;
		if (isPlayer _x && _dist < _scandist) then {
			_closest = _x;
			_scandist = _dist;
		};
	} count playableUnits;
	
	_closest
};

isReturningPlayer = {
	local _position = _this select 0;
	local _acArray = _this select 1;
	local _playerUID = _acArray select 0;
	local _returningPlayer = objNull;

	{
		if ((isPlayer _x) && (_x distance _position <= WAI_AcAlertDistance) && (getplayerUID _x == _playerUID)) then {
			_returningPlayer = _x;
		};
	} count playableUnits;
	
	_returningPlayer
};

