/*
	DZMSInit.sqf by Vampire
	This is the file that every other file branches off from.
	It checks that it is safe to run, sets relations, and starts mission timers.
	Updated for DZMS 2.0 by JasonTM
*/

// Global for other scripts to check if DZMS is installed.
DZMSInstalled = true;

diag_log text "[DZMS]: Starting DayZ Mission System.";

DZMSRelations = [];
if (!isNil "DZAI_isActive") then {DZMSRelations = DZMSRelations + ["DZAI"];};
if (!isNil "SAR_version") then {DZMSRelations = DZMSRelations + ["SargeAI"];};
if (!isNil "WAIconfigloaded") then {DZMSRelations = DZMSRelations + ["WickedAI"];};

call {
	
	// If we have multiple relations running, lets warn the user
	if (count DZMSRelations > 1) exitWith {
		diag_log text "[DZMS]: Multiple Relations Detected! Unwanted AI Behaviour May Occur!";
		diag_log text "[DZMS]: If Issues Arise, Decide on a Single AI System! (DZAI, SargeAI, or WickedAI)";
	};
	
	// If only one set of relations were found, let the user know which one is being used.
	if (count DZMSRelations == 1) exitWith {diag_log text format["[DZMS]: Using %1 Relations.",(DZMSRelations select 0)];};
	
	// They weren't found, so let's set relationships
	diag_log text "[DZMS]: Relations not found! Using DZMS Relations.";
	
	// Create the groups if they aren't created already
	createCenter east;
	// Make AI Hostile to Survivors
	WEST setFriend [EAST,0];
	EAST setFriend [WEST,0];
	// Make AI Hostile to Zeds
	EAST setFriend [CIVILIAN,0];
	CIVILIAN setFriend [EAST,0];
};

//Destroy the global variable
DZMSRelations = nil;

// This variable is used to lock the mission spawning to avoid data collisions
DZMSMarkerReady = true;

// This array will store the data for missions
DZMSMissionData = [];

// Let's initialize the mission count variables
DZMSBanditRunning = 0;
DZMSHeroRunning = 0;

// Let's initialize the mission end times
DZMSBanditEndTime = diag_tickTime;
DZMSHeroEndTime = diag_tickTime;

// We need to check for Epoch and OverWatch to adjust vehicle spawning, and configurations
DZMSEpoch = isClass (configFile >> "CfgWeapons" >> "Chainsaw");
DZMSOverwatch = isClass (configFile >> "CfgWeapons" >> "USSR_cheytacM200");

// Let's Load the General Mission Configuration
call compile preprocessFileLineNumbers "\z\addons\dayz_server\DZMS\DZMSConfig.sqf";

// Report the version
if (DZMSDebug) then {diag_log text format ["[DZMS]: Currently Running Version: %1", DZMSVersion];};

// Lets check for a copy-pasted config file
if (DZMSVersion != "2.1") then {
	diag_log text format ["[DZMS]: Outdated Configuration Detected! Please Update DZMS!"];
	diag_log text format ["[DZMS]: Old Versions are not supported by the Mod Author!"];
};

// These variables are initialized here because they are not used in all versions.
DZMSMakeVehKey = false;
DZMSAICheckWallet = false;
DZMSUseRPG = false;
DZMSM2Static = false;
DZMS_HeroDogTag = 0;
DZMS_BanditDogTag = 0;
DZMS_AllowThermal = false;
DZMSHighValue = [];

call {
	// Epoch + Overwatch = Overpoch
	if (DZMSEpoch && DZMSOverwatch) exitWith {
		call compile preprocessFileLineNumbers "\z\addons\dayz_server\DZMS\ExtConfig\OverpochExtConfig.sqf";
		diag_log text "[DZMS]: DayZ Overpoch Detected! Overpoch Configs loaded";
	};
	// Epoch detected!
	if (DZMSEpoch && !DZMSOverwatch) exitWith {
		call compile preprocessFileLineNumbers "\z\addons\dayz_server\DZMS\ExtConfig\EpochExtConfig.sqf";
		diag_log text "[DZMS]: DayZ Epoch Detected! Epoch Configs loaded!";
	};
	// Epoch and Overwatch not detected, load Vanilla Mod configs.
	call compile preprocessFileLineNumbers "\z\addons\dayz_server\DZMS\ExtConfig\VanillaExtConfig.sqf";
	diag_log text "[DZMS]: DayZ Vanilla Mod Detected! Vanilla Configs loaded!";
};

// Lets compile our functions
call compile preprocessFileLineNumbers "\z\addons\dayz_server\DZMS\Scripts\DZMSFunctions.sqf";
DZMSAIKilled = compile preprocessFileLineNumbers "\z\addons\dayz_server\DZMS\Scripts\DZMSAIKilled.sqf";
DZMSAISpawn = compile preprocessFileLineNumbers "\z\addons\dayz_server\DZMS\Scripts\DZMSAISpawn.sqf";
DZMSM2Spawn = compile preprocessFileLineNumbers "\z\addons\dayz_server\DZMS\Scripts\DZMSM2Spawn.sqf";
DZMSBoxSetup = compile preprocessFileLineNumbers "\z\addons\dayz_server\DZMS\Scripts\DZMSBox.sqf";
DZMSSpawnVeh = compile preprocessFileLineNumbers "\z\addons\dayz_server\DZMS\Scripts\DZMSSpawnVeh.sqf";
DZMSWaitMissionComp = compile preprocessFileLineNumbers "\z\addons\dayz_server\DZMS\Scripts\DZMSWaitMissionComp.sqf";
DZMSFindPos = compile preprocessFileLineNumbers "\z\addons\dayz_server\DZMS\Scripts\DZMSFindPos.sqf";
DZMSSpawnObjects = compile preprocessFileLineNumbers "\z\addons\dayz_server\DZMS\Scripts\DZMSSpawnObjects.sqf";

// Get the static AI spawned (if applicable)
if (DZMSStaticAI) then {
	[] spawn {
		while {true} do {
			{
				if !((_x select 0 == 0) && (_x select 1 == 0)) then {
					[_x,DZMSStaticAICnt,2,"Bandit"] call DZMSAISpawn;
				};
				sleep 2;
			} forEach DZMSStaticSpawn;

			sleep DZMSStaticAITime;
		};
	};
};
