// Compile all Functions
WAI_SpawnGroup = compile preprocessFileLineNumbers "\z\addons\dayz_server\WAI\compile\spawn_group.sqf";
WAI_SpawnStatic = compile preprocessFileLineNumbers "\z\addons\dayz_server\WAI\compile\spawn_static.sqf";
WAI_SetWaypoints = compile preprocessFileLineNumbers "\z\addons\dayz_server\WAI\compile\waypoints.sqf";
WAI_HeliPara = compile preprocessFileLineNumbers "\z\addons\dayz_server\WAI\compile\heli_para.sqf";
WAI_HeliPatrol = compile preprocessFileLineNumbers "\z\addons\dayz_server\WAI\compile\heli_patrol.sqf";
WAI_VehPatrol = compile preprocessFileLineNumbers "\z\addons\dayz_server\WAI\compile\vehicle_patrol.sqf";
WAI_Onkill = compile preprocessFileLineNumbers "\z\addons\dayz_server\WAI\compile\on_kill.sqf";
WAI_DynCrate = compile preprocessFileLineNumbers "\z\addons\dayz_server\WAI\compile\dynamic_crate.sqf";
WAI_FindPos = compile preprocessFileLineNumbers "\z\addons\dayz_server\WAI\compile\find_position.sqf";
WAI_LoadAmmo = compile preprocessFileLineNumbers "\z\addons\dayz_server\WAI\compile\load_ammo.sqf";
WAI_MissionMonitor = compile preprocessFileLineNumbers "\z\addons\dayz_server\WAI\compile\missionMonitor.sqf";
WAI_PublishVeh = compile preprocessFileLineNumbers "\z\addons\dayz_server\WAI\compile\publishVehicle.sqf";
WAI_SpawnObjects = compile preprocessFileLineNumbers "\z\addons\dayz_server\WAI\compile\spawnObjects.sqf";

call compile preprocessFileLineNumbers "\z\addons\dayz_server\WAI\compile\position_functions.sqf";
call compile preprocessFileLineNumbers "\z\addons\dayz_server\WAI\compile\functions.sqf";

if (isNil("DZMSInstalled")) then {

	createCenter EAST;
	createCenter RESISTANCE;

	WEST setFriend [EAST,0];
	WEST setFriend [RESISTANCE,0];

	EAST setFriend [WEST,0];
	EAST setFriend [RESISTANCE,0];
	
	RESISTANCE setFriend [EAST,0];
	RESISTANCE setFriend [WEST,0];

} else {

	createCenter RESISTANCE;
	
	EAST setFriend [RESISTANCE,0];
	WEST setFriend [RESISTANCE,0];
	
	RESISTANCE setFriend [EAST,0];
	RESISTANCE setFriend [WEST,0];	
};

WAIconfigloaded = false;
WAI_MarkerReady = true;
WAI_MissionData = [];
WAI_HeroRunning = 0;
WAI_BanditRunning = 0;
WAI_HeroStartTime = diag_tickTime;
WAI_BanditStartTime = diag_tickTime;

call compile preprocessFileLineNumbers "\z\addons\dayz_server\WAI\config.sqf";
call compile preprocessFileLineNumbers "\z\addons\dayz_server\WAI\configs\mission_loot.sqf";

if (WAI_SpawnPoints) then {
	call compile preprocessFileLineNumbers "\z\addons\dayz_server\WAI\configs\spawnpoints.sqf";
};

if (WAI_Blacklist) then {
	call compile preprocessFileLineNumbers "\z\addons\dayz_server\WAI\configs\blacklist.sqf";
};