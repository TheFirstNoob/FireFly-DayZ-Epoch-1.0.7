private ["_legacyStreamingMethod","_hiveLoaded","_timeStart","_i","_key","_result","_shutdown","_res","_myArray","_val","_status","_fileName","_lastFN",
		"_VehicleQueue","_vQty","_idKey","_type","_ownerID","_worldspace","_inventory","_damage","_storageMoney","_vector","_vecExists","_ownerPUID",
		"_wsCount","_ws2TN","_ws3TN","_dir","_posATL","_wsDone","_object","_doorLocked","_isPlot","_isTrapItem","_isSafeObject",
		"_weaponcargo","_magcargo","_backpackcargo","_weaponqty","_magqty","_backpackqty","_lockable","_codeCount","_codeCount","_isTrapItem","_xTypeName","_x1",
		"_isAir","_selection","_dam","_hitpoints","_fuel","_pos"];

#include "\z\addons\dayz_server\compile\server_toggle_debug.hpp"

waitUntil {!isNil "BIS_MPF_InitDone" && initialized};
if (!isNil "sm_done") exitWith {}; 	// Недопускает чтобы server_monitor был вызван дважды (Такой баг происходит при первом запуске игроком)
sm_done 	= 	false;

_legacyStreamingMethod 	= 	false; // Использовать Старый метод обработки? Он более защищен, но гораздо медленнее и зависит от ограничений размера CallExtention.

dayz_serverIDMonitor 	= 	[];
DZE_LockedSafes 		= 	[]; 	// Для Modules/Abadoned_Safes.sqf
dayz_versionNo 			= 	getText (configFile >> "CfgMods" >> "DayZ" >> "version");
dayz_hiveVersionNo 		= 	getNumber (configFile >> "CfgMods" >> "DayZ" >> "hiveVersion");
_hiveLoaded 			= 	false;
_serverVehicleCounter 	= 	[];

diag_log "[БАЗА ДАННЫХ]: [server_monitor.sqf]: ЗАПУСК...";

// Обработка потока для объектов

// Посылаем ключ
_timeStart = diag_tickTime;

for "_i" from 1 to 5 do {

	diag_log "[БАЗА ДАННЫХ]: [server_monitor.sqf]: Попытка получить объекты";

	_key 		= 	format["CHILD:302:%1:%2:",dayZ_instance, _legacyStreamingMethod];
	_result 	= 	_key call server_hiveReadWrite;

	if (typeName _result == "STRING") then
	{
		_shutdown 	= 	format["CHILD:400:%1:",(profileNamespace getVariable "SUPERKEY")];
		_res 		= 	_shutdown call server_hiveReadWrite;

		diag_log ("[БАЗА ДАННЫХ]: [server_monitor.sqf]: Попытка остановки.. HiveExt ответ:"+str(_res));
	}
	else
	{
		diag_log ("[БАЗА ДАННЫХ]: [server_monitor.sqf]: Найдено: "+str(_result select 1)+" объектов" );
		_i 	= 	99; // Стоп
	};
};

if (typeName _result == "STRING") exitWith
{
	diag_log "[БАЗА ДАННЫХ]: [server_monitor.sqf]: !!!ОШИБКА СОЕДИНЕНИЯ!!! Server_monitor.sqf вышел.";
};

diag_log "[БАЗА ДАННЫХ]: [server_monitor.sqf]: Отправка запроса";

_myArray 	= 	[];
_val 		= 	0;
_status 	= 	_result select 0; // Результат процесса
_val 		= 	_result select 1;

