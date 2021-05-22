diag_log '[СЕРВЕР]: [МИССИЯ]: [ConfigVariables.sqf]: Получение всех параметров и значений для Клиент/Сервер.';

// СЕРВЕР
if (isServer) then
{
	dayZ_instance = 24; // Не трогать! NAPF MAP ID

	dayz_POIs = false; // Только для Черно!
	
	// Динамичная техника
	MaxVehicleLimit 			= 	150; 	// Всего рандомной техники на карте (ID = 0 в DB)
	DynamicVehicleDamageLow 	= 	70; 	// Мин. урон по технике при спавне (% = 0 - 100)
	DynamicVehicleDamageHigh 	= 	97; 	// Макс. урон по технике при спавне (% = 0 - 100)
	DynamicVehicleFuelLow 		= 	5; 		// Мин. бензина в технике при спавне (% = 0 - 100)
	DynamicVehicleFuelHigh 		= 	20; 	// Макс. бензина в технике при спавне (% = 0 - 100)
	
	// Динамичные объекты
	MaxDynamicDebris 	=	0;		// Кол-во Мусора на дорогах
	MaxAmmoBoxes 		=	5;		// Кол-во Ящиков Supply_Crate_DZE появится на карте
	MaxMineVeins 		=	50;		// Кол-во Руд появится на карте

	// Параметры Спавна
	spawnArea 		= 	1000;	// Расстояние от точки спавна из Mission.sqm для спавна игрока (в метрах)
	spawnShoremode 	= 	1;		// Рандомный выбор спавна  1 = На берегу, 0 = Внутри острова

	// Призрак (Спектатор после смерти)
	dayz_enableGhosting 	=	false;		// Включить режим Призрака?  / True - Да, False - Нет
	dayz_ghostTimer 		=	120;		// Время жизни Призрака (В секудах)
	
	// Ивенты (Берутся из DayZ_Server/Modules)
	EpochEvents =
	[
		// ФОРМАТ: [Год,месяц,день,минуты,Имя файла - .sqf] Установите где время -1, тогда сервер запустит ивент сразу. Используйте "any" для любой даты.
		// ["any","any","any","any",-1,"Infected_Camps"], // (Кушает прилично FPS)
		["any","any","any","any",25,"animated_crash_spawner"]
		,["any","any","any","any",50,"animated_crash_spawner"]
		,["any","any","any","any",75,"animated_crash_spawner"]
	];

	DZE_TRADER_SPAWNMODE 	=	false;	// Купленная техника будет появляться на парашюте? / True - Да, False - Нет
	// ZSC
	Z_globalBankingTraders 	= 	true;	// Включить Банкиров NPC в Трейд-Зонах?
};

