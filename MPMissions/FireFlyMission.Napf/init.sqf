#include "configVariables.sqf" // ВСЕ ПАРАМЕТРЫ И ЗНАЧЕНИЯ КОНФИГУРАЦИИ СЕРВЕРА НАХОДЯТСЯ В ЭТОМ ФАЙЛЕ!!!

// Настройки для Сервера и Клиента
dayz_antihack 	= 	0; 		// DayZ Antihack / 1 = Вкл, 0 = Выкл. // Если Используется EPOCH AntiHack & AdminTool, то установите значение 0 или по инструкции!
dayz_REsec 		= 	1;		// DayZ RE Security / 1 = Вкл, 0 = Выкл.

// ФОРМАТ: [[[3D Позиция (X,Y,Z), Радиус], [3D Позиция (X,Y,Z), Радиус]]; 
// Отключает Спавн Лута и Зомби, а так же защищает игроков в указанных зонах. Обычно для Трейд-Зон.
DZE_SafeZonePosArray =
[
	 [[3164,12179,0],	85]		// ТЗ Церковь
	,[[9670,2955,0],	120]	// ТЗ Гора
	,[[10580,13110,0],	80]		// ТЗ Бункер
	,[[13155,6395,0],	90]		// ТЗ Сторож
];

// Не трогать!
enableRadio false;
enableSentences false;

diag_log "[СЕРВЕР]: [МИССИЯ]: [Init.sqf]: Параметр dayz_preloadFinished Сброшен!";
dayz_preloadFinished 	= 	nil;
onPreloadStarted "diag_log [diag_tickTime,'onPreloadStarted']; dayz_preloadFinished = false;";
onPreloadFinished "diag_log [diag_tickTime,'onPreloadFinished']; dayz_preloadFinished = true;";
with uiNameSpace do {RscDMSLoad 	= 	nil;};

if (!isDedicated) then
{
	enableSaving [false, false];
	startLoadingScreen ["","RscDisplayLoadCustom"];
	dayz_progressBarValue 	=	0;
	dayz_loadScreenMsg 		= 	localize 'str_login_missionFile';
	progress_monitor 		= 	[] execVM "\z\addons\dayz_code\system\progress_monitor.sqf";
	0 cutText ['','BLACK',0];
	0 fadeSound 0;
	0 fadeMusic 0;
};

initialized 	= 	false;
call compile preprocessFileLineNumbers "Fixes\init\variables.sqf";
dayz_progressBarValue 	= 	0.05;
call compile preprocessFileLineNumbers "\z\addons\dayz_code\init\publicEH.sqf";
dayz_progressBarValue 	= 	0.1;
call compile preprocessFileLineNumbers "\z\addons\dayz_code\medical\setup_functions_med.sqf";
dayz_progressBarValue 	= 	0.15;
call compile preprocessFileLineNumbers "Fixes\init\compiles.sqf";
call compile preprocessFileLineNumbers "Traders_Menu.sqf";
dayz_progressBarValue 	= 	0.25;
initialized 	= 	true;

// DayZ REsec
if (dayz_REsec == 1) then
{
	call compile preprocessFileLineNumbers "\z\addons\dayz_code\system\REsec.sqf";
};

if (isServer) then
{
	DZE_ServerMarkerArray 	= 	[]; 
	DZE_MissionPositions 	= 	[];

	// ТОЛЬКО ДЛЯ ЧЕРНОРУСИИ
	if (dayz_POIs) then
	{
		call compile preprocessFileLineNumbers "\z\addons\dayz_code\system\mission\chernarus\poi\init.sqf";
	};

	call compile preprocessFileLineNumbers "\z\addons\dayz_server\system\dynamic_vehicle.sqf";
	call compile preprocessFileLineNumbers "\z\addons\dayz_server\system\server_monitor.sqf";
	execVM "\z\addons\dayz_server\traders\napf.sqf"; 	// Торговцы
	
	if (dayz_infectiousWaterholes) then
	{
		execVM "\z\addons\dayz_code\system\mission\chernarus\infectiousWaterholes\init.sqf";
	};
	
	// ТОЛЬКО ДЛЯ ЧЕРНОРУСИИ (из CfgTownGeneratorDefault.hpp)
	if (dayz_townGenerator) then
	{
		execVM "\z\addons\dayz_code\system\mission\chernarus\MainLootableObjects.sqf";
	};
	
	Log_To_Server 	= 	compile preprocessFileLineNumbers "Scripts\LogToServer\LogToServer.sqf";
	"PV_LogToServer" addPublicVariableEventHandler {_id 	= 	(_this select 1) spawn Log_To_Server};
};

if (!isDedicated) then
{
	// Enables Plant lib fixes
	execVM "\z\addons\dayz_code\system\antihack.sqf";
	
	if (dayz_townGenerator) then
	{
		execVM "\z\addons\dayz_code\compile\client_plantSpawner.sqf";
	};
	
	execVM "Scripts\RndLoadout\RndLoadout.sqf";
	call compile preprocessFileLineNumbers "Scripts\ClientMarkerSystem\ClientMarkerSystem.sqf";
	call compile preprocessFileLineNumbers "Scripts\RecipesPreview\RecipesPreview.sqf";
	execFSM "\z\addons\dayz_code\system\player_monitor.fsm";

	[] call compile preprocessFileLineNumbers "Scripts\DZAIClient\dzai_initclient.sqf";

	if (DZE_R3F_WEIGHT) then
	{
		execVM "\z\addons\dayz_code\external\R3F_Realism\R3F_Realism_Init.sqf";
	};
	
	waitUntil {scriptDone progress_monitor};
	cutText ["","BLACK IN", 3];
	3 fadeSound 1;
	3 fadeMusic 1;
	endLoadingScreen;
};