if (_legacyStreamingMethod) then
{
	if (_status == "ObjectStreamStart") then
	{
		profileNamespace setVariable ["SUPERKEY",(_result select 2)];
		_hiveLoaded 	= 	true;

		// Обработка потока для объектов
		diag_log ("[БАЗА ДАННЫХ]: [server_monitor.sqf]: Начат поток передачи объектов...");

		for "_i" from 1 to _val do {
			_result 	= 	_key call server_hiveReadWriteLarge;
			_status 	= 	_result select 0;
			_myArray set [count _myArray,_result];
		};
	};
}
else
{
	if (_val > 0) then
	{
		_fileName 	= 	_key call server_hiveReadWrite;
		_lastFN 	= 	profileNamespace getVariable["lastFN",""];
		profileNamespace setVariable["lastFN",_fileName];
		saveProfileNamespace;

		if (_status == "ObjectStreamStart") then
		{
			profileNamespace setVariable ["SUPERKEY",(_result select 2)];
			_hiveLoaded 	= 	true;
			_myArray 		= 	Call Compile PreProcessFile _fileName;
			_key 			= 	format["CHILD:302:%1:%2:",_lastFN,_legacyStreamingMethod];
			_result 		= 	_key call server_hiveReadWrite; 	// Удаляет старый Дамп объектов
		};
	}
	else
	{
		if (_status == "ObjectStreamStart") then
		{
			profileNamespace setVariable ["SUPERKEY",(_result select 2)];
			_hiveLoaded 	= 	true;
		};
	};
};

// Сначала обработка Объектов, после загрузка Техники
_VehicleQueue 	= 	[];
_vQty 			= 	0;
diag_log ("[БАЗА ДАННЫХ]: [server_monitor.sqf]: Обработано: " + str(count _myArray) + " объектов.");

// Не создаем объекты если Нет игроков онлайн (createVehicle падает в ошибку: Ref to nonnetwork object)
if ((playersNumber west + playersNumber civilian) == 0) exitWith
{
	diag_log "[СЕРВЕР]: [server_monitor.sqf]: Все Игроки вышли из сервера. Server_monitor.sqf - выход.";
};

