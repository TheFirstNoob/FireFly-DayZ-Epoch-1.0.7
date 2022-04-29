/*
	Миссия Заброшенный сейв от Cramps (zfclan.org/forum)
	Модификация для DayZ Epoch 1.0.6+ от JasonTM
	Модификация для DayZ Epoch 1.0.7+ от JasonTM
	Инструкция в конце файла.
	Необходим SQL ивент чтобы устанавливать код для сейфов 0000 - в конце файла.
	Последнее обновление: 06-01-2021
*/

local _spawnChance 	= 	0.5; 				// Вероятность ивента в процентах. Число должно быть от 0 до 1. 1 = вероятность 100%.
local _debug 		= 	true; 			// Включить режим диагностики? (Серверный RPT) (True - Да/False - Нет)
local _toGround 	= 	true; 			// Если сейф находится на высоте более 2 метров над землей, то при установке - True: Сейф будет перемещен на ровную землю.
local _radius 		= 	150; 			// Радиус маркера (В Метрах)
local _type 		= 	"Hint"; 		// Тип вывода оповещения. Параметры: "Hint","TitleText". ***ВНИМАНИЕ: Hint появляется в том же месте экрана, что и обычные Hint где Дебаг монитор.
local _timeout 		= 	360; 			// Время на исчезновение ивента, если игрок не нашел его (В Минутах)

#define TITLE_COLOR "#00FF11" 	// Hint параметры: Цвет верхней линии
#define TITLE_SIZE "2" 			// Hint параметры: Размер верхней линии
#define IMAGE_SIZE "4" 			// Hint параметры: Размер изображения

if (random 1 > _spawnChance && !_debug) exitWith {};

diag_log "[Заброшенный сейф]: Запуск...";

if ((count DZE_LockedSafes) < 1) exitWith
{
	diag_log "[Заброшенный сейф]: На карте нет сейфов.";
};

local _vaults 	= 	[];
local _current 	= 	0;
local _code 	= 	0;

for "_i" from 0 to (count DZE_LockedSafes)-1 do {
	_current 	= 	DZE_LockedSafes select _i;
	_code 		= 	_current getVariable ["CharacterID", "0"];

	if (_code == "0000") then
	{
		_vaults set [count _vaults, _current];
	};
};

if (count _vaults == 0) exitWith
{
	diag_log "[Заброшенный сейф]: На карте нет заброшенных сейфов";
};

if (_debug) then
{
	diag_log format["[Заброшенный сейф]: Количество заброшенных сейфов: %1",count _vaults];
};

if (_type == "Hint") then
{
	local _img 		= 	(getText (configFile >> "CfgMagazines" >> "ItemVault" >> "picture"));
	RemoteMessage 	= 	["hintWithImage",["STR_CL_ESE_VAULT_TITLE","STR_CL_ESE_VAULT"],[_img,TITLE_COLOR,TITLE_SIZE,IMAGE_SIZE]];
}
else
{
	RemoteMessage = ["titleText","STR_CL_ESE_VAULT"];
};
publicVariable "RemoteMessage";

if (_debug) then
{
	diag_log format["[Заброшенный сейф]: Параметры получены. Настройка завершена, Ожидаю %1 минут для timeout", _timeout];
};

local _vault 	= 	_vaults call BIS_fnc_selectRandom;
local _pos 		= 	[_vault] call FNC_GetPos;
local _markers 	= 	[];

if (_toGround) then
{
	if ((_pos select 2) > 2) then
	{
		_pos 	= 	_pos findEmptyPosition[0,100];
		_pos set [2, 0];
		_vault setPos _pos;
		_vault setVariable ["OEMPos",_pos,true];
	};
};

if (_debug) then {diag_log format["[Заброшенный сейф]: Location of randomly picked 0000 vault = %1",_pos];};

//[position,createMarker,setMarkerColor,setMarkerType,setMarkerShape,setMarkerBrush,setMarkerSize,setMarkerText,setMarkerAlpha]
_markers set [0, [_pos, format ["safemark_%1", diag_tickTime], "ColorKhaki", "","ELLIPSE", "", [_radius,_radius], [], 0]];
_markers set [1, [_pos, format ["safedot_%1", diag_tickTime], "ColorBlack", "mil_dot","ICON", "", [], ["STR_CL_ESE_VAULT_TITLE"], 0]];
DZE_ServerMarkerArray set [count DZE_ServerMarkerArray, _markers]; // Маркера добавляются в запросы JIP игроков.
local _markerIndex 		= 	count DZE_ServerMarkerArray - 1;
PVDZ_ServerMarkerSend 	= 	["start",_markers];
publicVariable "PVDZ_ServerMarkerSend";

uiSleep (_timeout * 60);

// Передаем всем клиентам что маркер нужно удалить
local _remove 	= 	[];
{
	_remove set [count _remove, (_x select 1)];
} count _markers;
PVDZ_ServerMarkerSend 	= 	["end",_remove];
publicVariable "PVDZ_ServerMarkerSend";
DZE_ServerMarkerArray set [_markerIndex, -1];

diag_log "[Заброшенный сейф]: Завершено!";

/*
	****Специальная инструкция (УЖЕ ПРОПИСАНО В СБОРКЕ!)****
	Откройте server_monitor.sqf
	
	Найдите строку:
	dayz_serverIDMonitor = [];
	
	Добавьте эту строчку ниже:
	DZE_LockedSafes = [];
	
	Найдите строку:
	_isTrapItem = _object isKindOf "TrapItems";
	
	Добавьте эту строку над ней:
	if (_type in [VaultStorageLocked","VaultStorage2Locked","TallSafeLocked]) then
	{
		DZE_LockedSafes set [count DZE_LockedSafes, _object];
	};

	****Запустите этот запрос в своей базе данных, чтобы сбросить код неактивных сейфов на 0000. Можете использовать Ивентом в Базе Данных****

	DROP EVENT IF EXISTS resetVaults; CREATE EVENT resetVaults
	   ON SCHEDULE EVERY 1 DAY
	   COMMENT 'Установить на сейфы код 0000 Если он не был активен 14 дней'
	   DO
	UPDATE `object_data` SET `CharacterID` = 0
	WHERE
	`LastUpdated` < DATE_SUB(CURRENT_TIMESTAMP, INTERVAL 14 DAY) AND
	`Datestamp` < DATE_SUB(CURRENT_TIMESTAMP, INTERVAL 14 DAY) AND
	`CharacterID` > 0 AND
	`Classname` IN ('VaultStorageLocked','VaultStorage2Locked','TallSafeLocked') AND
	`Inventory` <> '[]' AND
	`Inventory` IS NOT NULL
*/