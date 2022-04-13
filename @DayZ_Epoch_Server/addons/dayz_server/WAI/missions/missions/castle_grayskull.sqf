local _mission = count WAI_MissionData -1;
local _aiType = _this select 0; // "Bandit" or "Hero"
local _hero = _aiType == "Hero";
local _name = "Castle Grayskull";
local _supportedMaps = ["chernarus","chernarus_winter"]; // The default positions listed below are for Chernarus. If you wish to use this mission on another map then you must gather your own list of flat terrain positions.
local _flatPositions = [[4277.94,9457.53],[4144.92,9439.12],[4229.24,9749.14],[3314.31,10614.7],[2152.91,10467.1],[1956.85,10338.3],[4138.71,12630.3],[3999.11,12659.3],[3733.19,14063.7],[3505.19,14168.2],[5191.49,13994.6],[5986.83,14403.1],[6282.33,14097.3],[6497.14,13582.8],[14255.6,14169.6],[13231.9,10718.3],[12080.6,9895.28],[10612.5,8441.86],[8737.68,9200.67],[7137.15,9483.91],[7406.85,3487.04],[7139.72,5321.27],[5227.21,2202.33],[4149.34,2772.77],[1143.01,2439.9],[1230.53,2526.4],[1157.66,4245.54],[1246.03,4612.52],[4436.68,8472.96],[4748.81,5867.21],[5852.48,11010.3]]; // Chernarus
local _position = [_flatPositions] call isValidSpot;

if (count _position < 1 || {!(toLower worldName in _supportedMaps)}) exitWith {
	if (_hero) then {
		WAI_HeroRunning = WAI_HeroRunning - 1; WAI_MissionData set [_mission, -1]; WAI_MarkerReady = true;
	} else {
		WAI_BanditRunning = WAI_BanditRunning - 1; WAI_MissionData set [_mission, -1]; WAI_MarkerReady = true;
	};
};

local _startTime = diag_tickTime;
local _difficulty = "Extreme";
local _localized = ["STR_CL_MISSION_BANDIT", "STR_CL_MISSION_HERO"] select _hero;
local _localName = "STR_CL_GRAYSKULL_TITLE";

diag_log format["[WAI]: %1 %2 started at %3.",_aiType,_name,_position];

local _messages = ["STR_CL_GRAYSKULL_ANNOUNCE","STR_CL_GRAYSKULL_WIN","STR_CL_GRAYSKULL_FAIL"];

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

// Spawn Objects
local _objects = [[
	["MAP_A_Castle_Bergfrit",[0, 0, 0],-118],
	["Land_A_Castle_Donjon",[-9.9136, -56.3155, -6.9],150],
	["Land_A_Castle_Donjon",[48.269, -23.5899, -6.9],150],
	["Land_A_Castle_Gate",[19.6933, -39.376, 0.16360788],150],
	["Land_A_Castle_Stairs_A",[-3.2178, -9.418, -0.15027224],-27],
	["Land_A_Castle_Wall1_20",[35.7534, -31.0733, -1.0470082],150],
	["Land_A_Castle_Wall1_20",[-22.2061, 31.915, 0],-30],
	["Land_A_Castle_Wall2_30",[-19.3956,-39.5801, -0.5399434],-120],
	["Land_A_Castle_Wall2_30",[38.3569, -9.7383, -0.53297883],-300],
	["Land_A_Castle_Bastion",[-42.6607, 20.5839, 0],-76],
	["Land_A_Castle_Bastion",[-0.7754, 41.1093, 0],33],
	["Land_A_Castle_WallS_End",[11.0483, -8.8145, 0]],
	["Land_A_Castle_Wall2_End_2",[-28.252, -15.7022, 0],60],
	["Land_A_Castle_Wall2_End_2",[25.1665, 13.6259, 0],53],
	["Land_A_Castle_Wall2_Corner_2",[10.893, 25.8378, 0],7],
	["Land_A_Castle_Wall2_Corner_2",[-35.1402, 2.0625, 0],-107],
	["Land_A_Castle_Wall2_End",[-15.6451, -1.5752, 0],-30],
	["Land_A_Castle_Wall2_End",[-12.125, 12.2656, 0],60],
	["Land_A_Castle_Bergfrit",[0, 0, 0],-118],
	["Land_A_Castle_Wall1_20_Turn_ruins",[1.5449, -49.2315, -1.810002],-18],
	["Land_fortified_nest_big",[-4.6485, 11.4218, 0],-29],
	["Land_Fort_Watchtower",[31.0649, -20.5664, 0],-120],
	["Land_Fort_Watchtower",[-2.4654, -40.1768, 0],-120],
	["Land_Fort_Watchtower",[17.6709, 5.6084, 0],-210],
	["Land_HBarrier_large",[-20.0684, 9.3222, -0.16],-114],
	["Land_HBarrier_large",[-8.1246, 29.4492, -0.16],30],
	["Land_HBarrier_large",[0.5297, -31.6856, -0.16],-67],
	["Land_HBarrier_large",[21.2143, -20.9278, -0.16],5],
	["Land_HBarrier_large",[-29.604, 17.0527, -0.16],-74],
	["Land_fort_artillery_nest",[-32.8667, 50.4794, 0.4],-30],
	["Land_fort_artillery_nest",[42.645, 18.2978, 0.4],58],
	["Land_fort_artillery_nest",[-48.6299, -29.17, 0.4],-120],
	["Land_fort_artillery_nest",[18.1303, 64.9013, 0.4],34],
	["Land_fort_artillery_nest",[-72.543, 15.9394, 0.4],-90],
	["Land_fort_artillery_nest",[11.02, -81.7247, 0.4],-180],
	["Land_fort_artillery_nest",[59.4721, -53.6338, 0.4],-240]
],_position,_mission] call WAI_SpawnObjects;