// Создаем объекты
{
	// Разбор массива
	_idKey 			= 	_x select 1;
	_type 			= 	_x select 2;
	_ownerID 		= 	_x select 3;
	_worldspace 	= 	_x select 4;
	_inventory 		= 	_x select 5;
	_damage 		= 	_x select 8;
	_storageMoney 	= 	_x select 9;

	if ((_type isKindOf "AllVehicles")) then
	{
		_VehicleQueue set [_vQty,_x];
		_vQty 	= 	_vQty + 1;
	}
	else
	{
		_dir 		= 	90;
		_pos 		= 	[0,0,0];
		_wsDone 	= 	false;
		_wsCount 	= 	count _worldspace;

		// Векторная стройка
		_vector 	= 	[[0,0,0],[0,0,0]];
		_vecExists 	= 	false;
		_ownerPUID 	= 	"0";

		call {
			if (_wsCount == 4) exitwith
			{
				_dir 		= 	_worldspace select 0;
				_posATL 	= 	_worldspace select 1;

				if (count _posATL == 3) then
				{
					_pos 		= 	_posATL;
					_wsDone 	= 	true;
				};

				_ws2TN 	= 	typename (_worldspace select 2);
				_ws3TN 	= 	typename (_worldspace select 3);

				if (_ws3TN == "STRING") then
				{
					_ownerPUID 	= 	_worldspace select 3;
				}
				else
				{
					if (_ws2TN == "STRING") then
					{
						_ownerPUID 	= 	_worldspace select 2;
					};
				};

				if (_ws2TN == "ARRAY") then
				{
					_vector 	= 	_worldspace select 2;
					_vecExists 	= 	true;
				}
				else
				{
					if (_ws3TN == "ARRAY") then
					{
						_vector 	= 	_worldspace select 3;
						_vecExists 	= 	true;
					};
				};
			};

			if (_wsCount == 3) exitwith
			{
				_dir 		= 	_worldspace select 0;
				_posATL 	= 	_worldspace select 1;

				if (count _posATL == 3) then
				{
					_pos 		= 	_posATL;
					_wsDone 	= 	true;
				};

				_ws2TN 	= 	typename (_worldspace select 2);
				_ws3TN 	= 	typename (_worldspace select 3);

				if (_ws2TN == "STRING") then
				{
					_ownerPUID 	= 	_worldspace select 2;
				}
				else
				{
					 if (_ws2TN == "ARRAY") then
					 {
						_vector 	= 	_worldspace select 2;
						_vecExists 	= 	true;
					};
				};
			};

			if (_wsCount == 2) then
			{
				_dir 		= 	_worldspace select 0;
				_posATL 	= 	_worldspace select 1;

				if (count _posATL == 3) then
				{
					_pos 		= 	_posATL;
					_wsDone 	= 	true;
				};
			};

			if (_wsCount < 2) exitwith
			{
				_worldspace set [count _worldspace,"0"];
			};
		};

		if (!_wsDone) then
		{
			if ((count _posATL) >= 2) then
			{
				_pos 	= 	[_posATL select 0,_posATL select 1,0];

				diag_log format["[СЕРВЕР]: [server_monitor.sqf]: [ПЕРЕМЕЩЕНИЕ ОБЪЕКТА]: Ключ: %1 Класса: %2 с worldspace массивом = %3 На позицию: %4",_idKey,_type,_worldspace,_pos];
			}
			else
			{
				diag_log format["[СЕРВЕР]: [server_monitor.sqf]: [ПЕРЕМЕЩЕНИЕ ОБЪЕКТА]: Ключ: %1 Класса: %2 с worldspace массивом = %3 На позицию: [0,0,0]",_idKey,_type,_worldspace];
			};
		};

		_object 	= 	_type createVehicle [0,0,0]; 	// Более чем в 2 раза быстрее, чем массив createvehicle
		_object setDamage _damage;

		if (_vecExists) then
		{
			_object setVectorDirAndUp _vector;
		}
		else
		{
			_object setDir _dir; // setdir несовместим с setVectorDirAndUp и не должен использоваться вместе на одном и том же объекте https://community.bistudio.com/wiki/setVectorDirAndUp
		};
		_object enableSimulation false;
		_object setPosATL _pos;

		_doorLocked 	= 	_type in DZE_DoorsLocked;
		_isPlot 		= 	_type == "Plastic_Pole_EP1_DZ";

		// Недопускаем моментальную Запись в Базу Данных при установке детали
		_object setVariable ["lastUpdate",diag_ticktime];
		_object setVariable ["ObjectID",_idKey,true];
		_object setVariable ["OwnerPUID",_ownerPUID,true];

		if (Z_SingleCurrency && {_type in DZE_MoneyStorageClasses}) then
		{
			_object setVariable ["cashMoney",_storageMoney,true];
		};

		dayz_serverIDMonitor set [count dayz_serverIDMonitor,_idKey];

		if (!_wsDone) then
		{
			[_object,"position",true] call server_updateObject;
		};

		if (_type == "Base_Fire_DZ") then
		{
			_object spawn base_fireMonitor;
		};

		if (_type in ["VaultStorageLocked","VaultStorage2Locked","TallSafeLocked"]) then
		{
			DZE_LockedSafes set [count DZE_LockedSafes,_object];
		};

		_isTrapItem 	= 	_object isKindOf "TrapItems";
		_isSafeObject 	= 	_type in DayZ_SafeObjects;

		// Отключаем Инвентарь ловушкам
		if (!_isTrapItem) then
		{
			clearWeaponCargoGlobal _object;
			clearMagazineCargoGlobal _object;
			clearBackpackCargoGlobal _object;

			if ((count _inventory > 0) && !_isPlot && !_doorLocked) then
			{
				if (_type in DZE_LockedStorage) then
				{
					// Не посылайте большие массивы через Интернет-Сервер! Только серверу нужен этот массив
					_object setVariable ["WeaponCargo",(_inventory select 0),false];
					_object setVariable ["MagazineCargo",(_inventory select 1),false];
					_object setVariable ["BackpackCargo",(_inventory select 2),false];
				}
				else
				{
					_weaponcargo 	= 	_inventory select 0 select 0;
					_magcargo 		= 	_inventory select 1 select 0;
					_backpackcargo 	= 	_inventory select 2 select 0;
					_weaponqty 		= 	_inventory select 0 select 1;
					{
						_object addWeaponCargoGlobal [_x, _weaponqty select _foreachindex];
					} foreach _weaponcargo;

					_magqty 	= 	_inventory select 1 select 1;

					{
						if (_x != "CSGAS") then
						{
							_object addMagazineCargoGlobal [_x, _magqty select _foreachindex];
						};
					} foreach _magcargo;

					_backpackqty 	= 	_inventory select 2 select 1;
					{
						_object addBackpackCargoGlobal [_x, _backpackqty select _foreachindex];
					} foreach _backpackcargo;
				};
			}
			else
			{
				if (DZE_permanentPlot && _isPlot) then
				{
					_object setVariable ["plotfriends",_inventory,true];
				};

				if (DZE_doorManagement && _doorLocked) then
				{
					_object setVariable ["doorfriends",_inventory,true];
				};
			};
		};

		// Исправление проблемы с Ведушими нулями в кодах от Сейфа после перезапуска сервера
		_lockable 	= 	getNumber (configFile >> "CfgVehicles" >> _type >> "lockable");
		_codeCount 	= 	count (toArray _ownerID);

		call {
			if (_lockable == 4) exitwith
			{
				call {
					if (_codeCount == 3) exitwith {_ownerID = format["0%1",_ownerID];};
					if (_codeCount == 2) exitwith {_ownerID = format["00%1",_ownerID];};
					if (_codeCount == 1) exitwith {_ownerID = format["000%1",_ownerID];};
				};
			};

			if (_lockable == 3) exitwith
			{
				call {
					if (_codeCount == 2) exitwith {_ownerID = format["0%1",_ownerID];};
					if (_codeCount == 1) exitwith {_ownerID = format["00%1",_ownerID];};
				};
			};
		};

		_object setVariable ["CharacterID", _ownerID, true];

		if (_isSafeObject && !_isTrapItem) then
		{
			_object setVariable["memDir",_dir,true];

			if (DZE_GodModeBase && {!(_type in DZE_GodModeBaseExclude)}) then
			{
				_object addEventHandler ["HandleDamage",{false}];
			}
			else
			{
				_object addMPEventHandler ["MPKilled",{_this call vehicle_handleServerKilled;}];
			};

			_object setVariable ["OEMPos",_pos,true]; 	// Используется для обновления позиции сейфа при Открыть/Закрыть
		}
		else
		{
			_object enableSimulation true;
		};

		if (_isTrapItem) then
		{
			// Используем инвентарь для Взведенных ловушек
			{
				_xTypeName = typeName _x;

				if (_xTypeName == "ARRAY") then
				{
					_x1 	= 	_x select 1;
 					_object setVariable ["armed", _x1, true];
				}
				else
				{
					_object setVariable ["armed", _x, true];
				};
			} count _inventory;
		};
		dayz_serverObjectMonitor set [count dayz_serverObjectMonitor,_object]; 	// Мониторим объект
	};
} foreach _myArray;

