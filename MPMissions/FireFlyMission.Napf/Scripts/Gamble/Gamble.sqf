/***************************************************/
/*	   											   */
/*	 O9 Gambling Script by Airwaves Man      	   */
/*	 If you use it please give credit			   */
/*												   */		
/*												   */
/***************************************************/

if (dayz_actionInProgress) exitWith { localize "STR_CL_GAMBLE_ALREADY" call dayz_rollingMessages;};
dayz_actionInProgress = true;

private ["_fn_additems", "_playerMoney", "_gambleAmount", "_freeTry", "_hasCards", "_playerMoneyNew", "_hasGold", "_gambleChance", "_winNumbers", "_prizeWeapons", "_prizeTools", "_prizeAmmo", "_prizeItems", "_multi", "_money", "_coins", "_winOutput", "_qyt", "_fn_additems", "_itemDisplay"];
closeDialog 0;

_fn_additems = {
	private ["_item", "_qyt", "_type", "_itemtype", "_holder", "_magazine", "_pos"];

	_item = _this select 0;
	_qyt = _this select 1;
	_type = _this select 2;
	_itemtype = _this select 3;

	_holder = objNull;
	_pos = getPosATL player;
	_holder = createVehicle ["WeaponHolder", _pos, [], 1, "CAN_COLLIDE"];

	if (_type == 1) exitwith {
		if(_itemtype == "weapon") then {
			_magazine = getArray (configFile >> "CfgWeapons" >> _item >> "magazines") select 0;
			[_magazine,3,2] call _fn_additems;
		};
		_holder addWeaponCargoGlobal [_item,_qyt];
	};

	if (_type == 2) exitwith {
		_holder addMagazineCargoGlobal [_item,_qyt];
	};
};

_playerMoney = player getVariable [(["cashMoney","globalMoney"] select Z_persistentMoney),0];
_gambleAmount = _this select 3;
_freeTry = false;
_hasCards = "ItemCards" in magazines player;

if (_gambleAmount == 0 ) then {
	_freeTry = true;
};

if ((_gambleAmount == 0) && !_hasCards ) exitwith {dayz_actionInProgress = false; _freeTry = false; localize "STR_CL_GAMBLE_PRICEFREE_NO_CARDS" call dayz_rollingMessages;};

if ((_playerMoney < _gambleAmount) && !_freeTry) exitwith {dayz_actionInProgress = false; format [ localize "STR_CL_GAMBLE_NO_MONEY",CurrencyName] call dayz_rollingMessages;};

if (_freeTry) then {
	player removeMagazine "ItemCards";
} else {
	_playerMoneyNew = _playerMoney - _gambleAmount;
	player setVariable [(["cashMoney","globalMoney"] select Z_persistentMoney),_playerMoneyNew,true];
};

call player_forceSave;
_hasGold = true;

