/*
[_objectID,_objectUID,_activatingPlayer,_objPos,dayz_authKey] call server_deleteObj;
For PV calls from the client use this function, otherwise if calling directly from the server use server_deleteObjDirect
*/
private["_id","_uid","_key","_activatingPlayer","_objPos","_clientKey","_exitReason","_PlayerUID","_processDelete"];

if (count _this < 5) exitWith
{
diag_log "[СЕРВЕР]: [Server_DeleteObj.sqf]: [ОШИБКА]: Неверно получены данные. Параметров получено меньше, должно быть 5!";};
_id 				= 	_this select 0;
_uid 				= 	_this select 1;
_activatingPlayer 	= 	_this select 2;
_objPos 			= 	_this select 3; 	// Может быть Оъектом или Позиция если if _processDelete равен false
_clientKey 			= 	_this select 4;
_processDelete 		= 	[true,_this select 5] select (count _this > 5);
_PlayerUID 			= 	getPlayerUID _activatingPlayer;

_exitReason = [_this,"DeleteObj",_objPos,_clientKey,_PlayerUID,_activatingPlayer] call server_verifySender;
if (_exitReason != "") exitWith
{
	diag_log _exitReason
};

if (isServer) then
{
	if (_processDelete) then
	{
		deleteVehicle _objPos
	};

	if (typeName _objPos != "ARRAY") then
	{
		_objPos = typeof _objPos;
	};
	
	// Удаляем из Базы Данных
	if (parseNumber _id > 0) then
	{
		// Отправляем запрос
		_key = format["CHILD:304:%1:",_id];
		_key call server_hiveWrite;
		diag_log format["[СЕРВЕР]: [Server_DeleteObj.sqf]: [УДАЛЕНИЕ]: Игрок: %1(%2) удалил: %4 с ID: %3",(_activatingPlayer call fa_plr2str), _PlayerUID, _id, _objPos];
	}
	else
	{
		// Отправляем запрос
		_key = format["CHILD:310:%1:",_uid];
		_key call server_hiveWrite;
		diag_log format["[СЕРВЕР]: [Server_DeleteObj.sqf]: [УДАЛЕНИЕ]: Игрок: %1(%2) удалил: %4 с UID: %3",(_activatingPlayer call fa_plr2str), _PlayerUID, _uid, _objPos];
	};
};
