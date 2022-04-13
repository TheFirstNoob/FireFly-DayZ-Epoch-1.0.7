/*
	DZMSAIKilled.sqf by Vampire
	This function is called when an AI Unit is killed.
	It handles the humanity allocation and body cleanup.
	Updated for DZMS 2.0 by JasonTM
*/

local _unit = _this select 0;
local _player = _this select 1;
local _array = _unit getVariable ["DZMSAI" + dayz_serverKey, nil];
local _mission = _array select 0;
local _aiType = _array select 1;

if (typeName(DZMSMissionData select _mission) == "ARRAY") then {
	DZMSMissionData select _mission set [0, ((DZMSMissionData select _mission) select 0) - 1];
};

//If the killer is a player, lets handle the humanity
if (isPlayer _player) then {
	
	//diag_log text format ["[DZMS]: Debug: Unit killed by %1 at %2", _player, mapGridPosition _unit];
	
	//Lets grab some info
	local _humanity = _player getVariable ["humanity",0];
	local _banditkills = _player getVariable ["banditKills",0];
	local _humankills = _player getVariable["humanKills",0];
	
	//If the player gets humanity per config, lets give it
	if (DZMSMissHumanity) then {
		if (_aiType == "Bandit") then {
			_player setVariable ["humanity",(_humanity + DZMSBanditHumanity),true];
		} else {
			_player setVariable ["humanity",(_humanity - DZMSHeroHumanity),true];
		};
		
		if (DZMSKillFeed) then {
			local _humanityReward = if (_aiType == "Hero") then {format["-%1 Humanity",DZMSHeroHumanity];} else {format["+%1 Humanity",DZMSBanditHumanity];};
			local _aiColor = if (_aiType == "Hero") then {"#3333ff";} else {"#ff0000";};
			local _params = [_aiColor,"0.50","#FFFFFF",-.4,.2,2,0.5];
			
			RemoteMessage = ["ai_killfeed", [_aiType," AI Kill",_humanityReward],_params];
			(owner _player) publicVariableClient "RemoteMessage";
		};
	};
	
	//If this counts as a bandit or hero kill, lets give it
	if (DZMSCntKills) then {
		if (_aiType == "Bandit") then {
			_player setVariable ["banditKills",(_banditkills + 1),true];
		} else {
			_player setVariable ["humanKills",(_humankills + 1),true];
		};
	};
	
	// If ZSC installed and DZMSAICheckWallet enabled, add money to AI wallets
	if (DZMSAICheckWallet && Z_singleCurrency) then {
		local _cash = round(random 10) * 500; // adds money to AI wallets in 500x increments. 
		_unit setVariable["cashMoney",_cash ,true];
	};
	
	//Lets inform the nearby AI of roughly the players position
	//This makes the AI turn and react instead of laying around
	{
		if (((position _x) distance (position _unit)) <= 300) then {
			_x reveal [_player, 4.0];
		}
	} forEach allUnits;
	
} else {

	//diag_log text format ["[DZMS]: Debug: Unit killed by %1 at %2", _player, mapGridPosition _unit];

	if (DZMSRunGear) then {
		//Since a player ran them over, or they died from unknown causes
		//Lets strip their gear
		if (!isNull (unitBackpack _unit)) then {removeBackpack _unit;};
		removeAllWeapons _unit;
		{
			_unit removeMagazine _x
		} forEach magazines _unit;
	};
	
};

if (DZMSCleanDeath) exitWith {
	_unit call sched_co_deleteVehicle;
};

_unit setVariable ["bodyName","NPC",false]; // Corpse will be deleted by sched_corpses function according to DZE_NPC_CleanUp_Time

if (DZMSUseNVG) then {
	_unit removeWeapon "NVGoggles";
};

if (DZMSUseRPG && {"RPG7V" in (weapons _unit)}) then {
	_unit removeWeapon "RPG7V";
	_unit removeMagazines "PG7V";
};