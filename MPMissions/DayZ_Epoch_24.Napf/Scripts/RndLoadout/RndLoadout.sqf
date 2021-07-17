find_suitable_ammunition 	=
{

	private ["_weapon","_result","_ammoArray"];

	_result 	= 	false;
	_weapon 	= 	_this;
	_ammoArray 	= 	getArray (configFile >> "cfgWeapons" >> _weapon >> "magazines");

	if (count _ammoArray > 0) then
	{
		_result 	= 	_ammoArray select 0;
	};

	_result

};

loadout_fnc_selectRandom 	=
{
    _this select (floor random (count _this))
};

_primary 		=
[
	"AKS74_DZ","AKS_DZ","AKS_Silver_DZ","AKS_Gold_DZ","MAT49_DZ","M4A1_DZ","M4A1_Rusty_DZ","L85A2_DZ","G36C_DZ","ACR_BL_DZ","MK16_DZ","SA58_DZ","CTAR21_DZ","M31_DZ"
	,"Bizon_DZ","UMP_DZ","TMP_DZ","Scorpion_Evo3_DZ","PDR_DZ","P90_DZ","MP7_DZ","MP5_DZ","Kriss_DZ","KAC_PDW_DZ","Sten_MK_DZ"
	,"Saiga12K_DZ","Remington870_DZ","MR43_DZ","M1014_DZ"
	,"Winchester1866_DZ","Redryder","Mosin_DZ","LeeEnfield_DZ"
	,"Crossbow_DZ"
] call loadout_fnc_selectRandom;

_secondary 		=
[
	"APS_DZ","USP_DZ","TEC9_DZ","Tokarew_TT33_DZ","Ruger_MK2_DZ","Revolver_DZ","Revolver_Gold_DZ","DesertEagle_DZ","DesertEagle_Silver_DZ","DesertEagle_Gold_DZ","Colt_Anaconda_DZ","Colt_Anaconda_Gold_DZ","Colt_Bull_DZ","Colt_Python_DZ","Colt_Revolver_DZ","PPK_DZ","P99_Black_DZ","P38_DZ","P226_DZ","MK22_DZ","Makarov_DZ","M9_DZ","M93R_DZ","M1911_DZ","G18_DZ","G17_DZ","CZ75SP_DZ"
	,"UZI_EP1","SA61_DZ"
] call loadout_fnc_selectRandom;

_ammo 			= 	_primary call find_suitable_ammunition;
_ammos 			= 	_secondary call find_suitable_ammunition;

_food 			= 	["FoodBioMeat","FoodCanBakedBeans","FoodCanFrankBeans","FoodCanPasta","FoodCanSardines","FoodCanUnlabeled","FoodMRE","FoodNutmix","FoodPistachio","FoodSteakCooked"] call loadout_fnc_selectRandom;
_drink 			= 	["ItemSodaCoke","ItemSodaMdew","ItemSodaOrangeSherbet","ItemSodaPepsi","ItemSodaRbull","ItemWaterbottle"] call loadout_fnc_selectRandom;

_backpack 		= 	["Patrol_Pack_DZE1","GymBag_Camo_DZE1","TerminalPack_DZE1","TinyPack_DZE1","Czech_Vest_Pouch_DZE1","Assault_Pack_DZE1","TK_Assault_Pack_DZE1","School_Bag_DZE1","ALICE_Pack_DZE1","CompactPack_DZE1"] call loadout_fnc_selectRandom;

DefaultMagazines 		= 	["ItemBandage","ItemBandage","ItemMorphine","ItemPainkiller",_ammo,_ammos,_food,_drink]; 
DefaultWeapons 			= 	["ItemWatch",_primary,_secondary]; 
DefaultBackpack 		= 	_backpack; 
DefaultBackpackItems 	= 	"";