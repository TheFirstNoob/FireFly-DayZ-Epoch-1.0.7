#include "\z\addons\dayz_server\compile\server_toggle_debug.hpp"

private ["_characterID","_minutes","_newObject","_playerID","_playerName","_key","_pos","_infected","_sourceName","_sourceWeapon","_distance","_message","_method","_suicide","_bodyName","_type","_sourceID"];
//[unit, weapon, muzzle, mode, ammo, magazine, projectile]

_characterID 	= 	_this select 0;
_minutes 		= 	_this select 1;
_newObject 		= 	_this select 2;
_playerID 		= 	_this select 3;
_playerName 	= 	toString (_this select 4); 	// Отправим в массив чтобы избежать publicVariable запрет
_infected 		= 	_this select 5;
_sourceName 	= 	toString (_this select 6);
_sourceWeapon 	= 	_this select 7;
_distance 		= 	_this select 8;
_method 		= 	_this select 9;
_sourceID 		= 	_this select 10;

// Отметим игрока мертвым чтобы обойти Призрак Систему
dayz_died set [count dayz_died, _playerID];

_newObject setVariable ["bodyName",_playerName,true];
_pos 	= 	getPosATL _newObject;

if (typeName _minutes == "STRING") then {_minutes = parseNumber _minutes;};

if (_characterID != "0") then
{
	_key 	= 	format["CHILD:202:%1:%2:%3:",_characterID,_minutes,_infected];
	//diag_log ("HIVE: WRITE: "+ str(_key));
	_key call server_hiveWrite;
};

diag_log format ["[СЕРВЕР]: [server_playerDied.sqf]: [СМЕРТЬ]: Игрок %1(%3) умер %5 на %2 CharID: %4",
	_newObject call fa_plr2str, _pos call fa_coor2str,
	_playerID, _characterID,
	typeOf _newObject
];

// Сообщения о смерти
_suicide = ((_sourceName == _playerName) or (_method == "suicide"));

if (_method in ["explosion","melee","shot","shothead","shotheavy","suicide"] && {!(_method == "explosion" && {_suicide || {_sourceName == "unknown"}})}) then
{
	if (_suicide) then
	{
		_message = ["suicide",_playerName];
	}
	else
	{
		if (_sourceWeapon == "") then
		{
			_sourceWeapon = "unknown weapon";
		};
		_message = ["killed",_playerName,_sourceName,_sourceWeapon,_distance];
		// Сохраним сообщения о смерти чтобы позволить смотреть их в Трейд-Зонах на БилБорде.
		PlayerDeaths set [count PlayerDeaths,[_playerName,_sourceName,_sourceWeapon,_distance,[(ServerCurrentTime select 3), (ServerCurrentTime select 4)]]];
	};
}
else
{
	// No source name, distance or weapon needed: "%1 died from %2" str_death_%1 (see stringtable)
	// Possible methods: ["bled","combatlog","crash","crushed","dehyd","eject","fall","starve","sick","rad","runover","unknown","zombie"]
	_message = ["died",_playerName,_method];
};

if (_playerName != "unknown" || {_sourceName != "unknown"}) then
{
	if (toLower DZE_DeathMsgChat != "none" || {DZE_DeathMsgRolling} || {DZE_DeathMsgDynamicText}) then
	{
		PVDZE_deathMessage = _message;
		// Не используйте обычные PV здесь поскольку JIP клиентам это не нужно
		owner _newObject publicVariableClient "PVDZE_deathMessage"; // Отправим в Мертвого игрока (не в playableUnits)
		{
			if !(getPlayerUID _x in ["",_playerID]) then
			{
				owner _x publicVariableClient "PVDZE_deathMessage";
			};
		} count playableUnits;
	};

	_type 		= 	_message select 0;
	_bodyName 	= 	_message select 1;

	if (_type == "killed" && {_sourceName == "AI"}) then
	{
		_message set [2, (localize "STR_PLAYER_AI")];
	};

	_message = call {
		if (_type == "died") exitwith {format ["Игрок: %1(%3) умер от: %2", _bodyName, localize format["str_death_%1",_message select 2],_playerID]};
		if (_type == "killed") exitwith {format ["Игрок: %1(%5) был убит от рук: %2(%6), (С оружия: %3),(Расстояние: %4м)", _bodyName, _message select 2, _message select 3, _message select 4,_playerID,_sourceID]};
		if (_type == "suicide") exitwith {format ["%1(%2) сделал Самоубийство", _bodyName,_playerID]};
	};
	diag_log format["[СЕРВЕР]: [server_playerDied.sqf]: [УБИЙСТВА И СМЕРТИ]: %1",_message];
};

_newObject setDamage 1;
_newObject setOwner 0;