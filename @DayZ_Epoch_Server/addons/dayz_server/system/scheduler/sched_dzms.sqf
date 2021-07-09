/*
	This scheduled task checks for running DZMS missions and starts them appropriately.
*/

sched_dzms_init = {
	diag_log("[DZMS]: Scheduler Started");
	local _array = +DZMSMissionArray;
	local _timeBandit = ((random(DZMSBanditMax - DZMSBanditMin) + DZMSBanditMin) * 60);
	local _timeHero = ((random(DZMSHeroMax - DZMSHeroMin) + DZMSHeroMin) * 60);
	[_array,_timeBandit,_timeHero]
};

sched_dzms = {
	local _array = _this select 0;
	local _timeBandit = _this select 1;
	local _timeHero = _this select 2;
	local _varName = "";
	
	// Bandit mission timer
	if (((diag_tickTime - DZMSBanditEndTime) >= _timeBandit) && {DZMSBanditRunning < DZMSBanditLimit} && {DZMSMarkerReady}) then {
		DZMSMarkerReady = false;
		_varName = _array call BIS_fnc_selectRandom;
		["Bandit"] execVM format ["\z\addons\dayz_server\DZMS\Missions\%1.sqf",_varName];
		diag_log text format ["[DZMS]: Running Bandit Mission %1.",_varName];
		DZMSMarkers set [(count DZMSMarkers), ("DZMSBandit" + str(count DZMSMissionData))];
		DZMSMissionData = DZMSMissionData + [[0,[],[],[],[],[]]];
		DZMSBanditEndTime = diag_tickTime;
		DZMSBanditRunning = DZMSBanditRunning + 1;
	};
	
	// Hero mission timer
	if (((diag_tickTime - DZMSHeroEndTime) >= _timeHero) && {DZMSHeroRunning < DZMSHeroLimit} && {DZMSMarkerReady}) then {
		DZMSMarkerReady = false;
		_varName = _array call BIS_fnc_selectRandom;
		["Hero"] execVM format ["\z\addons\dayz_server\DZMS\Missions\%1.sqf",_varName];
		diag_log text format ["[DZMS]: Running Hero Mission %1.",_varName];
		DZMSMarkers set [(count DZMSMarkers), ("DZMSHero" + str(count DZMSMissionData))];
		DZMSMissionData = DZMSMissionData + [[0,[],[],[],[],[]]];
		DZMSHeroEndTime = diag_tickTime;
		DZMSHeroRunning = DZMSHeroRunning + 1;
	};
	
	// Remove mission from array and reset array if necessary
	_array = _array - [_varName];
	if (count _array == 0) then {
		_array = +DZMSMissionArray;
	};
	
	// Reset times
	_timeBandit = ((random(DZMSBanditMax - DZMSBanditMin) + DZMSBanditMin) * 60);
	_timeHero = ((random(DZMSHeroMax - DZMSHeroMin) + DZMSHeroMin) * 60);
		
	[_array,_timeBandit,_timeHero]
};