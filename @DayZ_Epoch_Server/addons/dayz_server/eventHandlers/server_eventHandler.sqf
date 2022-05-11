"PVDZ_plr_Death"			addPublicVariableEventHandler {_id 	= 	(_this select 1) spawn server_playerDied};
"PVDZ_plr_Save"				addPublicVariableEventHandler {_id 	= 	(_this select 1) call server_playerSync;};
"PVDZ_plr_SwitchMove"		addPublicVariableEventHandler {((_this select 1) select 0) switchMove ((_this select 1) select 1);}; 	// Нужен для выполнения switchMove на Сервере. rSwitchMove используется только на других Машинах (Клиентах)
"PVDZ_obj_Publish"			addPublicVariableEventHandler {(_this select 1) call server_publishObj}; 								// Используется для построек (Epoch и Vanilla)
"PVDZ_veh_Save" 			addPublicVariableEventHandler {(_this select 1) call server_updateObject};
"PVDZ_plr_Login1"			addPublicVariableEventHandler {_id 	= 	(_this select 1) call server_playerLogin};
"PVDZ_plr_Login2"			addPublicVariableEventHandler {(_this select 1) call server_playerSetup};
"PVDZ_plr_LoginRecord"		addPublicVariableEventHandler {_id 	= 	(_this select 1) spawn dayz_recordLogin};
"PVDZ_obj_Destroy"			addPublicVariableEventHandler {(_this select 1) call server_deleteObj};
"PVDZ_plr_Delete"			addPublicVariableEventHandler {(_this select 1) spawn sched_co_deleteVehicle}; 							// Удаление спрятанных мертвых тел
"PVDZ_send" 				addPublicVariableEventHandler {(_this select 1) call server_sendToClient};
"PVDZ_playerMedicalSync" 	addPublicVariableEventHandler {(_this select 1) call server_medicalSync; ((_this select 1) select 0) setVariable["Medical",((_this select 1) select 1),false]; }; //diag_log format["[СЕРВЕР]: [server_eventHandler.sqf]: %1 - %2",((_this select 1) select 0),((_this select 1) select 1)]; };

// EPOCH
"PVDZE_maintainArea" 	addPublicVariableEventHandler {(_this select 1) spawn server_maintainArea};
"PVDZE_obj_Swap" 		addPublicVariableEventHandler {(_this select 1) spawn server_swapObject}; 		// Используется для Улучшения/ДаунГрейда Epoch построек
"PVDZE_veh_Publish2"	addPublicVariableEventHandler {(_this select 1) call server_publishVeh2}; 		// Используется для Покупки техники у Торговца
"PVDZE_veh_Upgrade"		addPublicVariableEventHandler {(_this select 1) spawn server_publishVeh3}; 		// Используется для Улучшение техники
"PVDZE_obj_Trade"		addPublicVariableEventHandler {(_this select 1) spawn server_tradeObj};			// Логгирование Торговли
"PVDZE_plr_DeathB"		addPublicVariableEventHandler {(_this select 1) spawn server_deaths};
"PVDZE_handleSafeGear" 	addPublicVariableEventHandler {(_this select 1) call server_handleSafeGear};
"SK_changeCode" 		addPublicVariableEventHandler {(_this select 1) call server_changeCode};

if (dayz_groupSystem) then
{
	"PVDZ_Server_UpdateGroup" addPublicVariableEventHandler {(_this select 1) spawn server_updateGroup};
};

"PVDZE_PingSend" addPublicVariableEventHandler {PVDZE_PingReceived 	= 	1; (owner (_this select 1)) publicVariableClient "PVDZE_PingReceived";};

"PVDZ_Server_Simulation" addPublicVariableEventHandler {
	local _agent 	= 	(_this select 1) select 0;
	local _control 	= 	(_this select 1) select 1;
	_agent enableSimulation _control;
};

"PVDZ_obj_Delete" addPublicVariableEventHandler {
	local _obj 		= 	(_this select 1) select 0;
	local _player 	= 	(_this select 1) select 1;
	local _type 	= 	typeOf _obj;
	local _dis 		= 	_player distance _obj;

	if (_type in Dayz_plants) then
	{
		if (_dis < 3) then
		{
			deleteVehicle _obj;
		};
	};

	if (_type == "Blood_Trail_DZ") then
	{
		deleteVehicle _obj;
	};

	// Убедимся что объект это CardboardBox и убедимся, что расстояние от игрока до объекта не превышает 15 метров.
	if (_type iskindOf "CardboardBox") then
	{
		if (_dis < 15) then
		{
			deleteVehicle _obj;
		};
	};
};

"PVDZ_serverStoreVar" addPublicVariableEventHandler {
	local _obj 		= 	(_this select 1) select 0;
	local _name 	= 	(_this select 1) select 1;
	local _value 	= 	(_this select 1) select 2;
	_obj setVariable [_name, _value];
};

"PVDZ_sec_atp" addPublicVariableEventHandler {
	local _y 	= 	_this select 1;

	call {
		if (typeName _y == "STRING") exitwith 		// Просто пару логов для Игрока
		{
			diag_log _y;
		};

		if (count _y == 2) exitwith		// Неверная сторона
		{
			diag_log format["[СЕРВЕР]: [server_eventHandler.sqf]: Игр0к: %1 передал данные о возможном 'side' чите. Сервер может быть скомпрометирован!",(_y select 1) call fa_plr2Str];
		};

 		// Регистрация попадания урона		
		local _source 	= 	_y select 1;
		if (!isNull _source) then
		{
			local _unit 	= 	_y select 0;
			diag_log format ["[СЕРВЕР]: [server_eventHandler.sqf]: Игр0к: %1 | Попадание от: %2 %3 | Из: %4 | Расстояние: %5 | Урон: %6",
			_unit call fa_plr2Str, if (!isPlayer _source && alive _source) then {"AI"} else {_source call fa_plr2Str}, _y select 2, _y select 3, _y select 4, _y select 5];
		};
	};
};

"PVDZ_objgather_Knockdown" addPublicVariableEventHandler {
	local _tree 		= 	(_this select 1) select 0;
	local _player 		= 	(_this select 1) select 1;
	local _dis 			= 	_player distance _tree;
	local _name 		= 	if (alive _player) then
							{
								name _player
							}
							else
							{
								"DeadPlayer"
							};
	local _uid 			= 	getPlayerUID _player;
	local _treeModel 	= 	_tree call fn_getModelName;

	if (_dis < 30 && {_treeModel in dayz_trees or (_treeModel in dayz_plant)} && {_uid != ""}) then
	{
		_tree setDamage 1;
		dayz_choppedTrees set [count dayz_choppedTrees,_tree];
		diag_log format["[СЕРВЕР]: [server_eventHandler.sqf]: Серверный параметр setDamage на Дерево или Растение: %1 было срублено игроком: %2(%3)",_treeModel,_name,_uid];
	};
};