// КЛИЕНТ
if (!isDedicated) then
{
	// Нет смысла менять эти параметры или лучше не менять во все т.к. изменение может сделать хуже!
	timezoneswitch 				= 	0; 			// Оффсет времени для MurderMenu (Сам не шарю конкретику)
	dayz_tameDogs 				= 	false;		// Приручать собак? (Скрипт очень лагучий и баганный. Доделываться он не будет!)
	dayz_bleedingeffect 		= 	2; 			// 1 = Кровь остается на земле (Негативно влияет на FPS), 2 = Только эффект (Рекомендуется), 3 = Оба варианта вместе
	dayz_maxMaxWeaponHolders 	= 	120; 		// Максимальное количество Куч Лута (WeaponHolders) которое может спавниться в радиусе 200 метров от игрока
	
	// Настройки для Сервера
	DZE_PVE_Mode 			= 	false; 		// Включить PVE Режим? (Отключает Урон по Игрокам от Игроков)
	DZE_DisabledChannels 	=  				// Отключить Голосовой чат в этих Каналах. Остальные каналы: "str_channel_group","str_channel_direct","str_channel_vehicle"
	[
		(localize "str_channel_side")
		,(localize "str_channel_global")
		,(localize "str_channel_command")
	];
	dayZ_serverName 		= 	"FireFly"; 		// Показывает Водяной знак внизу слева экрана
	dayz_enableRules 		= 	false; 			// Включить Приветственное сообщение при входе игрока (Они же правила или новости. Файл Rules.sqf)
	
	// Прочие параметры (Не сортируемые)
	DZE_Hide_Body 				= 	true; 		// Можно Прятать трупы? (В том числе удаляет маркер трупа)
	DZE_DeathScreen 			= 	true; 		// Экран смерти: True = Epoch / False = DayZ
	DZE_R3F_WEIGHT 				= 	true; 		// Включить R3F весовую систему. Чем больше вес у игрока, тем медленнее игрок и он может устать и упасть в перегруз
	DZE_HeartBeat				=	false;		// Включить звук Ударов Сердцебиения если на игрока смотрит Бандит (<= -3000 Человечности)
	dayz_randomMaxFuelAmount 	= 	500; 		// Кол-во литров топлива (рандомное) которое может быть на ВСЕХ Заправках.
	
	DZE_salvageLocked 			= 	true; 		// Включить Взлом Закрытой Техники? : True - Вкл / False - Выкл
	DZE_DisableVehicleUpgrade 	= 	[]; 		// Список Техники которые Нельзя улучшать. ФОРМАТ: ["ArmoredSUV_PMC_DZE","LandRover_CZ_EP1_DZE"];
	
	DZE_VanillaUICombatIcon		= 	true; 		// Показывать или Спрятать UI Иконку "В бою". Если используется DZE_UI = "vanilla"; не примется эффект.
	dayz_paraSpawn 				= 	false; 		// HALO Прыжок Epoch: True - Вкл / False - Выкл
	
	dayz_quickSwitch 		= 	false; 		// Быстрое переключение между оружием: True - Вкл / False - Выкл
	DZE_TwoPrimaries 		= 	2; 			// 0 do not allow primary weapon on back. 1 allow primary weapon on back, but not when holding a primary weapon in hand. 2 allow player to hold two primary weapons, one on back and one in their hands.

	// Отображение Имени
	DZE_NameTags 				= 	0; 			// Отображать Имя Игрока когда он рядом?  0 = Выкл, 1 = Вкл, 2 = Игрок сам решает
	DZE_ForceNameTagsInTrader 	= 	true; 		// Отображать Имя Игрока когда он рядом в Трейд-Зоне ПРИНУДИТЕЛЬНО. Игнорирует выбор игрока.
	DZE_HumanityTargetDistance 	= 	25; 		// Дистанция отображения Имени Игрока (В метрах)

	// Настройки Зомби
	dayz_maxGlobalZeds 		= 	1000; 		// Максимальное Кол-во Зомби на всей карте
	dayz_DamageMultiplier 	= 	1; 			// Множитель урона Зомби по Игрокам
	DZE_ZombieSpeed 		= 	[0,0]; 		// Default agro speed is 6 per zombie config, set array elements 0 and 1 the same for non-variable speed, set to 0 to disable. array format = [min, max];  Ex: [2, 6]; results in a range of speed between 2 and 6 (2 is the old DZE_slowZombies hard-coded speed)
	
	// Самопереливание Крови
	DZE_SelfTransfuse 			= 	false; 				// Разрешить игрокам переливать Самому себе кровь? : True - Вкл / False - Выкл
	DZE_selfTransfuse_Values 	= 	[12000,15,120]; 	// [Количество крови, Шанс инфекции, Перезарядка умения (В секундах)]
	
	// Настройки Скинов
	// Доступные скины при спавне ФОРМАТ: [[Мужские],[Женские]]; Закомментируйте этот параметр чтобы отключить эту функцию.
	DZE_defaultSkin		=
	[
		[
			"Survivor2_DZ"
			,"Rocker1_DZ"
			,"Rocker2_DZ"
			,"Rocker3_DZ"
			,"Rocker4_DZ"
			,"Priest_DZ"
			,"Functionary1_EP1_DZ"
			,"Doctor_DZ"
			,"Assistant_DZ"
			,"Worker1_DZ"
			,"Worker3_DZ"
			,"Worker4_DZ"
			,"TK_CIV_Takistani01_EP1_DZ"
			,"TK_CIV_Takistani03_EP1_DZ"
			,"TK_CIV_Takistani04_EP1_DZ"
			,"TK_CIV_Takistani06_EP1_DZ"
			,"Firefighter1_DZ"
			,"Firefighter2_DZ"
			,"Firefighter3_DZ"
			,"Firefighter4_DZ"
			,"Firefighter5_DZ"
			,"Firefighter_Officer1_DZ"
			,"Firefighter_Officer2_DZ"
			,"Postman1_DZ"
			,"Postman2_DZ"
			,"Postman3_DZ"
			,"Postman4_DZ"
			,"SchoolTeacher_DZ"
			,"Gardener_DZ"
			,"RU_Policeman2_DZ"
			,"Hunter_DZ"
			,"Civilian1_DZ"
			,"Civilian3_DZ"
			,"Civilian5_DZ"
			,"Civilian7_DZ"
			,"Civilian9_DZ"
			,"Civilian11_DZ"
			,"Civilian13_DZ"
			,"Prisoner1_DZ"
			,"Prisoner2_DZ"
			,"Prisoner3_DZ"
			,"Reporter_DZ"
			,"MafiaBoss_DZ"
			,"Dealer_DZ"
			,"BusinessMan_DZ"
		],
		[
			"SurvivorW2_DZ"
			,"SurvivorWcombat_DZ"
			,"SurvivorWdesert_DZ"
			,"SurvivorWurban_DZ"
			,"SurvivorWpink_DZ"
			,"SurvivorW3_DZ"
		]
	];
	// Запрещенные скины которые Нельзя одеть. ФОРМАТ: ["Skin_GUE_Soldier_CO_DZ","Skin_GUE_Soldier_2_DZ"];
	DZE_RestrictSkins 	= 	[];
	// Скины которые будут работать как "Утепленные". ФОРМАТ: ["Skin_GUE_Soldier_CO_DZ","Skin_GUE_Soldier_2_DZ"];
	DZE_WarmClothes 	= 	[];
	
	// Настройки Температуры
	// Установите True чтобы ОТКЛЮЧИТЬ ВСЕ изменения связанные с Температурой.
	dayz_temperature_override 	= 	true;
	// Влияние значения Температуры когда игрок...
	DZE_TempVars 				=
	[
		// Положительное значение
		  7			// Сидя в Технике
		, 15		// Костер / Огонь
		, 4			// Внутри Здания
		, 4			// При Движении игрока
		, 2			// На Солнце
		, 6			// Использование Хим.Грелки
		, 8			// Одет "Утепленный" скин
		
		// Отрицательное значение
		, 3			// Вода, Море и т.п.
		, 2			// Игрок не передвигается
		, 0.25		// Идет Дождь
		, 0.75		// Ветер
		, 0.5		// Ночь
		, 12		// Снег
		, 33		// Дрожь (Установите 26 чтобы отключить)
	];

	dayz_nutritionValuesSystem = false; //true, Enables nutrition system, false, disables nutrition system.
	DZE_NutritionDivisor = [1, 1, 1, 1]; //array of DIVISORS that regulate the rate of [calories, thirst, hunger, temperature] use when "working" (keep in mind that temperature raises with actions) - min values 0.1 - Larger values slow the effect, smaller values accelerate it
	
	// Ограничения Строительства
	DZE_NoBuildNear 				= 	[]; 		// Массив объектов рядом с которыми нельзя строить. ФОРМАТ: ["Land_Mil_ControlTower","Land_SS_hangar"].
	DZE_NoBuildNearDistance 		= 	150; 		// Дистанция в метрах от обьекта где нельзя строить.
	DZE_requireplot 				= 	1; 			// Требуется ЗНАК-ПЛОТ для строительства? (1 - Да / 0 - Нет).
	DZE_PlotPole 					= 	[30,45]; 	// [Радиус ЗНАК-ПЛОТ, Минимальное Расстояние в метрах между ЗНАК-ПЛОТ];
	DZE_StaticConstructionCount		= 	0; 			// Кол-во шагов анимации при строительстве (ДЛЯ ВСЕХ ОБЪЕКТОВ СРАЗУ!). Установите 0 чтобы параметры шагов анимации были получены из Config файлов.
	DZE_BuildOnRoads 				= 	false; 		// Можно ли строить на дороге?
	DZE_BuildHeightLimit 			= 	0; 			// Ограничение строительства объектов по высоте. 0 = Нет лимита | >0 = Лимит в метрах.
	DZE_BuildingLimit 				= 	150; 		// Максимальное Кол-во объектов для строительства в ЗНАК-ПЛОТе
	DZE_AntiWallLimit 				= 	3; 			// Кол-во попыток прежде чем параметр: player_antiWall убьет игрока за попытку Глича со стенами. Lower is stricter, but may result in false positives.
	DZE_DamageBeforeMaint 			= 	0.09; 		// Мин. Кол-во урона требуется нанести постройкам чтобы оно было "Обслуживаемым"
	DZE_lockablesHarderPenalty 		= 	true; 		// Включить "Пенальти" за неудачные взломы/открытия Сейфов и Замков? : True - Вкл / False - Выкл

	// SafeZone
	DZE_SafeZoneNoBuildItems		=	[]; 	// Список Объектов которые нельзя строить возле Трейд-Зон DZE_SafeZonePosArray (Смотри mission\init.sqf). Можно использовать свои значения расстояния для Определенного объекта. НАПРИМЕР: ["VaultStorageLocked","LockboxStorageLocked",["Plastic_Pole_EP1_DZ",1300]].
	DZE_SafeZoneNoBuildDistance		=	150; 	// Дистанция для объектов возле Трейд-Зон DZE_SafeZonePosArray (see mission\init.sqf) to disallow building near.
	DZE_BackpackAntiTheft 			= 	true;	// Предотвращать воровство из Рюкзаков для "Не отмеченных другом" игроков в Трейд-Зонах.
	
	// HALO Прыжок
	DZE_HaloAltitudeMeter 		= false; 	// Отображать Высоту и Скорость при прыжке? : True - Вкл / False - Выкл
	DZE_HaloOpenChuteHeight 	= 180; 		// При какой высоте открывать автоматически парашют. Установите -1 чтобы отключить эту функцию.
	DZE_HaloSpawnHeight 		= 2000; 	// Начальная высота прыжка когда игрок только возродился (В метрах).
	DZE_HaloJump 				= true; 	// Включить HALO прыжок если высота больше 400м : True - Вкл / False - Выкл

	// Настройка Торговли
	DZE_serverLogTrades 	= 	true; 		// Логгировать в Серверный RPT (Отправляет запрос publicVariableServer на каждую торговлю)
	
	// Установите Кол-во добываемых Руд при "Добывании"
	DZE_GemOccurance 		= 	
	[
		["ItemTopaz",10]
		, ["ItemObsidian",8]
		, ["ItemSapphire",6]
		, ["ItemAmethyst",4]
		, ["ItemEmerald",3]
		, ["ItemCitrine",2]
		, ["ItemRuby",1]
	];
	
	// Цены за Руду при обмене с Торговцем. Установите DZE_GemWorthArray = []; чтобы отключить этот параметр.
	DZE_GemWorthArray 		= 
	[
		["ItemTopaz",15000]
		, ["ItemObsidian",20000]
		, ["ItemSapphire",25000]
		, ["ItemAmethyst",30000]
		, ["ItemEmerald",35000]
		, ["ItemCitrine",40000]
		, ["ItemRuby",45000]
	];
	
	DZE_SaleRequiresKey 			= 	true; 		// Требуется Ключ от техники чтобы продать ее? True - Да / False - Нет. Ключ может быть где угодно у Игрока или в его Технике.
	DZE_keepVehicleKey 				= 	false; 		// Оставлять Ключ после продажи техники? True - Да / False - Нет. (Полезно для Скрипта с Key Changer)
	Z_AllowTakingMoneyFromBackpack 	= 	false; 		// Можно ли при Торговле брать деньги из Рюкзака? ТОЛЬКО ДЛЯ СТАНДАРТНОЙ ВАЛЮТЫ. True - Да / False - Нет.
	Z_AllowTakingMoneyFromVehicle 	= 	false; 		// Можно ли при Торговле брать деньги из Техники? ТОЛЬКО ДЛЯ СТАНДАРТНОЙ ВАЛЮТЫ. True - Да / False - Нет.

	// Plot Management и Plot for Life
	DZE_PlotManagementAdmins 		= 	[]; 		// Список Админских PlayerUIDов. UIDы которые будут иметь Полный доступ к Каждому ЗНАК-ПЛОТУ и его Меню.
	DZE_plotManagementMustBeClose 	= 	true; 		// Игроки должны быть в радиусе 10м от ЗНАК-ПЛОТА чтобы добавить друг друга в Меню управления или Друзья.
	DZE_MaxPlotFriends 				= 	10; 		// Максимальное количество игроков разрешенное на ЗНАК-ПЛОТ.
	DZE_limitPlots 					= 	0; 			// Лимит установки ЗНАК-ПЛОТА на Игрока, Установите 0 - Отключить. UIDы указанные в DZE_PlotManagementAdmins списке имеют исключение на этот лимит.
	DZE_maintainCurrencyRate 		= 	100; 		// Множитель Валюты для Обслуживания предметов на Базе. НАПРИМЕР: Множитель 100 * 10 предметов = 1000 (Слиток: 1 10oz gold или 1k монет). Cмотри Dayz_code/actions/maintain_area.sqf для примеров.
	
	// Список Объектов которые можно разобрать Ломом только "Владелец" или У кого есть доступ. Нет необходимости добавлять сюда Двери, хранилища или объекты унаследованные от 'ModularItems'. Объекты унаследованные от 'BuiltItems' можно добавить при желании.
	DZE_restrictRemoval 	=
	[
		"Fence_corrugated_DZ"
		,"M240Nest_DZ"
		,"ParkBench_DZ"
		,"FireBarrel_DZ"
		,"Scaffolding_DZ"
		,"CanvasHut_DZ"
		,"LightPole_DZ"
		,"DeerStand_DZ"
		,"MetalGate_DZ"
		,"StickFence_DZ"
	];

	DZE_DisableUpgrade 		= 	[];		// Список Объектов которые не могут быть Улучшены. НАПРИМЕР: DZE_DisableUpgrade = ["WoodShack_DZ","StorageShed_DZ"];

	// Snap Build и Build Vectors
	DZE_modularBuild 			= 	true; 	// Включить скрипт Snap Building и Build Vectors? True - Да / False - Нет.
	DZE_snapExtraRange 			= 	0; 		// Увеличивает стандартное расстояние для Соединения построек (В метрах).
	
	// Список Объектов которые нельзя Вращать при постройке. НАПРИМЕР: ["ItemVault","ItemTent","ItemDomeTent","ItemDesertTent"];
	DZE_noRotate 		= 	
	[
		"ItemWoodLadder"
		,"woodfence_foundation_kit"
		,"metalfence_foundation_kit"
		,"cook_tripod_kit"
		,"metal_drawbridge_kit"
		,"metal_drawbridge_kit_locked"
		,"storage_crate_kit"
	];

	DZE_vectorDegrees 		= 	[0.01, 0.1, 1, 5, 15, 45, 90]; 		// На какие углы можно вращать объекты.
	DZE_curDegree 			= 	45; 								// Начальный угол вращения объектов. Может быть любое значение которое указанно в массиве выше.
	DZE_dirWithDegrees 		= 	true; 								// Можно ли вращать объекты используя Q&E.
	
	DZE_buildMaxMoveDistance 		= 	10; 	// Макс. дистанция на которое игрок может ходить при постройке (В метрах).
	DZE_buildMaxHeightDistance 		= 	10; 	// Макс. дистанция на которое игрок может поднимать объект при постройке (В метрах).

	DZE_modularConfig = [];
	/*
		Список объектов которые будут возвращать предметы обратно при Разборе объекта. Для объектов которые изначально не возвращают предметы.

		НАПРИМЕР:
		DZE_modularConfig =
		[
			["CinderWall_DZ", [["CinderBlocks",7],["MortarBucket",2]]],
			["CinderWallDoor_DZ", [["CinderBlocks",7],["MortarBucket",2],["ItemTankTrap",3],["ItemPole",[1,3]]]]
		];

		При разборке вернется 7 cinder blocks и 2 mortar за "CinderWall_DZ"
		При разборке "CinderWallDoor_DZ" вам вернется 7 cinder blocks, 2 mortar, 3 tank traps и случайное количество ItemPole от 1 до 3.
		Количество возвращаемых объектов может быть массивом. Где первое число это Минимум, где второе число это макисмум. Значение будет выбираться случайно.
	*/

	// Door Management
	DZE_doorManagementAdmins 			= 	[]; 		// Список Админских PlayerUIDов. UIDы которые будут иметь Полный доступ к Двери (замкам) и его Меню.
	DZE_doorManagementMustBeClose 		= 	false; 		// Игроки должны быть в радиусе 10м от Двери чтобы добавить друг друга в Меню управления или Друзья.
	DZE_doorManagementAllowManualCode 	= 	true; 		// Для того чтобы открыть дверь нужно ввести комбинацию. Установите false чтобы вместо комбинации использовать Сканнер глаз.
	DZE_doorManagementMaxFriends 		= 	10; 		// Максимальное количество игроков разрешенное на Дверь.
	DZE_doorManagementHarderPenalty 	= 	true; 		// Включить "Пенальти" за неудачные взломы/открытия Дверей? : True - Вкл / False - Выкл

	// Group System
	dayz_markGroup 		= 	1; 			// Игроки могут видеть Членов своей группы на карте: 0 = Никогда, 1 = Всегда, 2 = Только при наличии GPS
	dayz_markSelf 		= 	0; 			// Игроки могут видеть Свою позицию на карте: 0 = Никогда, 1 = Всегда, 2 = Только при наличии GPS
	dayz_markBody 		= 	0; 			// Игроки могут видеть Свои Трупы на карте: 0 = Никогда, 1 = Всегда, 2 = Только при наличии GPS
	dayz_requireRadio 	= 	false; 		// Для создания Группы или Приглашений требуется Радио? True - Да / False - Нет.

	// Humanity System
	DZE_Hero 	= 	5000; 	// Сколько нужно Хуманити чтобы стать Героем?
	DZE_Bandit 	= 	-5000; 	// Сколько нужно Хуманити чтобы стать Бандитом?

	// ZSC
	Z_showCurrencyUI 	= true; 	// Отображать иконку денег в Инвентаре? Только если Z_SingleCurrency = True.
	Z_showBankUI 		= true; 	// Отображать иконку денег в Банке? Только если Z_globalBanking = True.

	ZSC_bankTraders 	= 	["Functionary1_EP1"]; 	// Список НПС Торговцев с кем будет БАНКИНГ. НАПРИМЕР: Functionary1_EP1, Не используйте _DZ классы - они используют игровые скины
	ZSC_bankObjects 	= 	[""]; 					// Список Объектов с которыми будет БАНКИНГ. НАПРИМЕР:  ["Suitcase","Info_Board_EP1","Laptop_EP1","SatPhone"]
	
	ZSC_limitOnBank 	= 	true; 		// Банк имеет лимит хранения Денег? True - Да / False - Нет.
	ZSC_maxBankMoney 	= 	500000; 	// Какой лимит Денег хранимых в Юанке.
	
	ZSC_defaultStorageMultiplier 		= 	200; 		// Количество мест для хранения денег для тех объектов, у которых нет слотов для хранения: ["Suitcase","Info_Board_EP1","Laptop_EP1","SatPhone"]
	ZSC_MaxMoneyInStorageMultiplier 	= 	5000; 		// Множитель хранения денег в Объектах (Сейфы, техника и т.п.) на Количество слотов. НАПРИМЕР: 200 Предметных слотов * 5000 значение равняется 1 миллиону хранимых денег. (200 * 5000 = 1,000,000)
	
	ZSC_ZombieCoins 	= 	[true,[0,5]]; 		// Зомби имеют деньги при себе? True - Вкл / False - Выкл // Значения 0 - 5: Это От скольки и До скольки денег может быть случайно у Зомби.

	// Loot system
	dayz_toolBreaking 			= 	true; 	// Кувалда, Ломик и Топор имеют шанс сломаться при использовании? True - Да / False - Нет.
	dayz_knifeDulling 			= 	true; 	// Включить износ Охотничего ножа? Ножи будут затупляться после нескольких использований. True - Да / False - Нет.
	dayz_matchboxCount 			= 	true; 	// Включить траты Спичек? После 5 раз спички заканчиваются. True - Да / False - Нет.
	dayz_waterBottleBreaking 	= 	true; 	// Фляги с водой имеют шанс сломаться при Кипечении воды? Чтобы починить требуется Изолента. True - Да / False - Нет.
};

