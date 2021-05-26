private ["_position","_doLoiter","_unitTypes","_array","_agent","_type","_radius","_method","_rndx","_rndy","_counter","_amount","_wildsdone"];
_unitTypes 	= 	_this select 0;
_amount 	= 	_this select 1;
_wildsdone 	= 	true;
_counter 	= 	0;

while {_counter < _amount} do {
	_agent 		= 	objNull;
	_type 		= 	_unitTypes call BIS_fnc_selectRandom;
	_method 	= 	"CAN_COLLIDE";
	_position 	= 	[getMarkerPos "center",1,6500,1] call fn_selectRandomLocation;
	if ([_position] call DZE_SafeZonePosCheck) exitWith {};
	// Создаем Зомби
	_agent 	= 	createAgent [_type, _position, [], 1, _method];
	_agent setDir floor(random 360);
	_agent setVariable ["doLoiter",true];

	if (random 1 > 0.7) then
	{
		_agent setUnitPos "Middle";
	};

	_position 	= 	getPosATL _agent;
	_agent setVariable ["homePos",_position,true];
	_agent setVariable["agentObject",_agent,true];
	
	// Добавляем в Счетчик
	_counter = _counter + 1;
	_agent enableSimulation false;

	//diag_log format ["[СЕРВЕР]: [zombie_Windgenerate.sqf]: [ГЕНЕРАЦИЯ]: Активных: %1, Ждут: %2",_counter,(_amount - _counter)]
};

_wildsdone
