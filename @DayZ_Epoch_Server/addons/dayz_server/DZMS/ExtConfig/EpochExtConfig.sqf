/*
	EpochExtConfig.sqf
	This config file is loaded in DZMSInit.sqf if the Epoch mod is detected.
	It contains specific AI, Crate, and Vehicle configurations for DayZ Epoch.
*/

// Generates keys for mission vehicles and places it in the gear. Only works if DZMSSaveVehicles is set to true and Epoch is detected.
DZMSMakeVehKey = true;

//If you have ZSC installed then you can set this to true to place money in ai wallets.
DZMSAICheckWallet = true;

// Do you want AI to use RPG7V's?
// Odd numbered AI will spawn with one if enabled.
DZMSUseRPG = false;

// Do you want static M2 heavy machine gunners at the missions? (Some of the easier missions don't have them).
DZMSM2Static = false;

///////////////////////////////////////////////
// Arrays of skin classnames for the AI to use
DZMSBanditSkins = ["Bandit1_DZ","BanditW1_DZ","TK_INS_Warlord_EP1_DZ","GUE_Commander_DZ"];
DZMSHeroSkins = ["Soldier_Sniper_PMC_DZ","Survivor2_DZ","SurvivorW2_DZ","Soldier1_DZ","Camo1_DZ","UN_CDF_Soldier_EP1_DZ"];

////////////////////////
// Array of AI Skills
DZMSSkills0 = [
	["aimingAccuracy",0.10,0.125],
	["aimingShake",0.45,0.55],
	["aimingSpeed",0.45,0.55],
	["endurance",0.40,0.50],
	["spotDistance",0.30,0.45],
	["spotTime",0.30,0.45],
	["courage",0.40,0.60],
	["reloadSpeed",0.50,0.60],
	["commanding",0.40,0.50],
	["general",0.40,0.60]
];

DZMSSkills1 = [
	["aimingAccuracy",0.125,0.15],
	["aimingShake",0.60,0.70],
	["aimingSpeed",0.60,0.70],
	["endurance",0.55,0.65],
	["spotDistance",0.45,0.60],
	["spotTime",0.45,0.60],
	["courage",0.55,0.75],
	["reloadSpeed",0.60,0.70],
	["commanding",0.55,0.65],
	["general",0.55,0.75]
];

DZMSSkills2 = [
	["aimingAccuracy",0.15,0.20],
	["aimingShake",0.75,0.85],
	["aimingSpeed",0.70,0.80],
	["endurance",0.70,0.80],
	["spotDistance",0.60,0.75],
	["spotTime",0.60,0.75],
	["courage",0.70,0.90],
	["reloadSpeed",0.70,0.80],
	["commanding",0.70,0.90],
	["general",0.70,0.90]
];

DZMSSkills3 = [	
	["aimingAccuracy",0.20,0.25],
	["aimingShake",0.85,0.95],
	["aimingSpeed",0.80,0.90],
	["endurance",0.80,0.90],
	["spotDistance",0.70,0.85],
	["spotTime",0.70,0.85],
	["courage",0.80,1.00],
	["reloadSpeed",0.80,0.90],
	["commanding",0.80,0.90],
	["general",0.80,1.00]
];

// Set the bloodbag type
_bloodbag = if (dayz_classicBloodBagSystem) then {"ItemBloodbag"} else {"bloodBagONEG"};

/////////////////////////////////////////////////////////////
// These are gear sets that will be randomly given to the AI
DZMSGear0 = [
	["ItemBandage","ItemBandage","ItemAntibiotic","ItemPainkiller","ItemSodaGrapeDrink","FoodBaconCooked"],
	["ItemKnife","ItemFlashlight"]
];

DZMSGear1 = [
	["ItemBandage","ItemBandage","ItemPainkiller","ItemMorphine","ItemSodaRocketFuel","FoodGoatCooked"],
	["ItemToolbox","ItemEtool"]
];

DZMSGear2 = [
	["ItemBandage","ItemAntibacterialWipe",_bloodbag,"ItemPainkiller","ItemSodaSacrite","FishCookedTrout"],
	["ItemMatchbox","ItemHatchet"]
];

DZMSGear3 = [
	["ItemBandage","ItemBandage","ItemMorphine","ItemHeatPack","ItemSodaRabbit","FoodMRE"],
	["ItemCrowbar","ItemMachete"]
];

