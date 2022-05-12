local _Ratio1 	= 	1;
local _Ratio2 	= 	2;
local _Ratio3 	= 	3;
local _Ratio4 	= 	4;
local _Ratio5 	= 	5;
local _Ratio6 	= 	6;

/*
if (MaxVehicleLimit > 300) then
{
	_Ratio1 	= 	round(MaxVehicleLimit * 0.0034);		// 1
	_Ratio2 	= 	round(MaxVehicleLimit * 0.0067);		// 2
	_Ratio3 	= 	round(MaxVehicleLimit * 0.01);			// 3
};
*/

AllowedVehiclesList =
[
	// Наземная техника
	 ["Tractor_DZE",			_Ratio6]	// Трактор
	,["TractorOld_DZE",			_Ratio6]	// Трактор старый
	,["Tractor_Armored_DZE",	_Ratio3]	// Трактор с броней
	 
	,["Hummer_DZE",				_Ratio3]	// Хаммер (Городской)
	,["HMMWV_DZ",				_Ratio2]	// Хаммер
	,["HMMWV_Ambulance_DZE",	_Ratio2]	// Хаммер (медицинский)
	,["HMMWV_Armored_DZE",		_Ratio1]	// Хаммер (c М240)
	,["HMMWV_M2_DZ",			_Ratio1]	// Хаммер (с М2)
	,["HMMWV_MK19_DZE",			_Ratio1]	// Хаммер (с MK19)
	
	,["HMMWV_M1035_DES_EP1_DZE",		_Ratio2]	// Хаммер
	,["HMMWV_M1151_M2_CZ_DES_EP1_DZE",	_Ratio1]	// Хаммер (с М2 бронь)
	
	,["Ural_CDF_DZE",			_Ratio1]	// Урал (CDF)
	,["UralOpen_CDF_DZE",		_Ratio2]	// Урал-Открытый (CDF)
	,["Ural_INS_DZE",			_Ratio1]	// Урал (INS)
	,["UralCivil_DZE",			_Ratio1]	// Урал Гражданский Желтый
	,["UralCivil2_DZE",			_Ratio1]	// Урал Гражданский Синий
	,["UralRefuel_CDF_DZE",		_Ratio1]	// Урал (Заправочный) (CDF)
	
	,["Skoda_DZE",			_Ratio4]	// Шкода Белая
	,["SkodaBlue_DZE",		_Ratio4]	// Шкода Синий
	,["SkodaRed_DZE",		_Ratio4]	// Шкода Красный
	,["SkodaGreen_DZE",		_Ratio4]	// Шкода Зеленый
	
	,["UAZ_RU_DZE",			_Ratio3]	// УАЗ (РУ)
	,["UAZ_CDF_DZE",		_Ratio3]	// УАЗ (CDF)
	,["UAZ_INS_DZE",		_Ratio3]	// УАЗ (INS)
	,["UAZ_MG_CDF_DZE",		_Ratio1]	// УАЗ (CDF с ДШКМ)
	,["UAZ_MG_INS_DZE",		_Ratio1]	// УАЗ (INS с ДШКМ)
	,["UAZ_AGS30_RU_DZE",	_Ratio1]	// УАЗ (РУ АГС)
	
	,["datsun1_civil_1_open_DZE",		_Ratio3]	// Пикап Открытый
	,["datsun1_civil_2_covered_DZE",	_Ratio3]	// Пикап Крытый
	,["datsun1_civil_3_open_DZE",		_Ratio3]	// Пикап с трубой
	
	,["car_hatchback_DZE",		_Ratio4]	// Хэтчбэг
	,["car_hatchback_red_DZE",	_Ratio4]	// Хэтчбэг
	,["car_sedan_DZE",			_Ratio4]	// Седан
	
	,["Lada1_DZE",				_Ratio4]	// Лада
	,["Lada1_TK_CIV_EP1_DZE",	_Ratio4]	// Лада
	,["Lada2_DZE",				_Ratio4]	// Лада
	,["Lada2_TK_CIV_EP1_DZE",	_Ratio4]	// Лада
	,["LadaLM_DZE",				_Ratio4]	// Лада
	
	,["hilux1_civil_1_open_DZE",	_Ratio3]	// ХайЛюкс Внежорожник (Открытый)
	,["hilux1_civil_2_covered_DZE",	_Ratio3]	// ХайЛюкс Внежорожник (Крытый)
	,["hilux1_civil_3_open_DZE",	_Ratio3]	// ХайЛюкс Внежорожник (C трубой)
	
	,["Pickup_PK_GUE_DZE",	_Ratio1]	// Пикап с ПКМ
	,["Pickup_PK_INS_DZE",	_Ratio1]	// Пикап с ПКМ
	
	,["Offroad_DSHKM_Gue_DZE",	_Ratio1]	// Оффроад с ДШКМ
	
	,["GLT_M300_LT_DZE",	_Ratio4]	// Такси Лада
	,["GLT_M300_ST_DZE",	_Ratio4]	// Такси Седан
	
	,["GAZ_Vodnik_MedEvac_DZE",	_Ratio1]	// Водник медицинский
	,["GAZ_Vodnik",				_Ratio1]	// Водник 2 ПКМ
	
	,["M113Ambul_TK_EP1_DZ",	_Ratio1]	// M113 медицинский
	,["M113Ambul_UN_EP1_DZ",	_Ratio1]	// M113 медицинский
	,["ScrapAPC_DZE",			_Ratio1]	// APC
	
	,["Ikarus_DZE",				_Ratio2]	// Автобус
	,["Ikarus_White_DZE",		_Ratio3]	// Маршрутка
	,["Ikarus_TK_CIV_EP1_DZE",	_Ratio2]	// Автобус
	,["Ikarus_Armored_DZE",		_Ratio1]	// Автобус (Бронированный)
	
	,["Kamaz_DZE",		_Ratio1]	// Камаз
	,["KamazOpen_DZE",	_Ratio1]	// Камаз (Открытый)
	,["KamazRefuel_DZ",	_Ratio1]	// Камаз (Заправочный)
	
	,["MTVR_DZE",		_Ratio1]	// Камаз MTVR
	,["MTVR_Open_DZE",	_Ratio1]	// Камаз MTVR (Открытый)
	,["MtvrRefuel_DZ",	_Ratio1]	// Камаз MTVR (Заправочный)
	
	,["V3S_Civ_DZE",				_Ratio1]	// V3S
	,["V3S_TK_EP1_DZE",				_Ratio1]	// V3S
	,["V3S_Open_TK_EP1_DZE",		_Ratio1]	// V3S (Открытый)
	,["V3S_Open_TK_CIV_EP1_DZE",	_Ratio1]	// V3S (Открытый)
	,["V3S_Refuel_TK_GUE_EP1_DZ",	_Ratio1]	// V3S (Заправочный)
	
	,["VWGolf_DZE",			_Ratio4]	// Хэтчбэг
	,["Mini_Cooper_DZE",	_Ratio4]	// Миникупер

	,["TT650_Civ_DZE",	_Ratio5]	// Мотик TT650
	,["TT650_Ins_DZE",	_Ratio5]	// Мотик TT650
	
	,["ATV_CZ_EP1_DZE",	_Ratio5]	// Квадрик
	
	,["BTR40_TK_GUE_EP1_DZE",		_Ratio3]	// БТР-40
	,["BTR40_TK_INS_EP1_DZE",		_Ratio3]	// БТР-40
	,["BTR40_MG_TK_GUE_EP1_DZE",	_Ratio1]	// БТР-40 (c ДШКМ)
	,["BTR40_MG_TK_INS_EP1_DZE",	_Ratio1]	// БТР-40 (c ДШКМ)
	
	,["BRDM2_HQ_TK_GUE_EP1_DZE",	_Ratio1]	// БРДМ-2 (ПКМ Открытый)
	,["BRDM2_TK_GUE_EP1_DZE",		_Ratio1]	// БРДМ-2 (ПКМ Закрытый)
	
	,["BTR60_Gue_DZE",	_Ratio1]	// БТР-60 (ПКМ)
	
	,["LandRover_TK_CIV_EP1_DZE",	_Ratio3]	// Военный оффроад
	,["LandRover_MG_TK_EP1_DZE",	_Ratio1]	// Военный оффроад с М2
	
	,["S1203_TK_CIV_EP1_DZE",		_Ratio4]	// Школа-1203
	,["S1203_ambulance_EP1_DZE",	_Ratio4]	// Школа-1203 (медицинский)
	
	,["Volha_1_TK_CIV_EP1_DZE",		_Ratio4]	// Волга Синий
	,["Volha_2_TK_CIV_EP1_DZE",		_Ratio4]	// Волга Серый
	,["VolhaLimo_TK_CIV_EP1_DZE",	_Ratio4]	// Волга Лимо
	
	,["SUV_Camo",			_Ratio1]	// Сув
	,["SUV_Blue",			_Ratio1]	// Сув
	,["SUV_Green",			_Ratio1]	// Сув
	,["SUV_Yellow",			_Ratio1]	// Сув
	,["SUV_Red",			_Ratio1]	// Сув
	,["SUV_White",			_Ratio1]	// Сув
	,["SUV_Pink",			_Ratio1]	// Сув
	,["SUV_Charcoal",		_Ratio1]	// Сув
	,["SUV_Orange",			_Ratio1]	// Сув
	,["SUV_Silver",			_Ratio1]	// Сув
	,["SUV_TK_CIV_EP1_DZE",	_Ratio1]	// Сув
	
	,["MTVR_Bird_DZE",			_Ratio1]	// Литл из MTVR
	,["Mi17_BLACK_DZE",			_Ratio1]	// Ми17 гражданский
	,["Mi17_medevac_RU_DZ",		_Ratio1]	// Ми17 медицинский РУ
	,["AH6X_DZ",				_Ratio1]	// Литл-мал
	,["MH6J_DZ",				_Ratio1]	// Литл-мал (больше мест)
	,["UH60M_MEV_EP1_DZ",		_Ratio1]	// UH60 медицинский
	,["BAF_Merlin_DZE",			_Ratio1]	// Merlin
	,["Mi17_DZE",				_Ratio1]	// Ми-17 с ПКМ
	,["UH1H_DZE",				_Ratio1]	// UH1H с M240
	,["MH60S_DZE",				_Ratio1]	// MH60 с ПКТ
	,["CH53_DZE",				_Ratio1]	// CH53
];

