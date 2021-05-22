[		
		/* Общая 1 */
			// Оружие
		["US_Delta_Force_AR_EP1", [3175, 12179, 0], 270]
			// Патроны
		,["Graves", [3175, 12181, 0], 270]
			// Техника
		,["GUE_Commander", [3174, 12170, 0], 180]
			// Еда и Рюкзаки
		,["Damsel3", [3182, 12191, 0], 275]
			// Стройка
		,["GUE_Woodlander2", [3171, 12191, 0], 100]
			// Медик
		,["Dr_Annie_Baker_EP1",[3148, 12202, 0], 175]
		
		/* Общая 2 */
			// Оружие
		,["Soldier_MG_PKM_PMC", [9679, 2916, 0], 8]
			// Патроны
		,["GUE_Worker2", [9684, 2916, 0], 337]
			// Техника
		,["GUE_Woodlander3", [9652, 2954, 0], 253]
			// Еда и Рюкзаки
		,["CIV_EuroWoman01_EP1", [9694, 2952, 0], 230]
			// Стройка
		,["GUE_Villager3", [9675, 2960, 0], 151]
			// Медик
		,["Dr_Hladik_EP1",[9674, 2917, 0], 56]
		
		/* Общая 3 */
			// Оружие
		,["Ins_Soldier_AR", [10582, 13088, 0], 80]
			// Патроны
		,["Ins_Lopotev", [10582, 13086, 0], 80]
			// Техника
		,["Ins_Worker2", [10569, 13114, 0], 75]
			// Еда и Рюкзаки
		,["Damsel5", [10600, 13098, 0], 260]
			// Стройка
		,["Ins_Woodlander3", [10592, 13091, 0], 69]
			// Медик
		,["pook_Doc_Bell47",[10600, 13109, 0], 232]
		
		/* Общая 4 */
			// Оружие
		,["Drake_Light", [13139, 6364, 0], 100]
			// Патроны
		,["Soldier_GL_PMC", [13140, 6367, 0], 100]
			// Техника
		,["RUS_Commander", [13161, 6401, 0], 5]
			// Еда и Рюкзаки
		,["TK_Special_Forces_EP1", [13161, 6366, 0], 10]
			// Стройка
		,["TK_Special_Forces_MG_EP1", [13150, 6363, 0], 15]
			// Медик
		,["Ins_Woodlander2",[13175, 6357, 0], 352]
] call server_spawnTraders;

execVM "\z\addons\dayz_server\buildings\Trade1.sqf";
uiSleep 1;
execVM "\z\addons\dayz_server\buildings\Trade2.sqf";
uiSleep 1;
execVM "\z\addons\dayz_server\buildings\Trade3.sqf";
uiSleep 1;
execVM "\z\addons\dayz_server\buildings\Trade4.sqf";
uiSleep 1;