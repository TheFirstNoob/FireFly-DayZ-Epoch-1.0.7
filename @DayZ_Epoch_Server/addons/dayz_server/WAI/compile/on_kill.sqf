local _unit = _this select 0;
local _player = _this select 1;
local _launcher = secondaryWeapon _unit;
local _mission = _unit getVariable ("mission" + dayz_serverKey);
	
if (typeName (WAI_MissionData select _mission) == "ARRAY") then {
	WAI_MissionData select _mission set [0, ((WAI_MissionData select _mission) select 0) - 1];
};

_unit setVariable ["bodyName","NPC",false]; // Corpse will be deleted by sched_corpses function according to DZE_NPC_CleanUp_Time

if (WAI_HasMoney && Z_singleCurrency) then {
	_unit setVariable ["cashMoney", (round (random WAI_MoneyMultiplier) * 50) , true];
};

if (WAI_AddSkin) then {
	local _skin = "Skin_" + (typeOf _unit);
	if (isClass (configFile >> "CfgMagazines" >> _skin)) then {
		[_unit,_skin] call BIS_fnc_invAdd;
	};
};

if (isPlayer _player) then {
	if (WAI_RewardVehGunner) then {
		_player = (effectiveCommander vehicle _player);
	};
	
	if (WAI_KillFeed && WAI_HumanityGain) then {
		local _aitype = ["Bandit","Hero"] select (_unit getVariable ["Hero", false]);
		local _humanityReward = [format["+%1 Humanity",WAI_AddHumanity],format["-%1 Humanity",WAI_RemoveHumanity]] select (_aitype == "Hero");
		local _aiColor = ["#ff0000","#3333ff"] select (_aitype == "Hero");
		local _params = [_aiColor,"0.50","#FFFFFF",-.4,.2,2,0.5];
		
		RemoteMessage = ["ai_killfeed", [_aitype," AI Kill",_humanityReward],_params];
		(owner _player) publicVariableClient "RemoteMessage";
	};

	if (WAI_HumanityGain) then {
		local _humanity = _player getVariable["humanity",0];
		local _gain = _unit getVariable ["humanity", 0];
		if (_unit getVariable ["Hero", false]) then {_player setVariable ["humanity",(_humanity - _gain),true];};
		if (_unit getVariable ["Bandit", false]) then {_player setVariable ["humanity",(_humanity + _gain),true];};					
	};

	if (WAI_KillsGain) then {
		local _banditkills = _player getVariable["banditKills",0];
		local _humankills = _player getVariable["humanKills",0];
		if (_unit getVariable ["Hero", false]) then {
			_player setVariable ["humanKills",(_humankills + 1),true];
		} else {
			_player setVariable ["banditKills",(_banditkills + 1),true];
		};
	};

	if (WAI_ClearBody) then {
		{_unit removeMagazine _x;} count (magazines _unit);
		{_unit removeWeapon _x;} count (weapons _unit);
	};

	if (WAI_ShareInfo) then {
		{
			if (((position _x) distance (position _unit)) <= WAI_ShareDist) then {
				_x reveal [_player, 4.0];
			};
		} count allUnits;
	};
} else {
	if (WAI_CleanRoadKill) then {
		removeBackpack _unit;
		removeAllWeapons _unit;
		{
			_unit removeMagazine _x
		} count magazines _unit;
	} else {
		if ((random 100) <= WAI_RkDamageWeapon) then {
			removeAllWeapons _unit;
		};
	};
};

if (WAI_RemoveLauncher && {_launcher != ""}) then {
	local _rockets = _launcher call WAI_FindAmmo;
	_unit removeWeapon _launcher;
	{
		if(_x == _rockets) then {
			_unit removeMagazine _x;
		};
	} count magazines _unit;
};

if (_unit hasWeapon "NVGoggles" && {floor(random 100) < 20}) then {
	_unit removeWeapon "NVGoggles";
};
