/*
	Add Ammo to the turrets and gear of DZE vehicles.
	
	Note: Most of the helicopters can have flares added with the line below if you want.
	TURRET("60Rnd_CMFlareMagazine",-1) // also uses "120Rnd_CMFlareMagazine","240Rnd_CMFlareMagazine","60Rnd_CMFlare_Chaff_Magazine","120Rnd_CMFlare_Chaff_Magazine","240Rnd_CMFlare_Chaff_Magazine"
	
	Caution: Ammo like Hydras and Sidewinders will result in Battleye kicks. You will have to add exceptions to createVehicle.txt.
*/

#define GEAR(mag) if !(isNil "_inGear") then {_vehicle addMagazineCargoGlobal [mag,_inGear];};
#define TURRET(mag,num) _vehicle addMagazineTurret [mag,[num]];

local _vehicle = _this select 0;
local _type = _this select 1;
local _inGear = nil;

if (count _this > 2) then {
	_inGear = _this select 2;
};

call {	
	if (_type == "AH6J_EP1_DZE") exitWith { 
		TURRET("2000Rnd_762x51_M134",-1) // also uses "4000Rnd_762x51_M134"
		GEAR("2000Rnd_762x51_M134")
	};
	
	if (_type in ["pook_gunship_m134_DZE","pook_gunship_CDF_m134_DZE"]) exitWith { 
		TURRET("2000Rnd_762x51_M134",-1) // can also use "4000Rnd_762x51_M134"
		TURRET("pook_12Rnd_Grenade_Camel",-1) // can also use "6Rnd_Grenade_Camel"
		GEAR("2000Rnd_762x51_M134")
	};
	
	if (_type in ["pook_gunship_CDF_DZE","pook_gunship_DZE"]) exitWith { 
		TURRET("pook_1300Rnd_762x51_M60",-1) // also uses "4000Rnd_762x51_M134"
		TURRET("pook_12Rnd_Grenade_Camel",-1) // also uses "6Rnd_Grenade_Camel"
		GEAR("pook_1300Rnd_762x51_M60")
	};
	
	if (_type == "pook_transport_DZE") exitWith { 
		TURRET("pook_12Rnd_Grenade_Camel",-1) // also uses "6Rnd_Grenade_Camel"
		TURRET("pook_250Rnd_762x51",0) // also uses "100Rnd_762x51_M240","200Rnd_762x51_M240","460Rnd_762x51_M240_ACR"
		GEAR("pook_250Rnd_762x51")
	};
	
	if (_type == "Mi171Sh_CZ_EP1_DZE") exitWith { 
		TURRET("100Rnd_762x54_PK",0) // also uses "1500Rnd_762x54_PKT","2000Rnd_762x54_PKT","250Rnd_762x54_PKT_T90","200Rnd_762x54_PKT"
		TURRET("100Rnd_762x54_PK",1)
		TURRET("100Rnd_762x54_PK",2)
		GEAR("100Rnd_762x54_PK")
	};
	
	if (_type in ["Mi17_DZE","Mi17_UN_CDF_EP1_DZE","Mi17_TK_EP1_DZE","Mi17_CDF_DZE","Mi17_DES_DZE","Mi17_GREEN_DZE","Mi17_BLUE_DZE","Mi17_BLACK_DZE","Mi17_RUST_DZE","Mi17_WINTER_DZE"]) exitWith { 
		TURRET("100Rnd_762x54_PK",0) // also uses "1500Rnd_762x54_PKT","2000Rnd_762x54_PKT","250Rnd_762x54_PKT_T90","200Rnd_762x54_PKT"
		TURRET("100Rnd_762x54_PK",1)
		GEAR("100Rnd_762x54_PK")
	};

	if (_type in ["UH1Y_DZE","UH60M_EP1_DZE"]) exitWith {
		TURRET("2000Rnd_762x51_M134",0)
		TURRET("2000Rnd_762x51_M134",1)
		GEAR("2000Rnd_762x51_M134")
	};

	if (_type in ["UH1H_DZE","UH1H_WD_DZE","UH1H_DES_DZE","UH1H_GREY_DZE","UH1H_BLACK_DZE","UH1H_SAR_DZE","UH1H_WINTER_DZE","UH1Y_M240_DZE"]) exitWith {
		TURRET("100Rnd_762x51_M240",0) // also uses "1200Rnd_762x51_M240
		TURRET("100Rnd_762x51_M240",1)
		GEAR("100Rnd_762x51_M240")
	};

	if (_type in ["CH_47F_EP1_DZE","CH_47F_EP1_Black_DZE","CH_47F_EP1_GREY_DZE","CH_47F_EP1_DES_DZE"]) exitWith {
		TURRET("2000Rnd_762x51_M134",0)
		TURRET("2000Rnd_762x51_M134",1)
		TURRET("100Rnd_762x51_M240",2)
		GEAR("2000Rnd_762x51_M134")
	};
	
	if (_type == "HMMWV_M998A2_SOV_DES_EP1_DZE") exitWith {
		TURRET("48Rnd_40mm_MK19",0)
		TURRET("100Rnd_762x51_M240",1)
		GEAR("48Rnd_40mm_MK19")
	};

	if (_type == "LandRover_Special_CZ_EP1_DZE") exitWith {
		TURRET("29Rnd_30mm_AGS30",0)
		TURRET("100Rnd_762x54_PK",1)
		GEAR("29Rnd_30mm_AGS30")
	};

	if (_type == "GAZ_Vodnik_DZE") exitWith {
		TURRET("100Rnd_762x54_PK",0) // also uses "1500Rnd_762x54_PKT","2000Rnd_762x54_PKT","250Rnd_762x54_PKT_T90","200Rnd_762x54_PKT"
		TURRET("100Rnd_762x54_PK",1)
		GEAR("100Rnd_762x54_PK")
	};
	
	if (_type in ["HMMWV_M1151_M2_CZ_DES_EP1_DZE","LandRover_MG_TK_EP1_DZE","M113_UN_EP1_DZE","HMMWV_GPK_M2_WINTER_DZE","HMMWV_M2_DZE","M113_TK_EP1_DZE"]) exitWith {
		TURRET("100Rnd_127x99_M2",0)
		GEAR("100Rnd_127x99_M2")
	};
	
	if (_type == "ArmoredSUV_PMC_DZE") exitWith {
		TURRET("2000Rnd_762x51_M134",0)
		GEAR("2000Rnd_762x51_M134")
	};
	
	if (_type in ["Ka60_GL_PMC_DZE","Pickup_PK_TK_GUE_EP1_DZE","Pickup_PK_GUE_DZE","Pickup_PK_INS_DZE","ArmoredSUV_PKT_DZE","BRDM2_HQ_WINTER_DZE","BRDM2_HQ_TK_GUE_EP1_DZE","BMP2_HQ_INS_DZE","BMP2_HQ_CDF_DZE","BMP2_HQ_TK_EP1_DZE","BTR90_HQ_DZE","BRDM2_HQ_RUST_DZE","BRDM2_HQ_CDF_DZE"]) exitWith {
		TURRET("100Rnd_762x54_PK",0) // also uses "1500Rnd_762x54_PKT","2000Rnd_762x54_PKT","250Rnd_762x54_PKT_T90","200Rnd_762x54_PKT"
		GEAR("100Rnd_762x54_PK")
	};
	
	if (_type in ["BAF_Jackal2_L2A1_W_DZE","BAF_Jackal2_L2A1_D_DZE"]) exitWith {
		TURRET("100Rnd_127x99_M2",1)
		TURRET("200Rnd_762x51_M240",0)
		GEAR("100Rnd_127x99_M2")
	};
	
	if (_type in ["BAF_Jackal2_GMG_D_DZE","BAF_Jackal2_GMG_W_DZE"]) exitWith {
		TURRET("48Rnd_40mm_MK19",1)
		TURRET("200Rnd_762x51_M240",0)
		GEAR("48Rnd_40mm_MK19")
	};
	
	if (_type in ["BTR40_MG_TK_INS_EP1_DZE","BTR40_MG_TK_GUE_EP1_DZE","UAZ_MG_WINTER_DZE","HMMWV_M1114_DSHKM_ACR_DZE","UAZ_MG_TK_EP1_DZE","Offroad_DSHKM_Gue_DZE","UAZ_MG_RUST_EP1_DZE"]) exitWith {
		TURRET("150Rnd_127x107_DSHKM",0)
		GEAR("150Rnd_127x107_DSHKM")
	};
	
	if (_type in ["HMMWV_Armored_DZE","Dingo_WDL_ACR_DZE","Dingo_DST_ACR_DZE","LAV25_HQ_DZE","HMMWV_Winter_Armored_DZE","AW159_Lynx_BAF_DZE"]) exitWith {
		TURRET("100Rnd_762x51_M240",0) // also uses "1200Rnd_762x51_M240"
		GEAR("100Rnd_762x51_M240")
	};
	
	if (_type in ["HMMWV_M1114_AGS_ACR_DZE","UAZ_AGS30_TK_EP1_DZE","UAZ_AGS30_RUST_DZE","UAZ_AGS30_WINTER_DZE"]) exitWith {
		TURRET("29Rnd_30mm_AGS30",0)
		GEAR("29Rnd_30mm_AGS30")
	};
	
	if (_type in ["HMMWV_DES_MK19_DZE","Dingo_GL_Wdl_ACR_DZE","Dingo_GL_DST_ACR_DZE","HMMWV_MK19_DZE"]) exitWith {
		TURRET("48Rnd_40mm_MK19",0)
		GEAR("48Rnd_40mm_MK19")
	};
	
	if (_type in ["T810A_PKT_DES_ACR_DZE","T810A_PKT_ACR_DZE"]) exitWith {
		TURRET("200Rnd_762x54_PKT",0) // also uses "100Rnd_762x54_PK","1500Rnd_762x54_PKT","2000Rnd_762x54_PKT","250Rnd_762x54_PKT_T90"
		GEAR("200Rnd_762x54_PKT")
	};
	
	if (_type in ["BRDM2_WINTER_DZE","BRDM2_RUST_DZE","BRDM2_Desert_ACR_DZE","BTR60_TK_EP1_DZE","BTR60_Gue_DZE","BRDM2_TK_EP1_DZE","BRDM2_CDF_DZE","BRDM2_TK_GUE_EP1_DZE"]) exitWith {
		TURRET("1500Rnd_762x54_PKT",0) // also uses "100Rnd_762x54_PK","2000Rnd_762x54_PKT","250Rnd_762x54_PKT_T90","200Rnd_762x54_PKT"
		GEAR("1500Rnd_762x54_PKT")
	};
	
	if (_type == "LAV25_DZE") exitWith {
		TURRET("210Rnd_25mm_M242_APDS",0) // also uses "210Rnd_25mm_M242_HEI"
		TURRET("1200Rnd_762x51_M240",0)
		GEAR("210Rnd_25mm_M242_APDS")
	};
	
	if (_type == "BTR90_DZE") exitWith {
		TURRET("250Rnd_30mmAP_2A42",0) // also uses "150Rnd_30mmAP_2A42","230Rnd_30mmAP_2A42","150Rnd_30mmHE_2A42","230Rnd_30mmHE_2A42","250Rnd_30mmHE_2A42"
		TURRET("2000Rnd_762x54_PKT",0) // also uses "100Rnd_762x54_PK","1500Rnd_762x54_PKT","250Rnd_762x54_PKT_T90","200Rnd_762x54_PKT"
		TURRET("8Rnd_AT5_BMP2",0) // also uses "5Rnd_AT5_BRDM2"
		TURRET("400Rnd_30mm_AGS17",0)
		GEAR("250Rnd_30mmAP_2A42")
	};
	
	if (_type == "GAZ_Vodnik_HMG_DZE") exitWith {
		TURRET("250Rnd_30mmAP_2A42",0) // also uses "150Rnd_30mmAP_2A42","230Rnd_30mmAP_2A42","150Rnd_30mmHE_2A42","230Rnd_30mmHE_2A42","250Rnd_30mmHE_2A42"
		TURRET("2000Rnd_762x54_PKT",0) // also uses "100Rnd_762x54_PK","1500Rnd_762x54_PKT","250Rnd_762x54_PKT_T90","200Rnd_762x54_PKT"
		TURRET("SmokeLauncherMag",0)
		GEAR("250Rnd_30mmAP_2A42")
	};
	
	if (_type == "AH1Z_DZE") exitWith {
		TURRET("38Rnd_FFAR",-1) // also uses "28Rnd_FFAR"
		TURRET("750Rnd_M197_AH1",0)
		TURRET("8Rnd_Hellfire",0)
		TURRET("2Rnd_Sidewinder_AH1Z",0)
		GEAR("38Rnd_FFAR")
	};
};