#include "\z\addons\dayz_server\compile\server_toggle_debug.hpp"

local _character 		= 	_this select 0;
local _magazines 		= 	_this select 1;
local _dayz_onBack 		= 	_this select 2;
local _weaponsPlayer 	= 	_this select 3; 
local _characterID 		= 	_character getVariable ["characterID","0"];
local _playerUID 		= 	getPlayerUID _character;
local _charPos 			= 	getPosATL _character;
local _isInVehicle 		= 	vehicle _character != _character;
local _timeSince 		= 	0;
local _humanity 		= 	0;
local _name 			= 	if (alive _character) then
							{
								name _character
							}
							else
							{
								"Dead Player"
							};
local _inDebug 			= 	(respawn_west_original distance _charPos) < 1500;

local _exitReason = call {
	if (isNil "_characterID") exitwith
	{
		("[СЕРВЕР]: [server_playerSync.sqf]: [СИНХРОНИЗАЦИЯ]: [ОШИБКА]: Невозможно синхронизировать игрока " + _name + " имеет Ноль в characterID")
	};

	if (_inDebug) exitwith
	{
		format["[СЕРВЕР]: [server_playerSync.sqf]: [СИНХРОНИЗАЦИЯ]: Невозможно синхронизировать игрока %1 рядом с respawn_west %2. Это нормально при Перезаходе или когда игрок Переодевается.",_name,_charPos]
	};

	if (_characterID == "0") exitwith
	{
		("[СЕРВЕР]: [server_playerSync.sqf]: [СИНХРОНИЗАЦИЯ]: [ОШИБКА]: Невозможно синхронизировать игрока " + _name + " не имеет characterID")
	};

	if (_character isKindOf "Animal") exitwith
	{
		("[СЕРВЕР]: [server_playerSync.sqf]: [СИНХРОНИЗАЦИЯ]: [ОШИБКА]: Невозможно синхронизировать игрока " + _name + " является классом Животных")
	};

	"none";
};

if (_exitReason != "none") exitWith
{
	diag_log _exitReason;
};

// Проверим для игрока все обновления переменных
local _playerPos 		= 	[];
local _playerGear 		=	[];
local _playerBackp 		= 	[];
local _medical 			= 	[];
local _distanceFoot 	= 	0;

// Все getVariable
local _globalCoins 		= 	_character getVariable ["globalMoney", -1];
local _bankCoins 		= 	_character getVariable ["bankMoney", -1];
local _coins 			= 	_character getVariable ["cashMoney", -1];
local _lastPos 			= 	_character getVariable ["lastPos",_charPos];
local _usec_Dead 		= 	_character getVariable ["USEC_isDead",false];
local _lastTime 		= 	_character getVariable ["lastTime",-1];
local _modelChk 		= 	_character getVariable ["model_CHK",""];
local _temp 			= 	round (_character getVariable ["temperature",100]);
local _lastMagazines 	= 	_character getVariable ["ServerMagArray",[[],"",[]]];
local _statsDiff 		= 	[_character,_playerUID] call server_getStatsDiff;
_humanity 				= 	_statsDiff select 0;
local _kills 			= 	_statsDiff select 1;
local _headShots 		= 	_statsDiff select 2;
local _killsH 			= 	_statsDiff select 3;
local _killsB 			= 	_statsDiff select 4;
local _charPosLen 		= 	count _charPos;
local _magTemp 			= 	[];

