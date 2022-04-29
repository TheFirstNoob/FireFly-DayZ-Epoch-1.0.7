local _cycle 	= 	true; // Если установлено true, то миссии не будут повторяться до тех пор, пока не будут созданы все

if (isNil "Server_Events_Array") then
{
	Server_Events_Array =
	[
		"building_supplies"
		,"pirate_treasure"
		,"special_forces"
		,"un_supply"
		,"labyrinth"
		,"rubble_town"
		,"fuelstationbomb"
		,"mechanics_truck"
	];
};

local _event 	= 	Server_Events_Array call BIS_fnc_selectRandom;
execVM format ["\z\addons\dayz_server\modules\%1.sqf",_event];

if (_cycle) then
{
	Server_Events_Array = Server_Events_Array - [_event];

	if (count Server_Events_Array == 0) then
	{
		Server_Events_Array 	= 	nil;
	};
};