// КЛИЕНТ И СЕРВЕР
// ТОЛЬКО ДЛЯ ЧЕРНОРУСИИ!!!
dayz_infectiouswaterholes 		= 	false; 	// Включить Зараженные водоемы?
infectedWaterHoles 				= 	[]; 	// Нужно для НЕ ЧЕРНО КАРТ (Массив не знаю!).
dayz_townGenerator 				= 	false; 	// Использовать Ванильный мусор вместо Epoch DynamicDebris? ТОЛЬКО ДЛЯ ЧЕРНО. (Негативно влияет на FPS)
dayz_townGeneratorBlackList 	= 	[]; 	// Если townGenerator = true, то в радиусе 150м от указанных позиций мусор не будет появляться. ПРИМЕРЫ ЧЕРНО ТОРГОВЦЕВ: [[4053,11668,0],[11463,11349,0],[6344,7806,0],[1606,7803,0],[12944,12766,0],[5075,9733,0],[12060,12638,0]]
dayz_spawnselection 			= 	0; 		// Включить выбор спавна? 0 = Рандом, 1 = Выбор (ТОЛЬКО ДЛЯ ЧЕРНО)

// Прочие параметры (Работают на всех картах).
DZE_GodModeBase 			= 	false; 		// Включить Бессмертие на постройки? True - Да / False - Нет.
DZE_GodModeBaseExclude 		= 	[]; 		// Список Объектов которые будут Исключены для Бессмертия. Рекомендуется: Двери,ворота и т.п.

