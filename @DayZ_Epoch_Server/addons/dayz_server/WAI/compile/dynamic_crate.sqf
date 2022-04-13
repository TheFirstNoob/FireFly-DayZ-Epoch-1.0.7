local _crate = _this select 0;
local _loot = _this select 1;
local _complete = nil;
if ((count _this) > 2) then {
	_complete = _this select 2;
};
local _multiArrItem = false;
local _multiArrWep = false;
local _numWeapons = 0;
local _weaponArray = [];
local _numTools = 0;
local _toolArray = [];
local _numItems = 0;
local _itemArray = [];
local _numPistols = 0;
local _pistolsArray = [];
local _numPacks = 0;
local _packArray = [];

if !(isNil "_complete") then {
	if (typeOf _crate in (WAI_CrateLg + WAI_CrateMd + WAI_CrateSm)) then {
		if (WAI_CrateSmoke && sunOrMoon == 1) then {
			local _marker = "smokeShellPurple" createVehicle getPosATL _crate;
			_marker setPosATL (getPosATL _crate);
			_marker attachTo [_crate,[0,0,0]];
		};
		if (WAI_CrateFlare && sunOrMoon != 1) then {
			local _marker = "RoadFlare" createVehicle getPosATL _crate;
			_marker setPosATL (getPosATL _crate);
			_marker attachTo [_crate, [0,0,0]];
			PVDZ_obj_RoadFlare = [_marker,0];
			publicVariable "PVDZ_obj_RoadFlare";
		};
	};
};

if (typeName (_loot select 0) == "ARRAY") then {
	_numWeapons = (_loot select 0) select 0;
	_weaponArray = (_loot select 0) select 1;
} else {
	_numWeapons = _loot select 0;
	_multiArrWep = true;
};

if (typeName (_loot select 1) == "ARRAY") then {
	_numTools = (_loot select 1) select 0;
	_toolArray = (_loot select 1) select 1;
} else {
	_numTools = _loot select 1;
	_toolArray = WAI_ToolsAll;
};

if (typeName (_loot select 2) == "ARRAY") then {
	_numItems = (_loot select 2) select 0;
	_itemArray	= (_loot select 2) select 1;
} else {
	_numItems = _loot select 2;
	_multiArrItem = true;
};

if (typeName (_loot select 3) == "ARRAY") then {
	_numPistols = (_loot select 3) select 0;
	_pistolsArray = (_loot select 3) select 1;
} else {
	_numPistols = _loot select 3;
	if (WAI_Overpoch) then {
		_pistolsArray = WAI_OWPistol;
	} else {
		_pistolsArray = WAI_Pistol;
	};
};

if (typeName (_loot select 4) == "ARRAY") then {
	_numPacks = (_loot select 4) select 0;
	_packArray = (_loot select 4) select 1;
} else {
	_numPacks = _loot select 4;
	_packArray = WAI_PacksAll;
};

if (_numWeapons > 0) then {
	if (_multiArrWep) then {
		for "_i" from 1 to _numWeapons do {
			_weaponArray = WAI_RandomWeapon call BIS_fnc_selectRandom;
			local _weapon = _weaponArray call BIS_fnc_selectRandom;
			local _ammo = _weapon call WAI_FindAmmo;
			_crate addWeaponCargoGlobal [_weapon,1];
			_crate addMagazineCargoGlobal [_ammo, (round(random((WAI_NumMags select 1) - (WAI_NumMags select 0))) + (WAI_NumMags select 0))];
		};
	} else {
		for "_i" from 1 to _numWeapons do {
			local _weapon = _weaponArray call BIS_fnc_selectRandom;
			local _ammo = _weapon call WAI_FindAmmo;
			_crate addWeaponCargoGlobal [_weapon,1];
			_crate addMagazineCargoGlobal [_ammo, (round(random((WAI_NumMags select 1) - (WAI_NumMags select 0))) + (WAI_NumMags select 0))];
		};
	};
};

if (_numTools > 0) then {
	for "_i" from 1 to _numTools do {
		local _tool = _toolArray call BIS_fnc_selectRandom;
		if (typeName (_tool) == "ARRAY") then {
			_crate addWeaponCargoGlobal [_tool select 0,_tool select 1];
		} else {
			_crate addWeaponCargoGlobal [_tool,1];
		};
	};
};

if (_numItems > 0) then {
	if (_multiArrItem) then {
		for "_i" from 1 to _numItems do {
			_itemArray = WAI_ItemsRandom call BIS_fnc_selectRandom;
			local _item = _itemArray call BIS_fnc_selectRandom;
			if (typeName (_item) == "ARRAY") then {
				_crate addMagazineCargoGlobal [_item select 0,_item select 1];
			} else {
				_crate addMagazineCargoGlobal [_item,1];
			};
		};
	} else {
		for "_i" from 1 to _numItems do {
			local _item = _itemArray call BIS_fnc_selectRandom;
			if (typeName (_item) == "ARRAY") then {
				_crate addMagazineCargoGlobal [_item select 0,_item select 1];
			} else {
				_crate addMagazineCargoGlobal [_item,1];
			};
		};
	};
};

if (_numPistols > 0) then {
	for "_i" from 1 to _numPistols do {
		local _pistol = _pistolsArray call BIS_fnc_selectRandom;
		local _ammo = _pistol call WAI_FindAmmo;
		_crate addWeaponCargoGlobal [_pistol,1];
		_crate addMagazineCargoGlobal [_ammo, (round(random((WAI_NumMags select 1) - (WAI_NumMags select 0))) + (WAI_NumMags select 0))];
	};
};


if(_numPacks > 0) then {
	for "_i" from 1 to _numPacks do {
		local _backpack = _packArray call BIS_fnc_selectRandom;
		if (typeName (_backpack) == "ARRAY") then {
			_crate addBackpackCargoGlobal [_backpack select 0,_backpack select 1];
		} else {
			_crate addBackpackCargoGlobal [_backpack,1];
		};
	};
};

if (WAI_HighValueChance > 0) then {
	if (random 100 < WAI_HighValueChance) then {
		local _item = WAI_HighValue call BIS_fnc_selectRandom;
		_crate addMagazineCargoGlobal [_item,1];
	};
};

if (WAI_DebugMode) then {
	diag_log format["WAI: Spawning in a dynamic crate with %1 guns, %2 tools, %3 items and %4 pistols and %5 backpacks",_numWeapons,_numTools,_numItems,_numPistols,_numPacks];
};
