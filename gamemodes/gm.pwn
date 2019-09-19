/*

Respetar los creditos a Kratoz - Comunidad: OkPlayers Juego de Rol.
Versión: 0.0.1
Actualizado: 19/09/2019

*/
#include <a_samp>

#include <a_mysql>
#include <bcrypt>
#define BCRYPT_COST 12
#include <YSI_Data/y_iterate.inc>
#include <YSI_Data/y_foreach.inc>
#include <izcmd>
#include <sscanf2>
#include <streamer>
#include <kratoz/definiciones.inc>
#include <kratoz/jugador.inc>
#include <bcrypt.inc>
//Sistema de encriptado
forward OnPasswordHashed(playerid);
forward OnPasswordChecked(playerid);
main()
{
	print("\n----------------------------------");
	print("[Kratoz]: Cargando "#NOMBRE_SV"...");
	print("----------------------------------\n");
}
//Sistema de test de rol
enum _examenrol{
	Pregunta[120],
	Alternativas[300],
	Respuesta
};
new TestRol[10][_examenrol]={
	{"El death Match(DM)...",//1
	"A) Está permitido en el servidor hasta una cierta hora.\n\
	B) Es cuando asisto con mi pandilla a matar a la pandilla por problemas OOC.\n\
	C) Es la acción violenta dentro del servidor teniendo motivos para ejecutarlo.\n\
	D) Es matar sin razón a los administradores.", 1},
	{"¿Que ejemplo no es PG?",//2
	"A) Rolear dar un puñetazo a un usuario y matarlo de un solo golpe.\n\
	B) Tirarte de un cuarto piso de un edificio y rolear saber caer bien.\n\
	C) Estoy roleando con mi mafia en mi coche de mafioso, mientras fumo.\n\
	D) Saltar para evitar cansarte.", 2},
	{"¿Que ejemplo no es MG?",//3
	"A) Le hablo por teamspeak a mis amigos que que iré a comer.\n\
	B) Llamo a mis amigos IC para que conecten al whatsapp por /b.\n\
	C) Compro Marihuana y le regalo a mi compañero de pandilla.\n\
	D) Veo por foro que quieren matar a un compañero, se lo comunico IC.", 2},
	{"¿Que es IC?",//4
	"A) La información que he optenido OOC para uso IC.\n\
	B) Toda información de mi personaje ingame.\n\
	C) Información de mi vida privada.\n\
	D) Toda información ooc dicha ingame.", 1},
	{"Roleo de pandillero y...",//5
	"A) Llevo el rol que quiero tener para mi pj, respetando las normativas.\n\
	B) Compro marihuana para fumarla ooc.\n\
	C) Puedo asesinar a quien se me pegue la gana.\n\
	D) Según normativa, tengo que usar un savana o glendale", 0},
	{"Un administrador me banneo",//6
	"A) Posteo por foro que es una injusticia, y pido desban.\n\
	B) Solicito a un administrador dueño tome mi caso.\n\
	C) Posteo mi descargo en el foro y espero que me respondan.\n\
	D) Posteo mi descargo en el foro muchas veces para que vean mi caso.", 2},
	{"¿Que ejemplo es buen anuncio?",//7
	"A) Compro escoba de volar.\n\
	B) Joven emprendedor busca empleo en el servidor.\n\
	C) Se realizan trabajos de pintado vehícular, a solo $200.\n\
	D) Compro DisKo multimedia para escuchar música desde internet.", 2},
	{"¿Que ejemplo es buen rol?",//8
	"A) /me se vería a Vinny como sangraría por la pierna.\n\
	B) /me mira la hora de su reloj de muñeca.\n\
	C) /me [Sonido-Coche] Se ecucharía algo mal el motor.\n\
	D) /do Usa el comando /comprar para que compres algo colega.", 1},
	{"¿Que ejemplo es CJ?",//9
	"A) Un negro empieza a vender coca, y me la roba.\n\
	B) Subirme a los coches sin rol previo para arrancar.\n\
	C) Atropellar a un jugador realizando Car Jugador muerto.\n\
	D) Subir a los coches sin rol previo para quitarlo.", 3},
	{"Si un policía me apunta...",//10
	"A) Rolearía agacharme y gatear para poder escaparme.\n\
	B) Levantar las manos y correr evitando que me caigan las balas.\n\
	C) Resistirse al arresto ya que si muevo un pelo me puede costar la vida.\n\
	D) Rendirte, y hacer caso a lo que ordene el oficial.", 3}
};

public OnGameModeInit()//Inicia el servidor lo primero que carga aparte del main
{
	SendRconCommand("hostname "#NOMBRE_SV"");
	SendRconCommand("language Español");
	MySQL = mysql_connect("127.0.0.1", CuentaMysql, ContraMysql, BaseMysql);
	if(mysql_errno() != 0){
		print("[Consola-ALERTA]: No se pudo conectar.");
		SendRconCommand("exit");
		return 1;
	}
	else{
		print("[Consola]"#NOMBRE_SV" se ha conectado correctamente.");
	}
	SetGameModeText("Los Santos");
	Loop(i,311,0){
		AddPlayerClass(i,Punto_Spawn,269.1425,-1,-1,-1,-1,-1,-1);
	}
	new query[200];
	mysql_format(MySQL,query, sizeof(query), "UPDATE `cuentas_email` SET `Logeado`='0' WHERE (`Logeado`='1')");
	mysql_query(MySQL, query);
	Loop(i,MAX_PLAYERS,0){
		ResetVariablePJ(i,true);
	}
	return 1;
}

public OnGameModeExit()
{
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
	return 0;
}
public OnPlayerFinishedDownloading(playerid, virtualworld){
	MostrarDialog_Ok(playerid, d_LoginEmail, 0);
	return 1;
}
public OnPlayerConnect(playerid)
{
	new str[120];
	K_Format(str, "Conectando_%d", playerid);
	SetPlayerName(playerid, str);
	SetPlayerColor(playerid, 0x78787800);
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	if(Ingreso[playerid] == 1){//Guardamos lo que tenemos del pj para evitar perder posición
		GetPlayerPos(playerid, InfoJugador[playerid][Posicion_X], InfoJugador[playerid][Posicion_Y], InfoJugador[playerid][Posicion_Z]);
		new query[200];
		mysql_format(MySQL,query, sizeof(query), "UPDATE `cuentas` SET `Posicion_X`='%f',`Posicion_Y`='%f',`Posicion_Z`='%f' WHERE (`ID`='%d')", 
			InfoJugador[playerid][Posicion_X], InfoJugador[playerid][Posicion_Y], InfoJugador[playerid][Posicion_Z],
			InfoJugador[playerid][ID_Cuenta]);
		mysql_query(MySQL, query);
	}
	ResetVariablePJ(playerid);
	return 1;
}

public OnPlayerSpawn(playerid)
{
	if(Ingreso[playerid] == 1){
		Mensaje(playerid, -1, "[SERVIDOR]: Bienvenido al servidor.");
		SetPlayerColor(playerid, 0xFFFFFF00);
	}
	else{
		Mensaje(playerid, Color_Alerta, "[SERVIDOR]: Debes logear correctamente, relogea.");
		Kick(playerid);
	}
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	return 1;
}

public OnVehicleSpawn(vehicleid)
{
	return 1;
}

public OnVehicleDeath(vehicleid, killerid)
{
	return 1;
}

public OnPlayerText(playerid, text[])
{
	if(Ingreso[playerid] != 1) return MensajeError(playerid, "Debes logear primero para poder enviar algún texto."), 0;
	else{
		new
			string[180],
			len = strlen(text);

		K_Format(string,"%s: %s",NombreDePJ(playerid), text);
		ProxDetector(20,playerid,string,-1,COLOR_Hablar,COLOR_Hablar2,COLOR_Hablar3,COLOR_Hablar4);
		//Le damos la Animación para hablar.
		if (len > 2){
			new
				animi = GetPlayerAnimationIndex(playerid);
			switch(animi){
				case 1189, 1231:{
					KillTimerEx(playerid, TIMER_HABLAR);
					TimerPlayer[playerid][TIMER_HABLAR] = SetTimerEx("PararAnimChat", len * 50, false, "i", playerid);
					ApplyAnimation(playerid, "PED", "IDLE_chat", 4.0, 1, 0, 0, 1, 1, true); // SAY
				}
			}
		}
	}
	return 0;
}
CALLBACK: PararAnimChat (playerid){
	switch(GetPlayerAnimationIndex(playerid)){
		case 1189, 1231, 1266:{
			ApplyAnimation(playerid, "CARRY", "crry_prtial", 1.0, 0, 1, 1, 0, 0);
		}
	}
	TimerPlayer[playerid][TIMER_HABLAR] = INVALID_TIMER;
}
//%s es para string o cadenas de texto
//%d Es para Número | %i Es para enteros
//%f Es para Float cordenadas, lugares, x, y ,z angulos, etc.
public OnPlayerCommandReceived(playerid,cmdtext[]){
	printf("%s: %s", NombreJ(playerid), cmdtext);
	return 1;
}
//success = 1 Es por que el comando se ejecuta en el servidor
//success = 0 Es por que el comando no se ejecuta en el servidor
public OnPlayerCommandPerformed(playerid,cmdtext[], success){
	if(!success){
		Mensaje(playerid, Color_Alerta, "[ERROR]: El comando colocado no se encuentra en el servidor.");
	}
	return 1;
}
CMD:creditos(playerid){
	MostrarDialog(playerid, d_General, DIALOG_STYLE_MSGBOX, "{FFFFFF}Creditos", "{FFFFFF}- Programado por: Kratoz\n- GameMode base OkPlayers Juego de Rol\n- Dicord de contacto: KratoZ#9037.", "Gracias","");
	return 1;
}
public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	return 1;
}

public OnPlayerEnterCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveCheckpoint(playerid)
{
	return 1;
}

public OnPlayerEnterRaceCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveRaceCheckpoint(playerid)
{
	return 1;
}

public OnRconCommand(cmd[])
{
	return 1;
}

public OnPlayerRequestSpawn(playerid)
{
	Mensaje(playerid, Color_Alerta, "[SERVIDOR]: Debes logear correctamente desde Login/Registro.");
	return 0;
}

public OnObjectMoved(objectid)
{
	return 1;
}

public OnPlayerObjectMoved(playerid, objectid)
{
	return 1;
}

public OnPlayerPickUpPickup(playerid, pickupid)
{
	return 1;
}

public OnVehicleMod(playerid, vehicleid, componentid)
{
	return 1;
}

public OnVehiclePaintjob(playerid, vehicleid, paintjobid)
{
	return 1;
}

public OnVehicleRespray(playerid, vehicleid, color1, color2)
{
	return 1;
}

public OnPlayerSelectedMenuRow(playerid, row)
{
	return 1;
}

public OnPlayerExitedMenu(playerid)
{
	return 1;
}

public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	return 1;
}

public OnRconLoginAttempt(ip[], password[], success)
{
	return 1;
}

public OnPlayerUpdate(playerid)
{
	return 1;
}

public OnPlayerStreamIn(playerid, forplayerid)
{
	return 1;
}

public OnPlayerStreamOut(playerid, forplayerid)
{
	return 1;
}

public OnVehicleStreamIn(vehicleid, forplayerid)
{
	return 1;
}

public OnVehicleStreamOut(vehicleid, forplayerid)
{
	return 1;
}
stock MostrarDialog_Ok(playerid, dialogid, caso){
	SetPVarInt(playerid, "PasoDialog", caso);
	switch(dialogid){
		case d_LoginEmail:{
			switch(caso){
				case 0:{
					MostrarDialog(playerid, d_LoginEmail, DIALOG_STYLE_INPUT, ""#NOMBRE_SV"", "Coloque el correo de su cuenta", "Siguiente", "Salir");
				}
			}
		}
		case d_Registro:{
			switch(caso){
				//case 0: MostrarDialog(playerid, d_Registro, DIALOG_STYLE_INPUT, "Registro", "Bienvenido a "#NOMBRE_SV"\n¿Cual será su correo?", "Siguiente", "Salir");
				case 0: MostrarDialog(playerid, d_Registro, DIALOG_STYLE_INPUT, "Registro", "¿Su contraseña?\nRecuerde que debe colocar como mínimo 5 carácteres.", "Siguiente", "Salir");
				case 1: MostrarDialog(playerid, d_Registro, DIALOG_STYLE_LIST, "Registro-Sexo", "1) Hombre\n2) Mujer", "Siguiente", "Salir");
				case 2: MostrarDialog(playerid, d_Registro, DIALOG_STYLE_LIST, "Registro-Procedencia", "1) Los santos\n2) Las venturas\n3) San fierro", "Siguiente", "Salir");
				case 3: MostrarDialog(playerid, d_Registro, DIALOG_STYLE_INPUT, "Registro-Edad", "¿Cual es la edad para su personaje?", "Siguiente", "Salir");
				case 4: MostrarDialog(playerid, d_Registro, DIALOG_STYLE_INPUT, "Registro-Nombre", "¿Cual es el Nombre_Apellido para su personaje?", "Crear", "Salir");
			}
		}
		case d_TestRol:{
			switch(caso){
				case 0..9: MostrarDialog(playerid, d_TestRol, DIALOG_STYLE_LIST, TestRol[caso][Pregunta], TestRol[caso][Alternativas], "Responder", "Atras");
				case 10:{
					new str[200];
					K_Format(str, "Correctas: %d.\nIncorrectas: %d.\nResultado: %s", ResultadoTestRol[playerid], 10-ResultadoTestRol[playerid], ResultadoTestRol[playerid] >=8 ? ("APROBADO"):("DESAPROBADO"));
					MostrarDialog(playerid, d_TestRol, DIALOG_STYLE_MSGBOX, "Exámen de rol", str, "Siguiente", "Salir");
				}
			}
		}
		case d_Ingreso:{
			switch(caso){
				case 0:{
					MostrarDialog(playerid, d_Ingreso, DIALOG_STYLE_PASSWORD, "Ingreso", "Bienvenido a "#NOMBRE_SV"\n¿Cual es su contraseña?", "Ingresar", "Salir");
				}
				case 1:{
					new query[300], row;
					mysql_format(MySQL,query, sizeof(query), "SELECT * FROM `cuentas` WHERE `ID_Cuenta`='%d' LIMIT 3", InfoJugador[playerid][ID_Cuenta]);
					mysql_query(MySQL, query);
					//Verificamos
					row = cache_num_rows();
					if(row){
						new skin[3], contenido[120];
						Loop(i, row, 0){
							cache_get_value_name(i, "Nombre", contenido);EscribirCadena(NombresPJ[playerid][i],contenido);
							cache_get_value_int(i, "Ropa", skin[i]);
						}
						SeleccionarPJ[playerid][0] = CreatePlayerTextDraw(playerid, 118.000000, 166.000000, "Nowy_TextDraw");
						PlayerTextDrawSetPreviewModel(playerid, SeleccionarPJ[playerid][0], skin[0]);
						PlayerTextDrawLetterSize(playerid, SeleccionarPJ[playerid][0], 0.600000, 2.000000);
						PlayerTextDrawTextSize(playerid, SeleccionarPJ[playerid][0], 130.000000, 155.000000);
						SeleccionarPJ[playerid][1] = CreatePlayerTextDraw(playerid, 253.000000, 166.000000, "Nowy_TextDraw");
						PlayerTextDrawLetterSize(playerid, SeleccionarPJ[playerid][1], 0.600000, 2.000000);
						PlayerTextDrawTextSize(playerid, SeleccionarPJ[playerid][1], 130.000000, 155.000000);
						PlayerTextDrawSetPreviewModel(playerid, SeleccionarPJ[playerid][1], skin[1]);
						SeleccionarPJ[playerid][2] = CreatePlayerTextDraw(playerid, 404.000000, 166.000000, "Nowy_TextDraw");
						PlayerTextDrawLetterSize(playerid, SeleccionarPJ[playerid][2], 0.600000, 2.000000);
						PlayerTextDrawTextSize(playerid, SeleccionarPJ[playerid][2], 130.000000, 155.000000);
						PlayerTextDrawSetPreviewModel(playerid, SeleccionarPJ[playerid][2], skin[2]);
						Loop(i, 3, 0){
							PlayerTextDrawFont(playerid, SeleccionarPJ[playerid][i], 5);
							PlayerTextDrawSetOutline(playerid, SeleccionarPJ[playerid][i], 1);
							PlayerTextDrawSetShadow(playerid, SeleccionarPJ[playerid][i], 0);
							PlayerTextDrawAlignment(playerid, SeleccionarPJ[playerid][i], 1);
							PlayerTextDrawColor(playerid, SeleccionarPJ[playerid][i], -1);
							PlayerTextDrawBackgroundColor(playerid, SeleccionarPJ[playerid][i], 0);
							PlayerTextDrawBoxColor(playerid, SeleccionarPJ[playerid][i], 255);
							PlayerTextDrawUseBox(playerid, SeleccionarPJ[playerid][i], 1);
							PlayerTextDrawSetProportional(playerid, SeleccionarPJ[playerid][i], 1);
							PlayerTextDrawSetSelectable(playerid, SeleccionarPJ[playerid][i], 0);
							PlayerTextDrawSetPreviewRot(playerid, SeleccionarPJ[playerid][i], -10.000000, 0.000000, -4.000000, 1.000000);
							PlayerTextDrawSetPreviewVehCol(playerid, SeleccionarPJ[playerid][i], 1, 1);
							PlayerTextDrawShow(playerid, SeleccionarPJ[playerid][i]);
						}
						SeleccionarPJ[playerid][3] = CreatePlayerTextDraw(playerid, 185.000000, 328.000000, NombresPJ[playerid][0]);
						PlayerTextDrawLetterSize(playerid, SeleccionarPJ[playerid][3], 0.354166, 1.350000);
						PlayerTextDrawTextSize(playerid, SeleccionarPJ[playerid][3], 10.000000, 69.500000);
						SeleccionarPJ[playerid][4] = CreatePlayerTextDraw(playerid, 321.000000, 328.000000, NombresPJ[playerid][1]);
						PlayerTextDrawLetterSize(playerid, SeleccionarPJ[playerid][4], 0.354166, 1.350000);
						PlayerTextDrawTextSize(playerid, SeleccionarPJ[playerid][4], 10.000000, 69.500000);
						SeleccionarPJ[playerid][5] = CreatePlayerTextDraw(playerid, 472.000000, 328.000000, NombresPJ[playerid][2]);
						PlayerTextDrawLetterSize(playerid, SeleccionarPJ[playerid][5], 0.354166, 1.350000);
						PlayerTextDrawTextSize(playerid, SeleccionarPJ[playerid][5], 10.000000, 69.500000);
						Loop(i, 6, 3){
							PlayerTextDrawFont(playerid, SeleccionarPJ[playerid][i], 0);
							PlayerTextDrawSetOutline(playerid, SeleccionarPJ[playerid][i], 0);
							PlayerTextDrawSetShadow(playerid, SeleccionarPJ[playerid][i], 0);
							PlayerTextDrawAlignment(playerid, SeleccionarPJ[playerid][i], 2);
							PlayerTextDrawColor(playerid, SeleccionarPJ[playerid][i], -1);
							PlayerTextDrawBackgroundColor(playerid, SeleccionarPJ[playerid][i], 0);
							PlayerTextDrawBoxColor(playerid, SeleccionarPJ[playerid][i], -2127877121);
							PlayerTextDrawUseBox(playerid, SeleccionarPJ[playerid][i], 1);
							PlayerTextDrawSetProportional(playerid, SeleccionarPJ[playerid][i], 1);
							PlayerTextDrawSetSelectable(playerid, SeleccionarPJ[playerid][i], 1);
							PlayerTextDrawShow(playerid, SeleccionarPJ[playerid][i]);
						}
						SelectTextDraw(playerid, Color_Alerta);
						MirandoTextDraw[playerid] = CLICK_SELECTPJ;
					}
					else if(!row){
						MostrarDialog_Ok(playerid, d_Registro, 1);
					}
				}
			}
		}
	}
	return 1;
}
public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	switch(dialogid){
		case d_LoginEmail:{
			if(response){
				if(0<strlen(inputtext)<120){
					new query[150];
					EscribirCadena(InfoJugador[playerid][Email], inputtext);
					mysql_format(MySQL,query, sizeof(query),"SELECT * FROM `cuentas_email` WHERE `Email`='%e' LIMIT 1", InyectarCadena(inputtext));
					mysql_pquery(MySQL, query, "VerificarUsuario","dd", playerid, 0);
				}
				else MostrarDialog_Ok(playerid, d_LoginEmail, 0);
			}
			else{
				Mensaje_SV(playerid, "Gracias por visitarnos, que tenga buen día, hasta pronto.");
				Kick_PJ(playerid);
			}
		}
		case d_Registro:{
			switch(GetPVarInt(playerid, "PasoDialog")){
				case 0:{//Pedido de Contraseña
					if(response){
						if(5<strlen(inputtext)<50){
							EscribirCadena(InfoJugador[playerid][Contra], inputtext);
							MostrarDialog_Ok(playerid, d_TestRol, 0);
						}
						else{
							Mensaje_SV(playerid, "Solo aceptamos que el correo tenga entre 5 a 50 carácteres.");
							MostrarDialog_Ok(playerid, d_Registro, 0);
						}
					}
					else MostrarDialog_Ok(playerid, d_LoginEmail, 0);
				}
				case 1:{//Sexo
					if(response){
						switch(listitem){
							case 0: EscribirCadena(InfoJugador[playerid][Sexo],"Hombre");
							case 1: EscribirCadena(InfoJugador[playerid][Sexo],"Mujer");
						}
						MostrarDialog_Ok(playerid, d_Registro, 2);
					}
					else{
						Mensaje_SV(playerid, "Gracias por visitarnos, que tenga buen día, hasta pronto.");
						Kick_PJ(playerid);
					}
				}
				case 2:{//Procedencia
					if(response){
						switch(listitem){
							case 0:EscribirCadena(InfoJugador[playerid][Procedencia], "Los Santos");
							case 1:EscribirCadena(InfoJugador[playerid][Procedencia], "Las Venturas");
							case 2:EscribirCadena(InfoJugador[playerid][Procedencia], "San Fierro");
						}
						MostrarDialog_Ok(playerid, d_Registro, 3);
					}
					else MostrarDialog_Ok(playerid, d_Registro, 1);
				}
				case 3:{//Edad
					if(response){
						if(17<strval(inputtext)<99){
							InfoJugador[playerid][Edad] = strval(inputtext);
							MostrarDialog_Ok(playerid, d_Registro, 4);
						}
						else{
							Mensaje_SV(playerid, "Debes colocar una edad válido entre 18 a 99 años.");
							MostrarDialog_Ok(playerid, d_Registro, 3);
						}
					}
					else MostrarDialog_Ok(playerid, d_Registro, 2);
				}
				case 4:{//NombrePJ
					if(response){
						if(3<strlen(inputtext)<MAX_PLAYER_NAME){
							EscribirCadena(InfoJugador[playerid][Nombre], inputtext);
							new query[200];
							mysql_format(MySQL,query, sizeof(query),"SELECT * FROM `cuentas` WHERE `Nombre`='%e' LIMIT 1", InyectarCadena(InfoJugador[playerid][Nombre]));
							mysql_pquery(MySQL, query, "VerificarUsuario","dd", playerid, 2);
						}
						else{
							Mensaje_SV(playerid, "Debes colocar un nombre válido de 3 a 25 carácteres.");
							MostrarDialog_Ok(playerid, d_Registro, 4);
						}
					}
					else MostrarDialog_Ok(playerid, d_Registro, 3);
				}
			}
		}
		case d_TestRol:{
			new caso = GetPVarInt(playerid, "PasoDialog");
			if(response){
				switch(caso){
					case 0..9:{
						if(listitem == TestRol[caso][Respuesta])ResultadoTestRol[playerid]++;
						MostrarDialog_Ok(playerid, d_TestRol, caso+1);
					}
					case 10:{
						if(ResultadoTestRol[playerid]>=8){
							new query[200];
							mysql_format(MySQL,query, sizeof(query),"SELECT * FROM `cuentas_email` WHERE `Email`='%e' LIMIT 1", InyectarCadena(InfoJugador[playerid][Email]));
							mysql_pquery(MySQL, query, "VerificarUsuario","dd", playerid, 1);
						}
						else MostrarDialog_Ok(playerid, d_TestRol, 0);
						ResultadoTestRol[playerid]=0;
					}
				}
			}
			else{
				Mensaje_SV(playerid, "Gracias por visitarnos, que tenga buen día, hasta pronto.");
				Kick_PJ(playerid);
			}
		}
		case d_Ingreso:{
			switch(GetPVarInt(playerid, "PasoDialog")){
				case 0:{
					if(response){
						bcrypt_check(inputtext, InfoJugador[playerid][Contra], "OnPasswordChecked", "d", playerid);
					}
					else MostrarDialog_Ok(playerid, d_LoginEmail, 0);
				}
			}
		}
	}
	return 1;
}
CALLBACK: SacarIDMysql(caso, variable){
	switch(caso){
		case ID_Player: InfoJugador[variable][ID_Cuenta] = cache_insert_id();
	}
	return 1;
}
public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	return 1;
}
public OnPlayerClickTextDraw(playerid, Text:clickedid){
	if(clickedid == Text:INVALID_TEXT_DRAW){
		switch(MirandoTextDraw[playerid]){
			case CLICK_SELECTPJ:{
				Loop(i, 6, 0){
					PlayerTextDrawHide(playerid, SeleccionarPJ[playerid][i]);
					if(SeleccionarPJ[playerid][i]!=PlayerText:INVALID_TEXT_DRAW)
						PlayerTextDrawDestroy(playerid, SeleccionarPJ[playerid][i]);
					SeleccionarPJ[playerid][i]=PlayerText:INVALID_TEXT_DRAW;
				}
				MirandoTextDraw[playerid] = 0;
				CancelSelectTextDraw(playerid);
				Mensaje_SV(playerid, "Gracias por visitarnos, que tenga buen día, hasta pronto.");
				Kick_PJ(playerid);
			}
		}
	}
	return 0;
}
public OnPlayerClickPlayerTextDraw(playerid, PlayerText:playertextid){
	if(playertextid != PlayerText:INVALID_TEXT_DRAW){
		switch(MirandoTextDraw[playerid]){
			case CLICK_SELECTPJ:{
				if(playertextid == PlayerText:SeleccionarPJ[playerid][3]||playertextid == PlayerText:SeleccionarPJ[playerid][4]||
					playertextid == PlayerText:SeleccionarPJ[playerid][5]){
					if(playertextid == PlayerText:SeleccionarPJ[playerid][3]){
						if(IgualdadCadena(NombresPJ[playerid][0], "Crear personaje")) MostrarDialog_Ok(playerid, d_Registro, 1);
						else{
							MirandoTextDraw[playerid] = 0;
							new query[120];
							mysql_format(MySQL,query, sizeof(query), "SELECT * FROM `cuentas` WHERE `Nombre`='%e' LIMIT 1", InyectarCadena(NombresPJ[playerid][0]));
							mysql_pquery(MySQL, query, "CargarCuenta","d", playerid);
						}
					}
					else if(playertextid == PlayerText:SeleccionarPJ[playerid][4]){
						if(IgualdadCadena(NombresPJ[playerid][1], "Crear personaje")) MostrarDialog_Ok(playerid, d_Registro, 1);
						else{
							MirandoTextDraw[playerid] = 0;
							new query[120];
							mysql_format(MySQL,query, sizeof(query), "SELECT * FROM `cuentas` WHERE `Nombre`='%e' LIMIT 1", InyectarCadena(NombresPJ[playerid][1]));
							mysql_pquery(MySQL, query, "CargarCuenta","d", playerid);
						}
					}
					else if(playertextid == PlayerText:SeleccionarPJ[playerid][5]){
						if(IgualdadCadena(NombresPJ[playerid][2], "Crear personaje")) MostrarDialog_Ok(playerid, d_Registro, 1);
						else{
							MirandoTextDraw[playerid] = 0;
							new query[120];
							mysql_format(MySQL,query, sizeof(query), "SELECT * FROM `cuentas` WHERE `Nombre`='%e' LIMIT 1", InyectarCadena(NombresPJ[playerid][2]));
							mysql_pquery(MySQL, query, "CargarCuenta","d", playerid);
						}
					}
					Loop(i, 6, 0){
						PlayerTextDrawHide(playerid, SeleccionarPJ[playerid][i]);
						if(SeleccionarPJ[playerid][i]!=PlayerText:INVALID_TEXT_DRAW)
							PlayerTextDrawDestroy(playerid, SeleccionarPJ[playerid][i]);
						SeleccionarPJ[playerid][i]=PlayerText:INVALID_TEXT_DRAW;
					}
					return 1;
				}
			}
		}
	}
	return 0;
}