class 30Rnd_556x45_Stanag
{
    class ItemActions
    {
        class TapeMags
        {
            text = "Создать сдвоенный магазин";
            script = ";['TapeMags','CfgMagazines', _id] spawn player_craftItem;"; // [Class of itemaction,CfgMagazines || CfgWeapons, item]
            neednearby[] = {};
            requiretools[] = {}; // (cfgweapons only)
            output[] = {{"60Rnd_556x45_Stanag_Taped",1}}; // (CfgMagazines, qty)
            input[] = {{"30Rnd_556x45_Stanag",2},{"equip_duct_tape",1}}; // (CfgMagazines, qty)
            inputstrict = true; // (CfgMagazines input without inheritsFrom) Optional
            inputweapons[] = {}; // consume toolbox (cfgweapons only)
            outputweapons[] = {}; // return toolbox (cfgweapons only)
        };
    };
};

class 30Rnd_556x45_StanagSD
{
    class ItemActions
    {
        class TapeMags
        {
            text = "Создать сдвоенный магазин";
            script = ";['TapeMags','CfgMagazines', _id] spawn player_craftItem;"; // [Class of itemaction,CfgMagazines || CfgWeapons, item]
            neednearby[] = {};
            requiretools[] = {}; // (cfgweapons only)
            output[] = {{"60Rnd_556x45_StanagSD_Taped",1}}; // (CfgMagazines, qty)
            input[] = {{"30Rnd_556x45_StanagSD",2},{"equip_duct_tape",1}}; // (CfgMagazines, qty)
            inputstrict = false; // (CfgMagazines input without inheritsFrom) Optional
            inputweapons[] = {}; // consume toolbox (cfgweapons only)
            outputweapons[] = {}; // return toolbox (cfgweapons only)
        };
    };
};