// Создаем технику
{
	// Разбор массива
	_idKey 			= 	_x select 1;
	_type 			= 	_x select 2;
	_ownerID 		= 	_x select 3;
	_worldspace 	= 	_x select 4;
	_inventory 		= 	_x select 5;
	_hitPoints 		= 	_x select 6;
	_fuel 			= 	_x select 7;
	_damage 		= 	_x select 8;
	_storageMoney 	= 	_x select 9;

	_dir 		= 	90;
	_pos 		= 	[0,0,0];
	_wsDone 	= 	false;
	_wsCount 	= 	count _worldspace;

	call {
		if (_wsCount == 2) exitwith
		{
			_dir 		= 	_worldspace select 0;
			_posATL 	= 	_worldspace select 1;

			if (count _posATL == 3) then
			{
				_pos 		= 	_posATL;
				_wsDone 	= 	true;
			};
		};

		if (_wsCount < 2) exitwith
		{
			_worldspace set [count _worldspace,"0"];
		};
	};

	if (!_wsDone) then
	{
		if ((count _posATL) >= 2) then
		{
			_pos 	= 	[_posATL select 0,_posATL select 1,0];

			diag_log format["[СЕРВЕР]: [server_monitor.sqf]: [ПЕРЕМЕЩЕНИЕ ОБЪЕКТА]: Ключ: %1 Класса: %2 с worldspace массивом = %3 На позицию: %4",_idKey,_type,_worldspace,_pos];
		}
		else
		{
			diag_log format["[СЕРВЕР]: [server_monitor.sqf]: [ПЕРЕМЕЩЕНИЕ ОБЪЕКТА]: Ключ: %1 Класса: %2 с worldspace массивом = %3 На позицию: [0,0,0]",_idKey,_type,_worldspace];
		};
	};

	_object 	= 	_type createVehicle [0,0,0]; 	// Более чем в 2 раза быстрее, чем массив createvehicle
	_object setDir _dir;
	_object setPosATL _pos;
	_object setDamage _damage;
	_object enableSimulation false;

	// Недопускаем моментальную Запись в Базу Данных при установке детали автомобиля
	_object setVariable ["lastUpdate",diag_ticktime];
	_object setVariable ["ObjectID",_idKey,true];

	if (Z_SingleCurrency && ZSC_VehicleMoneyStorage) then
	{
		_object setVariable ["cashMoney",_storageMoney,true];
	};

	dayz_serverIDMonitor set [count dayz_serverIDMonitor,_idKey];

	if (!_wsDone) then
	{
		[_object,"position",true] call server_updateObject;
	};

	clearWeaponCargoGlobal _object;
	clearMagazineCargoGlobal _object;
	clearBackpackCargoGlobal _object;
	
	if (count _inventory > 0) then
	{
		_weaponcargo 	= 	_inventory select 0 select 0;
		_magcargo 		= 	_inventory select 1 select 0;
		_backpackcargo 	= 	_inventory select 2 select 0;
		_weaponqty 		= 	_inventory select 0 select 1;
		{
			_object addWeaponCargoGlobal [_x, _weaponqty select _foreachindex];
		} foreach _weaponcargo;

		_magqty 	= 	_inventory select 1 select 1;

		{
			if (_x != "CSGAS") then
			{
				_object addMagazineCargoGlobal [_x, _magqty select _foreachindex];
			};
		} foreach _magcargo;

		_backpackqty 	= 	_inventory select 2 select 1;

		{
			_object addBackpackCargoGlobal [_x, _backpackqty select _foreachindex];
		} foreach _backpackcargo;
	};

	_object setVariable ["CharacterID", _ownerID, true];
	_isAir 	= 	_object isKindOf "Air";

	{
		_selection 	= 	_x select 0;
		_dam 		= 	[_x select 1,(_x select 1) min 0.8] select (!_isAir && {_selection in dayZ_explosiveParts});
		_object setHit [_selection,_dam];
	} count _hitpoints;
	[_object,"damage"] call server_updateObject;

	_object setFuel _fuel;
	_object call fnc_veh_ResetEH;

	if (_ownerID != "0" && {!(_object isKindOf "Bicycle")}) then
	{
		_object setVehicleLock "locked";
	};

	_serverVehicleCounter set [count _serverVehicleCounter,_type]; 	// Общее количество техники
	_object enableSimulation true;
	_object setVelocity [0,0,1];
	dayz_serverObjectMonitor set [count dayz_serverObjectMonitor,_object]; 	// Мониторим объект
} foreach _VehicleQueue;