DZE_NoVehicleExplosions 	= 	false; 		// Выключить Взрыв от Техники? В случае поломки техники она не будет взрываться и наносить урон, а просто заменит модельку на сломанную. True - Да / False - Нет.
DZE_SafeZoneZombieLoot 		= 	false;  	// Разрешить Предметам и Зомби в зонах DZE_SafeZonePosArray?
dayz_ForcefullmoonNights 	= 	false; 		// Отключить лунный свет ночью? Выкручивание яркости в данном случае не поможет. True - Да / False - Нет.
dayz_classicBloodBagSystem 	= 	false; 		// Отключить систему Групп крови и использовать один тип крови для всех с ItemBloodbag? True - Да / False - Нет.
dayz_enableFlies 			= 	false; 		// Включить мух на Трупах? (Негативно влияет на FPS). True - Да / False - Нет.
DZE_PlayerZed 				= 	false; 		// Если игрок умер при заражении, то он может стать зомби? True - Да / False - Нет.
DZE_HeliLift 				= 	true; 		// Включить Epoch буксировочную систему? True - Да / False - Нет.

// Death Messages
DZE_DeathMsgChat 			= 	"none"; 	// "none","global","side","system" В какой чат будут отображаться сообщения об убийствах игроков.
DZE_DeathMsgDynamicText 	= 	false; 		// Отображать сообщения об убийствах игроков используя: dynamicText. (Сверху слева с иконками). True - Да / False - Нет.
DZE_DeathMsgRolling 		= 	false; 		// Отображать сообщения об убийствах игроков используя: rolling messages (По центру экрана). True - Да / False - Нет.

