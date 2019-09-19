enum _pj{
	ID,
	ID_Cuenta,
	Email[120],
	Nombre[MAX_PLAYER_NAME],
	Contra[50],
	Ropa,
	Float:Posicion_X,
	Float:Posicion_Y,
	Float:Posicion_Z,
	Sexo[12],//cadena en el texto
	Procedencia[12],//0LS 1LV 2SF
	Edad
};
new 
	InfoJugador[MAX_PLAYERS][_pj],
	Intentos[MAX_PLAYERS],
	Ingreso[MAX_PLAYERS],
	ResultadoTestRol[MAX_PLAYERS];
CALLBACK:VerificarUsuario(playerid, caso){
	/*
		Leyenda de "caso"
		0 = Verifica si el jugador está inscrito oficialmente el la base de datos
		1 = Verifica por segunda vez si está inscrito en la base de datos para iniciar una creación de esa tabla
	*/
	new row = cache_num_rows();
	if(!row){
		switch(caso){
			case 0:{//Verificacion si está o no inscrito en el servidor
				MostrarDialog_Ok(playerid, d_Registro, 0);//Mandarlo a registrarte
			}
			case 1:{//Verifica por segunda vez si está inscrito en la base de datos para iniciar una creación de esa tabla
				bcrypt_hash(InfoJugador[playerid][Contra], BCRYPT_COST, "OnPasswordHashed", "d", playerid);
			}
			case 2:{//Verifica por primera vez si está inscrito en la base de datos para iniciar una creación de esa tabla PJ
				new query[300];
				mysql_format(MySQL,query, sizeof(query), "INSERT INTO `cuentas`(`Nombre`,`ID_Cuenta`,`Edad`,`Procedencia`,`Sexo`) \
					VALUES ('%e','%d','%d','%s','%s')",
					InyectarCadena(InfoJugador[playerid][Nombre]),
					InfoJugador[playerid][ID_Cuenta],
					InfoJugador[playerid][Edad],
					InfoJugador[playerid][Procedencia],
					InfoJugador[playerid][Sexo]);
				mysql_query(MySQL, query);

				SetSpawnInfo(playerid, 0, InfoJugador[playerid][Ropa], Punto_Spawn, 180, 0, 0, 0, 0, 0, 0);
				Ingreso[playerid] = 1;
				SpawnPlayer(playerid);
				//MostrarDialog_Ok(playerid, d_Ingreso, 0);
			}
		}
	}
	else{
		switch(caso){
			case 0:{//Verificacion si está o no inscrito en el servidor
				new contenido[200];
				cache_get_value_name(0, "Contra", contenido); EscribirCadena(InfoJugador[playerid][Contra], contenido);
				cache_get_value_int(0, "ID", InfoJugador[playerid][ID_Cuenta]);
				MostrarDialog_Ok(playerid, d_Ingreso, 0);//Mandamos a logear
			}
			case 1:{
				MostrarDialog_Ok(playerid, d_LoginEmail, 0);
				Mensaje_SV(playerid, "El correo ya se encuentra registrado, vuelva a colocar un correo único.");
			}
			case 2:{
				Mensaje_SV(playerid, "El Nombre_Apellido ya se encuentra registrado, intenta con otro nombre.");
				MostrarDialog(playerid, d_Registro, DIALOG_STYLE_INPUT, "Registro-Nombre", "¿Cual es el Nombre_Apellido para su personaje?", "Crear", "Salir");
			}
		}
	}
	return 1;
}