diag_log ("[БАЗА ДАННЫХ]: [server_monitor.sqf]: Обработано " + str((count _myArray) -_vQty) + " Объектов и " + str(_vQty) + " Техники.");

diag_log format["[БАЗА ДАННЫХ]: [server_monitor.sqf]: [BENCHMARK]: Server_monitor.sqf закончил обработку: %1 объектов за %2 секунд (До планировщика)",_val,diag_tickTime - _timeStart];

if (dayz_townGenerator) then
{
	call compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\server_plantSpawner.sqf"; 	// Рисуем Псевдослучайные семена
};
#ifndef OBJECT_DEBUG
	object_debug 	= 	false;
#else
	object_debug 	= 	true;
#endif
execFSM "\z\addons\dayz_server\system\server_vehicleSync.fsm";
execVM "\z\addons\dayz_server\system\scheduler\sched_init.sqf"; 	// Запускаем новый Планировщик
execFSM "\z\addons\dayz_server\system\server_weather.fsm"; 			// Новая система погоды для 1.0.7

createCenter civilian;

actualSpawnMarkerCount = 0;

// Подсчитаем действительные точки возраждения. Т.к. разные карты имеют разное количество точек.
for "_i" from 0 to 10 do {
	if ((getMarkerPos format["spawn%1",_i]) distance [0,0,0] > 0) then
	{
		actualSpawnMarkerCount 	= 	actualSpawnMarkerCount + 1;
	}
	else
	{
		_i 	= 	11; 	// Заканчиваем т.к. не нашли дополнительные точки
	};
};

