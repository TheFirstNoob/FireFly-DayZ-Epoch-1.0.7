/*
	DayZ Mission System Config by Vampire
	DZMS: https://github.com/SMVampire/DZMS-DayZMissionSystem
	Updated for DZMS 2.0 by JasonTM
*/

///////////////////////////////////////////////////////////////////////
// Do you want to see how many AI are at the mission in the mission marker?
// This option may cause excessive network traffic on high pop. servers as markers are refreshed every 2 seconds.
DZMSAICount = false;

// If players are not near the AI behavior is disabled and the NPCs are hidden.
DZMSAICaching = false;

// Time in minutes for a mission to timeout.
DZMSMissionTimeOut = 20;

// Distance in meters from a mission to scan for players for timeout.
DZMSTimeoutDistance = 800;

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
DZMSDebug = false;

// Do you want your players to gain or lose humanity from killing mission AI?
DZMSMissHumanity = true;

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
DZMSRunGear = false;

// How long before bodies disappear? (in minutes) (default = 30)
// Also used by WAI. Make sure they are the same if both are installed.
DZE_NPC_CleanUp_Time = 30;

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
DZMSStatLocs = call {
/*475 Positions*/if (toLower worldName in ["chernarus","chernarus_winter"]) exitWith {[[7799.17,11502.8],[5682.2,8713.45],[4042.5,7253.45],[7088.84,9570.31],[6230.92,8338.9],[8596.73,11183.3],[8008.01,12055.4],[12156.9,8546.7],[10470.9,8574.72],[3122.48,9849.65],[5144.53,3538.41],[5019.55,3703.74],[7665.34,8249.58],[3302.39,9793.31],[4341.28,8591.47],[5329.04,10360],[5802.65,7769.07],[6376.84,8126.08],[4310.27,10816.8],[4925.12,8620.5],[5120.21,8946.94],[4127.88,9569.24],[8777.68,10099.9],[11672.9,12562.5],[6882.23,8352.39],[6059.67,8279.8],[3732.6,7149.41],[9711.38,11623],[13082.6,6937.48],[9409.3,12855.5],[4466.85,10133.9],[7912.78,9635.89],[6806.61,10032.6],[4242.57,8021.31],[8940.72,10005.2],[3347.4,9664.6],[5541.03,7851.62],[5625.43,10218.4],[4122.07,7922.29],[4783.2,8626.48],[5432.74,10511.1],[2941.04,8375.69],[5762.03,7908.29],[3720.38,10454.9],[5812.42,10824.1],[11339.4,9605.34],[3732.83,7030.78],[3394.36,8076.2],[6487.41,10087.5],[8733.36,9159.71],[7131.88,8385.2],[3953.14,4848.25],[4428.27,7888.68],[5133.26,10731.1],[3946.27,7399.39],[3128.96,5024.94],[4253.09,8647.28],[4357.46,8478.1],[4364.67,8353.79],[5063.67,9119.25],[4130.71,12904.1],[3029.63,8289.95],[6233.49,8222.73],[5162.16,10409.3],[7036.93,7496.88],[5316.59,8394.78],[3542.57,8068.03],[2851.47,8562.15],[3686.54,7530.46],[6643.58,3561.24],[7967,13630.9],[3677.97,6795.47],[5056.86,8173.08],[7418.78,9483.13],[5737.49,9613.75],[5093.99,7547.25],[3689.14,6901.95],[9617.06,11391.3],[12269.5,12667.1],[10108.6,13461.3],[3480.04,7903.94],[4260.54,6372.61],[12705.2,9025.35],[3207.88,8982.16],[5879.71,13519.1],[5197.96,8386.93],[7195.1,9419.24],[4773.11,5772.96],[3467.42,5428.55],[5796.96,7503.37],[4666.24,8390.75],[12702.4,8898.62],[5767.59,9177.26],[9180.27,11353],[4634.87,5853.75],[7304.27,8344.95],[2837.51,8802.67],[3484.69,9649.02],[4875.07,10032.9],[7136.49,8858.17],[6772.99,9435.69],[3735.81,7734.06],[8149.77,13441.7],[7376.65,10681.6],[4654.92,10179.1],[2813.72,9640.34],[6083.21,7590.76],[3837.59,7202.61],[4304.63,9736.19],[9422.71,11082.7],[5650.47,7855.74],[11784,9570.23],[6698.83,7383.68],[10023.1,5953.64],[4747.91,6238.35],[4011.58,10945.3],[2646.19,9379.18],[8185.7,8545.16],[12697.7,8540.94],[6304.28,8022.81],[5713.68,8034.49],[4129.57,6926.06],[3547.75,10799],[6802.96,8280.44],[6777.37,5840.17],[7350.93,5230.5],[5880.3,7421.09],[4193.83,9763.97],[3179.7,8738.37],[3804.15,10245.1],[3632.77,8178.62],[3305.05,8950.76],[8342.5,12723.1],[6407.1,8390.98],[5906.31,9039.78],[2960.61,9741.18],[5794.15,11343],[9322.11,11337.1],[3967.19,6935.48],[4995.4,7454.07],[3276.81,6987.63],[5507.38,10233],[6043.24,9180.2],[11303.7,7823.53],[4065.26,8360.14],[12613.7,8963.77],[6954.07,9628.47],[4772.88,11380.4],[5319.73,3846.47],[11717.2,12442],[4184.95,8481.47],[5101.17,9242.48],[12363.1,12829.7],[6542.46,7296.54],[4442.68,8648.98],[12328.3,12923.4],[9991.48,8671.71],[4924.55,5712.25],[3739.91,9464.64],[6754.05,8069.78],[5704.5,9376.33],[6237.46,6893.11],[4164.45,8309.07],[7268.03,9812.92],[9176.98,11155.1],[4018.28,7698.71],[3454,6735.96],[6661.29,4743.14],[5864.36,7217.91],[9017.75,9150.02],[3436.28,7257.51],[3283.67,8066.6],[10668.4,8784.42],[5131.96,9527.4],[5681.55,7454.81],[12161.6,12707.9],[3799.02,4858.68],[7316,9506.9],[8435.24,6330],[7873.6,3359.29],[10039.9,8794.42],[8334.02,6931.65],[6957.06,5717.19],[3017.12,8768.88],[3169.82,9475.7],[6058.5,8402.42],[12050.1,12715.1],[5744.64,8817.38],[8066.75,13663.5],[4262.76,10520.2],[12419.2,8767.53],[4217.73,9619.35],[6977.93,9085.19],[9763.38,10559.9],[4175.41,9433.74],[6271.95,8560.47],[2608.37,13012.9],[5601.47,11134.4],[5676.14,8336.67],[9794.94,11563.5],[9587.56,11640.1],[6039.75,7287.61],[10080.7,13356.2],[5218.37,8486.53],[3489.79,8176.19],[4549.65,10390.7],[3581.91,7438.98],[3335.82,9445.02],[7451.73,7835.34],[8596.86,6475.7],[4675.1,8093.05],[4411.06,9872.14],[6621.88,9450.58],[8566.07,9300.61],[5640.05,10443.6],[6146.9,8846.21],[4525.41,9162.48],[8139.29,9900.37],[3268.83,6740.06],[4106.08,11074.2],[5934.23,13619.7],[3844.36,6982.55],[3047.42,8081.76],[7345.17,7885.3],[4528.07,10612],[5558.44,10368.8],[4970.62,8497.54],[5235.14,8965.67],[7363.32,7508.87],[6876.98,9731.42],[5781.92,10435.6],[12595.9,9187.68],[4368.52,8814.37],[10846.2,8290.96],[3700.13,10202.2],[3300.23,7773.56],[8215.09,13358],[5996.08,12400.3],[3676.42,7296.08],[12057,11096.4],[6478.6,8169.8],[12513.9,9330.9],[9381.05,11697.1],[5269.87,8148.47],[5631.98,8463.25],[5108.29,10929],[3441.75,8943.55],[10622,8311.33],[9388.93,12175.2],[8659.81,10116.7],[10097.4,8693.6],[2676.25,12094.3],[5234.12,8829.32],[12077.2,10601.9],[6200.36,8455.24],[11244.9,8345.91],[4453.62,7752.54],[4789.63,8309.21],[4519.84,8320.14],[10594.6,8424.5],[2923.11,6693.79],[3794.22,6879.02],[4778.66,9686.77],[6919.94,7557.01],[5461.5,11081.2],[3306.76,8773.89],[2783.02,7241.23],[3083.82,8616.49],[4350.54,9644.92],[3255.1,7400.8],[3913.81,8389.22],[3118.37,9091.28],[4280.59,9452.8],[12723.4,10334.6],[4665.4,7284.39],[3140.65,4462.85],[3692.41,4775.84],[3790.35,8108.43],[10674.7,8636.13],[3439.92,6847.16],[8812.25,12527.1],[10806.2,8645.02],[3930.43,8086.77],[4835.21,3958.52],[5855.93,7679.31],[3791.54,7441.86],[4045.94,6635.06],[5403.74,9044.05],[5077.62,12095.9],[8804.57,12789.5],[2940.76,8238.27],[2887.74,6922.38],[4887.49,8075.59],[4982.5,6705.49],[3156.66,10876.7],[5831.25,12320.6],[8005.9,8173.4],[5626.52,9243.53],[13080.1,7580],[3467.69,7566.49],[6392.09,8270.32],[5984.04,9879.01],[4039.48,8518.26],[2915.94,8870.84],[10337.9,8213.99],[12291.4,8590.87],[5115.81,10547],[5753.82,11068.5],[8525.86,12693.1],[4482.11,8501.2],[6577.4,7393.74],[7585.89,8800.8],[5350.81,9324.26],[8649.91,12686.7],[7757.88,8803.12],[7844.35,13649.7],[4532.19,8168.12],[9246.49,11635.4],[4862.99,8810.87],[5139.04,7637.45],[9147.83,11854.6],[5548.78,8007.25],[4758.67,9087.56],[13063.9,8071.43],[3908.4,11055.1],[7126.69,9680.15],[10414.1,8730.57],[3607.13,7141.9],[4823.4,9198.24],[6694.86,7914.11],[5009.5,8985.91],[3852.24,9969.66],[10281.8,8622.63],[2817.91,8965.58],[5981.32,7429.15],[9139.06,11617.9],[6968.06,8187.84],[3371.36,6561.53],[3857.52,9534.05],[3335.55,10652.4],[2841.14,6545.85],[9207.69,11020.7],[7563.27,7595.52],[8274.41,9784.96],[3498.63,7697.52],[4040.61,9032.03],[3802.69,11108.9],[5152.16,8241.7],[7347.71,9669.68],[3553.56,4919.49],[3687.37,10309.1],[9563.04,12089.3],[3806.48,12843],[4753.93,10131.8],[7874.79,5028.24],[11951.1,9822.97],[12615.4,8840.56],[5231.56,10804.2],[5705.13,7560.65],[5416.46,5533.77],[10324.5,8096.45],[3505.03,10414.2],[5665.34,10899.6],[6695.83,8996.15],[4721.32,10705.9],[3512.3,10280.5],[11972,12280],[2680.72,10219],[5637.09,8186.65],[3367.55,7632.59],[5516.14,10958.7],[11691.3,13119.4],[12509.3,13472.1],[4598.42,8637.38],[3229.14,9111.25],[12609.7,13422],[2667.38,7225.2],[6997.58,5381.12],[4169.82,9928.62],[8072.59,6608.32],[5744.41,9834.35],[10052.2,8583.86],[4899.76,8396.74],[9364.9,11217.5],[5884.65,9139.34],[4421.84,10839],[12342.3,9302.54],[7504.04,8187.63],[4142.63,8654.95],[8436.6,12634.3],[10763,12333.8],[5618.54,10798.6],[2874.36,10307],[4527.32,7100.29],[3290.59,7271.12],[7760.55,8685.49],[11728.2,12965],[5534.47,11371.4],[6149.35,7504.06],[6733.46,9336.83],[12075.2,12908.2],[3852.97,7737.73],[7179.41,9054.8],[6255.1,6250.19],[8341.93,9647.8],[10476.8,8385.57],[11537.6,9655.87],[3747.49,8558.96],[6265.47,9036.89],[2907.99,9857.44],[4487.71,10714],[8139.76,7073.58],[5782.39,8308.85],[3922.86,7047.63],[3136.63,6744.08],[10455.2,10180],[6430.84,7017.95],[5530.5,8575.52],[2762.58,9401.68],[6294.75,8417.67],[6733.22,9560.53],[3213.83,6435.83],[5236.18,7189.23],[3986.08,7146.6],[7210.97,9600.61],[5788.5,10137.9],[12152.3,9929.2],[4511.77,12330.3],[5440.36,7445.78],[7640.43,9069.69],[2639.34,11906.2],[5256.43,10496],[4840.12,6323.76],[3804.38,9339.56],[3850.02,5016.59],[12468.4,9931.49],[7385.11,10797.8],[7925.64,7303.83],[9720.78,13023.9],[8301.33,6752.26],[6246.58,9191.19],[11154.7,7935.82],[1989.56,3983.87],[1953.11,4111.87],[2139.47,4102.4],[1384.2,4523.72],[1263.92,4683.09],[1415.68,4376.28],[1902.83,5353.61],[1986.22,5163.8],[1695.14,5234.37],[1421.79,5235.87],[1101.99,3795.9],[1149.06,3878.55],[1259.11,4044.03],[1134.75,4207.94],[953.839,4238.65],[1001.07,4445.2],[839.208,4638.53],[3197.78,3229.35],[3170.97,3341.39],[3982.13,3005.38],[3889.89,2923.18],[3762.15,2834.78],[1930.46,2863.78],[1840.56,2993.93],[11653.2,5637.37],[11147.3,4785.1],[10310,5827.85],[7368.85,11448.2],[7824.14,12193.7],[8270.72,9096.08],[8070.95,8992.47],[12286.2,6891.63],[11988.9,10037.7]]};
	[[0,0],[0,0]];
};

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
DZMSSaveVehicles = true;

