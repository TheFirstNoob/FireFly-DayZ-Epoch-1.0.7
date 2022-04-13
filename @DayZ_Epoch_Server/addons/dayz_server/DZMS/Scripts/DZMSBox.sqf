/*
	_crate is the object to fill
	_type is the type of crate
*/
local _crate = _this select 0;
local _type = _this select 1;
local _scount = 0;
local _sSelect = 0;
local _item = "";
local _ammo = [];
local _cfg = "";
local _attach = "";
local _qty = 0;

//////////////////////////////////////////////////////////////////
// Medical Crates
if (_type == "medical") then {
	// load medical
	_scount = count DZMSMeds;
	for "_x" from 0 to 40 do {
		_sSelect = floor(random _sCount);
		_item = DZMSMeds select _sSelect;
		_crate addMagazineCargoGlobal [_item,1];
	};
	
	// load packs
	_scount = count DZMSPacks;
	for "_x" from 0 to 2 do {
		_sSelect = floor(random _sCount);
		_item = DZMSPacks select _sSelect;
		_crate addBackpackCargoGlobal [_item,1];
	};
};

////////////////////////////////////////////////////////////////
// General Store Crate
if (_type == "store") then {
	// load food/drink
	_scount = count DZMSGeneralStore;
	for "_x" from 0 to 40 do {
		_sSelect = floor(random _sCount);
		_item = DZMSGeneralStore select _sSelect;
		_crate addMagazineCargoGlobal [_item,1];
	};
	
	// load survival tools
	_scount = count DZMSCrateTools;
	for "_x" from 0 to 4 do {
		_sSelect = floor(random _sCount);
		_item = DZMSCrateTools select _sSelect;
		_crate addWeaponCargoGlobal [_item,1];
	};
	
	// load packs
	_scount = count DZMSPacks;
	for "_x" from 0 to 2 do {
		_sSelect = floor(random _sCount);
		_item = DZMSPacks select _sSelect;
		_crate addBackpackCargoGlobal [_item,1];
	};
	 
	// load pistols
	_scount = count DZMSPistol;
	for "_x" from 0 to 2 do {
		_sSelect = floor(random _sCount);
		_item = DZMSPistol select _sSelect;
		_crate addWeaponCargoGlobal [_item,1];
		_ammo = getArray (configFile >> "cfgWeapons" >> _item >> "magazines");
		if (count _ammo > 0) then {
			_crate addMagazineCargoGlobal [(_ammo select 0),(round(random 8))];
		};
		if (!DZMSOverwatch) then {
			_cfg = configFile >> "CfgWeapons" >> _item >> "Attachments";
			if (isClass _cfg && count _cfg > 0) then {
				_attach = configName (_cfg call BIS_fnc_selectRandom);
				_crate addMagazineCargoGlobal [_attach,1];
			};
		};
	};
	
	
};

///////////////////////////////////////////////////////////////////
// Weapon Crate Small
if (_type == "weapons") then {
	// load grenades
	_scount = count DZMSGrenades;
	for "_x" from 0 to 5 do {
		_sSelect = floor(random _sCount);
		_item = DZMSGrenades select _sSelect;
		_crate addMagazineCargoGlobal [_item,1];
	};
   
	// load packs
	_scount = count DZMSPacks;
	for "_x" from 0 to 3 do {
		_sSelect = floor(random _sCount);
		_item = DZMSPacks select _sSelect;
		_crate addBackpackCargoGlobal [_item,1];
	};
	 
	// load pistols and attachments
	_scount = count DZMSPistol;
	for "_x" from 0 to 2 do {
		_sSelect = floor(random _sCount);
		_item = DZMSPistol select _sSelect;
		_crate addWeaponCargoGlobal [_item,1];
		_ammo = getArray (configFile >> "cfgWeapons" >> _item >> "magazines");
		if (count _ammo > 0) then {
			_crate addMagazineCargoGlobal [(_ammo select 0),(round(random 8))];
		};
		if (!DZMSOverwatch) then {
			_cfg = configFile >> "CfgWeapons" >> _item >> "Attachments";
			if (isClass _cfg && count _cfg > 0) then {
				_attach = configName (_cfg call BIS_fnc_selectRandom);
				_crate addMagazineCargoGlobal [_attach,1];
			};
		};
	};
	
	// Load Weapons and attachments
	for "_x" from 0 to 5 do {
		_wepArray = DZMSCrateWeps call BIS_fnc_selectRandom;
		_item = _wepArray call BIS_fnc_selectRandom;
		_crate addWeaponCargoGlobal [_item,1];
		_ammo = getArray (configFile >> "cfgWeapons" >> _item >> "magazines");
		if (count _ammo > 0) then {
			_crate addMagazineCargoGlobal [(_ammo select 0),(round(random 8))];
		};
		if (!DZMSOverwatch) then {
			_cfg = configFile >> "CfgWeapons" >> _item >> "Attachments";
			if (isClass _cfg && count _cfg > 0) then {
				_attach = configName (_cfg call BIS_fnc_selectRandom);
				if (_attach == "Attachment_Tws") then {
					if (DZMS_AllowThermal) then {
						_crate addMagazineCargoGlobal [_attach,1];
					};
				} else {
					_crate addMagazineCargoGlobal [_attach,1];
				};
			};
		};
	};
};

