/*
	This scheduled task checks for running WAI missions and starts them appropriately.
*/

sched_wai_init = {
	diag_log("WAI: Scheduler Started");
	local _hArray = +WAI_HeroMissions;
	local _bArray = +WAI_BanditMissions;
	local _hTime = (random ((WAI_Timer select 1) - (WAI_Timer select 0)) + (WAI_Timer select 0)) * 60;
	local _bTime = (random ((WAI_Timer select 1) - (WAI_Timer select 0)) + (WAI_Timer select 0)) * 60;
	[_hArray,_bArray,_bTime,_hTime]
};

sched_wai = {
	local _hArray = _this select 0;
	local _bArray = _this select 1;
	local _bTime = _this select 2;
	local _hTime = _this select 3;
	local _mission = "";
	
	// Bandit mission timer
	if (WAI_MarkerReady  && {diag_tickTime - WAI_BanditStartTime >= _bTime} && {WAI_BanditRunning < WAI_BanditLimit}) then {	
		WAI_MarkerReady = false;
		local _selected = false;
		
		while {!_selected} do {
			if (WAI_DebugMode) then {diag_log format["WAI: Bandit Array: %1",_bArray];};
			_mission = _bArray call BIS_fnc_selectRandom;
			_index = [_bArray, (_mission select 0)] call BIS_fnc_findNestedElement select 0;
			_bArray = [_bArray,_index] call fnc_deleteAt;
			if (count _bArray == 0) then {_bArray = +WAI_BanditMissions;};
			if ((_mission select 1) >= random 1) then {
				_selected = true;
				if (WAI_DebugMode) then {diag_log format["WAI: Bandit mission %1 selected.",(_mission select 0)];};
			} else {
				if (WAI_DebugMode) then {diag_log format["WAI: Bandit mission %1 NOT selected.",(_mission select 0)];};
			};
		};
			
		WAI_BanditRunning = WAI_BanditRunning + 1;
		WAI_BanditStartTime = diag_tickTime;
		WAI_MissionData = WAI_MissionData + [[0,[],[],[],[],[]]]; // [AI Count, UnitGroups, Crates, AI Vehicles, Vehicles, Objects]
		["Bandit"] execVM format ["\z\addons\dayz_server\WAI\missions\missions\%1.sqf",(_mission select 0)];
	};
	
	// Hero mission timer
	if (WAI_MarkerReady  && {diag_tickTime - WAI_HeroStartTime >= _hTime} && {WAI_HeroRunning < WAI_HeroLimit}) then {
		WAI_MarkerReady = false;
		local _selected = false;
		
		while {!_selected} do {
			if (WAI_DebugMode) then {diag_log format["WAI: Hero Array: %1",_hArray];};
			_mission = _hArray call BIS_fnc_selectRandom;
			_index = [_hArray, (_mission select 0)] call BIS_fnc_findNestedElement select 0;
			_hArray = [_hArray,_index] call fnc_deleteAt;
			if (count _hArray == 0) then {_hArray = +WAI_HeroMissions;};
			if ((_mission select 1) >= random 1) then {
				_selected = true;
				if (WAI_DebugMode) then {diag_log format["WAI: Hero mission %1 selected.",(_mission select 0)];};
			} else {
				if (WAI_DebugMode) then {diag_log format["WAI: Hero mission %1 NOT selected.",(_mission select 0)];};
			};
		};
			
		WAI_HeroRunning = WAI_HeroRunning + 1;
		WAI_HeroStartTime = diag_tickTime;
		WAI_MissionData = WAI_MissionData + [[0,[],[],[],[],[]]]; // [AI Count, UnitGroups, Crates, AI Vehicles, Vehicles, Objects]
		["Hero"] execVM format ["\z\addons\dayz_server\WAI\missions\missions\%1.sqf",(_mission select 0)];
	};
	
	// Reset times
	_hTime = (random ((WAI_Timer select 1) - (WAI_Timer select 0)) + (WAI_Timer select 0)) * 60;
	_bTime = (random ((WAI_Timer select 1) - (WAI_Timer select 0)) + (WAI_Timer select 0)) * 60;
		
	[_hArray,_bArray,_bTime,_hTime]
};