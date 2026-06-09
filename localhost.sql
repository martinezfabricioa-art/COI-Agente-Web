-- phpMyAdmin SQL Dump
-- version 4.9.11
-- https://www.phpmyadmin.net/
--
-- Servidor: localhost
-- Tiempo de generación: 07-04-2026 a las 12:54:36
-- Versión del servidor: 5.7.44-log
-- Versión de PHP: 7.4.33

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;


--
-- Estructura de tabla para la tabla `agenda`
--

CREATE TABLE `agenda` (
  `id` bigint(20) NOT NULL,
  `dia` varchar(50) NOT NULL,
  `horaDesde` time NOT NULL,
  `horaHasta` time NOT NULL,
  `idProfesional` bigint(20) NOT NULL,
  `duracion` int(20) NOT NULL,
  `tipo` varchar(20) NOT NULL,
  `cantidad` int(11) DEFAULT NULL,
  `lunes` int(11) DEFAULT NULL,
  `martes` int(11) DEFAULT NULL,
  `miercoles` int(11) DEFAULT NULL,
  `jueves` int(11) DEFAULT NULL,
  `viernes` int(11) DEFAULT NULL,
  `sabado` int(11) DEFAULT NULL,
  `tipoagenda` varchar(10) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `agendaweb`
--

CREATE TABLE `agendaweb` (
  `id` bigint(20) NOT NULL,
  `dia` varchar(50) NOT NULL,
  `horaDesde` time NOT NULL,
  `horaHasta` time NOT NULL,
  `idProfesional` bigint(20) NOT NULL,
  `duracion` int(20) NOT NULL,
  `tipo` varchar(20) NOT NULL,
  `cantidad` int(11) DEFAULT NULL,
  `lunes` int(11) DEFAULT NULL,
  `martes` int(11) DEFAULT NULL,
  `miercoles` int(11) DEFAULT NULL,
  `jueves` int(11) DEFAULT NULL,
  `viernes` int(11) DEFAULT NULL,
  `sabado` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------



--
-- Estructura de tabla para la tabla `especialidad`
--

CREATE TABLE `especialidad` (
  `id` bigint(20) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `detalle` varchar(300) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `estado`
--

CREATE TABLE `estado` (
  `id` bigint(20) NOT NULL,
  `nombre` char(255) NOT NULL,
  `tipo` char(250) NOT NULL,
  `activo` char(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `feriado`
--

CREATE TABLE `feriado` (
  `id` bigint(20) NOT NULL,
  `fecha` date NOT NULL,
  `descripcion` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------



CREATE TABLE `obra_social` (
  `id` bigint(20) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `detalle` varchar(300) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `paciente`
--

CREATE TABLE `paciente` (
  `id` bigint(20) NOT NULL,
  `nombre` char(200) NOT NULL,
  `direccion` varchar(255) NOT NULL,
  `telefono` varchar(30) DEFAULT NULL,
  `mail` varchar(50) DEFAULT NULL,
  `idTipoDni` int(11) NOT NULL,
  `dni` varchar(10) NOT NULL,
  `idLocalidad` bigint(20) NOT NULL,
  `idObraSocial` bigint(20) NOT NULL,
  `nacimiento` date NOT NULL,
  `afiliado` varchar(50) NOT NULL,
  `sexo` char(1) NOT NULL,
  `idUsuario` bigint(20) NOT NULL,
  `plan` varchar(200) DEFAULT NULL,
  `idEstado` bigint(20) DEFAULT NULL,
  `obs` text CHARACTER SET utf8,
  `usr` varchar(50) DEFAULT NULL,
  `fAlta` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `practica`
--

CREATE TABLE `practica` (
  `id` bigint(20) NOT NULL,
  `detalle` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `profesional`
--

CREATE TABLE `profesional` (
  `id` bigint(20) NOT NULL,
  `nombre` char(200) NOT NULL,
  `telefono` varchar(30) NOT NULL,
  `idEspecialidad` bigint(20) NOT NULL,
  `idCentro` bigint(20) NOT NULL,
  `idEstado` bigint(20) NOT NULL,
  `nota` varchar(200) DEFAULT NULL,
  `idUsuario` bigint(20) NOT NULL,
  `nro_dni` int(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------


--
-- Estructura de tabla para la tabla `tipo_documento`
--

CREATE TABLE `tipo_documento` (
  `id` bigint(20) NOT NULL,
  `tipo` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `turno`
--

CREATE TABLE `turno` (
  `id` bigint(20) NOT NULL,
  `fecha` date NOT NULL,
  `hora` time NOT NULL,
  `idProfesional` bigint(20) NOT NULL,
  `idPaciente` bigint(20) NOT NULL,
  `idEstado` bigint(20) NOT NULL,
  `tipo` varchar(50) DEFAULT NULL,
  `orden` int(11) DEFAULT NULL,
  `nota` varchar(200) DEFAULT NULL,
  `cobro` double(10,2) DEFAULT '0.00',
  `origen` varchar(10) DEFAULT NULL,
  `usera` varchar(100) DEFAULT NULL,
  `userr` varchar(100) DEFAULT NULL,
  `fechaAlta` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `para` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------



--
-- Estructura de tabla para la tabla `usuari`
--

CREATE TABLE `usuari` (
  `USUARI_IDUSER` int(10) NOT NULL,
  `USUARI_NOMBRE` varchar(150) NOT NULL,
  `USUARI_UEMAIL` text,
  `USUARI_TELEFO` varchar(30) DEFAULT NULL,
  `USUARI_PASSWO` text,
  `USUARI_NROROL` int(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `agenda`
--
ALTER TABLE `agenda`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `agendaweb`
--
ALTER TABLE `agendaweb`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `empresa`
--
ALTER TABLE `empresa`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `UQ_Empresa_id` (`id`),
  ADD UNIQUE KEY `unico_empresa` (`nombre`);

--
-- Indices de la tabla `especialidad`
--
ALTER TABLE `especialidad`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unico_especialidad` (`nombre`);

--
-- Indices de la tabla `estado`
--
ALTER TABLE `estado`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `UQ_Estado_id` (`id`),
  ADD UNIQUE KEY `unico_estado` (`nombre`,`tipo`);

--
-- Indices de la tabla `feriado`
--
ALTER TABLE `feriado`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `fecha` (`fecha`,`descripcion`);

--
-- Indices de la tabla `historia_clinica`
--
ALTER TABLE `historia_clinica`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idPaciente` (`idPaciente`,`idProfesional`),
  ADD KEY `profesional` (`idProfesional`),
  ADD KEY `patologia` (`patologia`,`cirugia`);

--
-- Indices de la tabla `historia_clinica_historial`
--
ALTER TABLE `historia_clinica_historial`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idPaciente` (`idPaciente`,`idProfesional`),
  ADD KEY `profesional` (`idProfesional`),
  ADD KEY `FK_hist_clinica` (`idHistoriaClinica`);

--
-- Indices de la tabla `horario`
--
ALTER TABLE `horario`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `localidad`
--
ALTER TABLE `localidad`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `UQ_Localidad_id` (`id`);

--
-- Indices de la tabla `obra_social`
--
ALTER TABLE `obra_social`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `paciente`
--
ALTER TABLE `paciente`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `UQ_Cliente_id` (`id`),
  ADD UNIQUE KEY `dni` (`dni`),
  ADD UNIQUE KEY `unico_paciente` (`dni`),
  ADD KEY `obra_social` (`idObraSocial`),
  ADD KEY `estado` (`idEstado`);

--
-- Indices de la tabla `practica`
--
ALTER TABLE `practica`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `profesional`
--
ALTER TABLE `profesional`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `UQ_Cliente_id` (`id`),
  ADD KEY `idEspecialidad` (`idEspecialidad`),
  ADD KEY `idCentro` (`idCentro`),
  ADD KEY `idUsuario` (`idUsuario`);

--
-- Indices de la tabla `roacse`
--
ALTER TABLE `roacse`
  ADD PRIMARY KEY (`ROACSE_NROROL`,`ROACSE_NROSEC`,`ROACSE_NROACC`),
  ADD KEY `ROACSE_NROACC` (`ROACSE_NROACC`),
  ADD KEY `ROACSE_NROROL` (`ROACSE_NROROL`),
  ADD KEY `ROACSE_NROSEC` (`ROACSE_NROSEC`);

--
-- Indices de la tabla `seccio`
--
ALTER TABLE `seccio`
  ADD PRIMARY KEY (`SECCIO_NROSEC`),
  ADD KEY `SECCIO_PARENT` (`SECCIO_PARENT`);

--
-- Indices de la tabla `tabrol`
--
ALTER TABLE `tabrol`
  ADD PRIMARY KEY (`TABROL_NROROL`);

--
-- Indices de la tabla `tacces`
--
ALTER TABLE `tacces`
  ADD PRIMARY KEY (`TACCES_NROACC`);

--
-- Indices de la tabla `tamenu`
--
ALTER TABLE `tamenu`
  ADD PRIMARY KEY (`TAMENU_NROMEN`),
  ADD KEY `TAMENU_NROSEC` (`TAMENU_NROSEC`);

--
-- Indices de la tabla `tipo_documento`
--
ALTER TABLE `tipo_documento`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unico_tipodocumento` (`tipo`);

--
-- Indices de la tabla `turno`
--
ALTER TABLE `turno`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unicot` (`hora`,`fecha`,`idProfesional`),
  ADD KEY `idProfesional` (`idProfesional`),
  ADD KEY `idEstado` (`idEstado`),
  ADD KEY `idPaciente` (`idPaciente`);

--
-- Indices de la tabla `usuari`
--
ALTER TABLE `usuari`
  ADD PRIMARY KEY (`USUARI_IDUSER`),
  ADD UNIQUE KEY `UK_usuario` (`USUARI_NOMBRE`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `agenda`
--
ALTER TABLE `agenda`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `agendaweb`
--
ALTER TABLE `agendaweb`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `empresa`
--
ALTER TABLE `empresa`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `especialidad`
--
ALTER TABLE `especialidad`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `estado`
--
ALTER TABLE `estado`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `feriado`
--
ALTER TABLE `feriado`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `historia_clinica`
--
ALTER TABLE `historia_clinica`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `historia_clinica_historial`
--
ALTER TABLE `historia_clinica_historial`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `horario`
--
ALTER TABLE `horario`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `localidad`
--
ALTER TABLE `localidad`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `obra_social`
--
ALTER TABLE `obra_social`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `paciente`
--
ALTER TABLE `paciente`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `practica`
--
ALTER TABLE `practica`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `profesional`
--
ALTER TABLE `profesional`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `seccio`
--
ALTER TABLE `seccio`
  MODIFY `SECCIO_NROSEC` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `tabrol`
--
ALTER TABLE `tabrol`
  MODIFY `TABROL_NROROL` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `tacces`
--
ALTER TABLE `tacces`
  MODIFY `TACCES_NROACC` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `tipo_documento`
--
ALTER TABLE `tipo_documento`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `turno`
--
ALTER TABLE `turno`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `usuari`
--
ALTER TABLE `usuari`
  MODIFY `USUARI_IDUSER` int(10) NOT NULL AUTO_INCREMENT;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `paciente`
--
ALTER TABLE `paciente`
  ADD CONSTRAINT `fk_os` FOREIGN KEY (`idObraSocial`) REFERENCES `obra_social` (`id`);

--
-- Filtros para la tabla `profesional`
--
ALTER TABLE `profesional`
  ADD CONSTRAINT `profesional_ibfk_1` FOREIGN KEY (`idEspecialidad`) REFERENCES `especialidad` (`id`);

--
-- Filtros para la tabla `turno`
--
ALTER TABLE `turno`
  ADD CONSTRAINT `turno_ibfk_1` FOREIGN KEY (`idProfesional`) REFERENCES `profesional` (`id`),
  ADD CONSTRAINT `turno_ibfk_3` FOREIGN KEY (`idEstado`) REFERENCES `estado` (`id`);
COMMIT;

