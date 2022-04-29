class Debug_BG
{
	access = 0;
	type = 0;
	idc = -1;
	colorBackground[] = {0,0,0,0};
	colorText[] = {0.8784,0.8471,0.651,1};
	text = "";
	fixedWidth = 0;
	x = 0;
	y = 0;
	h = 0.037;
	w = 0.3;
	style = 0;
	shadow = 1;
	font = "Zeppelin33";
	SizeEx = 0.03921;
};

class Debug_Text
{
	access = 0;
	type = 13;
	idc = -1;
	style = 0;
	colorText[] = {1,1,1,1};
	class Attributes	{
		font = "Zeppelin33";
		color = "#ffffff";
		align = "center";
		shadow = 1;
	};
	x = 0;
	y = 0;
	h = 0.035;
	w = 0.1;
	text = "";
	size = 0.01275 * safezoneH;
	shadow = 1;
};
//---------------------------------------------------------------//
class DEBUGMONITOR
{
	idd = -1;
	fadeout = 1;
	fadein = 1;
	duration = 10e10;
	name = "DEBUGDISPLAY";
	onLoad = "uiNamespace setVariable ['DEBUGDISPLAY', _this select 0]";
	class controlsBackground
	{
		class Debug_BG_DEBUGDISPLAY: Debug_BG
		{
			idc = -1;
			x = 0.8755 * safezoneW + safezoneX;		// x = 0.860750	
			y = 0.1087 * safezoneH + safezoneY;			// y = 0.051481
			w = 0.114 * safezoneW;								// w = 0.120666
			h = 0.09 * safezoneH;								// h = 0.298370
			//w = 0.146666 * safezoneW;
			//h = 0.300370 * safezoneH;
			colorBackground[] = {0,0,0,0.5};
		};

		class Debug_Text_DEBUGDISPLAY:Debug_Text 
		{
			idc = 9000;
			x = 0.8755 * safezoneW + safezoneX;		// x = 0.860750	
			y = 0.1087 * safezoneH + safezoneY;			// y = 0.051481	
			w = 0.114 * safezoneW;								// w = 0.120666
			h = 0.09 * safezoneH;								// h = 0.298370				
			//w = 0.134666 * safezoneW;
			//h = 0.306666 * safezoneH;
			colorBackground[] = {0,0,0,0};
		};
	};
};	

