local _mission = count WAI_MissionData -1;
local _aiType = _this select 0; // "Bandit" or "Hero"
local _name = "Wuhan Lab";
local _supportedMaps = ["chernarus","chernarus_winter"]; // The default positions listed below are for Chernarus. If you wish to use this mission on another map then you must gather your own list of flat terrain positions.
local _flatPositions = [[4277.94,9457.53],[4144.92,9439.12],[4229.24,9749.14],[3314.31,10614.7],[2152.91,10467.1],[1956.85,10338.3],[4138.71,12630.3],[3999.11,12659.3],[3733.19,14063.7],[3505.19,14168.2],[5191.49,13994.6],[5986.83,14403.1],[6282.33,14097.3],[6497.14,13582.8],[14255.6,14169.6],[13231.9,10718.3],[12080.6,9895.28],[10612.5,8441.86],[8737.68,9200.67],[7137.15,9483.91],[7406.85,3487.04],[7139.72,5321.27],[5227.21,2202.33],[4149.34,2772.77],[1143.01,2439.9],[1230.53,2526.4],[1157.66,4245.54],[1246.03,4612.52],[4436.68,8472.96],[4748.81,5867.21],[5852.48,11010.3]]; // Chernarus
local _position = [_flatPositions] call isValidSpot;

if (count _position < 1 || {!(toLower worldName in _supportedMaps)}) exitWith {
	if (_aiType == "Hero") then {
		WAI_HeroRunning = WAI_HeroRunning - 1; WAI_MissionData set [_mission, -1]; WAI_MarkerReady = true;
	} else {
		WAI_BanditRunning = WAI_BanditRunning - 1; WAI_MissionData set [_mission, -1]; WAI_MarkerReady = true;
	};
};

local _startTime = diag_tickTime;
local _difficulty = "Extreme";
local _localized = ["STR_CL_MISSION_BANDIT", "STR_CL_MISSION_HERO"] select (_aiType == "Hero");
local _localName = "STR_CL_WUHAN_TITLE";

diag_log format["[WAI]: %1 %2 started at %3.",_aiType,_name,_position];

local _messages = ["STR_CL_WUHAN_ANNOUNCE","STR_CL_WUHAN_WIN","STR_CL_WUHAN_FAIL"];

////////////////////// Do not edit this section ///////////////////////////
local _markers = [1,1,1,1];
//[position,createMarker,setMarkerColor,setMarkerType,setMarkerShape,setMarkerBrush,setMarkerSize,setMarkerText,setMarkerAlpha]
_markers set [0, [_position, "WAI" + str(_mission), "ColorBlack", "", "ELLIPSE", "Solid", [300,300], [], 0]];
_markers set [1, [_position, "WAI" + str(_mission) + "dot", "ColorBlack", "mil_dot", "", "", [], [_localized,_localName], 0]];
if (WAI_AutoClaim) then {_markers set [2, [_position, "WAI" + str(_mission) + "auto", "ColorRed", "", "ELLIPSE", "Border", [WAI_AcAlertDistance,WAI_AcAlertDistance], [], 0]];};
DZE_ServerMarkerArray set [count DZE_ServerMarkerArray, _markers]; // Markers added to global array for JIP player requests.
_markerIndex = count DZE_ServerMarkerArray - 1;
PVDZ_ServerMarkerSend = ["start",_markers];
publicVariable "PVDZ_ServerMarkerSend";

WAI_MarkerReady = true;

// Add the mission's position to the global array so that other missions do not spawn near it.
DZE_MissionPositions set [count DZE_MissionPositions, _position];
local _posIndex = count DZE_MissionPositions - 1;

// Send announcement
[_difficulty,(_messages select 0)] call WAI_Message;

// Wait until a player is within range or timeout is reached.
local _timeout = false;
local _claimPlayer = objNull;

while {WAI_WaitForPlayer && !_timeout && {isNull _claimPlayer}} do {
	_claimPlayer = [_position, WAI_TimeoutDist] call isClosestPlayer;
	
	if (diag_tickTime - _startTime >= (WAI_Timeout * 60)) then {
		_timeout = true;
	};
	uiSleep 1;
};

if (_timeout) exitWith {
	[_mission, _aiType, _markerIndex, _posIndex] call WAI_AbortMission;
	[_difficulty,(_messages select 2)] call WAI_Message;
	diag_log format["WAI: %1 %2 aborted.",_aiType,_name,_position];
};
//////////////////////////////// End //////////////////////////////////////

