private["_num","_sound","_length","_pause"];
while {!r_player_dead} do {
	_num = round(random 37);
	_sound = "z_suspense_" + str(_num);
	_length = getNumber(configFile >> "cfgMusic" >> _sound >> "Duration");
	_pause = ((random 5) + 2) + _length;
	if (!r_player_unconscious && !r_pitchWhine) then {
		playMusic _sound;
	};
	uiSleep _pause;
};