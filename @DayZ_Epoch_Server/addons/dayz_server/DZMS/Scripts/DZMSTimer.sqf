/*
	DayZ Mission System Timer by JasonTM
	Based on the Major and Minor DayZ Mission System Timer by Vampire
	Based on fnc_hTime by TAW_Tonic and SMFinder by Craig
	This function is launched by the Init and runs continuously.
*/

private["_timeBandit","_timeHero","_varName","_array"];

//Let's get our random mission start times for this server reset
_timeBandit = ((random(DZMSBanditMax - DZMSBanditMin) + DZMSBanditMin) * 60);
_timeHero = ((random(DZMSHeroMax - DZMSHeroMin) + DZMSHeroMin) * 60);

// This variable is used to lock the mission spawning to avoid data collisions
DZMSMarkerReady = true;

// This array will store the data for missions
DZMSMissionData = [];

// This array will store the mission markers
DZMSMarkers = [];

// Let's initialize the mission count variables
DZMSBanditRunning = 0;
DZMSHeroRunning = 0;

// Let's initialize the mission end times
DZMSBanditEndTime = diag_tickTime;
DZMSHeroEndTime = diag_tickTime;

diag_log text format["[DZMS]: Mission Clock Starting!"];

//Lets get the scheduling loop started
while {true} do {
	
	if (isNil "_array") then {_array = DZMSMissionArray;};
	_varName = "";
	
	// Bandit mission timer
	if (((diag_tickTime - DZMSBanditEndTime) >= _timeBandit) && {DZMSBanditRunning < DZMSBanditLimit} && {DZMSMarkerReady}) then {
		DZMSMarkerReady = false;
		// Let's pick a random mission
		_varName = _array call BIS_fnc_selectRandom;
		// Execute the mission
		["Bandit"] execVM format ["\z\addons\dayz_server\DZMS\Missions\%1.sqf",_varName];
		// Post an entry to the RPT
		diag_log text format ["[DZMS]: Running Bandit Mission %1.",_varName];
		// Add mission data
		DZMSMarkers set [(count DZMSMarkers), ("DZMSBandit" + str(count DZMSMissionData))];
		DZMSMissionData = DZMSMissionData + [[0,[],[],[],[],[]]];
		// Reset the mission end time
		DZMSBanditEndTime = diag_tickTime;
		// Add to the total bandit missions running
		DZMSBanditRunning = DZMSBanditRunning + 1;
	};
	
	// Hero mission timer
	if (((diag_tickTime - DZMSHeroEndTime) >= _timeHero) && {DZMSHeroRunning < DZMSHeroLimit} && {DZMSMarkerReady}) then {
		DZMSMarkerReady = false;
		// Let's pick a random mission
		_varName = _array call BIS_fnc_selectRandom;
		// Execute the mission
		["Hero"] execVM format ["\z\addons\dayz_server\DZMS\Missions\%1.sqf",_varName];
		// Post an entry to the RPT
		diag_log text format ["[DZMS]: Running Hero Mission %1.",_varName];
		// Add mission data
		DZMSMarkers set [(count DZMSMarkers), ("DZMSHero" + str(count DZMSMissionData))];
		DZMSMissionData = DZMSMissionData + [[0,[],[],[],[],[]]];
		// Reset the mission end time
		DZMSHeroEndTime = diag_tickTime;
		// Add to the total hero missions running
		DZMSHeroRunning = DZMSHeroRunning + 1;
	};
	
	_array = _array - [_varName];
	if (count _array == 0) then {_array = nil;};
		
	// Make the loop sleep for 10 seconds
	uiSleep 10;
};