// ZSC
Z_SingleCurrency 	= 	true; 		// Включить Монетную систему?. True - Да / False - Нет.
Z_globalBanking 	= 	false; 		// Включить Банковскую систему?. True - Да / False - Нет.
Z_persistentMoney 	= 	false; 		// Включить защиту денег у игрока при смерти? Валюта вместо player_data будет использовать character_data. Это значит что при смерти игрока он не потеряет деньги у себя в кармане и перенесет их на нового игрока. Только для PVE серверов. Переменная будет называться: "GlobalMoney". True - Да / False - Нет.
Z_VehicleDistance 	= 	40; 		// Макс. дистация техники из которой торговец сможет торговать (В метрах).

CurrencyName 	= 	"Рублей"; 		// Отображаемое название вашей Валюты.

// Список Объектов в которых игрок может хранить валюту. НАПРИМЕР: ["GunRack_DZ","WoodCrate_DZ"]
DZE_MoneyStorageClasses 	= 
[
	"VaultStorage"
	,"VaultStorage2"
	,"VaultStorageLocked"
	,"VaultStorage2Locked"
	,"LockboxStorageLocked"
	,"LockboxStorage2Locked"
	,"LockboxStorage"
	,"LockboxStorage2"
	,"LockboxStorageWinterLocked"
	,"LockboxStorageWinter2Locked"
	,"LockboxStorageWinter"
	,"LockboxStorageWinter2"
	,"TallSafe"
	,"TallSafeLocked"
];

