#define WeaponList ["Модули к Оружию",190],["Пистолеты",100],["Серия М4A1",101],["Серия М16A4",102],["Серия G36C",103],["Серия FNFAL",104],["Серия L85A2",105],["Серия АК/S/M",106],["Серия SA58",107],["Пист.Пулеметы",108],["Дробовики",109],["Винтовки",110],["Пулеметы",111],["Снайп.винтовки",112],["Гранатометы",113],["Прочее",114]
#define AmmoList ["Патр.Автоматы",200],["Патр.Пистолеты",201],["Патр.Пист.Пулеметы",202],["Патр.Дробовики",203],["Патр.Винтовки",204],["Патр.Снайп.Винтовки",205],["Патр.Пулеметы",206],["Гранаты и Взрывчатка",207],["Патр.Для Техники",208],["Прочее",209] 
#define VehicleList ["Тракторы",300],["Мотоциклы и ATV",301],["Городские машины",302],["Внедорожники (без вооружения)",303],["Внедорожники (с вооружением)",304],["Грузовики и Автобусы",305],["Вертолеты",306]
#define FoodBackpackList ["Еда (Консервы)",400],["Еда (Мясо/Рыба)",401],["Вода",402],["Рюкзаки",403]
#define ConstructionList ["Инструменты",500],["Детали техники",501],["Строительство",502]
#define MedicList ["Медицина",600],["Дымовые",601],["Световые приборы",602]
#define MedicTrade ["FoodBioMeat","ItemZombieParts",1,1,"buy","Zombie Parts","Bio Meat",101]

serverTraders =
[
	"US_Delta_Force_AR_EP1","Soldier_MG_PKM_PMC","Ins_Soldier_AR","Drake_Light"
	,"Graves","GUE_Worker2","Ins_Lopotev","Soldier_GL_PMC"
	,"GUE_Commander","GUE_Woodlander3","Ins_Worker2","RUS_Commander"
	,"Damsel3","CIV_EuroWoman01_EP1","Damsel5","TK_Special_Forces_EP1"
	,"GUE_Woodlander2","GUE_Villager3","Ins_Woodlander3","TK_Special_Forces_MG_EP1"
	,"Dr_Annie_Baker_EP1","Dr_Hladik_EP1","pook_Doc_Bell47","Ins_Woodlander2"
];

/********* Оружие *********/
menu_US_Delta_Force_AR_EP1	=	[[WeaponList],[],"neutral"];
menu_Soldier_MG_PKM_PMC		=	[[WeaponList],[],"neutral"];
menu_Ins_Soldier_AR			=	[[WeaponList],[],"neutral"];
menu_Drake_Light			=	[[WeaponList],[],"neutral"];
/********* Оружие - конец *********/

/********* Патроны *********/
menu_Graves				=	[[AmmoList],[],"neutral"];
menu_GUE_Worker2		=	[[AmmoList],[],"neutral"];
menu_Ins_Lopotev		=	[[AmmoList],[],"neutral"];
menu_Soldier_GL_PMC		=	[[AmmoList],[],"neutral"];
/********* Патроны - конец *********/

/********* Техника *********/
menu_GUE_Commander		=	[[VehicleList],[],"neutral"];
menu_GUE_Woodlander3	=	[[VehicleList],[],"neutral"];
menu_Ins_Worker2		=	[[VehicleList],[],"neutral"];
menu_RUS_Commander		=	[[VehicleList],[],"neutral"];
/********* Техника - конец *********/

/********* Еда и рюкзаки *********/
menu_Damsel3				=	[[FoodBackpackList],[],"neutral"];
menu_CIV_EuroWoman01_EP1	=	[[FoodBackpackList],[],"neutral"];
menu_Damsel5				=	[[FoodBackpackList],[],"neutral"];
menu_TK_Special_Forces_EP1	=	[[FoodBackpackList],[],"neutral"];
/********* Еда и рюкзаки - конец *********/

/********* Стройка и Детали *********/
menu_GUE_Woodlander2			=	[[ConstructionList],[],"neutral"];
menu_GUE_Villager3				=	[[ConstructionList],[],"neutral"];
menu_Ins_Woodlander3			=	[[ConstructionList],[],"neutral"];
menu_TK_Special_Forces_MG_EP1	=	[[ConstructionList],[],"neutral"];
/********* Стройка и Детали - конец *********/

/********* Медик *********/
menu_Dr_Annie_Baker_EP1		=	[[MedicList],[MedicTrade],"neutral"];
menu_Dr_Hladik_EP1			=	[[MedicList],[MedicTrade],"neutral"];
menu_pook_Doc_Bell47		=	[[MedicList],[MedicTrade],"neutral"];
menu_Ins_Woodlander2		=	[[MedicList],[MedicTrade],"neutral"];
/********* Медик - конец *********/