// Setting this to true will prevent the mission vehicles from taking damage during the mission.
DZMSVehDamageOff = true;

/*///////////////////////////////////////////////////////////////////////////////////////////
There are two types of missions that run simultaneously on a the server.
The two types are Bandit and Hero missions.

Below is the array of mission file names and the minimum and maximum times they run.
If you don't want a certain mission to run on the server, comment out it's line.
Remember that the last mission in the list should not have a comma after it.
*/

DZMSMissionArray = [
	"AN2_Cargo_Drop", // Weapons
	"Ural_Ambush", // Weapons, Medical Supplies, Building Supplies
	"Squad", // No crate
	"Humvee_Crash", // Weapons
	//"APC_Mission", // Only uncomment for Epoch/Overpoch
	"Armed_Vehicles", // Vehicle ammo and parts
	"C130_Crash", // Building Supplies
	"Construction_Site", // Building Supplies
	"Firebase", // Building Supplies
	"Helicopter_Crash", // Weapons
	"Helicopter_Landing", // Weapons, Building Supplies
	"General_Store", // Survival items found in supermarket
	"Medical_Cache", // Medical Supplies
	"Medical_Camp", // Medical Supplies
	"Medical_Outpost", // Medical Supplies, Weapons
	"Weapons_Cache", // Weapons
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
];

DZMSDistanceBetweenMissions = 1600; // Minimum distance in meters to check for other missions.

// Autoclaim is a PVE feature that lets players know who is currently engaged in a mission.
DZMSAutoClaim = true;
DZMSAutoClaimAlertDistance = 800; // Distance from the mission that auto-claim uses to alert closest player
DZMSAutoClaimDelayTime = 30; // Time that the auto-claim waits until it declares a claim and places a marker - time in seconds
DZMSAutoClaimTimeout = 60; // If the claimer leaves the mission area he/she has this much time to return - time in seconds

/*=============================================================================================*/
// Do Not Edit Below This Line
/*=============================================================================================*/
DZMSVersion = "2.1";
