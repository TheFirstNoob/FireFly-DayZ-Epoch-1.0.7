_coords 	= 	_this select 0;
_dot 		= 	_this select 1;
_type 		= 	_this select 2;

if (_type == 0) then
{ // 0 Normal Event
	while {true} do {
		_event_marker = createMarker [ format ["CarePackages_%1", time], _coords];
		_event_marker setMarkerType _dot;

		uiSleep 178;
		deleteMarker _event_marker;
		uiSleep 2;
	};
};

if (_type == 1) then
{ // 1 Normal Event
	while {true} do {
		_event_marker = createMarker [ format ["InfectedCamps_%1", time], _coords];
		_event_marker setMarkerType _dot;

		uiSleep 178;
		deleteMarker _event_marker;
		uiSleep 2;
	};
};