// Random position for doctor and loot crate pair.
local _pos1 = [[0.791992,-2.81055,-6.12189],[1.79688,-1.57813,-6.12915]];
local _pos2 = [[-8.97363,10.8223,-6.01758],[-6.66406,13.3125,-6.1272]];
local _pos3 = [[2.0957,11.3994,-6.0177],[3.22754,13.25,-6.1203]];
local _pos4 = [[1.17383,7.71289,-6.12878],[-0.625,8.07324,-6.1272]];
local _pos5 = [[4.36523,4.60059,-6.01764],[3.87012,8.42773,-6.12732]];
local _pos6 = [[5.82227,13.2188,-6.12933],[5.83398,10.6621,-6.01636]];
local _pos7 = [[12.3428,13.1719,-6.1283],[12.2422,10.1768,-6.01428]];
local _pos8 = [[11.7949,6.40527,-6.11945],[8.39355,4.33887,-6.02197]];
local _random = [_pos1,_pos2,_pos3,_pos4,_pos5,_pos6,_pos7,_pos8] call BIS_fnc_selectRandom;
local _drPos = _random select 0;
local _cratePos = _random select 1;

// Spawn Objects
local _objects = [[
	["Land_Fort_Watchtower",[-4.4077, -60.0694, 0],-120],
	["Land_Fort_Watchtower",[56.2158, -25.0235, 0],-120],
	["Land_MBG_Warehouse",[12.1426, -16.8252, 0],150],
	["Land_fortified_nest_big",[0,0,-0.15467919],-30.100697],
	["Land_MBG_Shoothouse_1",[13.271, -19.3584, 0.28743303],60],
	["Land_MBG_Cinderwall_5",[4.0615, -33.7168, 0],60], // MBG_Cinderwall_5_InEditor
	["Land_MBG_Cinderwall_5",[1.5293, -29.4073, 0],60],
	["Land_MBG_Cinderwall_5",[-1.0054, -25.0909, 0],60],
	["Land_MBG_Cinderwall_5",[-3.5005, -20.8243, 0],60],
	["Land_MBG_Killhouse_3",[-22.3096, -0.5235, 0],-120],
	["Land_MBG_Killhouse_4",[-13.5767, 30.7295, 0],150],
	["Land_MBG_Killhouse_3",[15.9302, 20.9648, 0],-300],
	["Land_MBG_Cinderwall_5_Corner",[3.478, 37.1357, 0],150], // MBG_Cinderwall_5_Corner_InEditor
	["Land_MBG_Cinderwall_5_Gate",[-0.2002, 36.3154, 0],-30], // MBG_Cinderwall_5_Gate_InEditor
	["Land_MBG_Cinderwall_5_Gate",[-26.4517, 21.4033, 0],-30],
	["Land_MBG_Cinderwall_5_Corner",[-29.0083, 18.5996, 0],60],
	["Land_MBG_Cinderwall_5",[-28.1431, 14.999, 0],60],
	["Land_MBG_Cinderwall_5",[6.2939, 34.4404, 0],60],
	["Land_MBG_Cinderwall_5",[-4.4482, 33.8613, 0],-30],
	["Land_MBG_Cinderwall_5",[-22.2583, 23.8632, 0],-30],
	["MAP_Misc_Cargo1B",[24.9292, 0.9345, 0],-30],
	["MAP_Misc_Cargo1B",[34.9565, -15.6846, 0],-30],
	["MAP_Misc_Cargo1B",[6.5254, -41.9004, 0],60],
	["Land_fort_bagfence_round",[-37.1982, 23.5771, -0.14746886],-70],
	["Land_fort_bagfence_round",[3.3857, 45.7832, -0.14746886],14],
	["Land_fortified_nest_small",[-9.4155, -0.4756, -0.14746886],183],
	["MetalFloor4x_DZ",[8.9087, -26.669, 3.24],-30],
	["MetalFloor4x_DZ",[18.0439, -21.3194, 3.24],-30],
	["MetalFloor4x_DZ",[4.6528, -19.3653, 3.24],-30],
	["MetalFloor4x_DZ",[13.7612, -14.1309, 3.24],-30],
	["MetalFloor4x_DZ",[21.3423, -19.4834, 3.24],-30],
	["MetalFloor4x_DZ",[17.272, -12.2481, 3.24],-30],
	["Base_WarfareBBarrier10xTall",[26.7978, 41.8203, 0],60],
	["Base_WarfareBBarrier10xTall",[39.0347, 20.0703, 0],60],
	["Base_WarfareBBarrier10xTall",[51.9346, -2.4209, 0],60],
	["Base_WarfareBBarrier10xTall",[-50.4038, 0.7959, 0],60],
	["Base_WarfareBBarrier10xTall",[-36.96, -21.9727, 0],60],
	["Base_WarfareBBarrier10xTall",[-23.4951, -44.9912, 0],60],
	["Base_WarfareBBarrier10xTall",[30.8892, -53.1153, 0],-30],
	["Base_WarfareBBarrier10xTall",[-26.7476, 52.0547, 0],150]
],_position,_mission] call WAI_SpawnObjects;

