class CHX_RscStructuredText
{
	access = 0;
	type = 13;
	idc = -1;
	style = 0;
	colorText[] = {1,1,1,9};
	colorBackground[] = {-1,-1,-1,-1};
	class Attributes	{
		font = "Zeppelin32";
		color = "#FFFFFF";
		align = "center";
		valign = "middle";	
		shadow = 1;
	};
	x = 0;
	y = 0;
	h = 0.035;
	w = 0.1;
	text = "";
	size = 0.04421;
	shadow = 2;
};

class CHX_RscPicture
{
	access = 0;
	type = 0;
	idc = -1;
	style = 48;
	colorBackground[] = {0,0,0,0.95};
	colorText[] = {0,0,0,0.95};
	font = "Zeppelin32";
	sizeEx = 0;
	lineSpacing = 0;
	text = "";
	fixedWidth = 0;
	shadow = 0;
	x = 0;
	y = 0;
	w = 0.2;
	h = 0.15;
};

class CHX_RscListBox
{
	style = 0; 
	type = 102;
	shadow = 0;
	font = "Zeppelin32";
	sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * .9)";
	color[] = {0.216,0.231,0.263,1};
	colorText[] = {1,1,1,1.0};
	colorDisabled[] = {1,1,1,0.25};
	colorScrollbar[] = {1,1,1,9};
	colorSelect[] = {0.541,0,0.09,1};
	colorSelect2[] = {1,1,1,9};
	colorSelectBackground[] = {1,1,1,0.2};
	colorSelectBackground2[] = {1,1,1,0.2};
	period = 1.2;
	rowHeight = 0;
	soundSelect[] = {"",.1,1};
	soundExpand[] = {"",.1,1};
	soundCollapse[] = {"",.1,1};
	arrowEmpty = "#(argb,8,8,3)color(1,1,1,1)";
	arrowFull = "#(argb,8,8,3)color(1,1,1,1)";
	maxHistoryDelay = 1;
	autoScrollSpeed = -1;
	autoScrollDelay = 5;
	autoScrollRewind = 0;  
	drawSideArrows = 1;
	idcRight = -1;
	idcLeft = -1;
	
	class ListScrollBar
	{  

		color[] = {1,1,1,9};
		colorActive[] = {1,1,1,1};
		colorDisabled[] = {1,1,1,0.3};
		shadow = 0;
		scrollSpeed = 0.06;
		width = 0;
		height = 0;
		autoScrollEnabled = 0;
		autoScrollSpeed = -1;
		autoScrollDelay = 5;
		autoScrollRewind = 0;
		thumb = "\ca\ui\data\ui_scrollbar_thumb_ca.paa";
		arrowFull = "\ca\ui\data\ui_arrow_top_active_ca.paa";
		arrowEmpty = "\ca\ui\data\ui_arrow_top_ca.paa";
		border = "\ca\ui\data\ui_border_scroll_ca.paa";
	};
	
	class ScrollBar
	{  
		color[] = {1,1,1,0.6};
		colorActive[] = {1,1,1,1};
		colorDisabled[] = {1,1,1,0.3};
		shadow = 0;
		scrollSpeed = 0.06;
		width = 0;
		height = 0;
		autoScrollEnabled = 0;
		autoScrollSpeed = -1;
		autoScrollDelay = 5;
		autoScrollRewind = 0;
		thumb = "\ca\ui\data\ui_scrollbar_thumb_ca.paa";
		arrowFull = "\ca\ui\data\ui_arrow_top_active_ca.paa";
		arrowEmpty = "\ca\ui\data\ui_arrow_top_ca.paa";
		border = "\ca\ui\data\ui_border_scroll_ca.paa";
	};
};