CALLBACK:CargarCuenta(playerid){
	new Rows, contenido[120];
	Rows = cache_num_rows();
	if(Rows){
		cache_get_value_int(0, "ID", InfoJugador[playerid][ID]);
		cache_get_value_name(0, "Nombre", contenido); EscribirCadena(InfoJugador[playerid][Nombre], contenido);
		SetPlayerName(playerid, contenido);
		cache_get_value_name(0, "Procedencia", contenido); EscribirCadena(InfoJugador[playerid][Procedencia], contenido);
		cache_get_value_name(0, "Sexo", contenido); EscribirCadena(InfoJugador[playerid][Sexo], contenido);
		
		cache_get_value_int(0, "ID_Cuenta", InfoJugador[playerid][ID_Cuenta]);
		cache_get_value_int(0, "Edad", InfoJugador[playerid][Edad]);
		cache_get_value_int(0, "Ropa", InfoJugador[playerid][Ropa]);
		cache_get_value_float(0, "Posicion_X", InfoJugador[playerid][Posicion_X]);
		cache_get_value_float(0, "Posicion_Y", InfoJugador[playerid][Posicion_Y]);
		cache_get_value_float(0, "Posicion_Z", InfoJugador[playerid][Posicion_Z]);

		SetSpawnInfo(playerid, 0, InfoJugador[playerid][Ropa], InfoJugador[playerid][Posicion_X],InfoJugador[playerid][Posicion_Y],InfoJugador[playerid][Posicion_Z], 180, 0, 0, 0, 0, 0, 0);
		Ingreso[playerid] = 1;

		MirandoTextDraw[playerid] = 0;
		CancelSelectTextDraw(playerid);
		SpawnPlayer(playerid);
	}
	else{
		MostrarDialog_Ok(playerid, d_Ingreso, 0);
		Mensaje_SV(playerid, "Algo salió mal, vuelve a logear por favor.");
	}
	return 1;
}
stock ResetVariablePJ(playerid, bool:ignorar = true){
	EscribirCadena(NombresPJ[playerid][0],"Crear personaje");
	EscribirCadena(NombresPJ[playerid][1],"Crear personaje");
	EscribirCadena(NombresPJ[playerid][2],"Crear personaje");
	InfoJugador[playerid][ID] = 0;
	InfoJugador[playerid][ID_Cuenta] = 0;
	InfoJugador[playerid][Ropa] = 0;
	InfoJugador[playerid][Posicion_X] = 0;
	InfoJugador[playerid][Posicion_Y] = 0;
	InfoJugador[playerid][Posicion_Z] = 0;
	InfoJugador[playerid][Sexo] = 0;
	InfoJugador[playerid][Procedencia] = 0;
	InfoJugador[playerid][Edad] = 0;
	Ingreso[playerid] = 0;
	if(ignorar==false){
		Loop(n, 6, 0){
			if(SeleccionarPJ[playerid][n] != PlayerText:INVALID_TEXT_DRAW)
				PlayerTextDrawDestroy(playerid, SeleccionarPJ[playerid][n]);
			SeleccionarPJ[playerid][n]=PlayerText:INVALID_TEXT_DRAW;
		}
	}
	Loop(i,MAX_TIMERPJ,0){
		if(TimerPlayer[playerid][i]!=INVALID_TIMER) KillTimerEx(playerid, i);//matamos los timer para pj
	}
	return 1;
}

//Encriptar contraseñas
public OnPasswordHashed(playerid)
{
	new query[300];
	new hash[BCRYPT_HASH_LENGTH];
	bcrypt_get_hash(hash);

	mysql_format(MySQL,query, sizeof(query), "INSERT INTO `cuentas_email`(`Email`,`Contra`) \
		VALUES ('%e','%s')",
		InyectarCadena(InfoJugador[playerid][Email]),
		hash);
	mysql_tquery(MySQL, query, "SacarIDMysql", "ii", ID_Player, playerid);
	MostrarDialog_Ok(playerid, d_Registro, 1);
	return 1;
}
public OnPasswordChecked(playerid)
{
	new bool:match = bcrypt_is_equal();
	if(match == true){
		MostrarDialog_Ok(playerid, d_Ingreso, 1);
	}
	else{
		if(Intentos[playerid]<=2){
			MostrarDialog_Ok(playerid, d_Ingreso, 0);
			Mensaje_SV(playerid, "Contraseña erronea, solo tiene 3 intentos, luego será kickeado.");
			Intentos[playerid]++;
		}
		else{
			Mensaje_SV(playerid, "Contraseña erronea, fuiste kickeado del servidor.");
			Kick_PJ(playerid);
		}
	}
	return 1;
}