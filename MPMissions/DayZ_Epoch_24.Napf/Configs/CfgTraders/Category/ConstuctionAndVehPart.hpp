#define typeW type = "trade_weapons";
#define typeI type = "trade_items";
#define buyCVP buy[] = {
#define sellCVP sell[] = {
#define worth ,"worth"};

// Инструменты
class Category_500
{
	class ItemKnife				{typeW	buyCVP 1000 worth 		sellCVP 200 worth };
	class ItemMatchbox			{typeW	buyCVP 1000 worth 		sellCVP 200 worth };
	class ItemToolbox			{typeW	buyCVP 5000 worth 		sellCVP 1000 worth };
	class ItemEtool				{typeW	buyCVP 500 worth 		sellCVP 100 worth };
	class ItemWatch				{typeW	buyCVP 100 worth 		sellCVP 20 worth };
	class ItemCompass			{typeW	buyCVP 2500 worth 		sellCVP 500 worth };
	class ItemMap				{typeW	buyCVP 5000 worth 		sellCVP 1000 worth };
	class ItemGPS				{typeW	buyCVP 12500 worth 		sellCVP 2500 worth };
	class ItemFlashlight		{typeW	buyCVP 250 worth 		sellCVP 50 worth };
	class ItemFlashlightRed		{typeW	buyCVP 250 worth 		sellCVP 50 worth };
	class ItemFishingPole		{typeW	buyCVP 2500 worth 		sellCVP 500 worth };
	class ItemShovel			{typeW	buyCVP 2500 worth 		sellCVP 500 worth };
	class ItemPickaxe			{typeW	buyCVP 2500 worth 		sellCVP 500 worth };
	class ItemSledgeHammer		{typeW	buyCVP 2500 worth 		sellCVP 500 worth };
	class ItemCrowbar			{typeW	buyCVP 2500 worth 		sellCVP 500 worth };
	class ItemHatchet			{typeW	buyCVP 2500 worth 		sellCVP 500 worth };
	class Itemmachete			{typeW	buyCVP 2500 worth 		sellCVP 500 worth };
	class Binocular				{typeW	buyCVP 1000 worth 		sellCVP 200 worth };
	class Binocular_Vector		{typeW	buyCVP 40000 worth 		sellCVP 8000 worth };
	class NVGoggles				{typeW	buyCVP 50000 worth 		sellCVP 10000 worth };
	class ChainSaw				{typeW	buyCVP 20000 worth 		sellCVP 4000 worth };
	class ChainSawB				{typeW	buyCVP 20000 worth 		sellCVP 4000 worth };
	class ChainSawG				{typeW	buyCVP 20000 worth 		sellCVP 4000 worth };
	class ChainSawP				{typeW	buyCVP 20000 worth 		sellCVP 4000 worth };
	class ChainSawR				{typeW	buyCVP 20000 worth 		sellCVP 4000 worth };
};

// Детали техники (1л - 1000)
class Category_501
{
	class PartFueltank			{typeI	buyCVP 2000 worth 		sellCVP 400 worth };
	class PartWheel				{typeI	buyCVP 2000 worth 		sellCVP 400 worth };
	class PartEngine			{typeI	buyCVP 3000 worth 		sellCVP 600 worth };
	class PartGlass				{typeI	buyCVP 500 worth 		sellCVP 100 worth };
	class PartGeneric			{typeI	buyCVP 500 worth 		sellCVP 100 worth };
	class PartVRotor			{typeI	buyCVP 15000 worth 		sellCVP 3000 worth };
	class ItemFuelcanEmpty		{typeI	buyCVP 100 worth 		sellCVP 20 worth };
	class ItemFuelcan			{typeI	buyCVP 600 worth 		sellCVP 120 worth };
	class ItemJerrycanEmpty		{typeI	buyCVP 400 worth 		sellCVP 80 worth };
	class ItemJerrycan			{typeI	buyCVP 2000 worth 		sellCVP 400 worth };
	class ItemFuelBarrelEmpty	{typeI	buyCVP 3500 worth 		sellCVP 700 worth };
	class ItemFuelBarrel		{typeI	buyCVP 21000 worth 		sellCVP 4200 worth };
};

// Строительство (1 место - 1000)
class Category_502
{
	class ItemTent			{typeI	buyCVP 5000 worth 		sellCVP 1000 worth };
	class ItemDomeTent		{typeI	buyCVP 7500 worth 		sellCVP 1500 worth };
	class ItemDesertTent	{typeI	buyCVP 7500 worth 		sellCVP 1500 worth };
	class plot_pole_kit		{typeI	buyCVP 50000 worth 		sellCVP 10000 worth };
	class ItemVault			{typeI	buyCVP 50000 worth 		sellCVP 10000 worth };
	class ItemLockbox		{typeI	buyCVP 75000 worth 		sellCVP 15000 worth };
};