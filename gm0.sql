-- phpMyAdmin SQL Dump
-- version 4.8.4
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1:3306
-- Tiempo de generación: 19-09-2019 a las 05:39:50
-- Versión del servidor: 5.7.24
-- Versión de PHP: 7.2.14

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `gm0`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cuentas`
--

DROP TABLE IF EXISTS `cuentas`;
CREATE TABLE IF NOT EXISTS `cuentas` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `ID_Cuenta` int(11) NOT NULL,
  `Nombre` varchar(50) NOT NULL DEFAULT 'Nombre_Apellido',
  `Contra` varchar(255) NOT NULL DEFAULT '123456',
  `Edad` int(11) NOT NULL DEFAULT '18',
  `Procedencia` varchar(20) NOT NULL DEFAULT 'Los santos',
  `Posicion_X` float NOT NULL DEFAULT '1477.18',
  `Posicion_Y` float NOT NULL DEFAULT '-1740.34',
  `Posicion_Z` float NOT NULL DEFAULT '13.4678',
  `Ropa` int(11) NOT NULL DEFAULT '20',
  `Sexo` varchar(15) NOT NULL DEFAULT 'Hombre',
  UNIQUE KEY `ID` (`ID`),
  UNIQUE KEY `Nombre` (`Nombre`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `cuentas`
--

INSERT INTO `cuentas` (`ID`, `ID_Cuenta`, `Nombre`, `Contra`, `Edad`, `Procedencia`, `Posicion_X`, `Posicion_Y`, `Posicion_Z`, `Ropa`, `Sexo`) VALUES
(1, 1, 'Gary_Hadson', '123456', 25, 'Los Santos', 1541.56, -1671.06, 14.2187, 20, 'Hombre');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cuentas_email`
--

DROP TABLE IF EXISTS `cuentas_email`;
CREATE TABLE IF NOT EXISTS `cuentas_email` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Email` varchar(255) NOT NULL DEFAULT 'correo@gmail.com',
  `Contra` varchar(255) NOT NULL DEFAULT '123456',
  `TestRol` int(11) NOT NULL DEFAULT '0',
  `Logeado` int(11) NOT NULL DEFAULT '0',
  UNIQUE KEY `ID` (`ID`),
  UNIQUE KEY `Email` (`Email`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `cuentas_email`
--

INSERT INTO `cuentas_email` (`ID`, `Email`, `Contra`, `TestRol`, `Logeado`) VALUES
(1, 'kratoz@gmail.com', '$2y$12$Pze2XznPPVLtXCXPTknuSuXkAysBUWujlC4rplnCCXe4pixVuwOte', 0, 0);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