if (!isNil "_magazines") then
{
	_playerGear 	= 	[_weaponsPlayer,_magazines,_dayz_onBack];
	_character setVariable["ServerMagArray",[_magazines,_dayz_onBack,_weaponsPlayer], false];
}
else
{
	// Проверим Обойму каждый раз когда они не посылают player_forceSave
	_magTemp 	= 	(_lastMagazines select 0);
	if (isNil "_dayz_onBack") then
	{	
		_dayz_onBack 	= 	_lastMagazines select 1; 
	};

	if (isNil "_weaponsPlayer") then
	{	
		_weaponsPlayer 	= 	_lastMagazines select 2; 
	};

	if (count _magTemp > 0) then
	{
		_magazines 	= 	[(magazines _character),20] call array_reduceSize;
		{
			local _class 	= 	_x;

			if (typeName _x == "ARRAY") then
			{
				_class = _x select 0;
			};

			if (_class in _magazines) then
			{
				local _MatchedCount 	=
				{
					_compare = if (typeName _x == "ARRAY") then
								{
									_x select 0;
								}
								else
								{
									_x
								};
								_compare == _class
				} count _magTemp;

				local _CountedActual 	=
				{
					_x == _class
				} count _magazines;

				if (_MatchedCount > _CountedActual) then
				{
					_magTemp set [_forEachIndex, "0"];
				};
			}
			else 
			{
				_magTemp set [_forEachIndex, "0"];
			};
		} forEach (_lastMagazines select 0);

		_magazines 		= 	_magTemp - ["0"];
		_magazines 		= 	[_magazines,_dayz_onBack,_weaponsPlayer];
		_character setVariable["ServerMagArray",_magazines, false];
		_playerGear 	= 	[_magazines select 2,_magazines select 0,_magazines select 1];
	}
	else
	{
		_magazines 	= 	[_magTemp,_dayz_onBack,_weaponsPlayer];
	};

	_character setVariable["ServerMagArray",_magazines, false];
	_playerGear 	= 	[_magazines select 2,_magazines select 0,_magazines select 1];
};

// Проверим если Обновление запрошено
if !((_charPos select 0 == 0) && (_charPos select 1 == 0)) then
{
	// Позиция не Ноль
	_playerPos 	= 	[round (direction _character),_charPos];
	if (count _lastPos > 2 && {_charPosLen > 2}) then
	{
		if (!_isInVehicle) then
		{
			_distanceFoot = round (_charPos distance _lastPos);
		};
		_character setVariable["lastPos",_charPos];
	};
	if (_charPosLen < 3) then {_playerPos = [];};
};

// Проверим рюкзак игрока каждый раз при синхронизации
local _backpack 	= 	unitBackpack _character;
_playerBackp 		= 	[typeOf _backpack,getWeaponCargo _backpack,getMagazineCargo _backpack];

if (!_usec_Dead) then
{
	_medical 	= 	_character call player_sumMedical;
};

_character addScore _kills;

local _timeLeft 	= 	0;
if (_lastTime == -1) then
{
	_character setVariable ["lastTime",diag_tickTime,false];
}
else
{
	local _timeGross 	= 	(diag_tickTime - _lastTime);
	_timeSince 			= 	floor (_timeGross / 60);
	_timeLeft 			= 	(_timeGross - (_timeSince * 60));
};
/*
	Получим данные игрока детально
*/
local _currentWpn 		= 	currentMuzzle _character;
local _currentAnim 		= 	animationState _character;
local _config 			= 	configFile >> "CfgMovesMaleSdr" >> "States" >> _currentAnim;
local _onLadder 		= 	(getNumber (_config >> "onLadder")) == 1;
local _isTerminal 		= 	(getNumber (_config >> "terminal")) == 1;
local _currentModel 	= 	typeOf _character;
if (_currentModel == _modelChk) then
{
	_currentModel 	= 	"";
}
else
{
	_currentModel 	= 	str _currentModel;
	_character setVariable ["model_CHK",typeOf _character];
};

// Если игрок в технике Обновим позицию игрока
if (vehicle _character != _character) then
{
	[vehicle _character, "position"] call server_updateObject;
};

