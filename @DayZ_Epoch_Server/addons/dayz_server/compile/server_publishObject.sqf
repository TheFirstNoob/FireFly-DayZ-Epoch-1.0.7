#include "\z\addons\dayz_server\compile\server_toggle_debug.hpp"

private ["_type","_objectUID","_characterID","_object","_worldspace","_key","_ownerArray","_inventory","_clientKey","_exitReason","_player","_playerUID"];

if (count _this < 6) exitWith
{
	diag_log "[СЕРВЕР]: [server_publishObject.sqf]: [ОШИБКА]: Неверно получены данные. Параметров получено меньше, должно быть 6!";
};

_characterID 	=	_this select 0;
_object 		= 	_this select 1;
_worldspace 	= 	_this select 2;
_inventory 		= 	_this select 3;
_player 		= 	_this select 4;
_clientKey 		= 	_this select 5;
_type 			= 	typeOf _object;
_playerUID 		= 	getPlayerUID _player;

_exitReason 	= 	[_this,"PublishObj",(_worldspace select 1),_clientKey,_playerUID,_player] call server_verifySender;
if (_exitReason != "") exitWith
{
	diag_log _exitReason
};

if ([_object, "Server"] call check_publishobject) then
{
	_objectUID 	= 	_worldspace call dayz_objectUID2;
	_object setVariable ["ObjectUID", _objectUID, true];
	_key 		= 	str formatText["CHILD:308:%1:%2:%3:%4:%5:%6:%7:%8:%9:",dayZ_instance, _type, 0, _characterID, _worldspace call AN_fnc_formatWorldspace, _inventory, [], 0,_objectUID];

	_key call server_hiveWrite;

	if !(_object isKindOf "TrapItems") then
	{
		if (DZE_GodModeBase && {!(_type in DZE_GodModeBaseExclude)}) then
		{
			_object addEventHandler ["HandleDamage", {false}];
		}
		else
		{
			_object addMPEventHandler ["MPKilled",{_this call vehicle_handleServerKilled;}];
		};
	};

	_object enableSimulation false;
	dayz_serverObjectMonitor set [count dayz_serverObjectMonitor,_object];

	#ifdef OBJECT_DEBUG
	diag_log format["[СЕРВЕР]: [server_publishObject.sqf]: [ПУБЛИКАЦИЯ]: Игрок %1(%2) создал %3 с UID:%4 CID:%5 @%6 Инвентарь: %7",(_player call fa_plr2str),_playerUID,_type,_objectUID,_characterID,((_worldspace select 1) call fa_coor2str),_inventory];
	#endif
}
else
{
	#ifdef OBJECT_DEBUG
	diag_log ("[СЕРВЕР]: [server_publishObject.sqf]: [ПУБЛИКАЦИЯ]: *НЕ* создано " + (_type ) + " (Не разрешено)");
	#endif
};
