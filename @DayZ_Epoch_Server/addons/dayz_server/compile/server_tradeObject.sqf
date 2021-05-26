local _player 		= 	_this select 0;
local _traderID 	= 	_this select 1;
local _buyorsell 	= 	_this select 2;
local _classname 	= 	_this select 3;
local _traderCity 	= 	_this select 4;
local _currency 	= 	_this select 5;
local _price 		= 	_this select 6;

local _message 		= 	"";
local _playerUID 	= 	getPlayerUID _player;
local _name 		= 	if (alive _player) then
						{
							name _player
						}
						else
						{
							"Dead Player"
						};
local _quantity 	= 	1;
local _container 	= 	"gear";

if (count _this > 7) then
{
	_quantity 	= 	_this select 7;
	_container 	= 	_this select 8;	
};

// Включем логгирование всего что входит в '_watchClasses'. Указать количество где '_watchNumber' тогда Продаваемые предметы будут логгироваться.
local _checkItems = true;

if (_checkItems) then
{
	local _watchClasses 	= 
	[
		"ItemBriefcase40oz"
		,"ItemBriefcase50oz"
		,"ItemBriefcase60oz"
		,"ItemBriefcase70oz"
		,"ItemBriefcase80oz"
		,"ItemBriefcase90oz"
		,"ItemBriefcase100oz"
		,"ItemTopaz"
		,"ItemObsidian"
		,"ItemSapphire"
		,"ItemAmethyst"
		,"ItemEmerald"
		,"ItemCitrine"
		,"ItemRuby"
	]; // Предметы которые логгируем
	
	local _watchNumber 	= 	4; // Минимальное количество для логгирования

	if (_quantity >= _watchNumber && {_className in _watchClasses} && {_buyOrSell == 1}) then
	{
		_message 	= 	format ["[СЕРВЕР]: [server_tradeObject.sqf]: [ВНИМАНИЕ]: Игрок: %1 (%2) возможно занимается Дюпингом! Продано %3x %4",_name,_playerUID,_quantity,_className];
		diag_log _message;
	};
};	

if (typeName _currency  == "STRING") then
{_price = format ["%1 %2",_price,_currency];};

if (_buyorsell == 0) then
{
	_message = format["[СЕРВЕР]: [server_tradeObject.sqf]: [ТОРГОВЛЯ]: Игрок: %1 (%2) Купил %3x %4 в: %5 в зоне: %6 за цену: %7",_name,_playerUID,_quantity,_classname,_container,_traderCity,_price];
}
else
{
	_message = format["[СЕРВЕР]: [server_tradeObject.sqf]: [ТОРГОВЛЯ]: Игрок: %1 (%2) Продал %3x %4 из: %5 в зоне: %6 за цену: %7",_name,_playerUID,_quantity,_classname,_container,_traderCity,_price];
};

diag_log _message;