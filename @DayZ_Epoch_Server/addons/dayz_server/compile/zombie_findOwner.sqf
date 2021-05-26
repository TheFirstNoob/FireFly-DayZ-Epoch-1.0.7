private["_unit"];
_unit 	= 	_this select 0;
#include "\z\addons\dayz_server\compile\server_toggle_debug.hpp"

#ifdef SERVER_DEBUG
	diag_log ("[СЕРВЕР]: [ОЧИСТКА]: Удаляем неконтролируемых зомби: " + (typeOf _unit) + " из: " + str(_unit) );
#endif

deleteVehicle _unit;
