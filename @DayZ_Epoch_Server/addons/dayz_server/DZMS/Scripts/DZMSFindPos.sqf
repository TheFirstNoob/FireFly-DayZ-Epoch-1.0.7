local _pos = [0,0,0];
local _num = 1;
local _findRun = true;
local _playerNear = true;
local _isTavi = toLower worldName == "tavi";

//We need to loop findSafePos until it doesn't return the map center
while {_findRun} do {
	
	if (DZMSStaticPlc) then {
		_pos = DZMSStatLocs call BIS_fnc_selectRandom;
		_pos = [(_pos select 0), (_pos select 1)]; // Position needs to be 2D.
	} else {
		_pos = [getMarkerPos "center",0,((getMarkerSize "center") select 1) * .75,30,0,.2,0,DZMSBlacklistZones] call BIS_fnc_findSafePos;
	};
	local _isOk = true;
	// Let's check for nearby water within 100 meters
	{
		if (surfaceIsWater _x) exitWith {_isOk = false;};
	} count [_pos,[(_pos select 0), (_pos select 1)+100],[(_pos select 0)+100, (_pos select 1)],[(_pos select 0), (_pos select 1)-100],[(_pos select 0)-100, (_pos select 1)]];
	
	//Lets test the height on Taviana
	if (_isTavi) then {
		local _tavTest = createVehicle ["Can_Small",[(_pos select 0),(_pos select 1),0],[], 0, "CAN_COLLIDE"];
		_isOk = (((getPosASL _tavTest) select 2) <= 185);
		deleteVehicle _tavTest;
	};
	
	// Check if position is far enough away from other missions
	{
		if ((typeName _x) == "ARRAY" && {_pos distance _x < DZMSDistanceBetweenMissions}) exitWith {
			_isOk = false;
		};
	} count DZE_MissionPositions;
	
	// Check for near safezones if Epoch/Overpoch
	if (DZMSEpoch) then {
		{
			if (_pos distance (_x select 0) < 700) exitWith {
				_isOk = false;
			};
		} count DZE_SafeZonePosArray;
	};
	
	//Check for players within 500 meters
	_playerNear = [_pos,500] call DZMSNearPlayer;
	
	//Lets combine all our checks to possibly end the loop
	if (_isOk && !_playerNear && {count _pos == 2}) then {
		_findRun = false;
	};
	
	if (DZMSDebug) then {diag_log format["DZMSFindPos: %1 attempts to find a safe position",_num];};
	_num = _num + 1;
};
_pos set [2, 0];
_pos