_gambleChance = floor(random 1550);
_winNumbers = [3,11,27,32,44,54,66,68,71,88,99,120,132,134,146,147,149,154,175,189,191,199,221,231,249,251,276,290,310,343,344,354,376,396,404,442,456,479,491,523,541,589,611,635,676,678,689,739,786,832,856,876,921,934,959,999,1001,1015,1043,1073,1110,1146,1199,1204,1214,1224,1234,1244,1245,1254,1259,1280,1355,1371,1420,1422,1499];
_prizeWeapons = [ "Makarov_DZ" ,"M4A1_FL_DZ" ,"SA58_RIS_MFL_DZ", "Famas_Holo_DZ" ,"MK16_CCO_SD_DZ" ,"M14_CCO_Gh_DZ" ,"M4A1_Camo_Holo_GL_SD_DZ" ,"G36C_ACOG_SD_DZ" ,"M9_DZ" ,"G17_DZ" ,"M1911_DZ" ,"Revolver_DZ" ,"Revolver_Gold_DZ" ,"Makarov_SD_DZ" ,"Mosin_DZ" ,"LeeEnfield_DZ" ,"Winchester1866_DZ" ,"MR43_DZ" ,"Remington870_DZ" ,"M1014_DZ" ,"AA12_DZ" ,"Saiga12K_DZ" ,"RedRyder" ,"CZ550_DZ" ,"M4SPR_DZE" ,"L115A3_DZ" ,"MK17_Sniper_DZ" ,"MK17_Sniper_SD_DZ" ,"SVD_PSO1_DZ" ,"SVD_PSO1_Gh_DES_DZ" ,"SVD_NSPU_DZ" ,"M24_DZ" ,"M40A3_DZ" ,"DMR_DZ" ,"KSVK_DZE" ,"VSS_vintorez_DZE" ,"Bizon_SD_DZ" ,"MP5_SD_DZ" ,"AK74_DZ" ,"AKM_DZ" ,"AKS_74_NSPU" ,"AKS_Gold_DZ" ,"FNFAL_DZ" ,"G36K_Camo_DZ" ,"G36C_SD_DZ" ,"M4A1_SD_FL_DZ" ,"M4A1_DZ" ,"M4A1_ACOG_DZ" ,"M14_DZ" ,"SA58_DZ" ,"MK16_CCO_DZ" ,"MK17_CCO_SD_DZ" ,"L85A2_Holo_DZ" ,"M249_DZ" ,"L110A1_DZ" ,"M240_DZ" ,"Pecheneg_DZ" ,"M60A4_EP1_DZE" ,"Mk48_DZ" ,"PKM_DZ" ,"UK59_DZ" ,"RPK74_DZ" ,"RPK_DZ" ,"MG36_DZ" ];
_prizeTools = [ "ItemEtool" ,"Binocular_Vector" ,"NVGoggles" ,"ItemShovel" ,"ItemToolbox" ,"ItemCrowbar" ,"ItemSledge" ,"ItemKeyKit" ,"ChainSawP" ];
_prizeAmmo = [ "30Rnd_556x45_Stanag" ,"30Rnd_9x19_MP5" ,"30Rnd_545x39_AKSD" ,"5Rnd_17HMR" ,"5Rnd_762x54_Mosin" ,"30Rnd_762x39_AK47" ,"29Rnd_30mm_AGS30" ,"50Rnd_127x107_DSHKM" ,"48Rnd_40mm_MK19" ,"100Rnd_127x99_M2" ,"8Rnd_9x18_MakarovSD" ,"15Rnd_9x19_M9SD" ,"17Rnd_9x19_glock17SD" ,"30Rnd_9x19_UZI_SD" ,"30Rnd_9x19_MP5SD" ,"64Rnd_9x19_SD_Bizon" ,"30Rnd_556x45_G36SD" ,"30Rnd_556x45_StanagSD" ,"20Rnd_762x51_SB_SCAR" ,"20Rnd_762x51_FNFAL" ,"20Rnd_762x51_B_SCAR" ,"75Rnd_545x39_RPK" ,"50Rnd_762x54_UK59" ,"200Rnd_556x45_M249" ,"100Rnd_762x51_M240" ,"100Rnd_762x54_PK" ,"75Rnd_762x39_RPK" ,"5Rnd_762x51_M24" ,"10Rnd_762x54_SVD" ,"5Rnd_127x108_KSVK" ,"10Rnd_127x99_m107" ,"20Rnd_9x39_SP5_VSS" ,"5Rnd_86x70_L115A1" ,"20Rnd_762x51_DMR" ,"Attachment_BELT" ,"Attachment_SA58RIS" ,"Attachment_Ghillie" ,"Attachment_FL_Pist" ,"Attachment_FL" ,"Attachment_MFL_Pist" ,"Attachment_MFL" ,"Attachment_CCO" ,"Attachment_Holo" ,"Attachment_Kobra" ,"Attachment_SCOPED" ,"Attachment_ACOG" ,"Attachment_PSO1" ,"Attachment_Sup9" ,"Attachment_Sup545" ,"Attachment_Sup556" ,"Attachment_GP25" ,"Attachment_M203" ];
_prizeItems = [ "ItemKiloHemp" ,"ItemComboLock" ,"ItemLockbox" ,"ItemVault" ,"ItemComboLock" ,"ItemLockbox" ,"ItemVault" ,"ItemSilverBar10oz" ,"ItemGoldBar10oz" ,"equip_floppywire" ,"equip_scrapelectronics" ,"PartPlankPack" ,"PartPlywoodPack" ,"PartOreGold" ,"PartOreSilver" ,"PartOre" ,"FoodbaconCooked" ,"FoodbeefCooked" ,"FoodchickenCooked" ,"FoodGoatCooked" ,"FishCookedTrout" ,"FishCookedSeaBass" ,"FishCookedTuna" ,"FoodrabbitCooked" ,"FoodCanBakedBeans" ,"FoodCanBoneboy" ,"FoodCanFrankBeans" ,"FoodChipsChocolate" ,"ItemSodaCoke" ,"ItemSodaMdew" ,"ItemSodaRbull" ,"ItemSodaOrangeSherbet" ,"ItemKosmosSmokes" ,"ItemBandage" ,"ItemAntibiotic" ,"ItemMorphine" ,"ItemCards" ,"emptyBloodBag" ,"PartEngine" ,"PartVRotor" ,"PartWheel" ,"PartGlass" ,"PartFueltank" ,"ItemTent" ,"ItemDomeTent" ,"ItemDesertTent" ,"plot_pole_kit" ,"plot_pole_kit" ,"ItemMixOil" ,"Skin_FR_Sapper_DZ" ,"Skin_TK_Soldier_Sniper_EP1_DZ" ,"Skin_Sniper1_DZ" ,"Skin_BAF_Soldier_Officer_MTP_DZ" ,"Skin_GUE_Soldier_Sniper_DZ" ,"CinderBlocks" ,"metal_floor_kit" ,"half_cinder_wall_kit" ,"full_cinder_wall_kit" ,"ItemBookBible" ,"ItemLetter" ,"ItemOilBarrel" ,"ItemOilBarrel" ,"storage_shed_kit" ,"wood_ramp_kit" ,"ItemRSJ" ,"Skin_MVD_Soldier_DZ" ,"Skin_RUS_Commander_DZ" ,"Skin_Ins_Commander_DZ" ,"ItemNewspaper" ,"ItemTrashPaperMusic" ,"ItemBook1" ,"ItemBook2" ,"ItemBook3" ,"ItemBook4" ,"ItemGenerator" ,"equip_nails" ,"ItemCorrugated" ,"ItemPole" ,"ItemSandbag" ,"ItemWoodWall" ,"ItemFireBarrel_kit" ,"outhouse_kit" ,"park_bench_kit" ,"BagFenceRound_DZ_kit" ,"forest_net_kit" ,"desert_net_kit" ,"ItemScaffoldingKit" ,"ItemGunRackKit" ,"ItemWoodCrateKit" ,"deer_stand_kit" ,"Skin_Rocker2_DZ" ,"Skin_Priest_DZ" ,"Skin_RU_Policeman_DZ" ,"Skin_Rocker3_DZ" ,"FoodCanPasta" ,"FoodCanSardines" ,"FoodCanBeef" ,"FoodCanPotatoes" ,"FoodCanGriff" ,"FoodCanBadguy" ,"FoodCanBoneboy" ,"FoodCakeCremeCakeClean" ,"FoodCandyLegacys" ,"FoodCandyAnders" ,"ItemHotwireKit"  ];