///////////////////////////////////////////////////////////////////
// Weapon Crate Large
if (_type == "weapons2") then {
	// load grenades
	_scount = count DZMSGrenades;
	for "_x" from 0 to 5 do {
		_sSelect = floor(random _sCount);
		_item = DZMSGrenades select _sSelect;
		_crate addMagazineCargoGlobal [_item,1];
	};
   
	// load packs
	_scount = count DZMSPacks;
	for "_x" from 0 to 3 do {
		_sSelect = floor(random _sCount);
		_item = DZMSPacks select _sSelect;
		_crate addBackpackCargoGlobal [_item,1];
	};
	 
	// load pistols
	_scount = count DZMSPistol;
	for "_x" from 0 to 3 do {
		_sSelect = floor(random _sCount);
		_item = DZMSPistol select _sSelect;
		_crate addWeaponCargoGlobal [_item,1];
		_ammo = getArray (configFile >> "cfgWeapons" >> _item >> "magazines");
		if (count _ammo > 0) then {
			_crate addMagazineCargoGlobal [(_ammo select 0),(round(random 8))];
		};
	};
	
	// Load Weapons
	for "_x" from 0 to 10 do {
		_wepArray = DZMSCrateWeps call BIS_fnc_selectRandom;
		_item = _wepArray call BIS_fnc_selectRandom;
		_crate addWeaponCargoGlobal [_item,1];
		_ammo = getArray (configFile >> "cfgWeapons" >> _item >> "magazines");
		if (count _ammo > 0) then {
			_crate addMagazineCargoGlobal [(_ammo select 0),(round(random 8))];
		};
		if (!DZMSOverwatch) then {
			_cfg = configFile >> "CfgWeapons" >> _item >> "Attachments";
			if (isClass _cfg && count _cfg > 0) then {
				_attach = configName (_cfg call BIS_fnc_selectRandom);
				if (_attach == "Attachment_Tws") then {
					if (DZMS_AllowThermal) then {
						_crate addMagazineCargoGlobal [_attach,1];
					};
				} else {
					_crate addMagazineCargoGlobal [_attach,1];
				};
			};
		};
	};
};

///////////////////////////////////////////////////////////////////
// Supply Crate
if (_type == "supply") then {
	// load tools
	_scount = count DZMSBuildTools;
	for "_x" from 0 to 3 do {
		_sSelect = floor(random _sCount);
		_item = DZMSBuildTools select _sSelect;
		_crate addWeaponCargoGlobal [_item,1];
	};
	
	// load construction supplies
	_scount = count DZMSBuildSupply;
	for "_x" from 0 to 30 do {
		_sSelect = floor(random _sCount);
		_item = DZMSBuildSupply select _sSelect;
		_qty = _item select 0;
		_type = _item select 1;
		_crate addMagazineCargoGlobal [_type,_qty];
	};
	
	// load crafting supplies
	_scount = count DZMSCraftingSupply;
	for "_x" from 0 to 20 do {
		_sSelect = floor(random _sCount);
		_item = DZMSCraftingSupply select _sSelect;
		_crate addMagazineCargoGlobal [_item,1];
	};
	
	// load high value
	_scount = count DZMSHighValue;
	if (_scount > 0 && {random 1 < .3}) then {
		for "_x" from 0 to 0 do {
			_sSelect = floor(random _sCount);
			_item = DZMSHighValue select _sSelect;
			_crate addMagazineCargoGlobal [_item,1];
		};
	};
	
	// load packs
	_scount = count DZMSPacks;
	for "_x" from 0 to 3 do {
		_sSelect = floor(random _sCount);
		_item = DZMSPacks select _sSelect;
		_crate addBackpackCargoGlobal [_item,1];
	};
};

///////////////////////////////////////////////////////////////////
// Supply Crate 2
if (_type == "supply2") then {
	// load tools
	_scount = count DZMSBuildTools;
	for "_x" from 0 to 1 do {
		_sSelect = floor(random _sCount);
		_item = DZMSBuildTools select _sSelect;
		_crate addWeaponCargoGlobal [_item,1];
	};
	
	// load construction supplies
	_scount = count DZMSBuildSupply;
	for "_x" from 0 to 20 do {
		_sSelect = floor(random _sCount);
		_item = DZMSBuildSupply select _sSelect;
		_qty = _item select 0;
		_type = _item select 1;
		_crate addMagazineCargoGlobal [_type,_qty];
	};
	
	// load crafting supplies
	_scount = count DZMSCraftingSupply;
	for "_x" from 0 to 20 do {
		_sSelect = floor(random _sCount);
		_item = DZMSCraftingSupply select _sSelect;
		_crate addMagazineCargoGlobal [_item,1];
	};
	
	// load high value
	_scount = count DZMSHighValue;
	if (_scount > 0 && {random 1 < .3}) then {
		for "_x" from 0 to 0 do {
			_sSelect = floor(random _sCount);
			_item = DZMSHighValue select _sSelect;
			_crate addMagazineCargoGlobal [_item,1];
		};
	};
	
	// load packs
	_scount = count DZMSPacks;
	for "_x" from 0 to 2 do {
		_sSelect = floor(random _sCount);
		_item = DZMSPacks select _sSelect;
		_crate addBackpackCargoGlobal [_item,1];
	};
};

//////////////////////////////////////////////////////////////////
// Vehicle Stuff
if (_type == "ArmedVehicle") then {
	// load vehicle ammo
	_scount = count DZMSVehAmmo;
	for "_x" from 0 to 10 do {
		_sSelect = floor(random _sCount);
		_item = DZMSVehAmmo select _sSelect;
		_crate addMagazineCargoGlobal [_item,1];
	};
	
	// load packs
	_scount = count DZMSPacks;
	for "_x" from 0 to 2 do {
		_sSelect = floor(random _sCount);
		_item = DZMSPacks select _sSelect;
		_crate addBackpackCargoGlobal [_item,1];
	};
	
	// load vehicle parts
	_scount = count DZMSVehParts;
	for "_x" from 0 to 15 do {
		_sSelect = floor(random _sCount);
		_item = DZMSVehParts select _sSelect;
		_crate addMagazineCargoGlobal [_item,1];
	};
};