if (count _this > 4) then
{
	if (_this select 4) then
	{
		_medical set [1, true]; // set unconcious to true
		_medical set [10, 150]; // combat timeout
	};

	if (_isInVehicle) then
	{
		// Если игрок сидел в технике, то высадим его
		local _relocate 	= 	((vehicle _character isKindOf "Air") && (_charPos select 2 > 1.5));
		_character action ["eject", vehicle _character];

		// Защита от Перезахода на парашюте или Летной технике чтобы попасть в чужую базу
		if (_relocate) then
		{
			local _count 	= 	0;
			local _maxDist 	= 	800;
			local _newPos 	= 	[_charPos, 80, _maxDist, 10, 1, 0, 0, [], [_charPos,_charPos]] call BIS_fnc_findSafePos;

			while {_newPos distance _charPos == 0} do {
				_count 	= 	_count + 1;
				if (_count > 4) exitWith
				{
					_newPos = _charPos;
				};
				_newPos = [_charPos, 80, (_maxDist + 800), 10, 1, 0, 0, [], [_charPos,_charPos]] call BIS_fnc_findSafePos;
			};
			_newPos set [2,0]; // findSafePos только вернет 2 элемента
			_charPos = _newPos;
			diag_log format["[СЕРВЕР]: [server_playerSync.sqf]: [СИНХРОНИЗАЦИЯ]: [ЗАЩИТА ОТ ПЕРЕЗАХОДА]: Игрок: %1(%2) вышел из сервера находясь в Летной технике. Переопределяем его позицию на safePos %3 - %4.",_name,_playerUID,mapGridPosition _charPos,_charPos];
		};
	};
};

if (_onLadder or _isInVehicle or _isTerminal) then
{
	_currentAnim 	= 	"";

	if ((count _playerPos > 0) && !_isTerminal) then
	{
		_charPos set [2,0];
		_playerPos set [1,_charPos];
	};
};

if (_isInVehicle) then
{
	_currentWpn 	= 	"";
}
else
{
	if (typeName _currentWpn == "STRING") then
	{
		local _muzzles 	= 	getArray (configFile >> "cfgWeapons" >> _currentWpn >> "muzzles");

		if (count _muzzles > 1) then
		{
			_currentWpn 	= 	currentMuzzle _character;
		};
	}
	else
	{
		_currentWpn 	= 	"";
	};
};
local _currentState 	= 	[[_currentWpn,_currentAnim,_temp],[]];

// Сбросим таймер
if (_timeSince > 0) then
{
	_character setVariable ["lastTime",(diag_ticktime - _timeLeft)];
};

/*
	Все готово! Теперь отправляем все данные в Базу Данных
	Низкий приоритет кода ниже где _character object ничего не нужно и он может быть Null.
*/
if (count _playerPos > 0) then
{
	local _array 	= 	[];
	{
		if (_x > dayz_minpos && _x < dayz_maxpos) then
		{
			_array set [count _array,_x];
		};
	} forEach (_playerPos select 1);
	_playerPos set [1,_array];
};

local _key = if (Z_SingleCurrency) then
{
	str formatText["CHILD:201:%1:%2:%3:%4:%5:%6:%7:%8:%9:%10:%11:%12:%13:%14:%15:%16:%17:",_characterID,_playerPos,_playerGear,_playerBackp,_medical,false,false,_kills,_headShots,_distanceFoot,_timeSince,_currentState,_killsH,_killsB,_currentModel,_humanity,_coins]
}
else
{
	str formatText["CHILD:201:%1:%2:%3:%4:%5:%6:%7:%8:%9:%10:%11:%12:%13:%14:%15:%16:",_characterID,_playerPos,_playerGear,_playerBackp,_medical,false,false,_kills,_headShots,_distanceFoot,_timeSince,_currentState,_killsH,_killsB,_currentModel,_humanity]
};

#ifdef PLAYER_DEBUG
	diag_log str formatText["[СЕРВЕР]: [server_playerSync.sqf]: [СИНХРОНИЗАЦИЯ]: [ИНФОРМАЦИЯ]: %2(UID:%4,CID:%3) PlayerSync, %1",_key,_name,_characterID,_playerUID];
#endif
_key call server_hiveWrite;

if (Z_SingleCurrency) then
{
	_key 	= 	str formatText["CHILD:205:%1:%2:%3:%4:",_playerUID,dayZ_instance,_globalCoins,_bankCoins];
	_key call server_hiveWrite;
};

{
	[_x,"gear"] call server_updateObject;
} count nearestObjects [[_character] call FNC_GetPos,DayZ_GearedObjects,10];