//Spawn Crates
local _loot1 = [Loot_GraySkull1 select 1, Loot_GraySkull1 select 0] select _hero;
local _loot2 = [Loot_GraySkull2 select 1, Loot_GraySkull2 select 0] select _hero;
local _loot3 = [Loot_GraySkull3 select 1, Loot_GraySkull3 select 0] select _hero;
local _loot4 = [Loot_GraySkull4 select 1, Loot_GraySkull4 select 0] select _hero;

[[ // Crate in the tower
	[_loot1, WAI_CrateMd, [0,0], -32]
],((_objects select 0) modelToWorld [0.341797,-1.85889,8.7569]),_mission] call WAI_SpawnCrate;

[[
	[_loot2, WAI_CrateMd, [31.7817, -20.461], -34],
	[_loot3, WAI_CrateMd, [17.4746, 6.5839], -118],
	[_loot4, WAI_CrateMd, [-1.4278, -40.1006], -30]
],_position,_mission] call WAI_SpawnCrate;

// External Troops
[[(_position select 0) + 37, (_position select 1) + 15, 0],5,_difficulty,"Random","AA","Random",WAI_ApocalypticSkin,"Random",_aiType,_mission] call WAI_SpawnGroup;
[[(_position select 0) + 15, (_position select 1) + 60, 0],5,_difficulty,"Random","AT","Random",WAI_ApocalypticSkin,"Random",_aiType,_mission] call WAI_SpawnGroup;
[[(_position select 0) - 30, (_position select 1) + 45, 0],5,_difficulty,"Random","","Random",WAI_ApocalypticSkin,"Random",_aiType,_mission] call WAI_SpawnGroup;
//[[(_position select 0) - 66, (_position select 1) + 15, 0],5,_difficulty,"Random","","Random",WAI_ApocalypticSkin,"Random",_aiType,_mission] call WAI_SpawnGroup;
//[[(_position select 0) - 43, (_position select 1) - 26, 0],5,_difficulty,"Random","","Random",WAI_ApocalypticSkin,"Random",_aiType,_mission] call WAI_SpawnGroup;
//[[(_position select 0) + 10, (_position select 1) - 77, 0],5,_difficulty,"Random","","Random",WAI_ApocalypticSkin,"Random",_aiType,_mission] call WAI_SpawnGroup;
//[[(_position select 0) + 55, (_position select 1) - 51, 0],5,_difficulty,"Random","","Random",WAI_ApocalypticSkin,"Random",_aiType,_mission] call WAI_SpawnGroup;

// Internal Troops - these use "SENTRY" waypoint type
[[(_position select 0) - 10, (_position select 1) - 29, .25],5,_difficulty,"Random","AT","Random",WAI_ApocalypticSkin,"Random",_aiType,_mission] call WAI_SpawnGroup;
[[(_position select 0) + 22, (_position select 1) - 11, .25],5,_difficulty,"Random","AA","Random",WAI_ApocalypticSkin,"Random",_aiType,_mission] call WAI_SpawnGroup;
[[(_position select 0) - 1, (_position select 1) + 39, .25],5,_difficulty,"Random","","Random",WAI_ApocalypticSkin,"Random",_aiType,_mission] call WAI_SpawnGroup;
//[[(_position select 0) - 16, (_position select 1) + 25, .25],5,_difficulty,"Random","","Random",WAI_ApocalypticSkin,"Random",_aiType,_mission] call WAI_SpawnGroup;
//[[(_position select 0) - 17, (_position select 1) + 3, .25],5,_difficulty,"Random","","Random",WAI_ApocalypticSkin,"Random",_aiType,_mission] call WAI_SpawnGroup;

// Vehicle Patrol
[[(_position select 0) + 100, _position select 1, 0],[(_position select 0) + 100, _position select 1, 0],50,2,"BAF_Jackal2_L2A1_D_DZ","Random",_aiType,_aiType,_mission] call WAI_VehPatrol;

[WAI_UnarmedTrackedVeh,[(_position select 0) - 9.7, (_position select 1) - 8],_mission, true, -209] call WAI_PublishVeh;

//Static guns
[[
	[(_position select 0) + 27.3671, (_position select 1) - 30.6905, 0],
	((_objects select 2) modelToWorld [-6.04492,6.05078,13.6449]),
	[(_position select 0) - 55.6475, (_position select 1) + 33.6943, 0],
	[(_position select 0) - 5.6695, (_position select 1) + 59.6269, 0],
	((_objects select 1) modelToWorld [6.00293,6.05811,13.7865]),
	[(_position select 0) - 39.3331, (_position select 1) + 19.7656, 0],
	[(_position select 0) - 2.6773, (_position select 1) + 7.0332, 0]
],"Random",_difficulty,WAI_ApocalypticSkin,_aiType,"Random","Random","Random",_mission] call WAI_SpawnStatic;

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
	["crate"], // Completion type: ["crate"], ["kill"], or ["assassinate", _unitGroup],
	_messages
] spawn WAI_MissionMonitor;