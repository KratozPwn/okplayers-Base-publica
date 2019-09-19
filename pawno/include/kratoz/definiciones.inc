#define INVALID_TIMER -1
#define TIMER_HABLAR 0
#define MAX_TIMERPJ 1
new 
	MySQL:MySQL,
	PlayerText:SeleccionarPJ[MAX_PLAYERS][6],
	MirandoTextDraw[MAX_PLAYERS],
	NombresPJ[MAX_PLAYERS][3][MAX_PLAYER_NAME],
	TimerPlayer[MAX_PLAYERS][MAX_TIMERPJ];

#define NOMBRE_SV		"Gamemode desde 0 - Juego de Rol"
#define CuentaMysql		"root"
#define ContraMysql		""
#define BaseMysql		"gm0"
//ID CLICKTEXTDRAW
#define CLICK_SELECTPJ	1
//ID MYSQL
#define ID_Player 0
//PuntoSpawn
#define Punto_Spawn	1477.1805, -1740.3394, 13.4678
//Dialogos ID
#define d_LoginEmail	0
#define d_Registro		1
#define d_TestRol		2
#define d_Ingreso		3
#define d_General		999
//Creamos atajos
#define Color_Alerta			0xDD710BFF
//HABLAR (CHAT)
#define COLOR_Hablar 					0xE6E6E6E6
#define COLOR_Hablar2					0xC8C8C8C8
#define COLOR_Hablar3					0xAAAAAAAA
#define COLOR_Hablar4					0x8C8C8C8C
#define COLOR_Hablar5					0x6E6E6E6E

#define Mensaje					SendClientMessage
#define Mensaje_SV(%0,%1)		MensajeF(%0, Color_Alerta, "[SERVIDOR]: "%1)
#define MensajeError(%0,%1)		Mensaje(%0, Color_Alerta, "[SERVIDOR]: "%1)
#define CALLBACK:%0(%1) 		forward %0(%1); public %0(%1)
#define MostrarDialog			ShowPlayerDialog
#define K_Format(%1,			format(%1,sizeof(%1),
#define Loop(%0,%1,%2)			for(new %0 = %2; %0 < %1; %0++)
#define KillTimerEx(%0,%1)		if(TimerPlayer[%0][%1]!=INVALID_TIMER) KillTimer(TimerPlayer[%0][%1]), TimerPlayer[%0][%1]=INVALID_TIMER

CALLBACK:Kick_PJ(playerid) return SetTimerEx("Kick", 1000, false, "d", playerid);
CALLBACK:EncontrarPalabra(const search[], const find[]){
	if(strfind(search, find, true) != -1) return true;
	return false;
}
stock EscribirCadena(string[],string2[]){
	strmid(string,string2,0,strlen(string2),strlen(string2)+1);
	return 1;
}
stock IgualdadCadena(const String1[], const String2[]){
	if ((strcmp(String1, String2, true, strlen(String2)) == 0) && (strlen(String2) == strlen(String1))){
		return 1;
	}
	else return 0;
}
stock NombreDePJ(playerid){
	new NombrePJ[24];
	GetPlayerName(playerid,NombrePJ,24);
	new N[24];
	strmid(N,NombrePJ,0,strlen(NombrePJ),24);
	for(new i = 0; i < MAX_PLAYER_NAME; i++){
	if (N[i] == '_') N[i] = ' ';
	}
	return N;
}
stock NombreJ(playerid)
{
	new nombre[MAX_PLAYER_NAME];
	GetPlayerName(playerid, nombre, sizeof(nombre));
	return nombre;
}
stock LimpiarPantalla(playerid,lineas){
	Loop(i,lineas,0) Mensaje(playerid,-1,"");
	return 1;
}
//USamos el MensajeF creditos a Ryan Spell por la creación de esta variable.
#define BYTES_PER_CELL              4
stock MensajeF(playerid, color, fstring[], {Float, _}:...){
	// by Y_Less
	static const STATIC_ARGS = 3;
	new n = (numargs() - STATIC_ARGS) * BYTES_PER_CELL;
	if(n)
	{
		new message[144],arg_start,arg_end;
		#emit CONST.alt        fstring
		#emit LCTRL          5
		#emit ADD
		#emit STOR.S.pri        arg_start

		#emit LOAD.S.alt        n
		#emit ADD
		#emit STOR.S.pri        arg_end
		do
		{
			#emit LOAD.I
			#emit PUSH.pri
			arg_end -= BYTES_PER_CELL;
			#emit LOAD.S.pri      arg_end
		}
		while(arg_end > arg_start);

		#emit PUSH.S          fstring
		#emit PUSH.C          144
		#emit PUSH.ADR         message

		n += BYTES_PER_CELL * 3;
		#emit PUSH.S          n
		#emit SYSREQ.C         format

		n += BYTES_PER_CELL;
		#emit LCTRL          4
		#emit LOAD.S.alt        n
		#emit ADD
		#emit SCTRL          4

		SendClientMessage(playerid, color, message);
	}
	else
	{
		SendClientMessage(playerid, color, fstring);
	}
    return 1;
}
//Prox detector
CALLBACK: ProxDetector(Float:radi, playerid, string[],col1,col2,col3,col4,col5)
{
	if (!IsPlayerConnected (playerid))
		return 1;

	new
		Float: x,
		Float: y,
		Float: z,
		my_vw = GetPlayerVirtualWorld (playerid);

	GetPlayerPos (playerid, x, y, z);

	foreach(new i:Player)
	{
		if (my_vw == GetPlayerVirtualWorld (i))
		{
			new
			Float: distance_p = GetPlayerDistanceFromPoint (i, x, y, z);

			if (distance_p < radi)
			{
				if (distance_p < (radi/5))
				{
					MensajeLargo (i, col1, string);
				}
				else if (distance_p < (radi/4))
				{
					MensajeLargo (i, col2, string);
				}
				else if (distance_p < (radi/3))
				{
					MensajeLargo (i, col3, string);
				}
				else if (distance_p < (radi/2))
				{
					MensajeLargo (i, col4, string);
				}
				else
				{
					MensajeLargo (i, col5, string);
				}
			}
		}
	}
	return 1;
}
stock MensajeLargo(playerid, color, const message[])
{
	new
	    len = strlen(message);
	    
	if(len >= 100)
	{
	    new
	        Part1[105];
	        
		strmid(Part1, message, 0, 100);
		strcat(Part1, "...");
		
		SendClientMessage(playerid, color, Part1);

		strmid(Part1, message, 100, len);
		strins(Part1, "...", 0);

		SendClientMessage(playerid, color, Part1);
		return 1;
	}
	return SendClientMessage(playerid, color, message);
}
//Inyectamos la cadena para evitar algo de inyección.
stock InyectarCadena(cadena[]){
	new str[120];
	mysql_escape_string(cadena, str);
	return str;
}