if ((_gambleAmount == 1000) || (_gambleAmount == 0)) then {
	_multi = 1;
};

if (_gambleAmount == 2000) then {
	_multi = 2;
};

if (_gambleAmount == 3000) then {
	_multi = 3;
};

if (_hasGold) then {
	_hasGold = false;
	
	if (_freeTry) then {
		localize "STR_CL_GAMBLE_GAMBLING_FOR_FREE" call dayz_rollingMessages;
	} else {
		format [localize "STR_CL_GAMBLE_GAMBLING_FOR_X_COINS", [_gambleAmount] call BIS_fnc_numberText,CurrencyName] call dayz_rollingMessages;
	};
	uiSleep 3;
	//_gambleChance = [3,32,44,54,66,68,71,88,120,132,134,146,147,149,154,175,189,199,221,231,249,276,290,310,343,344,354,376,396,404,442,456,479,491,523,541,589,611,635,676,678,689,739,786,832,856,876,921,934,959,999,1001,1043,1110,1199,1204,1214,1224,1234,1244,1245,1254,1259,1499]call BIS_fnc_selectRandom;

	if (_gambleChance in _winNumbers) then {
		[objNull, player, rSAY, "tada",5] call RE;

		call {
			if (_gambleChance < 200) exitwith {
				_winOutput = _prizeWeapons call BIS_fnc_selectRandom;
				_qyt = 1*_multi;
				[_winOutput,_qyt,1,"weapon",1] call _fn_additems;
				_itemDisplay = getText (configFile >> "CfgWeapons" >> _winOutput >> "displayName");
				format [localize "STR_CL_GAMBLE_WON", _qyt, _itemDisplay] call dayz_rollingMessages;
			};

			if ((_gambleChance > 200) && (_gambleChance < 400)) exitwith {
				_winOutput = _prizeTools call BIS_fnc_selectRandom;
				_qyt = 3*_multi;
				[_winOutput,_qyt,1,"tools",1] call _fn_additems;
				_itemDisplay = getText (configFile >> "CfgWeapons" >> _winOutput >> "displayName");
				format [localize "STR_CL_GAMBLE_WON", _qyt, _itemDisplay] call dayz_rollingMessages;
			};

			if ((_gambleChance > 400) && (_gambleChance < 600)) exitwith {
				_winOutput = _prizeAmmo call BIS_fnc_selectRandom;
				_qyt = 3*_multi;
				[_winOutput,_qyt,2,"items",1] call _fn_additems;
				_itemDisplay = getText (configFile >> "CfgMagazines" >> _winOutput >> "displayName");
				format [localize "STR_CL_GAMBLE_WON", _qyt, _itemDisplay] call dayz_rollingMessages;
			};

			if ((_gambleChance > 600) && (_gambleChance < 800)) exitwith {
				_winOutput = _prizeItems call BIS_fnc_selectRandom;
				_qyt = 3*_multi;
				[_winOutput,_qyt,2,"items",1] call _fn_additems;
				_itemDisplay = getText (configFile >> "CfgMagazines" >> _winOutput >> "displayName");
				format [localize "STR_CL_GAMBLE_WON", _qyt, _itemDisplay] call dayz_rollingMessages;
			};

			if ((_gambleChance > 800) && (_gambleChance < 1000)) exitwith {
				_winOutput = _prizeItems call BIS_fnc_selectRandom;
				_qyt = 3*_multi;
				[_winOutput,_qyt,2,"items",1] call _fn_additems;
				_itemDisplay = getText (configFile >> "CfgMagazines" >> _winOutput >> "displayName");
				format [localize "STR_CL_GAMBLE_WON", _qyt, _itemDisplay] call dayz_rollingMessages;
			};

			if ((_gambleChance > 1000) && (_gambleChance < 1200)) exitwith {
				_winOutput = _prizeAmmo call BIS_fnc_selectRandom;
				_qyt = 3*_multi;
				[_winOutput,_qyt,2,"items",1] call _fn_additems;
				_itemDisplay = getText (configFile >> "CfgMagazines" >> _winOutput >> "displayName");
				format [localize "STR_CL_GAMBLE_WON", _qyt, _itemDisplay] call dayz_rollingMessages;
			};

			if ((_gambleChance > 1200) && (_gambleChance < 1270)) exitwith {
				_money = player getVariable [(["cashMoney","globalMoney"] select Z_persistentMoney),0];
				_coins = (1000 + floor(random 50000))*_multi;
				player setVariable [(["cashMoney","globalMoney"] select Z_persistentMoney),(_money + _coins),true];
				call player_forceSave;
				format [localize "STR_CL_GAMBLE_WON_COINS", [_coins] call BIS_fnc_numberText,CurrencyName] call dayz_rollingMessages;
			};
			if (_gambleChance == 1499) exitwith {
				uisleep 2;
				[objNull, player, rSAY, "tada",5] call RE;
				_money = player getVariable [(["cashMoney","globalMoney"] select Z_persistentMoney),0];
				_coins = (100000 + floor(random 250000))*_multi; // Jackpot
				player setVariable [(["cashMoney","globalMoney"] select Z_persistentMoney),(_money + _coins),true];
				call player_forceSave;
				format [localize "STR_CL_GAMBLE_WON_COINS_JACKPOT", [_coins] call BIS_fnc_numberText,CurrencyName] call dayz_rollingMessages;
				uisleep 2;
				[objNull, player, rSAY, "tada",5] call RE;
			};
		};

		uiSleep 3;
	} else {
		localize "STR_CL_GAMBLE_NO_LUCK" call dayz_rollingMessages;
	};
};

dayz_actionInProgress = false;