ZSC_VehicleMoneyStorage 	= 	true;	// Включить хранение Валюты в Технике? Если техника взорвется, то и валюта пропадет! True - Да / False - Нет.

// Plot Management и Plot for Life
DZE_permanentPlot 	= 	true; 		// ЗНАК-ПЛОТ не будет удалять игрока если тот умер. Включить Plot for Life и Plot Management? True - Да / False - Нет.

// Список объектов которые можно разобрать с помощью Ломика которые не требуют Доступа или прав Хозяина. Чтобы запретить захват базы. Уберите ЗНАК-ПЛОТ отсюда и добавьте его в DZE_restrictRemoval. Нет необходимости добавлять сюда Обломки или предметы унаследованные от 'BuiltItems'.
DZE_isRemovable 	= 
[
	"Plastic_Pole_EP1_DZ"
];

// Door Management
DZE_doorManagement 	= 	true; 		// Включть Door Management? True - Да / False - Нет.

// Group System
dayz_groupSystem 	= 	false; 		// Включить group system? True - Да / False - Нет.

// Погода
DZE_Weather = 2; // Options: 1 - Summer Static, 2 - Summer Dynamic, 3 - Winter Static, 4 - Winter Dynamic. If static is selected, the weather settings will be set at server startup and not change. Weather settings can be adjusted with array DZE_WeatherVariables.

