# okplayers-Base-publica
Te vengo a traer una gamemode desarrollado desde 0 para el aprendizaje de la comunidad de SA:MP, en vista de que ya estoy por retirarme he decidido brindar UPDATE seguidos de esta gamemode iremos agregándole sistemas, funciones y comandos. Logicamente este proyecto continuará actualizándose siempre y cuanto tenga el apoyo correspondiente por parte de la comunidad, de caso contrario dejaré de subir actualizaciones del gamemode. Planeo programar un servidor de la modalidad del roleplay conjunto con ustedes, solo pediré encarecidamente respetar todos los créditos a este servidor, mi objetivo de desarrollar y compartir con ustedes es con buenas intenciones.  
Utilizando:
1) Bcrypt v2.2.3: https://github.com/lassir/bcrypt-samp/releases
2) YSI 5.1: https://github.com/pawn-lang/YSI-Includes/releases
3) izcmd: https://github.com/YashasSamaga/I-ZCMD
4) sscanf 2.8.3: https://github.com/maddinat0r/sscanf/releases
5) Streamer Plugin v2.9.4: https://github.com/samp-incognito/samp-streamer-plugin/releases/tag/v2.9.4
6) Mysql 41-4: https://github.com/pBlueG/SA-MP-MySQL/releases.

Instalación:
1) Descargar la gamemode, agregar las carpetas faltante.
2) Colocar la base de datos MySQL con el nombre gm0.
3) Configurar sus datos SQL desde la carpeta \pawno\include\kratoz\definiciones.inc.

Versión 0.0.1: 19/09/2019.
- Sistema de login + registro.
- 10 preguntas como test de rol.
- Configuración de Gamemode para el uso de MySQL.
- Registro mediante correo, almacenando 3 personajes por cuenta.
- Animación de acuerdo a la cantidad de texto hablado ingame.
- Agregado comando /creditos.
- Agregado el encriptado para seguridad de contraseñas "bcrypt".
