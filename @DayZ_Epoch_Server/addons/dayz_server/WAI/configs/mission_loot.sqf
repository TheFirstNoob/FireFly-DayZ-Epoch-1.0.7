// This file contains loot array definitions per mission
// Array format [long guns, tools, items, pistols, backpacks] - Either a number or a custom array.
// First array is for Hero missions, second is for bandit missions. Change the values to preferences.
// [[Hero Loot Array],
//	[Bandit Loot Array]]

/***** Easy Missions *****/
Loot_UralAttack = [
	[4,8,36,3,1], // Hero
	[4,8,36,3,1] // Bandit
];
Loot_Farmer = [
	[6,5,[40,WAI_Medical],3,3], // Hero
	[6,5,[40,WAI_Medical],3,3] // Bandit
];
Loot_MediCamp = [
	[0,0,[70,WAI_Medical],3,3], // Hero
	[0,0,[70,WAI_Medical],3,3] // Bandit
];
Loot_Outpost = [
	[6,4,40,2,3], // Hero
	[6,4,40,2,3] // Bandit
];
Loot_ScoutPatrol = [
	[4,8,36,2,3], // Hero
	[4,8,36,2,3] // Bandit
];
Loot_SlaughterHouse = [
	[6,5,[15,WAI_VehAmmo],2,3], // Hero
	[6,5,[15,WAI_VehAmmo],2,3] // Bandit
];

/***** Medium Missions *****/
Loot_AbandonedTrader = [
	[8,5,15,3,3], // Hero
	[8,5,15,3,3] // Bandit
];
Loot_ArmedVehicle = [
	[0,0,[35,WAI_VehAmmo],0,3], // Hero
	[0,0,[35,WAI_VehAmmo],0,3] // Bandit
];
Loot_BHC = [ // Black Hawk Crash
	[5,5,10,3,1], // Hero
	[5,5,10,3,1] // Bandit
];
Loot_DrugBust = [
	[5,5,[10,WAI_Hemp],3,3], // Hero
	[5,5,[10,WAI_Hemp],3,3] // Bandit
];
Loot_Junkyard = [
	[14,5,1,3,1], // Hero
	[14,5,1,3,1] // Bandit
];
Loot_Patrol = [
	[3,0,[2,["ItemBriefcase100oz"]],0,1], // Hero
	[3,0,[2,["ItemBriefcase100oz"]],0,1] // Bandit
];
Loot_VehicleDrop = [
	[3,0,[2,["ItemBriefcase100oz"]],0,1], // Hero
	[3,0,[2,["ItemBriefcase100oz"]],0,1] // Bandit
];
Loot_WeaponCache = [
	[10,4,0,3,4], // Hero
	[10,4,0,3,4] // Bandit
];

/***** Hard Missions *****/
Loot_ArmyBase = [
	[10,5,10,3,5], // Hero
	[10,5,10,3,5] // Bandit
];
Loot_Base = [
	[[16,WAI_Sniper],8,[3,WAI_HighValue],3,[4,WAI_PacksLg]], // Hero
	[[16,WAI_Sniper],8,[3,WAI_HighValue],3,[4,WAI_PacksLg]] // Bandit
];
Loot_CannibalCave = [
	[10,8,[2,WAI_HighValue],3,[2,WAI_PacksLg]], // Hero
	[10,8,[2,WAI_HighValue],3,[2,WAI_PacksLg]] // Bandit
];
Loot_CapturedMV22 = [
	[0,0,[80,WAI_Medical],3,3], // Hero
	[0,0,[80,WAI_Medical],3,3] // Bandit
];
Loot_CropRaider = [
	[6,5,[15,WAI_Hemp],3,3], // Hero
	[6,5,[15,WAI_Hemp],3,3] // Bandit
];
Loot_DronePilot = [
	[14,8,[2,WAI_HighValue],3,[2,WAI_PacksLg]], // Hero
	[14,8,[2,WAI_HighValue],3,[2,WAI_PacksLg]] // Bandit
];
Loot_GemTower = [
	[8,5,[4,wai_gems],3,2], // Hero
	[8,5,[4,wai_gems],3,2] // Bandit
];
Loot_IkeaConvoy = [
	[[1,WAI_Chainsaws],[8,WAI_ToolsBuildable],[30,WAI_Ikea],3,4], // Hero
	[[1,WAI_Chainsaws],[8,WAI_ToolsBuildable],[30,WAI_Ikea],3,4] // Bandit
];
Loot_LumberJack = [
	[6,[8,WAI_ToolsBuildable],[20,WAI_Wood],3,[4,WAI_PacksLg]], // Hero
	[6,[8,WAI_ToolsBuildable],[20,WAI_Wood],3,[4,WAI_PacksLg]] // Bandit
];
Loot_MacDonald = [
	[9,5,[15,WAI_Hemp],3,2], // Hero
	[9,5,[15,WAI_Hemp],3,2] // Bandit
];
Loot_Radioshack = [
	[10,5,30,3,2], // Hero
	[10,5,30,3,2] // Bandit
];
Loot_Extraction = [
	[[10,WAI_Sniper],4,[10,WAI_HeliAmmo],3,2], // Hero
	[[10,WAI_Sniper],4,[10,WAI_HeliAmmo],3,2] // Bandit
];
Loot_TankColumn = [
	[12,5,30,3,4], // Hero
	[12,5,30,3,4] // Bandit
];

/***** Extreme Missions *****/
Loot_Firestation1 = [ // Fire Station Crate 1
	[0,0,[4,WAI_HighValue],0,2], // Hero
	[0,0,[4,WAI_HighValue],0,2] // Bandit
];
Loot_Firestation2 = [ // Fire Station Crate 2
	[[10,WAI_Sniper],3,20,3,5], // Hero
	[[10,WAI_Sniper],3,20,3,5] // Bandit
];
Loot_Mayors = [
	[10,5,[4,WAI_HighValue],3,[2,WAI_PacksLg]], // Hero
	[10,5,[4,WAI_HighValue],3,[2,WAI_PacksLg]] // Bandit
];
Loot_Presidents = [
	[0,0,[40,WAI_Presidents],0,4], // Hero
	[0,0,[40,WAI_Presidents],0,4] // Bandit
];
Loot_Wuhan = [
	[0,0,[6,["ItemBriefcase100oz"]],0,3], // Hero
	[0,0,[6,["ItemBriefcase100oz"]],0,3] // Bandit
];
Loot_GraySkull1 = [ // Castle Grayskull Crate 1
	[0,0,[4,WAI_HighValue],0,1], // Hero
	[0,0,[4,WAI_HighValue],0,1] // Bandit
];
Loot_GraySkull2 = [ // Castle Grayskull Crate 2
	[[10,WAI_Sniper],3,20,3,2], // Hero
	[[10,WAI_Sniper],3,20,3,2] // Bandit
];
Loot_GraySkull3 = [ // Castle Grayskull Crate 3
	[10,5,30,3,2], // Hero
	[10,5,30,3,2] // Bandit
];
Loot_GraySkull4 = [ // He-Man smokes weed
	[0,0,[15,WAI_Hemp],0,3], // Hero
	[0,0,[15,WAI_Hemp],0,3] // Bandit
];