// The settings in the array below may be adjusted as desired. The default settings are designed to maximize client and server performance.
// Having several features enabled at once might have adverse effects on client performance. For instance, you could have snowfall, ground fog, and breath fog threads all running at once.
DZE_WeatherVariables = [
	15, // Minimum time in minutes for the weather to change. (default value: 15).
	30, // Maximum time in minutes for the weather to change. (default value: 30).
	0, // Minimum fog intensity (0 = no fog, 1 = maximum fog). (default value: 0).
	.2, // Maximum fog intensity (0 = no fog, 1 = maximum fog). (default value: 0.8).
	0, // Minimum overcast intensity (0 = clear sky, 1 = completely overcast). (default value: 0). Note: Rain and snow will not occur when overcast is less than 0.70.
	.6, // Maximum overcast intensity (0 = clear sky, 1 = completely overcast). (default value: 1).
	0, // Minimum rain intensity (0 = no rain, 1 = maximum rain). Overcast needs to be at least 70% for it to rain.
	.6, // Maximum rain intensity (0 = no rain, 1 = maximum rain). Overcast needs to be at least 70% for it to rain.
	0, // Minimum wind strength (default value: 0).
	3, // Maximum wind strength (default value: 5).
	.25, // Probability for wind to change when weather changes. (default value: .25).
	1, // Minimum snow intensity (0 = no snow, 1 = maximum snow). Overcast needs to be at least 75% for it to snow.
	1, // Maximum snow intensity (0 = no snow, 1 = maximum snow). Overcast needs to be at least 75% for it to snow.
	.2,// Probability for a blizzard to occur when it is snowing. (0 = no blizzards, 1 = blizzard all the time). (default value: .2).
	10, // Blizzard interval in minutes. Set to zero to have the blizzard run for the whole interval, otherwise you can set a custom time interval for the blizzard.
	0, // Ground Fog Effects. Options: 0 - no ground fog, 1 - only at evening, night, and early morning, 2 - anytime, 3 - near cities and towns, at late evening, night, and early morning, 4 - near cities and towns, anytime.
	400, // Distance in meters from player to scan for buildings to spawn ground fog. By default, only the 15 nearest buildings will spawn ground fog.
	false, // Allow ground fog when it's snowing or raining?
	2 // Winter Breath Fog Effects. Options: 0 - no breath fog, 1 - anytime, 2 - only when snowing or blizzard. Note: breath fog is only available with winter weather enabled.
];

setViewDistance 2500;	// Дальность прорисовки Сервера
setTerrainGrid 3.125;	// Дальность травы и геометрии (Установите 50 - Отключить траву и Геометрию и повысит FPS. Значение 25 - Стандарт).

diag_log '[СЕРВЕР]: [МИССИЯ]: [ConfigVariables.sqf]: ВСЕ параметры и значения были получены.';