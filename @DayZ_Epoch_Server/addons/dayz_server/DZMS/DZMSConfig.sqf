/*
	DayZ Mission System Config by Vampire
	DZMS: https://github.com/SMVampire/DZMS-DayZMissionSystem
	Updated for DZMS 2.0 by JasonTM
*/

///////////////////////////////////////////////////////////////////////
// Do you want to see how many AI are at the mission in the mission marker?
// This option may cause excessive network traffic on high pop. servers as markers are refreshed every 2 seconds.
DZMSAICount = false;

// Time in minutes for a mission to timeout.
DZMSMissionTimeOut = 30;

// This is how many bandit missions are allowed to run simultaneously
DZMSBanditLimit = 1;

// This is how many hero missions are allowed to run simultaneously
DZMSHeroLimit = 1;

// Do you want to turn off damage to the mission objects?
DZMSObjectsDamageOff = true;

// Mission announcement style. Options: "Hint","TitleText","rollingMessages","DynamicText".
//Note: The "Hint" messages will appear in the same area as common debug monitors.
DZMSAnnounceType = "TitleText";

// Turn this on to enable troubleshooting. RPT entries might show where problems occur.
DZMSDebug = true;

// Do you want your players to gain or lose humanity from killing mission AI?
DZMSMissHumanity = false;

// How much humanity should a player lose for killing a hero AI?
DZMSHeroHumanity = 25;

// How much humanity should a player gain for killing a bandit AI?
DZMSBanditHumanity = 25;

// Do you want the players to get AI kill messages?
DZMSKillFeed = false;

// Do You Want AI to use NVGs?
//(They are deleted on death)
DZMSUseNVG = true;

// Do you want bandit or hero AI kills to count towards player total?
DZMSCntKills = true;

// Do you want AI to disappear instantly when killed?
DZMSCleanDeath = false;

// Do you want AI that players run over to not have gear?
// (If DZMSCleanDeath is true, this doesn't matter)
DZMSRunGear = true;

// How long before bodies disappear? (in minutes) (default = 30)
// Also used by WAI. Make sure they are the same if both are installed.
ai_cleanup_time = 30;

// Percentage of AI that must be dead before mission completes (default = 0)
//( 0 is 0% of AI / 0.50 is 50% / 1 is 100% )
DZMSRequiredKillPercent = .85;

// How long in minutes before mission scenery disappears (default = 30 / 0 = disabled)
DZMSSceneryDespawnTimer = 30;

// Should crates despawn with scenery? (default = false)
DZMSSceneryDespawnLoot = true;

//////////////////////////////////////////////////////////////////////////////////////////
// You can adjust AI gear/skills and crate loot in files contained in the ExtConfig folder.
//////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////
// Do you want to use static coords for missions?
// Leave this false unless you know what you are doing.
DZMSStaticPlc = false;

// Array of static locations. X,Y
DZMSStatLocs = [
	[0,0],
	[0,0]
];

//////////////////////////////////////////////////////////////////////////////////////////
// Do you want to place some static AI in a base or similar?
// Leave this false unless you know what you are doing.
DZMSStaticAI = false;

// How long before they respawn? (in seconds) (default 2 hours)
// If set longer than the amount of time before a server restart, they respawn at restart
DZMSStaticAITime = 7200;

// How many AI in a group? (Past 6 in a group it's better to just add more positions)
DZMSStaticAICnt = 4;

// Array of Static AI Locations
DZMSStaticSpawn = [
	[0,0,0],
	[0,0,0]
];

///////////////////////////////////////////////////////////////////////////////////////////////////////////
// Do you want vehicles from missions to save to the Database? (this means they will stay after a restart)
// If False, vehicles will disappear on restart. It will warn a player who gets inside of a vehicle.
DZMSSaveVehicles = false;

// Setting this to true will prevent the mission vehicles from taking damage during the mission.
DZMSVehDamageOff = true;

/*///////////////////////////////////////////////////////////////////////////////////////////
There are two types of missions that run simultaneously on a the server.
The two types are Bandit and Hero missions.

Below is the array of mission file names and the minimum and maximum times they run.
If you don't want a certain mission to run on the server, comment out it's line.
Remember that the last mission in the list should not have a comma after it.
*/

DZMSMissionArray = 
[
	"AN2_Cargo_Drop", // Weapons
	"Ural_Ambush", // Weapons, Medical Supplies, Building Supplies
	"Squad", // No crate
	"Humvee_Crash", // Weapons
	"APC_Mission", // Only uncomment for Epoch/Overpoch
	"Armed_Vehicles", // No crate
	"C130_Crash", // Building Supplies
	"Construction_Site", // Building Supplies
	"Firebase", // Building Supplies
	"Helicopter_Crash", // Weapons
	"Helicopter_Landing", // Weapons, Building Supplies
	"General_Store", // Survival items found in supermarket
	"Medical_Cache", // Medical Supplies
	"Medical_Camp", // Medical Supplies
	"Medical_Outpost", // Medical Supplies, Weapons
	"NATO_Weapons_Cache", // Weapons
	"Stash_house", // Weapons
	"Weapons_Truck" // Weapons
];

/////////////////////////////////////////////////////////////////////////////////////////////
// The Minumum time in minutes before a bandit mission will run.
// At least this much time will pass between bandit missions. Default = 5 minutes.
DZMSBanditMin = 5;

// Maximum time in seconds before a bandit mission will run.
// A bandit mission will always run before this much time has passed. Default = 10 minutes.
DZMSBanditMax = 10;

// Time in seconds before a hero mission will run.
// At least this much time will pass between hero missions. Default = 5 minutes.
DZMSHeroMin = 5;

// Maximum time in seconds before a hero mission will run.
// A hero mission will always run before this much time has passed. Default = 10 minutes.
DZMSHeroMax = 10;

// Blacklist Zone Array -- missions will not spawn in these areas
// format: [[x,y,z],[x,y,z]]
// The first set of xyz coordinates is the upper left corner of a box
// The second set of xyz coordinates is the lower right corner of a box
DZMSBlacklistZones = [
	//[[0,0,0],[0,0,0]]
	//[[0,16000,0],[1000,-0,0]],	// Left edge of map Chernarus
    [[0,16000,0],[16000.0,12500,0]] // Top edge of map Chernarus
];

/*=============================================================================================*/
// Do Not Edit Below This Line
/*=============================================================================================*/
DZMSVersion = "2.0";