diag_log format["[СЕРВЕР]: [server_monitor.sqf]: Общее количество точек возрождения: %1", actualSpawnMarkerCount];

if (isDedicated) then
{
	endLoadingScreen;
};

[] call compile preprocessFileLineNumbers "\z\addons\dayz_server\DZAI\init\dzai_initserver.sqf";
allowConnection 	= 	true;
sm_done 			= 	true;
publicVariable "sm_done";

execVM "\z\addons\dayz_server\system\lit_fireplaces.sqf";

if (_hiveLoaded) then
{
	_serverVehicleCounter spawn
	{
		private ["_startTime","_cfgLootFile","_vehLimit"];
		// Создаем технику
		// Получим все Здания и дороги всего один раз. Это очень долгий процесс, но только при первом запуске сервера
		_serverVehicleCounter 	= 	_this;
		_vehiclesToUpdate 		= 	[];
		_startTime 				= 	diag_tickTime;
		_buildingList 			= 	[];
		_cfgLootFile 			= 	missionConfigFile >> "CfgLoot" >> "Buildings";
		{
			if (isClass (_cfgLootFile >> typeOf _x)) then
			{
				_buildingList set [count _buildingList,_x];
			};
		} count (getMarkerPos "center" nearObjects ["building",((getMarkerSize "center") select 1)]);
		_roadList 	= 	getMarkerPos "center" nearRoads ((getMarkerSize "center") select 1);
		//diag_log format ["[СЕРВЕР]: [server_monitor.sqf]: _serverVehicleCounter: %1",_serverVehicleCounter];
		_vehLimit 	= 	MaxVehicleLimit - (count _serverVehicleCounter);

		if (_vehLimit > 0) then
		{
			diag_log ("[БАЗА ДАННЫХ]: [server_monitor.sqf]: Создаю Техники: " + str(_vehLimit));
			for "_x" from 1 to _vehLimit do {call spawn_vehicles;};
		}
		else
		{
			diag_log "[БАЗА ДАННЫХ]: [server_monitor.sqf]: Достингут лимит создания Техники!";
			_vehLimit 	= 	0;
		};

		if (dayz_townGenerator) then
		{
			// Стандартная генерация Остовов для каждого клиента.
			MaxDynamicDebris 	= 	0;
		}
		else
		{
			// Epoch глобальная генерация Остовов (Мусора, Огорождений)
			diag_log ("[БАЗА ДАННЫХ]: [server_monitor.sqf]: Создаю Остовов/Мусора: " + str(MaxDynamicDebris));
			for "_x" from 1 to MaxDynamicDebris do {call spawn_roadblocks;};
		};

		diag_log ("[БАЗА ДАННЫХ]: [server_monitor.sqf]: Создаю Ящики с патронами: " + str(MaxAmmoBoxes));
		for "_x" from 1 to MaxAmmoBoxes do {call spawn_ammosupply;};

		diag_log ("[БАЗА ДАННЫХ]: [server_monitor.sqf]: Создаю Рудные жилы: " + str(MaxMineVeins));
		for "_x" from 1 to MaxMineVeins do {call spawn_mineveins;};

		diag_log format["[БАЗА ДАННЫХ]: [server_monitor.sqf]: [BENCHMARK]: СЕРВЕР закончил создание: %1 Техники, %2 Остовов/Мусора, %3 Ящиков с патронами и %4 Рудных жил за %5 секунд (С Планировщиком)",_vehLimit,MaxDynamicDebris,MaxAmmoBoxes,MaxMineVeins,diag_tickTime - _startTime];

		// Обновим снаряжение последним после создания всей Техники для сохранения случайного содержимого в Базе Данных (Низкий приоритет)
		{
			[_x,"gear"] call server_updateObject
		} count _vehiclesToUpdate;
		
		if (DZE_SafeZone_Relocate) then
		{
			execVM "\z\addons\dayz_server\system\safezone_relocate.sqf";
		};
	};
};