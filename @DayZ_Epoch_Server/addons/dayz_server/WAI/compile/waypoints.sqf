local _unitGroup = _this select 0;
local _position = _this select 1;
local _pos_x = _position select 0;
local _pos_y = _position select 1;
local _pos_z = _position select 2;
local _wp_rad = 0;
local _skill = "";
local _wp = [];

/*
// Experiment with guarded points to try and keep AI in a certain area.
if (_pos_z > 0) exitWith {
	local _side = side (leader _unitgroup);
	createGuardedPoint [_side, _position, -1, objNull];
	_wp = _unitGroup addWaypoint [_position,0];
	_wp setWaypointType "GUARD";
	_unitgroup lockWP true;
};
*/

if (_pos_z > 0) exitWith {
	_wp = _unitGroup addWaypoint [_position,0];
	//_wp setWaypointType "HOLD";
	_wp setWaypointType "SENTRY";
};

if(count _this > 2) then {
	_skill = _this select 2;
	_wp_rad = call {
		if (_skill == "easy") exitWith {20;};
		if (_skill == "medium") exitWith {40;};
		if (_skill == "hard") exitWith {60;};
		if (_skill == "extreme") exitWith {80;};
		if (_skill == "random") exitWith {20 + random(60);};
	};
};

{
	_wp = _unitGroup addWaypoint [_x,10];
	_wp setWaypointType "MOVE";

} count [[_pos_x,(_pos_y + _wp_rad),0],[(_pos_x + _wp_rad),_pos_y,0],[_pos_x,(_pos_y - _wp_rad),0],[(_pos_x - _wp_rad),_pos_y,0]];

_wp = _unitGroup addWaypoint [[_pos_x,_pos_y,0],_wp_rad];
_wp setWaypointType "CYCLE";