class CHX_RscButton
{
	access = 0;
	type = 1;
	text = "";
	colorText[] = {1,1,1,0.9};
	colorDisabled[] = {1,1,1,0.03};
	colorBackground[] = {1,1,1,0.25};
	colorBackgroundDisabled[] = {0,0,0,0.5};
	colorBackgroundActive[] = {1,1,1,0.25};
	colorFocused[] = {1,1,1,0.25};
	colorShadow[] = {0,0,0,0};
	colorBorder[] = {1,1,1,0.05};
	soundEnter[] = {"\ca\ui\data\sound\onover",0.09,1};
	soundPush[] = {"\ca\ui\data\sound\new1",0,0};
	soundClick[] = {"\ca\ui\data\sound\onclick",0.07,1};
	soundEscape[] = {"\ca\ui\data\sound\onescape",0.09,1};
	style = 2;
	x = 0;
	y = 0;
	w = 0.055589;
	h = 0.039216;
	shadow = 1;
	font = "Zeppelin32";
	sizeEx = 0.03921;
	offsetX = 0.003;
	offsetY = 0.003;
	offsetPressedX = 0.002;
	offsetPressedY = 0.002;
	borderSize = 0;
};

class BuildingCatalogue
{
	idd = 8456;
	name = "BuildingCatalogue";
	movingEnabled = true;
	onload = "uiNamespace setVariable ['BuildingCatalogue', _this select 0]; player setVariable['isBusy',true,true];vehicle_bot=objNull; preview_bot=objNull; preview_camera cameraEffect ['terminate','back']; camDestroy preview_camera; preview_camera = nil; preview_cameraPos = nil; "; 
	onUnload = "player setVariable['isBusy',false,true]; deleteVehicle vehicle_bot; deleteVehicle preview_bot; vehicle_bot=objNull; preview_bot=objNull; preview_camera cameraEffect ['terminate','back']; camDestroy preview_camera; preview_camera = nil; preview_cameraPos = nil; ";

	class ControlsBackground
	{
		class CHXBCATLBG: CHX_RscPicture
		{
			idc = -1;
			text = "#(argb,8,8,3)color(0,0,0,0.65)";
			x = 0.0164805 * safezoneW + safezoneX;
			y = 0.115 * safezoneH + safezoneY;
			w = 0.277218 * safezoneW;
			h = 0.78375 * safezoneH;
		};

		class CHXBCATINFOBG: CHX_RscPicture
		{
			idc = -1;
			text = "#(argb,8,8,3)color(0,0,0,0.65)";
			x = 0.706302 * safezoneW + safezoneX;
			y = 0.115 * safezoneH + safezoneY;
			w = 0.277218 * safezoneW;
			h = 0.78375 * safezoneH;
		};

		class CHXBCATTITLELIST: CHX_RscStructuredText
		{
			idc = -1;
			text = "Постройки Epoch";
			x = 0.0229274 * safezoneW + safezoneX;
			y = 0.12875 * safezoneH + safezoneY;
			w = 0.264324 * safezoneW;
			h = 0.04125 * safezoneH;
		};
	};

	class Controls
	{
		class CHXBCATLB: CHX_RscListbox
		{
			idc = 27421;
			idcLeft = -1;
			idcRight = -1;
			x = 0.0229274 * safezoneW + safezoneX;
			y = 0.18375 * safezoneH + safezoneY;
			w = 0.264324 * safezoneW;
			h = 0.70125 * safezoneH;
			soundSelect[] = {"",0.1,1};
			onLBDblClick  = "player spawn building_previews;  ";
		};

		class CHXBCATINFO: CHX_RscStructuredText
		{
			idc = 4442;
			text = "";
			x = 0.719195 * safezoneW + safezoneX;
			y = 0.1975 * safezoneH + safezoneY;
			w = 0.25143 * safezoneW;
			h = 0.6875 * safezoneH;
		};

		class CHXBCATBT2: CHX_RscButton
		{
			idc = 21601;
			text = "Выйти";
			x = 0.422637 * safezoneW + safezoneX;
			y = 0.885 * safezoneH + safezoneY;
			w = 0.154726 * safezoneW;
			h = 0.04125 * safezoneH;
			onButtonClick = "closeDialog 0;";
			colorBackground[] = {0, 0, 0, 0.5};
		};
	};
};