DZMSGear4 = [
	["ItemBandage","ItemAntibacterialWipe","ItemEpinephrine",_bloodbag,"ItemSodaMtngreen","FoodRabbitCooked"],
	["ItemGPS","Binocular_Vector"]
];


/////////////////////////////////////////////////////////////////////////////////////////////
// These are arrays of vehicle classnames for the missions.
// Adjust to your liking.

//Armed Choppers
DZMSChoppers = ["UH1H_DZE","Mi17_DZE","UH60M_MEV_EP1_DZ","BAF_Merlin_DZE","UH60M_EP1_DZE","CH_47F_EP1_DZE","MH60S_DZE","UH1Y_DZE","AW159_Lynx_BAF_DZE","Ka60_GL_PMC_DZE"];

//Small Vehicles
DZMSSmallVic = ["hilux1_civil_3_open_DZE","SUV_TK_CIV_EP1_DZE","HMMWV_DZ","UAZ_Unarmed_UN_EP1_DZE","HMMWV_Ambulance_CZ_DES_EP1_DZE","LandRover_TK_CIV_EP1_DZE","SUV_Camo"];

//Large Vehicles
DZMSLargeVic = ["Ural_TK_CIV_EP1_DZE","Ural_CDF_DZE","Ural_UN_EP1_DZE","UralCivil_DZE","UralCivil2_DZE","MTVR_DES_EP1_DZE","MTVR_DZE","Kamaz_DZE","KamazOpen_DZE"];

////////////////////////////////////////////////////////////////
// Weapons Arrays -  These can be adjusted as desired or make your own custom arrays
DZMSPistol = ["M9_DZ","M9_SD_DZ","G17_DZ","G17_SD_DZ","Makarov_DZ","Makarov_SD_DZ","Revolver_DZ","M1911_DZ","Sa61_DZ","PDW_DZ"];
DZMSAssault = ["M16A2_DZ","M4A1_DZ","M4A1_SD_DZ","SA58_RIS_DZ","L85A2_DZ","L85A2_SD_DZ","AKM_DZ","G36C_DZ","G36C_SD_DZ","G36A_Camo_DZ","G36K_Camo_DZ","G36K_Camo_SD_DZ"];
DZMSLMG = ["L110A1_DZ","M249_DZ","M240_DZ","Mk48_DZ","RPK_DZ","UK59_DZ","PKM_DZ"];
DZMSSMG = ["Bizon_DZ","Bizon_SD_DZ","MP5_DZ","MP5_SD_DZ"];
DZMSSniper = ["Mosin_PU_DZ","M4SPR_DZE","M14_DZ","M24_DZ","M24_DES_DZ","M40A3_DZ","SVD_DZ","SVD_PSO1_Gh_DES_DZ","FNFAL_DZ","DMR_DZ","L115A3_DZ","L115A3_2_DZ"];
DZMSSingleShot = ["Remington870_DZ","M1014_DZ","Winchester1866_DZ","LeeEnfield_DZ","CZ550_DZ"];

// Weapon arrays that can spawn on the AI
DZMSAIWeps = [DZMSAssault,DZMSSMG,DZMSSingleShot,DZMSLMG,DZMSSniper];

// Weapon arrays that can spawn in the crates - Pistols spawn separately
DZMSCrateWeps = [DZMSAssault,DZMSLMG,DZMSSniper];

