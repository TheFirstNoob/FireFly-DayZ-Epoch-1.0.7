/*
	DZMSInit.sqf by Vampire
	This is the file that every other file branches off from.
	It checks that it is safe to run, sets relations, and starts mission timers.
	Updated for DZMS 2.0 by JasonTM
*/
waitUntil{initialized};

// Lets let the heavier scripts run first
sleep 60;

// Error Check
if (!isServer) exitWith {diag_log text "[DZMS]: <ERROR> DZMS is Installed Incorrectly! DZMS is not Running!";};
if (!isNil "DZMSInstalled") exitWith {diag_log text "[DZMS]: <ERROR> DZMS is Installed Twice or Installed Incorrectly!";};

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

// We need to check for Epoch and OverWatch to adjust vehicle spawning, and configurations
DZMSEpoch = isClass (configFile >> "CfgWeapons" >> "Chainsaw");

// Let's Load the General Mission Configuration
call compile preprocessFileLineNumbers "\z\addons\dayz_server\DZMS\DZMSConfig.sqf";

// Report the version
if (DZMSDebug) then {diag_log text format ["[DZMS]: Currently Running Version: %1", DZMSVersion];};

// Lets check for a copy-pasted config file
if (DZMSVersion != "2.0") then {
	diag_log text format ["[DZMS]: Outdated Configuration Detected! Please Update DZMS!"];
	diag_log text format ["[DZMS]: Old Versions are not supported by the Mod Author!"];
};

// These variables are initialized here because they are not used in all versions.
DZMSMakeVehKey = false; DZMSAICheckWallet = false; DZMSHighValue = []; DZMSUseRPG = false; DZMSM2Static = false;

call {

	// Epoch detected!
	if (DZMSEpoch) exitWith {
		call compile preprocessFileLineNumbers "\z\addons\dayz_server\DZMS\ExtConfig\EpochExtConfig.sqf";
		diag_log text "[DZMS]: DayZ Epoch Detected! Epoch Configs loaded!";
	};
};

// Lets compile our functions
execVM "\z\addons\dayz_server\DZMS\Scripts\DZMSFunctions.sqf"; // execVM is appropriate here because line functions are saved to global variables.
DZMSAIKilled = compile preprocessFileLineNumbers "\z\addons\dayz_server\DZMS\Scripts\DZMSAIKilled.sqf";
DZMSAISpawn = compile preprocessFileLineNumbers "\z\addons\dayz_server\DZMS\Scripts\DZMSAISpawn.sqf";
DZMSM2Spawn = compile preprocessFileLineNumbers "\z\addons\dayz_server\DZMS\Scripts\DZMSM2Spawn.sqf";
DZMSBoxSetup = compile preprocessFileLineNumbers "\z\addons\dayz_server\DZMS\Scripts\DZMSBox.sqf";
DZMSSpawnVeh = compile preprocessFileLineNumbers "\z\addons\dayz_server\DZMS\Scripts\DZMSSpawnVeh.sqf";
DZMSWaitMissionComp = compile preprocessFileLineNumbers "\z\addons\dayz_server\DZMS\Scripts\DZMSWaitMissionComp.sqf";
DZMSFindPos = compile preprocessFileLineNumbers "\z\addons\dayz_server\DZMS\Scripts\DZMSFindPos.sqf";
DZMSSpawnObjects = compile preprocessFileLineNumbers "\z\addons\dayz_server\DZMS\Scripts\DZMSSpawnObjects.sqf";

// Let's get the clocks running!
execVM "\z\addons\dayz_server\DZMS\Scripts\DZMSTimer.sqf";

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
