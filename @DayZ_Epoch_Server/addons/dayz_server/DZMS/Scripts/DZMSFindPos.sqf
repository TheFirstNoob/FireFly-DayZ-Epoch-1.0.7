private["_markers","_tavHeight","_pos","_params","_num","_findRun","_tavTest","_okDis","_noWater","_playerNear"];

_tavHeight = 0;
_pos = [0,0,0];
_params = [getMarkerPos "center",0,((getMarkerSize "center") select 1) * .75,30,0,.2,0,DZMSBlacklistZones];
_num = 1;
_findRun = true;

//We need to loop findSafePos until it doesn't return the map center
while {_findRun} do {
	
	if (DZMSStaticPlc) then {
		_pos = DZMSStatLocs call BIS_fnc_selectRandom;
		_pos = [(_pos select 0), (_pos select 1)]; // Position needs to be 2D.
	} else {
		_pos = _params call BIS_fnc_findSafePos;
	};
	
	// Let's check for nearby water within 100 meters
	_noWater = true;
	{
		if (surfaceIsWater _x) exitWith {_noWater = false;};
	} count [_pos,[(_pos select 0), (_pos select 1)+100],[(_pos select 0)+100, (_pos select 1)],[(_pos select 0), (_pos select 1)-100],[(_pos select 0)-100, (_pos select 1)]];
	
	//Lets test the height on Taviana
	if (toLower worldName == "tavi") then {
		_tavTest = createVehicle ["Can_Small",[(_pos select 0),(_pos select 1),0],[], 0, "CAN_COLLIDE"];
		_tavHeight = (getPosASL _tavTest) select 2;
		deleteVehicle _tavTest;
	};
	
	// If WAI installed, include the markers
	_markers = if (!isNil "wai_mission_markers") then {DZMSMarkers + wai_mission_markers} else {DZMSMarkers};
	
	//Lets check for minimum mission separation distance
	_okDis = true;
	{
		if (_pos distance (getMarkerPos _x) < 1000) exitWith {
			_okDis = false;
		};
	} count _markers;
	
	// Check for near safezones if Epoch/Overpoch
	if (DZMSEpoch) then {
		{
			if (_pos distance (_x select 0) < 700) exitWith {
				_okDis = false;
			};
		} forEach DZE_SafeZonePosArray;
	};
	
	//Check for players within 500 meters
	_playerNear = [_pos,500] call DZMSNearPlayer;
	
	//Lets combine all our checks to possibly end the loop
	if (_noWater AND _okDis AND !_playerNear AND _tavHeight <= 185 AND count _pos == 2) then {
		_findRun = false;
	};
	
	if (DZMSDebug) then {diag_log format["DZMSFindPos: %1 attempts to find a safe position",_num];};
	_num = _num + 1;
};
_pos set [2, 0];
_pos