// Items and tools that can be added to crates
DZMSGeneralStore = ["forest_net_kit","ItemMixOil","ItemWaterBottleSafe","ItemSodaCoke","ItemSodaPepsi","ItemSodaMdew","ItemSodaMtngreen","ItemSodaR4z0r","ItemSodaClays","ItemSodaSmasht","ItemSodaDrwaste","ItemSodaFranka","ItemSodaLemonade","ItemSodaLirik","ItemSodaLvg","ItemSodaMzly","ItemSodaPeppsy","ItemSodaRabbit","ItemSodaSacrite","ItemSodaRocketFuel","ItemSodaGrapeDrink","ItemSherbet","FoodPistachio","FoodNutmix","FoodChipsSulahoops","FoodChipsMysticales","FoodChipsChocolate","FoodCandyChubby","FoodCandyAnders","FoodCandyLegacys","FoodCandyMintception","FoodCakeCremeCakeClean","FoodCanBeef","FoodCanPotatoes","FoodCanGriff","FoodCanBadguy","FoodCanBoneboy","FoodCanCorn","FoodCanCurgon","FoodCanDemon","FoodCanFraggleos","FoodCanHerpy","FoodCanDerpy","FoodCanOrlok","FoodCanPowell","FoodCanTylers","FoodCanUnlabeled","FoodCanBakedBeans","FoodCanSardines","FoodCanFrankBeans","FoodCanPasta","FoodCanRusUnlabeled","FoodCanRusStew","FoodCanRusPork","FoodCanRusPeas","FoodCanRusMilk","FoodCanRusCorn","ItemJerrycan"];
DZMSCrateTools = ["ItemToolbox","ItemFishingPole","ItemGPS","ItemMap","ItemMachete","ItemKnife","ItemFlashlight","ItemMatchbox","ItemHatchet","Binocular_Vector"];
DZMSMeds = [_bloodbag,"ItemBandage","ItemAntibiotic","ItemPainkiller","ItemMorphine","ItemAntibacterialWipe","ItemEpinephrine","FoodMRE","ItemWaterBottleSafe"];
DZMSPacks = ["Patrol_Pack_DZE1","Assault_Pack_DZE1","Czech_Vest_Pouch_DZE1","TerminalPack_DZE1","TinyPack_DZE1","ALICE_Pack_DZE1","TK_Assault_Pack_DZE1","CompactPack_DZE1","British_ACU_DZE1","GunBag_DZE1","NightPack_DZE1","SurvivorPack_DZE1","AirwavesPack_DZE1","CzechBackpack_DZE1","WandererBackpack_DZE1","LegendBackpack_DZE1","CoyoteBackpack_DZE1","LargeGunBag_DZE1"];

// Items and tools that are only added to crates
DZMSGrenades = ["HandGrenade_west","FlareGreen_M203","FlareWhite_M203"];
DZMSBuildSupply = [[3,"CinderBlocks"],[1,"MortarBucket"],[3,"ItemPole"],[3,"PartPlywoodPack"],[3,"PartPlankPack"],[3,"ItemSandbag"],[3,"ItemWire"],[1,"ItemFireBarrel_kit"],[1,"forest_large_net_kit"],[1,"ItemComboLock"],[1,"ItemLockbox"],[3,"ItemTankTrap"]]; // [Number to add to crate,Item]
DZMSBuildSupply2 = [[3,"CinderBlocks"],[1,"MortarBucket"],[3,"ItemPole"],[3,"PartPlywoodPack"],[3,"PartPlankPack"],[3,"ItemSandbag"],[3,"ItemWire"],[1,"ItemFireBarrel_kit"],[1,"forest_large_net_kit"],[1,"ItemComboLock"],[1,"ItemLockbox"],[3,"ItemTankTrap"]]; // [Number to add to crate,Item]
DZMSBuildTools = ["ItemCrowbar","ItemEtool","ItemToolbox","ItemSledgeHammer","ChainSaw"];
DZMSHighValue = ["ItemBriefcase100oz","ItemVault"];

DZMSAmmoRU = [
	"30Rnd_545x39_AK","30Rnd_545x39_AK","30Rnd_545x39_AKSD","75Rnd_545x39_RPK",
	"30Rnd_762x39_AK47","75Rnd_762x39_RPK",
	"10Rnd_762x54_SVD","100Rnd_762x54_PK",
	"30Rnd_762x39_SA58","50Rnd_762x54_UK59",
	"1Rnd_HE_GP25","FlareGreen_GP25","1Rnd_Smoke_GP25",
	"HandGrenade_East","SmokeShell","SmokeShellRed","SmokeShellGreen","PipeBomb"
];

DZMSAmmoUS = [
	"30Rnd_556x45_Stanag","30Rnd_556x45_Stanag","30Rnd_556x45_StanagSD","200Rnd_556x45_M249",
	"20Rnd_762x51_DMR","100Rnd_762x51_M240",
	"30Rnd_556x45_G36","30Rnd_556x45_G36SD",
	"20Rnd_762x51_FNFAL","5Rnd_86x70_L115A1",
	"1Rnd_HE_M203","FlareGreen_M203","1Rnd_Smoke_M203",
	"HandGrenade_West"
];
