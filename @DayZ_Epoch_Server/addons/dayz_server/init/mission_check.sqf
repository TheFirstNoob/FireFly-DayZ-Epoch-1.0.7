/*
	Временная проверка на наличие эксплойта переопределения миссии A2OA.
	Этот Баг должен быть исправлен в следующем End Of Life патче.
*/

// Список файлов в вашей Миссии для проверки. 
// Для определения файлов с Папкой используйте: 'custom\variables.sqf'.
// Удалите то, что не используйте
_files =
[
	'description.ext','init.sqf','mission.sqm','rules.sqf'
];

_list = [];
{
	_file 	= 	toArray (toLower(preprocessFile _x));
	_sum 	= 	0;
	_count 	= 	{
					_sum 	= 	_sum + _x; true
				} count _file;
	
	if (_count > 999999) then
	{
		_count 	= 	_count mod 999999		// Предотвратим техническую запись при конвертации в строку ниже
	};

	if (_sum > 999999) then
	{
		_sum 	= 	_sum mod 999999
	};
	_list set [count _list,[_count,_sum]];
} forEach _files;

// Проверим целостность миссии на всех клиентах
_temp 	= 	"HeliHEmpty" createVehicle [0,0,0];
_temp setVehicleInit (str formatText["
	if (isServer) exitWith {};
	
	_list 	= 	[];
	{
		_file 	= 	toArray (toLower(preprocessFile _x));
		_sum 	= 	0;
		_count 	= 	{
						_sum 	= 	_sum + _x; true
					} count _file;

		if (_count > 999999) then
		{
			_count 	= 	_count mod 999999
		};

		if (_sum > 999999) then
		{
			_sum 	= 	_sum mod 999999
		};
		_list set [count _list,[_count,_sum]];
	} forEach %1;
	
	_file 	= 	-1;
	{
		if ((_x select 0 != (_list select _forEachIndex) select 0) or (_x select 1 != (_list select _forEachIndex) select 1)) then
		{
			_file 	= 	_forEachIndex;
		};
	} forEach %2;

	if (_file != -1) then
	{
		MISSION_CHECK 	= 	if ((_list select _file) select 0 < 49999) then
							{
								preprocessFileLineNumbers (%1 select _file)
							}
							else
							{
								'СЛИШКОМ БОЛЬШОЙ'
							};
		publicVariableServer 'MISSION_CHECK';

		[] spawn {
			uiSleep 1;

			{
				(findDisplay _x) closeDisplay 2;
			} count [0,8,12,18,46,70];
		};
	};
",_files,_list]);

processInitCommands;