//Spawn Crates
local _loot = if (_aiType == "Hero") then {Loot_Wuhan select 0;} else {Loot_Wuhan select 1;};
[[
	[_loot,WAI_CrateSm,[0,0]]
],((_objects select 2) modelToWorld _cratePos),_mission] call WAI_SpawnCrate;

// The doctor
local _drGrp = [((_objects select 2) modelToWorld _drPos),1,"Easy","Random","","none","Gardener_DZ","Random",[_aiType,500],_mission] call WAI_SpawnGroup;
_drGrp setVariable ["DoNotFreeze", true];
local _doctor = leader _drGrp;
_doctor disableAI "MOVE";

// External Troops
[[(_position select 0) - 26.7149, (_position select 1) + 44.2705, 0],5,_difficulty,"Random","AA","Random",WAI_ScientistSkin,"Random",_aiType,_mission] call WAI_SpawnGroup;
[[(_position select 0) - 35.6089, (_position select 1) - 11.2735, 0],5,_difficulty,"Random","","Random",WAI_ScientistSkin,"Random",_aiType,_mission] call WAI_SpawnGroup;
[[(_position select 0) - 26.1333, (_position select 1) - 45.6035, 0],5,_difficulty,"Random","","Random",WAI_ScientistSkin,"Random",_aiType,_mission] call WAI_SpawnGroup;
//[[(_position select 0) + 34.8667, (_position select 1) + 7.6396, 0],5,_difficulty,"Random","","Random",WAI_ScientistSkin,"Random",_aiType,_mission] call WAI_SpawnGroup;

// Internal Troops - these use "SENTRY" waypoint type
//[[(_position select 0) - 14.0933, (_position select 1) + 8.5674, .25],5,_difficulty,"Random","AT","Random","RU_Doctor","Random",_aiType,_mission] call WAI_SpawnGroup;
[[(_position select 0) + 4.646, (_position select 1) + 18.4238, .25],5,_difficulty,"Random","","Random","RU_Doctor","Random",_aiType,_mission] call WAI_SpawnGroup;
[[(_position select 0) + 2.5156, (_position select 1) - 10.1075, .25],5,_difficulty,"Random","","Random","RU_Doctor","Random",_aiType,_mission] call WAI_SpawnGroup;
[[(_position select 0) + 28.0249, (_position select 1) - 12.8565, .25],5,_difficulty,"Random","","Random","RU_Doctor","Random",_aiType,_mission] call WAI_SpawnGroup;
//[[(_position select 0) + 14.7788, (_position select 1) - 20.7061, .25],5,_difficulty,"Random","","Random","RU_Doctor","Random",_aiType,_mission] call WAI_SpawnGroup;

// Vehicle Patrol
[[(_position select 0) + 100, _position select 1, 0],[(_position select 0) + 100, _position select 1, 0],50,2,"T810A_PKT_DES_ACR_DZ","Random",_aiType,_aiType,_mission] call WAI_VehPatrol;

//Static guns
[[
	((_objects select 0) modelToWorld [-0.0166016,2.62402,0.558044]),
	((_objects select 1) modelToWorld [-0.0166016,2.62402,0.558044]),
	[(_position select 0) - 35.5835, (_position select 1) + 23.0283, 0],
	[(_position select 0) + 2.835, (_position select 1) + 44.1552, 0],
	((_objects select 2) modelToWorld [15.1514,-2.4043,-6.13165]),
	[(_position select 0) - 10.0166, (_position select 1) + 0.2011, 0],
	((_objects select 2) modelToWorld [19.4072,16.3848,-6.10211])
],"KORD_high",_difficulty,_aiType,_aiType,"Random","Random","Random",_mission] call WAI_SpawnStatic;

// Spawn Vehicles
local _vehicle = [WAI_APC,[(_position select 0) + 5.4551, (_position select 1) + 5.9316], _mission, true, -30] call WAI_PublishVeh;
[_vehicle,(typeOf _vehicle),2] call WAI_LoadAmmo;
uiSleep 1; // the warehouse needs to be fully spawned in to place the heli on the roof.
_vehicle = [WAI_ArmedHeli,[(_position select 0) + 2.1392, (_position select 1) - 21.5498, 11.75], _mission, true, -30] call WAI_PublishVeh;
[_vehicle,(typeOf _vehicle),2] call WAI_LoadAmmo;

[
	_mission, // Mission number
	_position, // Position of mission
	_difficulty, // Difficulty
	_name, // Name of Mission
	_localName,
	_aiType, // "Bandit" or "Hero"
	_markerIndex,
	_posIndex,
	_claimPlayer,
	true, // show mission marker?
	false, // make minefields available for this mission
	["assassinate",_doctor], // Completion type: ["crate"], ["kill"], or ["assassinate", _unitGroup],
	_messages
] spawn WAI_MissionMonitor;