/*
// Вдруг потребуется, но пока не нужно.
if (toLower worldName in ["napf","utes"]) then
{

	AllowedVehiclesList = AllowedVehiclesList + [
		["Fishing_Boat_DZE",_Ratio3],
		["JetSkiYanahui_Case_Blue",_Ratio1],
		["JetSkiYanahui_Case_Green",_Ratio1],
		["JetSkiYanahui_Case_Red",_Ratio1],
		["JetSkiYanahui_Case_Yellow",_Ratio1],
		["PBX_DZE",_Ratio3],
		["RHIB_DZE",_Ratio1],
		["RHIB2Turret_DZE",_Ratio1],
		["Smallboat_1_DZE",_Ratio3],
		["Smallboat_2_DZE",_Ratio3],
		["Zodiac_DZE",_Ratio3],
		["Submarine_DZE",_Ratio3]
	];
};

DZE_Hangar_positions = [];
DZE_Runway_Positions = [];

// Используем уникальные позиции для спавна Самолетов на Взлетных полосах и в Ангарах.
call {
	if (toLower worldName == "napf") exitWith
	{
		DZE_Hangar_positions 	= 	[[[18302.373, 2296.6174],128.92664],[[18219.572, 2201.1204],131.85796],[[18163.936, 2138.0906],130.08537],[[5012.1724, 4871.896],260.887802],[[4651.1582, 4806.9653],77.901695],[[4782.9136, 4831.3003],260.053566],[[14391.086, 16890.748],139.26932],[[14482.736, 16787.213],317.649258]];
		DZE_Runway_Positions 	= 	[[[14339.543, 17166.994],138.43173],[[14254.993, 17096.977],78.634995],[[14742.884, 16617.965],135.36357],[[15147.044, 16147.293],345.509653],[[18139.805, 1965.5642],39.729259],[[3902.3901, 4476.9971],79.775864],[[3876.8308, 4604.3208],128.58391],[[3930.5286, 4311.0532],16.60323],[[3888.5801, 4372.7026],51.806969],[[5208.6802, 4621.9556],286.741859]];
	};
};

DZE_AllAircraftPositions = DZE_Hangar_positions + DZE_Runway_Positions;
*/