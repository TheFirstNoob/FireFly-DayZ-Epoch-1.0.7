private ["_display","_stats","_time", "_hours", "_minutes","_DebugText","_servername","_spacer"];
disableSerialization;
//--------------------------------------------------------------------------------------------//
_display = uiNameSpace getVariable "DEBUGDISPLAY";
_stats = _display displayCtrl 9000;
//--------------------------------------------------------------------------------------------//
_servername = "FireFly Dayz Epoch";
_spacer = "------------------------------------------";
//--------------------------------------------------------------------------------------------//
while {1 == 1} do {
	_time 		= 	(round(360-(serverTime)/60));
	_hours 		= 	(floor(_time/60));
	_minutes 	= 	(_time-(_hours*60));

	switch(_minutes) do	{
		case 9: {_minutes = "09"};
		case 8: {_minutes = "08"};
		case 7: {_minutes = "07"};
		case 6: {_minutes = "06"};
		case 5: {_minutes = "05"};
		case 4: {_minutes = "04"};
		case 3: {_minutes = "03"};
		case 2: {_minutes = "02"};
		case 1: {_minutes = "01"};
		case 0: {_minutes = "00"};
	};
	
//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------//
	_DebugText = format ["<t size='1.4' font='Zeppelin33' align='center' color='#D9FF00'>%1</t><br/>", _servername];
/*-----------*/	_DebugText = _DebugText + format ["<t size='0.8' font='Zeppelin33' align='left' color='#CCCCCC'>%1</t><br/>", _spacer];
	_DebugText = _DebugText + format ["<t size='1.2' font='Zeppelin33' align='left' color='#8CFA16'>FPS: </t><t size='1.2' font='Zeppelin33' align='left' color='#FFFFFF'>%1</t>", round diag_fps];
	_DebugText = _DebugText + format ["<t size='1.2' font='Zeppelin33' align='right' color='#E5E5E5'>Игроков: </t><t size='1.2' font='Zeppelin33' align='right' color='#FFFFFF'>%1</t><br/>", count playableUnits];
	_DebugText = _DebugText + format ["<t size='1.2' font='Zeppelin33' align='left' color='#D0F000'>Денег: </t><t size='1.2' font='Zeppelin33' align='right' color='#FFFFFF'>%1</t><br/>", [player getVariable["cashMoney",0]] call BIS_fnc_numberText];
/*-----------*/	_DebugText = _DebugText + format ["<t size='0.8' font='Zeppelin33' align='left' color='#CCCCCC'>%1</t><br/>", _spacer];
	_DebugText = _DebugText + format ["<t size='1.1' font='Zeppelin33' align='center' color='#D9FF00'>Рестарт через: </t><t size='1.2' font='Zeppelin33' align='center' color='#FFFFFF'>%1:%2</t><br/>", _hours, _minutes];
//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------//
	_stats ctrlSetStructuredText parseText _DebugText;
	uiSleep 3;
};