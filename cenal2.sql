-- phpMyAdmin SQL Dump
-- version 4.7.4
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1:3306
-- Tiempo de generación: 15-12-2017 a las 16:42:57
-- Versión del servidor: 5.7.19
-- Versión de PHP: 7.1.9

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `cenal2`
--

DELIMITER $$
--
-- Procedimientos
--
DROP PROCEDURE IF EXISTS `crearTarifas`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `crearTarifas` (IN `inscripcion` INT, IN `matricula` INT, IN `estampilla` INT, IN `cuota_inicial` INT, IN `duracion` INT, IN `jornada_id` INT, IN `sede_id` INT, IN `programa_id` INT)  BEGIN
	
	INSERT INTO tarifas
VALUES
	(
		inscripcion,
		matricula,
		estampilla,
		cuota_inicial,
		duracion,
		jornada_id,
		sede_id,
		programa_id
	) ;
END$$

DROP PROCEDURE IF EXISTS `getAllBecas`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getAllBecas` ()  BEGIN
SELECT
a.id,
a.descripcion,
a.sede_id,
b.nombre
FROM
becas AS a
INNER JOIN sede AS b ON a.sede_id = b.id
WHERE a.deleted_at IS NULL
AND b.deleted_at IS NULL;
END$$

DROP PROCEDURE IF EXISTS `getAllCiudades`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getAllCiudades` ()  BEGIN
SELECT
a.id,
a.ciudad,
a.departamento_id,
b.descripcion
FROM
ciudad AS a
INNER JOIN departamento AS b ON a.departamento_id = b.id
WHERE
a.deleted_at IS NULL AND
b.deleted_at IS NULL;
END$$

DROP PROCEDURE IF EXISTS `getAllConceptoGasto`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getAllConceptoGasto` (IN `valor` INT(1))  BEGIN
IF valor = 0 THEN
SELECT
a.id,
a.descripcion,
a.requiere_programa,
a.concepto_pago,
  CASE a.concepto_pago
  WHEN '1' THEN 'Gasto'
  WHEN '2' THEN 'Ingreso'
  WHEN '3' THEN 'Gasto e Ingreso'
  ELSE a.concepto_pago
  END as concepto
FROM
concepto as a
WHERE
a.deleted_at IS NULL
AND a.is_factura = 1;
ELSE
SELECT
a.id,
a.descripcion,
a.requiere_programa,
a.concepto_pago,
  CASE a.concepto_pago
  WHEN '1' THEN 'Gasto'
  WHEN '2' THEN 'Ingreso'
  WHEN '3' THEN 'Gasto e Ingreso'
  ELSE a.concepto_pago
  END as concepto
FROM
concepto as a
WHERE
a.concepto_pago = valor OR a.concepto_pago = '3' AND
a.deleted_at IS NULL
AND a.is_factura = 1;
END IF;
END$$

DROP PROCEDURE IF EXISTS `getAllConceptos`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getAllConceptos` ()  SELECT *
FROM concepto
WHERE
concepto.is_factura = 0 AND
concepto.deleted_at IS NULL$$

DROP PROCEDURE IF EXISTS `getAllCuadre`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getAllCuadre` ()  NO SQL
SELECT
a.id,
a.consecutivo,
a.usuario_id_cuadre,
(SELECT b.user_name FROM usuario AS b WHERE b.id = a.usuario_id_cuadre) AS nom_usuario_cuadre,
a.usuario_id_creador,
(SELECT b.user_name FROM usuario AS b WHERE b.id = a.usuario_id_creador) AS nom_usuario_creador,
IFNULL((SELECT
Sum(detalle_ingresos.neto) AS total_ingresos
FROM
detalle_ingresos
WHERE
detalle_ingresos.cuadre_id = a.id AND
detalle_ingresos.deleted_at IS NULL),0) AS total_ingreso,
IFNULL((SELECT
Sum(detalle_egresos.valor) AS total_egresos
FROM
detalle_egresos
WHERE
detalle_egresos.cuadre_id = a.id AND
detalle_egresos.deleted_at IS NULL),0) AS total_egreso,
a.sede_id,
DATE_FORMAT(a.created_at, '%d-%m-%Y') as created_at,
c.nombre AS nom_sede
FROM
cuadre AS a
INNER JOIN sede AS c ON a.sede_id = c.id
WHERE
a.deleted_at IS NULL$$

DROP PROCEDURE IF EXISTS `getAllDetalleEgreso`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getAllDetalleEgreso` ()  NO SQL
SELECT
a.id,
a.fecha,
a.tercero,
a.valor,
a.created_at,
a.cuadre_id,
a.gastos_detalles_id
FROM
detalle_egresos AS a
WHERE
a.deleted_at IS NULL$$

DROP PROCEDURE IF EXISTS `getAllDetalleIngreso`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getAllDetalleIngreso` ()  NO SQL
SELECT
a.id,
a.fecha,
a.estudiante_tercero,
a.sede,
a.desto,
a.valor,
a.neto,
a.created_at,
a.cuadre_id,
a.recibo_caja_detalle_id
FROM
detalle_ingresos AS a
WHERE
a.deleted_at IS NULL$$

DROP PROCEDURE IF EXISTS `getAllIdentificacion`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getAllIdentificacion` ()  BEGIN
SELECT * FROM identificacion;
END$$

DROP PROCEDURE IF EXISTS `getAllPatrocinador`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getAllPatrocinador` (IN `id_estudiante` INT)  NO SQL
SELECT nit,nombre,direccion,telefono,id_estudiante FROM patrocinador WHERE id_estudiante = id_estudiante$$

DROP PROCEDURE IF EXISTS `getAllProveedores`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getAllProveedores` ()  BEGIN
SELECT
a.id,
a.sede_id,
a.nombres,
a.apellidos,
b.nombre
FROM
proveedores AS a
INNER JOIN sede AS b ON a.sede_id = b.id
WHERE
a.deleted_at IS NULL AND
b.deleted_at IS NULL;
END$$

DROP PROCEDURE IF EXISTS `getAllTarifas`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getAllTarifas` ()  NO SQL
SELECT
a.inscripcion,
a.id,
a.matricula,
a.estampilla,
a.cuota_inicial,
a.duracion,
d.jornada,
c.nombre,
b.programa,
a.jornada_id,
a.sede_id,
a.programa_id
FROM
tarifas AS a
INNER JOIN programas AS b ON b.id = a.programa_id
INNER JOIN sede AS c ON c.id = a.sede_id
INNER JOIN jornadas AS d ON d.id = a.jornada_id$$

DROP PROCEDURE IF EXISTS `getAllUsuarios`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getAllUsuarios` ()  NO SQL
SELECT
a.id,
a.user_name,
a.`password`,
a.actived,
a.credencial_id,
a.sede_id,
b.nombre AS sede,
c.nombre AS credencial,
CASE a.actived
  WHEN true THEN '<i class="fa fa-check text-navy"></i>'
  ELSE '<i class="fa fa-times text-danger"></i>'
  END as estado
FROM
usuario AS a
INNER JOIN sede AS b ON a.sede_id = b.id
INNER JOIN credencial AS c ON a.credencial_id = c.id
WHERE
a.deleted_at IS NULL AND
b.deleted_at IS NULL AND
c.deleted_at IS NULL$$

DROP PROCEDURE IF EXISTS `getCarteraByIdEstudiante`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getCarteraByIdEstudiante` (IN `id_estu` INT(11))  NO SQL
SELECT
factura.id,
factura.estudiante_id,
detalle_factura.fecha_inicio,
detalle_factura.cuota,
detalle_factura.saldo_vencido,
DATEDIFF(NOW(),(detalle_factura.fecha_inicio)) AS Dias,
estudiante.consecutivo
FROM
factura
INNER JOIN detalle_factura ON detalle_factura.factura_id = factura.id
INNER JOIN estudiante ON factura.estudiante_id = estudiante.id
WHERE
factura.estudiante_id = id_estu
AND detalle_factura.saldo_vencido > 0$$

DROP PROCEDURE IF EXISTS `getConceptoById`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getConceptoById` (IN `id_con` INT(5))  BEGIN
SELECT * FROM concepto
WHERE id = id_con;
END$$

DROP PROCEDURE IF EXISTS `getconceptosSinFactura`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getconceptosSinFactura` ()  NO SQL
SELECT
a.id,
a.descripcion
FROM
concepto AS a
WHERE
a.deleted_at IS NULL AND
a.sin_factura = 1$$

DROP PROCEDURE IF EXISTS `getCuadreById`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getCuadreById` (IN `id_cuadre` INT)  NO SQL
SELECT
a.id,
a.ing_descripcion,
a.ing_valor,
a.eg_descripcion,
a.eg_valor,
a.consecutivo,
a.usuario_id_cuadre,
(SELECT b.user_name FROM usuario AS b WHERE b.id = a.usuario_id_cuadre) AS nom_usuario_cuadre,
a.usuario_id_creador,
(SELECT b.user_name FROM usuario AS b WHERE b.id = a.usuario_id_creador) AS nom_usuario_creador,
a.total_ingreso,
a.total_egreso,
a.sede_id,
DATE_FORMAT(a.created_at, '%d-%m-%Y') as created_at,
c.nombre AS nom_sede
FROM
cuadre AS a
INNER JOIN sede AS c ON a.sede_id = c.id
WHERE
a.id = id_cuadre AND 
a.deleted_at IS NULL$$

DROP PROCEDURE IF EXISTS `getCuadreDetalleByIdCuadre`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getCuadreDetalleByIdCuadre` (IN `id_cuadre` INT(11), IN `valor` INT(11))  NO SQL
BEGIN
IF valor = 0 THEN
SELECT
b.observacion,
b.concepto_id,
c.descripcion,
b.valor
FROM
recibo_caja_detalle AS b
LEFT OUTER JOIN concepto AS c ON c.id = b.concepto_id
WHERE
b.recibo_caja_id = id_cuadre AND
b.deleted_at IS NULL AND
c.deleted_at IS NULL;
ELSE 
SELECT
b.observacion,
a.valor,
b.concepto_id,
c.descripcion
FROM
detalle_ingresos AS a
INNER JOIN recibo_caja_detalle AS b ON b.id = a.recibo_caja_detalle_id
INNER JOIN concepto AS c ON c.id = b.concepto_id
WHERE
b.recibo_caja_id = id_cuadre AND
a.deleted_at IS NULL AND
b.deleted_at IS NULL AND
c.deleted_at IS NULL;
END IF;
END$$

DROP PROCEDURE IF EXISTS `getCuadreDetalleEgresoByIdCuadre`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getCuadreDetalleEgresoByIdCuadre` (IN `id_cuadre` INT(11))  NO SQL
SELECT
a.valor,
a.cuadre_id,
b.gasto_id,
b.valor,
c.id AS id_programa,
d.id AS id_concepto,
d.descripcion AS nom_concepto,
DATE_FORMAT(b.created_at, '%d-%m-%Y') AS fecha,
CONCAT_WS(' ',f.nombres,f.apellidos) AS tercero,
CASE WHEN c.id = 0 
       THEN b.observacion
       ELSE c.programa
END AS descripcion 
FROM
detalle_egresos AS a
INNER JOIN gastos_detalles AS b ON b.id = a.gastos_detalles_id
INNER JOIN programas AS c ON c.id = b.programas_id
INNER JOIN concepto AS d ON d.id = b.concepto_id
INNER JOIN gastos AS e ON e.id = b.gasto_id
INNER JOIN proveedores AS f ON e.proveedores_id = f.id
WHERE
a.cuadre_id = id_cuadre AND
a.deleted_at IS NULL AND
b.deleted_at IS NULL AND
c.deleted_at IS NULL AND
d.deleted_at IS NULL AND
e.deleted_at IS NULL AND
f.deleted_at IS NULL$$

DROP PROCEDURE IF EXISTS `getCuadreDetalleIngresoByIdCuadre`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getCuadreDetalleIngresoByIdCuadre` (IN `id_cuadre` INT(11))  NO SQL
SELECT
	a.cuadre_id,
	a.recibo_caja_detalle_id AS recibo_caja_id,
	SUM(a.valor) AS valor,
	DATE_FORMAT(b.created_at, '%d-%m-%Y') AS created_at,
	b.descuento,
	(SUM(a.valor) - b.descuento) AS neto,
	CASE
WHEN g.nombres IS NOT NULL THEN
	CONCAT_WS(
		' ',
		g.nombres,
		g.primer_apellido,
		g.segundo_apellido
	)
ELSE
	CONCAT_WS(' ', h.nombres, h.apellidos)
END AS nombre
FROM
	detalle_ingresos AS a
INNER JOIN recibo_caja AS b ON b.id = a.recibo_caja_detalle_id
LEFT OUTER JOIN recibo_caja_pivot_estudiante AS e ON e.recibo_caja_id = b.id
LEFT OUTER JOIN recibo_caja_pivot_proveedores AS f ON f.recibo_caja_id = b.id
LEFT OUTER JOIN estudiante AS g ON e.estudiante_id = g.id
LEFT OUTER JOIN proveedores AS h ON h.id = f.proveedores_id
WHERE
	a.cuadre_id = id_cuadre
AND a.deleted_at IS NULL
AND b.deleted_at IS NULL
GROUP BY
	b.id,
    g.nombres,
    g.primer_apellido,
    g.segundo_apellido,
    h.nombres,
    h.apellidos$$

DROP PROCEDURE IF EXISTS `getDataEstudianteById`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getDataEstudianteById` (IN `id_estudiante` INT(11))  NO SQL
SELECT
a.id,
CONCAT_WS(' ',
a.nombres,
a.primer_apellido,
a.segundo_apellido
) AS nombre,
a.consecutivo,
a.sede_id,
b.nombre AS sede,
a.jornadas_id,
a.programas_id,
c.jornada,
d.programa
FROM
estudiante AS a
INNER JOIN sede AS b ON b.id = a.sede_id
INNER JOIN jornadas AS c ON c.id = a.jornadas_id
INNER JOIN programas AS d ON d.id = a.programas_id
WHERE
a.id = id_estudiante$$

DROP PROCEDURE IF EXISTS `getDetalleIngresoByIdUser`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getDetalleIngresoByIdUser` (IN `id_user` INT(11), IN `fecha` VARCHAR(20))  NO SQL
SELECT
a.recibo_caja_id,
Sum(a.saldo) As saldo,
Sum(a.valor)AS valor,
(sum(a.valor) - b.descuento) AS neto,
a.deleted_at,
DATE_FORMAT(a.created_at, '%Y-%m-%d') as created_at,
b.impresion_cuadre,
b.consecutivo AS consecutivo,
b.descuento AS descuento,
e.id AS id_estudiante,
e.nombres AS nom_estudiante,
e.primer_apellido AS ape1_estudiante,
e.segundo_apellido AS ape2_estudiante,
f.nombres AS nom_prov,
f.apellidos AS ape_prov,
sede.nombre AS nom_sede
FROM
recibo_caja_detalle AS a
INNER JOIN recibo_caja AS b ON b.id = a.recibo_caja_id
LEFT OUTER JOIN recibo_caja_pivot_estudiante AS c ON c.recibo_caja_id = b.id
LEFT OUTER JOIN recibo_caja_pivot_proveedores AS d ON d.recibo_caja_id = b.id
LEFT OUTER JOIN estudiante AS e ON e.id = c.estudiante_id
LEFT OUTER JOIN proveedores AS f ON f.id = d.proveedores_id
LEFT OUTER JOIN sede ON sede.id = b.sede_id
WHERE
a.deleted_at IS NULL AND
b.deleted_at IS NULL AND
b.usuario_id = id_user AND
DATE_FORMAT(a.created_at, '%Y-%m-%d') <=  fecha AND
b.impresion_cuadre = 0
GROUP BY
a.recibo_caja_id,
a.deleted_at,
created_at,
b.impresion_cuadre,
b.consecutivo,
b.descuento,
e.id,
e.nombres,
e.primer_apellido,
e.segundo_apellido,
f.nombres,
f.apellidos,
sede.nombre$$

DROP PROCEDURE IF EXISTS `getDetalleIngresosByRecibo`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getDetalleIngresosByRecibo` (IN `id_recibo` INT(11))  NO SQL
SELECT
a.recibo_caja_detalle_id as recibo
FROM
detalle_ingresos AS a
WHERE
a.recibo_caja_detalle_id = id_recibo
 AND
a.deleted_at IS NULL$$

DROP PROCEDURE IF EXISTS `getDetalleReciboByDetallFactura`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getDetalleReciboByDetallFactura` (IN `id_detalle_factura` INT(11))  NO SQL
SELECT
a.recibo_caja_id AS caja_id
FROM
recibo_caja_detalle AS a
WHERE
a.detalle_factura_id LIKE id_detalle_factura AND
a.deleted_at IS NULL$$

DROP PROCEDURE IF EXISTS `getDetalleReciboByIdRecibo`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getDetalleReciboByIdRecibo` (IN `id_recibo` INT(11))  NO SQL
SELECT
b.observacion,
c.descripcion,
b.valor
FROM
recibo_caja AS a
INNER JOIN recibo_caja_detalle AS b ON b.recibo_caja_id = a.id
INNER JOIN concepto AS c ON c.id = b.concepto_id
WHERE
a.id = id_recibo$$

DROP PROCEDURE IF EXISTS `getFormaPagoByIdReciboCajaDetalle`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getFormaPagoByIdReciboCajaDetalle` (IN `recibo_caja_detalle_id` INT(11))  NO SQL
SELECT
a.valor,
b.descripcion
FROM
forma_pago AS b
INNER JOIN forma_pago_detalle AS a ON a.forma_pago_id = b.id
WHERE
b.deleted_at IS NULL AND
a.deleted_at IS NULL AND
a.recibo_caja_id = recibo_caja_detalle_id$$

DROP PROCEDURE IF EXISTS `getGestionByIdEstudiante`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getGestionByIdEstudiante` (IN `estudiante_id` INT(11))  NO SQL
SELECT 
DATE_FORMAT(fecha_gestion, '%Y-%m-%d') as fecha_gestion,
contacto,
observacion,
gestion_cartera.id 
FROM gestion_cartera 
WHERE id_estudiante = estudiante_id$$

DROP PROCEDURE IF EXISTS `getIdsFacturasCarteraByIdEStudiante`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getIdsFacturasCarteraByIdEStudiante` (IN `id_estudiante` INT, IN `reintegro` INT, IN `fecha_suspension` DATE)  NO SQL
BEGIN

IF reintegro = 0 THEN
	SELECT
		factura.id,
		factura.estudiante_id,
		detalle_factura.fecha_inicio,
		detalle_factura.cuota,
		detalle_factura.saldo_vencido,
		DATEDIFF(
			NOW(),
			(
				detalle_factura.fecha_inicio
			)
		) AS Dias,
		estudiante.consecutivo,
		concepto.descripcion,
		detalle_factura.id AS detalle_factura_id,
		detalle_factura.suspendido,
        concepto.id AS concepto_id
	FROM
		factura
	INNER JOIN detalle_factura ON detalle_factura.factura_id = factura.id
	INNER JOIN estudiante ON factura.estudiante_id = estudiante.id
	INNER JOIN concepto ON concepto.id = detalle_factura.concepto_id
	WHERE
		factura.estudiante_id = id_estudiante
	AND detalle_factura.saldo_vencido > 0
	AND factura.deleted_at IS NULL
  AND detalle_factura.deleted_at IS NULL
  AND estudiante.deleted_at IS NULL
	AND DATEDIFF(
		fecha_suspension,
		(
			detalle_factura.fecha_inicio
		)
	) <= 0;
	ELSE
		SELECT
			factura.id,
			factura.estudiante_id,
			detalle_factura.fecha_inicio,
			detalle_factura.cuota,
			detalle_factura.saldo_vencido,
			DATEDIFF(
				NOW(),
				(
					detalle_factura.fecha_inicio
				)
			) AS Dias,
			estudiante.consecutivo,
			concepto.descripcion,
			detalle_factura.id AS detalle_factura_id,
			detalle_factura.suspendido,
            concepto.id AS concepto_id
		FROM
			factura
		INNER JOIN detalle_factura ON detalle_factura.factura_id = factura.id
		INNER JOIN estudiante ON factura.estudiante_id = estudiante.id
		INNER JOIN concepto ON concepto.id = detalle_factura.concepto_id
		WHERE
			factura.estudiante_id = id_estudiante
		AND factura.deleted_at IS NULL
		AND detalle_factura.suspendido = 1 
		AND estudiante.deleted_at IS NULL
		AND DATEDIFF(
			NOW(),
			(
				detalle_factura.fecha_inicio
			)
		) <= 0;
		END IF;


END$$

DROP PROCEDURE IF EXISTS `getLastAuxiliarByUser`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getLastAuxiliarByUser` (IN `id_usuario` INT)  NO SQL
SELECT COUNT(id) as respuesta FROM cuadre_auxiliar WHERE user_id = id_usuario$$

DROP PROCEDURE IF EXISTS `getNextConsecutivoByUsuario`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getNextConsecutivoByUsuario` (IN `id_user` INT, IN `last_id` INT)  NO SQL
SELECT
COUNT(a.id) As consecutivo
FROM
cuadre as a
WHERE
a.usuario_id_creador = id_user
AND
a.id <= last_id$$

DROP PROCEDURE IF EXISTS `getPreinscritosByAllSede`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getPreinscritosByAllSede` ()  NO SQL
SELECT
a.id AS id,
Count(b.id) AS cantidad,
a.nombre
FROM
sede AS a
INNER JOIN estudiante AS b ON a.id = b.sede_id
WHERE
a.deleted_at IS NULL AND
b.deleted_at IS NULL AND
b.estudiante_status_id = 5
GROUP BY
a.id$$

DROP PROCEDURE IF EXISTS `getPreinscritosBySede`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getPreinscritosBySede` (IN `id_sede` INT(11))  NO SQL
SELECT
Count(a.id) AS cantidad
FROM
estudiante AS a
WHERE
a.sede_id = id_sede AND
a.estudiante_status_id = 5 AND
a.deleted_at IS NULL$$

DROP PROCEDURE IF EXISTS `getProveedorByDato`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getProveedorByDato` (IN `dato` VARCHAR(20))  NO SQL
SELECT
proveedores.id,
proveedores.sede_id,
CONCAT_WS(' ', proveedores.nombres, proveedores.apellidos) AS nombre,
proveedores.created_at,
proveedores.deleted_at,
proveedores.telefono,
proveedores.celular,
proveedores.num_documento,
proveedores.direccion,
proveedores.email,
proveedores.identificacion_id,
proveedores.ciudad_id FROM proveedores WHERE nombres LIKE dato AND
proveedores.deleted_at IS NULL$$

DROP PROCEDURE IF EXISTS `getReciboByIdEstu`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getReciboByIdEstu` (IN `id_estu` INT(11))  NO SQL
SELECT
recibo_caja.id,
recibo_caja.consecutivo,
recibo_caja.fecha_pago,
Sum(recibo_caja_detalle.valor) AS valor,
recibo_caja.descuento,
(SUM(recibo_caja_detalle.valor) - recibo_caja.descuento) AS neto
FROM
recibo_caja
INNER JOIN recibo_caja_detalle ON recibo_caja_detalle.recibo_caja_id = recibo_caja.id
INNER JOIN detalle_factura ON recibo_caja_detalle.detalle_factura_id = detalle_factura.id
INNER JOIN factura ON detalle_factura.factura_id = factura.id
WHERE
factura.estudiante_id = id_estu
GROUP BY
recibo_caja.id,
recibo_caja.consecutivo,
recibo_caja.fecha_pago$$

DROP PROCEDURE IF EXISTS `getRecibosInicioFin`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getRecibosInicioFin` (IN `id_cuadre` INT)  NO SQL
SELECT
Min(a.id) AS minimo,
Max(a.id) AS maximo
FROM
recibo_caja AS a
INNER JOIN detalle_ingresos AS b ON a.id = b.recibo_caja_detalle_id
WHERE
b.cuadre_id = id_cuadre$$

DROP PROCEDURE IF EXISTS `getRecibosInicioFinGastos`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getRecibosInicioFinGastos` (IN `id_cuadre` INT)  NO SQL
SELECT
Min(c.gasto_id) AS minimo,
Max(c.gasto_id) AS maximo
FROM
detalle_egresos AS b
INNER JOIN gastos_detalles AS c ON c.id = b.gastos_detalles_id
WHERE
b.cuadre_id = id_cuadre AND
b.deleted_at IS NULL AND
c.deleted_at IS NULL$$

DROP PROCEDURE IF EXISTS `getUsuarioById`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getUsuarioById` (IN `id` INT(11))  NO SQL
SELECT
a.id,
a.user_name,
a.`password`,
a.actived,
a.changue_password,
a.credencial_id,
a.sede_id,
b.nombre AS nom_sede
FROM
usuario AS a
INNER JOIN sede AS b ON a.sede_id = b.id
WHERE
a.id = id AND
a.deleted_at IS NULL$$

DROP PROCEDURE IF EXISTS `getUsuariosByIdSede`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getUsuariosByIdSede` (IN `id_sede` INT(11))  NO SQL
SELECT
a.id,
a.user_name,
a.sede_id
FROM
usuario AS a
WHERE
a.sede_id = id_sede AND
a.deleted_at IS NULL$$

DROP PROCEDURE IF EXISTS `insertarPatrocinador`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertarPatrocinador` (IN `nit` VARCHAR(100), IN `nombre` VARCHAR(100), IN `direccion` VARCHAR(100), IN `telefono` VARCHAR(100), IN `id_estudiante` INT)  NO SQL
INSERT INTO patrocinador (nit,nombre,direccion,telefono,id_estudiante) VALUES (nit,nombre,direccion,telefono,id_estudiante)$$

DROP PROCEDURE IF EXISTS `insertAuxiliarCuadre`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertAuxiliarCuadre` (IN `id_cuadre` INT, IN `id_usuario` INT)  NO SQL
INSERT INTO cuadre_auxiliar (cuadre_id,user_id) VALUES(id_cuadre,id_usuario)$$

DROP PROCEDURE IF EXISTS `updateDetalleFacturaSaldosByIdRecibo`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateDetalleFacturaSaldosByIdRecibo` (IN `id_recibo` INT(11))  NO SQL
BEGIN
UPDATE detalle_factura
JOIN (
 SELECT recibo_caja_detalle.detalle_factura_id AS id_factura,
 detalle_factura.cuota AS cuota
FROM
 recibo_caja_detalle
INNER JOIN detalle_factura ON recibo_caja_detalle.detalle_factura_id = detalle_factura.id
WHERE
 recibo_caja_detalle.recibo_caja_id = id_recibo
AND recibo_caja_detalle.deleted_at IS NULL
AND detalle_factura.deleted_at IS NULL
) AS findPIDsQuery ON detalle_factura.id = findPIDsQuery.id_factura
SET detalle_factura.saldo_vencido = findPIDsQuery.cuota;

DELETE a
FROM
 recibo_caja_detalle AS a
JOIN (
 SELECT 
   c.id AS id_detalle
  FROM
   recibo_caja_detalle AS c
  WHERE
   c.recibo_caja_id = id_recibo
) AS b ON b.id_detalle = a.id;

UPDATE recibo_caja SET deleted_at = NOW() WHERE id=id_recibo;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `aux_consecutivo`
--

DROP TABLE IF EXISTS `aux_consecutivo`;
CREATE TABLE IF NOT EXISTS `aux_consecutivo` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `estudiante_id` int(10) UNSIGNED DEFAULT NULL,
  `sede_id` int(10) UNSIGNED DEFAULT NULL,
  `ano` int(11) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_aux_consecutivo_estudiante` (`estudiante_id`),
  KEY `fk_aux_consecutivo_sede` (`sede_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `becas`
--

DROP TABLE IF EXISTS `becas`;
CREATE TABLE IF NOT EXISTS `becas` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `descripcion` text CHARACTER SET utf8 COLLATE utf8_spanish2_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `sede_id` int(10) UNSIGNED DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_becas_sede` (`sede_id`)
) ENGINE=InnoDB AUTO_INCREMENT=43 DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `becas`
--

INSERT INTO `becas` (`id`, `descripcion`, `created_at`, `deleted_at`, `sede_id`) VALUES
(1, 'Bd', '2016-11-23 19:57:32', NULL, 3),
(2, 'Bd', '2016-11-23 21:07:48', NULL, 2),
(3, 'Bd', '2017-04-16 14:51:09', NULL, 1),
(4, 'Bd', '2017-04-16 14:51:09', NULL, 4),
(5, 'Bcenal', '2017-04-16 14:51:09', NULL, 1),
(6, 'Binterdrogas', '2017-04-16 14:51:09', NULL, 1),
(7, 'Brendimiento', '2017-04-16 14:51:09', NULL, 1),
(8, 'Bfamiliar', '2017-04-16 14:51:09', NULL, 1),
(9, 'Esenorte', '2017-04-16 14:51:09', NULL, 1),
(10, 'Esecentro', '2017-04-16 14:51:09', NULL, 1),
(11, 'Bcondor', '2017-04-16 14:51:09', NULL, 1),
(12, 'Isabelmejia', '2017-04-16 14:51:09', NULL, 1),
(13, 'B.Arcos', '2017-04-16 14:51:09', NULL, 1),
(14, 'Bav', '2017-04-16 14:51:09', NULL, 4),
(15, 'Bf', '2017-04-16 14:51:09', NULL, 4),
(16, 'Bcn', '2017-04-16 14:51:09', NULL, 4),
(17, 'Bl', '2017-04-16 14:51:09', NULL, 4),
(18, 'Todomed', '2017-04-16 14:51:09', NULL, 1),
(19, 'Bfamiliar', '2017-04-16 14:51:09', NULL, 2),
(20, 'Bverde', '2017-04-16 14:51:09', NULL, 2),
(21, 'Bpopular', '2017-04-16 14:51:09', NULL, 2),
(22, 'Beustorgio', '2017-04-16 14:51:09', NULL, 2),
(23, 'Btenorio', '2017-04-16 14:51:09', NULL, 2),
(24, 'Becass', '2017-04-16 14:51:09', NULL, 2),
(25, 'Bmc', '2017-04-16 14:51:09', NULL, 2),
(26, 'Brendimiento', '2017-04-16 14:51:09', NULL, 2),
(27, 'Borejuela', '2017-04-16 14:51:09', NULL, 3),
(28, 'Previser', '2017-04-16 14:51:09', NULL, 1),
(29, 'Bcenal', '2017-04-16 14:51:09', NULL, 3),
(30, 'Previser', '2017-04-16 14:51:09', NULL, 2),
(31, 'Bcenal', '2017-04-16 14:51:09', NULL, 4),
(32, 'Bapom', '2017-04-16 14:51:09', NULL, 4),
(34, 'Previser', '2017-04-16 14:51:09', NULL, 3),
(35, 'Previser', '2017-04-16 14:51:09', NULL, 4),
(36, '2Programas', '2017-04-16 14:51:09', NULL, 1),
(37, 'Porvenir', '2017-04-16 14:51:09', NULL, 1),
(38, '2Programas', '2017-04-16 14:51:09', NULL, 4),
(39, 'Accionplus', '2017-04-16 14:51:09', NULL, 1),
(40, 'Porvenir', '2017-05-21 17:06:34', NULL, 2),
(41, 'Porvernir', '2017-05-21 17:06:34', NULL, 3),
(42, 'Porvenir', '2017-05-21 17:06:34', NULL, 4);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `bitacora`
--

DROP TABLE IF EXISTS `bitacora`;
CREATE TABLE IF NOT EXISTS `bitacora` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `accion` varchar(80) CHARACTER SET utf8 COLLATE utf8_spanish2_ci NOT NULL,
  `usuario_id` int(10) UNSIGNED NOT NULL,
  `observacion` varchar(1024) CHARACTER SET utf8 COLLATE utf8_spanish2_ci DEFAULT NULL,
  `fecha` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `tabla` varchar(80) CHARACTER SET utf8 COLLATE utf8_spanish2_ci NOT NULL,
  `registro` bigint(20) UNSIGNED DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `bitacora_accion_Idx` (`accion`) USING BTREE,
  KEY `bitacora_usuario_id_Idx` (`usuario_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=455716 DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `bitacora`
--

INSERT INTO `bitacora` (`id`, `accion`, `usuario_id`, `observacion`, `fecha`, `tabla`, `registro`) VALUES
(455674, 'identificación', 1, NULL, '2017-11-14 16:02:42', 'NINGUNA', NULL),
(455675, 'Registro Creado', 1, 'Codigo Estudiante 2175023', '2017-11-14 16:38:56', 'estudiante', 1),
(455676, 'Registro Creado', 1, '', '2017-11-14 16:38:56', 'factura', 1),
(455677, 'Registro Detalle Creado', 1, 'Factura id 1', '2017-11-14 16:38:56', 'detalle_factura', 1),
(455678, 'Registro Detalle Creado', 1, 'Factura id 1', '2017-11-14 16:38:56', 'detalle_factura', 2),
(455679, 'Registro Detalle Creado', 1, 'Factura id 1', '2017-11-14 16:38:56', 'detalle_factura', 3),
(455680, 'Registro Detalle Creado', 1, 'Factura id 1', '2017-11-14 16:38:56', 'detalle_factura', 4),
(455681, 'Registro Detalle Creado', 1, 'Factura id 1', '2017-11-14 16:38:56', 'detalle_factura', 5),
(455682, 'Registro Detalle Creado', 1, 'Factura id 1', '2017-11-14 16:38:56', 'detalle_factura', 6),
(455683, 'Registro Detalle Creado', 1, 'Factura id 1', '2017-11-14 16:38:56', 'detalle_factura', 7),
(455684, 'Registro Detalle Creado', 1, 'Factura id 1', '2017-11-14 16:38:56', 'detalle_factura', 8),
(455685, 'Registro Detalle Creado', 1, 'Factura id 1', '2017-11-14 16:38:56', 'detalle_factura', 9),
(455686, 'Registro Detalle Creado', 1, 'Factura id 1', '2017-11-14 16:38:56', 'detalle_factura', 10),
(455687, 'Registro Detalle Creado', 1, 'Factura id 1', '2017-11-14 16:38:56', 'detalle_factura', 11),
(455688, 'Registro Detalle Creado', 1, 'Factura id 1', '2017-11-14 16:38:56', 'detalle_factura', 12),
(455689, 'Registro Detalle Creado', 1, 'Factura id 1', '2017-11-14 16:38:56', 'detalle_factura', 13),
(455690, 'Registro Detalle Creado', 1, 'Factura id 1', '2017-11-14 16:38:56', 'detalle_factura', 14),
(455691, 'Registro Detalle Creado', 1, 'Factura id 1', '2017-11-14 16:38:56', 'detalle_factura', 15),
(455692, 'Registro Detalle Creado', 1, 'Factura id 1', '2017-11-14 16:38:56', 'detalle_factura', 16),
(455693, 'Registro Detalle Creado', 1, 'Factura id 1', '2017-11-14 16:38:56', 'detalle_factura', 17),
(455694, 'Registro Detalle Creado', 1, 'Factura id 1', '2017-11-14 16:38:56', 'detalle_factura', 18),
(455695, 'Registro Detalle Creado', 1, 'Factura id 1', '2017-11-14 16:38:56', 'detalle_factura', 19),
(455696, 'Registro Detalle Creado', 1, 'Factura id 1', '2017-11-14 16:38:56', 'detalle_factura', 20),
(455697, 'Registro Detalle Creado', 1, 'Factura id 1', '2017-11-14 16:38:56', 'detalle_factura', 21),
(455698, 'identificación', 1, NULL, '2017-11-14 19:29:54', 'NINGUNA', NULL),
(455699, 'identificación', 1, NULL, '2017-11-14 19:31:35', 'NINGUNA', NULL),
(455700, 'Registro Creado', 1, 'Recibo n° 1', '2017-11-14 05:00:00', 'Patrocinador', 1),
(455701, 'identificación', 1, NULL, '2017-11-15 13:42:52', 'NINGUNA', NULL),
(455702, 'Registro Creado', 1, 'Recibo n° 1', '2017-11-15 05:00:00', 'Patrocinador', 1),
(455703, 'Registro Creado', 1, 'Recibo n° 1', '2017-11-15 05:00:00', 'Patrocinador', 1),
(455704, 'Registro Creado', 1, 'Recibo n° 1', '2017-11-15 16:04:02', 'recibo_caja', 1),
(455705, 'Registro Creado', 1, 'Recibo n° 1', '2017-11-15 16:04:02', 'recibo_caja_detalle', 1),
(455706, 'Registro Forma de Pago Detalle Creado', 1, '', '2017-11-15 16:04:05', 'forma_pago_detalle', 1),
(455707, 'Doc. Recibo Impreso', 1, '', '2017-11-15 16:13:18', 'recibo_caja', 1),
(455708, 'Registro Creado', 1, 'Recibo n° 2', '2017-11-15 19:41:07', 'recibo_caja', 2),
(455709, 'Registro Creado', 1, 'Recibo n° 2', '2017-11-15 19:41:07', 'recibo_caja_detalle', 2),
(455710, 'identificación', 1, NULL, '2017-11-22 14:32:18', 'NINGUNA', NULL),
(455711, 'Registro Creado', 1, 'Recibo n° 3', '2017-11-22 14:32:35', 'recibo_caja', 3),
(455712, 'Registro Creado', 1, 'Recibo n° 3', '2017-11-22 14:32:35', 'recibo_caja_detalle', 3),
(455713, 'Registro Creado', 1, 'Recibo n° 3', '2017-11-22 14:32:36', 'recibo_caja_detalle', 4),
(455714, 'Registro Forma de Pago Detalle Creado', 1, '', '2017-11-22 14:32:44', 'forma_pago_detalle', 2),
(455715, 'Doc. Recibo Impreso', 1, '', '2017-11-22 14:32:47', 'recibo_caja', 3);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ciudad`
--

DROP TABLE IF EXISTS `ciudad`;
CREATE TABLE IF NOT EXISTS `ciudad` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `ciudad` varchar(255) CHARACTER SET utf8 COLLATE utf8_spanish2_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `departamento_id` int(10) UNSIGNED DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_ciudad_departamento` (`departamento_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1121 DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `ciudad`
--

INSERT INTO `ciudad` (`id`, `ciudad`, `created_at`, `deleted_at`, `departamento_id`) VALUES
(1, 'Santiago de Cali', '2016-11-22 20:31:39', NULL, 1),
(2, 'Tuluá', '2016-11-24 22:20:02', NULL, 1),
(3, 'Palmira', '2016-11-26 21:06:49', NULL, 1),
(4, 'Popayán', '2016-11-26 22:40:16', NULL, 2),
(5, 'Andalucía', '2017-04-16 14:24:27', NULL, 1),
(6, 'Bugalagrande', '2017-04-16 14:24:27', NULL, 1),
(7, 'Zarzal', '2017-04-16 14:24:27', NULL, 1),
(8, 'Riofrio', '2017-04-16 14:24:27', NULL, 1),
(9, 'Buga', '2017-04-16 14:24:27', NULL, 1),
(10, 'Piendamo', '2017-06-07 23:48:36', NULL, 2),
(11, 'ANGELOPOLIS', '2016-06-23 11:49:49', NULL, 24),
(12, 'ANGOSTURA', '2016-06-23 11:49:49', NULL, 24),
(13, 'ANORI', '2016-06-23 11:49:49', NULL, 24),
(14, 'SANTAFE DE ANTIOQUIA', '2016-06-23 11:49:49', NULL, 24),
(15, 'ANZA', '2016-06-23 11:49:49', NULL, 24),
(16, 'APARTADO', '2016-06-23 11:49:49', NULL, 24),
(17, 'ARBOLETES', '2016-06-23 11:49:49', NULL, 24),
(18, 'ARGELIA', '2016-06-23 11:49:49', NULL, 24),
(19, 'ARMENIA', '2016-06-23 11:49:49', NULL, 24),
(20, 'BARBOSA', '2016-06-23 11:49:49', NULL, 24),
(21, 'BELMIRA', '2016-06-23 11:49:49', NULL, 24),
(22, 'BELLO', '2016-06-23 11:49:49', NULL, 24),
(23, 'BETANIA', '2016-06-23 11:49:49', NULL, 24),
(24, 'BETULIA', '2016-06-23 11:49:49', NULL, 24),
(25, 'CIUDAD BOLIVAR', '2016-06-23 11:49:49', NULL, 24),
(26, 'BRICEÑO', '2016-06-23 11:49:49', NULL, 24),
(27, 'BURITICA', '2016-06-23 11:49:49', NULL, 24),
(28, 'CACERES', '2016-06-23 11:49:49', NULL, 24),
(29, 'CAICEDO', '2016-06-23 11:49:49', NULL, 24),
(30, 'CALDAS', '2016-06-23 11:49:49', NULL, 24),
(31, 'CAMPAMENTO', '2016-06-23 11:49:49', NULL, 24),
(32, 'CAÑASGORDAS', '2016-06-23 11:49:49', NULL, 24),
(33, 'CARACOLI', '2016-06-23 11:49:49', NULL, 24),
(34, 'CARAMANTA', '2016-06-23 11:49:49', NULL, 24),
(35, 'CAREPA', '2016-06-23 11:49:49', NULL, 24),
(36, 'EL CARMEN DE VIBORAL', '2016-06-23 11:49:49', NULL, 24),
(37, 'CAROLINA', '2016-06-23 11:49:49', NULL, 24),
(38, 'CAUCASIA', '2016-06-23 11:49:49', NULL, 24),
(39, 'CHIGORODO', '2016-06-23 11:49:49', NULL, 24),
(40, 'CISNEROS', '2016-06-23 11:49:49', NULL, 24),
(41, 'COCORNA', '2016-06-23 11:49:49', NULL, 24),
(42, 'CONCEPCION', '2016-06-23 11:49:49', NULL, 24),
(43, 'CONCORDIA', '2016-06-23 11:49:49', NULL, 24),
(44, 'COPACABANA', '2016-06-23 11:49:49', NULL, 24),
(45, 'DABEIBA', '2016-06-23 11:49:49', NULL, 24),
(46, 'DON MATIAS', '2016-06-23 11:49:49', NULL, 24),
(47, 'EBEJICO', '2016-06-23 11:49:49', NULL, 24),
(48, 'EL BAGRE', '2016-06-23 11:49:49', NULL, 24),
(49, 'ENTRERRIOS', '2016-06-23 11:49:49', NULL, 24),
(50, 'ENVIGADO', '2016-06-23 11:49:49', NULL, 24),
(51, 'FREDONIA', '2016-06-23 11:49:49', NULL, 24),
(52, 'FRONTINO', '2016-06-23 11:49:49', NULL, 24),
(53, 'GIRALDO', '2016-06-23 11:49:49', NULL, 24),
(54, 'GIRARDOTA', '2016-06-23 11:49:49', NULL, 24),
(55, 'GOMEZ PLATA', '2016-06-23 11:49:49', NULL, 24),
(56, 'GRANADA', '2016-06-23 11:49:49', NULL, 24),
(57, 'GUADALUPE', '2016-06-23 11:49:49', NULL, 24),
(58, 'GUARNE', '2016-06-23 11:49:49', NULL, 24),
(59, 'GUATAPE', '2016-06-23 11:49:49', NULL, 24),
(60, 'HELICONIA', '2016-06-23 11:49:49', NULL, 24),
(61, 'HISPANIA', '2016-06-23 11:49:49', NULL, 24),
(62, 'ITAGUI', '2016-06-23 11:49:49', NULL, 24),
(63, 'ITUANGO', '2016-06-23 11:49:49', NULL, 24),
(64, 'JARDIN', '2016-06-23 11:49:49', NULL, 24),
(65, 'JERICO', '2016-06-23 11:49:49', NULL, 24),
(66, 'LA CEJA', '2016-06-23 11:49:49', NULL, 24),
(67, 'LA ESTRELLA', '2016-06-23 11:49:49', NULL, 24),
(68, 'LA PINTADA', '2016-06-23 11:49:49', NULL, 24),
(69, 'LA UNION', '2016-06-23 11:49:49', NULL, 24),
(70, 'LIBORINA', '2016-06-23 11:49:49', NULL, 24),
(71, 'MACEO', '2016-06-23 11:49:49', NULL, 24),
(72, 'MARINILLA', '2016-06-23 11:49:49', NULL, 24),
(73, 'MONTEBELLO', '2016-06-23 11:49:49', NULL, 24),
(74, 'MURINDO', '2016-06-23 11:49:49', NULL, 24),
(75, 'MUTATA', '2016-06-23 11:49:49', NULL, 24),
(76, 'NARIÑO', '2016-06-23 11:49:49', NULL, 24),
(77, 'NECOCLI', '2016-06-23 11:49:49', NULL, 24),
(78, 'NECHI', '2016-06-23 11:49:49', NULL, 24),
(79, 'OLAYA', '2016-06-23 11:49:49', NULL, 24),
(80, 'PEÑOL - ANTIOQUIA', '2016-06-23 11:49:49', NULL, 24),
(81, 'PEQUE', '2016-06-23 11:49:49', NULL, 24),
(82, 'PUEBLORRICO', '2016-06-23 11:49:49', NULL, 24),
(83, 'PUERTO BERRIO', '2016-06-23 11:49:49', NULL, 24),
(84, 'PUERTO NARE', '2016-06-23 11:49:49', NULL, 24),
(85, 'PUERTO TRIUNFO', '2016-06-23 11:49:49', NULL, 24),
(86, 'REMEDIOS', '2016-06-23 11:49:49', NULL, 24),
(87, 'RETIRO', '2016-06-23 11:49:49', NULL, 24),
(88, 'RIONEGRO', '2016-06-23 11:49:49', NULL, 24),
(89, 'SABANALARGA', '2016-06-23 11:49:49', NULL, 24),
(90, 'SABANETA', '2016-06-23 11:49:49', NULL, 24),
(91, 'SALGAR', '2016-06-23 11:49:49', NULL, 24),
(92, 'SAN ANDRES DE CUERQUIA', '2016-06-23 11:49:49', NULL, 24),
(93, 'SAN CARLOS', '2016-06-23 11:49:49', NULL, 24),
(94, 'SAN FRANCISCO', '2016-06-23 11:49:49', NULL, 24),
(95, 'SAN JERONIMO', '2016-06-23 11:49:49', NULL, 24),
(96, 'SAN JOSE DE LA MONTAÑA', '2016-06-23 11:49:49', NULL, 24),
(97, 'SAN JUAN DE URABA', '2016-06-23 11:49:49', NULL, 24),
(98, 'SAN LUIS', '2016-06-23 11:49:49', NULL, 24),
(99, 'SAN PEDRO', '2016-06-23 11:49:49', NULL, 24),
(100, 'SAN PEDRO DE URABA', '2016-06-23 11:49:49', NULL, 24),
(101, 'SAN RAFAEL', '2016-06-23 11:49:49', NULL, 24),
(102, 'SAN ROQUE', '2016-06-23 11:49:49', NULL, 24),
(103, 'SAN VICENTE', '2016-06-23 11:49:49', NULL, 24),
(104, 'SANTA BARBARA', '2016-06-23 11:49:49', NULL, 24),
(105, 'SANTA ROSA DE OSOS', '2016-06-23 11:49:49', NULL, 24),
(106, 'SANTO DOMINGO', '2016-06-23 11:49:49', NULL, 24),
(107, 'EL SANTUARIO', '2016-06-23 11:49:49', NULL, 24),
(108, 'SEGOVIA', '2016-06-23 11:49:49', NULL, 24),
(109, 'SONSON', '2016-06-23 11:49:49', NULL, 24),
(110, 'SOPETRAN', '2016-06-23 11:49:49', NULL, 24),
(111, 'TAMESIS', '2016-06-23 11:49:49', NULL, 24),
(112, 'TARAZA', '2016-06-23 11:49:49', NULL, 24),
(113, 'TARSO', '2016-06-23 11:49:49', NULL, 24),
(114, 'TITIRIBI', '2016-06-23 11:49:49', NULL, 24),
(115, 'TOLEDO', '2016-06-23 11:49:49', NULL, 24),
(116, 'TURBO', '2016-06-23 11:49:49', NULL, 24),
(117, 'URAMITA', '2016-06-23 11:49:49', NULL, 24),
(118, 'URRAO', '2016-06-23 11:49:49', NULL, 24),
(119, 'VALDIVIA', '2016-06-23 11:49:49', NULL, 24),
(120, 'VALPARAISO', '2016-06-23 11:49:49', NULL, 24),
(121, 'VEGACHI', '2016-06-23 11:49:49', NULL, 24),
(122, 'VENECIA', '2016-06-23 11:49:49', NULL, 24),
(123, 'VIGIA DEL FUERTE', '2016-06-23 11:49:49', NULL, 24),
(124, 'YALI', '2016-06-23 11:49:49', NULL, 24),
(125, 'YARUMAL', '2016-06-23 11:49:49', NULL, 24),
(126, 'YOLOMBO', '2016-06-23 11:49:49', NULL, 24),
(127, 'YONDO', '2016-06-23 11:49:49', NULL, 24),
(128, 'ZARAGOZA', '2016-06-23 11:49:49', NULL, 24),
(129, 'BARRANQUILLA', '2016-06-23 11:49:49', NULL, 8),
(130, 'BARANOA', '2016-06-23 11:49:49', NULL, 8),
(131, 'CAMPO DE LA CRUZ', '2016-06-23 11:49:49', NULL, 8),
(132, 'CANDELARIA', '2016-06-23 11:49:49', NULL, 8),
(133, 'GALAPA', '2016-06-23 11:49:49', NULL, 8),
(134, 'JUAN DE ACOSTA', '2016-06-23 11:49:49', NULL, 8),
(135, 'LURUACO', '2016-06-23 11:49:49', NULL, 8),
(136, 'MALAMBO', '2016-06-23 11:49:49', NULL, 8),
(137, 'MANATI', '2016-06-23 11:49:49', NULL, 8),
(138, 'PALMAR DE VARELA', '2016-06-23 11:49:49', NULL, 8),
(139, 'PIOJO', '2016-06-23 11:49:49', NULL, 8),
(140, 'POLONUEVO', '2016-06-23 11:49:49', NULL, 8),
(141, 'PONEDERA', '2016-06-23 11:49:49', NULL, 8),
(142, 'PUERTO COLOMBIA', '2016-06-23 11:49:49', NULL, 8),
(143, 'REPELON', '2016-06-23 11:49:49', NULL, 8),
(144, 'SABANAGRANDE', '2016-06-23 11:49:49', NULL, 8),
(145, 'SABANALARGA', '2016-06-23 11:49:49', NULL, 8),
(146, 'SANTA LUCIA', '2016-06-23 11:49:49', NULL, 8),
(147, 'SANTO TOMAS', '2016-06-23 11:49:49', NULL, 8),
(148, 'SOLEDAD', '2016-06-23 11:49:49', NULL, 8),
(149, 'SUAN', '2016-06-23 11:49:49', NULL, 8),
(150, 'TUBARA', '2016-06-23 11:49:49', NULL, 8),
(151, 'USIACURI', '2016-06-23 11:49:49', NULL, 8),
(152, 'BOGOTA, D.C.', '2016-06-23 11:49:49', NULL, 3),
(153, 'CARTAGENA', '2016-06-23 11:49:49', NULL, 4),
(154, 'ACHI', '2016-06-23 11:49:49', NULL, 4),
(155, 'ALTOS DEL ROSARIO', '2016-06-23 11:49:49', NULL, 4),
(156, 'ARENAL', '2016-06-23 11:49:49', NULL, 4),
(157, 'ARJONA', '2016-06-23 11:49:49', NULL, 4),
(158, 'ARROYOHONDO', '2016-06-23 11:49:49', NULL, 4),
(159, 'BARRANCO DE LOBA', '2016-06-23 11:49:49', NULL, 4),
(160, 'CALAMAR', '2016-06-23 11:49:49', NULL, 4),
(161, 'CANTAGALLO', '2016-06-23 11:49:49', NULL, 4),
(162, 'CICUCO', '2016-06-23 11:49:49', NULL, 4),
(163, 'CORDOBA', '2016-06-23 11:49:49', NULL, 4),
(164, 'CLEMENCIA', '2016-06-23 11:49:49', NULL, 4),
(165, 'EL CARMEN DE BOLIVAR', '2016-06-23 11:49:49', NULL, 4),
(166, 'EL GUAMO', '2016-06-23 11:49:49', NULL, 4),
(167, 'EL PEÑON', '2016-06-23 11:49:49', NULL, 4),
(168, 'HATILLO DE LOBA', '2016-06-23 11:49:49', NULL, 4),
(169, 'MAGANGUE', '2016-06-23 11:49:49', NULL, 4),
(170, 'MAHATES', '2016-06-23 11:49:49', NULL, 4),
(171, 'MARGARITA', '2016-06-23 11:49:49', NULL, 4),
(172, 'MARIA LA BAJA', '2016-06-23 11:49:49', NULL, 4),
(173, 'MONTECRISTO', '2016-06-23 11:49:49', NULL, 4),
(174, 'MOMPOS', '2016-06-23 11:49:49', NULL, 4),
(175, 'MORALES', '2016-06-23 11:49:49', NULL, 4),
(176, 'NOROSI', '2016-06-23 11:49:49', NULL, 4),
(177, 'PINILLOS', '2016-06-23 11:49:49', NULL, 4),
(178, 'REGIDOR', '2016-06-23 11:49:49', NULL, 4),
(179, 'RIO VIEJO', '2016-06-23 11:49:49', NULL, 4),
(180, 'SAN CRISTOBAL', '2016-06-23 11:49:49', NULL, 4),
(181, 'SAN ESTANISLAO', '2016-06-23 11:49:49', NULL, 4),
(182, 'SAN FERNANDO', '2016-06-23 11:49:49', NULL, 4),
(183, 'SAN JACINTO', '2016-06-23 11:49:49', NULL, 4),
(184, 'SAN JACINTO DEL CAUCA', '2016-06-23 11:49:49', NULL, 4),
(185, 'SAN JUAN NEPOMUCENO', '2016-06-23 11:49:49', NULL, 4),
(186, 'SAN MARTIN DE LOBA', '2016-06-23 11:49:49', NULL, 4),
(187, 'SAN PABLO', '2016-06-23 11:49:49', NULL, 4),
(188, 'SANTA CATALINA', '2016-06-23 11:49:49', NULL, 4),
(189, 'SANTA ROSA', '2016-06-23 11:49:49', NULL, 4),
(190, 'SANTA ROSA DEL SUR', '2016-06-23 11:49:49', NULL, 4),
(191, 'SIMITI', '2016-06-23 11:49:49', NULL, 4),
(192, 'SOPLAVIENTO', '2016-06-23 11:49:49', NULL, 4),
(193, 'TALAIGUA NUEVO', '2016-06-23 11:49:49', NULL, 4),
(194, 'TIQUISIO', '2016-06-23 11:49:49', NULL, 4),
(195, 'TURBACO', '2016-06-23 11:49:49', NULL, 4),
(196, 'TURBANA', '2016-06-23 11:49:49', NULL, 4),
(197, 'VILLANUEVA', '2016-06-23 11:49:49', NULL, 4),
(198, 'ZAMBRANO', '2016-06-23 11:49:49', NULL, 4),
(199, 'TUNJA', '2016-06-23 11:49:49', NULL, 5),
(200, 'ALMEIDA', '2016-06-23 11:49:49', NULL, 5),
(201, 'AQUITANIA', '2016-06-23 11:49:49', NULL, 5),
(202, 'ARCABUCO', '2016-06-23 11:49:49', NULL, 5),
(203, 'BELEN', '2016-06-23 11:49:49', NULL, 5),
(204, 'BERBEO', '2016-06-23 11:49:49', NULL, 5),
(205, 'BETEITIVA', '2016-06-23 11:49:49', NULL, 5),
(206, 'BOAVITA', '2016-06-23 11:49:49', NULL, 5),
(207, 'BOYACA', '2016-06-23 11:49:49', NULL, 5),
(208, 'BRICEÑO', '2016-06-23 11:49:49', NULL, 5),
(209, 'BUENAVISTA', '2016-06-23 11:49:49', NULL, 5),
(210, 'BUSBANZA', '2016-06-23 11:49:49', NULL, 5),
(211, 'CALDAS', '2016-06-23 11:49:49', NULL, 5),
(212, 'CAMPOHERMOSO', '2016-06-23 11:49:49', NULL, 5),
(213, 'CERINZA', '2016-06-23 11:49:49', NULL, 5),
(214, 'CHINAVITA', '2016-06-23 11:49:49', NULL, 5),
(215, 'CHIQUINQUIRA', '2016-06-23 11:49:49', NULL, 5),
(216, 'CHISCAS', '2016-06-23 11:49:49', NULL, 5),
(217, 'CHITA', '2016-06-23 11:49:49', NULL, 5),
(218, 'CHITARAQUE', '2016-06-23 11:49:49', NULL, 5),
(219, 'CHIVATA', '2016-06-23 11:49:49', NULL, 5),
(220, 'CIENEGA', '2016-06-23 11:49:49', NULL, 5),
(221, 'COMBITA', '2016-06-23 11:49:49', NULL, 5),
(222, 'COPER', '2016-06-23 11:49:49', NULL, 5),
(223, 'CORRALES', '2016-06-23 11:49:49', NULL, 5),
(224, 'COVARACHIA', '2016-06-23 11:49:49', NULL, 5),
(225, 'CUBARA', '2016-06-23 11:49:49', NULL, 5),
(226, 'CUCAITA', '2016-06-23 11:49:49', NULL, 5),
(227, 'CUITIVA', '2016-06-23 11:49:49', NULL, 5),
(228, 'CHIQUIZA', '2016-06-23 11:49:49', NULL, 5),
(229, 'CHIVOR', '2016-06-23 11:49:49', NULL, 5),
(230, 'DUITAMA', '2016-06-23 11:49:49', NULL, 5),
(231, 'EL COCUY', '2016-06-23 11:49:49', NULL, 5),
(232, 'EL ESPINO', '2016-06-23 11:49:49', NULL, 5),
(233, 'FIRAVITOBA', '2016-06-23 11:49:49', NULL, 5),
(234, 'FLORESTA', '2016-06-23 11:49:49', NULL, 5),
(235, 'GACHANTIVA', '2016-06-23 11:49:49', NULL, 5),
(236, 'GAMEZA', '2016-06-23 11:49:49', NULL, 5),
(237, 'GARAGOA', '2016-06-23 11:49:49', NULL, 5),
(238, 'GUACAMAYAS', '2016-06-23 11:49:49', NULL, 5),
(239, 'GUATEQUE', '2016-06-23 11:49:49', NULL, 5),
(240, 'GUAYATA', '2016-06-23 11:49:49', NULL, 5),
(241, 'GsICAN', '2016-06-23 11:49:49', NULL, 5),
(242, 'IZA', '2016-06-23 11:49:49', NULL, 5),
(243, 'JENESANO', '2016-06-23 11:49:49', NULL, 5),
(244, 'JERICO', '2016-06-23 11:49:49', NULL, 5),
(245, 'LABRANZAGRANDE', '2016-06-23 11:49:49', NULL, 5),
(246, 'LA CAPILLA', '2016-06-23 11:49:49', NULL, 5),
(247, 'LA VICTORIA', '2016-06-23 11:49:49', NULL, 5),
(248, 'LA UVITA', '2016-06-23 11:49:49', NULL, 5),
(249, 'VILLA DE LEYVA', '2016-06-23 11:49:49', NULL, 5),
(250, 'MACANAL', '2016-06-23 11:49:49', NULL, 5),
(251, 'MARIPI', '2016-06-23 11:49:49', NULL, 5),
(252, 'MIRAFLORES', '2016-06-23 11:49:49', NULL, 5),
(253, 'MONGUA', '2016-06-23 11:49:49', NULL, 5),
(254, 'MONGUI', '2016-06-23 11:49:49', NULL, 5),
(255, 'MONIQUIRA', '2016-06-23 11:49:49', NULL, 5),
(256, 'MOTAVITA', '2016-06-23 11:49:49', NULL, 5),
(257, 'MUZO', '2016-06-23 11:49:49', NULL, 5),
(258, 'NOBSA', '2016-06-23 11:49:49', NULL, 5),
(259, 'NUEVO COLON', '2016-06-23 11:49:49', NULL, 5),
(260, 'OICATA', '2016-06-23 11:49:49', NULL, 5),
(261, 'OTANCHE', '2016-06-23 11:49:49', NULL, 5),
(262, 'PACHAVITA', '2016-06-23 11:49:49', NULL, 5),
(263, 'PAEZ', '2016-06-23 11:49:49', NULL, 5),
(264, 'PAIPA', '2016-06-23 11:49:49', NULL, 5),
(265, 'PAJARITO', '2016-06-23 11:49:49', NULL, 5),
(266, 'PANQUEBA', '2016-06-23 11:49:49', NULL, 5),
(267, 'PAUNA', '2016-06-23 11:49:49', NULL, 5),
(268, 'PAYA', '2016-06-23 11:49:49', NULL, 5),
(269, 'PAZ DE RIO', '2016-06-23 11:49:49', NULL, 5),
(270, 'PESCA', '2016-06-23 11:49:49', NULL, 5),
(271, 'PISBA', '2016-06-23 11:49:49', NULL, 5),
(272, 'PUERTO BOYACA', '2016-06-23 11:49:49', NULL, 5),
(273, 'QUIPAMA', '2016-06-23 11:49:49', NULL, 5),
(274, 'RAMIRIQUI', '2016-06-23 11:49:49', NULL, 5),
(275, 'RAQUIRA', '2016-06-23 11:49:49', NULL, 5),
(276, 'RONDON', '2016-06-23 11:49:49', NULL, 5),
(277, 'SABOYA', '2016-06-23 11:49:49', NULL, 5),
(278, 'SACHICA', '2016-06-23 11:49:49', NULL, 5),
(279, 'SAMACA', '2016-06-23 11:49:49', NULL, 5),
(280, 'SAN EDUARDO', '2016-06-23 11:49:49', NULL, 5),
(281, 'SAN JOSE DE PARE', '2016-06-23 11:49:49', NULL, 5),
(282, 'SAN LUIS DE GACENO', '2016-06-23 11:49:49', NULL, 5),
(283, 'SAN MATEO', '2016-06-23 11:49:49', NULL, 5),
(284, 'SAN MIGUEL DE SEMA', '2016-06-23 11:49:49', NULL, 5),
(285, 'SAN PABLO DE BORBUR', '2016-06-23 11:49:49', NULL, 5),
(286, 'SANTANA', '2016-06-23 11:49:49', NULL, 5),
(287, 'SANTA MARIA', '2016-06-23 11:49:49', NULL, 5),
(288, 'SANTA ROSA DE VITERBO', '2016-06-23 11:49:49', NULL, 5),
(289, 'SANTA SOFIA', '2016-06-23 11:49:49', NULL, 5),
(290, 'SATIVANORTE', '2016-06-23 11:49:49', NULL, 5),
(291, 'SATIVASUR', '2016-06-23 11:49:49', NULL, 5),
(292, 'SIACHOQUE', '2016-06-23 11:49:49', NULL, 5),
(293, 'SOATA', '2016-06-23 11:49:49', NULL, 5),
(294, 'SOCOTA', '2016-06-23 11:49:49', NULL, 5),
(295, 'SOCHA', '2016-06-23 11:49:49', NULL, 5),
(296, 'SOGAMOSO', '2016-06-23 11:49:49', NULL, 5),
(297, 'SOMONDOCO', '2016-06-23 11:49:49', NULL, 5),
(298, 'SORA', '2016-06-23 11:49:49', NULL, 5),
(299, 'SOTAQUIRA', '2016-06-23 11:49:49', NULL, 5),
(300, 'SORACA', '2016-06-23 11:49:49', NULL, 5),
(301, 'SUSACON', '2016-06-23 11:49:49', NULL, 5),
(302, 'SUTAMARCHAN', '2016-06-23 11:49:49', NULL, 5),
(303, 'SUTATENZA', '2016-06-23 11:49:49', NULL, 5),
(304, 'TASCO', '2016-06-23 11:49:49', NULL, 5),
(305, 'TENZA', '2016-06-23 11:49:49', NULL, 5),
(306, 'TIBANA', '2016-06-23 11:49:49', NULL, 5),
(307, 'TIBASOSA', '2016-06-23 11:49:49', NULL, 5),
(308, 'TINJACA', '2016-06-23 11:49:49', NULL, 5),
(309, 'TIPACOQUE', '2016-06-23 11:49:49', NULL, 5),
(310, 'TOCA', '2016-06-23 11:49:49', NULL, 5),
(311, 'TOGsI', '2016-06-23 11:49:49', NULL, 5),
(312, 'TOPAGA', '2016-06-23 11:49:49', NULL, 5),
(313, 'TOTA', '2016-06-23 11:49:49', NULL, 5),
(314, 'TUNUNGUA', '2016-06-23 11:49:49', NULL, 5),
(315, 'TURMEQUE', '2016-06-23 11:49:49', NULL, 5),
(316, 'TUTA', '2016-06-23 11:49:49', NULL, 5),
(317, 'TUTAZA', '2016-06-23 11:49:49', NULL, 5),
(318, 'UMBITA', '2016-06-23 11:49:49', NULL, 5),
(319, 'VENTAQUEMADA', '2016-06-23 11:49:49', NULL, 5),
(320, 'VIRACACHA', '2016-06-23 11:49:49', NULL, 5),
(321, 'ZETAQUIRA', '2016-06-23 11:49:49', NULL, 5),
(322, 'MANIZALES', '2016-06-23 11:49:49', NULL, 6),
(323, 'AGUADAS', '2016-06-23 11:49:49', NULL, 6),
(324, 'ANSERMA', '2016-06-23 11:49:49', NULL, 6),
(325, 'ARANZAZU', '2016-06-23 11:49:49', NULL, 6),
(326, 'BELALCAZAR', '2016-06-23 11:49:49', NULL, 6),
(327, 'CHINCHINA', '2016-06-23 11:49:49', NULL, 6),
(328, 'FILADELFIA', '2016-06-23 11:49:49', NULL, 6),
(329, 'LA DORADA', '2016-06-23 11:49:49', NULL, 6),
(330, 'LA MERCED', '2016-06-23 11:49:49', NULL, 6),
(331, 'MANZANARES', '2016-06-23 11:49:49', NULL, 6),
(332, 'MARMATO', '2016-06-23 11:49:49', NULL, 6),
(333, 'MARQUETALIA', '2016-06-23 11:49:49', NULL, 6),
(334, 'MARULANDA', '2016-06-23 11:49:49', NULL, 6),
(335, 'NEIRA', '2016-06-23 11:49:49', NULL, 6),
(336, 'NORCASIA', '2016-06-23 11:49:49', NULL, 6),
(337, 'PACORA', '2016-06-23 11:49:49', NULL, 6),
(338, 'PALESTINA', '2016-06-23 11:49:49', NULL, 6),
(339, 'PENSILVANIA', '2016-06-23 11:49:49', NULL, 6),
(340, 'RIOSUCIO', '2016-06-23 11:49:49', NULL, 6),
(341, 'RISARALDA', '2016-06-23 11:49:49', NULL, 6),
(342, 'SALAMINA', '2016-06-23 11:49:49', NULL, 6),
(343, 'SAMANA', '2016-06-23 11:49:49', NULL, 6),
(344, 'SAN JOSE', '2016-06-23 11:49:49', NULL, 6),
(345, 'SUPIA', '2016-06-23 11:49:49', NULL, 6),
(346, 'VICTORIA', '2016-06-23 11:49:49', NULL, 6),
(347, 'VILLAMARIA', '2016-06-23 11:49:49', NULL, 6),
(348, 'VITERBO', '2016-06-23 11:49:49', NULL, 6),
(349, 'FLORENCIA', '2016-06-23 11:49:49', NULL, 7),
(350, 'ALBANIA', '2016-06-23 11:49:49', NULL, 7),
(351, 'BELEN DE LOS ANDAQUIES', '2016-06-23 11:49:49', NULL, 7),
(352, 'CARTAGENA DEL CHAIRA', '2016-06-23 11:49:49', NULL, 7),
(353, 'CURILLO', '2016-06-23 11:49:49', NULL, 7),
(354, 'EL DONCELLO', '2016-06-23 11:49:49', NULL, 7),
(355, 'EL PAUJIL', '2016-06-23 11:49:49', NULL, 7),
(356, 'LA MONTAÑITA', '2016-06-23 11:49:49', NULL, 7),
(357, 'MILAN', '2016-06-23 11:49:49', NULL, 7),
(358, 'MORELIA', '2016-06-23 11:49:49', NULL, 7),
(359, 'PUERTO RICO', '2016-06-23 11:49:49', NULL, 7),
(360, 'SAN JOSE DEL FRAGUA', '2016-06-23 11:49:49', NULL, 7),
(361, 'SAN VICENTE DEL CAGUAN', '2016-06-23 11:49:49', NULL, 7),
(362, 'SOLANO', '2016-06-23 11:49:49', NULL, 7),
(363, 'SOLITA', '2016-06-23 11:49:49', NULL, 7),
(364, 'VALPARAISO', '2016-06-23 11:49:49', NULL, 7),
(365, 'MEDELLIN', '2016-06-23 11:49:49', NULL, 24),
(366, 'ALMAGUER', '2016-06-23 11:49:49', NULL, 2),
(367, 'ARGELIA', '2016-06-23 11:49:49', NULL, 2),
(368, 'BALBOA', '2016-06-23 11:49:49', NULL, 2),
(369, 'BOLIVAR', '2016-06-23 11:49:49', NULL, 2),
(370, 'BUENOS AIRES', '2016-06-23 11:49:49', NULL, 2),
(371, 'CAJIBIO', '2016-06-23 11:49:49', NULL, 2),
(372, 'CALDONO', '2016-06-23 11:49:49', NULL, 2),
(373, 'CALOTO', '2016-06-23 11:49:49', NULL, 2),
(374, 'CORINTO', '2016-06-23 11:49:49', NULL, 2),
(375, 'EL TAMBO', '2016-06-23 11:49:49', NULL, 2),
(376, 'FLORENCIA', '2016-06-23 11:49:49', NULL, 2),
(377, 'GUAPI', '2016-06-23 11:49:49', NULL, 2),
(378, 'INZA', '2016-06-23 11:49:49', NULL, 2),
(379, 'JAMBALO', '2016-06-23 11:49:49', NULL, 2),
(380, 'LA SIERRA', '2016-06-23 11:49:49', NULL, 2),
(381, 'LA VEGA', '2016-06-23 11:49:49', NULL, 2),
(382, 'LOPEZ', '2016-06-23 11:49:49', NULL, 2),
(383, 'MERCADERES', '2016-06-23 11:49:49', NULL, 2),
(384, 'MIRANDA', '2016-06-23 11:49:49', NULL, 2),
(385, 'MORALES', '2016-06-23 11:49:49', NULL, 2),
(386, 'PADILLA', '2016-06-23 11:49:49', NULL, 2),
(387, 'PAEZ', '2016-06-23 11:49:49', NULL, 2),
(388, 'PATIA', '2016-06-23 11:49:49', NULL, 2),
(389, 'PIAMONTE', '2016-06-23 11:49:49', NULL, 2),
(390, 'ANDES', '2016-06-23 11:49:49', NULL, 24),
(391, 'PUERTO TEJADA', '2016-06-23 11:49:49', NULL, 2),
(392, 'PURACE', '2016-06-23 11:49:49', NULL, 2),
(393, 'ROSAS', '2016-06-23 11:49:49', NULL, 2),
(394, 'SAN SEBASTIAN', '2016-06-23 11:49:49', NULL, 2),
(395, 'SANTANDER DE QUILICHAO', '2016-06-23 11:49:49', NULL, 2),
(396, 'SANTA ROSA', '2016-06-23 11:49:49', NULL, 2),
(397, 'SILVIA', '2016-06-23 11:49:49', NULL, 2),
(398, 'SOTARA', '2016-06-23 11:49:49', NULL, 2),
(399, 'SUAREZ', '2016-06-23 11:49:49', NULL, 2),
(400, 'SUCRE', '2016-06-23 11:49:49', NULL, 2),
(401, 'TIMBIO', '2016-06-23 11:49:49', NULL, 2),
(402, 'TIMBIQUI', '2016-06-23 11:49:49', NULL, 2),
(403, 'TORIBIO', '2016-06-23 11:49:49', NULL, 2),
(404, 'TOTORO', '2016-06-23 11:49:49', NULL, 2),
(405, 'VILLA RICA', '2016-06-23 11:49:49', NULL, 2),
(406, 'VALLEDUPAR', '2016-06-23 11:49:49', NULL, 9),
(407, 'AGUACHICA', '2016-06-23 11:49:49', NULL, 9),
(408, 'AGUSTIN CODAZZI', '2016-06-23 11:49:49', NULL, 9),
(409, 'ASTREA', '2016-06-23 11:49:49', NULL, 9),
(410, 'BECERRIL', '2016-06-23 11:49:49', NULL, 9),
(411, 'BOSCONIA', '2016-06-23 11:49:49', NULL, 9),
(412, 'CHIMICHAGUA', '2016-06-23 11:49:49', NULL, 9),
(413, 'CHIRIGUANA', '2016-06-23 11:49:49', NULL, 9),
(414, 'CURUMANI', '2016-06-23 11:49:49', NULL, 9),
(415, 'EL COPEY', '2016-06-23 11:49:49', NULL, 9),
(416, 'EL PASO', '2016-06-23 11:49:49', NULL, 9),
(417, 'GAMARRA', '2016-06-23 11:49:49', NULL, 9),
(418, 'GONZALEZ', '2016-06-23 11:49:49', NULL, 9),
(419, 'LA GLORIA', '2016-06-23 11:49:49', NULL, 9),
(420, 'LA JAGUA DE IBIRICO', '2016-06-23 11:49:49', NULL, 9),
(421, 'MANAURE', '2016-06-23 11:49:49', NULL, 9),
(422, 'PAILITAS', '2016-06-23 11:49:49', NULL, 9),
(423, 'PELAYA', '2016-06-23 11:49:49', NULL, 9),
(424, 'PUEBLO BELLO', '2016-06-23 11:49:49', NULL, 9),
(425, 'RIO DE ORO', '2016-06-23 11:49:49', NULL, 9),
(426, 'LA PAZ', '2016-06-23 11:49:49', NULL, 9),
(427, 'SAN ALBERTO', '2016-06-23 11:49:49', NULL, 9),
(428, 'SAN DIEGO', '2016-06-23 11:49:49', NULL, 9),
(429, 'SAN MARTIN', '2016-06-23 11:49:49', NULL, 9),
(430, 'TAMALAMEQUE', '2016-06-23 11:49:49', NULL, 9),
(431, 'MONTERIA', '2016-06-23 11:49:49', NULL, 10),
(432, 'AYAPEL', '2016-06-23 11:49:49', NULL, 10),
(433, 'BUENAVISTA', '2016-06-23 11:49:49', NULL, 10),
(434, 'CANALETE', '2016-06-23 11:49:49', NULL, 10),
(435, 'CERETE', '2016-06-23 11:49:49', NULL, 10),
(436, 'CHIMA', '2016-06-23 11:49:49', NULL, 10),
(437, 'CHINU', '2016-06-23 11:49:49', NULL, 10),
(438, 'CIENAGA DE ORO', '2016-06-23 11:49:49', NULL, 10),
(439, 'COTORRA', '2016-06-23 11:49:49', NULL, 10),
(440, 'LA APARTADA', '2016-06-23 11:49:49', NULL, 10),
(441, 'LORICA', '2016-06-23 11:49:49', NULL, 10),
(442, 'LOS CORDOBAS', '2016-06-23 11:49:49', NULL, 10),
(443, 'MOMIL', '2016-06-23 11:49:49', NULL, 10),
(444, 'MONTELIBANO', '2016-06-23 11:49:49', NULL, 10),
(445, 'MOÑITOS', '2016-06-23 11:49:49', NULL, 10),
(446, 'PLANETA RICA', '2016-06-23 11:49:49', NULL, 10),
(447, 'PUEBLO NUEVO', '2016-06-23 11:49:49', NULL, 10),
(448, 'PUERTO ESCONDIDO', '2016-06-23 11:49:49', NULL, 10),
(449, 'PUERTO LIBERTADOR', '2016-06-23 11:49:49', NULL, 10),
(450, 'PURISIMA', '2016-06-23 11:49:49', NULL, 10),
(451, 'SAHAGUN', '2016-06-23 11:49:49', NULL, 10),
(452, 'SAN ANDRES SOTAVENTO', '2016-06-23 11:49:49', NULL, 10),
(453, 'SAN ANTERO', '2016-06-23 11:49:49', NULL, 10),
(454, 'SAN BERNARDO DEL VIENTO', '2016-06-23 11:49:49', NULL, 10),
(455, 'SAN CARLOS', '2016-06-23 11:49:49', NULL, 10),
(456, 'SAN PELAYO', '2016-06-23 11:49:49', NULL, 10),
(457, 'TIERRALTA', '2016-06-23 11:49:49', NULL, 10),
(458, 'VALENCIA', '2016-06-23 11:49:49', NULL, 10),
(459, 'AGUA DE DIOS', '2016-06-23 11:49:49', NULL, 11),
(460, 'ALBAN', '2016-06-23 11:49:49', NULL, 11),
(461, 'ANAPOIMA', '2016-06-23 11:49:49', NULL, 11),
(462, 'ANOLAIMA', '2016-06-23 11:49:49', NULL, 11),
(463, 'ARBELAEZ', '2016-06-23 11:49:49', NULL, 11),
(464, 'BELTRAN', '2016-06-23 11:49:49', NULL, 11),
(465, 'BITUIMA', '2016-06-23 11:49:49', NULL, 11),
(466, 'BOJACA', '2016-06-23 11:49:49', NULL, 11),
(467, 'CABRERA', '2016-06-23 11:49:49', NULL, 11),
(468, 'CACHIPAY', '2016-06-23 11:49:49', NULL, 11),
(469, 'CAJICA', '2016-06-23 11:49:49', NULL, 11),
(470, 'CAPARRAPI', '2016-06-23 11:49:49', NULL, 11),
(471, 'CAQUEZA', '2016-06-23 11:49:49', NULL, 11),
(472, 'CARMEN DE CARUPA', '2016-06-23 11:49:49', NULL, 11),
(473, 'CHAGUANI', '2016-06-23 11:49:49', NULL, 11),
(474, 'CHIA', '2016-06-23 11:49:49', NULL, 11),
(475, 'CHIPAQUE', '2016-06-23 11:49:49', NULL, 11),
(476, 'CHOACHI', '2016-06-23 11:49:49', NULL, 11),
(477, 'CHOCONTA', '2016-06-23 11:49:49', NULL, 11),
(478, 'COGUA', '2016-06-23 11:49:49', NULL, 11),
(479, 'COTA', '2016-06-23 11:49:49', NULL, 11),
(480, 'CUCUNUBA', '2016-06-23 11:49:49', NULL, 11),
(481, 'EL COLEGIO', '2016-06-23 11:49:49', NULL, 11),
(482, 'EL PEÑON', '2016-06-23 11:49:49', NULL, 11),
(483, 'EL ROSAL', '2016-06-23 11:49:49', NULL, 11),
(484, 'FACATATIVA', '2016-06-23 11:49:49', NULL, 11),
(485, 'FOMEQUE', '2016-06-23 11:49:49', NULL, 11),
(486, 'FOSCA', '2016-06-23 11:49:49', NULL, 11),
(487, 'FUNZA', '2016-06-23 11:49:49', NULL, 11),
(488, 'FUQUENE', '2016-06-23 11:49:49', NULL, 11),
(489, 'FUSAGASUGA', '2016-06-23 11:49:49', NULL, 11),
(490, 'GACHALA', '2016-06-23 11:49:49', NULL, 11),
(491, 'GACHANCIPA', '2016-06-23 11:49:49', NULL, 11),
(492, 'GACHETA', '2016-06-23 11:49:49', NULL, 11),
(493, 'GAMA', '2016-06-23 11:49:49', NULL, 11),
(494, 'GIRARDOT', '2016-06-23 11:49:49', NULL, 11),
(495, 'GRANADA', '2016-06-23 11:49:49', NULL, 11),
(496, 'GUACHETA', '2016-06-23 11:49:49', NULL, 11),
(497, 'GUADUAS', '2016-06-23 11:49:49', NULL, 11),
(498, 'GUASCA', '2016-06-23 11:49:49', NULL, 11),
(499, 'GUATAQUI', '2016-06-23 11:49:49', NULL, 11),
(500, 'GUATAVITA', '2016-06-23 11:49:49', NULL, 11),
(501, 'GUAYABAL DE SIQUIMA', '2016-06-23 11:49:49', NULL, 11),
(502, 'GUAYABETAL', '2016-06-23 11:49:49', NULL, 11),
(503, 'GUTIERREZ', '2016-06-23 11:49:49', NULL, 11),
(504, 'JERUSALEN', '2016-06-23 11:49:49', NULL, 11),
(505, 'JUNIN', '2016-06-23 11:49:49', NULL, 11),
(506, 'LA CALERA', '2016-06-23 11:49:49', NULL, 11),
(507, 'LA MESA', '2016-06-23 11:49:49', NULL, 11),
(508, 'LA PALMA', '2016-06-23 11:49:49', NULL, 11),
(509, 'LA PEÑA', '2016-06-23 11:49:49', NULL, 11),
(510, 'LA VEGA', '2016-06-23 11:49:49', NULL, 11),
(511, 'LENGUAZAQUE', '2016-06-23 11:49:49', NULL, 11),
(512, 'MACHETA', '2016-06-23 11:49:49', NULL, 11),
(513, 'MADRID', '2016-06-23 11:49:49', NULL, 11),
(514, 'MANTA', '2016-06-23 11:49:49', NULL, 11),
(515, 'MEDINA', '2016-06-23 11:49:49', NULL, 11),
(516, 'MOSQUERA', '2016-06-23 11:49:49', NULL, 11),
(517, 'NARIÑO', '2016-06-23 11:49:49', NULL, 11),
(518, 'NEMOCON', '2016-06-23 11:49:49', NULL, 11),
(519, 'NILO', '2016-06-23 11:49:49', NULL, 11),
(520, 'NIMAIMA', '2016-06-23 11:49:49', NULL, 11),
(521, 'NOCAIMA', '2016-06-23 11:49:49', NULL, 11),
(522, 'VENECIA', '2016-06-23 11:49:49', NULL, 11),
(523, 'PACHO', '2016-06-23 11:49:49', NULL, 11),
(524, 'PAIME', '2016-06-23 11:49:49', NULL, 11),
(525, 'PANDI', '2016-06-23 11:49:49', NULL, 11),
(526, 'PARATEBUENO', '2016-06-23 11:49:49', NULL, 11),
(527, 'PASCA', '2016-06-23 11:49:49', NULL, 11),
(528, 'PUERTO SALGAR', '2016-06-23 11:49:49', NULL, 11),
(529, 'PULI', '2016-06-23 11:49:49', NULL, 11),
(530, 'QUEBRADANEGRA', '2016-06-23 11:49:49', NULL, 11),
(531, 'QUETAME', '2016-06-23 11:49:49', NULL, 11),
(532, 'QUIPILE', '2016-06-23 11:49:49', NULL, 11),
(533, 'APULO', '2016-06-23 11:49:49', NULL, 11),
(534, 'RICAURTE', '2016-06-23 11:49:49', NULL, 11),
(535, 'SAN ANTONIO DEL TEQUENDAMA', '2016-06-23 11:49:49', NULL, 11),
(536, 'SAN BERNARDO', '2016-06-23 11:49:49', NULL, 11),
(537, 'SAN CAYETANO', '2016-06-23 11:49:49', NULL, 11),
(538, 'SAN FRANCISCO', '2016-06-23 11:49:49', NULL, 11),
(539, 'SAN JUAN DE RIO SECO', '2016-06-23 11:49:49', NULL, 11),
(540, 'SASAIMA', '2016-06-23 11:49:49', NULL, 11),
(541, 'SESQUILE', '2016-06-23 11:49:49', NULL, 11),
(542, 'SIBATE', '2016-06-23 11:49:49', NULL, 11),
(543, 'SILVANIA', '2016-06-23 11:49:49', NULL, 11),
(544, 'SIMIJACA', '2016-06-23 11:49:49', NULL, 11),
(545, 'SOACHA', '2016-06-23 11:49:49', NULL, 11),
(546, 'SOPO', '2016-06-23 11:49:49', NULL, 11),
(547, 'SUBACHOQUE', '2016-06-23 11:49:49', NULL, 11),
(548, 'SUESCA', '2016-06-23 11:49:49', NULL, 11),
(549, 'SUPATA', '2016-06-23 11:49:49', NULL, 11),
(550, 'SUSA', '2016-06-23 11:49:49', NULL, 11),
(551, 'SUTATAUSA', '2016-06-23 11:49:49', NULL, 11),
(552, 'TABIO', '2016-06-23 11:49:49', NULL, 11),
(553, 'TAUSA', '2016-06-23 11:49:49', NULL, 11),
(554, 'TENA', '2016-06-23 11:49:49', NULL, 11),
(555, 'TENJO', '2016-06-23 11:49:49', NULL, 11),
(556, 'TIBACUY', '2016-06-23 11:49:49', NULL, 11),
(557, 'TIBIRITA', '2016-06-23 11:49:49', NULL, 11),
(558, 'TOCAIMA', '2016-06-23 11:49:49', NULL, 11),
(559, 'TOCANCIPA', '2016-06-23 11:49:49', NULL, 11),
(560, 'TOPAIPI', '2016-06-23 11:49:49', NULL, 11),
(561, 'UBALA', '2016-06-23 11:49:49', NULL, 11),
(562, 'UBAQUE', '2016-06-23 11:49:49', NULL, 11),
(563, 'VILLA DE SAN DIEGO DE UBATE', '2016-06-23 11:49:49', NULL, 11),
(564, 'UNE', '2016-06-23 11:49:49', NULL, 11),
(565, 'UTICA', '2016-06-23 11:49:49', NULL, 11),
(566, 'VERGARA', '2016-06-23 11:49:49', NULL, 11),
(567, 'VIANI', '2016-06-23 11:49:49', NULL, 11),
(568, 'VILLAGOMEZ', '2016-06-23 11:49:49', NULL, 11),
(569, 'VILLAPINZON', '2016-06-23 11:49:49', NULL, 11),
(570, 'VILLETA', '2016-06-23 11:49:49', NULL, 11),
(571, 'VIOTA', '2016-06-23 11:49:49', NULL, 11),
(572, 'YACOPI', '2016-06-23 11:49:49', NULL, 11),
(573, 'ZIPACON', '2016-06-23 11:49:49', NULL, 11),
(574, 'ZIPAQUIRA', '2016-06-23 11:49:49', NULL, 11),
(575, 'QUIBDO', '2016-06-23 11:49:49', NULL, 12),
(576, 'ACANDI', '2016-06-23 11:49:49', NULL, 12),
(577, 'ALTO BAUDO', '2016-06-23 11:49:49', NULL, 12),
(578, 'ATRATO', '2016-06-23 11:49:49', NULL, 12),
(579, 'BAGADO', '2016-06-23 11:49:49', NULL, 12),
(580, 'BAHIA SOLANO', '2016-06-23 11:49:49', NULL, 12),
(581, 'BAJO BAUDO', '2016-06-23 11:49:49', NULL, 12),
(582, 'BOJAYA', '2016-06-23 11:49:49', NULL, 12),
(583, 'EL CANTON DEL SAN PABLO', '2016-06-23 11:49:49', NULL, 12),
(584, 'CARMEN DEL DARIEN', '2016-06-23 11:49:49', NULL, 12),
(585, 'CERTEGUI', '2016-06-23 11:49:49', NULL, 12),
(586, 'CONDOTO', '2016-06-23 11:49:49', NULL, 12),
(587, 'EL CARMEN DE ATRATO', '2016-06-23 11:49:49', NULL, 12),
(588, 'EL LITORAL DEL SAN JUAN', '2016-06-23 11:49:49', NULL, 12),
(589, 'ISTMINA', '2016-06-23 11:49:49', NULL, 12),
(590, 'JURADO', '2016-06-23 11:49:49', NULL, 12),
(591, 'LLORO', '2016-06-23 11:49:49', NULL, 12),
(592, 'MEDIO ATRATO', '2016-06-23 11:49:49', NULL, 12),
(593, 'MEDIO BAUDO', '2016-06-23 11:49:49', NULL, 12),
(594, 'MEDIO SAN JUAN', '2016-06-23 11:49:49', NULL, 12),
(595, 'NOVITA', '2016-06-23 11:49:49', NULL, 12),
(596, 'NUQUI', '2016-06-23 11:49:49', NULL, 12),
(597, 'RIO IRO', '2016-06-23 11:49:49', NULL, 12),
(598, 'RIO QUITO', '2016-06-23 11:49:49', NULL, 12),
(599, 'RIOSUCIO', '2016-06-23 11:49:49', NULL, 12),
(600, 'SAN JOSE DEL PALMAR', '2016-06-23 11:49:49', NULL, 12),
(601, 'SIPI', '2016-06-23 11:49:49', NULL, 12),
(602, 'TADO', '2016-06-23 11:49:49', NULL, 12),
(603, 'UNGUIA', '2016-06-23 11:49:49', NULL, 12),
(604, 'UNION PANAMERICANA', '2016-06-23 11:49:49', NULL, 12),
(605, 'NEIVA', '2016-06-23 11:49:49', NULL, 13),
(606, 'ACEVEDO', '2016-06-23 11:49:49', NULL, 13),
(607, 'AGRADO', '2016-06-23 11:49:49', NULL, 13),
(608, 'AIPE', '2016-06-23 11:49:49', NULL, 13),
(609, 'ALGECIRAS', '2016-06-23 11:49:49', NULL, 13),
(610, 'ALTAMIRA', '2016-06-23 11:49:49', NULL, 13),
(611, 'BARAYA', '2016-06-23 11:49:49', NULL, 13),
(612, 'CAMPOALEGRE', '2016-06-23 11:49:49', NULL, 13),
(613, 'COLOMBIA', '2016-06-23 11:49:49', NULL, 13),
(614, 'ELIAS', '2016-06-23 11:49:49', NULL, 13),
(615, 'GARZON', '2016-06-23 11:49:49', NULL, 13),
(616, 'GIGANTE', '2016-06-23 11:49:49', NULL, 13),
(617, 'GUADALUPE', '2016-06-23 11:49:49', NULL, 13),
(618, 'HOBO', '2016-06-23 11:49:49', NULL, 13),
(619, 'IQUIRA', '2016-06-23 11:49:49', NULL, 13),
(620, 'ISNOS', '2016-06-23 11:49:49', NULL, 13),
(621, 'LA ARGENTINA', '2016-06-23 11:49:49', NULL, 13),
(622, 'LA PLATA', '2016-06-23 11:49:49', NULL, 13),
(623, 'NATAGA', '2016-06-23 11:49:49', NULL, 13),
(624, 'OPORAPA', '2016-06-23 11:49:49', NULL, 13),
(625, 'PAICOL', '2016-06-23 11:49:49', NULL, 13),
(626, 'PALERMO', '2016-06-23 11:49:49', NULL, 13),
(627, 'PALESTINA', '2016-06-23 11:49:49', NULL, 13),
(628, 'PITAL', '2016-06-23 11:49:49', NULL, 13),
(629, 'PITALITO', '2016-06-23 11:49:49', NULL, 13),
(630, 'RIVERA', '2016-06-23 11:49:49', NULL, 13),
(631, 'SALADOBLANCO', '2016-06-23 11:49:49', NULL, 13),
(632, 'SAN AGUSTIN', '2016-06-23 11:49:49', NULL, 13),
(633, 'SANTA MARIA', '2016-06-23 11:49:49', NULL, 13),
(634, 'SUAZA', '2016-06-23 11:49:49', NULL, 13),
(635, 'TARQUI', '2016-06-23 11:49:49', NULL, 13),
(636, 'TESALIA', '2016-06-23 11:49:49', NULL, 13),
(637, 'TELLO', '2016-06-23 11:49:49', NULL, 13),
(638, 'TERUEL', '2016-06-23 11:49:49', NULL, 13),
(639, 'TIMANA', '2016-06-23 11:49:49', NULL, 13),
(640, 'VILLAVIEJA', '2016-06-23 11:49:49', NULL, 13),
(641, 'YAGUARA', '2016-06-23 11:49:49', NULL, 13),
(642, 'RIOHACHA', '2016-06-23 11:49:49', NULL, 14),
(643, 'ALBANIA', '2016-06-23 11:49:49', NULL, 14),
(644, 'BARRANCAS', '2016-06-23 11:49:49', NULL, 14),
(645, 'DIBULLA', '2016-06-23 11:49:49', NULL, 14),
(646, 'DISTRACCION', '2016-06-23 11:49:49', NULL, 14),
(647, 'EL MOLINO', '2016-06-23 11:49:49', NULL, 14),
(648, 'FONSECA', '2016-06-23 11:49:49', NULL, 14),
(649, 'HATONUEVO', '2016-06-23 11:49:49', NULL, 14),
(650, 'LA JAGUA DEL PILAR', '2016-06-23 11:49:49', NULL, 14),
(651, 'MAICAO', '2016-06-23 11:49:49', NULL, 14),
(652, 'MANAURE', '2016-06-23 11:49:49', NULL, 14),
(653, 'SAN JUAN DEL CESAR', '2016-06-23 11:49:49', NULL, 14),
(654, 'URIBIA', '2016-06-23 11:49:49', NULL, 14),
(655, 'URUMITA', '2016-06-23 11:49:49', NULL, 14),
(656, 'VILLANUEVA', '2016-06-23 11:49:49', NULL, 14),
(657, 'SANTA MARTA', '2016-06-23 11:49:49', NULL, 15),
(658, 'ALGARROBO', '2016-06-23 11:49:49', NULL, 15),
(659, 'ARACATACA', '2016-06-23 11:49:49', NULL, 15),
(660, 'ARIGUANI', '2016-06-23 11:49:49', NULL, 15),
(661, 'CERRO SAN ANTONIO', '2016-06-23 11:49:49', NULL, 15),
(662, 'CHIBOLO', '2016-06-23 11:49:49', NULL, 15),
(663, 'CIENAGA', '2016-06-23 11:49:49', NULL, 15),
(664, 'CONCORDIA', '2016-06-23 11:49:49', NULL, 15),
(665, 'EL BANCO', '2016-06-23 11:49:49', NULL, 15),
(666, 'EL PIÑON', '2016-06-23 11:49:49', NULL, 15),
(667, 'EL RETEN', '2016-06-23 11:49:49', NULL, 15),
(668, 'FUNDACION', '2016-06-23 11:49:49', NULL, 15),
(669, 'GUAMAL', '2016-06-23 11:49:49', NULL, 15),
(670, 'NUEVA GRANADA', '2016-06-23 11:49:49', NULL, 15),
(671, 'PEDRAZA', '2016-06-23 11:49:49', NULL, 15),
(672, 'PIJIÑO DEL CARMEN', '2016-06-23 11:49:49', NULL, 15),
(673, 'PIVIJAY', '2016-06-23 11:49:49', NULL, 15),
(674, 'PLATO', '2016-06-23 11:49:49', NULL, 15),
(675, 'PUEBLOVIEJO', '2016-06-23 11:49:49', NULL, 15),
(676, 'REMOLINO', '2016-06-23 11:49:49', NULL, 15),
(677, 'SABANAS DE SAN ANGEL', '2016-06-23 11:49:49', NULL, 15),
(678, 'SALAMINA', '2016-06-23 11:49:49', NULL, 15),
(679, 'SAN SEBASTIAN DE BUENAVISTA', '2016-06-23 11:49:49', NULL, 15),
(680, 'SAN ZENON', '2016-06-23 11:49:49', NULL, 15),
(681, 'SANTA ANA', '2016-06-23 11:49:49', NULL, 15),
(682, 'SANTA BARBARA DE PINTO', '2016-06-23 11:49:49', NULL, 15),
(683, 'SITIONUEVO', '2016-06-23 11:49:49', NULL, 15),
(684, 'TENERIFE', '2016-06-23 11:49:49', NULL, 15),
(685, 'ZAPAYAN', '2016-06-23 11:49:49', NULL, 15),
(686, 'ZONA BANANERA', '2016-06-23 11:49:49', NULL, 15),
(687, 'VILLAVICENCIO', '2016-06-23 11:49:49', NULL, 16),
(688, 'ACACIAS', '2016-06-23 11:49:49', NULL, 16),
(689, 'BARRANCA DE UPIA', '2016-06-23 11:49:49', NULL, 16),
(690, 'CABUYARO', '2016-06-23 11:49:49', NULL, 16),
(691, 'CASTILLA LA NUEVA', '2016-06-23 11:49:49', NULL, 16),
(692, 'CUBARRAL', '2016-06-23 11:49:49', NULL, 16),
(693, 'CUMARAL', '2016-06-23 11:49:49', NULL, 16),
(694, 'EL CALVARIO', '2016-06-23 11:49:49', NULL, 16),
(695, 'EL CASTILLO', '2016-06-23 11:49:49', NULL, 16),
(696, 'EL DORADO', '2016-06-23 11:49:49', NULL, 16),
(697, 'FUENTE DE ORO', '2016-06-23 11:49:49', NULL, 16),
(698, 'GRANADA', '2016-06-23 11:49:49', NULL, 16),
(699, 'GUAMAL', '2016-06-23 11:49:49', NULL, 16),
(700, 'MAPIRIPAN', '2016-06-23 11:49:49', NULL, 16),
(701, 'MESETAS', '2016-06-23 11:49:49', NULL, 16),
(702, 'LA MACARENA', '2016-06-23 11:49:49', NULL, 16),
(703, 'URIBE', '2016-06-23 11:49:49', NULL, 16),
(704, 'LEJANIAS', '2016-06-23 11:49:49', NULL, 16),
(705, 'PUERTO CONCORDIA', '2016-06-23 11:49:49', NULL, 16),
(706, 'PUERTO GAITAN', '2016-06-23 11:49:49', NULL, 16),
(707, 'PUERTO LOPEZ', '2016-06-23 11:49:49', NULL, 16),
(708, 'PUERTO LLERAS', '2016-06-23 11:49:49', NULL, 16),
(709, 'PUERTO RICO', '2016-06-23 11:49:49', NULL, 16),
(710, 'RESTREPO', '2016-06-23 11:49:49', NULL, 16),
(711, 'SAN CARLOS DE GUAROA', '2016-06-23 11:49:49', NULL, 16),
(712, 'SAN JUAN DE ARAMA', '2016-06-23 11:49:49', NULL, 16),
(713, 'SAN JUANITO', '2016-06-23 11:49:49', NULL, 16),
(714, 'SAN MARTIN', '2016-06-23 11:49:49', NULL, 16),
(715, 'VISTAHERMOSA', '2016-06-23 11:49:49', NULL, 16),
(716, 'PASTO', '2016-06-23 11:49:49', NULL, 17),
(717, 'ALBAN', '2016-06-23 11:49:49', NULL, 17),
(718, 'ALDANA', '2016-06-23 11:49:49', NULL, 17),
(719, 'ANCUYA', '2016-06-23 11:49:49', NULL, 17),
(720, 'ARBOLEDA', '2016-06-23 11:49:49', NULL, 17),
(721, 'BARBACOAS', '2016-06-23 11:49:49', NULL, 17),
(722, 'BELEN', '2016-06-23 11:49:49', NULL, 17),
(723, 'BUESACO', '2016-06-23 11:49:49', NULL, 17),
(724, 'COLON', '2016-06-23 11:49:49', NULL, 17),
(725, 'CONSACA', '2016-06-23 11:49:49', NULL, 17),
(726, 'CONTADERO', '2016-06-23 11:49:49', NULL, 17),
(727, 'CORDOBA', '2016-06-23 11:49:49', NULL, 17),
(728, 'CUASPUD', '2016-06-23 11:49:49', NULL, 17),
(729, 'CUMBAL', '2016-06-23 11:49:49', NULL, 17),
(730, 'CUMBITARA', '2016-06-23 11:49:49', NULL, 17),
(731, 'CHACHAGsI', '2016-06-23 11:49:49', NULL, 17),
(732, 'EL CHARCO', '2016-06-23 11:49:49', NULL, 17),
(733, 'EL PEÑOL', '2016-06-23 11:49:49', NULL, 17),
(734, 'EL ROSARIO', '2016-06-23 11:49:49', NULL, 17),
(735, 'EL TABLON DE GOMEZ', '2016-06-23 11:49:49', NULL, 17),
(736, 'EL TAMBO', '2016-06-23 11:49:49', NULL, 17),
(737, 'FUNES', '2016-06-23 11:49:49', NULL, 17),
(738, 'GUACHUCAL', '2016-06-23 11:49:49', NULL, 17),
(739, 'GUAITARILLA', '2016-06-23 11:49:49', NULL, 17),
(740, 'GUALMATAN', '2016-06-23 11:49:49', NULL, 17),
(741, 'ILES', '2016-06-23 11:49:49', NULL, 17),
(742, 'IMUES', '2016-06-23 11:49:49', NULL, 17),
(743, 'IPIALES', '2016-06-23 11:49:49', NULL, 17),
(744, 'LA CRUZ', '2016-06-23 11:49:49', NULL, 17),
(745, 'LA FLORIDA', '2016-06-23 11:49:49', NULL, 17),
(746, 'LA LLANADA', '2016-06-23 11:49:49', NULL, 17),
(747, 'LA TOLA', '2016-06-23 11:49:49', NULL, 17),
(748, 'LA UNION', '2016-06-23 11:49:49', NULL, 17),
(749, 'LEIVA', '2016-06-23 11:49:49', NULL, 17),
(750, 'LINARES', '2016-06-23 11:49:49', NULL, 17),
(751, 'LOS ANDES', '2016-06-23 11:49:49', NULL, 17),
(752, 'MAGsI', '2016-06-23 11:49:49', NULL, 17),
(753, 'MALLAMA', '2016-06-23 11:49:49', NULL, 17),
(754, 'MOSQUERA', '2016-06-23 11:49:49', NULL, 17),
(755, 'NARIÑO', '2016-06-23 11:49:49', NULL, 17),
(756, 'OLAYA HERRERA', '2016-06-23 11:49:49', NULL, 17),
(757, 'OSPINA', '2016-06-23 11:49:49', NULL, 17),
(758, 'FRANCISCO PIZARRO', '2016-06-23 11:49:49', NULL, 17),
(759, 'POLICARPA', '2016-06-23 11:49:49', NULL, 17),
(760, 'POTOSI', '2016-06-23 11:49:49', NULL, 17),
(761, 'PROVIDENCIA', '2016-06-23 11:49:49', NULL, 17),
(762, 'PUERRES', '2016-06-23 11:49:49', NULL, 17),
(763, 'PUPIALES', '2016-06-23 11:49:49', NULL, 17),
(764, 'RICAURTE', '2016-06-23 11:49:49', NULL, 17),
(765, 'ROBERTO PAYAN', '2016-06-23 11:49:49', NULL, 17),
(766, 'SAMANIEGO', '2016-06-23 11:49:49', NULL, 17),
(767, 'SANDONA', '2016-06-23 11:49:49', NULL, 17),
(768, 'SAN BERNARDO', '2016-06-23 11:49:49', NULL, 17),
(769, 'SAN LORENZO', '2016-06-23 11:49:49', NULL, 17),
(770, 'SAN PABLO', '2016-06-23 11:49:49', NULL, 17),
(771, 'SAN PEDRO DE CARTAGO', '2016-06-23 11:49:49', NULL, 17),
(772, 'SANTA BARBARA', '2016-06-23 11:49:49', NULL, 17),
(773, 'SANTACRUZ', '2016-06-23 11:49:49', NULL, 17),
(774, 'SAPUYES', '2016-06-23 11:49:49', NULL, 17),
(775, 'TAMINANGO', '2016-06-23 11:49:49', NULL, 17),
(776, 'TANGUA', '2016-06-23 11:49:49', NULL, 17),
(777, 'SAN ANDRES DE TUMACO', '2016-06-23 11:49:49', NULL, 17),
(778, 'TUQUERRES', '2016-06-23 11:49:49', NULL, 17),
(779, 'YACUANQUER', '2016-06-23 11:49:49', NULL, 17),
(780, 'CUCUTA', '2016-06-23 11:49:49', NULL, 18),
(781, 'ABREGO', '2016-06-23 11:49:49', NULL, 18),
(782, 'ARBOLEDAS', '2016-06-23 11:49:49', NULL, 18),
(783, 'BOCHALEMA', '2016-06-23 11:49:49', NULL, 18),
(784, 'BUCARASICA', '2016-06-23 11:49:49', NULL, 18),
(785, 'CACOTA', '2016-06-23 11:49:49', NULL, 18),
(786, 'CACHIRA', '2016-06-23 11:49:49', NULL, 18),
(787, 'CHINACOTA', '2016-06-23 11:49:49', NULL, 18),
(788, 'CHITAGA', '2016-06-23 11:49:49', NULL, 18),
(789, 'CONVENCION', '2016-06-23 11:49:49', NULL, 18),
(790, 'CUCUTILLA', '2016-06-23 11:49:49', NULL, 18),
(791, 'DURANIA', '2016-06-23 11:49:49', NULL, 18),
(792, 'EL CARMEN', '2016-06-23 11:49:49', NULL, 18),
(793, 'EL TARRA', '2016-06-23 11:49:49', NULL, 18),
(794, 'EL ZULIA', '2016-06-23 11:49:49', NULL, 18),
(795, 'GRAMALOTE', '2016-06-23 11:49:49', NULL, 18),
(796, 'HACARI', '2016-06-23 11:49:49', NULL, 18),
(797, 'HERRAN', '2016-06-23 11:49:49', NULL, 18),
(798, 'LABATECA', '2016-06-23 11:49:49', NULL, 18),
(799, 'LA ESPERANZA', '2016-06-23 11:49:49', NULL, 18),
(800, 'LA PLAYA', '2016-06-23 11:49:49', NULL, 18),
(801, 'LOS PATIOS', '2016-06-23 11:49:49', NULL, 18),
(802, 'LOURDES', '2016-06-23 11:49:49', NULL, 18),
(803, 'MUTISCUA', '2016-06-23 11:49:49', NULL, 18),
(804, 'OCAÑA', '2016-06-23 11:49:49', NULL, 18),
(805, 'PAMPLONA', '2016-06-23 11:49:49', NULL, 18),
(806, 'PAMPLONITA', '2016-06-23 11:49:49', NULL, 18),
(807, 'PUERTO SANTANDER', '2016-06-23 11:49:49', NULL, 18),
(808, 'RAGONVALIA', '2016-06-23 11:49:49', NULL, 18),
(809, 'SALAZAR', '2016-06-23 11:49:49', NULL, 18),
(810, 'SAN CALIXTO', '2016-06-23 11:49:49', NULL, 18),
(811, 'SAN CAYETANO', '2016-06-23 11:49:49', NULL, 18),
(812, 'SANTIAGO', '2016-06-23 11:49:49', NULL, 18),
(813, 'SARDINATA', '2016-06-23 11:49:49', NULL, 18),
(814, 'SILOS', '2016-06-23 11:49:49', NULL, 18),
(815, 'TEORAMA', '2016-06-23 11:49:49', NULL, 18),
(816, 'TIBU', '2016-06-23 11:49:49', NULL, 18),
(817, 'TOLEDO', '2016-06-23 11:49:49', NULL, 18),
(818, 'VILLA CARO', '2016-06-23 11:49:49', NULL, 18),
(819, 'VILLA DEL ROSARIO', '2016-06-23 11:49:49', NULL, 18),
(820, 'ARMENIA', '2016-06-23 11:49:49', NULL, 19),
(821, 'BUENAVISTA', '2016-06-23 11:49:49', NULL, 19),
(822, 'CALARCA', '2016-06-23 11:49:49', NULL, 19),
(823, 'CIRCASIA', '2016-06-23 11:49:49', NULL, 19),
(824, 'CORDOBA', '2016-06-23 11:49:49', NULL, 19),
(825, 'FILANDIA', '2016-06-23 11:49:49', NULL, 19),
(826, 'GENOVA', '2016-06-23 11:49:49', NULL, 19),
(827, 'LA TEBAIDA', '2016-06-23 11:49:49', NULL, 19),
(828, 'MONTENEGRO', '2016-06-23 11:49:49', NULL, 19),
(829, 'PIJAO', '2016-06-23 11:49:49', NULL, 19),
(830, 'QUIMBAYA', '2016-06-23 11:49:49', NULL, 19),
(831, 'SALENTO', '2016-06-23 11:49:49', NULL, 19),
(832, 'PEREIRA', '2016-06-23 11:49:49', NULL, 20),
(833, 'APIA', '2016-06-23 11:49:49', NULL, 20),
(834, 'BALBOA', '2016-06-23 11:49:49', NULL, 20),
(835, 'BELEN DE UMBRIA', '2016-06-23 11:49:49', NULL, 20),
(836, 'DOSQUEBRADAS', '2016-06-23 11:49:49', NULL, 20),
(837, 'GUATICA', '2016-06-23 11:49:49', NULL, 20),
(838, 'LA CELIA', '2016-06-23 11:49:49', NULL, 20),
(839, 'LA VIRGINIA', '2016-06-23 11:49:49', NULL, 20),
(840, 'MARSELLA', '2016-06-23 11:49:49', NULL, 20),
(841, 'MISTRATO', '2016-06-23 11:49:49', NULL, 20),
(842, 'PUEBLO RICO', '2016-06-23 11:49:49', NULL, 20),
(843, 'QUINCHIA', '2016-06-23 11:49:49', NULL, 20),
(844, 'SANTA ROSA DE CABAL', '2016-06-23 11:49:49', NULL, 20),
(845, 'SANTUARIO', '2016-06-23 11:49:49', NULL, 20),
(846, 'BUCARAMANGA', '2016-06-23 11:49:49', NULL, 21),
(847, 'AGUADA', '2016-06-23 11:49:49', NULL, 21),
(848, 'ALBANIA', '2016-06-23 11:49:49', NULL, 21),
(849, 'ARATOCA', '2016-06-23 11:49:49', NULL, 21),
(850, 'BARBOSA', '2016-06-23 11:49:49', NULL, 21),
(851, 'BARICHARA', '2016-06-23 11:49:49', NULL, 21),
(852, 'BARRANCABERMEJA', '2016-06-23 11:49:49', NULL, 21),
(853, 'BETULIA', '2016-06-23 11:49:49', NULL, 21),
(854, 'BOLIVAR', '2016-06-23 11:49:49', NULL, 21),
(855, 'CABRERA', '2016-06-23 11:49:49', NULL, 21),
(856, 'CALIFORNIA', '2016-06-23 11:49:49', NULL, 21),
(857, 'CAPITANEJO', '2016-06-23 11:49:49', NULL, 21),
(858, 'CARCASI', '2016-06-23 11:49:49', NULL, 21),
(859, 'CEPITA', '2016-06-23 11:49:49', NULL, 21),
(860, 'CERRITO', '2016-06-23 11:49:49', NULL, 21),
(861, 'CHARALA', '2016-06-23 11:49:49', NULL, 21),
(862, 'CHARTA', '2016-06-23 11:49:49', NULL, 21),
(863, 'CHIMA', '2016-06-23 11:49:49', NULL, 21),
(864, 'CHIPATA', '2016-06-23 11:49:49', NULL, 21),
(865, 'CIMITARRA', '2016-06-23 11:49:49', NULL, 21),
(866, 'CONCEPCION', '2016-06-23 11:49:49', NULL, 21),
(867, 'CONFINES', '2016-06-23 11:49:49', NULL, 21),
(868, 'CONTRATACION', '2016-06-23 11:49:49', NULL, 21),
(869, 'COROMORO', '2016-06-23 11:49:49', NULL, 21),
(870, 'CURITI', '2016-06-23 11:49:49', NULL, 21),
(871, 'EL CARMEN DE CHUCURI', '2016-06-23 11:49:49', NULL, 21),
(872, 'EL GUACAMAYO', '2016-06-23 11:49:49', NULL, 21),
(873, 'EL PEÑON', '2016-06-23 11:49:49', NULL, 21),
(874, 'EL PLAYON', '2016-06-23 11:49:49', NULL, 21),
(875, 'ENCINO', '2016-06-23 11:49:49', NULL, 21),
(876, 'ENCISO', '2016-06-23 11:49:49', NULL, 21),
(877, 'FLORIAN', '2016-06-23 11:49:49', NULL, 21),
(878, 'FLORIDABLANCA', '2016-06-23 11:49:49', NULL, 21),
(879, 'GALAN', '2016-06-23 11:49:49', NULL, 21),
(880, 'GAMBITA', '2016-06-23 11:49:49', NULL, 21),
(881, 'GIRON', '2016-06-23 11:49:49', NULL, 21),
(882, 'GUACA', '2016-06-23 11:49:49', NULL, 21),
(883, 'GUADALUPE', '2016-06-23 11:49:49', NULL, 21),
(884, 'GUAPOTA', '2016-06-23 11:49:49', NULL, 21),
(885, 'GUAVATA', '2016-06-23 11:49:49', NULL, 21),
(886, 'GsEPSA', '2016-06-23 11:49:49', NULL, 21),
(887, 'HATO', '2016-06-23 11:49:49', NULL, 21),
(888, 'JESUS MARIA', '2016-06-23 11:49:49', NULL, 21),
(889, 'JORDAN', '2016-06-23 11:49:49', NULL, 21),
(890, 'LA BELLEZA', '2016-06-23 11:49:49', NULL, 21),
(891, 'LANDAZURI', '2016-06-23 11:49:49', NULL, 21),
(892, 'LA PAZ', '2016-06-23 11:49:49', NULL, 21),
(893, 'LEBRIJA', '2016-06-23 11:49:49', NULL, 21),
(894, 'LOS SANTOS', '2016-06-23 11:49:49', NULL, 21),
(895, 'MACARAVITA', '2016-06-23 11:49:49', NULL, 21),
(896, 'MALAGA', '2016-06-23 11:49:49', NULL, 21),
(897, 'MATANZA', '2016-06-23 11:49:49', NULL, 21),
(898, 'MOGOTES', '2016-06-23 11:49:49', NULL, 21),
(899, 'MOLAGAVITA', '2016-06-23 11:49:49', NULL, 21),
(900, 'OCAMONTE', '2016-06-23 11:49:49', NULL, 21),
(901, 'OIBA', '2016-06-23 11:49:49', NULL, 21),
(902, 'ONZAGA', '2016-06-23 11:49:49', NULL, 21),
(903, 'PALMAR', '2016-06-23 11:49:49', NULL, 21),
(904, 'PALMAS DEL SOCORRO', '2016-06-23 11:49:49', NULL, 21),
(905, 'PARAMO', '2016-06-23 11:49:49', NULL, 21),
(906, 'PIEDECUESTA', '2016-06-23 11:49:49', NULL, 21),
(907, 'PINCHOTE', '2016-06-23 11:49:49', NULL, 21),
(908, 'PUENTE NACIONAL', '2016-06-23 11:49:49', NULL, 21),
(909, 'PUERTO PARRA', '2016-06-23 11:49:49', NULL, 21),
(910, 'PUERTO WILCHES', '2016-06-23 11:49:49', NULL, 21),
(911, 'RIONEGRO', '2016-06-23 11:49:49', NULL, 21),
(912, 'SABANA DE TORRES', '2016-06-23 11:49:49', NULL, 21),
(913, 'SAN ANDRES', '2016-06-23 11:49:49', NULL, 21),
(914, 'SAN BENITO', '2016-06-23 11:49:49', NULL, 21),
(915, 'SAN GIL', '2016-06-23 11:49:49', NULL, 21),
(916, 'SAN JOAQUIN', '2016-06-23 11:49:49', NULL, 21),
(917, 'SAN JOSE DE MIRANDA', '2016-06-23 11:49:49', NULL, 21),
(918, 'SAN MIGUEL', '2016-06-23 11:49:49', NULL, 21),
(919, 'SAN VICENTE DE CHUCURI', '2016-06-23 11:49:49', NULL, 21),
(920, 'SANTA BARBARA', '2016-06-23 11:49:49', NULL, 21),
(921, 'SANTA HELENA DEL OPON', '2016-06-23 11:49:49', NULL, 21),
(922, 'SIMACOTA', '2016-06-23 11:49:49', NULL, 21),
(923, 'SOCORRO', '2016-06-23 11:49:49', NULL, 21),
(924, 'SUAITA', '2016-06-23 11:49:49', NULL, 21),
(925, 'SUCRE', '2016-06-23 11:49:49', NULL, 21),
(926, 'SURATA', '2016-06-23 11:49:49', NULL, 21),
(927, 'TONA', '2016-06-23 11:49:49', NULL, 21),
(928, 'VALLE DE SAN JOSE', '2016-06-23 11:49:49', NULL, 21),
(929, 'VELEZ', '2016-06-23 11:49:49', NULL, 21),
(930, 'VETAS', '2016-06-23 11:49:49', NULL, 21),
(931, 'VILLANUEVA', '2016-06-23 11:49:49', NULL, 21),
(932, 'ZAPATOCA', '2016-06-23 11:49:49', NULL, 21),
(933, 'SINCELEJO', '2016-06-23 11:49:49', NULL, 22),
(934, 'BUENAVISTA', '2016-06-23 11:49:49', NULL, 22),
(935, 'CAIMITO', '2016-06-23 11:49:49', NULL, 22),
(936, 'COLOSO', '2016-06-23 11:49:49', NULL, 22),
(937, 'COROZAL', '2016-06-23 11:49:49', NULL, 22),
(938, 'COVEÑAS', '2016-06-23 11:49:49', NULL, 22),
(939, 'CHALAN', '2016-06-23 11:49:49', NULL, 22),
(940, 'EL ROBLE', '2016-06-23 11:49:49', NULL, 22),
(941, 'GALERAS', '2016-06-23 11:49:49', NULL, 22),
(942, 'GUARANDA', '2016-06-23 11:49:49', NULL, 22),
(943, 'LA UNION', '2016-06-23 11:49:49', NULL, 22),
(944, 'LOS PALMITOS', '2016-06-23 11:49:49', NULL, 22),
(945, 'MAJAGUAL', '2016-06-23 11:49:49', NULL, 22),
(946, 'MORROA', '2016-06-23 11:49:49', NULL, 22),
(947, 'OVEJAS', '2016-06-23 11:49:49', NULL, 22),
(948, 'PALMITO', '2016-06-23 11:49:49', NULL, 22),
(949, 'SAMPUES', '2016-06-23 11:49:49', NULL, 22),
(950, 'SAN BENITO ABAD', '2016-06-23 11:49:49', NULL, 22),
(951, 'SAN JUAN DE BETULIA', '2016-06-23 11:49:49', NULL, 22),
(952, 'SAN MARCOS', '2016-06-23 11:49:49', NULL, 22),
(953, 'SAN ONOFRE', '2016-06-23 11:49:49', NULL, 22),
(954, 'SAN PEDRO', '2016-06-23 11:49:49', NULL, 22),
(955, 'SAN LUIS DE SINCE', '2016-06-23 11:49:49', NULL, 22),
(956, 'SUCRE', '2016-06-23 11:49:49', NULL, 22),
(957, 'SANTIAGO DE TOLU', '2016-06-23 11:49:49', NULL, 22),
(958, 'TOLU VIEJO', '2016-06-23 11:49:49', NULL, 22),
(959, 'IBAGUE', '2016-06-23 11:49:49', NULL, 23),
(960, 'ALPUJARRA', '2016-06-23 11:49:49', NULL, 23),
(961, 'ALVARADO', '2016-06-23 11:49:49', NULL, 23),
(962, 'AMBALEMA', '2016-06-23 11:49:49', NULL, 23),
(963, 'ANZOATEGUI', '2016-06-23 11:49:49', NULL, 23),
(964, 'ARMERO', '2016-06-23 11:49:49', NULL, 23),
(965, 'ATACO', '2016-06-23 11:49:49', NULL, 23),
(966, 'CAJAMARCA', '2016-06-23 11:49:49', NULL, 23),
(967, 'CARMEN DE APICALA', '2016-06-23 11:49:49', NULL, 23),
(968, 'CASABIANCA', '2016-06-23 11:49:49', NULL, 23),
(969, 'CHAPARRAL', '2016-06-23 11:49:49', NULL, 23),
(970, 'COELLO', '2016-06-23 11:49:49', NULL, 23),
(971, 'COYAIMA', '2016-06-23 11:49:49', NULL, 23),
(972, 'CUNDAY', '2016-06-23 11:49:49', NULL, 23),
(973, 'DOLORES', '2016-06-23 11:49:49', NULL, 23),
(974, 'ESPINAL', '2016-06-23 11:49:49', NULL, 23),
(975, 'FALAN', '2016-06-23 11:49:49', NULL, 23),
(976, 'FLANDES', '2016-06-23 11:49:49', NULL, 23),
(977, 'FRESNO', '2016-06-23 11:49:49', NULL, 23),
(978, 'GUAMO', '2016-06-23 11:49:49', NULL, 23),
(979, 'HERVEO', '2016-06-23 11:49:49', NULL, 23),
(980, 'HONDA', '2016-06-23 11:49:49', NULL, 23),
(981, 'ICONONZO', '2016-06-23 11:49:49', NULL, 23),
(982, 'LERIDA', '2016-06-23 11:49:49', NULL, 23),
(983, 'LIBANO', '2016-06-23 11:49:49', NULL, 23),
(984, 'MARIQUITA', '2016-06-23 11:49:49', NULL, 23),
(985, 'MELGAR', '2016-06-23 11:49:49', NULL, 23),
(986, 'MURILLO', '2016-06-23 11:49:49', NULL, 23),
(987, 'NATAGAIMA', '2016-06-23 11:49:49', NULL, 23),
(988, 'ORTEGA', '2016-06-23 11:49:49', NULL, 23),
(989, 'PALOCABILDO', '2016-06-23 11:49:49', NULL, 23),
(990, 'PIEDRAS', '2016-06-23 11:49:49', NULL, 23),
(991, 'PLANADAS', '2016-06-23 11:49:49', NULL, 23);
INSERT INTO `ciudad` (`id`, `ciudad`, `created_at`, `deleted_at`, `departamento_id`) VALUES
(992, 'PRADO', '2016-06-23 11:49:49', NULL, 23),
(993, 'PURIFICACION', '2016-06-23 11:49:49', NULL, 23),
(994, 'RIOBLANCO', '2016-06-23 11:49:49', NULL, 23),
(995, 'RONCESVALLES', '2016-06-23 11:49:49', NULL, 23),
(996, 'ROVIRA', '2016-06-23 11:49:49', NULL, 23),
(997, 'SALDAÑA', '2016-06-23 11:49:49', NULL, 23),
(998, 'SAN ANTONIO', '2016-06-23 11:49:49', NULL, 23),
(999, 'SAN LUIS', '2016-06-23 11:49:49', NULL, 23),
(1000, 'SANTA ISABEL', '2016-06-23 11:49:49', NULL, 23),
(1001, 'SUAREZ', '2016-06-23 11:49:49', NULL, 23),
(1002, 'VALLE DE SAN JUAN', '2016-06-23 11:49:49', NULL, 23),
(1003, 'VENADILLO', '2016-06-23 11:49:49', NULL, 23),
(1004, 'VILLAHERMOSA', '2016-06-23 11:49:49', NULL, 23),
(1005, 'VILLARRICA', '2016-06-23 11:49:49', NULL, 23),
(1006, 'GUACHENE', '2016-06-23 11:49:49', NULL, 8),
(1007, 'ALCALA', '2016-06-23 11:49:49', NULL, 1),
(1008, 'ABEJORRAL', '2016-06-23 11:49:49', NULL, 24),
(1009, 'ANSERMANUEVO', '2016-06-23 11:49:49', NULL, 1),
(1010, 'ARGELIA', '2016-06-23 11:49:49', NULL, 1),
(1011, 'BOLIVAR', '2016-06-23 11:49:49', NULL, 1),
(1012, 'BUENAVENTURA', '2016-06-23 11:49:49', NULL, 1),
(1013, 'AMALFI', '2016-06-23 11:49:49', NULL, 24),
(1014, 'ABRIAQUI', '2016-06-23 11:49:49', NULL, 24),
(1015, 'CAICEDONIA', '2016-06-23 11:49:49', NULL, 1),
(1016, 'CALIMA', '2016-06-23 11:49:49', NULL, 1),
(1017, 'CANDELARIA', '2016-06-23 11:49:49', NULL, 1),
(1018, 'CARTAGO', '2016-06-23 11:49:49', NULL, 1),
(1019, 'DAGUA', '2016-06-23 11:49:49', NULL, 1),
(1020, 'EL AGUILA', '2016-06-23 11:49:49', NULL, 1),
(1021, 'EL CAIRO', '2016-06-23 11:49:49', NULL, 1),
(1022, 'EL CERRITO', '2016-06-23 11:49:49', NULL, 1),
(1023, 'EL DOVIO', '2016-06-23 11:49:49', NULL, 1),
(1024, 'FLORIDA', '2016-06-23 11:49:49', NULL, 1),
(1025, 'GINEBRA', '2016-06-23 11:49:49', NULL, 1),
(1026, 'GUACARI', '2016-06-23 11:49:49', NULL, 1),
(1027, 'JAMUNDI', '2016-06-23 11:49:49', NULL, 1),
(1028, 'LA CUMBRE', '2016-06-23 11:49:49', NULL, 1),
(1029, 'LA UNION', '2016-06-23 11:49:49', NULL, 1),
(1030, 'LA VICTORIA', '2016-06-23 11:49:49', NULL, 1),
(1031, 'OBANDO', '2016-06-23 11:49:49', NULL, 1),
(1032, 'PACOA', '2016-06-23 11:49:49', NULL, 32),
(1033, 'PRADERA', '2016-06-23 11:49:49', NULL, 1),
(1034, 'RESTREPO', '2016-06-23 11:49:49', NULL, 1),
(1035, 'AMAGA', '2016-06-23 11:49:49', NULL, 24),
(1036, 'ROLDANILLO', '2016-06-23 11:49:49', NULL, 1),
(1037, 'SAN PEDRO', '2016-06-23 11:49:49', NULL, 1),
(1038, 'SEVILLA', '2016-06-23 11:49:49', NULL, 1),
(1039, 'TORO', '2016-06-23 11:49:49', NULL, 1),
(1040, 'TRUJILLO', '2016-06-23 11:49:49', NULL, 1),
(1041, 'LA VICTORIA', '2016-06-23 11:49:49', NULL, 29),
(1042, 'ULLOA', '2016-06-23 11:49:49', NULL, 1),
(1043, 'VERSALLES', '2016-06-23 11:49:49', NULL, 1),
(1044, 'VIJES', '2016-06-23 11:49:49', NULL, 1),
(1045, 'YOTOCO', '2016-06-23 11:49:49', NULL, 1),
(1046, 'YUMBO', '2016-06-23 11:49:49', NULL, 1),
(1047, 'ALEJANDRIA', '2016-06-23 11:49:49', NULL, 24),
(1048, 'ARAUCA', '2016-06-23 11:49:49', NULL, 25),
(1049, 'ARAUQUITA', '2016-06-23 11:49:49', NULL, 25),
(1050, 'CRAVO NORTE', '2016-06-23 11:49:49', NULL, 25),
(1051, 'FORTUL', '2016-06-23 11:49:49', NULL, 25),
(1052, 'PUERTO RONDON', '2016-06-23 11:49:49', NULL, 25),
(1053, 'SARAVENA', '2016-06-23 11:49:49', NULL, 25),
(1054, 'TAME', '2016-06-23 11:49:49', NULL, 25),
(1055, 'YOPAL', '2016-06-23 11:49:49', NULL, 26),
(1056, 'AGUAZUL', '2016-06-23 11:49:49', NULL, 26),
(1057, 'CHAMEZA', '2016-06-23 11:49:49', NULL, 26),
(1058, 'HATO COROZAL', '2016-06-23 11:49:49', NULL, 26),
(1059, 'LA SALINA', '2016-06-23 11:49:49', NULL, 26),
(1060, 'MANI', '2016-06-23 11:49:49', NULL, 26),
(1061, 'MONTERREY', '2016-06-23 11:49:49', NULL, 26),
(1062, 'NUNCHIA', '2016-06-23 11:49:49', NULL, 26),
(1063, 'OROCUE', '2016-06-23 11:49:49', NULL, 26),
(1064, 'PAZ DE ARIPORO', '2016-06-23 11:49:49', NULL, 26),
(1065, 'PORE', '2016-06-23 11:49:49', NULL, 26),
(1066, 'RECETOR', '2016-06-23 11:49:49', NULL, 26),
(1067, 'SABANALARGA', '2016-06-23 11:49:49', NULL, 26),
(1068, 'SACAMA', '2016-06-23 11:49:49', NULL, 26),
(1069, 'SAN LUIS DE PALENQUE', '2016-06-23 11:49:49', NULL, 26),
(1070, 'TAMARA', '2016-06-23 11:49:49', NULL, 26),
(1071, 'TAURAMENA', '2016-06-23 11:49:49', NULL, 26),
(1072, 'TRINIDAD', '2016-06-23 11:49:49', NULL, 26),
(1073, 'VILLANUEVA', '2016-06-23 11:49:49', NULL, 26),
(1074, 'MOCOA', '2016-06-23 11:49:49', NULL, 27),
(1075, 'COLON', '2016-06-23 11:49:49', NULL, 27),
(1076, 'ORITO', '2016-06-23 11:49:49', NULL, 27),
(1077, 'PUERTO ASIS', '2016-06-23 11:49:49', NULL, 27),
(1078, 'PUERTO CAICEDO', '2016-06-23 11:49:49', NULL, 27),
(1079, 'PUERTO GUZMAN', '2016-06-23 11:49:49', NULL, 27),
(1080, 'LEGUIZAMO', '2016-06-23 11:49:49', NULL, 27),
(1081, 'SIBUNDOY', '2016-06-23 11:49:49', NULL, 27),
(1082, 'SAN FRANCISCO', '2016-06-23 11:49:49', NULL, 27),
(1083, 'SAN MIGUEL', '2016-06-23 11:49:49', NULL, 27),
(1084, 'SANTIAGO', '2016-06-23 11:49:49', NULL, 27),
(1085, 'VALLE DEL GUAMUEZ', '2016-06-23 11:49:49', NULL, 27),
(1086, 'VILLAGARZON', '2016-06-23 11:49:49', NULL, 27),
(1087, 'SAN ANDRES', '2016-06-23 11:49:49', NULL, 28),
(1088, 'PROVIDENCIA', '2016-06-23 11:49:49', NULL, 28),
(1089, 'LETICIA', '2016-06-23 11:49:49', NULL, 29),
(1090, 'EL ENCANTO', '2016-06-23 11:49:49', NULL, 29),
(1091, 'LA CHORRERA', '2016-06-23 11:49:49', NULL, 29),
(1092, 'LA PEDRERA', '2016-06-23 11:49:49', NULL, 29),
(1093, 'MIRITI - PARANA', '2016-06-23 11:49:49', NULL, 29),
(1094, 'PUERTO ALEGRIA', '2016-06-23 11:49:49', NULL, 29),
(1095, 'PUERTO ARICA', '2016-06-23 11:49:49', NULL, 29),
(1096, 'PUERTO NARIÑO', '2016-06-23 11:49:49', NULL, 29),
(1097, 'PUERTO SANTANDER', '2016-06-23 11:49:49', NULL, 29),
(1098, 'TARAPACA', '2016-06-23 11:49:49', NULL, 29),
(1099, 'MAPIRIPANA', '2016-06-23 11:49:49', NULL, 30),
(1100, 'PANA PANA', '2016-06-23 11:49:49', NULL, 30),
(1101, 'MORICHAL', '2016-06-23 11:49:49', NULL, 30),
(1102, 'INIRIDA', '2016-06-23 11:49:49', NULL, 30),
(1103, 'BARRANCO MINAS', '2016-06-23 11:49:49', NULL, 30),
(1104, 'SAN FELIPE', '2016-06-23 11:49:49', NULL, 30),
(1105, 'PUERTO COLOMBIA', '2016-06-23 11:49:49', NULL, 30),
(1106, 'LA GUADALUPE', '2016-06-23 11:49:49', NULL, 30),
(1107, 'CACAHUAL', '2016-06-23 11:49:49', NULL, 30),
(1108, 'SAN JOSE DEL GUAVIARE', '2016-06-23 11:49:49', NULL, 31),
(1109, 'CALAMAR', '2016-06-23 11:49:49', NULL, 31),
(1110, 'EL RETORNO', '2016-06-23 11:49:49', NULL, 31),
(1111, 'MIRAFLORES', '2016-06-23 11:49:49', NULL, 31),
(1112, 'MITU', '2016-06-23 11:49:49', NULL, 32),
(1113, 'CARURU', '2016-06-23 11:49:49', NULL, 32),
(1114, 'TARAIRA', '2016-06-23 11:49:49', NULL, 32),
(1115, 'PAPUNAUA', '2016-06-23 11:49:49', NULL, 32),
(1116, 'YAVARATE', '2016-06-23 11:49:49', NULL, 32),
(1117, 'PUERTO CARREÑO', '2016-06-23 11:49:49', NULL, 33),
(1118, 'LA PRIMAVERA', '2016-06-23 11:49:49', NULL, 33),
(1119, 'SANTA ROSALIA', '2016-06-23 11:49:49', NULL, 33),
(1120, 'CUMARIBO', '2016-06-23 11:49:49', NULL, 33);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `concepto`
--

DROP TABLE IF EXISTS `concepto`;
CREATE TABLE IF NOT EXISTS `concepto` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `descripcion` varchar(255) DEFAULT NULL,
  `control_entrada` tinyint(1) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `requiere_programa` tinyint(1) DEFAULT '0',
  `concepto_pago` int(11) DEFAULT NULL COMMENT '1=Gasto, 2=Ingreso y  3= Ambos',
  `is_factura` tinyint(1) DEFAULT '0' COMMENT 'Cero es un concepto para facturación, 1 no se usa para facturación',
  `concepto_recibo` tinyint(1) NOT NULL DEFAULT '0',
  `sin_factura` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=85 DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `concepto`
--

INSERT INTO `concepto` (`id`, `descripcion`, `control_entrada`, `created_at`, `deleted_at`, `requiere_programa`, `concepto_pago`, `is_factura`, `concepto_recibo`, `sin_factura`) VALUES
(1, 'Matrícula', 1, '2017-05-15 18:02:40', NULL, 0, NULL, 0, 0, 0),
(2, 'Cuota', 1, '2016-11-22 20:31:40', NULL, 0, NULL, 0, 0, 0),
(3, 'Estampilla', 0, '2017-06-25 01:35:47', NULL, 0, NULL, 0, 0, 0),
(4, 'Carnet Estudiantil', 0, '2016-11-22 20:31:42', NULL, 0, NULL, 0, 0, 0),
(5, 'Uniforme', 0, '2016-11-22 20:31:43', NULL, 0, NULL, 0, 0, 0),
(6, 'Inscripción', 1, '2017-06-05 22:56:53', NULL, 0, NULL, 0, 0, 0),
(7, 'Seguro AP', 0, '2016-11-22 20:31:45', '2017-06-10 13:33:43', 0, NULL, 0, 0, 0),
(8, 'Seguro Rb', 0, '2016-11-22 20:31:46', NULL, 0, NULL, 0, 0, 0),
(9, 'Seguro RCP', 0, '2016-11-22 20:31:47', '2017-06-10 13:35:26', 0, NULL, 0, 0, 0),
(10, 'Certificado', 1, '2017-06-06 00:46:26', NULL, 0, NULL, 0, 0, 1),
(11, 'Habilitación', 0, '2017-09-21 21:06:53', NULL, 0, NULL, 0, 0, 1),
(12, 'Diploma', 0, '2016-11-22 20:31:50', NULL, 0, NULL, 0, 0, 0),
(13, 'Supletorios', 0, '2016-11-22 20:31:51', NULL, 0, NULL, 0, 0, 1),
(14, 'Homologaciones', 0, '2016-11-22 20:31:52', NULL, 0, NULL, 0, 0, 0),
(15, 'Repeticiones', 1, '2016-11-22 20:31:53', NULL, 0, NULL, 0, 0, 0),
(16, 'Prepractico', 0, '2016-11-22 20:31:54', '2017-06-28 02:51:16', 0, NULL, 0, 0, 0),
(17, 'Diplomado', 0, '2017-09-28 22:41:29', NULL, 0, NULL, 0, 0, 0),
(18, 'Seguro Desempleo', 0, '2016-11-22 20:31:56', '2017-06-28 02:50:58', 0, NULL, 0, 0, 0),
(19, 'Biblioteca', 0, '2016-11-22 20:31:57', '2017-06-28 02:50:48', 0, NULL, 0, 0, 0),
(20, 'Transporte', NULL, '2017-06-27 20:31:57', NULL, 0, 1, 1, 0, 0),
(21, 'Parqueadero', NULL, '2017-06-27 20:31:57', NULL, 0, 1, 1, 0, 0),
(22, 'Viaticos', NULL, '2017-06-27 20:31:57', NULL, 0, 1, 1, 0, 0),
(23, 'Nomina Empleados', NULL, '2017-06-27 20:31:57', NULL, 0, 1, 1, 0, 0),
(24, 'Nomina Profesores', NULL, '2017-10-24 00:52:38', NULL, 0, 1, 1, 0, 0),
(25, 'P.I.L.A.', NULL, '2017-06-27 20:31:57', NULL, 0, 1, 1, 0, 0),
(26, 'Carnés', NULL, '2017-06-27 20:31:57', NULL, 0, 1, 1, 0, 0),
(27, 'Polizas Seguros Rb Y Rcp', NULL, '2017-06-27 20:31:57', NULL, 0, 1, 1, 0, 0),
(28, 'Uniformes', NULL, '2017-06-27 20:31:57', NULL, 0, 1, 1, 0, 0),
(29, 'Servicios Agua - Energia', NULL, '2017-06-27 20:31:57', NULL, 0, 1, 1, 0, 0),
(30, 'Telefonos', NULL, '2017-06-27 20:31:57', NULL, 0, 1, 1, 0, 0),
(31, 'Celular Y Recargas', NULL, '2017-06-27 20:31:57', NULL, 0, 1, 1, 0, 0),
(32, 'Publicidad Directorio Publicar', NULL, '2017-06-27 20:31:57', NULL, 0, 1, 1, 0, 0),
(33, 'Publicidad Carteles', NULL, '2017-06-27 20:31:57', NULL, 0, 1, 1, 0, 0),
(34, 'Publicidad Periodicos', NULL, '2017-06-27 20:31:57', NULL, 0, 1, 1, 0, 0),
(35, 'Publicidad Acierto', NULL, '2017-06-27 20:31:57', NULL, 0, 1, 1, 0, 0),
(36, 'Publicidad Alquiler Murales', NULL, '2017-06-27 20:31:57', NULL, 0, 1, 1, 0, 0),
(37, 'Publicidad Radio', NULL, '2017-06-27 20:31:57', NULL, 0, 1, 1, 0, 0),
(38, 'Litografia Carpetas', NULL, '2017-06-27 20:31:57', NULL, 0, 1, 1, 0, 0),
(39, 'Litografia Flyers', NULL, '2017-06-27 20:31:57', NULL, 0, 1, 1, 0, 0),
(40, 'Litografia Volantes', NULL, '2017-06-27 20:31:57', NULL, 0, 1, 1, 0, 0),
(41, 'Litografia Hojas Membreteada', NULL, '2017-06-27 20:31:57', NULL, 0, 1, 1, 0, 0),
(42, 'Litografia Diplomas', NULL, '2017-06-27 20:31:57', NULL, 0, 1, 1, 0, 0),
(43, 'Litografia Otros', NULL, '2017-06-27 20:31:57', NULL, 0, 1, 1, 0, 0),
(44, 'Papeleria Gral.', NULL, '2017-06-27 20:31:57', NULL, 0, 1, 1, 0, 0),
(45, 'Fotocopias', NULL, '2017-06-27 20:31:57', NULL, 0, 1, 1, 0, 0),
(46, 'Gastos Fotocopiadora', NULL, '2017-06-27 20:31:57', NULL, 0, 1, 1, 0, 0),
(47, 'Mejoras Locativas   (Pint.Arregl,Adornos.Etc)', NULL, '2017-08-10 15:57:55', NULL, 1, 1, 1, 0, 0),
(48, 'Insumos Sala Sistemas', NULL, '2017-08-10 15:57:41', NULL, 1, 1, 1, 0, 0),
(49, 'Insumos Biblioteca', NULL, '2017-06-27 20:31:57', NULL, 0, 1, 1, 0, 0),
(50, 'Implementos Educativos Tabler.Pupitres.Multimedia', NULL, '2017-08-10 15:57:18', NULL, 1, 1, 1, 0, 0),
(51, 'Implementos De Oficina (Comput.Pbx.Fax.Fotoc.)', NULL, '2017-06-27 20:31:57', NULL, 0, 1, 1, 0, 0),
(52, 'Vehiculos. Terrenos', NULL, '2017-06-27 20:31:57', NULL, 0, 1, 1, 0, 0),
(53, 'Equipos Lab. Veterinaria', NULL, '2017-08-10 15:56:32', NULL, 1, 1, 1, 0, 0),
(54, 'Equipos Lab. Enfermería Y Fisioterapia', NULL, '2017-08-10 15:56:26', NULL, 1, 1, 1, 0, 0),
(55, 'Equipos Otros Programas', NULL, '2017-08-10 15:56:45', NULL, 1, 1, 1, 0, 0),
(56, 'Equipos Sala Sistemas', NULL, '2017-08-10 15:56:53', NULL, 1, 1, 1, 0, 0),
(57, 'Equipamiento Biblioteca', NULL, '2017-08-10 15:56:14', NULL, 1, 1, 1, 0, 0),
(58, 'Contraprestaciones ', NULL, '2017-06-27 20:31:57', NULL, 0, 1, 1, 0, 0),
(59, 'Donaciones', NULL, '2017-06-27 20:31:57', NULL, 0, 1, 1, 0, 0),
(60, 'Devolucion Matriculas', NULL, '2017-11-07 14:52:11', NULL, 0, 1, 1, 0, 0),
(61, 'Obligaciones Financieras', NULL, '2017-06-27 20:31:57', NULL, 0, 1, 1, 0, 0),
(62, 'Estampilla Procultura', NULL, '2017-06-27 20:31:57', NULL, 0, 1, 1, 0, 0),
(63, 'Retefuente', NULL, '2017-06-27 20:31:57', NULL, 0, 1, 1, 0, 0),
(64, 'Vigilancia Y Seguridad', NULL, '2017-06-27 20:31:57', NULL, 0, 1, 1, 0, 0),
(65, 'Artículos De Aseo', NULL, '2017-06-27 20:31:57', NULL, 0, 1, 1, 0, 0),
(66, 'Recarga Cartuchos Tinta', NULL, '2017-06-27 20:31:57', NULL, 0, 1, 1, 0, 0),
(67, 'Otros', NULL, '2017-10-24 13:19:02', NULL, 0, 1, 1, 0, 0),
(68, 'Anticipos Ángela', NULL, '2017-06-27 20:31:57', NULL, 0, 1, 1, 0, 0),
(69, 'Anticipos Oliverio', NULL, '2017-06-27 20:31:57', NULL, 0, 1, 1, 0, 0),
(70, 'Anticipos Julián', NULL, '2017-06-27 20:31:57', NULL, 0, 1, 1, 0, 0),
(71, 'Insumos Laboratorio Enfermería, Fisioterapia Y Veterinaria', NULL, '2017-08-10 15:57:32', NULL, 1, 1, 1, 0, 0),
(72, 'Impuesto', NULL, '2017-06-27 20:31:57', NULL, 0, 1, 1, 0, 0),
(73, 'Internet', NULL, '2017-06-27 20:31:57', NULL, 0, 1, 1, 0, 0),
(74, 'Directorio Claro', NULL, '2017-06-27 20:31:57', NULL, 0, 1, 1, 0, 0),
(75, 'Gastos Otras Sedes', NULL, '2017-06-27 20:31:57', NULL, 0, 1, 1, 0, 0),
(76, 'Plan Referidos', NULL, '2017-10-27 16:41:53', NULL, 0, 1, 1, 0, 0),
(77, 'Publicidad', NULL, '2017-06-27 20:31:57', NULL, 0, 1, 1, 0, 0),
(78, 'Arriendo', NULL, '2017-06-27 20:31:57', NULL, 0, 1, 1, 0, 0),
(79, 'seguro RCP', 1, '2017-07-10 20:34:08', NULL, 0, NULL, 0, 0, 0),
(80, 'Caja mayor', NULL, '2017-08-25 19:26:21', NULL, 0, 2, 1, 0, 0),
(81, 'DEVOLUCIÓN DE CAJA MAYOR', NULL, '2017-10-31 20:57:47', NULL, 0, 1, 1, 0, 0),
(82, 'OTROS', NULL, '2017-09-28 19:50:34', NULL, 0, 2, 1, 0, 0),
(83, '', NULL, '2017-09-28 22:45:10', NULL, 1, 2, 1, 0, 0),
(84, 'Diplomado Laboratorio Clínico', NULL, '2017-09-28 22:43:57', '2017-09-28 22:56:07', 0, 2, 1, 0, 0);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `concepto_anulacion`
--

DROP TABLE IF EXISTS `concepto_anulacion`;
CREATE TABLE IF NOT EXISTS `concepto_anulacion` (
  `descripcion` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `Id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`Id`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `concepto_anulacion`
--

INSERT INTO `concepto_anulacion` (`descripcion`, `created_at`, `deleted_at`, `Id`) VALUES
('No es el código', '2016-11-30 01:32:02', NULL, 1),
('No es el valor a pagar', '2016-11-30 01:32:10', NULL, 2);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `control_acceso`
--

DROP TABLE IF EXISTS `control_acceso`;
CREATE TABLE IF NOT EXISTS `control_acceso` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `accion` varchar(255) DEFAULT NULL,
  `accion_idhtml` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `control_acceso_user`
--

DROP TABLE IF EXISTS `control_acceso_user`;
CREATE TABLE IF NOT EXISTS `control_acceso_user` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `control_acceso_id` int(10) UNSIGNED DEFAULT NULL,
  `usuario_id` int(10) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_control_acceso_user_control_acceso` (`control_acceso_id`),
  KEY `fk_control_acceso_user_usuario` (`usuario_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `credencial`
--

DROP TABLE IF EXISTS `credencial`;
CREATE TABLE IF NOT EXISTS `credencial` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `nombre` varchar(20) CHARACTER SET utf8 COLLATE utf8_spanish2_ci NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `credencial`
--

INSERT INTO `credencial` (`id`, `nombre`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 'Administrador', '2016-11-24 18:43:32', NULL, NULL),
(2, 'Tesorero', '2017-02-21 14:28:46', NULL, NULL),
(3, 'Estudiante', '2017-02-21 14:28:51', NULL, NULL),
(4, 'Profesor', '2017-05-10 15:56:54', NULL, NULL),
(5, 'Director', '2017-05-10 15:57:03', NULL, NULL),
(6, 'Servicio al Cliente', '2017-05-10 15:57:24', NULL, NULL),
(7, 'Super User', '2017-07-27 15:48:35', NULL, NULL),
(8, 'Cobranza', '2017-07-27 15:48:35', NULL, NULL),
(9, 'Auditor', '2017-08-01 01:56:02', NULL, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cuadre`
--

DROP TABLE IF EXISTS `cuadre`;
CREATE TABLE IF NOT EXISTS `cuadre` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `usuario_id_cuadre` int(10) UNSIGNED DEFAULT NULL,
  `usuario_id_creador` int(10) UNSIGNED DEFAULT NULL,
  `total_ingreso` decimal(15,2) DEFAULT NULL,
  `total_egreso` decimal(15,2) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `sede_id` int(10) UNSIGNED DEFAULT NULL,
  `consecutivo` varchar(50) DEFAULT NULL,
  `ing_descripcion` varchar(255) DEFAULT NULL,
  `ing_valor` double NOT NULL DEFAULT '0',
  `eg_descripcion` varchar(255) DEFAULT NULL,
  `eg_valor` double NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `fk_cuadre_sede` (`sede_id`),
  KEY `fk_cuadre_usuario_creador` (`usuario_id_creador`),
  KEY `fk_cuadre_usuario_cuadre` (`usuario_id_cuadre`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `departamento`
--

DROP TABLE IF EXISTS `departamento`;
CREATE TABLE IF NOT EXISTS `departamento` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `descripcion` varchar(255) CHARACTER SET utf8mb4 DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `departamento`
--

INSERT INTO `departamento` (`id`, `descripcion`, `created_at`, `deleted_at`) VALUES
(1, 'Valle del Cauca', '2016-11-25 05:00:00', NULL),
(2, 'Cauca', '2016-11-25 05:00:00', NULL),
(3, 'Bogota', '2017-06-16 15:30:32', NULL),
(4, 'Bolivar', '2017-06-16 15:30:32', NULL),
(5, 'Boyaca', '2017-06-16 15:30:32', NULL),
(6, 'Caldas', '2017-06-16 15:30:32', NULL),
(7, 'Caqueta', '2017-06-16 15:30:32', NULL),
(8, 'Atlantico', '2017-06-16 15:30:32', NULL),
(9, 'Cesar', '2017-06-16 15:30:32', NULL),
(10, 'Cordoba', '2017-06-16 15:30:32', NULL),
(11, 'Cundinamarca', '2017-06-16 15:30:32', NULL),
(12, 'Choco', '2017-06-16 15:30:32', NULL),
(13, 'Huila', '2017-06-16 15:30:32', NULL),
(14, 'La Guajira', '2017-06-16 15:30:32', NULL),
(15, 'Magdalena', '2017-06-16 15:30:32', NULL),
(16, 'Meta', '2017-06-16 15:30:32', NULL),
(17, 'Nariño', '2017-06-16 15:30:32', NULL),
(18, 'Norte de Santander', '2017-06-16 15:30:32', NULL),
(19, 'Quindio', '2017-06-16 15:30:32', NULL),
(20, 'Risaralda', '2017-06-16 15:30:32', NULL),
(21, 'Santander', '2017-06-16 15:30:32', NULL),
(22, 'Sucre', '2017-06-16 15:30:32', NULL),
(23, 'Tolima', '2017-06-16 15:30:32', NULL),
(24, 'Antioquia', '2017-06-16 15:30:32', NULL),
(25, 'Arauca', '2017-06-16 15:30:32', NULL),
(26, 'Casanare', '2017-06-16 15:30:32', NULL),
(27, 'Putumayo', '2017-06-16 15:30:32', NULL),
(28, 'San Andres y Providencia', '2017-06-16 15:30:32', NULL),
(29, 'Amazonas', '2017-06-16 15:30:32', NULL),
(30, 'Guainia', '2017-06-16 15:30:32', NULL),
(31, 'Guaviare', '2017-06-16 15:30:32', NULL),
(32, 'Vaupes', '2017-06-16 15:30:32', NULL),
(33, 'Vichada', '2017-06-16 15:30:32', NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detalle_egresos`
--

DROP TABLE IF EXISTS `detalle_egresos`;
CREATE TABLE IF NOT EXISTS `detalle_egresos` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `fecha` timestamp NULL DEFAULT NULL,
  `tercero` varchar(200) DEFAULT NULL,
  `valor` decimal(15,2) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `cuadre_id` int(10) UNSIGNED DEFAULT NULL,
  `gastos_detalles_id` int(10) UNSIGNED DEFAULT NULL,
  `descripcion` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_detalle_egresos_cuadre` (`cuadre_id`),
  KEY `fk_detalle_egresos_gastos_detalles` (`gastos_detalles_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detalle_factura`
--

DROP TABLE IF EXISTS `detalle_factura`;
CREATE TABLE IF NOT EXISTS `detalle_factura` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `factura_id` int(10) UNSIGNED DEFAULT NULL,
  `concepto_id` int(10) UNSIGNED DEFAULT NULL,
  `observacion` varchar(1024) DEFAULT NULL,
  `activado` tinyint(1) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `fecha_inicio` date DEFAULT NULL,
  `planes_id` int(10) UNSIGNED DEFAULT NULL,
  `capital` decimal(10,2) DEFAULT NULL,
  `interes` decimal(10,2) DEFAULT NULL,
  `saldo` decimal(10,2) DEFAULT NULL,
  `cuota` int(11) DEFAULT NULL,
  `saldo_vencido` decimal(10,2) DEFAULT NULL,
  `valor` decimal(10,2) DEFAULT NULL,
  `suspendido` tinyint(1) NOT NULL DEFAULT '0',
  `observacion2` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_detalle_factura_concepto` (`concepto_id`),
  KEY `fk_detalle_factura_factura` (`factura_id`),
  KEY `fk_detalle_factura_planes` (`planes_id`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `detalle_factura`
--

INSERT INTO `detalle_factura` (`id`, `factura_id`, `concepto_id`, `observacion`, `activado`, `created_at`, `deleted_at`, `fecha_inicio`, `planes_id`, `capital`, `interes`, `saldo`, `cuota`, `saldo_vencido`, `valor`, `suspendido`, `observacion2`) VALUES
(1, 1, 1, '', 1, '2017-11-14 16:38:56', NULL, '2017-11-14', 1, '60000.00', '0.00', '0.00', 60000, '0.00', '0.00', 0, NULL),
(2, 1, 3, '', 1, '2017-11-14 16:38:56', NULL, '2017-11-14', 1, '22000.00', '0.00', '0.00', 22000, '0.00', '0.00', 0, NULL),
(3, 1, 6, '', 1, '2017-11-14 16:38:56', NULL, '2017-11-14', 1, '40000.00', '0.00', '0.00', 40000, '0.00', '0.00', 0, NULL),
(4, 1, 2, 'Cuota Noviembre de 2017', 1, '2017-11-14 16:38:56', NULL, '2017-11-20', 1, '90000.00', '0.00', '0.00', 90000, '0.00', '0.00', 0, NULL),
(5, 1, 2, 'Cuota Diciembre de 2017', 1, '2017-11-14 16:38:56', NULL, '2017-12-10', 1, '90000.00', '0.00', '0.00', 90000, '90000.00', '0.00', 0, NULL),
(6, 1, 2, 'Cuota Enero de 2018', 1, '2017-11-14 16:38:56', NULL, '2018-01-20', 1, '90000.00', '0.00', '0.00', 90000, '90000.00', '0.00', 0, NULL),
(7, 1, 2, 'Cuota Febrero de 2018', 1, '2017-11-14 16:38:56', NULL, '2018-02-20', 1, '90000.00', '0.00', '0.00', 90000, '90000.00', '0.00', 0, NULL),
(8, 1, 2, 'Cuota Marzo de 2018', 1, '2017-11-14 16:38:56', NULL, '2018-03-20', 1, '90000.00', '0.00', '0.00', 90000, '90000.00', '0.00', 0, NULL),
(9, 1, 2, 'Cuota Abril de 2018', 1, '2017-11-14 16:38:56', NULL, '2018-04-20', 1, '90000.00', '0.00', '0.00', 90000, '90000.00', '0.00', 0, NULL),
(10, 1, 2, 'Cuota Mayo de 2018', 1, '2017-11-14 16:38:56', NULL, '2018-05-20', 1, '95000.00', '0.00', '0.00', 95000, '95000.00', '0.00', 0, NULL),
(11, 1, 2, 'Cuota Junio de 2018', 1, '2017-11-14 16:38:56', NULL, '2018-06-20', 1, '95000.00', '0.00', '0.00', 95000, '95000.00', '0.00', 0, NULL),
(12, 1, 2, 'Cuota Julio de 2018', 1, '2017-11-14 16:38:56', NULL, '2018-07-20', 1, '95000.00', '0.00', '0.00', 95000, '95000.00', '0.00', 0, NULL),
(13, 1, 2, 'Cuota Agosto de 2018', 1, '2017-11-14 16:38:56', NULL, '2018-08-20', 1, '95000.00', '0.00', '0.00', 95000, '95000.00', '0.00', 0, NULL),
(14, 1, 2, 'Cuota Septiembre de 2018', 1, '2017-11-14 16:38:56', NULL, '2018-09-20', 1, '95000.00', '0.00', '0.00', 95000, '95000.00', '0.00', 0, NULL),
(15, 1, 2, 'Cuota Octubre de 2018', 1, '2017-11-14 16:38:56', NULL, '2018-10-20', 1, '95000.00', '0.00', '0.00', 95000, '95000.00', '0.00', 0, NULL),
(16, 1, 2, 'Cuota Noviembre de 2018', 1, '2017-11-14 16:38:56', NULL, '2018-11-20', 1, '100000.00', '0.00', '0.00', 100000, '100000.00', '0.00', 0, NULL),
(17, 1, 2, 'Cuota Diciembre de 2018', 1, '2017-11-14 16:38:56', NULL, '2018-12-20', 1, '100000.00', '0.00', '0.00', 100000, '100000.00', '0.00', 0, NULL),
(18, 1, 2, 'Cuota Enero de 2019', 1, '2017-11-14 16:38:56', NULL, '2019-01-20', 1, '100000.00', '0.00', '0.00', 100000, '100000.00', '0.00', 0, NULL),
(19, 1, 2, 'Cuota Febrero de 2019', 1, '2017-11-14 16:38:56', NULL, '2019-02-20', 1, '100000.00', '0.00', '0.00', 100000, '100000.00', '0.00', 0, NULL),
(20, 1, 2, 'Cuota Marzo de 2019', 1, '2017-11-14 16:38:56', NULL, '2019-03-20', 1, '100000.00', '0.00', '0.00', 100000, '100000.00', '0.00', 0, NULL),
(21, 1, 2, 'Cuota Abril de 2019', 1, '2017-11-14 16:38:56', NULL, '2019-04-20', 1, '100000.00', '0.00', '0.00', 100000, '100000.00', '0.00', 0, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detalle_ingresos`
--

DROP TABLE IF EXISTS `detalle_ingresos`;
CREATE TABLE IF NOT EXISTS `detalle_ingresos` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `fecha` timestamp NULL DEFAULT NULL,
  `estudiante_tercero` varchar(200) DEFAULT NULL,
  `sede` varchar(200) DEFAULT NULL,
  `valor` decimal(15,2) DEFAULT NULL,
  `neto` decimal(15,2) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `cuadre_id` int(10) UNSIGNED DEFAULT NULL,
  `recibo_caja_detalle_id` int(10) UNSIGNED DEFAULT NULL,
  `descripcion` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_detalle_ingresos_cuadre` (`cuadre_id`),
  KEY `fk_detalle_ingresos_recibo_caja_detalle` (`recibo_caja_detalle_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `estado_civil`
--

DROP TABLE IF EXISTS `estado_civil`;
CREATE TABLE IF NOT EXISTS `estado_civil` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `descripcion` varchar(255) CHARACTER SET utf8mb4 DEFAULT NULL,
  `create_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `estado_civil`
--

INSERT INTO `estado_civil` (`id`, `descripcion`, `create_at`, `deleted_at`) VALUES
(1, 'Soltero(a)', '2017-02-22 05:00:00', NULL),
(2, 'Casado(a)', '2017-02-22 05:00:00', NULL),
(3, 'Unión Libre', '2017-04-16 15:00:03', NULL),
(4, 'Actualizar', NULL, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `estudiante`
--

DROP TABLE IF EXISTS `estudiante`;
CREATE TABLE IF NOT EXISTS `estudiante` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `sede_id` int(10) UNSIGNED DEFAULT NULL,
  `estudiante_status_id` int(10) UNSIGNED DEFAULT NULL,
  `identificacion_id` int(10) UNSIGNED DEFAULT NULL,
  `ciudad_id` int(10) UNSIGNED DEFAULT NULL,
  `primer_apellido` varchar(255) DEFAULT NULL,
  `segundo_apellido` varchar(255) DEFAULT NULL,
  `nombres` varchar(255) DEFAULT NULL,
  `num_documento` varchar(255) DEFAULT NULL,
  `fecha_nacimiento` date DEFAULT NULL,
  `tel_fijo` varchar(50) DEFAULT NULL,
  `tel_movil` varchar(50) DEFAULT NULL,
  `direccion` varchar(255) DEFAULT NULL,
  `correo` varchar(255) DEFAULT NULL,
  `ocupacion` varchar(255) DEFAULT NULL,
  `expedicion_documento` varchar(255) DEFAULT NULL,
  `genero_id` int(10) UNSIGNED DEFAULT NULL,
  `barrio_domicilio` varchar(255) DEFAULT NULL,
  `num_libreta` varchar(255) DEFAULT NULL,
  `institucion` varchar(255) DEFAULT NULL,
  `ruta_foto` varchar(1024) DEFAULT NULL,
  `extension_foto` varchar(1024) DEFAULT NULL,
  `name_foto` varchar(1024) DEFAULT NULL,
  `old_name_foto` varchar(1024) DEFAULT NULL,
  `size_foto` varchar(1024) DEFAULT NULL,
  `size2_foto` varchar(1024) DEFAULT NULL,
  `type_foto` varchar(1024) DEFAULT NULL,
  `proteccion_datos` tinyint(1) DEFAULT '0',
  `comunicar_datos` tinyint(1) DEFAULT '0',
  `foto` varchar(1024) DEFAULT NULL,
  `recibir_comunicaciones` tinyint(1) DEFAULT '0',
  `acepto_condiciones` tinyint(1) DEFAULT '0',
  `nivel_academico_id` int(10) UNSIGNED DEFAULT NULL,
  `estado_civil_id` int(10) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `ciudad_domicilio` varchar(255) DEFAULT NULL,
  `nivel_academico` varchar(255) DEFAULT NULL,
  `programas_id` int(10) UNSIGNED DEFAULT NULL,
  `jornadas_id` int(10) UNSIGNED DEFAULT NULL,
  `consecutivo` varchar(10) DEFAULT NULL,
  `cod_referido` varchar(15) DEFAULT NULL,
  `actualizar` tinyint(1) DEFAULT '0',
  `observacion` varchar(2048) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_estudiante_ciudad` (`ciudad_id`),
  KEY `fk_estudiante_estado_civil` (`estado_civil_id`),
  KEY `fk_estudiante_estudiante_status` (`estudiante_status_id`),
  KEY `fk_estudiante_genero` (`genero_id`),
  KEY `fk_estudiante_identificacion` (`identificacion_id`),
  KEY `fk_estudiante_jornadas` (`jornadas_id`),
  KEY `fk_estudiante_nivel_academico` (`nivel_academico_id`),
  KEY `fk_estudiante_programas` (`programas_id`),
  KEY `fk_estudiante_sede` (`sede_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `estudiante`
--

INSERT INTO `estudiante` (`id`, `sede_id`, `estudiante_status_id`, `identificacion_id`, `ciudad_id`, `primer_apellido`, `segundo_apellido`, `nombres`, `num_documento`, `fecha_nacimiento`, `tel_fijo`, `tel_movil`, `direccion`, `correo`, `ocupacion`, `expedicion_documento`, `genero_id`, `barrio_domicilio`, `num_libreta`, `institucion`, `ruta_foto`, `extension_foto`, `name_foto`, `old_name_foto`, `size_foto`, `size2_foto`, `type_foto`, `proteccion_datos`, `comunicar_datos`, `foto`, `recibir_comunicaciones`, `acepto_condiciones`, `nivel_academico_id`, `estado_civil_id`, `created_at`, `deleted_at`, `ciudad_domicilio`, `nivel_academico`, `programas_id`, `jornadas_id`, `consecutivo`, `cod_referido`, `actualizar`, `observacion`) VALUES
(1, 1, 1, 1, 152, 'Marin', 'Escobar', 'Duvier', '1112230018', '1996-10-01', '', '3122414492', 'Manzana 18 casa 24', 'duvierm24@gmail.com', 'Desarrollador web', 'Pradera', 1, 'Villamarina', '', 'Alfredo Posada Correa', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, 0, 0, 3, 1, '2017-11-14 16:38:56', NULL, 'Pradera', NULL, 7, 1, '2175023', '', 0, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `estudiante_codigo`
--

DROP TABLE IF EXISTS `estudiante_codigo`;
CREATE TABLE IF NOT EXISTS `estudiante_codigo` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `estudiante_id` int(10) UNSIGNED DEFAULT NULL,
  `codigo` varchar(20) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_estudiante_codigo_estudiante` (`estudiante_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `estudiante_pivot_beca`
--

DROP TABLE IF EXISTS `estudiante_pivot_beca`;
CREATE TABLE IF NOT EXISTS `estudiante_pivot_beca` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `estudiante_id` int(10) UNSIGNED DEFAULT NULL,
  `becas_id` int(10) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_estudiantePivotBeca_becas` (`becas_id`),
  KEY `fk_estudiantePivotBeca_estudiante` (`estudiante_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `estudiante_status`
--

DROP TABLE IF EXISTS `estudiante_status`;
CREATE TABLE IF NOT EXISTS `estudiante_status` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `status` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `color_status` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `estudiante_status`
--

INSERT INTO `estudiante_status` (`id`, `status`, `created_at`, `deleted_at`, `color_status`) VALUES
(1, 'Activo', NULL, NULL, '#1ab394'),
(2, 'Inactivo', NULL, NULL, NULL),
(3, 'Retirado', NULL, NULL, '#d43f3a'),
(4, 'Graduado', NULL, NULL, '#1c84c6'),
(5, 'PreInscripción', NULL, NULL, '#f8ac59');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `factura`
--

DROP TABLE IF EXISTS `factura`;
CREATE TABLE IF NOT EXISTS `factura` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `estudiante_id` int(10) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `total` bigint(20) DEFAULT NULL,
  `impresion` tinyint(1) DEFAULT '0',
  `usuario_id` int(10) UNSIGNED DEFAULT NULL,
  `sede_id` int(10) UNSIGNED DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_factura_estudiante` (`estudiante_id`),
  KEY `fk_factura_sede` (`sede_id`),
  KEY `fk_factura_usuario` (`usuario_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `factura`
--

INSERT INTO `factura` (`id`, `estudiante_id`, `created_at`, `deleted_at`, `total`, `impresion`, `usuario_id`, `sede_id`) VALUES
(1, 1, '2017-11-14 16:38:56', NULL, NULL, 0, 1, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `forma_pago`
--

DROP TABLE IF EXISTS `forma_pago`;
CREATE TABLE IF NOT EXISTS `forma_pago` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `descripcion` varchar(255) CHARACTER SET utf8mb4 DEFAULT NULL,
  `abreviatura` varchar(150) CHARACTER SET utf8mb4 DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `forma_pago`
--

INSERT INTO `forma_pago` (`id`, `descripcion`, `abreviatura`, `created_at`, `deleted_at`) VALUES
(1, 'Efectivo', 'EF', '2017-01-07 20:52:15', NULL),
(2, 'Cheque', 'CH', '2017-01-07 20:52:27', NULL),
(3, 'Tarjeta de Crédito', 'TC', '2017-04-16 14:08:49', NULL),
(4, 'Consignación', 'CONG', '2017-04-16 14:08:49', NULL),
(5, 'Trans. Bancaria', 'TB', '2017-04-16 14:08:49', NULL),
(6, 'Pago en Baloto o Banco Avvilas', 'Baloto', '2017-07-16 15:33:07', NULL),
(7, 'Tarjeta Débito', 'TD', '2017-11-09 13:51:31', NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `forma_pago_detalle`
--

DROP TABLE IF EXISTS `forma_pago_detalle`;
CREATE TABLE IF NOT EXISTS `forma_pago_detalle` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `forma_pago_id` int(10) UNSIGNED DEFAULT NULL,
  `valor` decimal(10,2) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `recibo_caja_id` int(10) UNSIGNED DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_forma_pago_detalle_forma_pago` (`forma_pago_id`),
  KEY `fk_forma_pago_detalle_recibo_caja` (`recibo_caja_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `forma_pago_detalle`
--

INSERT INTO `forma_pago_detalle` (`id`, `forma_pago_id`, `valor`, `created_at`, `deleted_at`, `recibo_caja_id`) VALUES
(1, 1, '60000.00', '2017-11-15 16:04:05', NULL, 1),
(2, 1, '130000.00', '2017-11-22 14:32:44', NULL, 3);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `gastos`
--

DROP TABLE IF EXISTS `gastos`;
CREATE TABLE IF NOT EXISTS `gastos` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `sede_id` int(10) UNSIGNED DEFAULT NULL,
  `fecha` timestamp NULL DEFAULT NULL,
  `observacion` varchar(5000) DEFAULT NULL,
  `impresion` tinyint(1) DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `proveedores_id` int(10) UNSIGNED DEFAULT NULL,
  `usuario_id` int(10) UNSIGNED DEFAULT NULL,
  `impresion_cuadre` tinyint(1) DEFAULT '0',
  `concepto_anulacion` varchar(400) DEFAULT NULL,
  `impresion_foga` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `fk_gasto_sede` (`sede_id`),
  KEY `fk_gastos_proveedores` (`proveedores_id`),
  KEY `fk_gastos_usuario` (`usuario_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `gastos_detalles`
--

DROP TABLE IF EXISTS `gastos_detalles`;
CREATE TABLE IF NOT EXISTS `gastos_detalles` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `gasto_id` int(10) UNSIGNED DEFAULT NULL,
  `valor` varchar(20) DEFAULT NULL,
  `observacion` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `programas_id` int(10) UNSIGNED DEFAULT NULL,
  `concepto_id` int(10) UNSIGNED DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_detalles_gasto_gasto` (`gasto_id`),
  KEY `fk_gastos_detalles_concepto` (`concepto_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `genero`
--

DROP TABLE IF EXISTS `genero`;
CREATE TABLE IF NOT EXISTS `genero` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `descripcion` varchar(200) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `genero`
--

INSERT INTO `genero` (`id`, `descripcion`, `created_at`, `deleted_at`) VALUES
(1, 'Masculino', '2017-04-17 05:00:00', NULL),
(2, 'Femenino', '2017-04-17 05:00:00', NULL),
(3, 'Actualizar', NULL, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `identificacion`
--

DROP TABLE IF EXISTS `identificacion`;
CREATE TABLE IF NOT EXISTS `identificacion` (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `descripcion_corta` varchar(255) CHARACTER SET utf8 COLLATE utf8_spanish2_ci NOT NULL,
  `descripcion_larga` varchar(255) CHARACTER SET utf8 COLLATE utf8_spanish2_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `identificacion`
--

INSERT INTO `identificacion` (`id`, `descripcion_corta`, `descripcion_larga`, `created_at`, `deleted_at`) VALUES
(1, 'CC', 'Cédula de Ciudadanía', '2016-11-23 01:23:55', NULL),
(2, 'TI', 'Tarjeta de Identidad', '2016-11-24 01:02:47', NULL),
(3, 'NIT', 'NIT', '2017-05-13 19:34:44', NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `jornadas`
--

DROP TABLE IF EXISTS `jornadas`;
CREATE TABLE IF NOT EXISTS `jornadas` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `jornada` varchar(255) CHARACTER SET utf8mb4 DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `jornadas`
--

INSERT INTO `jornadas` (`id`, `jornada`, `created_at`, `deleted_at`) VALUES
(0, 'Default', '2017-05-03 05:00:00', NULL),
(1, 'Diurno 7-10', '2016-11-25 01:30:40', NULL),
(2, 'Diurno 10-1', '2016-12-16 00:43:29', NULL),
(3, 'Tarde', '2017-04-16 14:20:52', NULL),
(4, 'Sabatina Mañana', '2017-04-16 14:20:52', NULL),
(5, 'Sabatina Tarde', '2017-04-16 14:20:52', NULL),
(6, 'Noche', '2017-04-16 14:20:52', NULL),
(7, 'Dominical', '2017-06-07 23:53:09', NULL),
(8, 'Viernes 8:00 - 1:00 PM', '2017-10-20 19:18:33', NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `menu`
--

DROP TABLE IF EXISTS `menu`;
CREATE TABLE IF NOT EXISTS `menu` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `nombre` varchar(255) DEFAULT NULL,
  `padre` int(11) DEFAULT NULL,
  `nivel` int(11) DEFAULT NULL,
  `target` varchar(50) DEFAULT NULL,
  `estado` int(11) DEFAULT NULL,
  `url` varchar(500) DEFAULT NULL,
  `icono` varchar(50) DEFAULT NULL,
  `titulo` varchar(150) DEFAULT NULL,
  `orden` int(11) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `menu_pivot_user`
--

DROP TABLE IF EXISTS `menu_pivot_user`;
CREATE TABLE IF NOT EXISTS `menu_pivot_user` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `menu_id` int(10) UNSIGNED DEFAULT NULL,
  `usuario_id` int(10) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_menu_pivot_user_menu` (`menu_id`),
  KEY `fk_menu_pivot_user_usuario` (`usuario_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `migrations`
--

DROP TABLE IF EXISTS `migrations`;
CREATE TABLE IF NOT EXISTS `migrations` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `migration` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '2016_06_01_000001_create_oauth_auth_codes_table', 1),
(2, '2016_06_01_000002_create_oauth_access_tokens_table', 1),
(3, '2016_06_01_000003_create_oauth_refresh_tokens_table', 1),
(4, '2016_06_01_000004_create_oauth_clients_table', 1),
(5, '2016_06_01_000005_create_oauth_personal_access_clients_table', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `nivel_academico`
--

DROP TABLE IF EXISTS `nivel_academico`;
CREATE TABLE IF NOT EXISTS `nivel_academico` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `descripcion` varchar(255) CHARACTER SET utf8mb4 DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `nivel_academico`
--

INSERT INTO `nivel_academico` (`id`, `descripcion`, `created_at`, `deleted_at`) VALUES
(1, 'Primaria', '2016-11-25 05:00:00', NULL),
(2, 'Secundaria', '2016-11-25 05:00:00', NULL),
(3, 'Otro', '2017-04-16 15:03:10', NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `oauth_access_tokens`
--

DROP TABLE IF EXISTS `oauth_access_tokens`;
CREATE TABLE IF NOT EXISTS `oauth_access_tokens` (
  `id` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `client_id` int(11) NOT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `scopes` text COLLATE utf8mb4_unicode_ci,
  `revoked` tinyint(1) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `expires_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `oauth_access_tokens_user_id_index` (`user_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `oauth_access_tokens`
--

INSERT INTO `oauth_access_tokens` (`id`, `user_id`, `client_id`, `name`, `scopes`, `revoked`, `created_at`, `updated_at`, `expires_at`) VALUES
('65eb43a5551f3ff79fd8d5f2a884f204809df36adf8a5927de41c5463b75f23b6e6e30804df1e89a', 1, 5, 'AplexTM', '[]', 1, '2017-11-21 19:47:10', '2017-11-21 19:47:10', '2018-11-21 14:47:10'),
('c03113732980198393515000d24e1522ec5cf21ddf7a45dc78cbbc58c93aec9ec6f0ece29b18432c', 1, 5, 'AplexTM', '[]', 1, '2017-11-21 20:57:51', '2017-11-21 20:57:51', '2018-11-21 15:57:51'),
('a339f6247e9a410a331a29e0313b1f6392a3d18a7094f4d906a653c0b706d19e5f766ac216332a09', 1, 5, 'AplexTM', '[]', 1, '2017-11-21 21:05:01', '2017-11-21 21:05:01', '2018-11-21 16:05:01'),
('dc2022d3a65b81b2b3a3eadbf2fbf91f2b80c28baa264c4ca55864d705fb01edff311ec2a2d85207', 1, 5, 'AplexTM', '[]', 0, '2017-11-21 21:07:16', '2017-11-21 21:07:16', '2018-11-21 16:07:16'),
('cc2a44e5faef3f6d8f9c7a0f13e24c03c1fc9912b1e05f0953a76c74abc43b83908cb15df770846b', 1, 5, 'Prueba', '[]', 1, '2017-11-21 22:41:04', '2017-11-21 22:41:04', '2018-11-21 17:41:04'),
('a24d5096ca8a704270ed87240732288380be7edf6256825a563f43a50ef15461f298b9d728b28203', 1, 5, 'Prueba', '[]', 0, '2017-12-11 19:03:46', '2017-12-11 19:03:46', '2018-12-11 14:03:46');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `oauth_auth_codes`
--

DROP TABLE IF EXISTS `oauth_auth_codes`;
CREATE TABLE IF NOT EXISTS `oauth_auth_codes` (
  `id` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` int(11) NOT NULL,
  `client_id` int(11) NOT NULL,
  `scopes` text COLLATE utf8mb4_unicode_ci,
  `revoked` tinyint(1) NOT NULL,
  `expires_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `oauth_clients`
--

DROP TABLE IF EXISTS `oauth_clients`;
CREATE TABLE IF NOT EXISTS `oauth_clients` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `secret` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `redirect` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `personal_access_client` tinyint(1) NOT NULL,
  `password_client` tinyint(1) NOT NULL,
  `revoked` tinyint(1) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `oauth_clients_user_id_index` (`user_id`)
) ENGINE=MyISAM AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `oauth_clients`
--

INSERT INTO `oauth_clients` (`id`, `user_id`, `name`, `secret`, `redirect`, `personal_access_client`, `password_client`, `revoked`, `created_at`, `updated_at`) VALUES
(1, NULL, 'Laravel Personal Access Client', 'piwLedE9y5126u33XEzWoUNnuNXAjnbBzWy0GUx6', 'http://localhost', 1, 0, 0, '2017-11-17 01:19:43', '2017-11-17 01:19:43'),
(2, NULL, 'Laravel Password Grant Client', 'ZokBx17cOC57HsBFDMLnynRzgk4jSQgXtgWXYg71', 'http://localhost', 0, 1, 0, '2017-11-17 01:19:43', '2017-11-17 01:19:43'),
(5, NULL, 'Test personal', 'SB3amMspVzSsi6FO0qsYdmtSRKBzvrNhxzQwKeMm', 'http://localhost', 1, 0, 0, '2017-11-21 19:29:59', '2017-11-21 19:29:59');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `oauth_personal_access_clients`
--

DROP TABLE IF EXISTS `oauth_personal_access_clients`;
CREATE TABLE IF NOT EXISTS `oauth_personal_access_clients` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `client_id` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `oauth_personal_access_clients_client_id_index` (`client_id`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `oauth_personal_access_clients`
--

INSERT INTO `oauth_personal_access_clients` (`id`, `client_id`, `created_at`, `updated_at`) VALUES
(1, 1, '2017-11-17 01:19:43', '2017-11-17 01:19:43'),
(2, 5, '2017-11-21 19:29:59', '2017-11-21 19:29:59');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `oauth_refresh_tokens`
--

DROP TABLE IF EXISTS `oauth_refresh_tokens`;
CREATE TABLE IF NOT EXISTS `oauth_refresh_tokens` (
  `id` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `access_token_id` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `revoked` tinyint(1) NOT NULL,
  `expires_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `oauth_refresh_tokens_access_token_id_index` (`access_token_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `password_resets`
--

DROP TABLE IF EXISTS `password_resets`;
CREATE TABLE IF NOT EXISTS `password_resets` (
  `email` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  KEY `password_resets_email_index` (`email`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `patrocinador`
--

DROP TABLE IF EXISTS `patrocinador`;
CREATE TABLE IF NOT EXISTS `patrocinador` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nit` varchar(100) DEFAULT NULL,
  `nombre` varchar(100) NOT NULL,
  `direccion` varchar(100) DEFAULT NULL,
  `telefono` varchar(50) DEFAULT NULL,
  `id_estudiante` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `patrocinador`
--

INSERT INTO `patrocinador` (`id`, `nit`, `nombre`, `direccion`, `telefono`, `id_estudiante`) VALUES
(3, 'asdfasfdas', 'Duma Impulsa', 'Pradera 123', '321', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `planes`
--

DROP TABLE IF EXISTS `planes`;
CREATE TABLE IF NOT EXISTS `planes` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `porcentaje` float DEFAULT NULL,
  `descripcion` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `cuotas` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `planes`
--

INSERT INTO `planes` (`id`, `porcentaje`, `descripcion`, `created_at`, `deleted_at`, `cuotas`) VALUES
(1, 0, 'Sin Interés', '2016-11-30 19:33:54', NULL, 6),
(2, 2, 'Plan 12', '2016-12-12 21:37:05', '2017-06-28 21:44:22', 12),
(3, 2, 'Plan 24', '2017-01-04 05:00:00', '2017-06-28 21:44:26', 24),
(4, 0, 'Normal', '2017-06-07 23:54:05', '2017-06-07 23:56:11', 6);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `preinscritos`
--

DROP TABLE IF EXISTS `preinscritos`;
CREATE TABLE IF NOT EXISTS `preinscritos` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `codigo` int(10) UNSIGNED DEFAULT NULL,
  `nombre` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `celular` varchar(255) DEFAULT NULL,
  `telefono` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `sede_id` int(10) UNSIGNED DEFAULT NULL,
  `programas_id` int(10) UNSIGNED DEFAULT NULL,
  `jornadas_id` int(10) UNSIGNED DEFAULT NULL,
  `documento` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_preinscritos_jornadas` (`jornadas_id`),
  KEY `fk_preinscritos_programas` (`programas_id`),
  KEY `fk_preinscritos_sede` (`sede_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `programas`
--

DROP TABLE IF EXISTS `programas`;
CREATE TABLE IF NOT EXISTS `programas` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `sede_id` int(10) UNSIGNED DEFAULT NULL,
  `programa` varchar(255) CHARACTER SET utf8 COLLATE utf8_spanish2_ci DEFAULT NULL,
  `descripcion` varchar(255) CHARACTER SET utf8 COLLATE utf8_spanish2_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_programas_sede` (`sede_id`)
) ENGINE=InnoDB AUTO_INCREMENT=124 DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `programas`
--

INSERT INTO `programas` (`id`, `sede_id`, `programa`, `descripcion`, `created_at`, `deleted_at`) VALUES
(0, 1, 'Sin Programa', NULL, '2017-05-03 05:00:00', NULL),
(1, 1, 'Auxiliar en Servicios Farmacéutico', 'Auxiliar en Servicios Farmacéutico', '2017-05-03 05:00:00', NULL),
(2, 1, 'Auxiliar en Enfermería', 'Auxiliar en Enfermería', '2016-11-29 18:12:53', NULL),
(3, 1, 'Actividades de Recuperación Física (No Disponible)', 'Nueva definición por renovación de PEI', '2016-11-29 19:47:40', NULL),
(4, 1, 'Auxiliar en Salud Oral', 'Auxiliar en Salud Oral', '2017-01-01 03:19:56', NULL),
(5, 1, 'Auxiliar Administrativo en Salud', 'Auxiliar Administrativo en Salud', '2017-02-21 05:00:00', NULL),
(6, 1, 'Atención a la Primera Infancia', 'Atención a la Primera Infancia', '2017-04-16 14:03:08', NULL),
(7, 1, 'Auxiliar en Sistemas', 'Auxiliar en Sistemas', '2017-04-16 14:03:08', NULL),
(8, 1, 'Auxiliar en Procesos Industriales', 'Auxiliar en Procesos Industriales', '2017-04-16 14:03:08', NULL),
(9, 1, 'Auxiliar en Diseño Gráfico y Publicidad', 'Auxiliar en Diseño Gráfico y Publicidad', '2017-04-16 14:03:08', NULL),
(10, 1, 'Secretariado Gerencial y Contable', 'Secretariado Gerencial y Contable', '2017-04-16 14:03:08', NULL),
(11, 1, 'Auxiliar en Veterinaria', 'Auxiliar en Veterinaria', '2017-04-16 14:03:08', NULL),
(12, 2, 'Auxiliar en Servicios Farmacéutico', 'Auxiliar en Servicios Farmacéutico', '2017-04-16 14:03:08', NULL),
(13, 2, 'Auxiliar en Enfermería', 'Auxiliar en Enfermería', '2017-04-16 14:03:08', NULL),
(14, 2, 'Actividades de Recuperación Física ', 'Actividades de Recuperación Física ', '2017-04-16 14:03:08', NULL),
(15, 2, 'Auxiliar en Salud Oral', 'Auxiliar en Salud Oral', '2017-04-16 14:03:08', NULL),
(16, 2, 'Auxiliar Administrativo en Salud', 'Auxiliar Administrativo en Salud', '2017-04-16 14:03:08', NULL),
(17, 2, 'Atención a la Primera Infancia', 'Atención a la Primera Infancia', '2017-04-16 14:03:08', NULL),
(18, 2, 'Auxiliar en Sistemas', 'Auxiliar en Sistemas', '2017-04-16 14:03:08', NULL),
(19, 2, 'Auxiliar en Procesos Industriales', 'Auxiliar en Procesos Industriales', '2017-04-16 14:03:08', NULL),
(20, 2, 'Auxiliar en Diseño Gráfico y Publicidad', 'Auxiliar en Diseño Gráfico y Publicidad', '2017-04-16 14:03:08', NULL),
(21, 2, 'Secretariado Gerencial y Contable', 'Secretariado Gerencial y Contable', '2017-04-16 14:03:08', NULL),
(22, 2, 'Auxiliar en Veterinaria', 'Auxiliar en Veterinaria', '2017-04-16 14:03:08', NULL),
(23, 3, 'Auxiliar en Servicios Farmacéutico', 'Auxiliar en Servicios Farmacéutico', '2017-04-16 14:03:08', NULL),
(24, 3, 'Auxiliar en Enfermería', 'Auxiliar en Enfermería', '2017-04-16 14:03:08', NULL),
(25, 3, 'Actividades de Recuperación Física ', 'Actividades de Recuperación Física ', '2017-04-16 14:03:08', NULL),
(26, 3, 'Auxiliar en Salud Oral', 'Auxiliar en Salud Oral', '2017-04-16 14:03:08', NULL),
(27, 3, 'Auxiliar Administrativo en Salud', 'Auxiliar Administrativo en Salud', '2017-04-16 14:03:08', NULL),
(28, 3, 'Atención a la Primera Infancia', 'Atención a la Primera Infancia', '2017-04-16 14:03:08', NULL),
(29, 3, 'Auxiliar en Sistemas', 'Auxiliar en Sistemas', '2017-04-16 14:03:08', NULL),
(30, 3, 'Auxiliar en Procesos Industriales', 'Auxiliar en Procesos Industriales', '2017-04-16 14:03:08', NULL),
(31, 3, 'Auxiliar en Diseño Gráfico y Publicidad', 'Auxiliar en Diseño Gráfico y Publicidad', '2017-04-16 14:03:08', NULL),
(32, 3, 'Secretariado Gerencial y Contable', 'Secretariado Gerencial y Contable', '2017-04-16 14:03:08', NULL),
(33, 3, 'Auxiliar en Veterinaria', 'Auxiliar en Veterinaria', '2017-04-16 14:03:08', NULL),
(34, 4, 'Auxiliar en Servicios Farmacéutico', 'Auxiliar en Servicios Farmacéutico', '2017-04-16 14:03:08', NULL),
(35, 4, 'Auxiliar en Enfermería', 'Auxiliar en Enfermería', '2017-04-16 14:03:08', NULL),
(36, 4, 'Actividades de Recuperación Física ', 'Actividades de Recuperación Física ', '2017-04-16 14:03:08', NULL),
(37, 4, 'Auxiliar en Salud Oral', 'Auxiliar en Salud Oral', '2017-04-16 14:03:08', NULL),
(38, 4, 'Auxiliar Administrativo en Salud', 'Auxiliar Administrativo en Salud', '2017-04-16 14:03:08', NULL),
(39, 4, 'Atención a la Primera Infancia', 'Atención a la Primera Infancia', '2017-04-16 14:03:08', NULL),
(40, 4, 'Auxiliar en Sistemas', 'Auxiliar en Sistemas', '2017-04-16 14:03:08', NULL),
(41, 4, 'Auxiliar en Procesos Industriales', 'Auxiliar en Procesos Industriales', '2017-04-16 14:03:08', NULL),
(42, 4, 'Auxiliar en Diseño Gráfico y Publicidad', 'Auxiliar en Diseño Gráfico y Publicidad', '2017-04-16 14:03:08', NULL),
(43, 4, 'Secretariado Gerencial y Contable', 'Secretariado Gerencial y Contable', '2017-04-16 14:03:08', NULL),
(44, 4, 'Auxiliar en Veterinaria', 'Auxiliar en Veterinaria', '2017-04-16 14:03:08', NULL),
(46, 3, 'Cursos Especializados', 'Cursos Especializados', '2017-04-16 14:03:08', NULL),
(47, 1, 'Curso Básico de Sistemas', 'Curso Básico de Sistemas', '2017-04-16 14:03:08', NULL),
(48, 1, 'Técnico en Criminalística (No disponible)', 'Técnico en Criminalística', '2017-04-16 14:03:08', '2017-06-07 23:51:56'),
(49, 3, 'Curso Básico de Sistemas', 'Duración 2 meses', '2017-04-16 14:03:08', NULL),
(50, 4, 'Curso Básico de Sistemas', 'Duración 2 meses', '2017-04-16 14:03:08', NULL),
(51, 2, 'Curso Básico de Sistemas', 'Duración 2 meses', '2017-04-16 14:03:08', NULL),
(52, 1, 'Especialización técnica en circulante en sala de cirugías', 'Diplomado', '2017-04-16 14:03:08', NULL),
(53, 4, 'Curso Soporte Vital Basico', 'Duración 12 horas', '2017-04-16 14:03:08', NULL),
(54, 4, 'curso excel avanzado', 'duración 20 horas', '2017-04-16 14:03:08', NULL),
(55, 2, 'Especialización Técnica en Circulante en Sala de Cirugía', 'Diplomado', '2017-04-16 14:03:08', NULL),
(56, 1, 'Diplomado en Gestión de Calidad', 'Escuela de Administración\r\nDiplomado en Gestión de Calidad', '2017-04-16 14:03:08', NULL),
(57, 1, 'Diplomado en Cuidado Materno Infantil', 'Escuela de Salud\r\nDiplomado en Cuidado Materno Infantil', '2017-04-16 14:03:08', NULL),
(58, 1, 'Diplomado en Masoterapia', 'Escuela de Salud\r\nDiplomado en Masoterapia', '2017-04-16 14:03:08', NULL),
(59, 4, 'Curso rápido masoterapia', '1 mes', '2017-04-16 14:03:08', NULL),
(60, 1, 'Gestión Empresarial', 'Especialización Técnica', '2017-04-16 14:03:08', NULL),
(61, 3, 'Especialización técnica en circulante en sala de cirugías', 'Diplomado', '2017-04-16 14:03:08', NULL),
(62, 1, 'Cursos Especializados', 'Diplomados', '2017-04-16 14:03:08', NULL),
(63, 2, 'Gestión de Calidad', 'Especialización técnica', '2017-04-16 14:03:08', NULL),
(64, 1, 'Auxiliar en Recuperación Física', '1200 horas', '2017-04-16 14:03:08', NULL),
(65, 4, 'Diplomado Masoterapia', 'Diplomado', '2017-04-16 14:03:08', NULL),
(66, 2, 'Cursos Especializados', 'Cursos Especializados', '2017-04-16 14:03:08', NULL),
(67, 2, 'Diplomado de Masoterapia', 'Diplomado', '2017-04-16 14:03:08', NULL),
(68, 4, 'Curso Peluquería Canina', 'curso', '2017-04-16 14:03:08', NULL),
(69, 5, 'CICLO IV', '8-9', '2017-04-16 14:03:08', NULL),
(70, 5, 'CICLO V', '10', '2017-04-16 14:03:08', NULL),
(71, 5, 'CICLO VI', '11', '2017-04-16 14:03:08', NULL),
(72, 5, 'CICLO III', '6-7', '2017-04-16 14:03:08', NULL),
(73, 4, 'Curso Salud Ocupacional', 'Curso', '2017-04-16 14:03:08', NULL),
(74, 2, 'Técnico en Seguridad Ocupaciona;', 'Curso', '2017-05-16 14:03:08', NULL),
(75, 3, 'Técnico en Seguridad Ocupaciona;', 'Curso', '2017-05-16 14:03:08', NULL),
(76, 4, 'Cursos Especializados', 'Cursos', '2017-05-21 14:03:08', NULL),
(77, 1, 'Seguridad Ocupacional', 'Cali', '2017-05-30 00:15:36', NULL),
(78, 1, 'Asistente Administrativo', 'Técnico Laboral', '2017-05-30 00:15:41', NULL),
(79, 1, 'Inglés', 'Cali', '2017-05-30 00:15:56', NULL),
(80, 4, 'Técnico en Seguridad Ocupaciona', 'curso', '2017-06-30 15:41:08', NULL),
(81, 2, 'Técnico en Criminalística', 'Técnico en Criminalística', '2017-08-15 19:50:31', NULL),
(82, 4, 'Diplomado Laboratorio Clínico', 'Diplomado Laboratorio Clínico', '2017-09-28 22:54:00', NULL),
(83, 4, 'Diplomado RCCP', 'DIPLOMADO', '2017-10-04 19:48:22', NULL),
(84, 1, 'Curso en Atención y Cuidado a las personas', 'Escuela de Salud\r\nCurso en Atención y Cuidado a las personas', '2017-10-08 01:54:29', NULL),
(85, 1, 'Curso en Primeros Auxilios', 'Escuela de Salud\r\nCurso en Primeros Auxilios', '2017-10-08 01:55:50', NULL),
(86, 1, 'Curso en Salud Ocupacional Básica', 'Escuela de Salud\r\nCurso en Salud Ocupacional Básica', '2017-10-08 01:57:22', NULL),
(87, 1, 'Curso en Inyectología', 'Escuela de Salud\r\nCurso de Inyectología', '2017-10-08 01:58:08', NULL),
(88, 1, 'Curso en Visita Medica', 'Escuela de Salud\r\nCurso en Visita Medica', '2017-10-08 02:01:46', NULL),
(89, 1, 'Especialización Técnica en Farmacología', 'Escuela de Salud\r\nEspecialización Técnica en Farmacología', '2017-10-08 02:06:11', NULL),
(90, 1, 'Diplomado en RCCP', 'Escuela de Salud\r\nDiplomado en RCCP ( BLS -Basic Life Suport)', '2017-10-08 02:19:16', NULL),
(91, 1, 'Especialización Técnica en Atención en Unidad de Cuidados Intensivos', 'Escuela de Salud\r\nEspecialización Técnica en Atención en Unidad de Cuidados Intesivos', '2017-10-08 02:21:47', NULL),
(92, 1, 'Curso Excel Avanzado', 'Escuela de Nuevas Tecnologías\r\nCurso Excel Avanzado', '2017-10-08 02:26:45', NULL),
(93, 1, 'Curso en Instalación de Redes', 'Escuela de Nuevas Tecnologías\r\nCursos en Instalación de Redes', '2017-10-08 02:27:56', NULL),
(94, 1, 'Curso en Mantenimiento y Reparación de Computadores', 'Escuela de Nuevas Tecnologías\r\nCurso en Mantenimiento y Reparación de Computadores', '2017-10-08 02:29:08', NULL),
(95, 1, 'Curso en Mercadeo y Ventas', 'Escuela de Administración\r\nCurso en Mercadeo y Ventas', '2017-10-08 02:30:11', NULL),
(96, 1, 'Curso en Servicio al Cliente', 'Escuela de Administración\r\nCurso en Servicio al Cliente', '2017-10-08 02:30:56', NULL),
(97, 1, 'Curso en Afiliación en Seguridad Social', 'Escuela de Administración\r\nCurso en Afiliación en Seguridad Social', '2017-10-08 02:33:26', NULL),
(98, 1, 'Curso en Administración de Documentos', 'Escuela de Administración\r\nCurso en Administración de documentos', '2017-10-08 02:34:03', NULL),
(99, 1, 'Curso en Orientación en Educación Inicial', 'Escuela de Educación\r\nCurso en Orientación en Educación Inicial', '2017-10-08 02:36:41', NULL),
(100, 1, 'Curso en Creación de Páginas Web', 'Escuela de Arte y Comunicación\r\nCurso en Creación de Páginas Web', '2017-10-08 02:38:19', NULL),
(101, 1, 'Diplomado en Profilaxis Dental en Perros y Gatos sin anestesia', 'Escuela de Ciencia\r\nDiplomado en Profilaxis Dental en Perros y Gatos sin anestesia', '2017-10-08 02:39:48', NULL),
(102, 1, 'Curso de Peluquería Canina y Felina', 'Escuela de Ciencia\r\nCurso de Peluquería Canina y Felina', '2017-10-08 02:47:47', NULL),
(103, 1, 'Diplomado en Atención al paciente diabético', 'Jornada Viernes 8:00-1:00 pm', '2017-10-20 19:12:11', NULL),
(104, 3, 'Curso en Servicio al Cliente', 'Curso en Servicio al Cliente', '2017-10-26 21:50:59', NULL),
(105, 3, 'Curso Mercadeo y Ventas', 'Curso Mercadeo y Ventas', '2017-10-26 21:51:43', NULL),
(106, 3, 'Curso Excel Avanzado', 'Curso Excel Avanzado', '2017-10-26 21:52:14', NULL),
(107, 3, 'Curso Básico RCP', 'Curso Básico RCP', '2017-10-26 21:52:48', NULL),
(108, 3, 'Curso de Inyectología I', 'Curso de Inyectología I', '2017-10-26 21:53:12', NULL),
(109, 3, 'Diplomado en Masoterapia', 'Diplomado en Masoterapia', '2017-10-26 21:53:49', NULL),
(110, 3, 'Diplomado en Circulante en Sala de Cirugías', 'Diplomado en Circulante en Sala de Cirugías', '2017-10-26 21:54:36', NULL),
(111, 3, 'Curso de Mantenimiento y reparación de computadores', 'Curso de Mantenimiento y Reparación de computadores', '2017-10-26 21:55:14', NULL),
(112, 3, 'Curso de Administración de documentos', 'Curso de Administración de documentos', '2017-10-26 21:55:45', NULL),
(113, 3, 'Curso de Peluquería Canina y Felina', 'Curso de Peluquería Canina y Felina', '2017-10-26 21:56:28', NULL),
(114, 2, 'Curso en inyectología ', 'curso con intensidad horaria 1 mes', '2017-10-26 22:05:28', NULL),
(115, 2, 'Diplomado Laboratorio Clínico', 'curso con intensidad horaria 3 mes', '2017-10-26 22:06:51', NULL),
(116, 2, 'Curso de Peluquería Canina y Felina', 'duración 3 meses ', '2017-10-26 22:07:38', NULL),
(117, 2, 'Diplomado de geriatría y gerontología', 'duración: 3 meses', '2017-10-26 22:08:38', NULL),
(118, 2, 'Curso Farmacología y primeros auxilios ', 'duración: 3 meses', '2017-10-26 22:10:03', NULL),
(119, 2, 'Curso básico en sistemas ', 'duración: 3 meses', '2017-10-26 22:10:43', NULL),
(120, 2, 'Diplomado marketing y ventas ', 'duración: 3 meses', '2017-10-26 22:11:11', NULL),
(121, 2, 'Rccp con la nueva farmacología cardiaca ', 'duración:1 mes', '2017-10-26 22:11:57', NULL),
(122, 2, 'Diplomado de vacunación', 'duración: 3 meses', '2017-10-26 22:13:08', NULL),
(123, 1, 'DIPLOMADO LABORATORIO CLINICO', 'Duración 4 meses: 3 meses teórico - 1 mes práctico', '2017-11-03 19:04:38', NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `proveedores`
--

DROP TABLE IF EXISTS `proveedores`;
CREATE TABLE IF NOT EXISTS `proveedores` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `sede_id` int(10) UNSIGNED DEFAULT NULL,
  `nombres` varchar(255) DEFAULT NULL,
  `apellidos` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  `celular` varchar(20) DEFAULT NULL,
  `num_documento` varchar(20) DEFAULT NULL,
  `direccion` varchar(50) DEFAULT NULL,
  `email` varchar(50) DEFAULT NULL,
  `identificacion_id` int(10) UNSIGNED DEFAULT NULL,
  `ciudad_id` int(10) UNSIGNED DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_proveedores_ciudad` (`ciudad_id`),
  KEY `fk_proveedores_identificacion` (`identificacion_id`),
  KEY `fk_proveedores_sede` (`sede_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3057 DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `proveedores`
--

INSERT INTO `proveedores` (`id`, `sede_id`, `nombres`, `apellidos`, `created_at`, `deleted_at`, `telefono`, `celular`, `num_documento`, `direccion`, `email`, `identificacion_id`, `ciudad_id`) VALUES
(1, 1, 'Ramón Alberto', 'Ocampo Tenorio', NULL, NULL, '', '3188603319', '94526860', 'Av 2A No 75HN - 35', 'inocampo1125@hotmail.com', 1, 1),
(2, 1, 'Josefina ', 'Cuellar Aztaiza', NULL, NULL, '3', NULL, '39.989.001', 'Carrera 38 A No. 7-73', 'NULL', 1, 1),
(3, 1, 'YADIRA ', 'TAVERA', NULL, NULL, NULL, NULL, '38601112', 'C', 'yadira3860@hotmail.com', 1, 1),
(4, 1, 'Jose Domingo', 'Cuaran', NULL, NULL, NULL, NULL, '16791654', 'NULL', 'NULL', 1, 1),
(6, 1, 'Ramón ', 'Gonzalez', NULL, NULL, NULL, NULL, '1130631210', 'NULL', 'NULL', 1, 1),
(7, 1, 'Miriam ', 'Maya  de la Portilla', NULL, NULL, '5135178', '3207015206', '38.944.220', 'Calle 9 D 40 A 53 APTO 301 LOS CAMBULOS', 'mayadelap@hotmail.com', 1, 1),
(8, 1, 'Felipe', 'Caro Mayo', NULL, NULL, NULL, NULL, '79.381.285', 'NULL', 'NULL', 1, 1),
(9, 1, 'Jhon James', 'Barona', NULL, NULL, NULL, NULL, '94415294', 'NULL', 'NULL', 1, 1),
(10, 1, 'Catalina', 'Restrepo Alvarez', NULL, NULL, '2732049', '3188323998', '1.113.646.503', 'Carrera 3E No. 32 C 11', 'cavirea@hotmail.com', 1, 1),
(11, 1, 'Claudia Maria ', 'Garzo Peralta', NULL, NULL, 'NO TIENE', '3114687622', '26.551.775', 'CARRERA 96 A No 4 -34 MELENDEZ', 'cmgp2182@hotmail.com', 1, 1),
(12, 1, 'Diana ', 'Ariza', NULL, NULL, NULL, NULL, '38.460.157', 'NULL', 'NULL', 1, 1),
(13, 1, 'Jaime ', 'Mosquera Blanco', NULL, NULL, '6677922', '3154146223', '16.752.265', 'AV 3 NTE No 19- 100', 'jaimeandrescenal@gmail.com', 1, 1),
(14, 1, 'Willians', 'Lopez Muñoz', NULL, NULL, '3816177', '3147586618', '4.775.629', 'Carrera 2 A No 62 A 120', 'wijolomz@hotmail.com', 1, 1),
(15, 1, 'Javier Eduardo ', 'Palacios ', NULL, NULL, '3384061', '3136491536', '94.488.913', 'CRA 48 A No 48-92', 'javier.e.palacios@gmail.com', 1, 1),
(16, 1, 'Yadira', 'Sanchez Orrego', NULL, NULL, '6955731', '3147789343', '1.118.287.518', 'Calle 14 N No. 12 AN 04', 'yadirasanchez87@hotmail.com', 1, 1),
(17, 1, 'Carlos Andres ', 'Gonzalez', NULL, NULL, '4401341', '3148754102', '10.023.273', 'Calle 72 C 5 N 45', 'deivigos@hotmail.com', 1, 1),
(18, 1, 'Jenny Angélica ', 'Barrera', NULL, NULL, 'NO TIENE', '3108345140', '1.130.606.031', 'CRA 31 No 12C 33 APTO 207', 'psicoangelica2010@hotmail.com', 1, 1),
(19, 1, 'David Francisco ', 'Arango Idrobo', NULL, NULL, 'NO TIENE', '3148690005', '1.130.635.159', 'CALL 9 C CON CRA 30 CHAMPAÑAN -29', 'arango_mango@hotmail.com', 1, 1),
(20, 1, 'Edgar Enrique', 'Vergara', NULL, NULL, 'NO TIENE ', '3015474401', '94.456.514', 'CALLE 38 3 H 83', 'edgarenriquev@hotmail.com', 1, 1),
(21, 1, 'Damaris', 'Machado Hernandez', NULL, NULL, '3170552', '3163349313', '38.561.128', 'CARRERA 100 No 45 -51 APTO 104J CORALES DEL LILI', 'damaris884@hotmail.com', 1, 1),
(22, 1, 'Alexandra ', 'Montenegro Romero', NULL, NULL, '6652186', '3175762886', '59.836.186', 'AV 6 DN 41 N 26', 'jalexavet@hotmail.com', 1, 1),
(23, 1, 'Javier Enrique ', 'Potes Jaramillo', NULL, NULL, NULL, NULL, '16.793.142', 'NULL', 'NULL', 1, 1),
(24, 1, 'Edwin', 'Herrera Rengifo', NULL, NULL, '3366397', '3104047790', '16.3752.265', 'Carrera 31 A No. 27-91', 'edwinh82@hotmail.com', 1, 1),
(25, 1, 'Sonia ', 'Bedoya Enrique', NULL, NULL, '4864894', '3174656690', '66.818.693', 'CALLE 54 No 4 D 44', 'sbedoya2008@hotmail.com', 1, 1),
(26, 1, 'Erik Javier ', 'Bravo Ruano', NULL, NULL, '4028760', '3164946298', '1.130.609.289', 'CALLE 101 A No 22 B 40', 'erikjavierbravo@hotmail.com', 1, 1),
(27, 1, 'Jimena Patricia ', 'Cuesta Guapacha', NULL, NULL, '3712014', '3175298591', '29.116.859', 'CALLE 55 NTE 3 B 57 LA FLORA', 'jimenacuestaguapacha@hotmail.com', 1, 1),
(28, 1, 'Claudia Maria ', 'Espinosa Wuman', NULL, NULL, '6658659', '3008034730', '66.822.539', 'CALLE 61 NTE  No. 3 N 80', 'claudia.eswu@hotmail.com', 1, 1),
(29, 1, 'Diseños ', 'Profesionales', NULL, NULL, NULL, NULL, '1130671638-1', 'NULL', 'NULL', 1, 1),
(30, 1, 'Paula Andrea ', 'Zapata', NULL, NULL, NULL, NULL, '43.632.642', 'NULL', 'NULL', 1, 1),
(31, 1, 'Distribuidora La 16', 'NULL', NULL, NULL, NULL, NULL, '16.640.069-1', 'NULL', 'NULL', 1, 1),
(32, 1, 'José Julián ', 'Palacios Gañán', NULL, NULL, '6817301', NULL, '1130624192', 'c', 'direccion@cenal.com.co', 1, 1),
(33, 1, 'Luz Ángela ', 'Palacios Gañán', NULL, NULL, '6817301', NULL, '38.559.682', 'c', 'lapalacios@cenal.comc.o', 1, 1),
(34, 1, 'Interdrogas', 'drogueria', NULL, NULL, '8892019', NULL, '800.001.047-2', 'calle 8 No. 6 -80 esquina', '@', 1, 1),
(36, 1, 'Almacenes', 'La 14 S.A.', NULL, NULL, '433', NULL, '890.300.346-1', 'AV 6', '@', 1, 1),
(37, 1, 'Telefonica', 'Movistar', NULL, NULL, '5870284', NULL, '830.122.566-1', '#', '@', 1, 1),
(38, 1, 'Empresa de Medicina Integral', 'EMI S.A.', NULL, NULL, '6530404', NULL, '811.007.601-0', 'AV 1 NTE No. 5N 55', '@', 1, 1),
(39, 1, 'Maria Mercedes', 'Ocampo Jurado', NULL, NULL, '6817301', NULL, '66.852.630', '#', '@', 1, 1),
(40, 1, 'Claudia Patricia ', 'Pérez García ', NULL, NULL, '4465750', '3206417180', '66.992.878', 'Calle 66 No. 1 - 63 El porton de Cali Bolq 15 apto', 'vip1@cenal.com.co', 1, 1),
(41, 1, 'Grupo Comercial', 'Cardecol', NULL, NULL, '5248283', NULL, '31.322.510-1', '#', '@', 1, 1),
(42, 1, 'Rubiel', 'Anacona', NULL, NULL, '4226502', '3136656332', '83.160.979', 'Calle 107 No 26 P 25', 'NO TIENE', 1, 1),
(43, 1, 'Telmex comunicaciones S.A. E.S.P', 'Claro', NULL, NULL, '442', '', '830.140.108-8', 'Telmex Cali', '@', 1, 1),
(44, 1, 'Gases de occidente', 'S.A. ES.P', NULL, NULL, '4187333', NULL, '800.167.643-5', 'C.C. chipichape Bodega 6 piso 3', '@', 1, 1),
(45, 1, 'Empresas Municipales de Cali', 'E.I.C.E E.S.P', NULL, NULL, '44', NULL, '890.399.003-4', 'EL CAM', '@', 1, 1),
(46, 1, 'COMCEL S.A.', 'CLARO', NULL, NULL, '44', NULL, '800.153.993-7', '#', '@', 1, 1),
(47, 1, 'UNE EPM Telecomunicaciones', 'S.A.', NULL, NULL, '44', NULL, '900.092.385-9', 'CARRERA 16 No. 11A SUR 100 MEDELLIN', '@', 1, 1),
(48, 1, 'Stephania ', 'Motato Gañán', NULL, NULL, '4870828', '3178871990', '1.144.176.527', 'Calle 54 B No. 4D 44 Los ciruelos conjuto G apto 2', 'asistentecali@cenal.com.co', 1, 1),
(49, 1, 'Fundación ', 'Zoológico de Cali', NULL, NULL, '44', NULL, '890.318.247-8', '#', '@', 1, 1),
(51, 2, 'MILTON GEOVANNY ', 'ARBOLEDA SAAVEDRA ', NULL, NULL, '2323389', '3136546034', '94395777', 'CRA  38 C  N º 14 A -04', 'MILGEAR86@HOTMAIL.COM', 1, 2),
(52, 2, 'JOHN EDWAR ', 'RESTREPO CASTRO', NULL, NULL, '2325440', '3185226777', '1116234222', 'MANZANA 8 CASA 35', 'john_evil@hotmail.com', 1, 2),
(53, 2, 'Carolina', 'Ramirez Gutierrez', NULL, NULL, '2241982', '3117364137', '31790366', 'calle 41 nº 26-63', 'carolinarg366@hotmail.com', 1, 2),
(54, 2, 'Duberley', 'Osorio Patiño', NULL, NULL, '3177685226', '3177685226', '3482453', 'carrera 38A Nº 26-20', 'dleyosorio@gmail.com', 1, 2),
(55, 2, 'Danny Luz', 'Castaño Restrepo', NULL, NULL, '3174341645', '3174341645', '29875567', 'calle 35 Nº 24-64', 'dcastaño@ingeniocarmelita.com', 1, 2),
(56, 2, 'Sandra Milena', 'Atehortua León', NULL, NULL, '2307652', '3164968742', '38791203', 'Calle 22C Nº 7 A 38', 'samy_s.m.a.l@hotmail.com', 1, 2),
(57, 2, 'Leidy Johanna', 'Sandoval Rodriguez', NULL, NULL, '2325740', '3185448546', '1112102659', 'Carrera 3 oeste Nº 20-21', 'johannita-21091@hotmail.com', 1, 2),
(58, 2, 'Luis Eduardo', 'Espinosa Colorado', NULL, NULL, '3128610947', '3128610947', '16844351', 'Carrera 34 Nº 38-09', 'luedesco@hotmail.com', 1, 2),
(59, 2, 'Alba Lorena', 'Zuluaga Cano', NULL, NULL, '2255992', '3116248900', '66729379', 'Calle 25b Nº 1-06', 'lore493@hotmail.com', 1, 2),
(60, 4, 'JAIME ADOLFO', 'JIMENEZ MARULANDA ', NULL, NULL, '8397716', '3113569392', '76325996', 'CALLE 7 No 4-70', 'JAIMEMV9@HOTMAIL.COM', 1, 4),
(61, 2, 'SERVIENTREGA ', 'SERVIENTREGA', NULL, NULL, '7700380', '7700380', '860512330-3', 'TULUÁ', 'NULL', 1, 2),
(62, 3, 'Sandra Lorena', 'Obando Lobón', NULL, NULL, '3177387569', '3177387569', '1113653217', 'Cra 16 No. 38-81', 'tesoreriaplamira@cenal.com.co', 1, 3),
(63, 3, 'Adelfa ', 'Olmedo Marulanda', NULL, NULL, '3177971680', '3177971680', '1113635123', 'Cll 47 E No. 13-59', 'adelfa915@hotmail.com', 1, 3),
(64, 2, 'JAVIER', 'CARRILLO', NULL, NULL, '3127749983', '3127749983', '29645339', 'CLL 32 Nº 28-99', 'NULL', 1, 2),
(65, 2, 'CONSTRUPANEL ', 'GONZALEZ CASTAÑO', NULL, NULL, '2257272', '3175026752', '94366221-4', 'CLL 25  Nº 20-69', 'JJGONZALEZ1127@HOTMAIL.COM', 2, 2),
(66, 2, 'CONSTRUALBERTH', 'FERRETERIA LA 29', NULL, NULL, '2251492', '3167389201', '31204797-0', 'CLL 29 Nº  23-17', 'NULL', 1, 2),
(67, 2, 'Leidy Johana', 'Pinzón Betancur', NULL, NULL, '3146586941', '3146586941', '29314575', 'calle 35 Nº 31-21', 'coordinaciontulua@cenal.com.co', 1, 2),
(68, 2, 'Isabel Cristina', 'Castaño Franco', NULL, NULL, '2257383', '3168645470', '66708873', 'Calle 43 Nº 23 a 27', 'isacris-023@hotmail.com', 1, 2),
(69, 2, 'Aleixcer Bonelly', 'Sandoval Marmolejo', NULL, NULL, '3104295830', '3177761817', '14796168', 'Manzana 51 Casa 4b', 'emdimion@yahoo.com', 1, 2),
(70, 2, 'Ana Milena', 'Varela Gonzalez', NULL, NULL, '2245764', '3017943988', '38796637', 'Calle 34 Nª 22-48', 'anitavarela11@gmail.com', 1, 2),
(71, 2, 'Ana Maria', 'Molina Bermudez', NULL, NULL, '3104295830', '3104295830', '31793717', 'Carrera 22 A Nº 14-61', 'megamy2010@hotmail.com', 1, 2),
(72, 2, 'Mauricio', 'Guerrero Mahecha', NULL, NULL, '3178799706', '3178799706', '79386133', 'Calle 33 Nº 18-51', 'bmgm1966@hotmail.com', 1, 2),
(73, 2, 'Javier', 'Villegas Bernal', NULL, NULL, '3154993916', '3165241018', '79350439', 'Tres esquinas callejon Valderrama', 'javier.vb18@hotmail.com', 1, 2),
(74, 2, 'Sandra Fernanda', 'Rengifo Bocanegra', NULL, NULL, '2273661', '3152002309', '38877816', 'Carrera 15 Nº 7-65', 'sarem0203@hotmail.com', 1, 2),
(75, 2, 'Sara Rosa', ' Llanos Correa', NULL, NULL, '2321977', '3122899878', '66962759', 'calle 34 Nº 18 a 14', 'sarita-0614@hotmail.com', 1, 2),
(76, 2, 'Wilson Fabian', 'Alvarez Bedoya', NULL, NULL, '3104980729', '3104980729', '94154735', 'Calle 19 Nº 2E - 46', 'fabian0901_@hotmail.com', 1, 2),
(77, 2, 'Oscar Andres', 'Toro Bejarano', NULL, NULL, '2382333', '3177040057', '14137001', 'Carrera 2 N 9-34', 'oscartoro@misena.edu.co', 1, 2),
(78, 2, 'Eva e', 'Espinosa Lopez', NULL, NULL, '3147722847', '3147722847', '29875293', 'Calle 7 Nº 28 a 08', 'evaes10712@yahoo.es', 1, 2),
(79, 2, 'Victor Hugo', 'Clavijo Lemos', NULL, NULL, '3166265274', '3166265274', '6316858', 'calle 1 F sur nº 14-35', 'guarapoext@hotmail.com', 1, 2),
(80, 2, 'Maria Patricia', 'Mateus Rodriguez', NULL, NULL, '3117880428', '3117880428', '51919680', 'Carrera 38 Nº 23-36', 'mmateusrodriguez@hotmail.com', 1, 2),
(81, 2, 'Jair', 'Guarin Londoño', NULL, NULL, '2324746', '2324746', '31201195', 'Calle 6A Nº 25B 15', 'jair.guarin@hotmail.com', 1, 2),
(82, 2, 'Wilmer Alberto', 'Gutierrez', NULL, NULL, '3176986905', '3176986905', '6197207', 'Vereda Galicia', 'tohera107@yahoo.es', 1, 2),
(83, 2, 'Carlos Humberto', 'Navia', NULL, NULL, '2257778', '2257778', '94357804', 'Manzana p Casa 13', 'carloshumbertonavia@gmail.com', 1, 2),
(84, 2, 'Angela', 'Madrigales', NULL, NULL, '3178386678', '3178386678', '66720153', 'Carrera 38 A Nº 12 c 48', 'angymadrigales@hotmail.com', 1, 2),
(85, 2, 'Lina Maria', 'Daza Gutierrez', NULL, NULL, '2325062', '3164980619', '31792627', 'Alvernia', 'limadagu@gmail.com', 1, 2),
(86, 2, 'Claudia Saghenga', 'Olaya Valencia', NULL, NULL, '2307413', '3182061487', '29877695', 'Calle 24 Nº 15-25', 'saghito@gmail.com', 1, 2),
(87, 1, 'Maria Jimena', 'Cardona V.', NULL, NULL, '444', NULL, '31.253.777-2', '#', '@', 1, 1),
(88, 2, 'Felix Antonio', 'Gonzalez Aricapa', NULL, NULL, '2246048', '3155211827', '16358897', 'Carrera 18 Nº 26b -02', 'felixgonzalez63@hotmail.com', 1, 2),
(89, 2, 'Ines Eugenia', 'Galvez Jaramillo', NULL, NULL, '3165229601', '3165229601', '29875981', 'Alvernia', 'eugegalvez@hotmail.com', 1, 2),
(90, 2, 'Jenniffer', 'Vallecilla Posso', NULL, NULL, '2245086', '3128179009', '1111739195', 'Carrera 27 Bis Nº 39-58 ', 'jevapo9@hotmail.com', 1, 2),
(91, 1, 'Alcaldia Santiago de ', 'Cali ', NULL, NULL, '444', NULL, '890.399.011-3', '#', '@', 1, 1),
(92, 2, 'Rodolfo Alejandro', 'Guevara Garcia', NULL, NULL, '3206872440', '3206872440', '94283197', 'Carrera 23 Nº 32-41', 'direcciontulua@cenal.com.co', 1, 2),
(93, 2, 'Julio Cesar', 'Hernandez Cardenas', NULL, NULL, '3127749383', '3127749383', '16262650', 'Manzana 25 casa 20', 'NULL', 1, 2),
(94, 2, 'Harold Gonzalo', 'Duran', NULL, NULL, '3104268796', '3104268796', '6199459', 'CRA 3 Nº 5-61', 'hgduran@hotmail.com', 1, 2),
(95, 3, 'Luisa Fernanda', 'Arias Rojas', NULL, NULL, '3127040937', '3127040937', '1113624542', 'Cll 15 No. 26-97', 'luisa.fernanda.arias@hotmail.es', 1, 3),
(96, 3, 'Marina Ruth', 'Alvarez Bedoya', NULL, NULL, '3118696139', '3118696139', '39.565.156', 'No refiere', 'coordinadorapracticascenal@hotmail.com', 1, 3),
(97, 3, 'Jenny ALejandra ', 'Castillo Martinez', NULL, NULL, '3178015745', '3178015745', '29.665.023', 'Cra 3 No. 5-41', 'jennyalejacastillo64gmail.com', 1, 3),
(98, 2, 'Liliana del Socorro', 'Guzman', NULL, NULL, '2249264', '3147179505', '40775896', 'CALLE 39 A - 23-86', 'guseli47@hotmail.com ', 1, 2),
(99, 2, 'Diego Edison', 'Charria Prada', NULL, NULL, '3172273764', '3172273764', '94325005', 'CALLE 34 N. 36-21', 'NULL', 1, 2),
(100, 3, 'Angela Viviana', 'Zapata García', NULL, NULL, '2731718', '3113654566', '29.681.553', 'Cra 21 No. 16-18', 'viviangie-84@hotmail.com', 1, 3),
(101, 3, 'Carlos Alberto', 'Naranjo Revelo', NULL, NULL, '3002785604', '3002785604', '94.327.371', 'Cll 49 No. 34b-39', 'carlosnaranjorevelo@hotmail.com', 1, 3),
(103, 3, 'Viviana Loriet', 'Ruiz Canaval', NULL, NULL, '3163488861', '3182384537', '29.675.715', 'Cra 16a No. 39-63', 'vivianaloriet@hotmail.com', 1, 3),
(104, 3, 'Elsa ', 'Neiva Grueso', NULL, NULL, '3122025512', '3185833093', '66.784.060', 'Cra 28d No. 71-05', 'elsaneiva@gmail.com', 1, 3),
(105, 3, 'Miguel Angel', 'Cardona Quintero', NULL, NULL, '3182141876', '3003167184', '1.113.630.404', 'Cra 35 No. 40-38', 'mikelpone@hotmail.com', 1, 3),
(106, 3, 'Mauricio', 'Carbonell Ospina', NULL, NULL, '2874772', '3162569798', '94.328.491', 'Cll 47A No. 37-39', 'carbonelillo13@hotmail.com', 1, 3),
(107, 3, 'Maria Sandra ', 'Pereira Mora', NULL, NULL, '3156834905', '3156834905', '66.760.444', 'Cll 41 No. 42-83', 'sandrizz301@hotmail.com', 1, 3),
(108, 3, 'Lilian Ximena', 'Morales Triana', NULL, NULL, '3164638751', '3164638751', '29.684.859', 'Cra 13 No. 46-23', 'ximenilla0813@hotmail.com', 1, 3),
(109, 3, 'Armando ', 'Martinez Palacios', NULL, NULL, '3137588670', '3137588670', '16.257.995', 'Cra 24a No. 36-58', 'armando_martinez54@hotmail.com', 1, 3),
(110, 3, 'Diana Patricia', 'Mejia Torres', NULL, NULL, '3136113616', '3136113616', '29.681.151', 'Cll 22 No. 30-28', 'pattyd13@hotmail.com', 1, 3),
(111, 3, 'Monica Liliana', 'Borja Escobar ', NULL, NULL, '3174211258', '3174211258', '29.672.681', 'Cra 15 No. 43b-18', 'monilbe@hotmail.com', 1, 3),
(112, 3, 'Maria del Pilar', 'Isaza Jimenez', NULL, NULL, '3128317794', '3128317794', '66.777.250', 'Cra 42 No. T23-116', 'pilar_isaza@yahoo.es', 1, 3),
(113, 3, 'Hector Fabio ', 'Cabezas Florez', NULL, NULL, '312886440', '312886440', '94.328.379', 'Cll 40 No. 7-27', 'hectorcabezas0102@hotmail.es', 1, 3),
(114, 3, 'Andres Mauricio', 'Naranjo Revelo', NULL, NULL, '3006146365', '3006146365', '94.381.569', 'Cll 49 No. 34b-39', 'proyectofenixx@yahoo.com', 1, 3),
(115, 3, 'James Alberto ', 'Velez Bueno', NULL, NULL, '2735297', '3157439427', '16.264.624', 'Cll 24a No. 36-58', 'jamesvelezprof@hotmail.com', 1, 3),
(116, 3, 'Maria Nidia', 'Bermudez', NULL, NULL, '3105174240', '3105174240', '31.153.653', 'Cll 25 No. 26-38', 'No refeire', 1, 3),
(117, 3, 'Suleyma ', 'Delgado Guerrero', NULL, NULL, '2818511', NULL, '1.113.625.395', 'Cll 45 No. 25-40', 'No refiere', 1, 3),
(118, 3, 'Ronald ', 'Jaramillo Hernadez', NULL, NULL, '3113500483', '3113500483', '6.389.313', 'Cll 36 No. 25-48', 'rones8210@gmail.com', 1, 3),
(119, 3, 'Tatiana Yulima', 'Jaramillo ', NULL, NULL, '3208600685', '3208600685', '30.323.728', 'Cra 28 No. 31-38', 'atis8210@gmail.com', 1, 3),
(120, 3, 'Yanir', 'Lopez Gutierrez ', NULL, NULL, '3205753290', '3205753290', '66.971.502', 'CLL 36 No. 32-88', 'yaningutierrez14@hotmail.com', 1, 3),
(121, 3, 'Julio Cesar ', 'Perea Agredo', NULL, NULL, '3158305452', '3158305452', '6.626.031', 'Cll 33 No. 32-47', 'juliocesar8226@hotmail.com', 1, 3),
(122, 3, 'Andrea ', 'Toro Velez', NULL, NULL, '3167782104', '3167782104', '66.782.303', 'Cll 33 No. 37-66', 'andremore22@hotmail.com', 1, 3),
(123, 3, 'Leidy Diana', 'Rodriguez ', NULL, NULL, '315270626', '315270626', '29.679.301', 'Cra 30 No. 44a-24', 'leidydiana29@hotmail.com', 1, 3),
(124, 1, 'Deganado', 'S.A.', NULL, NULL, '44', NULL, '890.316.242-2', '#', '@', 1, 1),
(125, 1, 'Cooperativa de ganaderos', 'del centro y norte del Valle', NULL, NULL, '444', NULL, '800.193.348-7', '#', '@', 1, 1),
(126, 3, 'Lilian Jimena ', 'Naranjo Revelo', NULL, NULL, '2732157', '3147480061', '66772949', 'Cll 49 No. 34b-39', 'No refiere', 1, 3),
(127, 3, 'Marino ', 'Diaz Antia', NULL, NULL, '2710711', '3103941836', '6.300.698', 'Cll 33B No. 1e-16', 'No refiere', 1, 3),
(128, 3, 'EDWIN ', 'VEGA', NULL, NULL, '3156745316', NULL, '94314588', 'CLL 34 15-31', 'No refiere', 1, 3),
(129, 3, 'Vanessa ', 'Chacon Jaramillo', NULL, NULL, '2726728', '3117865980', '1.113.648.258', 'Cra 30 No. 35-20', 'No refiere', 1, 3),
(130, 3, 'Jhon Jairo ', 'Sanchez Castro', NULL, NULL, '3122587332', '3122587332', '94.311.108', 'Cll 18 No. 27-16', 'sancajairo@gmail.com', 1, 3),
(131, 1, 'Hector  Fabio ', 'Gallego Florez ', NULL, NULL, '4480874', '3175385861', '7.544.350', 'Calle 33 A No. 11 C 10', 'hectorfabiogalle@hotmail.com', 1, 1),
(132, 4, 'EDWIN ', 'RIVERA GOMEZ', NULL, NULL, '8362967 - ', '3137739881', ' 4.612.856  ', 'CR 6B No 27N - 32 PALACE ', 'edwin-r-1@hotmail.com', 1, 4),
(133, 4, 'ANDRES ENRIQUE ', 'NOGUERA FUENTES', NULL, NULL, '8367858', ' 3186098779-30033911', ' 10.304.403  ', 'CL 29AN No 6B - 04 ALICANTE ', 'andrese1984@hotmail.com ', 1, 4),
(134, 4, 'VICKY JOHANNA ', ' MUÑOZ', NULL, NULL, '-8363581', '3154189179', ' 34.315.654  ', 'CR 7B No 26BN - 02 ', 'vickypaz2006@yahoo.com ', 1, 4),
(135, 4, 'PAULA ANDREA', ' ARGOTE', NULL, NULL, '8', '317314625', ' 25.279.206  ', 'CR 17 No 57N-854 CASA 10 V/CLAUDIA ', 'anapaula1030@yahoo,com ', 1, 4),
(136, 4, 'CARLOS HERNAN', 'SOTELO CASTRO', NULL, NULL, '8362062', '3122648653', ' 10.292.181  ', 'CL 26N No 4A - 58 VILLA DOCENTE ', 'carloshernandosotelocastro@gmail.com ', 1, 4),
(137, 4, 'ROOSEVELT BOLIVAR ', 'SOTELO CASTRO', NULL, NULL, '8362062', '3128414196', ' 76.312.497  ', 'CL 26N No 4A - 58 VILLA DOCENTE ', 'rooseveltsotelo@gmail.com ', 1, 4),
(138, 4, 'DIEGO FERNANDO', 'FERNANDEZ GONZALEZ', NULL, NULL, '8232367-247581', '3113238864-315509270', '76.329.667 ', 'CR 10 A  No 67N - 71 ', 'diegofergonza@gmail.com ', 1, 4),
(139, 4, 'LIDIA REGINA', ' UTRIA MARENGO', NULL, NULL, '8367627', '3108351635', '22.609.540 ', 'CL 10 No 4-13 PISO 2 EL EMPEDRADO ', 'm_teresa611@hotmail.com ', 1, 4),
(140, 4, 'SANDRA MARITZA', ' SALAZAR RODRIGUEZ', NULL, NULL, '8221080-8220479-', '3154373982', '34.549.225 ', 'CR 1AE No 9-72 ', 'sandramaritzasalazar@gmail.com ', 1, 4),
(141, 4, 'OSCAR EDUARDO ', 'TORRES ', NULL, NULL, '3155785053', '3155785053', '10.300.265 ', 'CR 12 No 3-73 B/ CADILLAL ', 'oet7@hotmail.com ', 1, 4),
(142, 3, 'Oscar Andres', 'Serrano', NULL, NULL, '2732839', '3155080690', '6.694.110', 'Cll 41 No. 12-06', 'No refiere', 1, 3),
(143, 2, 'FRANCISCO ', 'CATAYO', NULL, NULL, '(04) 5114411', '(04) 5114411', '15370870', 'CRA 55 # 60-30', 'NULL', 1, 2),
(144, 1, 'Luz Mila ', 'Fernandez', NULL, NULL, '44', NULL, '66.820.238', '#', '@', 1, 1),
(145, 3, 'Luis Alfonso ', 'Velasco Sanchez', NULL, NULL, '3173980357', '3173980357', '16.274.822', 'Cra 42 E No.46-44', 'No refiere', 1, 3),
(146, 1, 'Nuevo Diario', 'Occidente S.A.', NULL, NULL, '4860555', NULL, '805.017.188-0', 'CL 8 5-70 PISO 2', '@', 1, 1),
(147, 1, 'Sandra ', 'Erazo', NULL, NULL, '3732254', '3113861480', '31.566.009', 'CRA 2 No 59 A 02', 'sandraera128@hotmail.es', 1, 1),
(148, 4, ' FERRETERIA Y ELCTRICOS JHON FERNANDO ', 'ORDOÑEZ', NULL, NULL, '8234985', 'NO', '1061709338', 'CALLE 3 No 6-09', 'NO', 1, 4),
(149, 4, 'AGUSTO ', 'GARCIA', NULL, NULL, 'NO', '3173257198', '10304076', 'CRA 4B No70B N39 VILLA DEL NORTE', 'NO TIENE', 1, 4),
(150, 2, 'Lizeth', 'Castaño Restrepo', NULL, NULL, '2325690', '3168920070', '29877454', 'Calle 14b Nº 14-19', 'lizeth8822@yahoo.es', 1, 2),
(151, 4, 'VICTOR MANUEL', 'LUJAN', NULL, NULL, '8', '3153391410', '94479120', 'CR 8E No 185E-03', 'L', 1, 4),
(152, 1, 'ALPINA PRODUCTOS ALIMENTICIOS', 'S.A', NULL, NULL, '18000529999', NULL, '860025900-2', 'CRA 4 ZONA INDUSTRIAL', 'NULL', 1, 1),
(153, 2, 'SUPERMERCADO', ' EL CAMPESINO', NULL, NULL, '2242057', '2246156', '16340659-1', 'CARRERA 21 Nº 29-14', 'NULL', 1, 2),
(154, 2, 'CONSTRUHERRAMIENTAS', 'Gerardo Carvajal', NULL, NULL, '2241990', '2241990', '94391162-3', 'calle 26 Nº 22-30', 'NULL', 1, 2),
(155, 2, 'QUIMICOS PROQUIMPI', 'ELIZABETH TASCON', NULL, NULL, '2257309', NULL, '38740053-3', 'CARRERA 23 Nº 32-41', 'NULL', 1, 2),
(156, 2, 'EL ACIERTO', 'PUBLICIDAD', NULL, NULL, '2248704', NULL, '900.136.588-8', 'CALLE 23 Nº 22-35', 'NULL', 1, 2),
(157, 4, 'CRISTIAN CAMILO', 'VALENCIA MUÑOZ', NULL, NULL, '8364569', '3167278752', '1061701260', 'CALLE 35 N # 4B-81 CASA 312 AIDA LUCIA', 'CAMILOVMSP@HOTMAIL.COM', 1, 4),
(158, 2, 'ALFONSO', 'ROJAS', NULL, NULL, '2263163', '2263163', '2480812', 'ROLDANILLO', 'NULL', 1, 2),
(159, 4, 'ERICK ALEXANDER', 'GONZALEZ RODRIGUEZ', NULL, NULL, '8231197', '3156614209', '76324514', 'CRA 9 No 13NORTE 68', 'FIDOKONG8@GMAIL.COM', 1, 4),
(160, 1, 'Wendy Vanessa', 'Guauña ', NULL, NULL, 'NO TIENE', '3117539609', '96110607439', 'Cra 30 No. 26 B -97 casa 1', 'wendy199671@gmail.com', 2, 1),
(161, 2, 'MAKROLLAVES', 'MAKROLLAVES', NULL, NULL, '3172833288', '3172833288', '94152914', 'CENTRO', 'NULL', 1, 2),
(162, 4, 'SANDRA MILENA', 'SOLANO MUÑOZ', NULL, NULL, '8221780', '3117769375', '60336715', 'CALLE 16 No 7-38', 'SAMY2020@LIVE.COM.CO', 1, 4),
(163, 4, 'MARIA MERCEDES', 'CATAMUSCAY VIDAL', NULL, NULL, '8394242', '3136260822', '25291720', 'VEREDA SANTA BARBARA', 'NO TIENE', 1, 4),
(164, 4, 'ISABEL CRISTINA ', 'PUENTES MONTOYA', NULL, NULL, '8394242', '3183599064', '34568481', 'CALLE 56 # 10-86 CASA 19', 'DIRECCIONPOPAYAN@CENAL.COM.CO', 1, 4),
(165, 4, 'NURY MARCELA', 'ORDOÑEZ GARZON', NULL, NULL, '8361878', '3003176313', '1061686587', 'CLL 69 No 10-51 BELLO HORIZONTE', 'MARCELITA13@HOTMAIL.COM', 1, 4),
(166, 3, 'Jhon Alexander', 'Restrepo Martinez', NULL, NULL, '3158473509', '3158473509', '6.394.652', 'Cra 21 No. 16-18', 'No refiere', 1, 3),
(167, 3, 'El ', 'Pais', NULL, NULL, '2727475', '272 74 75', '890.301.752-1', 'Cll 29 No. 29-19', 'No refiere', 1, 3),
(168, 1, 'Fernando ', 'Bolivar', NULL, NULL, '444', NULL, '16761339', '#', '@', 1, 1),
(169, 1, 'Rodrigo ', 'Carlozama', NULL, NULL, '444', NULL, '6.248.837', '#', '@', 1, 1),
(170, 1, 'Arley ', 'Coll', NULL, NULL, '44', NULL, '11', '#', '@', 1, 1),
(171, 1, 'Alex ', 'Posada', NULL, NULL, '44', NULL, '11', '#', '@', 1, 1),
(172, 1, 'Jose', 'Gomez', NULL, NULL, '44', NULL, '14.997.662', '#', '@', 1, 1),
(173, 1, 'Alexander', 'Palacios', NULL, NULL, '44', NULL, '18400471', '#', '@', 1, 1),
(174, 2, 'DORA ANGELICA', 'ARIAS', NULL, NULL, '2322665', '2322665', '2322665', 'CRA 23 Nº 32-47', 'NULL', 1, 2),
(175, 1, 'Gerzon ', 'Escobar Córdoba ', NULL, NULL, '44', NULL, '16.761.793', '#', '@', 1, 1),
(177, 1, 'Heidi Vanessa ', 'Tamayo Molina', NULL, NULL, '4428082', '3184566288', '1130631210', 'Calle 66 No. 1 - 63 El porton de Cali Bolq 15 apto', 'heidi.tamayo@gmail.com', 1, 1),
(178, 1, 'Elizabeth ', 'López Sayago', NULL, NULL, NULL, NULL, '31539110', NULL, NULL, 1, 1),
(179, 1, 'Claudia Patricia', 'Carabali', NULL, NULL, '3146610995', '3146610995', '67022677', 'cra 4 sur # 10a-52', 'calenita84@hotmail.com', 1, 1),
(180, 1, 'Milena', 'Varón Rincón', NULL, NULL, NULL, NULL, '38462992', NULL, NULL, 1, 1),
(181, 1, 'Fabio', 'Moreno Hurtado', NULL, NULL, 'no tiene', 'no tiene', '94493469', 'Cra 120 H No 22-54', 'no tiene', 1, 1),
(182, 1, 'Carmen Elena', 'Pedroza Mera', NULL, NULL, NULL, NULL, '66653813', NULL, NULL, 1, 1),
(183, 1, 'Martha Isabel', 'Ramirez', NULL, NULL, '6624877', '3152480972', '66680651', 'Calle 71 No 8 A 32 B/ 7 DE AGOSTO', 'NO TIENE', 1, 1),
(184, 1, 'Carolina ', 'Motato Gañán', NULL, NULL, NULL, NULL, '67023302', NULL, NULL, 1, 1),
(185, 1, 'Ernesto Marcial', 'Burbano Oviedo', NULL, NULL, NULL, NULL, '87710465', NULL, NULL, 1, 1),
(186, 1, 'Claudia Lorena ', 'Montes Lugo', NULL, NULL, '4885568', '3174017102', '67014022', 'Calle 28 No 86 -70 apto 208', 'calidad@cenal.com.co', 1, 1),
(187, 3, 'Daniel Alberto', 'Sanchez Rojas', NULL, NULL, '3184492927', '3184492927', '94.328.888 ', 'Cra 15 No. 36-63', 'direccionadorpalmira@hotmail.com', 1, 3),
(188, 3, 'Martha', 'Hernandez', NULL, NULL, '3137989363', '3137989363', '31.163.759 ', 'Cra 40b No. 60-53', 'No refiere', 1, 3),
(189, 3, 'Coordinadora', 'S.A.', NULL, NULL, 'No refiere', 'No refiere', '890904.713-2', 'No refeire', 'NULL', 1, 3),
(191, 2, 'EL TABLOIDE', 'PUBLICIDAD', NULL, NULL, '2242868', '2240000', '891903615-8', 'CALLE 28 NRO  27-47', 'NULL', 2, 2),
(192, 3, 'El ', 'Acierto', NULL, NULL, '2757960', NULL, '900.136.588-8', 'Cll 32 No. 30-62', 'No refiere', 1, 3),
(193, 1, 'Deprisa', 'Avianca', NULL, NULL, '44', NULL, '890.100.577-6', '#', '@', 1, 1),
(194, 3, 'Julio Cesar ', 'Perea Agredo', NULL, NULL, '3158305452', '3158305452', '6.626.031', 'Cll 33 No. 32-47', 'No refiere', 1, 3),
(195, 4, 'PERIÓDICO ', 'EXTRA', NULL, NULL, '8208718', '3148791580', '900169179-0', 'CRA 6 No 5-78', 'NO TIENE', 1, 4),
(196, 2, 'DIAN', 'IMPUESTOS', NULL, NULL, '7912346', '7912346', '7912346', 'CENTRO', 'NULL', 1, 2),
(197, 2, 'TODO ELECTRICOS', 'ORLANDO MILLAN', NULL, NULL, '2257529', '2257529', '94255348-4', 'CRA  23 Nº  24-63', 'NULL', 1, 2),
(198, 2, 'ESPERANZA', 'PALACIOS', NULL, NULL, '3156992143', '3156992143', '29870683', 'LA MARINA', 'NULL', 1, 2),
(199, 2, 'KELLY ALEJANDRA', 'BEDOYA', NULL, NULL, '3165171315', '3165171315', '1116439754', 'CLL 42 B 33-45', 'NULL', 1, 2),
(200, 2, 'ELECTRICOS ', 'PEÑARANDA', NULL, NULL, '2323280', '2323280', '902.363.526-0', 'CRA 27 Nº 30-08', 'NULL', 1, 2),
(201, 2, 'MARIA IDALIA', 'MAHECHA AGUDELO', NULL, NULL, '2303719', '2303719', '66714791', 'CLL 13 Nº 10-11', 'NULL', 1, 2),
(202, 2, 'CARLOS ', 'GUTIERREZ', NULL, NULL, '2314882', '2314882', '94393118', 'CLL 10 9 B 15', 'NULL', 1, 2),
(203, 1, 'Coopservir', 'Ltda', NULL, NULL, '44', NULL, '830.011.670-3', '#', '@', 1, 1),
(204, 4, 'CAROLINA', 'ESCOBAR RIASCOS', NULL, NULL, '8213473', '3154935497', '25277683', 'B/CENTRO', 'CARITO0478@HOTMAIL.COM', 1, 4),
(205, 1, 'Envaquimicos', NULL, NULL, NULL, '44', NULL, '6.554.049', '#', '@', 1, 1),
(206, 1, 'TARJETA', 'CREDIREBAJA', NULL, NULL, '4854444', NULL, '805.001.030-6', '#', '@', 1, 1),
(207, 1, 'Unitel', 'S.A. E.S.P.', NULL, NULL, '44', NULL, '800.224.288-8', '#', '@', 1, 1),
(208, 4, 'JAIVER  ROSENDO', 'CADENA ', NULL, NULL, 'NO TIENE', '3115621324', '1061709352', 'CLL 4E No 57C-44 LOMAS DE GRANADA', '\'hoja_genio@hotmail.com\'', 1, 4),
(209, 1, 'Postobon', 'S.A.', NULL, NULL, '44', NULL, '890.903.939-5', '#', '@', 1, 1),
(211, 2, 'LAURA', 'PIMENTEL', NULL, NULL, '2268093', '3113539944', '29756558', 'CALLE 6 Nº 9-12', 'NULL', 1, 2),
(212, 2, 'SERVINDUSTRIALES S & S', 'JORGE CARDONA ', NULL, NULL, '3185685370', '3185685370', '94368670-7', 'CLL 26 B # 13 A -10', 'NULL', 1, 2),
(213, 2, 'INTER', 'RAPIDISIMO', NULL, NULL, '5625000', '5625000', '800251569-7', 'CRA 30 Nº 7-45', 'NULL', 1, 2),
(214, 4, 'ALBERTO', 'PIAMBA ALVAREZ', NULL, NULL, 'NO TIENE', '3153391410', '10549600', 'CALLE 17 No 2-75 SAUCES', 'NO TIENE', 1, 4),
(215, 4, 'ASTRID CAROLINA ', 'MOLTANVO', NULL, NULL, 'NO TIENE', '3154062399', '25378963', 'CALLE 5ta # 30-150 BARRIO LA SOMBRILLA', 'NO TIENE', 1, 4),
(216, 1, 'Max ', 'Copias', NULL, NULL, NULL, NULL, '16.603.062-3', NULL, 'maxcopiascali@hotmail.com', 1, 1),
(217, 2, 'DISTRI', 'LOPEZ', NULL, NULL, '2246365', '2246365', '31793322-1', 'CRA  23 Nº  28-67', 'NULL', 1, 2),
(218, 4, 'JAVIER MAURICIO ', 'URIBE', NULL, NULL, '8201044', '3172333611', '10293848', 'CRA 6 No 19 AN-11 CIUDAD JARDIN', 'NO TIENE', 1, 4),
(219, 4, 'JAVIER ', 'RODRIGUEZ', NULL, NULL, '8383818', '3154845523', '10233122', 'CRA 9 # 71N-39 BARRIO EL PLACER ', 'NO TIENE', 1, 4),
(220, 3, 'Cristian', 'Castillo', NULL, NULL, '315 376 64 61', '315 376 64 61', '13.991.814', 'Samanes', 'no refiere', 1, 3),
(221, 2, 'EL MAESTRO', 'Materiales para construccion', NULL, NULL, '2246367', '2246367', '16351145-3', 'CRA  24 Nº 28-47', 'NULL', 3, 2),
(222, 3, 'John James', 'Barona Obando', NULL, NULL, '3207654978', '3183171436', '94415294', 'Cll 16 No. 1-10', 'No refiere', 1, 3),
(223, 1, 'José Oliverio ', 'Palacios Lozano', NULL, NULL, NULL, NULL, '16.351.010', NULL, NULL, 1, 1),
(224, 2, 'ALEXANDER', 'TANGARIFE ZULUAGA', NULL, NULL, '3117744135', '3117744135', '94368302', 'DIAGONAL 21 A Nº 8-39', 'NULL', 1, 2),
(225, 1, 'Luis Eduardo', 'Garcia ', NULL, NULL, '3136109777', '3136109777', '6.381.669', 'LA BUITRERA', 'NO REFIERE', 1, 3),
(226, 1, 'COORDINADORA', 'C', NULL, NULL, '6902121', '6902121', '890904713-2', 'CLL 30A # 53-16', '@', 1, 1),
(227, 1, 'El comercio Electrico', 'S.A.S', NULL, NULL, '6605900', NULL, '890.323.635-2', 'AV ESTACION No 4N -75', '@', 1, 1),
(228, 3, 'Rodolfo Alejandro', 'Guevara Garcia', NULL, NULL, '3206872440', '3206872440', '94.283.197 ', 'carrera 23 Nº 32-41 ', 'direcciontulua@cenal.com.c', 1, 2),
(229, 2, 'CENTRO', 'ELECTRICOS ', NULL, NULL, '2257332', '2242759', '800.113.362', 'CLL 25 Nº 26-17', 'NULL', 1, 2),
(230, 2, 'CARLOS  HUMBERTO ', 'POLANCO PALACIOS', NULL, NULL, '3173685566', '3173685566', '94368799', 'CRA 26 23-31', 'NULL', 1, 2),
(231, 4, 'COMPAÑIA ENERGETICA ', 'DE OCCIDENTE', NULL, NULL, '8301000', '8301000', '900366010-1', 'CARRERA 7 No 1N-28', 'NO TIENE', 1, 4),
(232, 4, 'ACUEDUCTO Y ALCANTARRILLADO ', 'POPAYAN', NULL, NULL, '8321000', '8321000', '891500117-1', 'CALLE 3 No 4-21', 'WWW.ACUEDUCTO.COM.CO', 1, 4),
(233, 4, 'TELEFONICA ', 'MOVISTAR', NULL, NULL, '18000940099', '18000940099', '830122566-1', 'CRA 4 CLL 3 ESQUINA', 'WWW.MOVISTAR.CO/NEGOCIOS', 1, 4),
(234, 2, 'LA CASA', 'DEL ELECTRISISTA', NULL, NULL, '2243831', '2243831', '6490085-9', 'CLL 26 CRA 23 ', 'NULL', 1, 2),
(235, 4, 'EMPRESA DE TELECOMUNICACIONES ', 'DE POPAYÁN  S.A.. E.S.P.  EMTEL  ', NULL, NULL, '8222255', '8222255', '891502163-1', 'CL 5 No 5-68', 'NO TIENE', 3, 4),
(236, 4, 'ALEXANDER', 'CHANTRE', NULL, NULL, '3128024948', '3128024948', '4617189', 'CR 8 CL 7 -', 'CHANEYPRODUCCIONES@HOTMAIL', 1, 4),
(237, 2, 'PAPELERÍA', 'SANTA MARIA', NULL, NULL, '2251000', '2256000', '94377734-8', 'CRA 24 Nº 26-23', 'NULL', 1, 2),
(238, 2, 'EUFROCINA ', 'AMADOR', NULL, NULL, '3173122215', '3173122215', '21204627', 'Cra 32 No. 23-31  30 MIL', 'NULL', 1, 2),
(239, 1, 'Carolina', 'Osorio', NULL, NULL, '44', NULL, '30.398.858', '#', '@', 1, 1),
(240, 1, 'Laser cintas y', 'cintas', NULL, NULL, NULL, NULL, '6.054.874-4', NULL, NULL, 1, 1),
(241, 2, 'JOSE ANTONIO', 'ECHEVERRY', NULL, NULL, '3164957689', '3164957689', '14432183', 'CLL 29 CRA 40', 'NULL', 1, 2),
(242, 1, 'S.O.S Servicio occidental de ', 'Salud', NULL, NULL, NULL, NULL, '805.001.157-2', NULL, NULL, 1, 1),
(243, 4, 'RECARGAS ', 'CELULAR', NULL, NULL, 'NO TIENE', 'NO TIENE', '0', 'PUNTOS DE RECARGAS', 'NO TIENE', 1, 4),
(244, 2, 'ALIRIO', 'ALZATE', NULL, NULL, '3186843978', '3186843978', '16342661', 'URBANIZACION SAN FRANCISCO', 'NULL', 1, 2),
(245, 2, 'EMO', 'MATERIALES', NULL, NULL, '2251629', '2251629', '801.002.644.8', 'CALLE 25 Nº 20-65', 'NULL', 1, 2),
(246, 2, 'CAROL JOHANNA', 'SILVA', NULL, NULL, '3103839126', '3103839126', '31791799', 'TULUÁ', 'NULL', 1, 2),
(247, 1, 'Contanza ', 'Lozano de Chilito', NULL, NULL, NULL, NULL, '11', NULL, NULL, 1, 1),
(248, 1, 'Carvajal Informacion', 'S.A.S', NULL, NULL, NULL, NULL, '860.001.317-4', NULL, NULL, 1, 1),
(249, 1, 'Seguridad de ', 'Occidente ', NULL, NULL, NULL, NULL, '891.303.786-4', NULL, NULL, 1, 1),
(250, 2, 'FACHADAS Y ', 'DECORADOS', NULL, NULL, '2325016', '2325016', '31159740-9', 'CLL23 Nº 22-43', 'NULL', 1, 2),
(251, 3, 'Comercializadora', 'Giraldo S.A.', NULL, NULL, 'NO REFIERE', 'NO REFIERE', '805.027.970-1', 'CLL 31 No. 24-28', 'NO REFIERE', 1, 3),
(252, 2, 'Tuluá', 'Envases', NULL, NULL, '2252210', '2252210', '29307365-8', 'calle 24 nº 26-63', 'NULL', 1, 2),
(253, 2, 'REMATES', 'EL REY', NULL, NULL, '2252264', '2252264', '1114814626', 'CALLE 26 22-64', 'NULL', 1, 2),
(254, 2, 'BOLSAS', 'EL MEJOR PRECIO', NULL, NULL, '2253111', '2253111', '31194855-5', 'CLL 28 23-46', 'NULL', 1, 2),
(255, 2, 'DIEGO', 'VILLAREJO DUQUE', NULL, NULL, '2236384', '3165101505', '2514917', 'CARRERA 4 Nº 6-39', 'NULL', 1, 2),
(256, 1, 'Maria Jimena', 'Cardona', NULL, NULL, NULL, NULL, '31253777-2', NULL, NULL, 1, 1),
(257, 3, 'Epsa Energia del Pacifico', 'S.A.E.S.P', NULL, NULL, 'no refiere', '', '800.249.860-1', 'Cll 15 no. 29-b-30', 'no refiere', 1, 3),
(258, 3, 'FOTOCOPIAS', 'LA 31', NULL, NULL, 'NO REFIERE', NULL, 'NO REFIERE', 'NO REFIERE', 'NO REFIERE', 1, 3),
(259, 4, 'BIBIANA EDIVEY', 'CASTRO FRANCO', NULL, NULL, '8367329', '3148632192', '34571572', 'CRA 16 No 18N-161 CAMPAMENTO', 'BIBIANACASTRO01@HOTMAIL.COM', 1, 4),
(260, 4, 'ENVIA', 'MENSAJERIA Y MERCANCIAS', NULL, NULL, '0', NULL, '800.185.306-4', 'POPAYAN', 'NULL', 1, 4),
(261, 4, 'YENNIFER', 'PERDOMO GUEVARA', NULL, NULL, '8', '3207452852', '1061532981', 'CR 5 No 11-23 PIENDAMO', 'NO', 1, 4),
(262, 1, 'Servicampo del Valle', 'S.A.', NULL, NULL, '4855032', NULL, '900.232.113-4', 'CR 1 A # 46C-01', '@', 1, 1),
(263, 1, 'LUIS ALBERTO', 'ORTEGA', NULL, NULL, NULL, NULL, '16.669.271', NULL, NULL, 1, 1),
(264, 2, 'GLORIA IDALY ', 'HERRERA MARIN', NULL, NULL, '3116346018', '3116346018', '31.410.294', 'CRA 3 BIS # 3-70', 'GLORIAIDALYHERRARA@HOTMAIL.COM', 1, 2),
(265, 2, 'AMPARO ', 'LOAIZA TASCON', NULL, NULL, '44', '44', '66678549', 'BUGALAGRANDE', 'NULL', 1, 2),
(266, 1, 'JPTECHNOLOGY', NULL, NULL, NULL, NULL, NULL, '29126432', NULL, NULL, 1, 1),
(267, 4, 'SONIA', 'BRAVO DE MEJIA', NULL, NULL, '8240719', '8240719', '345295861', 'CARRERA 6 No 6-69', 'NO TIENE', 1, 4),
(268, 4, 'JUNY', 'PANTOJA', NULL, NULL, '3162892920', '3173812011', '103332251', 'CALLE 6 No 2N-06 B/ BOLIVAR PASAJE SAN VICTORINO', 'NO TIENE', 1, 4),
(269, 1, 'Gigabyte', 'Colombia  Ltda.', NULL, NULL, '6679816', '3958451', '805.026.215-1', 'pasarela', 'gigabyte_colombia@yahoo.com', 1, 1),
(270, 2, 'IMPRE', 'SISTEMAS', NULL, NULL, '2256177', '3015464697', '29877839-1', 'CLL 33 Nº 20-29', 'NULL', 1, 2),
(271, 3, 'FERRETERIA', 'SOLO LLAVES', NULL, NULL, '2723568', NULL, '16.257.762-6', 'Cll 28 No. 26-51', 'No refiere', 1, 3),
(272, 1, 'BERTHA ISABEL', 'PERLAZA', NULL, NULL, NULL, NULL, '66.778.689', NULL, NULL, 1, 1),
(273, 3, 'Sandra Marcela', 'Jaramillo', NULL, NULL, '3127112002', NULL, '1.114.820.572', 'Cll 70A No. 26-86', 'No refiere', 1, 3),
(274, 2, 'ALBA LUCIA', 'GOMEZ MARTINEZ', NULL, NULL, '3122885107', '3122885107', '29337289', 'CARRRERA 20 Nº 17-03', 'NULL', 1, 2),
(275, 3, 'Juliana Andrea', 'Cuetia Lodoño', NULL, NULL, '2868104', NULL, '1.113.620.706', 'Cll 34a No. 41-64', 'No refiere', 1, 3),
(276, 2, 'JOSE IGNACIO', 'MORENO', NULL, NULL, '3154660947', '3154660947', '16350227', 'CRA 25 CON CLL 25 ESQUINA ', 'NULL', 1, 2),
(277, 2, 'CECILIA', 'AGUDELO PATIÑO', NULL, NULL, '44', '44', '66716028', 'CLL 26', 'NULL', 1, 2),
(278, 1, 'Erick ', 'Florez', NULL, NULL, NULL, NULL, '11', NULL, NULL, 1, 1),
(279, 2, 'MARIO FERNANDO', 'GARZON LOZANO', NULL, NULL, '3172856844', '3172856844', '14885754', 'CALLE 5 N. 18-46', 'mario_moon_full@yahoo.es', 1, 2),
(280, 4, 'RAFAEL ALBEIRO ', 'RENGIFO NIQUINAS', NULL, NULL, '8', '3136864505', '10306638', 'CALLE 4ta # 41-06 ', 'NO', 1, 4),
(281, 1, 'PAGINAS TELMEX DE COLOMBIA S.A.', 's.a.', NULL, NULL, '4882800', NULL, '900135887-0', 'AV 8N No. 24AN-07', 'NULL', 1, 1),
(282, 4, 'DIEGO', ' ROA ROA ', NULL, NULL, '8314666', '3186900108', '79567569', 'CARRERA 6A No 3N-45 CENTRO COMERCIAL LA ESTACION', 'NO TIENE', 1, 4),
(283, 2, 'MARIA CELIDES', 'PEREZ DE CASTRO', NULL, NULL, '2236150', '2236150', '29302878', 'BUGALAGRANDE', 'NULL', 1, 2),
(284, 1, 'Office ', 'Depot', NULL, NULL, NULL, NULL, '900023386-1', NULL, NULL, 1, 1),
(285, 4, 'SANDRA MILENA ', 'PISSO SERNA', NULL, NULL, '8369770', '3122958699', '25108554', 'CALLE 12C No18  B – 78 B/ PAJONAL', 'Samipisohotmail.com', 1, 4),
(286, 3, 'AQUA OCCIDENTE', 'S.A.E.S.P', NULL, NULL, 'NO REIFERE', '2717300', '900.651.752-8', 'CENTRO', 'NO REFIERE', 1, 3),
(287, 3, 'TELMEX  - CLARO', 'COLOMBIA S.A.', NULL, NULL, 'NO REFIERE', NULL, '830.053.800-4', 'NO REFIERE', 'NO REFIERE', 1, 3),
(288, 3, 'D.T.R DISTRIBUIDORA', 'DE TORNILLOS Y REMACHES', NULL, NULL, '2758555', '0', '31.179.226-1', 'Cll 28 No. 28-36', 'NO REFIERE', 3, 3),
(289, 4, 'IRMA', 'CHIMBORAZO AÑASCO', NULL, NULL, 'NO TIENE', '3136094186', '34537807', 'KRA 10 # 22A-06 LOMA DE LA VIRGEN ', 'NO TIENE', 1, 4),
(290, 1, 'EL PAIS', 'S.A.', NULL, NULL, '99999', '3116424879', '99999', 'N/A', 'NULL', 1, 1),
(291, 1, 'SOFIA', 'AMAYA TRASLADIÑA', NULL, NULL, '3754443', '3127163309', '68248920', 'CLL 1C # 70-63 LOURDES', 'NULL', 1, 1),
(292, 1, 'Gabriela', 'Cuero', NULL, NULL, NULL, NULL, '66.865.383', NULL, NULL, 1, 1),
(293, 2, 'FERRETERIA', 'VALVULAS Y GRIFO', NULL, NULL, '2315246', '3154069483', '16362590-5', 'CRA 18 Nº 23-26', 'NULL', 1, 2),
(294, 4, 'AURA VICTORIA ', 'RANGEL DE MESA', NULL, NULL, 'NO TIENE', '3188247011', '4739593', 'CALLE 68 # 17-09 BELLO HORIZONTE', 'NO TIENE', 1, 4),
(296, 2, 'DIANA  CAROLINA', 'GALVEZ', NULL, NULL, '3172366822', '3172366822', '1116232097', 'CLL 15 A # 15 E 03', 'NULL', 1, 2),
(297, 1, 'Fabio Hernan', 'Gaviria Muñoz', NULL, NULL, NULL, NULL, '16.666.927', NULL, NULL, 1, 1),
(298, 1, 'Bienco', 'S.A.', NULL, NULL, NULL, NULL, '805000082-4', NULL, NULL, 1, 1),
(299, 3, 'TIENDA', 'DEL ASEO', NULL, NULL, '2723322', NULL, '16.252.139-4', 'Cll 29 No. 28-24', 'No refiere', 1, 3),
(300, 1, 'ARCADIO ANTONIO', 'CASTAÑEDA ORTIZ', NULL, NULL, '3207413630', NULL, '70113861', 'CLL 51 OESTE # 12-01 EL COTIJO', 'NULL', 1, 1),
(301, 4, 'LUCERO AMPARO ', 'PARRA TOBAR ', NULL, NULL, '8364001', '8364001', '34531534-3', 'CRA 3 No 1-31 B/ LA PAMBA ', 'NO TIENE', 1, 4),
(302, 1, 'CEDELEC ', 'LTDA', NULL, NULL, NULL, NULL, '805022354-7', NULL, NULL, 1, 1),
(303, 2, 'VARIEDADES', 'FARIDE', NULL, NULL, '2259104', '2259104', '2259104', 'CRA  25 Nº  27-58', 'NULL', 1, 2),
(304, 4, 'COORDINADORA ', 'MERCANTIL', NULL, NULL, 'NO TIENE', 'NO TIENE', '890904713-2', 'POPAYAN', 'NO TIENE', 1, 4),
(305, 1, 'Felina', 'Nupan', NULL, NULL, '3107252930', NULL, '27.293.554', 'CLL 13 No. 11A-22', 'NO REFIERE', 1, 3),
(306, 1, 'Jhon Eduard ', 'Pino Chamorro', NULL, NULL, '3815903', '3003989997', '1130622982', 'CRA 67 A 40 -47', 'je.edward@hotmail.com', 1, 1),
(307, 2, 'JOSE DOMINGO', 'CUARAN', NULL, NULL, '3165811562', '3165811562', '16791654', '44', 'NULL', 1, 2),
(308, 1, 'ALVARO', 'CORREA BUSTAMANTE', NULL, NULL, '3117060198', NULL, '6226788', 'CLL 34 # 1A-13 B/ SANTANDER', 'NULL', 1, 1),
(309, 4, 'JORGE HERNAN', 'NIEVES ROJAS', NULL, NULL, '8', '3117348982', '76319055', 'CRA 15 CALLE 28 SALON COMUNAL MIRADOR ', 'NO ', 1, 4),
(310, 4, 'LILIA MARIA ', 'COTAZO NARVAEZ', NULL, NULL, '8243703', 'NO TIENE', '34320083-8', 'CRA 9 No 6-34', 'NO TIENE', 1, 4),
(311, 1, 'PAN Y', 'QUESO', NULL, NULL, '4453551', NULL, '890315845-9', 'AV 6', 'NULL', 1, 1),
(312, 3, 'POLIBOLSAS', 'S.A.S', NULL, NULL, '2733814', NULL, '900.419.442-7', 'Cll 28 No. 28-62', 'No refiere', 1, 3),
(313, 2, 'COORDINADORA', 'TRANSPORTADORA', NULL, NULL, '2246996', '2246996', '890.904.713-2', 'TULUA', 'NULL', 1, 2),
(314, 1, 'Comercializadora Nacional SAS', 'Ltda', NULL, NULL, NULL, NULL, '830.040.709-5', NULL, NULL, 1, 1),
(315, 1, 'Miriam ', 'Rivera Peralta', NULL, NULL, 'no tiene', '316-5396976', '26.559.971', 'Calle 3 b No 96 -19', 'myriam4.40@hotmail.com', 1, 1),
(316, 4, 'ROBINSON DAVID ', 'RAMIREZ TORO', NULL, NULL, '8', '3127981364', '10293078', 'CR 10 No 21-02 - EL DEAM', 'royson.05@gmail.com', 1, 4),
(317, 2, 'ALDEMAR', 'VARGAS MEDINA', NULL, NULL, '3174319669', '3174319669', '94480514', 'CLL 22 A # 11-25 ', 'ALVAME212@HOTMAIL.COM', 1, 9),
(318, 3, 'ELECTRONICA TV ', 'Y VIDEO ', NULL, NULL, '2739885', NULL, '31.998.001-3', 'Cll 31 No. 24-07', 'No refiere', 1, 3),
(319, 4, 'HERNAN', 'VALENCIA', NULL, NULL, '8', '3166148748', '4532000', 'CR 6 No 26AN - 90', 'NO REPORTA', 1, 4),
(320, 1, 'Dongee', '1', NULL, NULL, NULL, NULL, '1', NULL, NULL, 1, 1),
(321, 4, 'VIVIANA ', 'LOPEZ TOBAR', NULL, NULL, '8202774', '8235878', '43612869-6', 'CRA 6A No 2N-78', 'NO TIENE', 1, 4),
(322, 1, 'ELISABETH', 'LOPEZ CASTRILLON ', NULL, NULL, '3166762655', NULL, '38901409', 'CLL 55 # 32A-115 B/ COMUNEROS I', 'NULL', 1, 1),
(323, 1, 'AQUILEO', 'NIEVA QUINTANA', NULL, NULL, '4326345', NULL, '94310557', 'CRA 1A 4D #73-03 B/ SAN LUIS ', 'NULL', 1, 1),
(324, 1, 'ROSALINDA FABIOLA', 'ESPINOSA GORSILLO', NULL, NULL, '3132265413', NULL, '143656', 'CRA 16 #73-04 B/ ANDRES SANIN', 'NULL', 1, 1),
(325, 1, 'JUAN CARLOS', 'MENA', NULL, NULL, '4868615', '3136337280', '6221077', 'TRAV 72 F3 #D28D3-31 B/ YIRA CASTRO', 'NULL', 1, 1),
(326, 1, 'CARLOS JULIO', 'HUMBARILA ALVARADO', NULL, NULL, '3207014200', NULL, '7131482', 'CRA 28C #72U-44 B/ POBLADO II', 'NULL', 1, 1),
(327, 4, 'MADERAS ', 'EL BOSQUE', NULL, NULL, '8234923', '8234923', 'NO REFIERE', 'CRA 6 No 1N-04 B/BOLIVAR', 'NO TIENE', 1, 4),
(328, 2, 'CETSA', 'ELECTRICIDAD', NULL, NULL, '44', '44', '891.900.101-0', 'TULUÁ', 'NULL', 1, 2),
(329, 2, 'EDGAR LEANDRO', 'CRUZ COCONUBO', NULL, NULL, '3177627857', '3177627857', '1116234199', 'CLL 4 19-46', 'NULL', 1, 2),
(330, 2, 'SERVIPINTURAS', '..', NULL, NULL, '2254448', '2254448', '94153087-9', 'CALLE 22 Nº 23-20', 'NULL', 1, 2),
(331, 1, 'Via ', 'Baloto', NULL, NULL, NULL, NULL, '11', NULL, NULL, 1, 1),
(332, 1, 'Representaciones ', 'Calimetal Ltda', NULL, NULL, NULL, NULL, '805.010.668-2', NULL, NULL, 1, 1),
(333, 4, 'DANIEL ', 'ARBOLEDA ORDOÑEZ', NULL, NULL, '8', '3006207554', '4617710', 'PARCELACION LA FORTALEZA CASA 52', 'NO ', 1, 4),
(334, 4, 'ARTURO', 'LOPEZ OROZCO ', NULL, NULL, '8204547', '3136150548', '76313817-0', 'CRA 6 No 22n-35', 'NO TIENE', 1, 4),
(335, 4, 'LUZ CIELO ', 'BOLAÑOS ', NULL, NULL, '82280886', 'NO TIENE ', '34544042-8', 'CALLE 7 No 4-41 ', 'NO TIENE', 1, 4),
(336, 4, 'FERRETERIA Y ELECTRICOS ', 'LA REBAJA', NULL, NULL, '8234993', 'NO TIENE', '1061724070-6', 'CRA 6 No 21-13', 'NO TIENE', 1, 4),
(337, 4, 'MARTHA MERCEDES', 'PAZ CASTRO', NULL, NULL, '8', '3137251020-313740268', '34.331.309 ', 'Bloques de la Estancia Apto A-101  ', 'lunitamia101@hotmail.com ', 1, 4),
(338, 1, 'ASEGURADORA SOLIDARIA ', 'ENTIDAD COOPERATIVA', NULL, NULL, 'NA', '3174275592', 'na', 'JESUS ANDRES HERNANDEZ', 'andres2453@hotmail.com', 1, 1),
(339, 2, 'DIANA CAROLINA ', 'ARISTIZABAL ', NULL, NULL, '3155074633', '3155074633', '29761024', '44', 'NULL', 1, 2),
(340, 2, 'VIVERO', 'EL ROSAL', NULL, NULL, '2319719', '2319719', '900485012-4', 'CLL 27 Nº 3 OESTE  -52 ', 'NULL', 1, 2),
(341, 3, 'SEGURIDAD ', 'ATLAS LTDA', NULL, NULL, '2723474', NULL, '890.312.749-6 ', 'CLL 32 28-23', 'NO REFIERE', 1, 3),
(342, 2, 'estación', 'de la moda', NULL, NULL, '2257671', '2257671', '16363343-7', 'cra 22 nº 26 a-24', 'NULL', 1, 2),
(343, 4, 'CAROLINA', 'MOTATO GAÑAN', NULL, NULL, '8', '3184094190', '67023302', 'CENAL-CALI', 'M', 1, 4),
(344, 3, 'DANIEL ALEJANDRO', 'SAAVEDRA ', NULL, NULL, '3172812469', '3172812469', '1.113.638.693-4', 'CLL 31 No. 23-73', 'NO REFIERE', 1, 3),
(345, 2, 'RESIDUOS', 'HOSPITALARIO', NULL, NULL, '6665123', '6665123', '805007083-3', '44', 'NULL', 1, 2),
(346, 4, 'JOQUIN HERIBERTO', 'SANCHEZ ', NULL, NULL, '3154132765', '3183575590', '1271463-6', 'CALLE 57 No 10-55 ', 'SAUJH@HOTMAIL.COM', 1, 4),
(347, 2, 'MARIA MATILDE', 'OSPINA GUTIERREZ', NULL, NULL, '2315860', '2315860', '29886570', 'CALLE 27W Nº 21-95', 'NULL', 1, 2),
(348, 2, 'MARIA ROSALBA', 'LOPEZ LOPEZ', NULL, NULL, '2325860', '2325860', '29755804', 'CALLE 8 Nº 12-02', 'NULL', 1, 8),
(349, 1, 'Angeles Ferreteria', 'Limitada', NULL, NULL, NULL, NULL, '805.015.034-6', NULL, NULL, 1, 1),
(350, 1, 'Norma Helena ', 'Valdes Sarmiento', NULL, NULL, 'NO TIENE', '3182386342', '51.998.198', 'calle 54 b No. 48-b 96', 'normav2905@hotmail.com', 1, 1),
(351, 1, 'Sodimac Colombia', 'S.A.', NULL, NULL, NULL, NULL, '800.242.106-2', NULL, NULL, 1, 1),
(352, 3, 'Jackeline', 'Bohorquez Duque', NULL, NULL, '3117631931', '3117631931', '29.663.117', 'Cll 38 No. 1B-17', 'No refiere', 1, 3),
(353, 1, 'Rafael Ricardo', 'Santisteban', NULL, NULL, '3771328', '3015870832', '1.090.398.679', 'CALLE 4 No 6 32 APTO304', 'santistebandvm@hotmail.com', 1, 1),
(354, 3, 'Mary Luz ', 'Rodriguez Alzate', NULL, NULL, '2707772', '3182825139', '43.984.216', 'Cra 44 NO. 35-63', 'No refiere', 1, 3),
(355, 2, 'diego fernando ', 'florez', NULL, NULL, '3173763019', '3173763019', '3086739', 'tuluá', 'NULL', 1, 2),
(356, 2, 'ALARMAS', 'DISSEL LTDA', NULL, NULL, '2262390', '2262390', '816000348-8', 'ALVERNIA', 'NULL', 1, 2),
(357, 1, 'Grupo M. Y. M ', 'Cerrajeria', NULL, NULL, NULL, '3172510816', '900.177.271-4', 'homecenter', NULL, 1, 1),
(358, 4, 'JORGE LUIS ', 'MINA ', NULL, NULL, '3104191953', '3104191953', '16590091', 'CALLE 6 CRA 17 B/ LA ESMERALDA', 'POPAYASO-2011@HOTMAIL.COM', 1, 4),
(359, 2, 'DECOR', 'PANEL', NULL, NULL, '2245539', '2245539', '66714009-0', 'CARRERA 24 Nº 28-02', 'NULL', 1, 2),
(360, 2, 'FERRETERIA', 'MODERNA', NULL, NULL, '2242825', '2242825', '31198962-3', 'TULUÁ', 'NULL', 1, 2),
(361, 3, 'Migdalia ', 'Hurtado Serna', NULL, NULL, '3217258558', '3217258558', '30.305.156', 'Cra 26 No. 39-08', 'No refiere', 1, 3),
(362, 4, 'MOLDURAS DE COLOMBIA  LIMITADA', 'MODUCOL LTDA', NULL, NULL, '8319186', '8319187', '817000351-4', 'CALLE 1 NORTE 3-08', 'NO TIENE', 1, 4),
(363, 4, 'ABRAHAM', 'GARCIA LONDOÑO', NULL, NULL, '8369863', '3003700882', '4611706', 'CL 57N No 10-113', 'sam242916@hotmail.com', 1, 4),
(364, 2, 'ELECTRICOS LA', '28', NULL, NULL, '2249497', '2249497', '16354270-1', 'TULUA', 'NULL', 1, 2),
(365, 1, 'PRISCILA', 'VALENCIA ', NULL, NULL, '3155165113', NULL, '66769743', 'CRA 83 # 28-02 B/ MOJICA', 'NULL', 1, 1),
(366, 2, 'JESUS ', 'VELASQUEZ', NULL, NULL, '44', '44', '16353752', 'TULUÁ', 'NULL', 1, 2),
(367, 2, 'RAMIRO', 'CORTES', NULL, NULL, '44', '44', '2.536.982', 'LA MARINA', 'NULL', 1, 2),
(368, 2, 'EL', 'CAMPESINO', NULL, NULL, '2242057', '2242057', '16340659-1', 'TULUÁ', 'NULL', 1, 2),
(369, 2, 'CENTRO', 'AGUAS', NULL, NULL, '2317070', '2317070', '821002115-6', '44', 'NULL', 1, 2),
(370, 2, 'MOVISTAR', 'TELECOMUNICACIONES', NULL, NULL, '1800940099', '1800940099', '830.122.566-1', 'TULUÁ', 'NULL', 1, 2),
(371, 2, 'TRIPLEX', 'AGLOMERADOS', NULL, NULL, '2320434', '2320434', '6208127-3', 'CRA 23 Nº 28-48 ', 'NULL', 1, 2),
(372, 1, 'Alexander ', 'Castellano', NULL, NULL, NULL, NULL, '11', NULL, NULL, 1, 1),
(373, 2, 'EDGAR', 'LOPEZ PEREA', NULL, NULL, '3182881971', '3182881971', '2631888', 'CARRERA 1 OESTE Nº 26C 12 -04', 'NULL', 1, 2),
(374, 4, 'ALMACEN', 'EL ASEO', NULL, NULL, '8243294', '8206440', '800188369-1', 'CR 4 No 6-34', 'N', 1, 4),
(375, 4, 'ALMACENES', 'EXITO S.A', NULL, NULL, '8243500', '8243500', '890900608-9', 'CENTRO-PANAMEICANO', 'M', 1, 4),
(376, 1, 'OfiService', NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, 1, 1),
(377, 1, 'Carmen Elena ', 'Pedroza Mera', NULL, NULL, NULL, NULL, '66.653.813', NULL, NULL, 1, 1),
(378, 2, 'JORGE ALEXANDER', 'CARDONA', NULL, NULL, '3186585370', '3186585370', '94368670', 'CLL 26 B 13 A 10', 'NULL', 1, 2),
(379, 1, 'FRAGAN ', 'EL PERFUMERO', NULL, NULL, '6805555', '3136082811', '900402121-3', 'AV 6 # 29AN-44', 'NULL', 1, 1),
(380, 1, 'INCAUCA', 'S.A.', NULL, NULL, '4183000', NULL, '891300237-9', 'CARRERA 9 No. 28-103', 'jbhernandez@incauca.com', 1, 1),
(381, 1, 'Lizeth Maglieni', 'Galeano', NULL, NULL, NULL, NULL, '11', NULL, NULL, 1, 1),
(382, 2, 'ADRIANA CRISTINA', 'BELEÑO OLAYA', NULL, NULL, '3202883003', '3202883003', '1032383683', '44', 'NULL', 1, 2),
(383, 1, 'Daniel ', 'Mendoza', NULL, NULL, NULL, NULL, '16.932.251', NULL, NULL, 1, 1),
(384, 1, 'Almacen tecnichapas', 'y vidrios del norte', NULL, NULL, '6678074', '3164228320', '1.130.641.284-8', 'Av. 3A NTE No 23 DN -51', NULL, 1, 1),
(385, 3, 'LA', 'MARDEN LTDA', NULL, NULL, 'NO REFIERE', NULL, '800.004.599-1', 'NO REFIERE', 'NO REFIERE', 1, 3),
(386, 4, 'DIVA EMERITA ', 'URBANO REALPE', NULL, NULL, '8362313', '3217872315', '27450347', 'CRA 17 # 62N-04 EL UVO', 'NO TIENE', 1, 4),
(387, 2, 'DISEÑOS', 'PROFESIONALES', NULL, NULL, '6504420', '3148866490', '1.130.671.638-1', 'CALI', 'NULL', 1, 1),
(388, 1, 'PUBLICAR', 'S.A.', NULL, NULL, 'NA', 'NA', 'NA', 'AV 3N CLL 52', 'NA', 1, 1),
(389, 1, 'Dispapeles', 'S.A.', NULL, NULL, '8851717', NULL, '860.028.580-2', 'CL 24 No 4 -63', NULL, 1, 1),
(390, 2, 'MADERAS', 'LA VICTORIANA', NULL, NULL, '2259250', '2259250', '6384081', 'CLL 31 ', 'NULL', 1, 2),
(391, 1, 'P.I.L.A.', 'PAGO SIMPLE', NULL, NULL, 'NN', 'NN', 'NN', 'NN', 'NN', 1, 1),
(392, 4, 'MILTON VICENTE', 'VIVAS CORDOBA', NULL, NULL, '3148368793', '3157405121', '98364040', 'CL 4 No 36 - 104', 'N', 1, 4),
(393, 1, 'HELMAN ENRIQUE', 'CABAL', NULL, NULL, '3137155280', NULL, '16618675', 'CLL 23 # 43-06 B/ SAN JUDAS ', 'NULL', 1, 1),
(394, 2, 'PLASTICOS Y DESECHABLES', 'TULUÁ', NULL, NULL, '2246006', '3157900397', '66683086-3', 'CRA 23 Nº  28-28 ', 'NULL', 1, 2),
(395, 1, 'MARIA ENRIQUETA', 'DE LA CRUZ DE LUNA ', NULL, NULL, '6622317', '3153775673', '38995261', 'CRA 7FBIS # 73-18 LOPEZ', 'NULL', 1, 1),
(396, 1, 'LEVALLEJO AZ', ' S.A.', NULL, NULL, '4869696', NULL, '800254012-0', 'CRA 1 32-50 ', NULL, 1, 1),
(397, 1, 'Talleres multillaves y vidrios', 'LA ESTACION', NULL, NULL, NULL, NULL, '16988213-0', NULL, NULL, 1, 1),
(398, 2, 'FERRETERIA ', 'EL SOCIO', NULL, NULL, '2308462', '2308462', '66717253-5', 'CALLE 25 Nº  4W-25', 'NULL', 1, 2),
(399, 4, 'ALMACEN  SI', 'POPAYAN', NULL, NULL, 'NO TIENE', 'NO TIENE', '890301753-9', 'POPAYAN', 'NO TIENE', 1, 4),
(400, 2, 'PINTURAS', 'LA 25', NULL, NULL, '2312730', '2312730', '2312730', 'TRANSVERSAL 12 ', 'NULL', 1, 2),
(401, 4, 'EDITORIAL', 'EL LIBERAL S.A', NULL, NULL, '8242418', '8242418', '891500056-0', 'CR 3 No 2 - 60', 'N', 1, 4),
(402, 2, 'muebles y diseños', 'a moda', NULL, NULL, '3206080483', '3206080483', '3206080483', 'cra 29 nº  21-75', 'NULL', 1, 2),
(403, 4, 'FERRETERIA MUNDIAL', 'LTDA', NULL, NULL, '8230925', '3154801856', '891502443-7', 'CALLE No 6-17', 'NO TIENE', 1, 4);
INSERT INTO `proveedores` (`id`, `sede_id`, `nombres`, `apellidos`, `created_at`, `deleted_at`, `telefono`, `celular`, `num_documento`, `direccion`, `email`, `identificacion_id`, `ciudad_id`) VALUES
(404, 3, 'MEGATON', 'LTDA', NULL, NULL, '2818668', NULL, '16.267.829-3', 'CLL 30 NO. 23-62', 'NO REFIERE', 1, 3),
(405, 4, 'RICARDO ANDRES ', 'LOPEZ LEDEZMA', NULL, NULL, '8235093', '3186911733', '10306916', '6B # Nº 27 n 06', 'rianlopz@hotmail.com', 1, 4),
(406, 4, 'JOSE LEONEL', 'ZAMBRANO ', NULL, NULL, '3178447604', '3178447604', '94324502', 'CR 2 VEREDA POMONA', 'N', 1, 4),
(407, 1, 'Dagoberto', 'Diaz', NULL, NULL, NULL, NULL, '16697727', NULL, NULL, 1, 1),
(408, 1, 'NURY', 'BETANCOURT BALCAZAR', NULL, NULL, '4340764', '3176774005', '31903545', 'CLL 72L #3N-02 B/ FLORALIA ', 'NULL', 1, 1),
(409, 2, 'GASES ', 'DE OCCIDENTE', NULL, NULL, '4187333', '4187333', '800169643-5', 'TULUÁ', 'NULL', 1, 2),
(410, 1, 'YULIANA ANDREA', 'LONDOÑO ARANGO', NULL, NULL, '4001282', NULL, '38886191', 'CRA 27D # 74-84 B/ ALFONSO BONILLA ARAGON', 'NULL', 1, 1),
(411, 1, 'Zoomarcanes y', 'compañia Ltda.', NULL, NULL, '6608288', '3146205813', '830.513.430-7', 'AV 6N 28N 75', 'zoomarcanescia@hotmail.com', 1, 1),
(412, 3, 'JEY LARRY ', 'ALVARADO GARCIA', NULL, NULL, '3163864356', NULL, '6.393.547', 'Cra 28 No. 6-12', 'No refiere', 1, 3),
(413, 3, 'Maritza ', 'Cordoba de La Cruz', NULL, NULL, '3137691198', NULL, '1.113.517.106', 'Cll 5 No. 5-46', 'No refiere', 1, 3),
(414, 3, 'Punto Lamparas', 'y electricos', NULL, NULL, '2707524', NULL, '94.426.675-2 ', 'Cra 25 No. 30-55', 'No refiere', 1, 3),
(415, 1, 'Eliana Liceth ', 'Viveros Idrobo', NULL, NULL, '6659589', '3105466022', '76.967.936', 'Calle 70 nte No. 2 AN 151 ALAMOS', 'eliana2679@hotmail.com', 1, 1),
(416, 4, 'LUZ ANGELA', 'PALACIOS GAÑAN', NULL, NULL, '6817301', '31', '38559682', 'CENAL CALI', 'NO', 1, 4),
(417, 3, 'Bernardo ', 'Montoya Echeverri', NULL, NULL, '2861365', '318 889 63 94', '14.697.327', 'Cll 16 No. 33a-68 ', 'No refiere', 1, 3),
(418, 4, 'CÁMARA DE COMERCIO ', 'POPAYAN', NULL, NULL, 'NO TIENE', 'NO TIENE ', '891580011-1', 'POPAYAN', 'NO TIENE', 1, 4),
(419, 4, 'ELSA CECILIA   ', 'SANCHEZ', NULL, NULL, 'NO TIENE', 'NO TIENE', '31208805-1', 'CRA 5 No 5-01', 'NO TIENE', 1, 4),
(420, 2, 'JUAN CARLOS ', 'CARDENAS TANGARIFE', NULL, NULL, '3172921881', '3172921881', '1116248404', 'CLL 26 C1 110', 'NULL', 1, 2),
(421, 1, 'Ramiro ', 'Ramirez', NULL, NULL, '1', '1', '11', '1', '1', 1, 1),
(422, 1, 'Julio', 'Quinde', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1),
(423, 2, 'HELADERIA', 'RICO TOMASITO', NULL, NULL, '2243952', '2243952', '31188446-1', 'CALLE  26 Nº 32A-04', 'NULL', 1, 2),
(424, 2, 'YENY ANDREA ', 'HERNANDEZ  MARIN ', NULL, NULL, '3186167605', '3186167605', '1.116.233.722', 'TULUÁ', 'NULL', 1, 2),
(425, 1, 'Ferro Variedades', 'LA NEGRA', NULL, NULL, NULL, '3117037874', '31,963761', 'CRA. 8 CALLE 16 FRENTE AL 7-123', NULL, 1, 1),
(426, 1, 'Mega Papelería', 'El Cid', NULL, NULL, '8831230', '8831457', '3.608.417-1', 'Carrera 9 No. 11-39', '@', 1, 1),
(427, 4, 'CLAUDIA ALEJANDRA ', 'QUICENO ARCE', NULL, NULL, '8372093', '3012857615', '25285311', 'CRA 21 No 8-23 B/ GUAYABAL', 'CLAUDIALEJANDRAQUICENOARCE@HOTMAIL.COM', 1, 4),
(428, 4, 'ALBA MARIA ', 'SANCHEZ MACA ', NULL, NULL, '8201737', '3153162539', '1061701775', 'CALLE 28 BN No 329 YANACONAS ', 'ALBAMAR28@HOTMAIL.COM', 1, 4),
(429, 1, 'LEXCO', 'S.A.', NULL, NULL, '6679647', 'fax 6612468', '860.515.402-9', 'AV. ESTACION No 5c 72', '@', 1, 1),
(430, 1, 'NCopias', NULL, NULL, NULL, NULL, NULL, '5.558.343-5', NULL, NULL, 1, 1),
(431, 2, 'ANGELICA', 'ARIAS BETANCUR', NULL, NULL, '2235508', '2235508', '29142192', 'ANDALUCIA', 'NULL', 1, 5),
(432, 1, 'Claudia', 'Bonilla Ibarra', NULL, NULL, '2870143', '3166668062', '29.661.731', 'CLl 47 # 45 a 58 ', 'NO REFIERE', 1, 3),
(433, 2, 'MUNICIPIO ', 'TULUÁ', NULL, NULL, '44', '44', '891900272-1', 'TULUÁ', 'NULL', 1, 2),
(434, 1, 'Luceli', 'Lucumi', NULL, NULL, NULL, NULL, '1.143.853.471', NULL, NULL, 1, 1),
(435, 3, 'Cruz Merania', 'Moncayo Josa', NULL, NULL, '2869131', '3127408127', '1.085.248.987', 'Cll 53 No. 32a-05', 'No refiere', 1, 3),
(436, 2, 'HOMECENTER', 'ALMACEN', NULL, NULL, '18000115150', '18000115150', '800242106-2', 'CALI', 'NULL', 1, 2),
(437, 2, 'EFRAIN ', 'ARBOLEDA SAAVEDRA', NULL, NULL, '3164055042', '3164055042', '94151777', 'CALLE  26 A # 13-61', 'PSICOARBOLEDA@GMAIL.COM', 1, 2),
(438, 1, 'Cesar Arnol ', 'Silva Beltran', NULL, NULL, NULL, NULL, '94.384.823', NULL, NULL, 1, 1),
(439, 2, 'JULIAN ANDRES ', 'VELASQUEZ JOVEN ', NULL, NULL, '3218723345', '3218723345', '14798011', 'BOSQUES DE MARACAIBO', 'NULL', 1, 2),
(440, 2, 'PAPELERIA ', 'LA GARANTIA', NULL, NULL, '2254712', '2246558', '31192996-6', 'TULUÁ', 'NULL', 1, 2),
(441, 4, 'SIGIFREDO', 'MORIONES ZUÑIGA', NULL, NULL, '8234281', 'NO TIENE', '76305165-3', 'CRA 5 No 1N-62 PLAZA DEL BARRIO BOLIVAR', 'NO TIENE', 1, 4),
(442, 4, 'CARPAS Y ', 'EVENTOS ', NULL, NULL, '8244394', 'NO TIENE', '25283537-8', 'CRA 2 No 7-63 B/ SANTA INES', 'NO TIENE', 1, 4),
(443, 4, 'PLASTICOS DEL ', 'CAUCA', NULL, NULL, '8218101', 'NO TIENE', '817002747-6', 'CALLE 5 No 10-149', 'NO TIENE', 1, 4),
(444, 4, 'CENAL', 'POPAYAN', NULL, NULL, '8394242', '8221132', '805026596', 'CRA 3 No 1A NORTE-15 ', 'DIRECCIONPOPAYAN@CENAL.COM.CO', 1, 4),
(445, 2, 'DISTRIBUIDORA', 'CORAZON  DEL VALLE', NULL, NULL, '2241052', '3117487999', '821.000.570.5', 'CALLE 26  N 30-60', 'NULL', 1, 2),
(446, 4, 'ELSA', 'RUIZ GAMBOA', NULL, NULL, '8371996', '8371996', '25287122', 'CR 3 No 17-20', 'N', 1, 4),
(447, 2, 'MARCELA ', 'LASPRILLA OSPINA', NULL, NULL, '3177462812', '3177462812', '29.872.500', 'AGUA CLARA', 'NULL', 1, 2),
(448, 1, 'Juan Guillermo', 'Correa', NULL, NULL, NULL, NULL, '15.255.116', NULL, NULL, 1, 1),
(449, 2, 'TIENDA', 'CENAL TULUÁ', NULL, NULL, '2257787', '2257787', '44', 'CRA  23 # 32-41', 'NULL', 1, 2),
(450, 3, 'Quimi Aromas', 'Alejandro', NULL, NULL, '2702660', '2702660', 'No refiere', 'Cra 28 No. 27-68', 'No refiere', 1, 3),
(451, 3, 'POSTOBON', NULL, NULL, NULL, 'NO REFIERE', NULL, 'NO REFIERE', 'NO REFIERE', 'NO REFIERE', 1, 3),
(452, 4, 'FOTO ESTUDIOS', 'MAKA', NULL, NULL, '8395252', '3178004343', '8050266596-0', 'CL 68 No 15-35', 'M', 1, 4),
(453, 1, 'Fotocopias y duplicados de ', 'LLAVES BERNI', NULL, NULL, NULL, NULL, '16.762.222-6', NULL, NULL, 1, 1),
(454, 4, 'TRIPLEX', 'AGLOMERADOS', NULL, NULL, '8864759', '3', '6208127-3', 'B/ BOLIVAR', 'N', 1, 4),
(455, 1, 'Ferreteria Tubolaminas', 'S.A.', NULL, NULL, NULL, NULL, '890324420', NULL, 'NULL', 1, 1),
(456, 2, 'DISTRIPOLTRONAS', 'DEL VALLE', NULL, NULL, '2247952', '3177275404', '38793787-8', 'CALLE 25 Nº 21-50', 'NULL', 1, 2),
(457, 1, 'El Gran Mayorista Eléctrico', 'Ltda', NULL, NULL, '6841009', '8836321', '900.135.811-1', 'Cra 6 a No 17-34', '.elgranmayoristaelectrico@hotmail.com', 1, 1),
(458, 1, 'La Caramela ', 'SAS', NULL, NULL, NULL, NULL, '900162081-6', NULL, NULL, 1, 1),
(459, 2, 'EXITO', 'TULUÁ', NULL, NULL, '2242525', '2242525', '890900608-9', 'LA HERRADURA', 'NULL', 1, 2),
(460, 1, 'NORMA CECILIA ESTRADA', 'ANDAMIOS FABRICADOS', NULL, NULL, '8834931', NULL, '31.962.725-1', 'Cra. 8 No 22A - 25', NULL, 1, 1),
(461, 1, 'Juan Pablo', 'Villegas Patiño', NULL, NULL, NULL, '3012447775', '94.482.376', 'Av las americas No 21 n 31 apto 402', 'ver.wolf@hotmail.com', 1, 1),
(462, 1, 'STELLA', 'ZULUAGA CANO', NULL, NULL, '3122188926', NULL, '31164681', 'ND', 'stellazuluagac@gmail.com', 1, 1),
(463, 3, 'Rapillaves ', NULL, NULL, NULL, '3127557862', '3127557862', '16.893.973-0', 'Cra 28 No. 21-61', 'No refiere', 1, 3),
(464, 1, 'Lady Marjoy ', 'Noguera Bravo', NULL, NULL, 'no tenien', '3162706970', '38.301.423', 'Calle 33 e No 27-44', 'ladym12@hotmail.com', 1, 1),
(465, 1, 'Jhon Mario ', 'Blanco Ayala', NULL, NULL, '4001417', '3006023409', '16.286.588', 'Calle 72 No 28-89 esquina', 'jblancoayala@yahoo.es', 1, 1),
(466, 2, 'ALMACENES', 'LA 14 S.A ', NULL, NULL, '4881414', '4881414', '890.300.346-1', 'LA 40', 'NULL', 1, 2),
(467, 3, 'Marino ', 'Zabala', NULL, NULL, 'No refiere', 'No refiere', '16.238.793', 'No refiere', 'No tiene', 1, 3),
(468, 3, 'FLORISTERIA', 'TU Y YO ', NULL, NULL, '2758317', NULL, '6.389.241-0', 'CRA 26 NO. 33-80', 'No refiere', 1, 3),
(469, 1, 'Distribuciones Mega ', 'S.A.S', NULL, NULL, NULL, NULL, '805.017.353-1', NULL, NULL, 1, 1),
(470, 4, 'JAVIER EDUARDO', 'PALACIOS BLANCO', NULL, NULL, '3136491536', '3136491536', '94488913', 'CALLE 34 No 2BIS-70 CALI', 'JAVIER.E.PALACIOS@GMAIL.COM', 1, 4),
(471, 3, 'Diseños ', 'Profesionales', NULL, NULL, '6504420', '3148866490', '1.130.671.638-1', 'Av. 4Nte No. 20N-23', 'No refiere', 1, 3),
(472, 1, 'German ', 'Arias', NULL, NULL, NULL, NULL, '11', NULL, NULL, 1, 1),
(473, 4, 'CARACOL', 'S.A', NULL, NULL, '8333204', '31', '860014923-4', 'CL 9N No 9-31- SANTA CLARA', 'N', 1, 4),
(474, 1, 'Fabio', 'Ruiz', NULL, NULL, NULL, NULL, '11', NULL, NULL, 1, 1),
(475, 1, 'Seguridad Electronica de Occidente', 'Ltda', NULL, NULL, NULL, NULL, '815.001.026-2', NULL, NULL, 1, 1),
(476, 2, 'SECRETARIA DE HACIENDA', 'Y CREDITO PUBLICO ', NULL, NULL, '44', '44', '890.399.029-5', 'ALCALDIA MUNICIPAL', 'NULL', 1, 2),
(477, 3, 'Materia', 'Creativa', NULL, NULL, 'No refiere', NULL, '6.625.993-3', 'Cra 29 No. 28-12', 'materiacreativa@hotmail.com', 1, 3),
(478, 3, 'EXPRESO', 'PALMIRA', NULL, NULL, 'NO REFIERE', '4055335', '890.302.849-1', 'NO REFIERE', 'NO REFIERE', 1, 3),
(479, 1, 'Redox Colombia', 'S.A.S', NULL, NULL, '5246000', NULL, '800.078.360-4', 'CALLE 9C No 23C 51', NULL, 1, 1),
(480, 3, 'Carlos Alberto', 'Rivera De La Pava', NULL, NULL, '2866282', '3187955508', '16.797.282', 'Cll 36 No. 29-21', 'No refiere', 1, 3),
(481, 3, 'Eliecer ', 'Salazar Ramirez ', NULL, NULL, '3187751497', 'No refiere', '75.147.106', 'Cll 47 B No. 18-84', 'No refiere', 1, 3),
(482, 4, 'SEGURIDAD', 'VELSEG LTDA', NULL, NULL, '8239757', '8310580', '900202455-1', 'CL 1 No 12-71 CADILLAL', 'M', 1, 4),
(483, 1, 'Alejandra', 'Martinez Zulluaga', NULL, NULL, 'NO TIENE', '3188823555', '1.151.947.350', 'Calle 55 AN No. 2 FN 34', 'bienestar@cenal.com.co', 1, 1),
(484, 1, 'Maria de las Mercedes ', 'Rojas Galeano', NULL, NULL, NULL, NULL, '11', NULL, NULL, 1, 1),
(485, 1, 'Luis Fernando', 'Cuaran Osorio', NULL, NULL, NULL, NULL, '16.787.517', NULL, NULL, 1, 1),
(486, 3, 'YURY VANESSA', 'GUERRERO', NULL, NULL, '2701958', '3176808133', '1.113.837.207', 'Cra 23 No 29-10', 'No refiere', 1, 3),
(487, 3, 'Diego', 'Tovar Jaramillo', NULL, NULL, 'No refiere', NULL, 'No refiere', 'No refeire', 'No refiere', 1, 3),
(488, 1, 'GRAFIMETAL', NULL, NULL, NULL, '8800320', '8806015', '16.799.464-1', 'CRA 4 a No 20-17', NULL, 1, 1),
(489, 2, 'VALANTO', 'DISEÑO GRAFICO', NULL, NULL, '3103891811', '3103891811', '16551127-9', 'CLL 26 Nº 31-16', 'NULL', 1, 2),
(490, 1, 'TOGAS', 'JEAN SEBASTIAN ', NULL, NULL, '3367762', '3367762', '31882934-0', 'CALI', 'NULL', 1, 1),
(491, 2, 'DALIANG', 'LI', NULL, NULL, '2252593', '2252593', '621000027-1', 'TULUÁ', 'NULL', 1, 2),
(492, 4, 'YINETH ', 'POLANCO', NULL, NULL, '8', '3148772986', '1061719534', 'EL LIBERTADOR', 'N', 1, 4),
(493, 3, 'Remates', 'La 31', NULL, NULL, 'no refiere', NULL, 'no refiere', 'no refiere', 'no refiere', 1, 3),
(494, 2, 'MARCO ANTONIO', 'PALACIO LOZANO ', NULL, NULL, '3187106660', '3187106660', '6496139', 'TULUÁ ', 'NULL', 1, 2),
(495, 1, 'NANO TECNOLOGY', NULL, NULL, NULL, NULL, NULL, '111', NULL, NULL, 1, 1),
(496, 1, 'Jose Oliverio', 'Palacios', NULL, NULL, '6817301', 'NA', '16351010', 'Cll 34N 2bis 70', 'NA', 1, 1),
(497, 1, 'Banco ', 'Pichincha', NULL, NULL, NULL, NULL, '890.200.756-7', NULL, NULL, 1, 1),
(498, 2, 'EL MUNDO MAGICO', 'DE LA PIÑATA', NULL, NULL, '2251891', '2251891', '70.546.407-2', 'CALLE 27 Nº 22-33', 'NULL', 1, 2),
(499, 2, 'REMATES ', 'TAIWAN', NULL, NULL, '2243173', '2243173', '31979266-7', 'CALLE SARMIENTO', 'NULL', 1, 2),
(500, 2, 'RIMAX', 'DISTRIBUCIONES', NULL, NULL, '2244346', '2244346', '66717809-1', 'CALLE 25 Nº 19-27', 'NULL', 1, 2),
(501, 4, 'MARLENY ', 'MONTAÑO DIUZA', NULL, NULL, '8375551', '3108497489', '25435672', 'CALLE 60 AN # 16-30 LA ARBOLEDA', 'no tiene', 1, 4),
(502, 1, 'ELIZABETH ', 'RAMIREZ MARTINEZ', NULL, NULL, NULL, NULL, '66.907.281-7', NULL, NULL, 1, 1),
(503, 1, 'Bladimir', 'Gutierrez Muriel', NULL, NULL, NULL, NULL, '16.942.159', NULL, NULL, 1, 1),
(504, 4, 'ISABEL CRISTINA ', 'BERMUDEZ BETANCOURT', NULL, NULL, '8', '3006155979', '1130589047', 'CR 11 No 8N-188', 'ICBERMUDEZ@HOTMAIL.COM', 1, 4),
(505, 4, 'JOSE ARNOLD ', 'PEREZ HERRERA', NULL, NULL, '8', '312', '79958154', 'AGR 6 CASA 6-11', 'M', 1, 4),
(506, 1, 'Superintendencia de notariado', 'y registro', NULL, NULL, NULL, NULL, '899.99.667-0', NULL, NULL, 1, 1),
(507, 1, 'INDUSTRIALMEDIA ', 'S.A.', NULL, NULL, '3819002', NULL, '900.111.713-4', 'CRA 15 No 74-45 OF 201 BOGOTA', NULL, 1, 1),
(508, 3, 'Secretaria de ', 'Cultura y turismo', NULL, NULL, 'no refiere', NULL, 'No refiere', 'No refiere', 'no refiere', 1, 3),
(509, 3, 'Maria Elena ', 'Hernandez ', NULL, NULL, '6833876', '3173745937', '31.882.934-0', 'Cra 36 No. 31-25', 'No refiere', 1, 3),
(510, 1, 'Seguridad Industrial', 'Cali', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1),
(511, 1, 'Jhony Alejandro ', 'Cuaran Osorio', NULL, NULL, NULL, NULL, '94.374.720', NULL, NULL, 1, 1),
(512, 2, 'PAOLA ANDREA', 'ROJAS', NULL, NULL, '3163507524', '3163507524', '29286769', 'TULUÁ', 'NULL', 1, 2),
(513, 2, 'VICTORIA EUGENIA', 'NAVARRO ANGULO', NULL, NULL, '2305807', '3156576574', '66711696', 'PALOMESTIZO', 'REMISO63@HOTMAIL.COM', 1, 2),
(514, 2, 'SANDRA MILENA ', 'RIOS', NULL, NULL, '3186924225', '3186924225', '31794066', 'TULUÁ', 'NULL', 1, 2),
(515, 3, 'Crem', 'Helado', NULL, NULL, '2734804', NULL, '94.450.960', 'Cra 26 No. 33-68', 'No refiere', 1, 3),
(516, 1, 'Ferreteria', 'INCA', NULL, NULL, '4463149', NULL, '16.759.344-5', 'Cra  5 NTE No. 46 N 28', NULL, 1, 1),
(517, 1, 'Camara de Comercio', 'De Cali', NULL, NULL, NULL, NULL, '890.399.001', NULL, NULL, 1, 1),
(518, 3, 'Hector Fabio ', 'Paredes', NULL, NULL, '2732535', '3136180587', '16.261.772', 'Cll 37 No. 32-65', 'No refiere', 1, 3),
(519, 3, 'Ferropartes ', 'Del Valle', NULL, NULL, '2755594', 'No refiere', '31.149.188-1', 'Cra 24 No. 30-21', 'No refiere', 1, 3),
(520, 3, 'PHOTO ', 'GRAPHIKA', NULL, NULL, 'no refiere', 'no refiere', '900.562.260-4', 'Cll 31 No. 26-50', 'NO REGISTRA', 1, 3),
(521, 2, 'DANIEL', 'ZUÑIGA  LOPEZ', NULL, NULL, '3177645942', '3108986363', '94356303', 'CRA 30 Nº 20-52', 'DANZULO1976@HOTMAIL.ES', 1, 2),
(522, 1, 'NOTARIA QUINTA ', 'DE CALI', NULL, NULL, '6410608', NULL, '29.562.230-4', 'CALLE 29N No 6AN35', NULL, 1, 1),
(523, 1, 'ESE', 'CENTRO', NULL, NULL, 'NA', 'NA', 'NA', 'CS Diego Lalinde', 'NA', 1, 1),
(524, 2, 'Claudia Patricia', 'Escobar Agudelo', NULL, NULL, '3174844160', '3174844160', '31791837', 'MZ 58 C 7 BOSQUES', 'NULL', 1, 2),
(525, 3, 'Palmiequipos', NULL, NULL, NULL, '2723964', NULL, 'No refiere', 'Cra 32 No. 27-58', 'No refiere', 1, 3),
(526, 4, 'AUTOSERVICIO Y PAPELERIA', 'MAXIHOGAR', NULL, NULL, '8231651', '8231651', '25291357-2', 'CR 2 No 1-29', 'N', 1, 4),
(527, 2, 'C & S', 'COMPUTADORES', NULL, NULL, '2307491', '2307491', '66726195-4', 'TULUÁ', 'NULL', 1, 2),
(528, 2, 'CENTRO COMERCIAL', 'DEL PARQUE', NULL, NULL, '2246488', '2246488', '900355606-1', 'CALLE 27 26-60', 'NULL', 1, 2),
(529, 3, 'Servicios Postales', 'Nacionales', NULL, NULL, '4199292', NULL, '900.062.917-9', 'no refiere', 'No refiere', 1, 3),
(530, 3, 'Jaime', 'Toro Gonzalez', NULL, NULL, '2250062', '3117359253', '16603668', 'Tulua', 'jaimetoro57@hotmail.com', 1, 1),
(531, 2, 'MUNDIAL DE', 'VIDRIOS Y ALUMINIOS ', NULL, NULL, '2253435', '3156815516', '16356349', 'CALLE 12B 28A18', 'NULL', 1, 2),
(532, 4, 'PAOLA ANDREA', 'LOPEZ MAMBAGUE', NULL, NULL, '8327804', '3148429256', '1061767688', 'CL 60N No 17 - 24', 'N', 1, 4),
(533, 1, 'Luis Arcadio ', 'Becerra Bedoya', NULL, NULL, '4411031', NULL, '16684411-7', 'Cr 23 T25 28', NULL, 1, 1),
(534, 2, 'ROSALBA ', 'GOMEZ CEPEDA', NULL, NULL, '3202612015', '3202612015', '41514424', 'CALLE  6 Nº  11-52', 'NULL', 1, 2),
(535, 1, 'Cooperativa de Transportes de Tulua', NULL, NULL, NULL, '6685470', '2320201', '891.900.254-9', 'terminal', NULL, 1, 1),
(536, 3, 'COMPUCOPIAMOS', 'LTDA', NULL, NULL, '2724072', NULL, '815.004.237-3', 'Cra 24 No. 30-17', 'No refiere', 1, 3),
(537, 1, 'GIANCARLOS', 'BRUSATIN RODAS', NULL, NULL, NULL, NULL, '16.796.187', NULL, NULL, 1, 1),
(538, 3, 'HOMECENTER', 'CALI', NULL, NULL, 'NO REFIERE', NULL, '800.242.106', 'NO REFIERE', 'NO REFIERE', 1, 3),
(539, 1, 'Almacen de Pinturas ', 'Koral', NULL, NULL, '8809405', '3176855802-314508559', '16.799.915-1', 'cra8 No 22a-37', NULL, 1, 1),
(540, 1, 'Anderson ', 'Campo Quintero', NULL, NULL, NULL, NULL, '1.430.694', NULL, NULL, 1, 1),
(541, 3, 'SERVIENTREGA', 'S.A.', NULL, NULL, 'NO REFIERE', NULL, '860.512.330-3', 'NO REFIERE', 'NO REFIERE', 1, 3),
(542, 3, 'Pedro Nel', 'Pernia ', NULL, NULL, '3136934013', '3136934013', '2.530.316', 'Cll 15 No. 15-39', 'NO REFIERE', 1, 3),
(543, 2, 'MANUEL ANDRES ', 'ORTIZ', NULL, NULL, '3134591230', '3134591230', '6199672', 'CRA 7#7-89', 'NULL', 1, 2),
(544, 1, 'Feero Variedades', 'LA NEGRA', NULL, NULL, '3117037874', NULL, '31963761', 'CRA 8 CALL 16 FRENTA AL 7-123', NULL, 1, 1),
(545, 1, 'Fabio Hernán', 'Gaviria Muñoz', NULL, NULL, 'NA', '3113645026', '16.666.927 ', 'NA', 'fghernan@hotmail.com', 1, 1),
(546, 1, 'Luz Yaneth', 'Bedoya', NULL, NULL, 'NA', '3206429726', 'NA', 'NA', 'yaras79@gmail.com', 1, 1),
(547, 1, 'DIAN', 'DIAN', NULL, NULL, '6817301', '3103885600', 'NA', 'Cll 34N 2bis 70', 'jaimetoro57@hotmail.com', 1, 1),
(548, 1, 'Alvaro', 'Quimbayo', NULL, NULL, '4', '3', '1', '#', '1', 1, 1),
(549, 3, 'HERMELINDA', 'VALENCIA DE GONZALEZ', NULL, NULL, '3116376462', NULL, '29.342.738', 'Cll 8 No. 11-30', 'No refiere', 1, 3),
(550, 1, 'Ferreteria Deisy', NULL, NULL, NULL, '4037376', '3207718962', '43644555-6', 'cra 1 c No. 54-137', '@', 1, 1),
(551, 3, 'Robert ', 'Aristizabal', NULL, NULL, 'no refiere', NULL, '6.392.920', 'no refiere', 'no refiere', 1, 3),
(552, 3, 'TALLER COMPRAVENTA', 'ROJAS', NULL, NULL, '2725041', '3162877257', '94.312.233-0', 'Cll 36 No. 21-20', 'no refiere', 1, 3),
(553, 1, 'ANDRES FELIPE ', 'RODRIGUEZ', NULL, NULL, '3003281390', NULL, '94533318', 'EMCALI', 'NULL', 1, 1),
(554, 4, 'COMUNICATE', 'IMPRESORES', NULL, NULL, '8242412', '3113400257', '34570894-6', 'CL 7 No 10A-20', 'M', 1, 4),
(555, 3, 'Kely Yojana', 'Guerra Giraldo', NULL, NULL, 'NO REFIERE', '3184116543', '1.113.669.269', 'Cll 69A No. 26-13', 'kelyguerra@hotmail.es', 1, 3),
(556, 3, 'FLORENCIA', 'MORENO', NULL, NULL, '2555619', NULL, '38979185', 'CRA 1 NO. 4-117', 'NO REFIERE', 1, 3),
(557, 2, 'VICTOR HUGO', 'AGUDELO MARTINEZ', NULL, NULL, 'NO TIENE', 'NO TIENE', '94.367.081', 'AGUACLARA', 'NULL', 1, 2),
(558, 3, 'Carlos Hernan', 'Lozano Serna', NULL, NULL, '3177925247', NULL, '16.366.173', 'Calle 32a No. 19-20', 'No refiere', 1, 3),
(559, 1, 'JAIME', 'TORO GONZALEZ', NULL, NULL, '3117359253', '3117359253', '16.603.668', 'CARRERA 30 No 36-53', 'NULL', 1, 2),
(560, 3, 'FERRETERIA', 'TORREPAC', NULL, NULL, '2758037', NULL, '891.301.540', 'CRA 28 NO. 28-34', 'NO REFIERE', 1, 3),
(561, 2, 'RECAR', 'SYSTEM', NULL, NULL, '2258778', '2252403', '66.720.388-1', 'CARRERA 27 No. 29-80', 'NULL', 1, 2),
(562, 4, 'HERNAN JAVIER ', 'PERDOMO SALAZAR ', NULL, NULL, '8233083', '8233083', '12276122-9', 'CRA 6 No 5N-35 LOCAL 102', 'NO TIENE', 1, 4),
(563, 4, 'JESUS ARLEY', 'MENESES GUTIERREZ', NULL, NULL, '8365132', '8365132', '10306709-4', 'CRA 31 No 14-18 B 31 DE MARZO', 'NO TIENE', 1, 4),
(564, 4, 'CAFE INTERNET ', 'NO TIENE', NULL, NULL, '8367600', '8367600', '34.329.941-3', 'CRA 2 No 1-20 UBR/ CALDAS', 'NO TIENE', 1, 4),
(565, 1, 'Distriformica', 'J.A Ltda', NULL, NULL, '8804390', NULL, '890.310.154-5', 'calle 6 No. 7-97', '@', 1, 1),
(566, 3, 'GRAPHIKA ', 'SERVICIOS DIGITALES', NULL, NULL, 'NO REFIERE', 'NO REFIERE', '94317718', 'CALLE 31 NO. 26-50/52', 'NO REFIERE', 1, 3),
(567, 1, 'JOSE ANTONIO ', 'MONTAÑO PADREDIN', NULL, NULL, 'C', 'C', '16.623.062', 'C', 'C', 1, 1),
(568, 2, 'CAMARA ', 'DE COMERCIO', NULL, NULL, '367253', '367253', '891900300', 'TULUA', 'NULL', 1, 2),
(569, 1, 'DIAN.', '', NULL, NULL, '4', '1', '1', '1', '1', 1, 1),
(570, 3, 'Carvajal ', 'Informacion', NULL, NULL, 'no refiere', NULL, '860.001.317-4', 'No refiere', 'no refiere', 1, 3),
(571, 3, 'Armando ', 'Arce', NULL, NULL, 'No refiere', NULL, '6.403.434', 'No refiere', 'no refiere', 1, 3),
(572, 4, 'ANDRES FELIPE ', 'VELASCO MORALES', NULL, NULL, '8242848', '3122342395', '76324718', 'CALLE 10 No 3-26 EMPENDRADO', 'ANDRESFEÑ03@GMAIL.COM', 1, 4),
(573, 4, 'FRADER ARMANDO', 'CATAMUSCAY PAME', NULL, NULL, '8', '3124681479', '1061718925', 'SAN RAFAEL', 'f', 1, 4),
(574, 2, 'ELECTRI', 'CHAPAS', NULL, NULL, '2309610', '3154397214', '94.369.120-2', 'CALLE 25 No. 3-57', 'NULL', 1, 2),
(575, 4, 'CESAR AUGUSTO', 'BURBANO', NULL, NULL, '8203435', '3113270526', '10543521', 'CRA 10 No 1-37 B/MODELO', 'AUGUSTO572008@HOTMAIOL.ES', 1, 4),
(576, 2, 'PEREZ HIJOS', 'Y ASOCIADOS S.A', NULL, NULL, '2244483', NULL, '900142797', 'CARRERA 24 No. 26-45', 'NULL', 1, 2),
(577, 1, 'GRAFIMETAL', NULL, NULL, NULL, '8800320', '8606015', '16.799.464-1', 'CR 4 No. 20-17 San Nicolas', '@', 1, 1),
(578, 3, 'FERNANDO ', 'BETANCOURT', NULL, NULL, '3128558458', NULL, '94.367.347', 'TULUA', 'NO REFIERE', 1, 3),
(579, 2, 'SERVI', 'ENVIOS', NULL, NULL, '2321313', '2321313', '16.364.968-4', 'CARRERA 25 nO. 30-12', 'NULL', 1, 2),
(580, 2, 'LILIANA', 'BONILLA VIVEROS', NULL, NULL, '2249402', '3113227794', '31204622', 'CALLE 20 A nO24-57', 'NULL', 1, 2),
(581, 3, 'GERMAN DARIO', 'CAICEDO', NULL, NULL, 'NO REFIERE', 'NO REFIERE', 'NO REFIERE', 'NO REFIERE', 'NO REFIERE', 1, 3),
(582, 1, 'Diego Fernando', 'Vinasco', NULL, NULL, 'c', 'c', '111', 'c', 'c', 1, 1),
(583, 1, 'Corporación Colombiana de logistica', 'S.A.', NULL, NULL, '4460044', '4461282', '830.060.136-0', 'Cra. 6 N 45-21 B/ sALOMINA', '@', 1, 1),
(584, 3, 'IMPRESIONES', 'PALMIRA', NULL, NULL, 'NO REFIERE', 'NO REFIERE', 'NO REFIERE', 'CARRERA 30 # 37-115', 'NO REFIERE', 2, 3),
(585, 3, 'Bertha Lucía ', 'Palacios', NULL, NULL, 'NO REFIERE', 'NO REFIERE', '31192643', 'NO REFIERE', 'NO REFIERE', 1, 3),
(586, 4, 'ANNE ELIZABETH', 'FUERTES GUEVARA', NULL, NULL, '8', '312', '25280716', 'CR 12 No 54BN - 77 BOSQUES DE MORINDA', 'N', 1, 4),
(587, 3, 'DIEGO', 'ISAZA', NULL, NULL, 'NO REFIERE', 'NO REFIERE', '16881285', 'NO REFIERE', 'NO REFIERE', 1, 3),
(588, 3, 'Hilda Mary ', 'Zapata', NULL, NULL, 'NO REFIERE', 'NO REFIERE', '30401995', 'NO REFIERE', 'NO REFIERE', 1, 3),
(589, 1, 'TESH-MARK', 'LTDA.', NULL, NULL, 'C', 'C', '900.010.244-8', 'C', 'C', 1, 1),
(591, 1, 'ZONA PC TECNOLOGY', 'NORTE.', NULL, NULL, '4851993', 'CALI', '1130670758', 'AV 5AN 23 DN 72', '@', 1, 1),
(592, 1, 'Helm BanK', NULL, NULL, NULL, 'C', 'C', '11', 'C', 'C', 1, 1),
(593, 3, 'ALMACEN DE PLASTICOS', 'WASHINGTON', NULL, NULL, 'NO REFIERE', 'NO REFIERE', 'NO REFIERE', 'NO REFIERE', 'NO REFIERE', 1, 3),
(594, 3, 'CENTRO TEXTIL S.A.S', 'CENTEX', NULL, NULL, 'NO REFIERE', 'NO REFIERE', 'NO REFIERE', 'NO REFIERE', 'NO REFIERE', 1, 3),
(595, 1, 'OD COLOMBIA S.A.S', 'OFFICE DEPOT', NULL, NULL, '7431550', 'C', '90002386-1', 'CL 81 No. 19 A 18', 'legal@officedepot.com.co', 1, 1),
(596, 3, 'IMPORELECTRIC', 'DEL VALLE', NULL, NULL, 'NO REFIERE', 'NO REFIERE', 'NO REFIERE', 'NO REFIERE', 'NO REFIERE', 1, 3),
(597, 3, 'Cesantias', 'Porvenir', NULL, NULL, 'NO REFIERE', 'NO REFIERE', 'NO REFIERE', 'NO REFIERE', 'NO REFIERE', 1, 3),
(598, 3, 'Aglomerados y Molduras', 'Cruz', NULL, NULL, 'NO REFIERE', 'NO REFIERE', 'NO REFIERE', 'NO REFIERE', 'NO REFIERE', 1, 3),
(599, 1, 'HERPATEL', 'MARIA VICTORIA BECERRA', NULL, NULL, '6830151', '8801416', '31959521-1', 'CRA 9 # 8-26', 'NULL', 1, 1),
(600, 3, 'Gustavo ', 'Ríos', NULL, NULL, 'NO REFIERE', 'NO REFIERE', 'NO REFIERE', 'NO REFIERE', 'NO REFIERE', 1, 3),
(601, 2, 'LUZ ENEIDA', 'SALGADO', NULL, NULL, '3154035665', '3154035665', '66.709.943', 'CARRERA 30 No. 14-35', 'NULL', 1, 2),
(602, 1, 'Lorena ', 'Caicedo Murillo', NULL, NULL, '3926888', '3176441297', '31.758.646', 'cra 49 No. 9B 79', 'fisioloren25@hotmail.com', 1, 1),
(603, 1, 'Rocio', 'Ramirez Arias', NULL, NULL, 'NO TIENE', '3105362019', '31.179.717', 'Calle 36 A Nte 3N 94 PRADOS NTE', 'roci.pretty@yahoo.com', 1, 1),
(604, 3, 'Juan Manuel', 'Jaramillo', NULL, NULL, 'NO REFIERE', 'NO REFIERE', 'NO REFIERE', 'NO REFIERE', 'NO REFIERE', 1, 3),
(605, 1, 'Novaventa', NULL, NULL, NULL, NULL, NULL, '81025289-1', NULL, NULL, 1, 1),
(606, 1, 'El Molino Eduardo Molinari Palacin y ', 'CIA S EN C', NULL, NULL, '4', 'C', '890308111-2', 'C', 'C', 1, 1),
(607, 1, 'MAYA BEDOYA LTDA', 'INTERDROGAS', NULL, NULL, '4856424', '4', '800001047-2', 'C', NULL, 1, 1),
(608, 4, 'SANDRA', 'ORDOÑEZ', NULL, NULL, '3203709095', '3203709095', '1111', 'FISIOSALUD', 'B', 1, 4),
(609, 2, 'LISBETH', 'ZULUAGA CANO', NULL, NULL, '3185833304', '3185833304', '66.710.891', 'CALLE 21A No 15-27', 'NULL', 1, 2),
(610, 3, 'Detalles ', 'Con Amor', NULL, NULL, 'NO REFIERE', 'NO REFIERE', 'NO REFIERE', 'NO REFIERE', 'NO REFIERE', 1, 3),
(611, 3, 'Clinica', 'del Bluyin', NULL, NULL, 'NO REFIERE', 'NO REFIERE', 'NO REFIERE', 'NO REFIERE', 'NO REFIERE', 1, 3),
(612, 1, 'L  &   C     S.A.S', 'CHIPICHAPE', NULL, NULL, '0', NULL, '900407432-1', 'CLL 40N AV. 6A-45', 'NULL', 1, 1),
(613, 2, 'MARTHA OLIVA', 'JORDAN ASPRILLA', NULL, NULL, '2106393', NULL, '26.386.053', 'CARRERA 18B No. 10B -04', 'NULL', 1, 2),
(614, 1, 'IVAN DARIO', 'VELASQUEZ GONZALEZ', NULL, NULL, '4426821', '3148398285', '16378024-8', 'CL 71A 1A1 30 AP 201 BR SAN LUIS 2', 'ivanvelazquez378@hotmail.com', 1, 1),
(615, 3, 'Touch', 'Phone', NULL, NULL, 'NO REFIERE', '3128737011', 'NO REFIERE', 'Carrera 27 No. 30-76', 'NO REFIERE', 1, 3),
(616, 2, 'COMPUMARVIL', 'COMPUTADORES', NULL, NULL, '2306718', NULL, '6.493.872-2', 'CALLE 25 No. 21-40', 'NULL', 1, 2),
(617, 2, 'YENNI PAOLA', 'LOPEZ ACEVEDO', NULL, NULL, '2325740', NULL, '31.793.057', 'FARFAN', 'NULL', 1, 2),
(618, 1, 'FONDO NACIONAL', 'DEL AHORRO', NULL, NULL, 'NA', 'NA', 'NA', 'NA', 'NA', 1, 1),
(619, 1, 'PORVENIR', 'CESANTIAS', NULL, NULL, 'NA', 'NA', 'NA', 'NA', 'NA', 1, 1),
(620, 2, 'FONDO DE PENSIONES', 'PORVENIR', NULL, NULL, '2259602', NULL, '800.144.331-3', 'CALLE 27 CON CARRERA 27 ESQUINA', 'NULL', 1, 2),
(621, 1, 'Limpia Hogar', 'S.A.', NULL, NULL, '5572250', '3182405399', '900.128.172-4', 'Calle 8 No. 24 A 49 B/ Alameda', 'limpiahogarsa@hotmail.com', 1, 1),
(622, 1, 'Luis Alfonso Alzate', ' Almacen Vidrios Mora Bodega Azul S.A.S', NULL, NULL, '44', '44', '11', '11', '@', 1, 1),
(623, 4, 'FONDO NACIONAL', 'DEL AHORRO', NULL, NULL, '8205575', '8209510', '123', 'CL 6 No 9-29', 'NO', 1, 4),
(624, 2, 'ANYI VANESSA', 'PINZON BETANCUR', NULL, NULL, '3165619246', '3165619246', '1116252994', 'CALLE 35 NO. 31-21 FATIMA', 'ANGIEVANE_991@HOTMAIL.COM', 1, 2),
(625, 1, 'Diana Maria ', 'Perilla Lozano', NULL, NULL, 'NO TIENE', '3127068417', '29675765', 'Cra 3 No 7-18', 'dperilla581@hotmail.com', 1, 1),
(626, 3, 'Katherine', 'Melo', NULL, NULL, 'NO REFIERE', 'NO REFIERE', '29689030', 'NO REFIERE', 'NO REFIERE', 1, 3),
(627, 1, 'Nasly ', 'Ulabarry Garcia', NULL, NULL, '4449349', '3164435832', '31.567.105', 'Cra 2 b No 78-33', 'jenniferborrero_4@hotmail.com', 1, 1),
(628, 1, 'María del Pilar ', 'Blanco Ramos', NULL, NULL, 'NO TIENE', '3108947046', '66.825.173', 'Calle 33 No. 2 N 48', 'mapily_@hotmail.com', 1, 1),
(629, 2, 'ANA ROSA ', 'CARDONA DE OCAMPO', NULL, NULL, '3173558872', '3173558872', '29.988.616', 'CARRERA 8 CON CALLE 16 16-03', 'NULL', 1, 7),
(630, 3, 'Noralba ', 'Satizabal Moreno', NULL, NULL, 'No refiere', 'no refiere', '29.533.294', 'Cra 38 No. 33a-10', 'no refiere', 1, 3),
(631, 1, 'Cielo ', 'Torres Muñoz', NULL, NULL, '44', '315', '31.996.394', 'c', '@', 1, 1),
(632, 1, 'ALBERTINA ', 'GARCIA LERMA', NULL, NULL, 'C', 'C', '66.850.060', 'C', 'C', 1, 1),
(633, 3, 'Distribuciones ', 'Mimy', NULL, NULL, 'NO REFIERE', 'NO REFIERE', 'NO REFIERE', 'NO REFIERE', 'NO REFIERE', 1, 3),
(634, 3, 'Diego Fernando', 'Campo', NULL, NULL, 'NO REFIERE', 'NO REFIERE', '16.283.102', 'NO REFIERE', 'NO REFIERE', 1, 3),
(635, NULL, 'Nell', ' Florez', NULL, '2017-05-28 04:06:40', '2245469', '3104755168', '6.894.119', 'CLL 19 #28A40', 'florezpalomino@hotmail.com', 1, NULL),
(636, 2, 'MARIA NOHELIA', 'DUQUE DE GONZALEZ', NULL, NULL, '2237678', '2237678', '31.186.162', 'CARRERA 5 No. 1-47', 'NULL', 1, 6),
(637, 1, 'Angel Diagnostica ', 'S.A.', NULL, NULL, 'C', 'C', '805.013.591-8', 'C', 'C', 1, 1),
(638, 4, 'IVAN ENRIQUE', 'PALTA VILLAMARIN', NULL, NULL, '8366388', '3177774826', '4611982', 'CL 15 No 20F - 15', 'SS', 1, 4),
(639, 1, 'Teatro', 'Jorge Isaacs', NULL, NULL, '8899322', 'na', 'na', 'Cra 3 # 12-28', 'na', 1, 1),
(640, 1, 'Diego', 'Tovar', NULL, NULL, 'na', 'na', 'na', 'na', 'na', 1, 1),
(641, 1, 'Maria Elena', 'Hernandez', NULL, NULL, 'na', '3173745937', '31.882.934-0', 'na', 'togasjeansebastian@hotmail.com', 1, 1),
(642, 4, 'SANDRA PATRICIA', 'GAUSASOY JIMENEZ', NULL, NULL, '8', '3105328729', '1113629176', 'EL BORDO', 'NO', 1, 4),
(643, 3, 'Centro Convenciones', 'Municipio Palmira', NULL, NULL, 'NO REFIERE', 'NO REFIERE', 'NO REFIERE', 'NO REFIERE', 'NO REFIERE', 1, 3),
(644, 3, 'Javier', 'Giraldo', NULL, NULL, 'NO REFIERE', 'NO REFIERE', 'NO REFIERE', 'NO REFIERE', 'NO REFIERE', 1, 3),
(645, 3, 'Homcenter', 'Palmira', NULL, NULL, 'NO REFIERE', 'NO REFIERE', 'NO REFIERE', 'NO REFIERE', 'NO REFIERE', 1, 3),
(646, 4, 'CAMARA DE COMERCIO', 'DEL CAUCA', NULL, NULL, '822', '31', '891580011-1', 'CENTRO', 'NO', 1, 4),
(647, 1, 'MARCO OSWALDO ROSALES PINZA', 'ABC DIGITEC', NULL, NULL, '4383226', '4383226', '16943661-3', 'CL 56 15 17 LC 103', 'C', 1, 1),
(648, 2, 'TALLER', 'LA LLAVE', NULL, NULL, '2316616', '3156912035', '115068057-0', 'CARRERA 22 No. 23-07', 'NULL', 1, 2),
(649, 2, 'ALMACENTRO', 'CULTURA', NULL, NULL, '2249999', '2249999', '31.185.712-2', 'CALLE 27 No. 25-43', 'NULL', 1, 2),
(650, 2, 'FERRO ELECTRICOS', 'VILLEGAS', NULL, NULL, '2246618', '2246618', '16.351.089-9', 'CALLE 28 No. 23-45', 'NULL', 1, 2),
(651, 2, 'MELISSA', 'FLOREZ', NULL, NULL, '2307793', '3136617518', '1.053.783.661', 'CALLE 26B 1 No. 11-15', 'MELISAFLOREZ@HOTMAIL.COM', 1, 2),
(652, 4, 'ADRIANA ESTHER', 'LASSO BENAVIDES', NULL, NULL, '8301000', '3105384326', '25276926', 'CR 16 No 37N-24', 'B', 1, 4),
(653, 3, 'Camara de Comercio', 'De Palmira', NULL, NULL, 'NO REFIERE', 'NO REFIERE', 'NO REFIERE', 'NO REFIERE', 'NO REFIERE', 1, 3),
(654, 3, 'Casa Medica', 'Universales', NULL, NULL, 'NO REFIERE', 'NO REFIERE', 'NO REFIERE', 'NO REFIERE', 'NO REFIERE', 1, 3),
(655, 3, 'Juan Luis', 'Arias Yepes', NULL, NULL, 'NO REFIERE', 'NO REFIERE', 'NO REFIERE', 'NO REFIERE', 'NO REFIERE', 1, 3),
(656, 2, 'ALCALDIA', 'MUNICIPIO DE TULUA', NULL, NULL, '2339300', NULL, '891900272-1', 'CALLE 25 CON CARRERA 27 ESQUINA', 'NULL', 1, 2),
(657, 4, 'MARGARITA ', 'GARZON', NULL, NULL, '8206286', '3146070466-314607171', '59815039-1', 'CRA 9 No 7-91', 'NULL', 1, 4),
(658, 2, 'MARLENY DE JESUS', 'RENDON ZULETA', NULL, NULL, '2301123', '2301123', '29467185', 'CARRERA 4 No. 1-07', 'MARLEN1632010@HOTMAIL.COM', 1, 2),
(659, 1, 'Juan German ', 'Mejia Davila', NULL, NULL, '3739053', '3006990800', '6.774.769', 'Carrera 100 No. 45 - 140', 'drmejiavet@hotmail.com', 1, 1),
(660, 1, 'Daniel Adel', 'Hurtado Yela', NULL, NULL, '4451981', '328775446', '6.103.748', 'Dg 29 B No. T33 -E31', 'hurtadoing@gmail.com', 1, 1),
(661, 3, 'Jaime ', 'Botero', NULL, NULL, 'NO REFIERE', 'NO REFIERE', '16.263.580', 'NO REFIERE', 'NO REFIERE', 1, 3),
(662, 1, 'Jeniffer', 'Borrero Dominguez', NULL, NULL, '4269952', '3183670628', '31.566.273', 'Cra 28 -3 No 95-158', 'jenniferborrero_4@hotmail.com', 1, 1),
(663, 2, 'MAIRA ALEJANDRA', 'VARGAS', NULL, NULL, '3148966460', '3148966460', '1128391971', 'CARRERA 33 BIS No. 41-63', 'NULL', 1, 2),
(664, 1, 'Mari Luz ', 'Toro Gómez', NULL, NULL, 'c', 'c', '66993180', 'c', 'c', 1, 1),
(665, 4, 'FABIO ', 'DELGADO PARRA', NULL, NULL, '8240573', '3', '16239050', 'CL 5 No  4-87', 'NULL', 1, 4),
(666, 1, 'Carteles del Pacifico', 'Cali', NULL, NULL, 'c', 'c', '11', 'c', 'c', 1, 1),
(667, 1, 'Titanium', 'Fotocopias', NULL, NULL, 'NO REFIERE', 'NO REFIERE', 'NO REFIERE', 'NO REFIERE', 'NO REFIERE', 1, 3),
(668, 1, 'LA ', 'CABAÑA', NULL, NULL, '0', '0', '900425479-4', '0', 'NULL', 1, 1),
(669, 1, 'LA ', 'CABAÑA', NULL, NULL, '0', '0', '900425479-0', 'CALI', '0', 1, 1),
(670, 1, 'Jose German ', 'Velez Gomez', NULL, NULL, '2246715', '3165423659', '94.394.152', 'Carre 28 A No 16-45', 'stigermanvelezgomez@hotmail.com', 1, 1),
(671, 1, 'HOTEL FOUR POINTS SHERATON ', 'CALI', NULL, NULL, '44', '44', '11', '11', '@', 1, 1),
(672, 2, 'JOSE GERMAN', 'VELEZ GOMEZ', NULL, NULL, '3165423659', '3165423659', '94.394.152', 'CARRERA 28 No. 16-45', 'NULL', 1, 2),
(673, 4, ' JULIAN DAVID', 'OROZCO PALECHOR', NULL, NULL, '8', '3103865334', '95081509000', 'VILLA ALICIA', 'N', 1, 4),
(674, 1, 'ELECTRICOS E ILUMINACIONES', 'J.E SAS', NULL, NULL, '8841380', '8844506', '900.436.595-7', 'CR6 No 17-38', 'electricoeiluminacionesje@hotmail.com', 1, 1),
(675, 3, 'Super Tiendas', 'Cañaveral', NULL, NULL, 'NO REFIERE', 'NO REFIERE', 'NO REFIERE', 'NO REFIERE', 'NO REFIERE', 1, 3),
(676, 3, 'Afiliados Palmira', 'S.A.', NULL, NULL, 'NO REFIERE', 'NO REFIERE', 'NO REFIERE', 'NO REFIERE', 'NO REFIERE', 1, 3),
(677, 2, 'JAVIER', 'LOZANO RAMIREZ', NULL, NULL, '2314873', '3165410859', '94.367.516', 'CARRERA 21 No. 10A -12', 'NULL', 1, 2),
(678, 3, 'Tubería y Laminas', 'El Triunfo S.A.S.', NULL, NULL, 'NO REFIERE', 'NO REFIERE', 'NO REFIERE', 'NO REFIERE', 'NO REFIERE', 1, 3),
(679, 3, 'CENTRO ', 'HERRAMIENTAS ', NULL, NULL, 'NO REFIERE', 'NO REFIERE', 'NO REFIERE', 'NO REFIERE', 'NO REFIERE', 1, 3),
(680, 1, 'TESH-MARK', 'LTDA', NULL, NULL, 'C', 'C', '900.010.244-8', 'C', 'C', 1, 1),
(681, 4, 'DROGUERIAS ALIANZA ', 'DE OCCIDENTE S.A.', NULL, NULL, '8202020', '8202020', '817004260-0', 'CRA 6A No 10N-88', 'NO TIENE ', 1, 4),
(682, 1, 'Juan Carlos', 'Leon', NULL, NULL, 'c', 'c', '16.731.029', 'c', 'c', 1, 1),
(683, 4, 'MARIA FERNANDA', 'VALENCIA MUÑOZ ', NULL, NULL, '8203186', '3006351183', '34316287', 'CLL 15 NORTE No 6-40 B/ RECUERDO', 'MFVODONTOLGIA@HOTMAIL.COM', 1, 4),
(684, 1, 'Fotocopiadoras del Valle', NULL, NULL, NULL, '5242416-6800509', '31039239237', '1.112.475.787', 'Cra 27 No. 33 F 69', 'C', 1, 1),
(685, 4, 'JOSE MARIA', 'SOLANO GOMEZ', NULL, NULL, '8221780', '3216112086', '13878925', 'CLL 16 No 7-38 B/ 1 MAYO', 'NO TIENE', 1, 4),
(686, 2, 'FABIO ', 'DELGADO MOTOA', NULL, NULL, '2243075', '3137671115', '14.936.843', 'CALLE 34 No. 25-35', 'NULL', 1, 2),
(687, 3, 'CUERPO DE BOMBEROS', 'VOLUNTARIOS PALMIRA', NULL, NULL, 'NO REFIERE', 'NO REFIERE', '1113656740', 'NO REFIERE', 'NO REFIERE', 1, 3),
(688, 4, 'MULTIAGRO LTDA', 'MULTIAGRO', NULL, NULL, '8225070', '8225070', '800213488-7', 'LL 5 No 18-34', 'NO TIENE', 1, 4),
(689, 2, 'JENNIFER', 'ORTEGA SERNA', NULL, NULL, '3113478388', '3113478388', '1.116.235.060', 'BOCAS DE TULUA', 'NULL', 1, 2),
(690, 4, 'SURTIDENTAL', 'DEL CAUCA', NULL, NULL, '8366197', '3117107537', '34637624-4', 'CR 11 NO 3N-30', 'N', 1, 4),
(691, 2, 'DISTRIBUIDORA', 'MEGACOMPUTO', NULL, NULL, '2251988', '2251988', '94.389.694-7', 'CARRERA 26 No. 31-44', 'NULL', 1, 2),
(692, 1, 'Decorwid', 'Ltda.', NULL, NULL, '8853261', '8801046', '800.095.116-5', 'calle 21 No. 6 - 39', 'decorwidltda@emcali.net.co', 1, 1),
(693, 3, 'Secretaria de Hacienda', 'y Finanzas Publicas ', NULL, NULL, 'NO REFIERE', 'NO REFIERE', 'NO REFIERE', 'NO REFIERE', 'NO REFIERE', 1, 3),
(694, 1, 'MAXPRINTER', 'SAS', NULL, NULL, 'C', 'C', '11', 'C', 'C', 1, 1),
(695, 4, 'RICHAR FERNANDO', 'HURTADO CERON', NULL, NULL, '8234479', '8234479', '763144591', 'CRA 6 No 2n-25', 'no tiene', 1, 4),
(696, 2, 'MIGUEL ENRIQUE', 'TAFURT', NULL, NULL, '3117811385', '3117811385', '94.392.023', 'CARRERA 3 No. 6-56', 'NULL', 1, 5),
(697, 3, 'Expreso', 'Palmira', NULL, NULL, 'NO REFIERE', 'NO REFIERE', 'NO REFIERE', 'NO REFIERE', 'NO REFIERE', 1, 3),
(698, 2, 'ANGELICA MARIA', 'GONZALEZ GAÑAN', NULL, NULL, '2252563', '2252563', '29.760.975', 'CARRERA 33 No. 37-14', 'NULL', 1, 2),
(699, 3, 'Multimateriales', 'La 28', NULL, NULL, 'NO REFIERE', 'NO REFIERE', 'NO REFIERE', 'NO REFIERE', 'NO REFIERE', 1, 3),
(700, 3, 'FerroElectricos', 'La 28', NULL, NULL, '2746901', '3185920881', '29677673-8', 'Calle 28 No. 26-25/27', '0', 3, 3),
(701, 1, 'Harold', 'Quintero Duque', NULL, NULL, '4344172', '31437054553', '16717736', 'Carrera 3 Nte No 72-30', 'haroldqduque@gmail.com', 1, 1),
(702, 4, 'JOSE DOMINGO', 'CUARAN ', NULL, NULL, '3165811562', '3165811562', '16791654', 'CRA 44 No 37-38', 'JOSEDAVCUARAN@HOTMAIL.COM', 1, 4),
(703, 1, 'Maria Mercedes', 'Rivera Guzman', NULL, NULL, '3701972', '3147489572', '34.555.556', 'Calle 47 a nte No 2 an 45 b/ la merced', 'mariamerg@hotmail.es', 1, 1),
(704, 4, 'ALCALDIA MUNICIPAL', 'DE POPAYAN', NULL, NULL, '8240042', '8', '8', 'CR 6 No 4-21', 'www.popayan-cauca.gov.co', 1, 4),
(705, 4, 'FABIAN ENRIQUE', 'ORDOÑEZ VELASCO', NULL, NULL, '3117903837', '3117903837', '76.326.085', 'CLL 10 No 3-26 EMPEDRADO', 'MMBTRS@HOTMAIL.COM', 1, 4),
(706, 4, 'FERRETERIA MARACAIBO', 'S.A', NULL, NULL, '8213543', '8212725', '800252944-0', 'CLL 5 No 16-38 CENTRO', 'WWW.FERRETERIAMARACAIBO.COM', 1, 4),
(707, 1, 'Fabian ', 'Ramirez Yusunguair', NULL, NULL, '442', '1', 'cc', '1', '1', 1, 1),
(708, 3, 'TOGAS ', 'JEAN SEBASTIAN ', NULL, NULL, '3717246', 'NO REFIERE', 'NO REFIERE', 'CARRERA 36 NO. 31-25', 'NO REFIERE', 1, 3),
(709, 2, 'JAVIER ALONSO', 'RAMOS LAMUS', NULL, NULL, '3005067312', '3005067312', '94267272', 'CRA 42 N. 32-28', 'NULL', 1, 2),
(710, 1, 'Afiliados Palmira', 'S.A.', NULL, NULL, '4055335', '3146178782', '891.303.834-1', 'TERMINAL DE TRANSPORTES', '@', 1, 1),
(711, 1, 'EXTINTORES ', 'MEGA VALLE', NULL, NULL, '6831016', '8962767', '65.768.963-0', 'Cra. 1A No. 22A-07', '@', 1, 1),
(712, 1, 'Danny Andre', 'Medina Delgado', NULL, NULL, '3176402668', '3176402668', '16.932.251', 'c', 'dannandre@hotmail.com', 1, 1),
(713, 1, 'CARMEN JULIA ', 'CARVAJAL DE ALVARADO ', NULL, NULL, '3207014200', NULL, '20.277.589', 'CRA 28C # 72-44', 'NULL', 1, 1),
(714, 4, 'LIBRERIA Y PAPELERIA', 'CENTRAL', NULL, NULL, '8', '3', '31208805-1', 'CR 5 CALLE 5 ESQUINA', 'NULL', 1, 4),
(715, 4, 'CENTRAL', 'EXPOUTILES', NULL, NULL, '8', '3', '38239384-9', 'CR 5 No 5-65', 'N', 1, 4),
(716, 4, 'PAPELERIA', 'EXPOUTILES', NULL, NULL, '8', '3', '38239384-9', 'CR 5 No 5-65', 'N', 1, 4),
(717, 4, 'MARTHA ', 'JURADO ERAZO', NULL, NULL, '8386646', '3136569215', '25286608', 'CLL 69 No 9N-65', 'MARTAJE2008@HOTMAIL.COM', 1, 4),
(718, 1, 'Jaime Enrique ', 'Rojas Ruiz', NULL, NULL, '3810565', '3188994210', '16.632.908', 'Calle 50 Nte No 8 N 27 EL BOSQUE', 'jaenro205@yahoo.es', 1, 1),
(719, 1, 'TORNICENTER', 'LTDA', NULL, NULL, '8801268', '8807672', '900.196.794-5', 'Cra. 7a  No. 16-33', '@', 1, 1),
(720, 1, 'Mayra Alejandra', 'Salcedo Rodriguez', NULL, NULL, 'NO TIENE', '3206304428', '38.680.579', 'CRA 26 No 122 - 17', 'masalcedo97@misena.edu.co', 1, 1),
(721, 3, 'JENIFFER ', 'MONSALVE', NULL, NULL, 'NO REFIERE', '3127261639', '1113629257', 'NO REFIERE', 'NO REFIERE', 1, 3),
(722, 1, 'Johana Sabely', 'Bermeo Muñoz', NULL, NULL, '3820142', '3183606048', '38.554.890', 'Cra 1 I No 59-41', 'sabely81@hotmail.com', 1, 1),
(723, 3, 'JOSE GERMAN', 'VELEZ GOMEZ', NULL, NULL, 'NO REFIERE', NULL, '94394152', 'NO REFIERE', 'NO REFIERE', 1, 3),
(724, 4, 'JAC URBANIZACION', 'LA ESMERALDA', NULL, NULL, '3137062551', '3137062551', '0', 'BARRIO LA ESMERALDA', 'JUNTADEACCIONCOMUNALESMERALDA@GMAIL.COM', 1, 4),
(725, 3, 'Robert ', 'Aristizabal S.', NULL, NULL, 'NO REFIERE', NULL, '6392920', 'NO REFIERE', 'NO REFIERE', 1, 3),
(726, 1, 'ICONTEC', 'INSTITUTO COLOMBIANO DE NORMAS TECNICAS Y CERTIFICACION', NULL, NULL, '6640121', NULL, '860012336-1', 'AV 4AN # 45N-30', 'cali@icontec.org', 1, 1),
(727, 1, 'LEADIS CONSULTING', 'S.A.S', NULL, NULL, 'na', '3187083432', '900.511.932-7', 'cra 100B # 11-20 OF 401', 'info@lead-is.com', 1, 1),
(728, 1, 'Harold ', 'Galvis Perdomo', NULL, NULL, '2503867 - 6486361', '3107698733', '79386250-9', 'Cra 24 No 67-71 of 203', 'hgalvisp@hormail.com', 1, 1),
(729, 3, 'Comercializadora', 'Marden LTDA', NULL, NULL, 'NO REFIERE', NULL, '800004599-1', 'NO REFIERE', 'NO REFIERE', 1, 3),
(730, 1, 'Diego Fernando ', 'Vasquez Silva', NULL, NULL, '4885837', '3153504044', '16.837.402', 'Carrera 7 e cbis 63 41', 'dfvasquez76@gmail.com', 1, 1),
(731, 3, 'Cerraduras', 'Rapillaves ', NULL, NULL, '2726460', '3127557862', '16893973-0', 'Carrera 28 No. 21-61', 'NO REFIERE', 1, 3),
(732, 1, 'mi.com.co', 's.a.', NULL, NULL, '18000113126', 'NA', 'NA', 'Bogotá', 'info@pagosonline.net', 1, 1),
(733, 3, 'Estación de ', 'servicio Versalles', NULL, NULL, 'NO REFIERE', NULL, 'NO REFIERE', 'NO REFIERE', 'NO REFIERE', 1, 3),
(734, 1, 'FERRETERIA BARBOSA Y', 'CIA S EN C ', NULL, NULL, '4863000', 'NO TIENE', '890308587-4', 'CR 1 3184', '@', 1, 1),
(735, 1, 'ANGELES FERRETERIA', 'LIMITADA', NULL, NULL, '8836573', '8835897', '805.015.034-6', 'Cra. 9 No. 15-34 ', 'angelesferreteria@emcali.net.co', 1, 1),
(736, 4, 'CUERPO DE BOMBEROS', 'VOLUNTARIO DE POPAYAN', NULL, NULL, '8231313', 'N', '891500227-3', 'CL 4 No 10A  - 80', 'N', 1, 4),
(737, 3, 'Juan David', 'Solorzano', NULL, NULL, 'NO REFIERE', '3165896325', '16239546', 'NO REFIERE', 'NO REFIERE', 1, 3),
(738, 1, 'Benemerito Cuerpo de Bomberos Voluntarios', 'De Cali', NULL, NULL, 'c', 'c', '890.399.000-2', 'c', 'c', 1, 1),
(739, 3, 'Ferreteria', 'Aros', NULL, NULL, '2747205', 'NO REFIERE', '16.280.698-9', 'Calle 52 No. 38-68', 'NO REFIERE', 1, 3),
(740, 4, 'SUPER FAMILIAR ', 'SUPER FAMILAR', NULL, NULL, 'N O TIENE', '3128845522', '10519276-1', 'CRA 5 No 1N-88 GALERIA BARRIO BOLIVAR ', 'NO TIENE', 1, 4),
(741, 4, 'SIXTO ', 'MOSQUERA', NULL, NULL, 'NO TIENE', 'NO TIENE', '1.427.830', 'POPAYAN', 'NO TIENE', 1, 4),
(742, 4, 'GRAN FERIA ', 'DEL LIBRO', NULL, NULL, '8240729', '8240729', '900341606-0', 'CRA 5 No 5-27 centro', 'no tiene', 1, 4),
(743, 3, 'Saneamiento', 'E.A.T. ', NULL, NULL, '2700855', 'NO REFIERE', '815.002815-1', 'Carrera 30 No. 28-62', 'NO REFIERE', 1, 3),
(744, 3, 'Efrain ', 'Cadavid', NULL, NULL, '2716728', 'NO REFIERE', '16.708.476', 'NO REFIERE', 'NO REFIERE', 1, 3),
(745, 1, 'IMPORTRIPLEX', 'S.A.S', NULL, NULL, '8801620', 'NO TIENE', '805.022.071-8', 'CR 8 16 50', '@', 1, 1),
(746, 2, 'CARLOS ALBERTO', 'VALENCIA', NULL, NULL, '3122879147', '3122879147', '1.274.035', 'CARRERA 7 NORTE No. 5-99', 'NULL', 1, 2),
(747, 4, 'ELMER RICARDO', 'GUEVARA BURBANO', NULL, NULL, '8243881', '8242638', '10543248-6', 'CRA 4 No 6-09 ESQUINA', 'ELPUNTOELECTRICO01@HOTMAIL.COM', 1, 4),
(748, 2, 'ALMACEN', 'REFRILEMA', NULL, NULL, '2243680', '3105246505', '29.307.740-7', 'CARRERA 22 No. 26-33', 'NULL', 1, 2),
(749, 1, 'VIDRIOS Y ALUMINIOS MORA', 'S.A.S', NULL, NULL, 'C', 'C', '11', 'C', 'C', 1, 1),
(750, 2, 'RUSBEL', 'APONTE', NULL, NULL, '3122220647', '3122220647', '6.196.879', 'NO TIENE', 'NULL', 1, 2),
(751, 2, 'PRODUCTOS', 'QUIMICOS', NULL, NULL, '2256400', '2256400', '29854042-1', 'CRA 25 No. 29-87', 'COMERMA63@HOTMAIL.COM', 1, 2),
(752, 1, 'INDUSTRIA DE ALIMENTOS', 'ALAMO', NULL, NULL, '4416851', '3182097636', '900528724-6', 'CLL 30# 16-18', 'NULL', 1, 1),
(753, 3, 'Luz Albany ', 'Salazar Ramirez ', NULL, NULL, 'NO REFIERE', '3154425403', '30.357.906', 'NO REFIERE', 'NO REFIERE', 1, 3),
(754, 3, 'Lina Maria', 'Pelaez Alzate', NULL, NULL, '3167927440', '3167927440', '1114812912', 'NO REFIERE', 'NO REFIERE', 1, 3),
(755, 1, 'Oscar Gerardo', 'Montes Lugo', NULL, NULL, '4024238', '3164070115', '16.703.522', 'Carrera 3 Nte No 34 N 175', 'oscarmontes_21@hotmail.com', 1, 1),
(756, 1, 'Alvaro ', 'Cruz Mendez', NULL, NULL, '4395641', '3164999653', '16.459.340', 'Calle 69 No 5 -41', 'alvarocruzingles@gmail.com', 1, 1),
(757, 1, 'Valencia y Soto ', 'S.A.', NULL, NULL, '4', '4', '890316660-8', 'C', '@', 1, 1),
(758, 2, 'SUPERMERCADO', 'D1', NULL, NULL, '3163755', NULL, '900276962-1', 'CARRERA 31 No. 34-11', 'NULL', 1, 2),
(759, 1, 'Comercializadora Importacion', 'CIMEX LTDA', NULL, NULL, '5245362', 'NO TIENE', '800202146-6', 'Av 3 A BIS 23 DN 53', '@', 1, 1),
(760, 2, 'LUIS FERNANDO', 'ECHEVERRI ZAPATA', NULL, NULL, '3154089171', '3154089171', '16.215.713', 'CARRERA 23 No. 23-44', 'NULL', 1, 2),
(761, 4, 'ANDRES FELIPE', 'ZURA O', NULL, NULL, '8242819', '8242819', '10545193-9', 'CRA 2 No 1-22', 'NO TIENE', 1, 4),
(762, 3, 'Eliana ', 'Sánchez', NULL, NULL, '3183932167', NULL, '1.113.636.430', 'Cra 15 No. 38-67', 'no refiere', 1, 3),
(763, 2, 'MARTHA LUCIA', 'BOTERO GOMEZ', NULL, NULL, '2262000', '3174349701', '31.406.593', 'CARRERA 35 No. 24-56', 'NULL', 1, 2),
(764, 3, 'Tomas', 'Aparicio Fernandez', NULL, NULL, 'NO REFIERE', '3168916349', '94.306.213', 'NO REFIERE', 'NO REFIERE', 1, 3),
(765, 1, 'Allers', 'S.A.', NULL, NULL, '6856850', '3', '890.312.452-4', 'No.', 'allers@allers.com.co', 1, 1),
(766, 4, 'PAULA ANDREA', ' RICO RICO', NULL, NULL, '8224770', '3115258427', '42123594', 'Calle 4 Nº 11-74 Apto 201', 'paularicorico@hotmail.com', 1, 4),
(767, 1, 'SERVIENTREGA', NULL, NULL, NULL, 'C', 'C', '860.512.330-3', 'C', 'C', 1, 1),
(768, 1, 'Vitimetalicas del Valle', NULL, NULL, NULL, '8853878', 'no tiene', '11', 'Cra 10 No. 17- 19 ', 'vidriometalicasdelvalle@hotmail.com', 1, 1),
(769, 1, 'Merys Esmeralda', 'Monterroza Martinez', NULL, NULL, '3180020 ext 220', '3184790276', '66.953.640', 'Carrera 1 D No. 56-123', 'merysmonterroza@hotmail.com', 1, 1),
(770, 1, 'Makro', 'Supermayorista', NULL, NULL, '3329556', 'na', '900059238-5', 'Ca 94 # 25-60', 'na', 1, 1),
(771, 1, 'Darwin', 'Leon Jaramillo', NULL, NULL, '4382270', '3173803449', '1130630428', 'Calle 69 No. 1 -152', 'darwin078@hotmail.com', 1, 1),
(772, 1, 'Digitados', NULL, NULL, NULL, '44', '31', '111', 'c', 'l', 1, 1),
(773, 1, 'Ofelia de las Misericordias ', 'Garcia Zuleta', NULL, NULL, '3702671', '3113407377', '32.527.686', 'Carre 1c3 No. 52-39', 'ofelia838@hotmail.com', 1, 1),
(774, 1, 'Excelenter', NULL, NULL, NULL, 'C', 'C', '11', 'C', 'C', 1, 1),
(775, 2, 'SURTI DESECHABLES', 'LA 23', NULL, NULL, '2321954', '2246259', '1116438601-1', 'CARRERA 23', 'NULL', 1, 2),
(776, 1, 'Edinson Alonso', 'Ruiz Martinez', NULL, NULL, 'c', 'c', '94460165', 'c', 'c', 1, 1),
(777, 1, 'PAMPERO', 'S.A.S', NULL, NULL, '444', '444', '900.324.813', 'CALLE 21 No. 9 -17', '@', 1, 1),
(778, 2, 'CRISTINA', 'FERNANDEZ', NULL, NULL, '2247002', NULL, '66.724.394', 'CARRERA 9 No. 4-72', 'NULL', 1, 2),
(779, 2, 'COOPERATIVA', 'DE TRANSPORTES', NULL, NULL, '6685470', NULL, '891.900.254-9', 'CALLE 27 No. 1W 176', 'NULL', 1, 2),
(780, 1, 'Miguel ', 'Suarez Molina', NULL, NULL, '11', '11', '11', '11', '@', 1, 1),
(781, 4, 'CAMILO ANTONIO', 'ZAMBRANO URIBE', NULL, NULL, '3207439289', '3002817184', '76329691', 'CR 9A No 64AN-26', 'NULL', 1, 4),
(782, 3, 'Construyamos con', 'Fercho', NULL, NULL, '2812488', '3186833493', '16.284.914-3', 'Carrera 28 no. 28-21', 'NO REFIERE', 1, 3),
(783, 1, 'Simon', 'Parilla', NULL, NULL, '6641193', '6641193', '900.470.505-8', 'Calle 44 N No. 6 N 15', '@', 1, 1),
(784, 1, 'RG TECNOLOGY COMPUTERS.COM', NULL, NULL, NULL, '6676742', '3137803240', '1.130.626.115-9', 'C.C. PASARELA LOCAL 251', '@', 1, 1),
(785, 3, 'Centro ', 'Herramientas', NULL, NULL, '2707905', NULL, 'NO REFIERE', 'CALLE 28 NO 28-14', 'NO REFIERE', 1, 3),
(786, 2, 'JHONNY', 'TASAMA', NULL, NULL, '3117992076', '3117992076', '14571146', 'MANZANA 13B No. 14A-14', 'NULL', 1, 2),
(787, 2, 'TODO TINTAS', 'DEL VALLE', NULL, NULL, '2245517', '3144123042', '89.006.565-0', 'CARRERA 32A No. 25-95', 'NULL', 1, 2),
(788, 1, 'Il Gatto ', 'lone', NULL, NULL, '1', '1', '167961872', '1', '1', 1, 1),
(789, 3, 'Maderas', 'La 38', NULL, NULL, 'NO REFIERE', NULL, 'NO REFIERE', 'NO REFIERE', 'NULL', 1, 3),
(790, 1, 'Comercializadora ', 'Cimex Ltda', NULL, NULL, 'cc', 'cc', '800202146-6', 'Av 3 A bis 23 bn-53', 'cc', 1, 1),
(791, 4, 'CAROL YULIANA', 'CEBALLOS RAMIREZ', NULL, NULL, '8', '3148137047', '1061744867', 'CR 8E No 17B - 20', 'N', 1, 4),
(792, 1, 'Paola Andrea', 'Pimienta Barney', NULL, NULL, '3243253', '3113392045', '67.012.80', 'Carrea 66 B No.2 C 101', 'PAOPIMIENTA@HOTMAIL.COM', 1, 1),
(793, 3, 'Remates', ' la 24', NULL, NULL, '2727778', NULL, '16.697.149-8', 'Calle 30 No. 24-01', 'NO REFIERE', 1, 3),
(794, 3, 'Sergio Andres', 'Jaramillo', NULL, NULL, 'NO REFIERE', '3147463750', '94.323.483', 'Carrera 26 No 11-86', 'NO REFIERE', 1, 3),
(795, 4, 'SERVICOPIAS', 'LAU', NULL, NULL, '8', '3', '1061734086-1', 'CR 3 No 1-38 LOCAL 2', 'N', 1, 4),
(796, 2, 'MIYERLANDI', 'VILLADA ZAPATA', NULL, NULL, '3116005726', NULL, '1.112.300.743', 'BARRIO MORALES', 'NULL', 1, 2),
(797, 3, 'Alum Fer', 'del Pacifico LTDA', NULL, NULL, '2710638', '3187350358', '835.001.056-6', 'cARRERA 19 nO. 35-22', 'alumferpacifico.contabilidad@hotmail.com', 1, 3),
(798, 1, 'Rommel Impresores', 'Rommel Amaya', NULL, NULL, '8808156 8845214', '3002781559', '16.928.022-4', 'Calle 20 No. 4-27', 'rommelfox44@hotmail.com', 1, 1),
(799, 4, 'JESSICA ', 'JURADO', NULL, NULL, '8367600', '8367600', '34329941-3', 'CRA 2 No 1-20 URB CALDAS', 'NO TIENE', 1, 4),
(800, 3, 'Mundo', 'Informática ', NULL, NULL, '2737141', '3155467920', '6.382.931-2', 'Calle 26 No. 5 29', 'NULL', 1, 3),
(801, 1, 'Electrónica', 'Dario', NULL, NULL, '2716245', '3154646046', '16.275.091-9', 'Calle 31 No. 23-68', 'NO REFIERE', 1, 3),
(802, 2, 'VARIEDADES ', '5 ESTRELLAS', NULL, NULL, '2254418', '2254418', '29.899.427-5', 'CALLE 26 No. 21-35', 'NULL', 1, 2),
(803, 1, 'Sociedad Colombiana de Cirugía Ortopedia ', 'y Traumatologia', NULL, NULL, '11', '11', '111', '11', '11', 1, 1),
(804, 1, 'Banco AV', 'Villas', NULL, NULL, '44', '44', '11', '@', '@', 1, 1),
(805, 4, 'JULIETH MARCELA ', 'MUÑOZ', NULL, NULL, '8236136', '3137223900', '1061743778-2', 'CRA 6 No 16AN-17 EL RECUERDO', 'NO TIENE', 1, 4),
(806, 4, 'SUPER TIENDAS OLIMPICAS', 'SAO', NULL, NULL, '8236776', NULL, '890107487-3', 'CALLE 2N No 7-74', 'NO TIENE', 1, 4),
(807, 4, 'NOTA MUSICAL', 'NOTA MUSICAL', NULL, NULL, '8243606', '8243606', '2708235-1', 'CALLE 6 No 7-51', 'NO TIENE ', 1, 4),
(808, 2, 'FUMISERVICIOS', 'SOLO PLAGAS', NULL, NULL, '3117309273', '3177372627', '6.450.764-0', 'CORREGIMINETO LOS PINOS', 'NULL', 1, 2),
(809, 2, 'FERRIOBRAS', 'FERRETERIA Y MATERIALES', NULL, NULL, '2247989', '2243095', '900124929-4', 'CALLE 28 No. 23-52', 'NULL', 1, 2),
(810, 1, 'Paneles y Perfiles', NULL, NULL, NULL, 'x', 'x', 'x', 'x', 'x', 1, 1),
(811, 3, 'Jhon Edison', 'Correa', NULL, NULL, 'NO REFIERE', 'NO REFIERE', 'NO REFIERE', 'NO REFIERE', 'NO REFIERE', 1, 3),
(812, 1, 'Soluciones Inmediatas', 'LA SEXTA', NULL, NULL, '6653618', '6653620', '1.130.629.602-8', 'Av 6N No. 40 N -12', '@', 1, 1),
(813, 1, 'Dometal', 'S.A.S', NULL, NULL, '44', '315', '111', 'CL', '@', 1, 1);
INSERT INTO `proveedores` (`id`, `sede_id`, `nombres`, `apellidos`, `created_at`, `deleted_at`, `telefono`, `celular`, `num_documento`, `direccion`, `email`, `identificacion_id`, `ciudad_id`) VALUES
(814, 1, 'Lavadora y Refrigeracion ', 'del valle', NULL, NULL, '8882390 - 3809278', '3137495292', '4418596-8', 'cra 5 a No. 17-36', '@', 1, 1),
(815, 2, 'Carolina', 'Alvarez fernandez', NULL, NULL, '233-2431 ', '3162871430', '52.528.061', 'cra 38 n. 17-30', 'NULL', 1, 2),
(816, 4, 'ZEBRA', 'ELECTRONICA S.A', NULL, NULL, '6', '312', '8', 'C', 'N', 1, 4),
(817, 1, 'Lina Marcela', 'Marin Gaona', NULL, NULL, '4886617', '3173726626', '1.144.126.014', 'Carrera 3 E norte No 70 - 69 lares de con bloq 18 ', 'info@cenal.com.co', 1, 1),
(818, 1, 'Martha Lucia ', 'Cortes Torres', NULL, NULL, 'NO TIENE', '3163411056', '31.533.229', 'Cra 75 D 2 22 b/ los chorros parte alta', 'no tiene', 1, 1),
(820, 1, 'RAPIDO ', 'OCHOA', NULL, NULL, '2852838', NULL, '890936529', 'CLL 2 # 50-181', 'NULL', 1, 1),
(821, 2, 'TERMINAL DE VIDRIOS ', 'Y ALUMINIOS', NULL, NULL, '2246007', '2251573', '16.356.895-1', 'CALLE 27 No. 18A -10', 'NULL', 1, 2),
(822, 4, 'DROGAS DE SALUD ', 'PLUS CENTRO', NULL, NULL, '8396821', '8396821', '10539415-4', 'CRA 8 No 5-91', 'NO TIENE', 1, 4),
(823, 2, 'VIGO', 'LTDA', NULL, NULL, '2247989', '2247989', '900.142.082-8', 'CARRERA 24 No. 28-26', 'NULL', 1, 2),
(824, 4, 'JUAN CARLOS', 'LEON RIOS', NULL, NULL, '0', '3156292304', '16731029', 'CR 26B No 26 - 47', 'S', 1, 1),
(825, 2, 'MAS ', 'CALCAS', NULL, NULL, '3207977526', '3207977526', '14.800.790-4', 'CARRERA 30 No. 24-24', 'NULL', 1, 2),
(826, 2, 'CARLOS ALBERTO', 'MOLINA BONILLA', NULL, NULL, '3144786127', '3144786127', '16.367.308', 'CALLE 26B nO.12-90', 'NULL', 1, 2),
(827, 1, 'Juan Gabriel', 'Leon Rios', NULL, NULL, 'c', 'c', '94071583', 'cc', '@', 1, 1),
(828, 1, 'Elizabeth', 'Tabares Largo', NULL, NULL, 'No tiene', 'no tiene', '38.795.693', 'No se la sabe', 'elitabares84@hotmail.com', 1, 1),
(829, 2, 'ALIANZA ESTRATEGICA', 'EN SERVICIOS NACIONALES', NULL, NULL, '2259257', '2259257', '900.106.565-0', 'CARRERA 25 No. 25-36', 'NULL', 1, 2),
(830, 4, 'PAPELERIA ', 'LUZ', NULL, NULL, '8220052', '3', '76312032-1', 'CR 7 No 5-55', 'NULL', 1, 4),
(831, 1, 'Soporte T.V', 'Henry Arturo López', NULL, NULL, '6841291 - 4399910', '3168759598', '14441296-6', 'Cra 5 Nte No. 51B 36', '@', 1, 1),
(832, 1, 'TIENDAS TECNO PLAZA', 'S.A.S.', NULL, NULL, '4851150', 'NA', '900355222-7', 'AV. 5AN #23DN-68 L-141', 'comercial@tecnoplaza.com.co', 1, 1),
(833, 2, 'MUNDIAL', 'DE FERRETERIA', NULL, NULL, '2242970', '2242970', '31.200.762-5', 'CARRERA 24 No. 28-14', 'NULL', 1, 2),
(834, 4, 'CASA ', 'ODONTOLOGICA', NULL, NULL, ' 8224914-8308700', '8244084', '10545159-8', 'CRF 7 No 6-45', 'N', 1, 4),
(835, 4, 'COOPERATIVA ', 'MULTI ACTIVA PROVITEC', NULL, NULL, '8220835', '8220835', '900323764-1', 'CRA 7 No 6-30 ', 'NULL', 1, 4),
(836, 4, 'SUPER COLOMBIANA', 'DE REPUESTOS', NULL, NULL, '8393289', '3102511237', '3102511237', 'CR 9 No 1AN -13', 'SURCOLOMBIANADEREPUESTOS@HOTMAIL.COM', 1, 4),
(837, 2, 'ALUMINIOS Y ', 'VIDRIOS MEJIA', NULL, NULL, '2259130', '3172359583', '16.342.451-4', 'CARRERA 25 No. 29-44', 'NULL', 1, 2),
(838, 2, 'C.I', 'PINTURVEN', NULL, NULL, '2251080', '2251080', '900.154.019-5', 'CARRERA 30 nO. 23-14', 'NULL', 1, 2),
(839, 2, 'JUAN CARLOS ', 'LEON RIOS', NULL, NULL, '3156292304', '3156292304', '16731029', 'CARRERA 25B No. 27-47 BARRIO EL RECUERDO', 'JUANCARLOSLEONR@HOTMAIL.COM', 1, 1),
(840, 2, 'LEONARDO FABIO ', 'ESPINOSA B.', NULL, NULL, '3154908417', '3154908417', '94.389.863', 'CARRERA 27 No. 29-41', 'NULL', 1, 2),
(841, 4, 'RAMON ELI', 'GIRALDO QUINTERO', NULL, NULL, '8308700', '3154034066', '10545159-8', 'CRA 7 No 6-45 ', 'NO TIENE', 1, 4),
(842, 2, 'CENTRAL DE ', 'PRODUCTOS QUIMICOS', NULL, NULL, '2254886', '2254886', '800.171.549-6', 'carrera 25 No. 29-07', 'NULL', 1, 2),
(843, 2, 'JORGE ALEXANDER', 'GOMEZ NOREÑA', NULL, NULL, '2307424', '3116168906', '94.400.121', 'CALLE 26 No. 5-105', 'NULL', 1, 2),
(844, 4, 'LUIS JOHAN ANDRES ', 'MUÑOZ TULANDE', NULL, NULL, '3104038083', '3104038083', '1061744787', 'CRA 40 No 15-37 INDEPENDENCIA', 'JOHAJIDAN.1191.1991@HOTMIAL.COM', 1, 4),
(845, 4, 'LENNY ELIZABETH ', 'MUÑOZ GOMEZ', NULL, NULL, '8237890', '8237890', '34554500-2', 'CRA 6 No 4n-12 bolivar', 'no tiene', 1, 4),
(846, 4, '8237890', 'DIAZ', NULL, NULL, '820202', '820202', '1.111.123.123', 'TOMAS CIPRIANO DE MOSQUERA', 'NO TIENE', 1, 4),
(847, 4, 'JUAN', 'DIAZ', NULL, NULL, '8202020', '8202020', '1.111.123.123', 'TOMAS CICRIANO DE MOSQUERA', 'NO TIENE', 1, 4),
(848, 2, 'MARIA EUGENIA', 'RODRIGUEZ HERRERA', NULL, NULL, '3163199301', '3163199301', '66.722.366', 'CALLE 26A No. 15 A 06', 'NULL', 1, 2),
(849, 2, 'EL MUNDO', 'DE LOS ENVASES', NULL, NULL, '2320662', '3163432478', 'CANCELADO', 'CARRERA 27 No. 24-39', 'NULL', 1, 2),
(850, 2, 'LICUADORAS Y', 'PLANCHAS ELECTRONIC', NULL, NULL, '2259973', '2259973', '32.541.858', 'CARRERA 25 No. 29-06', 'NULL', 1, 2),
(851, 4, 'ALMACEN DIOR', 'CACHARRERIA FERRETERIA', NULL, NULL, 'NO TIENE', 'NO TIENE', '1061728169-4', 'CRA 6 No 3N-06 BARRIO BOLIVAR', 'NO TIENE', 1, 4),
(852, 4, 'GIOVANNI', 'VALENCIA ', NULL, NULL, '8397737', '8397737', '10548126-9', 'CALLE 5 No 15-24 ', 'ELECTRICOSDELSURPOPAYAN@HOTMAIL.COM', 1, 4),
(853, 2, 'LUIS HERNEY', 'SINISTERRA', NULL, NULL, '3173102592', '3173102592', '94.393.507', 'CALLE 15 No. 21-15', 'NULL', 1, 2),
(854, 3, 'Danilo', 'Jaramillo', NULL, NULL, 'NO REFIERE', 'NO REFIERE', 'NO REFIERE', 'NO REFIERE', 'NO REFIERE', 1, 3),
(855, 3, 'Marcos', 'Corredor', NULL, NULL, 'NO REFIERE', 'NO REFIERE', 'NO REFIERE', 'NO REFIERE', 'NO REFIERE', 1, 3),
(856, 4, 'MARTHA LUCIA ', 'MUÑOZ SATIZABAL', NULL, NULL, '3127761333', '3127761333', '34555820', 'CALLE 1 No 2-34', 'MARTALUMA@HOTMAIL.COM', 1, 4),
(857, 1, 'SHAPAELECTRICOS NORTE', NULL, NULL, NULL, '6676874', 'C', '16.286.461-8', 'C', 'C', 1, 1),
(858, 1, 'Radeón', '.com', NULL, NULL, '44', '8', '11', 'z', '@', 1, 1),
(859, 4, 'COMPUNOTA', 'LTDA', NULL, NULL, '8244931-8241798', '8243123', '800161500-3', 'CR 6 No 5-67-LOCAL 103', 'N', 1, 4),
(860, 3, 'Julio Cesar ', 'Alvarez ', NULL, NULL, 'NO REFIERE', '3166561971', '6389925', 'CALLE 29 NO. 16-41', 'NO REFIERE', 1, 3),
(861, 4, 'PANIFICADORA', 'CUARESNOR', NULL, NULL, '8205291', '3', '17634332-2', 'CL 4 No 5-84', 'N', 1, 4),
(862, 4, 'FRANCISCO ANTONIO', 'FERNANDEZ', NULL, NULL, '8243010', '31', '10292433-4', 'CL 6 No 8-67', 'N', 1, 4),
(863, 4, 'ROSALBA', 'BRAVO OBANDO', NULL, NULL, '8368544-8240427', '3002234483', '34.529.172', 'CR 8N No 17N-15 ', 'M', 1, 4),
(864, 4, 'ELECTRICOS  Y ELECTRICOS', 'DEL SUR', NULL, NULL, '8397737', '3155753932', '10548126-9', 'CL 5 No 15-24', 'N', 1, 4),
(865, 1, 'ARVAL', 'ARNULFO ALENZUELA', NULL, NULL, '6678882', '6681803', '890.323.312-9', 'Av 5a Norte No. 23DN 31', '@', 1, 1),
(866, 1, 'Gloria', 'Izquierdo Lopez', NULL, NULL, '4451357', '3012299035', '31.976.511', 'Carrera 28 A No 54 -25', 'glorua578@hotmail.com', 1, 1),
(867, 4, 'CENTER ', 'ELECTRONICS', NULL, NULL, '8857172', '3', '16741142-5', 'CR 6 No 16-60 CALI', 'N', 1, 4),
(868, 3, 'MARYSOL', 'OSPINA PALACIOS', NULL, NULL, '3168228458', '3168228458', '66.778.700', 'CARRERA 31A NO. 32A-21', 'NO REFIERE', 1, 3),
(869, 2, 'SANDRA MILENA', 'HURTADO', NULL, NULL, '3183246632', '3183246632', '66.931.412', 'CALLE 25B No. 10-20', 'shurtados7@gmail.com', 1, 2),
(870, 3, 'Jhony Alexander', 'Ojeda Rojas', NULL, NULL, 'NO REFIERE', '3105472663', '1.113.517.149', 'CARRERA 6 NO. 778', 'NO REFIERE', 1, 3),
(871, 1, 'Alba Noely ', 'Sandoval', NULL, NULL, '3', '3215285058', '41.605.346', 'c', '@', 1, 1),
(872, 4, 'SANDRA YANETH ', 'CAICEDO DOMINGUEZ ', NULL, NULL, 'NO TIENE', '3217532140', '34571895', 'Calle 36N # 4-114 casa 152 Conjunto Rincón de Yamb', 'Sandriu_11@hotmail.com', 1, 4),
(873, 2, 'INDUVIDRIOS', 'TULUA', NULL, NULL, '2246267', '2244088', '66.715.912-1', 'CALLE 26 No. 23-15', 'NULL', 1, 2),
(874, 4, 'SUMEDI-CO', 'SAS', NULL, NULL, '8239732', '3216443068', '900129426-4', 'CR 6 No 15N - 09', 'SUMEDI-CO@SUMEDI-CO.COM.CO', 1, 4),
(875, 2, 'CRISTALERIA', 'LA REINA', NULL, NULL, '2253321', '2253321', '43764172-3', 'CALLE 27 No, 52-14', 'NULL', 1, 2),
(876, 3, 'Fernando ', 'Alarcón H.', NULL, NULL, '2754422', NULL, '19.273.916-0', 'Carrera 27 No. 29-39', 'NO REFIERE', 1, 3),
(877, 3, 'Julio', 'Popayan', NULL, NULL, 'NO REFIERE', NULL, 'NO REFIERE', 'NO REFIERE', 'NO REFIERE', 1, 3),
(878, 3, 'Francisco Javier', 'Ortiz', NULL, NULL, 'NO REFIERE', NULL, 'NO REFIERE', 'NO REFIERE', 'NO REFIERE', 1, 3),
(879, 3, 'JOSE DOMINGO', 'CUARAN', NULL, NULL, 'NO REFIERE', '3165811562', '16.791.654', 'CARRERA 44 NO.37-38', 'NO REFIERE', 1, 3),
(880, 1, 'SALUTI ', NULL, NULL, NULL, '11', '11', '890.312.452-4', '11', '11', 1, 1),
(881, 2, 'CENTRAL DE ', 'TORNILLOS', NULL, NULL, '2242429', '2242429', '6198269-6', 'CARRERA 30 No. 22-39', 'NULL', 1, 2),
(882, 1, 'Sara Lucia ', 'Campuzano Pineda', NULL, NULL, '3765790', '3014179390', '1.130.674.078', 'Calle 60 No 3 am 60', 'saralu199@hotmail.com', 1, 1),
(883, 2, 'BOMBEROS', 'TULUA', NULL, NULL, '2242222', '2242222', '891.900.235-9', 'CALLE 24 CARRERA 28', 'NULL', 1, 2),
(884, 3, 'GABRIEL ', 'RIVERA', NULL, NULL, 'NO REFIERE', NULL, 'NO REFIERE', 'NO REFIERE', 'NO REFIERE', 1, 3),
(885, 1, 'Enertotal S.A.E.S.P', 'Energia Total', NULL, NULL, '6618290', '6602935', '900039901-5', 'Calle 22 Nte No. 6 AN ', 'servicioalcielnte@enertotalesp.com', 1, 1),
(886, 2, 'PILOS', 'CREATIVOS', NULL, NULL, '2321881', '2251082', '94.390.666-9', 'CARRERA 26 No. 36-40', 'NULL', 1, 2),
(887, 3, 'Juan ', 'Bolaños', NULL, NULL, 'NO REFIERE', '3117374255', '16.599.641', 'NO REFIERE', 'NO REFIERE', 1, 3),
(888, 1, 'ABC PRINTERLASER ', 'S.A.S', NULL, NULL, '524-2007', '6677330', '900.373863-4', 'aV 6 Bis No. 28-11', 'serviciotecnico@printer-laser.info', 1, 1),
(889, 1, 'Almacen Wahintong', 'Luis A. Caicedo', NULL, NULL, '8960643', '8892666', '6.064.013-2', 'Carrera 8 a No. 15-42', 'cliente@washinton.com.co', 1, 1),
(890, 1, 'Herramientas Olarte', 'Alexander Ramirez', NULL, NULL, '3168269791', '3176394894', '94.525.730-4', 'Calle 16 frente al No. 7-113', '@', 1, 1),
(891, 1, 'Llaves Kar', 'Alfonso Carvajal', NULL, NULL, '300-4057927', '3147246569', '11', 'Calle 15 No. 10-25', '@', 1, 1),
(892, 4, 'SERVIENTREGA', 'CENTRO DE SOLUCIONES', NULL, NULL, '8', '3', '860512330-3', 'CENTRO', 'N', 1, 4),
(893, 2, 'TECNI', 'ELECTRONICA', NULL, NULL, '2254951', '2254951', '94.393.673-4', 'CALLE 25 CON CARRERA 21 ESQUINA', 'NULL', 1, 2),
(894, 1, 'ORTOPEDICOS FUTURO ', 'JOSE ALVARO PONGUTA GARZON', NULL, NULL, '6689613', '6689613', '17038278-7', 'Calle 23 B (Avenida Estacion) No. 5N-04', '@', 1, 1),
(895, 2, 'BRENDA LUCIA', 'ORDOÑEZ A', NULL, NULL, '3122003059', '3122003059', '31.790.087', 'CARRERA 34 No. 41-47', 'BRENDAS19@GMAIL.COM', 1, 2),
(896, 3, 'Ferroelectricos ', 'La 10', NULL, NULL, 'NO REFIERE', '3173746182', 'NO REFIERE', 'NO REFIERE', 'NO REFIERE', 1, 3),
(897, 3, 'Argemiro', 'Buendia', NULL, NULL, 'NO REFIERE', NULL, 'NO REFIERE', 'NO REFIERE', 'NO REFIERE', 1, 3),
(898, 4, 'CACHARRERIAY PAPELERÌ', 'LOS CISNES', NULL, NULL, '8232459', '31', '10546181-5', 'Calle  1N No  5 - 50', 'NULL', 1, 4),
(899, 1, 'Nancy Edith', 'Castañeda Gomez', NULL, NULL, '3824057', '3137903508', '52.157.304', 'Carrera 53 No. 17-58', 'cgedith75@gmail.com', 1, 1),
(900, 1, 'Albano Alexander', 'Rojas Britto', NULL, NULL, 'no tiene', '3017772613', '94.418.340', 'Calle 50 No. 99 A -66 APTO 404 Bq. 7 Bosque Real', 'albanor@yahoo.com albanor@emcali.net.co', 1, 1),
(901, 3, 'Ferreteria Y cerrajeria', 'posada', NULL, NULL, '2808292', '3116294411', '14651502-1', 'Calle 28 No. 26-45', 'NO REFIERE', 1, 3),
(902, 1, 'Notaria', 'Quince', NULL, NULL, '6618812', '6613191', '16613246-4', 'AV 4N # 22N-35', 'info@notaria15cali.com', 1, 1),
(903, 3, 'Jhon', 'Paz Ospina', NULL, NULL, 'NO REFIERE', NULL, 'NO REFIERE', 'NO REFIERE', 'NO REFIERE', 1, 3),
(904, 1, 'TECNIGENTES', 'S.A.', NULL, NULL, '44', '44', '11', 'CC', '44', 1, 1),
(905, 1, 'Angela Maria ', 'Aragon Martinez', NULL, NULL, '5513978', '3134004512', '52.791.475', 'Calle 6 A No. 42 -16 Apto 202 Bloq E', 'fairya777@hotmail.com', 1, 1),
(906, 3, 'Juan Carlos ', 'Leon Rios', NULL, NULL, '3369834', 'NO REFIERE', '16731029', 'Carrera 25b No.27-47 CALI VALLE', 'NO REFIERE', 1, 3),
(907, 1, 'Diofanor ', 'Diaz Siaz', NULL, NULL, '8810494', '3108282143', '16.501.913', 'Cra 7 No. 11-21', '@', 1, 1),
(908, 1, 'Luis Felipe ', 'Burgos Narvaez', NULL, NULL, '4203592', '3164012002', '98.395.232', 'Calle 117 No 20-77', 'lufebu.1976@hotmail.com', 1, 1),
(909, 1, 'Moviltel', 'L&J', NULL, NULL, '3809290', '3134439573', '31.240.525-7', 'Av 6 N No. 28-30', '@', 1, 1),
(910, 2, 'LINA MARCELA', 'MARTINEZ GONZALEZ', NULL, NULL, '3174499418', '3174499418', '1.116.241.848', 'CARRERA 32 No. 25-20', 'NULL', 1, 2),
(911, 4, 'MARIA JOHANA ', 'MILLAN', NULL, NULL, '312611354', '312611354', '59706720', 'CRA 3 No 1AN 101', 'YOHA201030@HOTMAL.COM', 1, 4),
(912, 4, 'JINETH NATALY ', 'POLANCO ANGARITA', NULL, NULL, '314-8772986 – 315-69', '314-8772986 – 315-69', '1061719534', 'Calle 8ª. N 21 A – 17 B/ El Libertador ', 'natipol17@hotmail.com', 1, 4),
(913, 3, 'Servinetly', 'Centro', NULL, NULL, '2876948', NULL, '16.865.045', 'NO REFIERE', 'NO REFIERE', 1, 3),
(914, 4, 'LA GRAN PIÑATA', 'ESPERANZA GRISALES', NULL, NULL, 'NO REFIERE', 'NO REFIERE', '38239384', 'NO REFIERE', 'NO REFIERE', 1, 4),
(915, 4, 'CRISTALERIA LA CORONA ', 'YANETH PUYO LOPEZ', NULL, NULL, '8396440', '8396440', '805026596', 'CRA 3 -1AN-15', 'NO TIENE', 1, 4),
(916, 2, 'LA VOZ DE', 'LOS ROBLES', NULL, NULL, '2243750', '2243750', '891.903.435-9', 'CINEMA DEL PARQUE OFICINA 504', 'NULL', 1, 2),
(917, 2, 'DETALLES', 'TULUA', NULL, NULL, '2243368', '2243368', '19.112.462', 'CALLE 27 No. 27-24', 'NULL', 1, 2),
(918, 2, 'LAVACLINIC', 'LAVADO INDUSTRIAL', NULL, NULL, '2247424', '2247424', '29.860.486-0', 'CALLE 26 No. 32 A -46', 'NULL', 1, 2),
(919, 3, 'Jose ', 'Vargas', NULL, NULL, 'NO REFIERE', 'NO REFIERE', '16255901', 'NO REFIERE', 'NO REFIERE', 1, 3),
(920, 1, 'Ugo Andres', 'Sanchez Baeza', NULL, NULL, '3772995', '3113454369', '16784696', 'Av 9AN No. 12 N 41 APT 302', 'ugoandresprofesor@gmail.com', 1, 1),
(921, 4, 'BASICA 1040 AM ', 'S.A.S ', NULL, NULL, '8', '3', ' 805017548-9 ', 'CRA 8 #3.17', 'NULL', 1, 4),
(922, 3, 'Johanna Avelin', 'Mingan Ramos', NULL, NULL, 'NO REFIERE', '3216181983', '1114452575', 'Calle 3era 2e 124', 'NO REFIERE', 1, 3),
(923, 3, 'Veracruz', 'Palmira', NULL, NULL, '2756513', 'NO REFIERE', '66774606-4', 'Carrera 24 No. 30-82', 'NO REFIERE', 1, 3),
(924, 4, 'JOSE', 'ORDOÑEZ DIAZ', NULL, NULL, '8', '3207864470', '10530704', 'C', 'NULL', 1, 4),
(925, 4, 'JUAN PABLO', 'SEGURA OLAVE', NULL, NULL, '8', '3156692109', '1143965725', 'C', 'NULL', 1, 4),
(926, 3, 'Mayra Alejandra', 'Trochez Ramirez', NULL, NULL, 'NO REFIERE', 'NO REFIERE', '1113649307', 'NO REFIERE', 'NO REFIERE', 1, 3),
(927, 4, 'CENTRO RECREACIONAL', 'PROVITEC', NULL, NULL, '8/', '33', '1111', 'SAN ROSA', 'NULL', 1, 4),
(928, 4, 'ADORNOS MILE', 'Y CIA', NULL, NULL, '8', '8240093', '800149175-3', 'CR 6 No 5-27', 'N', 1, 4),
(929, 4, 'VARIEDADES', 'SAN ANDRESITO', NULL, NULL, '8', '3122720429', '25286941-4', 'CL 2A No 40A - 20', 'N', 1, 4),
(930, 4, 'PREMIACIONES', 'DEPORTIVAS', NULL, NULL, '8243994', '3148172654', '25258057-9', 'CR 10 NBo 5-83', 'N', 1, 4),
(931, 4, 'CACHARRERIA ', 'EL GANCHO', NULL, NULL, '8240571', '8240571', '4608443-5', 'CR 5 No 7-24', 'N', 1, 4),
(932, 4, 'QUESERA ', 'D MUÑOZ', NULL, NULL, '3208256231', '3208256231', '27451909-2', 'CR 41 No 2A - 24', 'N', 1, 4),
(933, 4, 'CERVEZAS Y CERVEZAS', 'LTDA', NULL, NULL, '8239062', '3164808969', '170000031837', 'CR 6 No 1N -41', 'N', 1, 4),
(934, 3, 'Printers', 'Tintas, Cartuchos', NULL, NULL, '2867773', '3168284838', '17653351-4', 'CALLE 33 NO. 29-04', 'NO REFIERE', 1, 3),
(935, 4, 'MAGNOLIA ', 'CAMACHO', NULL, NULL, '8', '3127294402', '25', 'N', 'NULL', 1, 4),
(936, 1, 'Martha Lucia ', 'Zuluaga Cañon SEGURIDAD INDUSTRIAL CALI', NULL, NULL, '4324390', '3174181040', '29202363-1', 'CR 1 70 A 72 AP 8102 BRR ALCAZARES', 'secuinducali@yahoo.com', 1, 1),
(937, 3, 'CellMaxter', 'San Andresito', NULL, NULL, 'NO REFIERE', 'NO REFIERE', '80888242-8', 'Cra 27 No. 30-68', 'NO REFIERE', 1, 3),
(938, 1, 'Pricesmart Colombia', 'S.A.S.', NULL, NULL, '3982223', 'na', '900319753-3', 'Cll 64AN 5B183', 'na', 1, 1),
(939, 3, 'Jose Gustavo', 'Ochoa Garzon', NULL, NULL, 'NO REFIERE', '3168063489', '16.268.137', 'Calle 32b No. 3E-30', 'NO REFIERE', 1, 3),
(940, 1, 'Alvaro Ivan ', 'Restrepo Zapata', NULL, NULL, '3782942', '3154490570', '16.719.283', 'Calle 56 No. 4 b 145', 'alvaroivanrestrepo@gmail.com', 1, 1),
(941, 1, 'Maria Lucy', 'Cataño  Molina', NULL, NULL, 'c', 'c', '31192525', 'c', 'c', 1, 1),
(942, 3, 'VARIEDADES', 'GOMEZ', NULL, NULL, 'NO REFIERE', '3152844370', '16.270.786-6', 'CALLE 30 NO. 24-12', 'NO REFIERE', 1, 3),
(943, 2, 'ALBA YULIETH', 'MONTILLO ARBOLEDA', NULL, NULL, '3167588548', '3167588548', '31.431.316', 'CARRERA 3B NORTE No. 19-11', 'MARIAFERNANDA_1506@HOTMAIL.COM', 1, 2),
(944, 1, 'Edward Steveen', 'Peña Lopez', NULL, NULL, '3762518', '3162932859', '1144177924', 'Cra 23 B 71 76', 'info@cenal.com.co', 1, 1),
(945, 1, 'Johana Patricia', 'Ruiz Granado', NULL, NULL, '3733719', '3014540340', '67014022', 'Calle 56 nte No 2 FN 39', 'calidad@cenal.com.co', 1, 1),
(946, 1, 'Luz Dary ', 'Mesa Murcia', NULL, NULL, '3748875', '3144715227', '52585479', 'Carrera 53 No 1 a 50 torre 12 apto 146', 'coordinacioncali@cenal.com.co', 1, 1),
(947, 4, 'VICTOR ALFONSO ', 'BOLAÑOS ', NULL, NULL, '3154598437', '3154598437', '10548104', 'CRA 19 No 11A-16 EL PAJONAL', 'VICTOR-BOLANOS@HOTMAIL.COM', 1, 4),
(948, 1, 'Claudia Patricia ', 'Valencia Molina', NULL, NULL, 'c', 'c', '31.202.338', 'c', 'c', 1, 1),
(949, 2, 'FERROGAS', 'DOMINGUEZ', NULL, NULL, '3012833448', '3007842795', '14.796.947-6', 'CARRERA 23 No. 27-48', 'NULL', 1, 2),
(950, 4, 'EILLEN YULIETH', 'MORIONES CAMPOS ', NULL, NULL, '3124403832', '3124403832', '96051010610', 'CL 70 AN- No 5A-19 LA PAZ', 'EILLEN33_4@HOTMAIL.COM', 2, 4),
(951, 3, 'AURA LEIDY', 'OBANDO MAYA', NULL, NULL, 'NO REFIERE', '3122566776', '29706655', 'NO REFIERE', 'NO REFIERE', 1, 3),
(952, 3, 'BICICLETERIA', 'MANRIQUE', NULL, NULL, '2722177', NULL, '16.263.780-3', 'CRA 27 NO. 28-56', 'NO REFIERE', 1, 3),
(953, 3, 'IMPORTACIONES ', 'AFM', NULL, NULL, '2859722', '3104388248', '14.695.133-4', 'CALLE 31 NO. 23-07', 'NO REFIERE', 1, 3),
(954, 1, 'ORBEY ', 'VERGANZO', NULL, NULL, '3136699857', '3136699857', '10489149', 'N/A', 'N/A', 1, 1),
(955, 3, 'Jaime ', 'Colmenares', NULL, NULL, 'NO REFIERE', 'NO REFIERE', 'NO REFIERE', 'NO REFIERE', 'NO REFIERE', 1, 3),
(956, 3, 'Pronto', 'Envios', NULL, NULL, 'NO REFIERE', 'NO REFIERE', 'NO REFIERE', 'NO REFIERE', 'NO REFIERE', 1, 3),
(957, 1, 'Soluciones Integrales a su Empresa', 'Carlos Eider Córdoba', NULL, NULL, '3816126', '3104713205', '16.455.076-0', 'Av 6N No 28-30', '@', 1, 1),
(958, 4, 'ALEX FERNANDO ', 'ORDOÑEZ ', NULL, NULL, '3117273052', '3117273052', '1061746323', 'CLL 20 No 6-11 B/LOS COMUNEROS', 'ALEXORDONEZTAN@GMAIL.COM', 1, 4),
(959, 4, 'GUILERMO LEON', 'PINZON SALAZAR ', NULL, NULL, '8210525', '3155002692', '10534062-5', 'CLL 6 No 14-06', 'NO TIENE ', 1, 4),
(960, 1, 'Carlos Julio', 'Betancourt Garcia', NULL, NULL, '3788511', '3164136361', '18.410.708', 'Carre 14 oest No 12 Aoeste 141 apto 401B', 'CARLOS.BETANCOURT@CMCFARMACUETUCA.COM', 1, 1),
(961, 4, 'FERRETERIA ', 'TUBOLAMINAS', NULL, NULL, '8300303', '8300303', '890324420-0', 'CL 5 No 33-108', 'comercial@tubolaminas.com', 1, 4),
(962, 4, 'LA PLAYITA', 'DISTRIBUIDOR MATERIALES', NULL, NULL, '3127025294', '3202880645', '76309085-0', 'CR 6A No 9 NTE ESQUINA', 'NO', 1, 4),
(963, 4, 'FERRO', 'ESTACION', NULL, NULL, '8201401', 'NO', '34535384-3', 'CR 6A NO 8N -119', 'NO', 1, 4),
(964, 2, 'MARIA CLAUDIA', 'ALDANA', NULL, NULL, '3162496666', '3162496666', '31.200.672', 'CALLE 8 No. T20-25', 'NULL', 1, 2),
(965, 3, 'CAROLINA ', 'MONGRAGON ZULUAGA ', NULL, NULL, 'NO REFIERE', 'NO REFIERE', '1130671638', 'NO REFIERE', 'NO REFIERE', 1, 3),
(966, 2, 'JHONATAN', 'OSORIO OROZCO', NULL, NULL, '2243285', NULL, '94.482.342', 'TULUA', 'NULL', 1, 2),
(967, 2, 'TIENDA', 'SPORT', NULL, NULL, '2391074', '3178555828', '31.655.140-7', 'CARRERA 9 No. 9-72', 'NULL', 1, 2),
(968, 4, 'NIDIA LORENA ', 'MOLINA PARRA', NULL, NULL, '8', '3134032505', ' 28.549.339', 'CR 9 No 23N -94 APTO 201 -', 'n', 1, 4),
(969, 1, 'CRISTHIAN STEVEN', 'GUAUÑA GUAUÑA', NULL, NULL, 'C', 'C', '1112479126', 'C', 'C', 1, 1),
(970, 1, 'Alduber ', 'Arango Hernadez', NULL, NULL, '5140901', '3153765089', '16694356', 'Calle 10 No. 29 B 51', '@', 1, 1),
(971, 2, 'INNOVA', 'QUALITY S.A.S', NULL, NULL, '3200976955', '3200976955', '900335864-1', 'TULUA', 'NULL', 1, 2),
(972, 2, 'ANTONIO', 'PATIÑO', NULL, NULL, '3168231367', '3168231367', '16.349.509', 'CALLE 10 No. 28 C -39', 'NULL', 1, 2),
(973, 3, 'ANDREA CAROLINA', 'MONTERI', NULL, NULL, '6504420', 'NO REFIERE', '52.842.266', 'NO REFIERE', 'NO REFIERE', 1, 1),
(974, 1, 'Bancoomeva', NULL, NULL, NULL, 'c', 'c', '88', 'c', 'c', 1, 1),
(975, 1, 'Protección', NULL, NULL, NULL, 'c', 'c', '88', 'c', 'c', 1, 1),
(976, 4, 'JUAN', 'ANDRADE URBANO', NULL, NULL, '3186936386', '3186936386', '10542977', 'CLL 53 N No 11-58 INTERIOR 47 VILLA DEL VIENTO', ' juleo2004@hotmail.com', 1, 4),
(977, 4, 'ALQUILER DE EQUIPOS', 'PARA CONSTRUCCION', NULL, NULL, '8365912', '3155392576', '7', 'CL 1N No 3-73', 'NO', 1, 4),
(978, 4, 'PINTUCOLOR', 'POPAYAN', NULL, NULL, '8315728', '3176431019', '25417675-3', 'CR 20 No 4-37', 'NP', 1, 4),
(979, 4, 'ALMACEN', 'DIOR', NULL, NULL, '8', '3', '1061728169-4', 'CR 6 No 3N - 06', 'NO', 1, 4),
(980, 1, 'COPSERVIR', 'LTDA', NULL, NULL, 'C', 'C', '830011670-3', 'C', 'C', 1, 1),
(981, 1, 'Enfermeros del Norte', NULL, NULL, NULL, '3821973', '3136544510', '42110432-3', 'Calle 24 N No. 3BIS -30 B/San Vicente', '@', 1, 1),
(982, 2, 'TELEFONIA', 'CELULAR', NULL, NULL, '3137455054', '3137455054', '16.758.236', 'PLENOCENTRO', 'NULL', 1, 2),
(983, 2, 'FABIAN ALONSO', 'GOMEZ', NULL, NULL, '2237015', '2237015', '6.200.557', 'CALLE 5 No. 303', 'NULL', 1, 6),
(984, 3, 'CLAUDIA MILENA', 'PINTO ESCOBAR', NULL, NULL, '2723306', '3166622647', '66777911', 'CRA 1 NO. T30-120', 'NO REFIERE', 1, 3),
(985, 1, 'Bellanira del Socorro', 'Ordoñez Ortiz ', NULL, NULL, 'NO TIENE', '3117758823 -32172462', '27097742', 'Carrera 28 E 3 No. 124 c 18', 'NO TIENE', 1, 1),
(986, 1, 'Leydy Dayhanna', 'Salazar Hernandez', NULL, NULL, 'c', 'c', '1114077305', 'c', 'c', 1, 1),
(987, 1, 'Experian colombia ', 'S.A.', NULL, NULL, '6081200', '11', '900.422.614-8', 'Calle 22 N No. 6AN 24', 'gtoro@datacredito.com', 1, 1),
(988, 1, 'PINTURAS ', 'AMERICA', NULL, NULL, '3164823622', '3164823622', '1.130.604.781-1', 'Calle 34 No. 2 -34', 'pinamerica@hotmail.com', 1, 1),
(989, 3, 'Juan Carlos', 'Lema', NULL, NULL, '2813264', 'NO REFIERE', '1113646297', 'CALLE 31 NO. 31-72', 'NO REFIERE', 1, 3),
(990, 3, 'ALMACENES ', 'LA 14 S.A', NULL, NULL, '0', '0', '890.300.346-1', '0', '0', 3, 3),
(991, 1, 'Dicoplast', 'S.A.', NULL, NULL, '25555018', '2555134', '811.013.802-9', 'cL 8 SUR No. 50 E 38', '@', 1, 1),
(992, 2, 'ALQUILER DE ', 'SIMCARD', NULL, NULL, '3158132106', '3158132106', '94.325.593', 'TULUA', 'NULL', 1, 2),
(993, 3, 'FALCA SAS', 'SUPERPLAZA SEMBRADOR', NULL, NULL, 'NO REFIERE', 'NO REFIERE', '900.277.465-5', 'AV 19 CALLE 23 ESQUINA', 'NO REFIERE', 1, 3),
(994, 3, 'COPSERVIR', 'LTDA.', NULL, NULL, 'NO REFIERE', 'NO REFIERE', '830.011.670-3', 'NO REFIERE', 'NO REFIERE', 1, 3),
(995, 3, 'Detalles ', 'y Fiestas', NULL, NULL, '2726800', 'NO REFIERE', '66.763.970-3', 'CALLE 36 No. 25-54', 'NO REFIERE', 1, 3),
(996, 3, 'Gustavo', 'Zuleta', NULL, NULL, 'NO REFIERE', 'NO REFIERE', '14.964.707', 'CALI', 'NO REFIERE', 1, 3),
(997, 1, 'GASPERINI', 'GOURMET', NULL, NULL, '2864913', '3157084145', '74.335.818-5', 'CALLE 32 No. 25-12', 'NO REFIERE', 1, 3),
(998, 1, 'Centro de Servicio Wahl', NULL, NULL, NULL, '8818747', '3168234324', '31.482.150-7', 'Calle 15 No. 3-20 ofic 201', '@', 1, 1),
(999, 1, 'Agronar', NULL, NULL, NULL, '7227923', '1', '12.984.204-1', 'Carrera 33 No. 5 Oeste 53', '@', 1, 1),
(1000, 4, 'NIDIA MARIA ', 'RIVERA MENESES', NULL, NULL, '3174879015', '3174879015', '25280432', 'Carrera 2 Nro. 12-10', 'nidiarim@hotmail.com', 1, 4),
(1001, 1, 'BBVA', 'Horizonte', NULL, NULL, '1', '1', '1', '1', '1', 1, 1),
(1002, 3, 'CARTUCHOS ', 'Y TONER', NULL, NULL, 'NO REFIERE', 'NO REFIERE', '38.956.925-9 R.COMUN', 'AV. 5 AN No. 23 DN - 68', 'NO REFIERE', 1, 1),
(1003, 3, 'COMFANDI', 'PALMIRA', NULL, NULL, 'NO REFIERE', 'NO REFIERE', '890303208-5', 'NO REFIERE', 'NO REFIERE', 1, 3),
(1004, 4, 'LA NOTA', 'MUSICAL', NULL, NULL, '8243531', '8243606', 'RESOL.170000035460', 'CL 6 No 7-51', '0', 1, 4),
(1005, 1, 'De La Pava Y Compañia ', 'S.A.', NULL, NULL, '8805014-8805031-8804', '8846432', '805002135-5', 'Carrera 6 a No. 15-45', '@', 1, 1),
(1006, 1, 'Center Electrics', 'Carlos Pino Vargas', NULL, NULL, '8857172', '1', '16.741.142-5', 'Carrera 6 No. 16-60', 'center-electric@hotmail.com', 1, 1),
(1007, 4, 'JOSE WILSON', 'CABRERA SALAZAR', NULL, NULL, '8278631', '3154088505 - 3137697', '12996992', 'CR 20 No 16-20 TIMBIO', 'N', 1, 4),
(1008, 1, 'Israel Alberto ', 'Unda Torres', NULL, NULL, '44', '44', '16673714', 'c', '@', 1, 1),
(1009, 4, 'OXINDUSTRIAL ', 'OXINDUSTRIAL ', NULL, NULL, '8339565', '3183423298', '25272612-5', '25272612-5', 'NO TIENE', 1, 4),
(1010, 1, 'CACHARERIA Y PAPELERIA ', 'NUEVO MILENIO ', NULL, NULL, '8831230', '8831230', '43786269-3', 'CRA 9 # 11-39', 'PAPELERIANUEVOMILENIO@HOTMAIL.COM', 1, 1),
(1011, 2, 'MKE', 'TECHNOLOGY LTDA', NULL, NULL, '2322525', '2322525', '900.316.686-4', 'CARRERA 26 No. 29-81', 'NULL', 1, 2),
(1012, 1, 'Sandra Viviana ', 'Aguirre Saavedra', NULL, NULL, '3835159', '3137403238', '1.144.031.099', 'Carrera 23 C No 29 -39', 'saviasa06@hotmail.com', 1, 1),
(1013, 2, 'ANDAMIOS Y', 'EQUIPOS ARANGO', NULL, NULL, '2256948', '2324822', '94.389.535-0', 'CALLE 27 No. 18-26', 'NULL', 1, 2),
(1014, 1, 'Adriana ', 'Arias Rosero', NULL, NULL, '6641486', 'NO TIENE', '1130667596', 'Cl 55 b norte No 2 FN 86', 'adriarias1986@hotmail.com', 1, 1),
(1015, 2, 'MONICA ANDREA', 'HERNANDEZ BEDOYA', NULL, NULL, '3186989310', '3186989310', '31.785.369', 'CALLE 26B No. 05-18', 'monica.hernandez.licenciada@gmail.com ', 1, 2),
(1016, 1, 'JULIETH ESMERALDA', 'PEÑA RIVAS ', NULL, NULL, 'N', 'N', '1006165813', 'N', 'N', 1, 1),
(1017, 4, 'EDWARD ', 'SANDOVAL MOSQUERA', NULL, NULL, '8', '3113145584', '1007581536', 'SIBERIA -CAUCA', 'N', 1, 4),
(1018, 2, 'SERCOPIAS', 'TULUA', NULL, NULL, '3175885329', '3175885329', '94.395.271-6', 'CARRERA 24 No. 24-74', 'NULL', 1, 2),
(1019, 2, 'TECNO', 'PARAISO', NULL, NULL, '2255009', '2255009', '94152346-7', 'CALLE 26 No. 32-49', 'NULL', 1, 2),
(1020, 1, 'Rodrigo ', 'Paz Jimenez', NULL, NULL, '3758874', '310840009', '16.629.729', 'Carrera 53 No 1 A 50', 'pazrodrigo@yahoo.com', 1, 1),
(1021, 3, 'Freddy', 'Quintero Gutierrez', NULL, NULL, '2726748', '3182988708 - 3107141', '16269305', 'Calle 29 No. 19-31', 'efequin@hotmail.com', 1, 3),
(1022, 4, 'DISTRIPAPEL', ' .', NULL, NULL, '8205742-8206506', '0', '122761229', 'CR 17 No 12-101', 'ventas@distripapel.com.co', 1, 4),
(1023, 4, 'OSCAR EDUARDO', 'DUQUE ', NULL, NULL, '3128475327', '3127084876', '94464405-2', 'VEREDA TORRES LOTE 1', 'NULL', 1, 4),
(1024, 3, 'MAX', 'PRINTER', NULL, NULL, '6681579', '3204952866', '900474722-8', 'AV 5 AN 23 DN 68 LOCAL 288', 'MAZPRINTERSAS@HOTMAIL.COM', 1, 3),
(1025, 3, 'EMIR YISELA ', 'COLORADO COMETA', NULL, NULL, 'NO REFIERE', '3188492176', '29680997', 'CALLE 41 NO. 11-73 APTO 201', 'NO REFIERE', 1, 3),
(1026, 2, 'JOSÉ JULIAN', 'PALACIOS GAÑAN', NULL, NULL, '2243285', '2257787', '1.130.624.192', 'TULUA', 'direccion@cenal.com.con', 1, 1),
(1027, 4, 'JOSE RAMIRO', 'ARTEAGA', NULL, NULL, '8242101', '3146070147', '12981988', 'CR 10 NO 6-26', 'NULL', 1, 4),
(1028, 2, 'PINTU', 'MEZCLAS', NULL, NULL, '2242713', '2242713', '9.525.511-9', 'CALLE 27 No. 30-30', 'NULL', 1, 2),
(1029, 1, 'Maura Celene', 'Solis Lozano', NULL, NULL, '5559063', '3117779979', '1.130.609.551', 'Cr 143 No 71 URB. FALMENCO', '@', 1, 1),
(1030, 3, 'DEPRISA', 'S.A', NULL, NULL, 'NO REFIERE', 'NO REFIERE', '890100577-6', 'NO REFIERE', 'NO REFIERE', 1, 3),
(1031, 4, 'ELPUNTO', 'ELECTRICO', NULL, NULL, '8243881', '8242638', '170000036217', 'CR 4 No 6-09', 'ELPUNTOELECTRICO01@HOTMAIL.COM', 1, 4),
(1032, 3, 'WILILTON', 'ALVARADO', NULL, NULL, '2742198', '3167107151', '94324834', 'CALLE 24 NO. 73-42', 'NO REFIERE', 1, 3),
(1033, 3, 'Mauricio ', 'Guerrero', NULL, NULL, 'NO REFIERE', '3178799706', '79386133', 'Calle 33 No. 18-51/ Tulua', 'NO REFIERE', 1, 3),
(1034, 4, 'FERRETERIA', 'CADIS', NULL, NULL, '8240719', '3', '34529586-1', 'CR 6 No 6-69 CENTRO', 'N', 1, 4),
(1035, 4, 'RINCON ', 'ELECTRICO', NULL, NULL, '8', '3155485832', '34544042-8', 'CL 7 No 4 - 41', 'C', 1, 4),
(1036, 4, 'JARAMILLO  PETS', 'Y CIA S C', NULL, NULL, '4446202', '4446202', '811047208-1', 'CLL 9 SUR 50 FF-89 B/POBLADO-Medellin', 'WWW.JARAMILLOPETS.COM', 1, 4),
(1037, 2, 'SERVY', 'PRINT', NULL, NULL, '3103894751', '3103894751', '29.872.910', 'CARRERA 29 No. 17-01', 'NULL', 1, 2),
(1038, 1, 'MARTHA CECILIA', 'URIBE SUAREZ', NULL, NULL, '3147992405', NULL, '31.893.649', 'CALLE 18 #69-100 BLOQUE B APTO 201', 'UMARTHA CECILIA@YAHOO.ES', 1, 1),
(1039, 1, 'Ferro Electricos ', 'La 28', NULL, NULL, '2746901', '3185920881-304447536', '1113629956-8', 'Calle 28 No. 26-25/27 ', '@', 1, 3),
(1040, 3, 'La Delicia ', 'Paisa', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 3),
(1041, 1, 'MIRIAM STELLA', 'POSADA DONNEYS', NULL, NULL, 'n', 'n', '1144025110', 'n', 'n', 1, 1),
(1042, 1, 'Universidad Santiago de Cali', 'sede Palmira', NULL, NULL, 'c', 'c', '890030797-1', 'c', 'c', 1, 3),
(1043, 4, 'CLARO  COLOMBIA', 'CLARO ', NULL, NULL, '8369999', '8369999', '830053800-4', 'CRA 9 No 2AN-21 C.C. CAMPANARIO LC 54-55-56', 'WWW.CLARO.COM.CO', 1, 4),
(1044, 2, 'MARTHA CECILIA', 'GUERRA GUZMAN', NULL, NULL, '3216205998', '3216205998', '41.117.131', 'CALLE 21 No.35 A 31', 'NULL', 1, 2),
(1045, 3, 'Angie Katherine', 'Henao Campuzano', NULL, NULL, '2861077', '3167624954', '1113675750', 'dia. 26 no. t7-17', 'katherine082229@gmail.com', 1, 3),
(1046, 1, 'ALEXANDER ', 'VARGAS LULIGO', NULL, NULL, '3152879135', 'N', '16928464', 'CRA 24A ~# 33F-07 ', 'N', 1, 1),
(1047, 2, 'WILMAR A.', 'MACIAS M.', NULL, NULL, '3218016523', '3218016523', '94.355.559', 'CALLE 1A No. 04-01', 'WAMM.71@YAHOO.ES', 1, 5),
(1048, 2, 'QUIMICOS Y EMPAQUES', 'DEL VALLE', NULL, NULL, '2243850', '3155853866', '80062612-4', 'CALLE 28 No. 24-35', 'KEMEDELVALLE@HOTMAIL.COM', 1, 2),
(1049, 4, 'EXHIALAMBRE Orlando ', 'ASTUDILLO ZUÑIGA', NULL, NULL, '8243865', '8243865', '76.296.528-3', 'CRA 8 No 6-15', 'NO TIENE', 1, 4),
(1050, 1, 'FERNANDO ', 'TANAGARIFE ', NULL, NULL, '8851788', '3154280468', '16942074', 'CRA 10 # 9-64', 'N', 1, 1),
(1051, 3, 'LUIS EDUARDO', 'GARCIA ', NULL, NULL, 'NO REFIERE ', 'NO REFIERE', 'NO REFIERE ', 'NO REFIERE ', 'NULL', 1, 3),
(1053, 3, '126370139894', 'NO REFIERE', NULL, NULL, 'NO REFIERE', NULL, 'NO REFIERE', 'NO REFIERE', 'NULL', 2, 3),
(1054, 3, 'DE IMAGEN ', 'COLOMBIA LTDA', NULL, NULL, '3798031', '3104159499', '900147319-0', 'CR 9 21-53', 'info@deimagencolombia.com', 2, 1),
(1055, 4, 'CARMEN ALICIA', 'LLANTEN ESCOBAR ', NULL, NULL, '3164091699', '3164091699', '34534391', 'CRA 8 4-39', 'NULL', 1, 4),
(1056, 1, 'Luis Francisco ', 'Diaz Doria', NULL, NULL, 'c', 'c', '6.875.247', 'c', 'c', 1, 1),
(1057, 3, 'CAFETERIA', 'AZUCAR Y SAL', NULL, NULL, 'NO REFIERE', 'NO REFIERE', 'NO REFIERE', 'NO REFIERE', 'NULL', 2, 3),
(1058, 1, 'Monitorear ', 'Ltda', NULL, NULL, '6619909', 'NO REFIERE', '805.020.072-6', 'Calle 33 A norte No. 3N -56', 'servicioalcliente@monitorear.com, cartera@monotore', 1, 1),
(1059, 4, 'FRANKIL LEANDRO', 'PEREZ', NULL, NULL, '3136139779', '3136139779', '1061691149', 'CLL 62 No 17N-16 B/ SANTIAGO DE CALI', 'NO TIENE', 1, 4),
(1060, 1, 'Deisy  Yohana ', 'Derazo ', NULL, NULL, 'c', NULL, '37.124.505', 'c', 'c', 1, 1),
(1061, 1, 'FACOR', 'SAS', NULL, NULL, '4441768', 'NO REFIERE', '800.167.914-6', 'Calle 34 No 2N 09', 'NO REFIER', 1, 1),
(1062, 3, 'AUDRI ', 'GARCIA HERNANDEZ', NULL, NULL, '2876022', '3158904217', '66.778.305-0', 'calle 48 no 95-74 casa 18', 'no refiere ', 2, 3),
(1063, 2, 'CAMILO HERNAN', 'RODRIGUEZ', NULL, NULL, '2242832', '2242832', '14.894.974', 'CRA 25 N. 28-30', 'NULL', 1, 2),
(1064, 3, 'DIANY FERNANDA', 'ESCOBAR MORALES ', NULL, NULL, '2875105', '3177744005', '1113653305', 'CALLE 70 NO 28B 18', 'dferescobar@misena.edu.co', 1, 3),
(1065, 1, 'Fernando', 'Erazo', NULL, NULL, 'c', 'c', '11', 'c', 'c', 1, 1),
(1066, 4, 'ISABEL YARITZA', 'MUÑOZ GARCIA', NULL, NULL, '3218849625', '3218849625', '1060877744', 'EL TAMBO-CAUCA', 'KARLOS19947823@HOTMAIL.COM', 1, 4),
(1067, 1, 'Segundo ', 'Narvaez', NULL, NULL, '11', '11', '11', '11', '11', 1, 1),
(1068, 4, 'ALMA CATALINA', 'SOLIS AGREDO', NULL, NULL, '8205245', '3104566835', '1061751168', 'TRAV 3 No 21-89 B/ CALICANTO', 'ALCA9222@HOTMAIL.COM', 1, 4),
(1069, 2, 'AGASAJOS', 'TULUA', NULL, NULL, '2252514', '2252514', '29.871.808-1', 'CALLE 26 No. 31-15', 'luzmate61@hotmail.com', 1, 2),
(1070, 1, 'ALUMNO', 'CENAL ', NULL, NULL, 'NO REFIERE', 'NO REFIERE', '1114826683', 'NO REFIERE', 'NO REFIERE', 1, 3),
(1071, 3, 'las tres emes ', 'MMM', NULL, NULL, '8805888', '3113247560', 'no refiere', 'CRA 3 NO 11-29 OF 106', 'lastres.emes@hotmail.com', 2, 1),
(1072, 1, 'UPS Servicios Expresos', 'S.A.S.', NULL, NULL, '2940600', '4135110', '900.400.551-8', 'Avenida Calle 26 No 106-81 Bodega 11.12.13', '@', 1, 1),
(1073, 2, 'COOPERATIVA', 'DE GANADEROS', NULL, NULL, '2243132', '2243132', '800193348-7', 'CARRERA 23 No. 29-28', 'NULL', 1, 2),
(1074, 3, 'EDWIN FERNANDO ', 'MONTOYA ', NULL, NULL, '2747532', '3182655703', '6391801', 'CALLE 13 NO 3-20', 'NO REFIERE', 1, 3),
(1075, 1, 'Catherine ', 'Quintero Figueroa', NULL, NULL, 'NO TIENE', '3187002085', '38.559.430', 'Av 6 A NORTE No. 25 N80', 'bienestar@cenal.com.co', 1, 1),
(1076, 1, 'Papeleria Los Colores', 'SAS', NULL, NULL, '8898999', 'NO REFIERE', '800190654-2', 'Calle 13 No 6 - 46', '@', 1, 1),
(1077, 3, 'RADIO ', 'ELECTRICIDAD ', NULL, NULL, '2725231', 'NO REFIERE ', '31.170.417-9', 'CALLE 30 23-30', 'NO REFIERE ', 2, 3),
(1078, 2, 'SUPERINTENDENCIA', 'DE NOTARIADO Y REGISTRO', NULL, NULL, '2259370', '2259370', '0', 'CALLE 28 N 25-24', 'NULL', 1, 2),
(1079, 4, 'ANGEL ALBERTO', 'GUTIERREZ', NULL, NULL, 'NO REFIERE', 'NO REFIERE', '10527289-0', 'PASAJE CENTRO COMERCIAL ', 'NO REFIERE', 1, 4),
(1080, 2, 'ANDREA', 'DUQUE VARGAS', NULL, NULL, '3147108799', '3147108799', '34.001.857', 'CALLE 5 No. 6-79', 'NULL', 1, 2),
(1081, 3, 'variedades y detalles', 'marcela ', NULL, NULL, 'no refiere ', 'no refiere ', 'no refiere ', 'no refiere ', 'NULL', 2, 3),
(1082, 3, 'REMATES LOS LOCOS ', 'MARINILLOS ', NULL, NULL, 'NO REFIERE ', 'NO  REFIERE ', '70.690.813-5', 'CALLE 30 NO 24-28', 'NULL', 2, 3),
(1083, 4, 'LUIS HERNAN ', 'RAMIREZ', NULL, NULL, '3117680152', '3117680152', '4663800', 'CRA 23D No 15-21 B/SOLIDARIDA', 'NO TIENE', 1, 4),
(1084, 4, 'YIBER', 'QUIÑONEZ', NULL, NULL, '3116371588', '3116371588', '16536662', 'CRA 42 A No 6C-04 B/VILLA OCCIDENTE', 'NO TIENE', 1, 4),
(1085, 4, 'FERRETERIA FAMILIA PAZ ', 'SAS ', NULL, NULL, '8361944', '8361944', '900530280-4', 'CRA 6 No 5N-13 BARRIO BOLIVAR', 'NO TIENE', 1, 4),
(1086, 4, 'PLASTIASEO', 'PLASTIASEO', NULL, NULL, '8232520', '8232520', '12992700', 'CRA 6 No 5N-34 BARRIO BOLIVAR', 'NO TIENE', 1, 4),
(1087, 3, 'TITANIUM ', 'NO REFIERE ', NULL, NULL, 'NO REFIERE', 'NO REFIERE', 'NO REFIERE ', 'NO REFIERE ', 'NULL', 2, 3),
(1088, 1, 'Maray Medicina', 'Veterinaria', NULL, NULL, '5536445', '4854066', '11', 'Calle 5C No.. 40-27', '@', 1, 1),
(1089, 2, 'MERCAMAX', 'MJ`S', NULL, NULL, '2244265', '2244265', '66.717.108', 'CARRERA 22 No. 30-07', 'NULL', 1, 2),
(1090, 3, 'FOTOCOPIAS ', 'EL ESTUDIANTE ', NULL, NULL, 'NO REIFERE', 'NO REFIERE ', '16266107-1', 'CARRERA 29 NO 31-69', 'NULL', 2, 3),
(1091, 3, 'SIXTO', 'MONTAÑO', NULL, NULL, 'NO REFIERE ', 'NO REFIERE ', '10386454', 'NO REFIERE ', 'NULL', 1, 3),
(1092, 1, 'Rommel Leonardo ', 'Gutierrez Lozano', NULL, NULL, '4367686', '3155304034', '16941656', 'Calle 72 P No 28 A 11 B / COMUNEROS II', '@', 1, 1),
(1093, 3, 'EFRAIN', 'MUÑOZ PEÑA ', NULL, NULL, 'NO REFIERE ', '3204884271', '19136157', 'CALLE 43 A 2-40', 'NULL', 1, 3),
(1094, 4, 'SERVIPOSTAL', 'POPAYAN', NULL, NULL, '8217859', '8217859', '900190458-8', 'CRA 19D No 11A-47', 'WWW.SERVIPOSTAL.COM.CO', 1, 4),
(1095, 1, 'Local 103', 'Variedad  en Mercancias', NULL, NULL, '8810708', '8830737', '11', 'Cra 5 No 15 -00 San Andresito viejo', '@', 1, 1),
(1096, 1, 'Central de Triplex', 'Ltda', NULL, NULL, 'c', 'c', '890318280-1', 'c', 'c', 1, 1),
(1098, 4, 'JUAN GABRIEL', 'ROJAS DELGADO', NULL, NULL, '8388022', '3216446289', '1114814006-2', 'CLL 5 No 27-29 SANTA ELENA', 'NO TIENE', 1, 4),
(1100, 2, 'RAPIENTREGA', 'TULUA', NULL, NULL, '2253173', '3155247661', '16.367.787-1', 'CARRERA 26 No. 22-38', 'NULL', 1, 2),
(1101, 4, 'MARIO FERNANDO', 'PRADO', NULL, NULL, '3016816117', '3016816117', '10307590', 'CLLA 4 NO 11-704 apt 201', 'NO TIENE', 1, 4),
(1103, 4, 'KYRON ', 'VETERINARIOS', NULL, NULL, '8200911', '8200911', '76323884', 'CRA 6 No 26 AN-28 BRR LOS HOYOS', 'NO TIENE', 1, 4),
(1104, 4, 'CLAUDIA PATRICIA', ' PORRAS GUAICAL', NULL, NULL, '3166344114', '3166344114', '34.315.903 ', 'Carrera cra 18 No 13B-77 El Pajonal ', 'KANDY803@HOTMAIL.COM', 1, 4),
(1105, 4, 'RODRIGO', 'PRADO BONILLA', NULL, NULL, '8224200', '3014819210', '10.525.580', 'CRA 10 No 8-35 SAN CAMILO', 'NO TIENE', 1, 4),
(1106, 4, 'COMERCIALIZADOR', 'DEL CAUCA', NULL, NULL, '8237932', '8237932', '38438901-0', 'CRA 6 No 5N-83', 'NO TIENE', 1, 4),
(1107, 3, 'R Y S ', 'IMPRESORES', NULL, NULL, '2700319', '3182876399', '29.688.526-8', 'CALLE 32 NO 27-29', 'NULL', 2, 3),
(1108, 3, 'ferreteria ', 'la mejor ', NULL, NULL, '2730040', '3117468751', '31.137.443-1', 'calle 33 no 25-91', 'NULL', 2, 3),
(1109, 4, 'HUMBERTO', 'PAPAMIJA CASTILLO', NULL, NULL, '3146087441', '3146087441', '4753461', 'CLL 65 LOTE 72 ', 'NO TIENE', 1, 4),
(1110, 1, 'RECARTUCHOS', NULL, NULL, NULL, '8816091', '5532940', '29.105.269-1', 'Calle 9 No. 5 - 50 ', '@', 1, 1),
(1111, 1, 'Liga Vallecacuca ', 'de Tenis', NULL, NULL, '1', '0', '11', '0', '0', 1, 1),
(1112, 3, 'ALUMNO  ', 'CENAL ', NULL, NULL, '2708888', NULL, 'NO REFIERE ', 'CALLE 31 23-44', 'NULL', 1, 3),
(1113, 2, 'FERRO', 'ELECTRA', NULL, NULL, '2243008', '2243008', '16.348.202', 'CALLE SARMIENTO No. 21-31', 'NULL', 1, 2),
(1114, 3, 'GRAFIMETAL', NULL, NULL, NULL, '8800320', '3128556940', '16.799.464-1', 'CRA 4 NO 20-17 SAN NICOLAS ', 'NULL', 1, 3),
(1115, 2, 'PAULA ANDREA', 'ZAPATA', NULL, NULL, '2257787', '2257787', '43.632.642', 'CARRERA 23 No. 32-41', 'NULL', 1, 2),
(1116, 3, 'FERNANDO ', 'TABARES', NULL, NULL, 'NO REFIERE ', 'NO REFIERE ', '16278564', 'NO REFIERE ', 'NULL', 1, 3),
(1117, 4, 'HOROLD', 'FERNADEZ', NULL, NULL, '3165636071', '3165636071', '76332359', 'CALLE 61N 16-125', 'CMSPOPAYAN@GMAIL', 1, 4),
(1118, 2, 'HECTOR', 'VIDALES LOPEZ', NULL, NULL, '3168468426', '3168468426', '2.482.377', 'CARRERA 6 No. 12-40', 'NULL', 1, 2),
(1119, 2, 'ELECTRICOS', 'E ILUMINACIONES', NULL, NULL, '8844506', '8844506', '900.436.595-7', 'CARRERA 6 No. 17-24', 'NULL', 1, 1),
(1120, 1, 'EXTINTORES', 'ALRAL SAS', NULL, NULL, '8853582', '3104129298', NULL, 'CRA 13 N. 22A33 B/ OBRERO', 'ALRAL_48@OUTLOOK.COM', 1, 1),
(1121, 3, 'CAFETERIA', ' AGORA ', NULL, NULL, NULL, NULL, NULL, NULL, 'NULL', 1, 3),
(1122, 1, 'Secretaria de Infraestructura ', 'y Valorización', NULL, NULL, 'c', 'c', '11', 'c', 'c', 1, 1),
(1123, 3, 'VARIEDADES ', 'EL PAISA ', NULL, NULL, NULL, '3154875108', NULL, 'CALLE 30 NO 24-25 ', 'NULL', 1, 3),
(1124, 3, 'MASTER ', 'SOCIEDAD FERRETERA DE COLOMBIA', NULL, NULL, NULL, NULL, '800.052.377-6', 'CARRERA 33 NO 28-24', 'NULL', 2, 3),
(1125, 3, 'FERREPLASTICOS ', 'LTDA', NULL, NULL, NULL, '3136559653', '815.003.909-1', 'CALLE 28 #27-60', 'NULL', 2, 3),
(1126, 2, 'ERIKA', 'VELA MEDINA', NULL, NULL, '3117223736', '3117223736', '1.146.634.408', 'CARRERA 28D No. 11-30', 'NULL', 1, 2),
(1127, 4, 'YOLANDA  ISABEL', 'CORTES GUERRERO', NULL, NULL, '3217644076', '3217644076', '34318950', 'k 5 DE 9A 03', 'ISABELITA-C@HOTMAIL.COM', 1, 4),
(1128, 1, 'Leidy Viviana ', 'Montiel  Beltran', NULL, NULL, '3723338', '3205857963', '31.306.369', 'Av 6 norte No 45 N 70 la flora', 'vivianamontnrgm@hotmail.com', 1, 1),
(1129, 3, 'EL', 'CONDOR ', NULL, NULL, NULL, '3176806133', '1113637207-3', 'CALLE 29 NO 23-12', 'NULL', 2, 3),
(1130, 4, 'LARRY FELIPE', 'VIDAL ASTUDILLO', NULL, NULL, '3147902279', '3147902279', '1061711440', '3147902279', 'NO TIENE', 1, 4),
(1131, 1, 'LARGO ', 'Arquitectura', NULL, NULL, 'c', 'c', '14.973.886', 'c', 'c', 1, 1),
(1132, 4, 'RAUL ANDRES', 'RUIZ MUÑOZ', NULL, NULL, '8205359', '3116283572', '76320541', 'CRA 6A No 3N-45 LA ESTACION', 'NO TIENE', 1, 4),
(1133, 3, 'JULIO CESAR ', 'MUÑOZ', NULL, NULL, NULL, NULL, '34331740', 'DIAG 26 TRASV 6-101', 'NULL', 1, 3),
(1134, 3, 'PANADERIA ', 'NUEVO REALPE', NULL, NULL, '2744652', NULL, '29.673.912-5', 'CARA 28  ', 'NULL', 2, 3),
(1135, 1, 'HOMECENTER', '0', NULL, NULL, '0', '0', '0', '0', '0', 1, 1),
(1136, 3, 'almacen ', 'los colores', NULL, NULL, '2719046', NULL, '22.020.218-4', 'calle 28 no 26-71', 'NULL', 2, 3),
(1137, 3, 'gasperini ', 'gourmet', NULL, NULL, '2864913', '3157084145 - 3147306', '74.335.818-5', 'calle 32 n0 25 -12', 'NULL', 2, 3),
(1138, 1, '0', '0', NULL, NULL, '0', '0', '0', '0', '0', 1, 1),
(1139, 1, 'FLORISTERIA', 'PAOLA', NULL, NULL, '0', '0', '0', '0', '0', 1, 1),
(1140, 3, 'ferreteria y cerrajeria ', 'posada ', NULL, NULL, NULL, NULL, '14.651.502-1', NULL, 'NULL', 2, 3),
(1141, 3, 'construyamos con ', 'fercho ', NULL, NULL, '2812488', '3186833493', '16.284.914-3', 'cra 28n28-21', 'NULL', 1, 3),
(1142, 2, 'MARIO', 'ALZATE CARDONA', NULL, NULL, '3137512587', '3137512587', '2219687', 'CONDOMINIO CIUDAD JARDIN', 'alzatemario361@gmail.com', 1, 2),
(1143, 2, 'SURTIFAMILIAR ', 'S.A', NULL, NULL, '2246185', '2246185', '805.028.991-6', 'CARRERA 21 No. 25-76', 'NULL', 1, 2),
(1144, 1, 'Corporación para la recreación', 'Popular', NULL, NULL, '6655212', NULL, '890.316.344-5', 'PACARA AV 2 GN No 52AN 44', '@', 1, 1),
(1145, 3, 'LA BODEGUITA', 'SUPERMERCADO TECNOLOGICO', NULL, NULL, '4867070', NULL, '900545461-6', 'AV 5AN NO 23DN68 LOCAL 121', 'NULL', 2, 1),
(1146, 3, 'DIGITAL ', 'PLANET.COM', NULL, NULL, '6536363', NULL, '31988112-1', 'AV 5 NORTE 2DN 68 LOCAL ', 'NULL', 2, 1),
(1147, 3, 'NES ', NULL, NULL, NULL, '4893354', '4851821', '830037278-1', 'AV 5N  NO 23DN68 LOCAL 1-85', 'NULL', 2, 1),
(1148, 2, 'GRACE', 'CERTUCHE CONCHA', NULL, NULL, '3164907283', '3164907283', '1.115.073.430', 'CALLE 16 No. 15-83', 'GRACEKELLY06@HOTMAIL.COM', 1, 2),
(1149, 4, 'DAVID FELIPE', 'JIRON', NULL, NULL, '3015741359', '3015741359', '10.305.799', 'CALLE 4 21-74', 'NULL', 1, 4),
(1150, 1, 'VISTOR', 'SERNA HOYOS', NULL, NULL, '8891190', NULL, '94487410-9', 'CRA 9 # 9-17', NULL, 1, 1),
(1151, 1, 'ROMULO ', 'MONTES', NULL, NULL, '/', '/', '800198467-8', 'cll 10 # 8-43', '/', 1, 1),
(1152, 1, 'Gustavo Adolfo', 'Valencia López', NULL, NULL, '4222293', '3153623582', '1.130.663.970-7', 'Diagonal 26 J No. T 93 -32', 'gatorecreacionyeventos@hotmail.com', 1, 1),
(1153, 2, 'ELECTROS E', 'ILUMINACIONES LA 26', NULL, NULL, '2252700', '2252700', '16.364.010-4', 'CALLE 26 No. 23-52', 'NULL', 1, 2),
(1154, 1, 'Andina Electronica', 'S.A.S', NULL, NULL, '1', '1', '1', '1', '1', 1, 1),
(1155, 2, 'MONICA ALEJANDRA', 'TOBON PASTRANA', NULL, NULL, '3178061651', '3178061651', '1.116.243.773', 'CALLE 43 No. 25-109', 'monikalejatp@hotmail.com', 1, 2),
(1156, 4, 'NORMA ', 'EVERLI', NULL, NULL, '3217452514', NULL, '34321549', 'TIMBIO', 'NULL', 1, 4),
(1157, 1, 'Maria Lilia', 'Gañán', NULL, NULL, '1', '1', '11', '1', '1', 1, 1),
(1158, 4, 'WALTER', 'MORALES', NULL, NULL, '3103932534', '76307522', '76307522', 'CALLE 36N 4-114', 'TICECOWA17@HOTMAIL.COM', 1, 4),
(1159, 4, 'FERNANDO ', 'HURTADO', NULL, NULL, '234479', '234479', '76314459-1', 'KRA 6 2N 25', 'NULL', 1, 4),
(1160, 4, 'CENTRO COMERCIAL ', 'CAMPANARIO ', NULL, NULL, '6817301', '6817301', '900218859-1', 'KRA 9 24 AN 21 ', 'NO ', 1, 4),
(1161, 1, 'TECNOMAXX', '.ES', NULL, NULL, '6612641', '3217590441', '1144049798-4', 'CLL 24 N AV. 5TA A-14', NULL, 1, 1),
(1162, 4, 'FABIO ', 'CERON ', NULL, NULL, '3155768930', '3155768930', '4613473', 'MANZANA 48  48-12', 'NO ', 1, 4),
(1163, 4, 'JESUS DAVID ', 'GIRON', NULL, NULL, '3147591237', '3147591237', '10305799', 'CALLE 4  21-74', 'NO', 1, 4),
(1164, 3, 'CAMADA', 'S.A.S', NULL, NULL, NULL, NULL, '900519669-0', NULL, 'NULL', 2, 3),
(1165, 4, 'CESAR ALFONSO', 'CARDENAS', NULL, NULL, '3147094366', '3147094366', '76321408', 'CENTRO ', 'NO TIENE ', 1, 4),
(1166, 1, 'Jhonnier Tabima Perez', 'FerreGrajales', NULL, NULL, '317 6888816', '44', '16401220', 'Cra 42A No. 40-03', '@', 1, 1),
(1167, 2, 'JUAN CARLOS', 'GALVIZ Z.', NULL, NULL, '3113411911', '3113411911', '94.283.948', 'MANZANA 5A -3', 'NULL', 1, 2),
(1168, 4, 'ANGELA KARINA', 'TRULLO', NULL, NULL, '3148487098', '3148487098', '1061218983', 'CLL 7 No 22-56 B/ JOSE MARIA OBANDO', 'KARINATRULLO@HOTMAIL.COM', 1, 4),
(1169, 2, 'ANGELICA MARIA', 'GREGORY ARIAS', NULL, NULL, '2322665', '2322665', '1112101736', 'TULUA', 'NULL', 1, 2),
(1170, 1, 'Almacenes', 'Éxito', NULL, NULL, '3396565', 'na', '890900608-9', 'chipichape', 'na', 1, 1),
(1171, 1, 'DIDACLIBROS', 'LTDA', NULL, NULL, '2841318', '2847276', '800036678-0', 'CLL 17 7-60 OF 818 BOGOTA', 'didaclibros@etb.net.co', 1, 1),
(1172, 1, 'Lina Maria', 'Cortes Cardona', NULL, NULL, '3782359', '3216447524', '1.143.825.036', 'Carrera 18 No 2 aoeste 36', 'limar1315@hotmail.com', 1, 1),
(1173, 4, 'ALVARO ALBERTO', 'VARGAS MUÑOZ ', NULL, NULL, '8225626', '8225626', '7525615-9', 'CLL 4 No 17-63 B/ PANDIGUANDO', 'NO TIENE', 1, 4),
(1174, 4, 'JHON JAIRO ', 'BELALCAZAR', NULL, NULL, '3113280714', '3113280714', '10490776-4', 'CALLE 4 No 16-17', 'NO TIENE', 1, 4),
(1175, 4, 'MADECENTRO ', 'MADECENTRO ', NULL, NULL, '8394848', '8394848', '811028650-1', 'CRA 17 No 7-87', 'NO TIENE', 1, 4),
(1176, 4, 'QUIMPO', 'POPAYAN', NULL, NULL, '8310031', '8310031', '800131956-1', 'KRA 15 #1-02', 'NO', 1, 4),
(1177, 2, 'BIODENTS', 'TULUA', NULL, NULL, '3178799706', '3178799706', '79386133-5', 'CALLE 33 No. 18-51', 'NULL', 1, 2),
(1178, 4, 'LORENA ', 'VILLOTA', NULL, NULL, '3128906611', '3128906611', '1085273772', 'LOS PERIODISTAS CASA 4', 'NO', 1, 4),
(1179, 2, 'REVISTA', 'CENTRO GERIATRICO', NULL, NULL, '3217299527', '3217299527', '6366769', 'TULUA', 'NULL', 1, 2),
(1180, 1, 'Center', 'Electronic', NULL, NULL, '8857172', NULL, '16.741.142-5', 'Carrera 6 No. 16-60', 'center-electronicahotmail.com', 1, 1),
(1181, 1, 'Maria Pilar', 'Castillo', NULL, NULL, '3117037874', '3117037874', '31.963.761-1', 'Carrera 1A6 No. 73-07', '@', 1, 1),
(1182, 3, 'TECNICARTUCHOS & ', 'LASER', NULL, NULL, '2713301', '2731161', '66.765.822-0', 'CALLE 31 NO 39-30', 'NULL', 2, 3),
(1183, 1, 'Representaciones Turisticas', 'Mar y Eventos', NULL, NULL, '6653431', '3117565963', '2956246-0', 'c', 'maretur2002@gmail.com', 1, 1),
(1184, 2, 'ARLEY ', 'CORREA', NULL, NULL, '3155375872', '3155375872', '6433121', 'LA CARRILERA', 'NULL', 1, 2),
(1185, 2, 'DISTRI', 'COSMOS', NULL, NULL, '2257246', '2257246', '900.477.861-7', 'CALLE 28 No. 20A 12-16', 'NULL', 1, 2),
(1186, 2, 'PAPELERIA', 'LA 26', NULL, NULL, '2247760', '2247760', '94.193.573-8', 'CALLE 26 No. 32 A 06', 'NULL', 1, 2),
(1187, 2, 'DIARIO', 'OCCIDENTE', NULL, NULL, '2253025', '2253025', '983174650', 'CALLE 25 No. 25-69', 'NULL', 1, 2),
(1188, 3, 'GLORIA YANETH', 'PEREA RIASCOS', NULL, NULL, NULL, '3146478133', '1112221721', 'CRA 9B 25-50', NULL, 1, 3),
(1189, 4, 'MARTIN', 'GAONA', NULL, NULL, '315252635', '315252635', '34318956', 'LA LOMA', 'NULL', 1, 4),
(1190, 1, 'Dora Angélica', 'Arias', NULL, NULL, '2257787', '3154640719', 'nn', 'CENAL Tuluá', 'cuenta avvillas 154934538', 1, 1),
(1191, 2, 'SEBASTIAN', 'CARVAJAL FLOREZ', NULL, NULL, '3136711814', '3136711814', '1.116.257.861', 'CALLE 25 No. 26-38', 'NULL', 1, 2),
(1192, 3, 'ALMACEN ', 'RR', NULL, NULL, '2810685', NULL, '521.792-0', 'CARRERA 28 28-12', 'NULL', 2, 3),
(1193, 4, 'YUDY ANDREA', 'NARVAEZ', NULL, NULL, '8242412', NULL, '34.570.894', 'COMUNICATE IMPRESORES', 'NULL', 1, 4),
(1194, 1, 'Fundación Paz ', 'Animal', NULL, NULL, '8933824', 'C', '805.006.161-5', 'CR 4 N 1 42', 'C', 1, 1),
(1195, 3, 'MADECENTRO', 'COLOMBIA S.A.S', NULL, NULL, '2807565', 'NO REFIERE', '811028650-1', 'CRA 28 NO 27-65', 'NOREFIERE', 2, 3),
(1196, 3, 'FERRETERIA JHON', 'SOLO LLAVES', NULL, NULL, '2713568-2729640', '3155559696', '94.322.474-1', 'CALLE 28 NI 26-51', 'NO REFIERE', 2, 3),
(1197, 2, 'DISTRIBUIDORA', 'DEMEFAR', NULL, NULL, '2259634', '2259634', '94.395.452-2', 'CARRERA 35 No.26-17', 'NULL', 1, 2),
(1198, 2, 'RENZO ANTONIO', 'COPETE DIAZ', NULL, NULL, '3177080631', '3177080631', '16.368.775', 'CALLE 38 No. 33 A 34', 'NULL', 1, 2),
(1199, 2, 'RAPITIENDA', 'NUEVO PRINCIPE', NULL, NULL, '2258256', '2258256', '31.315.201', 'NUEVO PRINCIPE', 'NULL', 1, 2),
(1200, 2, 'JORGE ENRIQUE', 'GUARIN HINCAPIE', NULL, NULL, '3157694876', '3157694876', '94.368.486', 'CALLE 36 No. 34 79', 'NULL', 1, 2),
(1201, 1, 'Andina  de Seguridad  del Valle', 'LTDA', NULL, NULL, '4860202', '4860200', '890.333.105-3', 'Calle 47 norte No 4 BN 85', 'cartera@andinaseguridad.com.co', 1, 1),
(1202, 3, 'STICKER`S &', 'CALCOMANIAS', NULL, NULL, '2814100', '3113209628', '94.310.375-9', 'CRA 28 NO 35-58', 'NO REFIERE', 2, 3),
(1203, 1, 'Pasarela', NULL, NULL, NULL, '1', '1', '11', '1', '1', 1, 1),
(1204, 3, 'ramo', 'de occidente ', NULL, NULL, '2717600', 'no refiere', '891303036-9', 'cra 35 no 43-162/174', 'ramoteescucha@ramo.com.co', 2, 3),
(1205, 4, 'FERNANDO ', 'MARTINEZ', NULL, NULL, '3218301440', '3218301440', '1007208835', 'KRA 21 65N 27', 'NO', 1, 4),
(1206, 2, 'CARVAJAL', 'PUBLICAR', NULL, NULL, '4104977', NULL, '860001317-4', 'CALLE 17 No. 60-85', 'NULL', 1, 2),
(1207, 2, 'DEPOSITO PRINCIPAL', 'DE DROGAS LTDA', NULL, NULL, '2312030', NULL, '860.514.592-5', 'CARRERA 34 No. 37-60', 'NULL', 1, 2),
(1208, 2, 'PARFUN', 'CHANEL', NULL, NULL, '3146491608', '3146491608', '29.236.704.-2', 'PLENOCENTRO', 'NULL', 1, 2),
(1209, 4, 'JUAN MANUEL', 'PERAFAN ', NULL, NULL, '3113500380', '3113500380', '160718572', 'CALLE 19CN 3-33', 'NULL', 1, 4),
(1210, 4, 'JUAN PABLO', 'ANDRADE', NULL, NULL, '3157702080', '3157702080', '10293232', 'KRA 15 A 9N 98', 'NO', 1, 4),
(1211, 4, 'HELDER', 'MUÑOZ', NULL, NULL, '8317149', '8317149', '76330841', 'KRA 15 4-05', 'NULL', 1, 4);
INSERT INTO `proveedores` (`id`, `sede_id`, `nombres`, `apellidos`, `created_at`, `deleted_at`, `telefono`, `celular`, `num_documento`, `direccion`, `email`, `identificacion_id`, `ciudad_id`) VALUES
(1212, 4, 'ARMANDO', 'CATAMUSCAY', NULL, NULL, '3124681479', '3124681479', '1061718925', 'VEREDA SANTA ', 'NO', 1, 4),
(1213, 2, 'CARLOS ROOSBELT', 'DIAZ CARVAJAL', NULL, NULL, '3168354199', '3168354199', '94.364.503', 'CALLE 29 No. 30-52', 'NULL', 1, 2),
(1214, 1, 'Juliana ', 'Roman Alvarado', NULL, NULL, '4456414', '3206637072', '1.151.945.524 ', 'Trns 29 No D 28 16 VILLANUEVA', 'juliana_roal@hotmail.com', 1, 1),
(1215, 1, 'Luis Eduardo ', 'Arango Murillo', NULL, NULL, '6627810', '3150918069', '16.287.023', 'Calle 15 No 42 a 09', 'luis.arango7@gmail.com', 1, 1),
(1216, 1, 'Edwin ', 'Vaquez Guarnizo', NULL, NULL, 'no tiene', '3217158192', '94329396', 'Calle 34 No 18 28 ', '@', 1, 1),
(1217, 1, 'Maria Nilbia ', 'Mosquera Sanchez', NULL, NULL, 'NO TIENE', '3117888094 - 3162228', '66.988.955', 'Cra 50 coeste No 12-08', '@', 1, 1),
(1218, 1, 'Diana Lizeth', 'Ortiz Balanta', NULL, NULL, '3818303', '3187064979', '1.144.145.456', 'Calle 101 C No 23 B 48', 'dianal_2490@hotmail.com', 1, 1),
(1219, 3, 'CENCOSUD ', 'COLOMBIA S.A', NULL, NULL, '2707600', 'NO REFIERE', '900.155.107-1', 'CARA 28 CON CALLE 43 ', 'NO REFIERE', 2, 3),
(1220, 4, 'SANDRA  MONICA', 'RIVERA CASTILLO', NULL, NULL, '3154338965', '3154338965', '34569787', 'CALLE 35 4 -102', 'NO', 1, 4),
(1221, 3, 'LUIS ALBERTO ', 'RIOS ', NULL, NULL, '2863195', '3127546725', '16274144', 'CARA 19 37-94 ', 'luisalbertorios19911965@gmail.com', 1, 3),
(1222, 1, 'Frey', 'Cadena Garcia', NULL, NULL, '6676875', '4055157', '18.389.273-1', 'Centro Comerncial La Pasarela L-221', '@', 1, 1),
(1224, 3, 'ELECTRONICAS TV & ', 'VIDEO', NULL, NULL, '2739885', 'NO REFIERE', '31.998.001-3', 'CALLE 31 NO 24-07', 'NO REFIERE', 2, 3),
(1225, 4, 'ASTRID', 'CORTES GONZALEZ', NULL, NULL, '8381367', '3017837282', '34321682', 'CRA 9 # 2 -34 CENTRO', 'AJCORTESG@HOTMAIL.COM', 1, 4),
(1226, 4, 'AGROPECUARIA', 'AGUA ', NULL, NULL, '8230916', '8230916', '48600293', 'NO', 'NO', 1, 4),
(1227, 4, 'TRIPLEX', 'LOS ANDES', NULL, NULL, '8202774', '8202774', '43612869', 'NO', 'NO', 1, 4),
(1228, 4, 'HENRY ', 'TOBAR', NULL, NULL, '3157818759', '3157818759', '76315522', 'CALLE 55  AN 14-59', 'NULL', 1, 4),
(1229, 1, 'Maderas y Enconfrados', 'Anchico', NULL, NULL, '4456358 - 4456374', '3', '13.103.491-3', 'Transv. 29 No. 27-17 B/ El Paraiso', 'maderasanchico@hotmail.com', 1, 1),
(1230, 2, 'GUSTAVO', 'LOPEZ RAVAGLI', NULL, NULL, '3185830589', '3185830589', '16.357.746', 'CALLE 35 No. 31-16', 'NULL', 1, 2),
(1231, 4, 'FABIAN ', 'RUIZ', NULL, NULL, '3147096439', '3147096439', '94329260', 'KRA 14 1N 33', 'NULL', 1, 4),
(1232, 4, 'CRISTOPHER', 'CERTUCHE', NULL, NULL, '3147636976', NULL, '962546581', 'NO', 'NULL', 1, 4),
(1233, 4, 'ANYI MARICEL ', 'BEDOYA ', NULL, NULL, '3206302427', '3206302427', '1061733409', 'NO', 'NULL', 1, 4),
(1234, 4, 'ALEJANDRO ', 'ABELLA ', NULL, NULL, '3218172083', '3218172083', '76324192', 'MANZANA 33  33-07', 'NULL', 1, 4),
(1235, 1, 'Zona Creativa', 'Agencia Grafica', NULL, NULL, '3804573', '3122901763', '16.796.241-2', 'Cra 3 No. 19-32', 'zonacreativacali@yahoo.es', 1, 1),
(1236, 3, 'OSITOS ALQUILER', 'DE TODO PARA SUS FIESTAS', NULL, NULL, '2725290', '2758323', '31131876-1', 'CARRERA 26 NO 36-11', 'NO REFIERE', 2, 3),
(1237, 4, 'GRANERO ', 'COLOMBIA', NULL, NULL, '8242660', '8325555', '94510352-1', 'CALLE 8 4-29', 'NULL', 1, 4),
(1238, 4, 'YULI', 'JUSPIAN', NULL, NULL, '80307849', NULL, '1061747266', 'TRASN 33B # 8-36', 'NULL', 1, 4),
(1239, 1, 'Ronbinson', 'Rivas Ayala', NULL, NULL, '4414286', '3172946603', '6.136.256', 'Carrera 12 No 46-57', 'robinsonrivasayala@hotmail.com', 1, 1),
(1240, 1, 'Robinson', 'Rivas Ayala', NULL, NULL, '4414286', '3172946603', '6.136.256', 'Carrera 12 No. 46 -57', 'robinsonrivasayala@hotmail.com', 1, 1),
(1241, 1, 'Enna Yaneth ', 'Rivas Moreno', NULL, NULL, '3353429', '3155404749', '67.032.855', 'Carre 38 No 12 a 136', 'mayadelap@hotmail.com', 1, 1),
(1242, 4, 'CAUCA ', 'LLAVES CERRADURAS ', NULL, NULL, '8205453', '3154925080', '34606798', 'calle 4No. 16-17 2do piso ', 'NULL', 1, 4),
(1243, 3, 'QUIMICOS PALOMINO Y', 'CASTAÑEDA S.A.S', NULL, NULL, '2864685', NULL, '900.458.615-0', 'CARRERA 23 NO 31-29', 'NULL', 2, 3),
(1244, 3, 'ALONDRA ', 'MAYORISTA LTDA', NULL, NULL, '2732968', 'NO REFIERE', '815.000.351-7', 'CRA 28 NO 32-44 ', 'NO REFIERE', 2, 3),
(1245, 2, 'LIBIA', 'AGUDELO CALLEJAS', NULL, NULL, '3163529249', '3163529249', '31.194.611', 'CARRERA 15 No. 25 -61', 'NO REGISTRA', 1, 2),
(1246, 2, 'ANDRES EDUARDO', 'CARDOZO', NULL, NULL, '3117943416', '3117943416', '1112105108', 'MZ 6 CASA 11', 'NULL', 1, 2),
(1247, 4, 'VALENTINA', 'LOPEZ', NULL, NULL, '3008121230', '3008121230', '1144074981', 'CALLE 1N # 8-83 MODELO', 'NULL', 1, 4),
(1248, 1, 'Luis Enrique ', 'Gomez Rojas', NULL, NULL, 'c', 'c', '94.458.689', 'c', 'c', 1, 1),
(1249, 1, 'Colombina', 'S.A.', NULL, NULL, '2205040', '88619999', '890.301.884-5', 'LA PAILA ZARZAL', '@', 1, 1),
(1250, 2, 'HEBERTH HERNANDO', 'GARCIA TAMAYO', NULL, NULL, '3122573849', '3122573849', '6.199.170', 'CARRERA 5 No. 8-69', 'NULL', 1, 2),
(1251, 2, 'JULIAN', 'QUIJANO BAUTISTA', NULL, NULL, '3174390423', '3174390423', '91.243.511-6', 'CALLE 40 No. 24-80', 'NULL', 1, 2),
(1252, 1, 'Milenio', 'LTDA', NULL, NULL, '8895002', '1', '805.010.892-6', 'CALLE 15 No 7-109', 'milenioferreteria1998@hotmail.com', 1, 1),
(1253, 2, 'COMFENALCO', 'VALLE', NULL, NULL, '226 2608', '225 1086', '890.303.093-5', 'Calle 26 No. 34-11', 'NULL', 1, 2),
(1254, 1, 'Papeleria Atlanta', 'LTDA', NULL, NULL, '8857478', '8800090', '805.005.139-8', 'Carrera 9 No. 11-50 local 108', 'patlantaltda@hotmail.com', 1, 1),
(1255, 2, 'NUBIA STELLA', 'CERON LONDOÑO', NULL, NULL, '3135774136', '3135774136', '31.966.362', 'CALLE 33 No. 32 A 49', 'NULL', 1, 2),
(1256, 1, 'Epicentro Electrico ', 'Cali S.A.S', NULL, NULL, '8893940', '8893940', '900348386-7', 'CR 6 18 51 B/ SAN NICOLAS', '@', 1, 1),
(1257, 4, 'LUISA FERNADA', 'GARZON ', NULL, NULL, '3116283572', '8205359', '25635224-1', 'KRA 6 A  3N-45', 'NO', 1, 4),
(1258, 2, 'RESERVAS DEL EJERCITO', 'Y POLICIA NACIONAL', NULL, NULL, '3172785963', '3172785963', '801.003.441-4', 'TULUA', 'NULL', 1, 2),
(1259, 1, 'DIRECTV', NULL, NULL, NULL, 'C', 'C', '805.006.014-0', 'C', 'C', 1, 1),
(1260, 4, 'IRALDO', 'TROCHEZ', NULL, NULL, '3178290064', '3178290064', '76000479', 'K 50 59N-83', 'NULL', 1, 4),
(1261, 2, 'SOLUCIONES', 'TECNICAS INTEGRALES', NULL, NULL, '2326103', '2326103', '94394152-3', 'CARRERA 28A No. 16-45', 'NULL', 1, 2),
(1262, 1, 'DISTRIBUIDORA ', 'AGUA PUREZA', NULL, NULL, '4430408', '3162702279', '29178034-0', 'CLL 36 # 13-32', 'AGUAPUREZACALI@HOTMAIL.COM', 1, 1),
(1263, 4, 'OSCAR  MARCEL', 'LOPEZ PERAFAN ', NULL, NULL, '8242412', '8242412', '76.319.878-1', 'CLL 7 No 10A-20', 'NO REFIERE', 1, 4),
(1264, 3, 'ALMACEN ', 'ELECTRO SABAS', NULL, NULL, '3154244303', NULL, '16.276.354-5', 'CALLE 30 NO 24-12', NULL, 2, 3),
(1265, 4, 'cacharreria ', 'el gancho', NULL, NULL, '8240571', '8240571', '4608443-1', 'kra 5 7-24', 'no', 1, 4),
(1266, 4, 'VARIEDADES SANTA ', 'JUANA', NULL, NULL, '8201547', '8201547', '34529900-1', 'CLL 2 No 3-16', 'NO TIENE', 1, 4),
(1267, 1, 'JAIME ALBERTO', 'ISAZIGA', NULL, NULL, '8894679', '3137309983', '16650094', 'CRA 4 # 20-40', 'NULL', 1, 1),
(1268, 4, 'IVETH ANGELICA ', 'CHAWEZ PULIDO', NULL, NULL, '8366048', '3146516793', '34.331.232', 'CRA 6A No 20N-21 B/CIUDAD JARDIN', 'ANGELLIKCHA@HOTMAIL.COM', 1, 4),
(1269, 1, 'HURTADOING', 'Daniel Adel Hurtado Yela', NULL, NULL, '4451981', '3218775446', '6103748-5', 'Diagonal 29B No. T33 -E31', 'hurtadoing@gmai.com', 1, 1),
(1270, 3, 'VIVERO ', 'MARINELA S.A.S', NULL, NULL, '2724010', NULL, '891.300.900-4', 'CALLE 42 NO CRA 49 ', 'NULL', 2, 3),
(1271, 3, 'volante', 'express', NULL, NULL, 'no refiere', '3163047019', '94.307.931', 'calle 46a no 30-20 ', 'volanteexpress1@hotmail.com', 2, 3),
(1272, 4, 'ENIO (METALICAS AZ)', 'ASTUDILLO ZUÑIGA', NULL, NULL, '8243865', '8243865', '76.276.595-1', 'CRA 8 No 6-24 CENTRO', 'NO REFIERE', 1, 4),
(1273, 1, 'COPIAS ANDRES', '0', NULL, NULL, '0', '0', '0', '0', '0', 1, 1),
(1274, 2, 'MEDALLAS', 'Y LLAVEROS', NULL, NULL, '2242390', '2242390', '6.509.849-4', 'CALLE 36 No. 25-61', 'NULL', 1, 2),
(1275, 1, 'La Bodeguita Supermecado ', 'Tecnologico', NULL, NULL, '4867070', '44', '900545461-6', 'Av 5 AN N 23 DN 68 LOCAL 121', '0', 1, 1),
(1276, 2, 'MADERAS Y', 'HERRAJES RUIZ', NULL, NULL, '2257423', '2257423', '16368928', 'CARRERA 30 No. 20-17', 'NULL', 1, 2),
(1277, 1, 'Lometal ', 'S.A.S C.I', NULL, NULL, '4425656', '4425656', '800.152.138', 'cR 6 a nO 31 -40', 'LOMETAL@LOMETAL.NET', 1, 1),
(1278, 4, 'TODO A BILLETE DE 5000', 'NO REQUIERE', NULL, NULL, 'NO REQUIERE', 'NO REQUIERE', 'NO REQUIERE ', 'POPAYAN', 'NULL', 1, 4),
(1279, 3, 'TATIANA MILENA ', 'MAPURA VARELA', NULL, NULL, '2815519', '3165890182', '66783693', 'CALLE 42 A 10-18 URBANIZACION CAMPESTRE', NULL, 2, 3),
(1280, 1, 'Lucy ', 'Argote Muñoz', NULL, NULL, 'no tiene', '3153769124', '66852126', 'Cr 27 B No 123 -25', 'lucyargote@hotmail.com', 1, 1),
(1281, 4, 'Edinson ', 'Muñoz', NULL, NULL, '3152930200', '3152930200', '76333166', 'calle 15#7-63', 'vectorpublic@hotmail.com', 1, 4),
(1282, 3, 'JORGE ELIECER ', 'SALAZAR SILVIA', NULL, NULL, '2865466', '314673845', '94331505', 'CALLE 33A NO 5AE-90 PRADOS DE ORIENTE', 'NULL', 1, 3),
(1283, 4, 'ESCOLVISUAL ', 'ESCOLVISUAL ', NULL, NULL, '3168692626', '3168692626', '76323909-2', 'CALLE 1N No 8-83 ', 'NO REFIERE', 1, 4),
(1284, 2, 'VARIEDADES', 'MARISOL', NULL, NULL, '2248690', '2248690', '31.188.387-5', 'CARRERA 25 No. 27-58', 'NULL', 1, 2),
(1285, 4, 'JAIME DI ', 'CAPOTE  RIVERA', NULL, NULL, '3113368222', '3113368222', '10295580', 'CL 72N#314-71', 'NO REGISTRA', 1, 4),
(1286, 2, 'RAFAEL ANTONIO', 'CRUZ PRIETO', NULL, NULL, '2248393', '2248393', '94365073', 'CARRERA 27 No. 20-04', 'NULL', 1, 2),
(1287, 4, 'PERFIL EMPRESARIAL', 'JOSELITO CRUZ GAITAN', NULL, NULL, '22316831', '22316831', '79246722-3', 'CLL 321 No 20A-35B', 'NO REFIERE', 1, 4),
(1288, 1, 'Andina Electronica', 'S.A.S', NULL, NULL, '4860202', '4680200', '900351892-3', 'Calle 47 Norte No. 4 BN 85', '@', 1, 1),
(1289, 4, 'FERRETERIA MASTER POPAYAN', 'CARLOS JULIO ROSERO', NULL, NULL, 'NO REFIERE', 'NO REFIERE', '10515850-1', 'CRA 4 No 6-21', 'NO REFIERE', 1, 4),
(1290, 4, 'PUNTO ', 'MEDICO', NULL, NULL, '8228376', '8216044', '900343620-3', 'KAR  15 5-66', 'NULL', 1, 4),
(1291, 1, 'Almacén y cristaleria', 'LA 13', NULL, NULL, '8893333', '8842635', '900.212.550.', 'Calle 13 No. 8-52', 'servicioalcliente@almacenesla13.com', 1, 1),
(1292, 3, 'DISTRIBUIDORA AGUA ', 'PUREZA', NULL, NULL, '4430408', '3162702279', '29178034-0', 'CALLE 36 NO 13-32', 'aguapurezacali@hotmail.com', 2, 1),
(1293, 1, 'JUAN CAMILO', 'PALACIOS GUAUÑA', NULL, NULL, '0', '0', '0', '0', '0', 2, 1),
(1294, 2, 'DISTRIBUIDORA', 'SANTANDER', NULL, NULL, '2259805', '2259805', '16360910-1', 'CARRERA 33 34-54', 'NULL', 1, 2),
(1295, 2, 'FERRE', 'HACIENDA', NULL, NULL, '3188542597', '3188542597', '16220506-7', 'CALLE 29 CARRERA 23 ESQUINA', 'NULL', 1, 2),
(1296, 1, 'Felipe ', 'Parra Roldán', NULL, NULL, 'c', 'c', '16.286.514', 'c', 'c', 1, 1),
(1297, 1, 'Banco Agrario', 'de Colombia', NULL, NULL, 'c', 'c', '800.037.800-8', 'c', 'c', 1, 1),
(1298, 1, 'Mister ', 'Kodrin', NULL, NULL, '6682586', 'C', '11', 'AV 3N 24 N 06', 'C', 1, 1),
(1299, 1, 'MA. JIMENA', 'CARDONA V.', NULL, NULL, '6682586', 'C', '31.253.777-2', 'AV 3 AN No. 24N 06', 'C', 1, 1),
(1300, 4, 'KALKOS', 'PAPELERIA DE TODO Y MAS', NULL, NULL, '8388374', '3136109316', '10545193-9', 'NO', 'NO', 1, 4),
(1301, 2, 'LUIS FELIPE', 'APONTE CRUZ', NULL, NULL, '2257787', NULL, '1.112.101.834', 'CALLE 30 No. 27-15', 'lapontecruz@hotmail.com', 1, 2),
(1302, 1, 'Corporación Colombiana de Logistica', 'S.A.', NULL, NULL, '3065588', '4460090', '830060136-0', 'Cra. 34 No. 16-215', '@', 1, 1),
(1303, 2, 'DISTRIBUIDORA', 'MASKEL', NULL, NULL, '3108411059', '3108411059', '961014-07338', 'CALLE 8A No. 22-36', 'NULL', 1, 2),
(1304, 4, 'ALMACEN', 'PATIÑO', NULL, NULL, '3154892572', NULL, '1427971-1', 'CALLE 5 7-50', 'NULL', 1, 4),
(1305, 1, 'Muebles ', 'Pazmiño', NULL, NULL, 'c', 'c', '38.562.484-0', 'c', 'c', 1, 1),
(1306, 1, 'Jonnathan Andres', 'Marquez Valencia', NULL, NULL, '3186799478', '3183890080', '1.130.638.207', 'Calle 70 B No 2 B 28 B/ LA RIVERA', 'jhonatanmarquezgmail.com', 1, 1),
(1307, 1, 'EPSA', 'EMPRESA DE ENERGIA DEL PACÍFICO S.A. E.S.P', NULL, NULL, 'C', 'C', '800.249.860-1', 'C', 'C', 1, 1),
(1308, 4, 'DROGUERIA CONTINENTAL', 'NO', NULL, NULL, '8202038', 'NO', '105296545', 'CR 6#4N-26', 'NO', 1, 4),
(1309, 4, 'COMERCIALIZADORA', ' AGROQUIMICA DEL CAUCA', NULL, NULL, '8237932', '8237932', '384389010', 'CR 6 5N-83', 'NO', 1, 4),
(1310, 1, 'Secretaria de Hacienda', NULL, NULL, NULL, 'c', 'c', '88', 'c', 'c', 1, 1),
(1311, 3, 'CARLOS ANDRES ', 'SANCLEMENTE', NULL, NULL, '3127580186', 'NO REFIERE', '94328126', 'CARA 28 24-47', 'NO REFIERE', 1, 3),
(1312, 4, 'COMERCIALIZADORA', 'ANDINA S.A.S', NULL, NULL, '8203995', 'NO', '900167610-5', 'KRA 6 1N-65', 'NULL', 1, 4),
(1313, 1, 'COMERCIALIZADORA E IMPORTADORA', 'EL CARPINTERO', NULL, NULL, '8830672', NULL, '9006214793', 'CRA 11 # 16-69', 'NULL', 1, 1),
(1314, 2, 'JOSE LUIS', 'PEÑA SANTA', NULL, NULL, '3163490056', '3163490056', '1.116.257.027', 'CARRERA 39A No. 13-20', 'NULL', 1, 2),
(1315, 4, 'OXIMEDICA ', 'POPAYAN ', NULL, NULL, '8221132', '3206947545', '900416581-9', 'KRA 6 7N 45', 'NULL', 1, 4),
(1316, 4, 'GABI', 'EQUIPOS MEDICOS', NULL, NULL, '3124809280', '3124809280', '669109023', 'CR 44#5A-77', 'INFO@GABIEQUIPOS.COM', 1, 4),
(1317, 4, 'JUAN DIEGO ', 'ARTUNDUAGA ', NULL, NULL, '8396424', '8396424', '1061768565', 'CALLE  7  4-33', 'NULL', 1, 4),
(1318, 3, 'YOLANDA ', 'DIAZ CHACON', NULL, NULL, '2862363', '3154579022', '31.164.462', 'CALLE 37 NO 9-13 2 PSISO', 'NO REFIERE', 1, 3),
(1319, 4, 'DIEGO ', 'LLAVES', NULL, NULL, '3103591944', '3176707015', '34328687-2', 'CC FERROCARRIL', 'NULL', 1, 4),
(1320, 4, 'OSCAR', 'ORTIZ', NULL, NULL, '1', '1', '1', '1', '1', 1, 4),
(1321, 4, 'LUIS GABRIEL ', 'CHICA PIENDANOTAS ', NULL, NULL, '3105061040', NULL, '10304240', 'PIENDAMO ', 'NULL', 1, 4),
(1322, 2, 'ALMACEN', 'EL GANADERO', NULL, NULL, '2244525', '2244525', '821000286-8', 'CARRERA 23 No. 28-61', 'NULL', 1, 2),
(1323, 1, 'SEGURIDAD INDUSTRIAL', 's', NULL, NULL, '4324390', '3174181040', '29202363', 'CARRERA 1 No. 70A-72', 'secuindustrialcali@yahoo.com', 1, 1),
(1324, 4, 'BERNARDO ', 'ROBLES', NULL, NULL, '3116741659', NULL, '1061743006', 'LA AURORA ', 'NULL', 1, 4),
(1325, 3, 'MILLARÉ', 'DIAZ LOPEZ ', NULL, NULL, NULL, '3128670411', '29686920', 'CALLE 30 NO 40-37 ', NULL, 2, 3),
(1326, 2, 'BERTHA LUCIA', 'SANTANA', NULL, NULL, '3173198517', '3173198517', '29.310.582', 'BUGALAGRANDE', 'NULL', 1, 6),
(1327, 4, 'FABIO ANDRES', 'GONZALEZ', NULL, NULL, '123', '123', '4.611.787', 'pop', 'n', 1, 4),
(1328, 3, 'IRINA ANDREA', 'SAAVEDRA', NULL, NULL, 'NO REFIERE', '3178957010', '1113657235', 'CALLE 30A NO 40A-10 RIVERA ESCOBAR', 'andrea7592@hotmail.com', 1, 3),
(1329, 2, 'CLARO - TELMEX', 'COLOMBIA', NULL, NULL, '18000180456', '18000180456', '830.053.800-4', 'TULUA', 'NULL', 1, 2),
(1330, 2, 'NOTARIA', 'TERCERA', NULL, NULL, '2258774', NULL, '16.250.685-5', 'CALLE 29 No. 24-10', 'NULL', 1, 2),
(1331, 1, 'Grupo Corporativo', 'Futuro Emopresarial', NULL, NULL, '3816025', '3155067870', '900504844-8', 'Av 5 Norte No 23 BN 23', 'GCFUTUROEMPRESARIAL@GMAIL.COM', 1, 1),
(1332, 2, 'LEONARDO', 'SEPULVEDA', NULL, NULL, '3185070449', NULL, '16.356.266', 'TRANSVERSAL 12 No. 14 A 76', 'NULL', 1, 2),
(1333, 4, 'BEATRIZ', 'CORREA', NULL, NULL, '8364653', 'NO', '1061690414-8', 'KRA 3 8-88', 'NULL', 1, 4),
(1334, 2, 'DISTRIBUIDORA', 'EL TULUAZO', NULL, NULL, '2320236', '2320236', '14590137-1', 'TULUA', 'NULL', 1, 2),
(1335, 1, 'TECNI', 'AIRES ACONDICIONADO', NULL, NULL, '4262621', '3128636022 - 3164211', '94.295.707-6', 'Calle 72 I No. 28 F 17B./ POBLADO', '@', 1, 1),
(1336, 2, 'JOSE JULIAN', 'PALACIOS GAÑAN', NULL, NULL, '2257787', '2257787', '1130624192', 'CARRERA 23 No. 32-41', 'NULL', 1, 2),
(1337, 4, 'EMISORA INDIGENA ', 'RENACER KOKONUKO', NULL, NULL, '3136622110', '3136622110', '76319421-5', 'VERDA SAN BARTOLO', 'N', 1, 4),
(1338, 1, 'Francia ', 'Victoria Surata', NULL, NULL, 'NO TIENE', '3207279675', '66.981.778', 'Calle 13 No 50 -133', 'franciasurata@hotmail.com', 1, 1),
(1339, 1, 'Distribuidora y comercializadora', 'TATOS', NULL, NULL, '8804563', '1', '70.828.443-9', 'Carrera 8 No. 13-81 LC 137', 'TATOS@EMCALI.NET.CO', 1, 1),
(1340, 1, 'Soportes ', 'T.V.', NULL, NULL, '6841291', 'C', '14624744-0', 'cL 52 Norte No. 4N 98', 'arturokhs@hotmail.com', 1, 1),
(1341, 3, 'PANADERÍA Y CAFETERIA', 'TAMANACO', NULL, NULL, '2722957', NULL, '31.153.161-7', 'CALLE 30 NO 25-07', NULL, 2, 3),
(1342, 1, 'Jose Otoniel ', 'Mayorga Hoyos', NULL, NULL, 'c', 'c', '16.754.098', 'c', 'c', 1, 1),
(1343, 1, 'Refrigeracion ', 'San Nicolas', NULL, NULL, '8881448', '8881477', '805.018.722-9', 'carrera 5 No. 21 - 94', 'refrigeracionsannicolas@hotmail.com', 1, 1),
(1344, 4, 'papeleria ', 'centrala', NULL, NULL, '8205742', '8206506', '122761229', 'cr 17 12-101', 'n', 1, 4),
(1345, 1, 'CESAR AUGUSTO', 'PIEDRAHITA AMPUDIA', NULL, NULL, '3801119', '3008606003', '14624306', 'CALLE 12 #32-25', 'cesar07co@hotmailc.om', 1, 1),
(1346, 3, 'RH S.A.S', 'S.A.S', NULL, NULL, '6665122-6665121', '6665123', '805007083-3', 'CRA 24 NO 13-387', 'WWW.RHSAS.COM.CO', 2, 1),
(1347, 4, 'FATIMA ', 'PRADO', NULL, NULL, '30745304046', NULL, '25280677', 'KRA 9 A 54 N 39', 'NULL', 1, 4),
(1348, 1, 'Orfilio ', 'Naranjo', NULL, NULL, '1', '1', '11', '1', '1', 1, 1),
(1349, 1, 'Encofrado ', 'BONILLA', NULL, NULL, 'Z', 'Z', 'Z', 'Z', 'Z', 1, 1),
(1350, 3, 'LITOGRAFIA', 'LITOCAMARA', NULL, NULL, '2758585', 'NO REFIERE', '802.062.270-1', 'CRA 29 27-30 ', 'NO REFEIRE', 1, 3),
(1351, 2, 'GRACIELA', 'PALACIOS LOZANO', NULL, NULL, '2248883', '2248883', '31.199.815', 'CARRERA 26 No. 23-41', 'NULL', 1, 2),
(1352, 2, 'SANDRA CAROLINA', 'AGUIRRE BERMUDEZ', NULL, NULL, '3178573316', '3178573316', '1.116.238.066', 'CARRERA 22 A No. 14-57', 'PUPILA07@HOTMAIL.COM', 1, 2),
(1353, 4, 'ASERHI', 'SAS', NULL, NULL, '8223477', '3148908132', '830502145-5', 'CR 2#8-13', 'NO', 1, 4),
(1354, 3, 'FERNANDO ', 'TABARES SANCHEZ ', NULL, NULL, '2759115', 'NO REFIERE', '16278564-4', 'CRA 36 25C 16', 'NO REFIERE', 1, 3),
(1355, 1, 'MARILYN', 'GONZALEZ BERNAL', NULL, NULL, '3206664644', NULL, '67038808-2', NULL, NULL, 1, 1),
(1356, 1, 'MARILYN', 'GONZALEZ BERNAL', NULL, NULL, NULL, NULL, '670388082', NULL, NULL, 1, 1),
(1357, 2, 'BOLSAS Y DESECHABLES', 'LA 21', NULL, NULL, '2247119', '3163731816', '1112129028-9', 'CRA 21  27-10', 'NO REGISTRA', 1, 2),
(1358, 1, 'HEBERT', 'MOTATO', NULL, NULL, '0', '0', '0', '0', '0', 1, 1),
(1359, 4, 'OSCAR', 'DIAZ', NULL, NULL, '31526548', NULL, '1085310992', 'KRA 2 56-36', 'NULL', 1, 4),
(1360, 4, 'ISABEL ', 'CUARAN ', NULL, NULL, '3217644059', NULL, '34.331.826', 'CALLE 50N 26-54', 'NULL', 1, 4),
(1361, 2, 'ELECTRONICAS', 'HAROLD', NULL, NULL, '2246643', '2246643', '16.362.431.2', 'CALLE 28 No. 24-39', 'NULL', 1, 2),
(1362, 1, 'SUSANA ', 'BADIEL ', NULL, NULL, '0', '0', '0', '0', '0', 1, 1),
(1363, 3, 'KARLEEN VIVIANA ', 'ROJAS BERNAL ', NULL, NULL, '2745324', '3178709153', '111362923', 'CALLE 57B NO 34-B13', 'NO REFIERE', 1, 3),
(1364, 2, 'TECNOLOGIA Y', 'SERVICIO', NULL, NULL, '3128126101', '3128126101', '94.366.740-5', 'CARRERA 23 No. 24-26', 'NULL', 1, 2),
(1365, 3, 'CLAUDIA VERONICA', 'ORTEGA LEGUIZAMO ', NULL, NULL, 'NO REFIERE ', '3178311290', '29682485', 'CALLE 69D NO 25-30 ', 'NO REFIERE ', 1, 3),
(1366, 1, 'Daniel octavio', 'rosero gaviria', NULL, NULL, '4883611', '3188596569', '16607021', 'CR 47B No. 40-37 2 piso apt, 202', 'danirex7@yahoo.es', 1, 1),
(1367, 4, 'JOSE LUIS', 'BURBANO', NULL, NULL, '201', '301', ' 1.061700.178 ', 'POPAYAN', 'N', 1, 4),
(1368, 4, 'JAMES ', 'ERAZO', NULL, NULL, '21', '12', ' 1.085.925.937', 'POPAYAN', 'NO', 1, 4),
(1369, 1, 'German Eduardo', 'Lopez Garcia', NULL, NULL, '3157083745', '3157083745', '1144067015', 'CLL 100 B No. 23-94', 'germani9312@hotmail.com', 1, 1),
(1370, 1, 'MARILYN', 'GONZALES BERNAL', NULL, NULL, '3952947', '3206664644', '67038808', 'CR 83 No. 45-56', 'loscoloresdemitierra@hotmail.com', 1, 1),
(1371, 2, 'IVAN ALEXANDER ', 'VELASQUEZ MARIN', NULL, NULL, '2326953', '3162730123', '16367014', 'CLL 21 NO 28A-88', 'IVANVELMA@GMAIL.COM', 1, 2),
(1372, 4, 'JAIRO ', 'VASQUEZ', NULL, NULL, '3152856369', NULL, '.4’640.847', 'POPAYAN', 'jairoalbertov12@hotmail.com', 1, 4),
(1373, 1, 'Hierro', 'HB', NULL, NULL, '4431223', NULL, '8001211998', 'CL 34 5A13 PORVENIR', 'NULL', 1, 1),
(1374, 2, 'FERRETERIA', 'TORNICENTRO', NULL, NULL, '2241383', '2241383', '16.618.702-4', 'CALLE 24 No. 31-07', 'NULL', 1, 2),
(1375, 4, 'distribuciones ', ' damasco', NULL, NULL, '8317144', 'n', '90009175-4', 'cr 7 6-61', 'n', 1, 4),
(1376, 1, 'PO PRODUC', 'OFFICE', NULL, NULL, '8824714', NULL, '11111111', 'CL 17 No. 8-18', 'VENTAS@PRODUOFFICE.COM', 1, 1),
(1377, 1, 'ACUAPARQUE', 'DE LA CAÑA', NULL, NULL, '4384812', '4384820', '8903163445', 'CRA 8 39 01', 'NULL', 1, 1),
(1378, 1, 'ALVARO ANDRES', 'HURTADO GOMEZ', NULL, NULL, '3015070714', '3015070714', '10494597', 'cr 53 a No. 7-48', 'alvaroandres_25@hotmail.com', 1, 1),
(1379, 1, 'CAJA DE COMPENSACION FAMILIAR DEL VALLE DEL CAUCA', 'COMFANDI', NULL, NULL, '3340000', 'NA', '8903032085', 'CRA 23 26B 46', 'atencioncliente@comfandi.com.co', 1, 1),
(1380, 1, 'FABIO ', 'RAMIREZ CARDONA', NULL, NULL, '3163887188', '3163887188', '16731082', 'CL 3A No. 92-92', 'framirez2218@gmail.com', 1, 1),
(1381, 4, 'LUISA NATALIA', 'VACA MOSQUERA', NULL, NULL, '3043617990', '3043617990', '1061729231', 'POPAYAN', 'N', 1, 4),
(1382, 4, 'PAULA', 'ZAPATA', NULL, NULL, 'N', 'N', '1212', 'POPAYAN', 'N', 2, 4),
(1383, 2, 'HERIBERTO', 'GARCIA GOMEZ', NULL, NULL, '3104938482', '3104938482', '16.662.825', 'CRA 3 DN 71 F 39', 'NULL', 1, 1),
(1384, 1, 'EDIWN ', 'BOLAÑOS PORTILLA', NULL, NULL, 'N/A', 'N/A', '1113521223', 'N/A', 'N/A', 1, 1),
(1385, 1, 'Compañia de gases del Pacifico', 'S.A.S', NULL, NULL, '4436140', '3136619408', '900.200.888-6', 'Cra. 17 G No. 25-66', 'cgpgases@hotmail.com', 1, 1),
(1386, 1, 'VIDRIOS', 'JC', NULL, NULL, '4411416', '4486493', '20435857-3', 'CALLE 35 No. 4C - 13', 'N/A', 1, 1),
(1387, 4, 'SUPER', 'DROGAS', NULL, NULL, '8381616', '8381616', '34535051-6', 'CALLE 5 22 A39', 'NULL', 1, 4),
(1388, 2, 'CRUZ ROJA', 'COLOMBIANA', NULL, NULL, '2261772', '2261772', '111111', 'CRA 34 # 25-26', 'NULL', 1, 2),
(1389, 1, 'Edwin', 'Bolaños Portilla', NULL, NULL, 'c', 'c', '1113521223', 'c', 'c', 1, 1),
(1390, 3, 'GUSTAVO ANTONIO', 'ZULETA FRANCO', NULL, NULL, '3105050857', 'NO REFIERE', '14.964.707', 'CALLE 13B 37-86', 'NO REFIERE ', 1, 3),
(1391, 2, 'JAIME', 'TORO', NULL, NULL, '2247814', '2247814', '16.603.668', 'CARRERA 30. No. 36-53', 'NULL', 1, 2),
(1392, 4, 'LUIS FERNANDO ', 'FERNANDEZ DORADO', NULL, NULL, '318 392 6849', '318 392 6849', 'FERNANDEZ DORADO', 'popayan', 'n', 1, 4),
(1393, 3, 'JAIRO ', 'QUINTERO MONSALVE ', NULL, NULL, '3155238691', 'NO REFIERE ', '16244357', 'CARA 32 NO 33-39', 'NO REFIERE ', 1, 3),
(1394, 1, 'Bladimir ', 'Becerra', NULL, NULL, '3270855', '3154717824', '16.765.358', 'carrera 45 No. 37-05', '@', 1, 1),
(1395, 3, 'HECTOR FABIO', 'MONTOYA', NULL, NULL, '2830169', '3173762885', '94274606', 'CARA 27 NO 41-30', 'NO REFIERE ', 1, 3),
(1396, 2, 'LA COMARCA', 'TULUA', NULL, NULL, '2244575', '2244575', '10226210-8', 'CARRERA 23 No. 29-41', 'NULL', 1, 2),
(1397, 3, 'MARIA ESNEDA ', 'AMEZQUITA', NULL, NULL, '2738410', '3168518142', '66775282', 'CRA 27 NO 22-11 MONTECLARO ', 'NO REFIER E', 1, 3),
(1398, 1, 'CENTRAL DE RESPUESTOS', 'Y SERVICIOS', NULL, NULL, '6649879', '6651977', '16627263', 'CLL 44N No. 2E - 59', 'n/a', 1, 1),
(1399, 1, 'FRANCY', 'MENESES', NULL, NULL, '4393178', '3122953432', '66988234', 'CR 1a  No. 56-94', 'franirme@hotmail.com', 1, 1),
(1400, 1, 'ALBA LUCIA', 'BELTRAN RIOS', NULL, NULL, '3352691', '3108944811', '66988066', 'CL 19 No. 27 -13', 'medipets2011@yahoo.com', 1, 1),
(1401, 2, 'JUAN CARLOS', 'FRANCO CALDERON', NULL, NULL, '3012600681', '3167291505', '94.357.489', 'CARRERA 27 C No. 40 D 26', 'NULL', 1, 5),
(1402, 1, 'Hector Fabio', 'Ortiz Sanchez', NULL, NULL, '3136882883', '3136882883', '94481355', 'CL 2da A  No . 5-27', 'hectorfos@hotmail.com', 1, 1),
(1403, 2, 'RICARDO', 'BALLESTEROS CARRAJA', NULL, NULL, '3188784090', '3188784090', '14899299', 'CALLE 18 No. 7-46', 'RIBALL201@HOTMAIL.COM', 1, 2),
(1404, 3, 'MAYRA ALEJANDRA', 'TORO GONZALEZ', NULL, NULL, 'NO REFIERE', '3153878732', '1113643792', 'DIAG 25 NO 6-A40', 'MAIRITACHIKI@GMAIL.COM', 1, 3),
(1405, 1, 'Mondelez', 'Internacional', NULL, NULL, '4460090', '4460090', '8903006569', 'N/A', 'N/A', 1, 1),
(1406, 4, 'FABIO ENRIQUE', 'PARRA', NULL, NULL, '8240573', NULL, '16239050', 'CALLE 5 4-87', 'NULL', 1, 4),
(1407, 3, 'DISTRIBUIDORA PINTURAS ', 'Y MEZCLAS', NULL, NULL, '2718334-2864267', '2732694', '900.128.108-2', 'CALLE 28 NO 27-54', 'NO REFIERE', 2, 3),
(1408, 4, 'CESAR JULIAN ', 'HERNANDEZ LOPEZ', NULL, NULL, '3182332426', '3182332426', '10298308', 'CLL 13 No 12-06', 'CJHDEZ20@GMAIL.COM', 1, 4),
(1409, 2, 'WALTER ', 'CAICEDO', NULL, NULL, '3146226600', '3146226600', '94.444.007', 'TULUA', 'NULL', 1, 2),
(1410, 4, 'JOSE ', 'COTAZO', NULL, NULL, '3147234190', NULL, '4611187', 'VEREDA CALIBIO ', 'NULL', 1, 4),
(1411, 1, 'Flor Angela', 'Calderon Ospina', NULL, NULL, '3739594', '3017508162', '31221981', 'CR 16 No. 9 -54 San bosco', 'floranco@yahoo.com', 1, 1),
(1412, 4, 'ULIAN ANDRES', 'COQUE ALEGRIA', NULL, NULL, '0', '0', '1061724944', 'popayan', '0', 1, 4),
(1413, 4, 'JULIAN ANDRES', 'COQUE ALEGRIA', NULL, NULL, '0', '0', '1061724944', 'POPAYAN', 'N', 1, 4),
(1414, 2, 'VIVIANA', 'OSORIO CEDEÑO', NULL, NULL, '3154420747', '3154420747', '66.713.313', 'CALLE 24 No. 14-39', 'voc713@hotmail.com', 1, 2),
(1415, 1, 'CASA', 'DENTAL', NULL, NULL, '6671845', '3183489498', '890300417-4', 'CALLE 23AN No. 5AN 30', 'casadental.gv@casadentalltda', 1, 1),
(1416, 1, 'ANA MARIA', 'CAVIEDES', NULL, NULL, '3153461103', '3153461103', '31975637', 'CR 30 8A 17', 'amcr.docencia@gmail.com', 1, 1),
(1417, 4, 'MONICA', 'DURAN', NULL, NULL, '8221132', '1', '25247891', 'POPAYAN', 'N', 1, 4),
(1418, 2, 'CARLOS ', 'GONZALEZ', NULL, NULL, '2248883', '2248883', '16.346.198', 'CARRERA 26 No. 23-31', 'NULL', 1, 2),
(1419, 1, 'ILUMINACION Y ', 'METALELECTRICA', NULL, NULL, '8803686', '3043825363', '900318577-9', 'CR 6 No.16-14', 'iluminacionymetaelectrica@hotmail.com', 1, 1),
(1420, 1, 'MULTIREDES Y ', 'TECNOLOGIA', NULL, NULL, '4850118', '4850118', '66975081-0', 'AV 5N 23DN-68', 'N/A', 1, 1),
(1421, 2, 'LUCIO EDINSON', 'JARAMILLO COLLAZOS', NULL, NULL, '3175746319', '3175746319', '94.153.229', 'CALLE 19 No. 15 B 03', 'lucioe28@gmail.com', 1, 2),
(1422, 3, 'JAMES ', 'ZUÑIGA ', NULL, NULL, 'NO REFIERE', '3136188493', '94321335', 'NO REFIERE ', 'NO REFIERE ', 1, 3),
(1423, 2, 'SUPER OFERTAS', 'BARATISIMO', NULL, NULL, '0', '0', '29.219.136-0', 'CALLE 2 No. 4-19', 'NULL', 1, 2),
(1424, 1, 'Leady Joana', 'Riascos Valencia', NULL, NULL, '4479267', '3137079687', '1.130.594.612', 'Carrera 4 b bis 76- 77 Santa Barbara', 'leadyso@yahoo.es', 1, 1),
(1425, 2, 'KANINA', 'TIENDA VETERINARIA', NULL, NULL, '2254728', '3154715425', '1.112.098.203-7', 'CARRERA 26 No. 33-50', 'NULL', 1, 2),
(1426, 2, 'LUZ ANGELA ', 'PALACIOS GAÑAN', NULL, NULL, '2257787', '2257787', '38.559.682', 'CARRERA 23 No. 32-41', 'NULL', 1, 2),
(1427, 2, 'JOSE OLIVERIO', 'PALACIOS', NULL, NULL, '2257787', 'NA', '16.351.010', 'CARRERA 23 No. 32-41', 'NULL', 1, 2),
(1428, 1, 'Target ', 'S.A.S', NULL, NULL, '6530081', '4879020', '900.406.687.8', 'Av. ESTACION No. 5N - 70 C.C. PASARELA', '@', 1, 1),
(1429, 3, 'MARMOLRES Y PIEDRAS', 'DEL VALLE', NULL, NULL, 'NO REFIERE', '3103886894', '6.501.831-6', 'CRA 28 NO 44-86', 'NO REFEIRE', 2, 3),
(1430, 2, 'MARIA RUBIELA', 'ARROYAVE CARDONA', NULL, NULL, '0', 'NA', '66.700.366', 'ZARZAL', 'NULL', 1, 7),
(1431, 4, 'VIDRIOS', 'EL SOL', NULL, NULL, '8211318', '8211318', '8000837789', 'CL 4 12-52', 'NO', 1, 4),
(1432, 1, 'MISCELANEA', 'REMODELAR', NULL, NULL, '6842378', '6842378', '11306689305', 'CLL 44 No. 6n 61', 'n/a', 1, 1),
(1433, 1, 'Maria Angelica', 'Rodriguez', NULL, NULL, '4476770', '3127249453', '1053767229', 'Cr 1e No. 59 -172', 'angelicanton@hotmail.com', 1, 1),
(1434, 2, 'EDGAR', 'GARCIA HENAO', NULL, NULL, '..', '...', '14.802.366', '...', 'NULL', 1, 2),
(1435, 2, 'MULTIREDES Y ', 'TECNOLOGIA', NULL, NULL, '2253310', '2253310', '66.975.081-0', 'CENTR COMERCIAL DEL RIO LOCAL 10', 'NULL', 1, 2),
(1436, 2, 'FUMIPLAGAS Y ', 'SANIAMIENTO', NULL, NULL, '2257023', '.....', '16.363.870-7', 'CLL 23 NO 26-02', '......', 1, 2),
(1437, 1, 'CASA', 'WHIRPOOL', NULL, NULL, '6606805', '6606805', '804097149', 'N/A', 'N/A', 1, 1),
(1438, 4, 'NESTOR ESTEBAN', 'PAME CATAMUSCAY', NULL, NULL, '8221132', '8221132', '1061725601', 'POPAYAN', 'N', 1, 4),
(1439, 2, 'MARIA ANAPAOLA', 'DELGADO', NULL, NULL, '3177856454', '3177856454', '21.824.401', 'CARRERA 36 No. 24 A 19', 'anapaod2004@hotmail.com', 1, 2),
(1440, 1, 'Yury', 'Rodriguez Dulcey', NULL, NULL, 'n/a', 'n/a', '29346724', 'n/a', 'n/a', 1, 1),
(1441, 1, 'Paula Andrea', 'Muriel', NULL, NULL, 'n/a', 'n/a', '38670608', 'n/a', 'n/a', 1, 1),
(1442, 3, 'CHRISTIAN ANDRES', 'JIMENEZ HURTADO ', NULL, NULL, '3186815878', 'NO REFIERE ', '1113618711', 'CRA 24 SUR 10-66', 'NO REFIERE', 1, 3),
(1443, 1, ' P y M', 'Machimbres', NULL, NULL, '888 1578', '3157148803', '111444111', 'Cra 8 No. 16 95', 'N/A', 1, 1),
(1444, 1, 'Luz Elena', 'Ariza Bolivar', NULL, NULL, '3178311769', '3178311769', '31984313', 'N/A', 'leari1@hotmail.com', 1, 1),
(1445, 1, 'Ivan Antonio', 'Tuzarma', NULL, NULL, 'n/a', 'n/a', '94260201', 'n/a', 'n/a', 1, 1),
(1446, 2, 'ADRIANA', 'ESCOBAR ALARCON', NULL, NULL, '3152055265', '3152055265', '31791903', 'CARRERA 35 No. 41-42', 'adriana.bolita@hotmail.com', 1, 2),
(1447, 2, 'FRANCISCO DAVID', 'ORTEGA', NULL, NULL, '2254561', '3137652638', '87.572.114', 'CALLE 43 No. 33-03', 'david.070@hotmail.com', 1, 2),
(1448, 2, 'DEPOSITO', 'DENTAL', NULL, NULL, '2255699', '2255699', '38.793.946-2', 'CARRERA 25 No. 30-70', 'NULL', 1, 2),
(1449, 4, 'JOEL ', 'DUQUE HOYOS', NULL, NULL, '8397127', 'N', '14989056', 'CR 6#5-62', 'N', 1, 4),
(1450, 3, 'GRAFICAS VILLA DE ', 'LAS PALMAS ', NULL, NULL, '2814076', 'NO REFIERE', '66.769.138-9', 'CRA 24 NO 30-74', 'GRAFICASVILLADELASPALMAS@HOTMAIL.COM', 2, 3),
(1451, 2, 'ANDRES FELIPE', 'GUZMAN ORTIZ', NULL, NULL, '2249940', '3183934313 - 3044900', '94.390.461', 'CARRERA 33 No. 21-46', 'afgo525@hotmail.com', 1, 2),
(1452, 2, 'FERNANDO ', 'TOBON', NULL, NULL, '2249102', '....', '....', 'SAJONIA', 'ftobonmol@hotmail.com', 1, 2),
(1453, 2, 'ALMACEN', 'TODO', NULL, NULL, '2242680', '2242680', '31197727-4', 'TULUA', 'NULL', 1, 2),
(1454, 1, 'USA', 'Appliances y Kitchens', NULL, NULL, '1122111', '1122111', '111445511', 'N/A', 'N/A', 1, 1),
(1455, 4, 'OLGA LUCIA', 'CERON', NULL, NULL, '8380933', NULL, '25274297', 'CR 40#1-65', 'N', 1, 4),
(1456, 4, 'MAGDA LISETH ', 'MENESES LOPEZ', NULL, NULL, '3217210503', NULL, '3123840634', 'KILOMETRO  7 VIA POPAYAN CALI', 'MAGDALIM29@HOTMAIL.COM', 1, 4),
(1457, 4, 'OSCAR', 'LOPEZ', NULL, NULL, '3147929842', '3147929842', '3152803220', 'POPAYAN', 'N', 1, 4),
(1458, 1, 'BASCULAS Y ', 'BALANZAS', NULL, NULL, '4101404', '4101458', '16795988', 'CALLE 33A NO. 8A 02', 'gerencia@jcmbasculas.com', 1, 1),
(1459, 4, 'WILLIAM', 'PALACIOS', NULL, NULL, '3105967528', NULL, '1061791235', 'CALLE 66  12-62', 'NULL', 1, 4),
(1460, 4, 'COMFACAUCA', 'COMFACAUCA', NULL, NULL, 'NO REFIERE', 'NO REFIERE', '891.500.182-0', 'NO REFIERE', 'NULL', 1, 4),
(1461, 1, 'LA OFERTA', 'ELECTRICA', NULL, NULL, '8854636', NULL, '900095617-6', 'CRA 6 # 17-68', NULL, 1, 1),
(1462, 4, 'LIZETH ANDREA', 'HIDALGO SANDOVAL', NULL, NULL, '3182865449', '3182865449', '1061739359', 'CR 20#8C-26', 'NO', 1, 4),
(1463, 2, 'JQB', 'COMPUTER', NULL, NULL, '3174390423', '3174390423', '91.243.511-6', 'TULUA', 'NULL', 1, 2),
(1464, 1, 'NORA MILENA', 'PUENTES GOMEZ', NULL, NULL, '3213662298', '3213662298', '66830547', 'CR 12 E No. 50 - 18', 'juancho_1405@hotmail.com', 1, 1),
(1465, 2, 'BETTI ROCIO', 'BETTI ROCIO', NULL, NULL, '3136467679', '3136467679', '29.757.815', 'CARRERA 12 No. 4-20', 'NULL', 1, 8),
(1466, 1, 'MUNDIAL ', 'DE ELECTRICOS', NULL, NULL, '3825403', NULL, '900540536-1', 'CRA 6 # 18-01', NULL, 1, 1),
(1467, 2, 'CARLOS ANDRES', 'PARRA GALEANO', NULL, NULL, '3184042361', '3184042361', '1.113.037.640', 'CARRERA 2 A No. 12-39', 'parra1128@hotmail.com', 1, 6),
(1468, 3, 'MEGASTORE ', 'TIENDA TECNOLOGICA SAS', NULL, NULL, 'NO REFIERE ', 'NO REFIERE ', '900.644.695-7', 'CALLE 30 23-62', 'NULL', 1, 3),
(1469, 2, 'MUNDO ', 'REPUESTO', NULL, NULL, '3184219560', '3184219560', '1116246647', 'CARRERA 21 No. 27-32', 'NULL', 1, 2),
(1470, 2, 'DROGUERIA', 'ETICA', NULL, NULL, '2243829', '2254425', '94391571-2', 'CALLE 27A No. 22-71', 'NULL', 1, 2),
(1471, 4, 'NESTOR', 'LEAL', NULL, NULL, '3104098770', '3104098770', '1061741112', 'MANZANA 2#2-02', 'N', 1, 4),
(1472, 4, 'IVON DANITZA', 'ARAGON DUQUE ', NULL, NULL, '311457895', '311457895', '34331146', 'POPAYAN', 'N', 1, 4),
(1473, 4, 'MARTHA LILIANA', 'JIMENEZ MUÑOZ', NULL, NULL, '3158755415', '3158755415', '25281364', 'POPAYAN', 'N', 1, 4),
(1474, 4, 'CATALINA ', 'FAJARDO', NULL, NULL, '3004448875', '3004448875', '1.061.716.558', 'CR 2C#1N-08', 'N', 1, 4),
(1475, 1, 'CLAUDIA PATRICIA', 'SANTACRUZ', NULL, NULL, '44488844', '4488444', '111444555', 'N/A', 'N/A', 1, 1),
(1476, 1, 'UNI', 'ELECTRONIC', NULL, NULL, '3968183', NULL, '66978872-3', NULL, NULL, 1, 1),
(1477, 3, 'TECNOLOGIAS ', 'ODONTOLOGICAS ', NULL, NULL, '3105050857', '3173783276', '14.964.707-6', 'CALLE 13B NO 37-86 APTO 402-B BALCONES DE LAS LAJA', 'NO REFIERE', 2, 1),
(1478, 1, 'Go', 'Line', NULL, NULL, '3183335333', '3183335333', '9006566515', 'Cl 36an 3gn 37', 'N/A', 1, 1),
(1479, 2, 'DISTRIBUIDORA', 'OFI ESCOLAR', NULL, NULL, '2242995', '2242995', '16.363.878-5', 'CALLE 26 No. 21-57', 'NULL', 1, 2),
(1480, 4, 'BERNARDO ', 'BARRAGAN', NULL, NULL, '3217006881', NULL, '76308186', 'CONDONIMIO LA RIVERA', 'NO ', 1, 4),
(1481, 1, 'Floristeria', 'Acuarium', NULL, NULL, '5248960', '8855475', '794077192', 'Car 10 No. 10-76', 'N/A', 1, 1),
(1482, 1, 'Drogas ', 'la rebaja', NULL, NULL, '54544848', '541515', '11111155', '11111333', 'n/a', 1, 1),
(1483, 4, 'MAGDA', 'CUELLAR TORRES', NULL, NULL, '8221132', '8', '25.277.540', 'POPAYAN', 'N', 1, 4),
(1484, 4, 'DAMIR', 'ARGOTY', NULL, NULL, '3105146764', 'NO', '76320367', 'CALLE 4 21-117', 'NO', 1, 4),
(1485, 1, 'Harold Johanny', 'Jamaramillo Osorio', NULL, NULL, '314 617 1008', '314 617 1008', '94542480', 'Cr 77 3 d 93', 'haroldhanol2sj0@gmail.com', 1, 1),
(1486, 1, 'Shirley ', 'Giraldo Ortiz', NULL, NULL, '1122333', '1122333', '67021441', 'n/a', 'n/a', 1, 1),
(1487, 1, 'Bellas ', 'Artes', NULL, NULL, '1122511', '112244', '11221144', 'n/a', 'n/a', 1, 1),
(1488, 1, 'CARLOS ALBERTO', 'OREJUELA VELEZ', NULL, NULL, '3152515', '4448884', '16735145', '1N/A', 'N/A', 1, 1),
(1489, 4, 'FAREZ DAVID', 'HOYOS VELASCO', NULL, NULL, '8367112', '3103751663', '4615367', 'CR 11#12 26', 'N', 1, 4),
(1490, 1, 'Gerardo ', 'Pinto', NULL, NULL, 'n/a', '112255744', '11221144', 'n/a', 'n/a', 1, 1),
(1491, 1, 'Julián ', 'Taxis', NULL, NULL, NULL, NULL, '111', NULL, NULL, 1, 1),
(1492, 1, 'DICEL', 'ENERGIA', NULL, NULL, '11122233', '1122233', '8150008969', 'N/A', 'N/A', 1, 1),
(1493, 2, 'SANDRA PATRICIA', 'HERNANDEZ', NULL, NULL, '3155145038', '3155145038', '66.721.567', 'CARERRA 38 No. 28 A 20', 'NULL', 1, 2),
(1494, 1, 'IMPERIO', 'ELECTRICO', NULL, NULL, '8835650', '8835650', '165356281', 'CARRERA 6 NO. 15 54', 'elimperiodelaelectronica@hotmail.com', 1, 1),
(1495, 2, 'LARISSA', 'BARCO OSORIO ', NULL, NULL, '3187181268', NULL, '961014-07338', 'CALLE 8A 22-36', 'NULL', 2, 2),
(1496, 2, 'SANDRA PATRICIA', 'GONZALEZ ', NULL, NULL, '2308502', NULL, '60.369.518', 'CARRERA 8 No. 20-09', 'NULL', 1, 2),
(1497, 2, 'ANDREA', 'TAMAYO', NULL, NULL, '3104939389', NULL, '1.116.241.659', 'MANZANA 8 CASA 43', 'NULL', 1, 2),
(1498, 4, 'ANDERSON ', 'GIRALDO ', NULL, NULL, '3104172151', NULL, '10308841', 'KRA 39 4 -54 ', 'NULL', 1, 4),
(1499, 4, 'VARIEDADES', 'MELISSA', NULL, NULL, '8244805', '8398044', '76.325.471', 'CR 7#6-69', 'N', 1, 4),
(1500, 1, 'CARGADORES Y ', 'APADTADORES ESPECIALES', NULL, NULL, '3847741', '3847741', '1150624609', 'CR 6 nO. 15 42', 'cargadores_especiales@hotmail.com', 1, 1),
(1501, 3, 'CYPERCOM', 'COMPUTADORES', NULL, NULL, '6676875', 'NO REFIERE', '18.389.273-1', 'CENTRO COMERCIAL LA PASARELA', 'NO REFIERE', 2, 1),
(1502, 4, 'ALUMNO CENAL', 'ALUMNO CENAL', NULL, NULL, '0', '0', '0', '0', '0', 1, 4),
(1503, 4, 'WBER YAMID ', 'MARTINEZ MACA', NULL, NULL, '3117636526', '3117636526', '76325073', 'CR 1E#12-95', 'NO', 1, 4),
(1504, 2, 'NIJHON', 'ACCESORIOS', NULL, NULL, '3168830304', '3168830304', '1.112.298.467-2', 'PLENOCENTRO LOCAL 59-60', 'NULL', 1, 2),
(1505, 2, 'MUNDO', 'ASEO', NULL, NULL, '2321583', '2321583', '71.596.516-4', 'CARRERA 18 No. 25-02', 'NULL', 1, 2),
(1506, 1, 'SANDRA FERNANDA', 'RENGIFO BOCANEGRA', NULL, NULL, '3152002309', '3152002309', '38877816', 'CALLE 16 18B 56', 'SAREM0203@HOTMAIL.COM', 1, 1),
(1507, 4, 'TOGAS JEAN ', ' SEBASTIAN', NULL, NULL, '3367762', '3367762', '31882934-0', 'CALI', 'N', 1, 4),
(1508, 1, 'NOTARIA', 'NOVENA CALI', NULL, NULL, '8844273', NULL, '31273138', 'CARRERA 5 # 12-80', 'NULL', 1, 1),
(1509, 1, 'Wilson ', 'Gonzalez Gomez', NULL, NULL, 'c', 'c', '16.772.966', 'c', 'c', 1, 1),
(1510, 2, 'PAN ', 'DE ORO', NULL, NULL, '2342266', '2342266', '38.795.301-1', 'CALLE 27 No. 33-43', 'NULL', 1, 2),
(1511, 2, 'ALUMNO', 'CENAL', NULL, NULL, '2257787', 'NA', 'NA', 'NA', 'NA', 1, 2),
(1513, 4, 'CESAR AUGUSTO', 'NOGUERA', NULL, NULL, '8236598', 'NO ', '10532339', 'KRA 39-1-60', 'NULL', 1, 4),
(1514, 4, 'MACRO CENTER', 'MACRO CENTER', NULL, NULL, '382 5360', '317 848 5853 ', ' 94.288.383', 'CALI', 'N', 1, 4),
(1515, 4, 'LUIS FERNANDO ', 'MAZABUEL RODRIGUEZ', NULL, NULL, '8321329', '3006670300', '10298741', 'ºCR 15#8-188', 'N', 1, 4),
(1516, 1, 'HOSPITAL MARIO', 'CORREA RENGIFO', NULL, NULL, '3180020', '3230090', '890399047-8', 'CLL 2OE 78-00', 'hmcore@hospitalmariocorrea.org', 1, 1),
(1517, 1, 'JIMENEZ FONTECHA SAS', 'COMERCIALES VARIAS', NULL, NULL, '6819203', '8892815', '805026578-8', 'CALI', 'dajimenezemcali.net.co', 1, 1),
(1518, 2, 'BATERIAS Y', 'TECNOLOGIA', NULL, NULL, '3152513805', '3152513805', '1.116.257.443-5', 'CARRERA 30 No. 27-20', 'NULL', 1, 2),
(1519, 1, 'HIPER CENTRO CORONA', ' CHIPICHAPE', NULL, NULL, '6603699', '6603699', '860500480-8', 'AV 6A NORTE # 35-40', 'NULL', 1, 1),
(1520, 2, 'GIOVANNA', 'AUDIVERTH GONZALEZ', NULL, NULL, '3172457017', '3172457017', '29.180.923 DE CALI', 'CARRERA 36B No. 14-69 LA VILLA', 'cfps_2010@hotmail.com', 1, 2),
(1521, 2, 'TELARES', 'MEDELLIN', NULL, NULL, '2245862', '2245862', '900.257.204-4', 'CARRERA 25 No. 26-16', 'NULL', 1, 2),
(1522, 4, 'LLAVES', ' LA COLMENA', NULL, NULL, '8217144', '8222500', '52278705', 'CL 4#16-42', 'N', 1, 4),
(1523, 1, 'Angie Cristina', 'Lopez Moeno', NULL, NULL, '3207147030', NULL, '1094917365', 'AV 2b1 No 74 nbis 65', 'angielopezan@outlook .com', 1, 1),
(1524, 4, 'JOHNY ALEJANDRO ', 'CUARAN', NULL, NULL, '3167588652', '3167588652', '94374720', 'POPAYAN', 'NULL', 1, 4),
(1525, 2, 'HAROLD HUMBERTO', 'GONZALEZ DE PAULA', NULL, NULL, '3136653866', '3136653866', '16.366.733', 'URBANIZACION LA PAZ MANZANA D CASA 15', 'NULL', 1, 2),
(1526, 1, 'DICEL', 'DISTRIBUIDORA', NULL, NULL, '3801515', NULL, '815000896-9', 'CALLE 64 N 5B-146', 'NULL', 1, 1),
(1527, 4, 'NIAZIO', 'CARTA', NULL, NULL, '8240459', '8240459', '600036262', 'NO', 'NULL', 1, 4),
(1528, 1, 'AUTOLARTE', 'SA', NULL, NULL, '3148261028', '4449545 Opc. 2 Ext.1', '890900081', 'Cr42 85-05 Autopista Sur Itagüí - Colombia, Medell', 'NULL', 1, 1),
(1529, 3, 'ALKOSTO ', NULL, NULL, NULL, '4073033', NULL, NULL, 'CALI', ' www.alkosto.com/contactenos', 1, 1),
(1530, 1, 'ALVARO', 'SALAZAR ESQUIVEL', NULL, NULL, '0', NULL, '16243229', 'CARRERA 25 A No. 17-07', 'NULL', 1, 1),
(1531, 1, 'JUAN MANUEL', 'ESCOBAR VELASCO', NULL, NULL, '3113428089', '3113428089', '16933345', 'CARRERA 38 NO. 10-139', 'NULL', 1, 1),
(1532, 3, 'PRINTING ', 'SOLUCIONES', NULL, NULL, 'NO REFIERE', NULL, '668324', 'AV 5AN NO 23DN-68  C.C.PASARELA', 'NO REFIERE', 1, 1),
(1533, 4, 'MULTIVIDRIOS Y ALUMINIOS', ' DEL CAUCA', NULL, NULL, '3103919454', '8364044', '76326641-1', 'KRA 14 4-26', 'NULL', 1, 4),
(1534, 1, 'EQUIPOS ELECTRICOS', 'RG DISTRIBUIDORES', NULL, NULL, '6959151', '6903636', '800115720-1', 'CRA 28A No. 16-45', 'www.rgdistribuciones.com', 1, 1),
(1535, 1, 'FRIOMASTER ', 'S.A.S', NULL, NULL, '8802139', '8800688', '805018722-9', 'CRA 5 No. 20-27', 'NULL', 1, 1),
(1536, 1, 'PAOLA ANDREA', 'ROLDAN', NULL, NULL, '0', '0', '0', '0', '0', 1, 1),
(1537, 1, 'DOCUPRINT', 'S.A.S', NULL, NULL, '0', '0', '800194997-1', '0', '0', 1, 1),
(1538, 1, 'MATERIALES ALFONSO LOPEZ', 'JESUS ADAN COPETE', NULL, NULL, '0', '0', '4861263', '0', '0', 1, 1),
(1539, 1, 'MARIA EUGENIA', 'BURITICA DUQUE', NULL, NULL, '6570332', '6570332', '31485914', '0', '0', 1, 1),
(1540, 3, 'FERRETERIA UNIDAS', 'CENTRO', NULL, NULL, '2864056', 'NO REFIERE', '94.326.844-1', 'CARRERA 28 NO 28-26', 'NO REFIERE', 2, 3),
(1541, 1, 'ECOINDUSTRIAL', 'COMERCIALIZADORA', NULL, NULL, '0', '0', '9007263504', '0', '0', 1, 1),
(1542, 1, 'FORMEX', 'S.A.S', NULL, NULL, '0', '0', '811045362-7', '0', '0', 1, 1),
(1543, 4, 'FRANCY ', 'CRIOLLO', NULL, NULL, '8221132', '8', '25277540', 'POPAYAN', 'N', 1, 4),
(1544, 1, 'HONORIO', 'POSSO GARCIA', NULL, NULL, '0', '0', '94226793', '0', '0', 1, 1),
(1545, 2, 'CRISTIAN ANDRES', 'SARMIENTO QUINTERO', NULL, NULL, '3152049990', '3152049990', '1.116.257.541', 'CALLE 12B No. 27 C 25', 'sarmien09@hotmail.com', 1, 2),
(1546, 1, 'ALEXANDER', 'HENAO HERNANDEZ', NULL, NULL, '0', '0', '94296487', '0', '0', 1, 1),
(1547, 2, 'COMERCIALIZADORA', 'JOAGRO', NULL, NULL, '2247204', '2247204', '900522639-7', 'CARRERA 23 No. 28-41', 'NULL', 1, 2),
(1548, 1, 'ELECTRICOS', 'FARALLONES ', NULL, NULL, '8899214', NULL, '9000410961', 'CRA 6 # 18-40', NULL, 1, 1),
(1549, 1, 'ELECTRICOS ', 'ALFREDO Y CIA.LTDA', NULL, NULL, '8821258', '8843843', '805021560-3', 'CRA 10 # 16-01', NULL, 1, 1),
(1550, 1, 'SURAMERICANA', '0', NULL, NULL, '0', '0', '0', '0', '0', 1, 1),
(1551, 1, 'ELECTRONICA', 'SAN NICOLAS', NULL, NULL, '0', '0', '31941520', '0', '0', 1, 1),
(1552, 4, 'SERVICIOS ', 'POSTALES NACIONALES', NULL, NULL, '4722005', '4722005', '900062917-9', 'DIA 25G#95A- 55', 'N', 1, 4),
(1553, 3, 'MARTHA LUCIA', 'CHAVEZ CHAVEZ', NULL, NULL, 'NO REFIERE', '3122294592', '66655506', 'CALLE 4 NO 8-26 EL CARMEN CORREGIMIENTO PLACER', 'marthaluciachavezchavez@gmail.com', 1, 3),
(1554, 2, 'HENRRY DE JESUS', 'BAÑOL', NULL, NULL, '3177918640', '3177918640', '16.358.442', 'OBANDO', 'NULL', 1, 2),
(1555, 2, 'Gustavo Adolfo', 'Cardenas', NULL, NULL, '3185107549', '3185107549', '94.368.667', 'Transvesal 12 n. 7-04', 'NULL', 1, 2),
(1556, 2, 'NATALIA ', 'SANCHEZ PIEDRAHITA', NULL, NULL, '3116332280', '3116332280', '31.430.587', 'CALLE 16A No. 9-38', 'natalia-fp81@hotmail.com', 1, 2),
(1557, 4, 'MARIA EUGENIA', 'MAÑUNGA GOMEZ', NULL, NULL, '3206683305', '3206683305', '1061736516', 'CR 33#16A-18', 'N', 1, 4),
(1558, 2, 'MARIA CELENE', 'BETANCUR', NULL, NULL, '3146586941', '3146586941', '29.463.752', 'Calle 35 n. 31-21', 'NULL', 1, 2),
(1559, 4, 'CESAR ANDRES', 'UZURIAGA', NULL, NULL, 'NO ', 'NO', '41948209', 'NO ', 'NO ', 1, 4),
(1560, 3, 'IMPRESOS ', 'MILLLENIUM', NULL, NULL, 'NO REFIERE', '315215206', '16.258.699-4', 'CALLE 29 NO 30-48 ', 'IMPRESOSMILLENIUM@OUTLOOK.COM', 2, 3),
(1561, 3, 'UNIVERSIDAD', 'NACIONAL', NULL, NULL, 'NO REFIERE', 'NO REFIERE', 'NO REFIERE', 'VIA CANDELARIA', 'NO REFIERE', 1, 3),
(1562, 1, 'VELOTAX', 'COOPERATIVA DE TRANSPORTE', NULL, NULL, '0', '0', '8907001896', '0', '0', 1, 1),
(1563, 3, 'MILTON WELENSHEN', 'BENAVIDES CUAYAL', NULL, NULL, 'NO REFIERE', '3182664561', '1.113.633.884', 'CRA 31 NO. 65A - 08 ZAMORANO', 'mwbc1@hotmail.com', 1, 3),
(1564, 1, 'CALI ', 'DRYWALL SAS', NULL, NULL, '6615000', '3148883880', '900456381-3', NULL, NULL, 1, 1),
(1565, 1, 'NURY ANTONIA ', 'ROSERO ESCOBAR', NULL, NULL, '0', '0', '66.880.822', '0', '0', 1, 1),
(1566, 1, 'GABRIEL ANGEL ', 'MORALES GUAPACHA', NULL, NULL, '0', '0', '15914099', '0', '0', 1, 1),
(1567, 3, 'CENTROTINTAS', 'TECNOLOGIAS', NULL, NULL, '3739910', 'NO REFIERE', '66.845.637-8', 'C.C. PASARELA LOCAL 2-101', 'NO REFIERE', 2, 1),
(1568, 4, 'MELLOS ', 'MELLOS', NULL, NULL, '8227685', '3155272654', '10548147-3', 'CR 13 5A-22', 'N', 1, 4),
(1569, 1, 'CONSIGATODO', 'SAS', NULL, NULL, '3148683956', '-', '900541027-4', 'CLL 30 N # 2BN-42', 'INFO@CONSIGATODO.COM', 1, 1),
(1570, 1, 'ÀNGELA', 'CARDENAS', NULL, NULL, '0', '3104974759', '66769447', '0', '0', 1, 1),
(1571, 3, 'EBM', 'COMPUTADORES LTDA', NULL, NULL, '3955919', 'NO REFIERE', '900.170.381-4', 'C.C. PASARELA LOCAL 2-79', 'NULL', 2, 1),
(1572, 1, 'ANGELA', 'CARDENAS ACOSTA', NULL, NULL, 'NA', '3104974759', '66769447', 'na', 'angelacardens11@hotmail.com', 1, 1),
(1573, 4, 'CARLOS RIGOBERTO ', 'NARVEZ', NULL, NULL, '3127504743', '3127504743', '76327123', 'CR 18A#12-79', 'N', 1, 4),
(1574, 4, 'ARY YESIT', 'AGREDA AGREDO', NULL, NULL, '3007835810', '3007835810', '76322331', 'CL 4#14-13', 'N', 1, 4),
(1575, 2, 'LEIDY JOHANNA', 'ARCILA MONTOYA', NULL, NULL, '3172729434', '3172729434', '1.112.299.853', 'CALLE 23 No. 15-68', 'NULL', 1, 2),
(1576, 1, 'PLANETA', 'ELECTRONIC', NULL, NULL, '8897843', '0', '14639267-4', '0', '0', 1, 1),
(1577, 4, 'BEATRIZ HELENA ', 'GELVEZ', NULL, NULL, '8240359', '3014915469', '1.061.738.867', 'CR 2E#7-61', 'N', 1, 4),
(1578, 2, 'CARLOS JULIO', 'CASTRO LOZANO', NULL, NULL, '3045947538', '3045947538', '1.116.248.719', 'CARRERA 25 No. 13-43', 'NULL', 1, 2),
(1579, 1, 'Viviana', 'García Morales', NULL, NULL, 'na', 'na', '67024737', 'na', 'viviana_garciamorales@hotmail.com', 1, 1),
(1580, 4, 'ALEJANDRA ', 'NARANJO', NULL, NULL, '3113416809', '3113416809', '34.329.197', 'CL 56N 10-86', 'N', 1, 4),
(1581, 1, 'LUZ KARIME', 'SUAREZ PARDO', NULL, NULL, '0', '0', '1130639883', '0', '0', 1, 1),
(1582, 4, 'MAURICIO ', 'JARAMILLO', NULL, NULL, '3164761299', '3164761299', '70095526', 'POPAYAN', 'NO', 1, 4),
(1583, 1, 'ADL', 'ADIELA DE LOMBANA', NULL, NULL, '0', '0', '890331426-3', '0', '0', 1, 1),
(1584, 4, 'KELLY ', 'CERON', NULL, NULL, '3004729951', '3004729951', '1061742256', 'CR 22# 5-78', 'N', 1, 4),
(1585, 3, 'ALQUILER DE SILLAS', 'FT', NULL, NULL, '2814466 - 2759115', '3152404285', 'NO REFIERE', 'NO REFIERE', 'NO REFIERE', 1, 3),
(1586, 1, 'VINILKORAL', 'DISTRIBUCIONES', NULL, NULL, '0', '0', '385568064', '0', '0', 1, 1),
(1587, 1, 'TAXIS LIBRES', '0', NULL, NULL, '0', '0', '0', '0', '0', 1, 1),
(1588, 1, 'BANCOLOMBIA', '0', NULL, NULL, '0', '0', '0', '0', '0', 1, 1),
(1589, 2, 'AZAEL JUNIER', 'PALACIOS GALEANO', NULL, NULL, '3185149327', '3185149327', '94.154.476', 'CARRERA 24 No. 3 A 10', 'NULL', 1, 2),
(1590, 4, 'GABRIEL ', 'MUÑOZ', NULL, NULL, '3187713322', NULL, '1061753063', 'CALLE 58 N 9 -17', 'NULL', 1, 4),
(1591, 1, 'BVQI', 'COLOMBIA LTDA', NULL, NULL, '0', '0', '830055049-8', '0', '0', 1, 1),
(1592, 1, 'MARIA INIRIDA', ' GRANADOS', NULL, NULL, '0', '0', '31850705', '0', '0', 1, 1),
(1593, 1, 'SOL ANGEL', 'LOPEZ SAAVEDRA', NULL, NULL, '0', '0', '63306220', '0', '0', 1, 1),
(1594, 1, 'GATO ARTE RECREACION', '0', NULL, NULL, '0', '0', '0', '0', '0', 1, 1),
(1595, 1, 'JORGE ', 'HUERTAS', NULL, NULL, '0', '0', '0', '0', '0', 1, 1),
(1596, 1, 'VELASQUEZ JARAMILLO', 'Y CIA LTDA', NULL, NULL, '0', '0', '800040182-5', '0', '0', 1, 1),
(1597, 1, 'VICTOR ADRIAN SERNA', 'HOYOS', NULL, NULL, '0', '0', '944874109', '0', '0', 1, 1),
(1598, 4, 'ALMACEN', 'SUPER TELAS', NULL, NULL, '3163297413', '3006605702', '16638771-8', 'CR 7#6-61', 'N', 1, 4),
(1599, 4, 'ALMACEN', 'MEGAFAM SAS', NULL, NULL, '8206686', '8206686', '900409291-9', 'CL 7#5-45', 'N', 1, 4),
(1600, 4, 'JUMBO', 'CAMPANARIO', NULL, NULL, '8308000', 'N', '900155107-1', 'CR 9#24an-21', 'N', 1, 4),
(1601, 3, 'CARLOS JULIO ', 'CAICEDO SAAVEDRA', NULL, NULL, '3146037301', '3146037301', '94318429', 'CORREGIMIENTO OBANDO CAS C79', 'NO REFEIRE', 1, 3),
(1602, 3, 'C & A', NULL, NULL, NULL, 'NO REFIERE', '3218829654', '19.601.689-9', 'CALLE 30 CRA 26 C.C. VIRGINIA', 'NO REFIERE', 1, 3),
(1603, 1, 'PROESA', 'GALEASON S.A', NULL, NULL, '0', '0', '811038228-9', '0', '0', 1, 1),
(1604, 1, 'JOHANNA MARCELA', 'GARAVITO MORALES', NULL, NULL, '0', '0', '1030552382', '0', '0', 1, 1),
(1605, 3, 'LA GRAN ', 'REGALIA', NULL, NULL, '2707496', 'NO REFIERE', '43477089-9', 'CRA 26 NO 29-86', 'NO REFIERE', 1, 3),
(1606, 4, 'JOSE JULIAN ', 'PALACIOS', NULL, NULL, '6615883', '6615883', '1130624192', 'CALI', 'NULL', 1, 1),
(1607, 1, 'ELECTRÓNICA CENTRAL', 'CARLOS MANOSALVA', NULL, NULL, '0', '0', '854514060', '0', '0', 1, 1),
(1608, 2, 'PROINGSA', 'INDUSTRIALES S.A.S', NULL, NULL, '2301521', NULL, '900562887-1', 'TULUA', 'NULL', 1, 2),
(1609, 2, 'CAROLINA', 'GONZALEZ', NULL, NULL, '3172566321', '3172566321', '29.875.227', 'MANZANA 25 CASA 22', 'cg68_4@hotmail.com', 1, 2),
(1610, 1, 'LUIS ALFONSO', 'VARELA', NULL, NULL, '0', '0', '0', '0', '0', 1, 1),
(1611, 4, 'ARFA', 'PAPELERIA Y SUMINISTROS', NULL, NULL, '3157272897', '3178485883', '805026596-0', 'CL 5OESTE #18-77', 'N', 1, 1),
(1612, 1, 'SANDRA MILENA', 'CANDELO RIOS', NULL, NULL, '0', '0', '30399836', '0', '0', 1, 1),
(1613, 4, 'CIRLEY MAGALY', 'YUQUILEMA GAITAN', NULL, NULL, '8389880', '3122176942', '36384845', 'CL 13#12-06', 'N', 1, 4),
(1614, 3, 'CERRAJERIA ', 'MONROY FRANCO', NULL, NULL, '2708817', 'NO REFIERE ', '16.259.439-0', 'CRA 28 NO 28-32', 'NO REFIERE', 2, 3),
(1615, 3, 'EL PINGUINO', 'PINGUINO', NULL, NULL, '2729902', '2719977', '66.777.003', 'CALLE 30 CRA 23ESQ ', 'NO REFIERE', 1, 3),
(1616, 1, 'NOTARIA 23', 'RAMIRO CALLE', NULL, NULL, '5242406', 'NA', '16259052-4', 'CLL 5A # 39-07', 'NA', 1, 1),
(1617, 2, 'DANIELA', 'RIVILLAS', NULL, NULL, '3178090464', '3178090464', '1.116.266.780', 'CALLE 26A CON CARRERA 17 A 27', 'NULL', 1, 2),
(1618, 1, 'PANADERÍA MONTECARLO', 'O', NULL, NULL, '6641469', 'O', '2401484-1', 'O', 'O', 1, 1),
(1619, 3, 'SUSPERCARTELES ', NULL, NULL, NULL, '2813264', 'no refiere', '14.652.391-3', 'Calle 31 no 31-72', 'no refiere', 2, 3),
(1620, 1, 'ALEXIS DE JESUS', 'POSADA ARBELAEZ', NULL, NULL, '0', '0', '16074593', '0', '0', 1, 1),
(1621, 3, 'asoprevepal', NULL, NULL, NULL, '0', '3173518929', 'no refiere', 'no refiere', 'no refiere', 2, 3),
(1622, 2, 'MARIBEL', 'VICTORIA SUESCUN', NULL, NULL, '3164239983', '3164239983', '29.314.359', 'CARRERA 2A No. 12-33', 'NULL', 1, 6);
INSERT INTO `proveedores` (`id`, `sede_id`, `nombres`, `apellidos`, `created_at`, `deleted_at`, `telefono`, `celular`, `num_documento`, `direccion`, `email`, `identificacion_id`, `ciudad_id`) VALUES
(1623, 4, 'DORA JOHANA', 'MUÑOZ DELGADO ', NULL, NULL, '3008712640', NULL, '34324962', 'KRA 6A 18AN 01', 'NULL', 1, 4),
(1624, 2, 'DIEGO FERNANDO', 'GARCIA PUENTES', NULL, NULL, '2324261', '3165077185', '94.389.945-7', 'CARRERA 27 BIS No. 39-15', 'NULL', 1, 2),
(1625, 1, 'AVIATUR', 'SA', NULL, NULL, '5879441', 'NA', '860000018-2', 'AV 19 4-62', 'NA', 1, 1),
(1626, 1, 'ANNY MARCELA', 'PIEDRAHITA CAICEDO', NULL, NULL, '0', '0', '1130610187', '0', '0', 1, 1),
(1627, 1, 'ANTONIO JOSE', 'PALACIOS MUÑOZ', NULL, NULL, '0', NULL, '12968109', '0', '0', 1, 1),
(1628, 4, 'COPIEXCELL', 'MANZO', NULL, NULL, '8319667', '8319667', '76314116', 'KRA 2A 3 N-116', 'NULL', 1, 4),
(1629, 1, 'CITI', 'BANK', NULL, NULL, '0', '0', '0', '0', '0', 1, 1),
(1630, 1, 'CLAUDIO ALEXANDER', 'MUÑOZ RECALDE ', NULL, NULL, '0', '0', '12745970', '0', '0', 1, 1),
(1631, 2, 'DAVID', 'ROJAS BEDOYA', NULL, NULL, '3103838489', '3103838489', '1.115.190.155', 'ANDALUCIA', 'NULL', 1, 5),
(1632, 1, 'JOSE FERNANDO', 'SCHEELL CORTES', NULL, NULL, '0', '0', '16535622', '0', '0', 1, 1),
(1633, 1, 'CENTROTINTAS TECNOLOGIA', 'GLADYS CONDE OVIEDO', NULL, NULL, '0', '0', '668456378', '0', '0', 1, 1),
(1634, 3, 'ANGELICA MARIA ', 'PARADA ESCOBAR ', NULL, NULL, '2757892', '-3117229637', '1113643408', 'CALLE 13A 25-56', 'ANGIIEP1@LIVE.COM', 1, 3),
(1635, 2, 'LUIS EDUARDO ', 'IBARRA PARRA', NULL, NULL, '3103738773', '3103738773', '6429735', 'CRA 22 NO 21-29 LA ALAMEDA', '....', 1, 2),
(1636, 2, 'ANDAMIOS ALTURAS', '...', NULL, NULL, '2326780', '3185293057', '16346569', 'CRA 30 NO 31-21', '...', 1, 2),
(1637, 1, 'LOGISTICA EXPRESO PALMIRA', '0', NULL, NULL, '4055335', '0', '8001600688', '0', '0', 2, 1),
(1638, 2, 'FERRETERIA', 'CONSTRUALBERTH', NULL, NULL, '2251492', '3167389201', '31204797-0', 'CLL 29 NO 23-17', 'NULL', 1, 2),
(1639, 3, 'SUMIPINTURAS', NULL, NULL, NULL, '2718324', 'NO REFIERE', '71631755-8', 'CALLE 28 NO 27-66', 'NO REFIERE', 2, 3),
(1640, 2, 'QUORUM SYSTEM', NULL, NULL, NULL, '2258778', '3163417551', '80502696', 'CRA 27 NO 29-80', '..', 1, 2),
(1641, 4, 'DAIRY ALEXANDER', ' FLOREZ ARANDA ', NULL, NULL, '321587056', '321587056', '93.391.244 ', 'POPAYAN', 'N', 1, 4),
(1642, 2, 'ANTONIO JOSE ', 'RODRIGUEZ ', NULL, NULL, '3177467173', '3177467173', '94376334', 'CLL 26C NO 14-18', 'antoniojr72@hotmail.com', 1, 2),
(1643, 2, 'MUNDIAL DE VIDRIOS Y ALUMINIOS', NULL, NULL, NULL, '2253435', '3156815516', '16356349', 'CLL 12B NO 28A-18', NULL, 1, 2),
(1644, 1, 'SIGN SUPPLY', 'S.A', NULL, NULL, '0', '0', '8300543649', '0', '0', 1, 1),
(1645, 1, 'MOLDURAS DE', 'COLOMBIA', NULL, NULL, 'NA', 'NA', '817000351-4', 'NA', 'NA', 1, 4),
(1646, 3, 'COMERCIALIZADORA', 'ARCOASEO', NULL, NULL, '2866434', 'NO REFIERE', '16243207-9', 'CRA 25 NO 29-75', 'NO REIFERE', 1, 3),
(1647, 1, 'COPY ', 'EVA ', NULL, NULL, '6677215', NULL, '66843237-6', 'CLL 34N # 2BN-47', NULL, 1, 1),
(1648, 4, 'TODO', 'ELECTRICO', NULL, NULL, '8236333', '8203737', '10539393-0', 'CL 10N-6A-82', 'N', 1, 4),
(1649, 2, 'EDWARD JAIR ', 'GUTIERREZ ROMERO', NULL, NULL, '3137082272', '3137082272', '94154295', 'CRA 38 NO 38A-35', 'edwargutierrez14@hotmail.com', 1, 2),
(1650, 4, 'CLARISOL', 'WALTON', NULL, NULL, '3147633976', '3147633976', '66980979 ', 'CE 42B#1-23', 'N', 1, 4),
(1651, 2, 'JHON JABER ', 'GALVIS', NULL, NULL, '3188038919', '3188038919', '1116255048', 'CRA 2 NO 22-70', '...', 1, 2),
(1652, 1, 'STYLOS Y ACABADOS ', 'DEL VALLE SAS', NULL, NULL, '8821717', NULL, '900501785-8', 'CRA 5 # 22-123', '1', 1, 1),
(1653, 1, 'ACCIONES Y SERVICIOS', 'ACCION PLUS', NULL, NULL, '6811111', 'NA', '800162612-4', 'CLL 26N 5N 39', 'NA', 1, 1),
(1654, 2, 'YHON FREDDY ', 'HERRERA GAVIRIA', NULL, NULL, '3173970552', '3173970552', '18561685', 'MZ 25 CASA 20', '..', 1, 2),
(1655, 2, 'CAROL JOHANA', 'GRANDA GALICIA', NULL, NULL, '2328024', '3012598245', '67.012.085', 'CARRERA 23 No. 35-14', 'NULL', 1, 2),
(1656, 1, 'ERIKA YULIETH ', 'ORTIZ RUEDA', NULL, NULL, '0', '0', '1130638357', '0', '0', 1, 1),
(1657, 1, 'PATRICIA EUGENIA', 'DURAN ESCOBAR', NULL, NULL, '0', '0', '1151935108', '0', '0', 1, 1),
(1658, 1, 'Marlin Durfay', 'Vidal Castrillon', NULL, NULL, '4460683', '3163628396', '1.130.613.249', 'Cra 1C bis 64-41', 'mdurfay@hotmail.com', 1, 1),
(1659, 1, 'NATHALIA', 'PERAFAN CHAMORRO', NULL, NULL, '0', '0', '1107069273', '0', '0', 1, 1),
(1660, 4, 'JAIME ANDRES', 'PEREZ REDONDO', NULL, NULL, '8231798', '3218362156', '73330236', 'CL 36C#3-37', 'NO', 1, 4),
(1662, 1, 'CRISTIAN DAVID', 'GARZON COLLAZOS', NULL, NULL, '0', '0', '1151958217', '0', '0', 1, 1),
(1663, 2, 'TODO SILLAS ', 'RECLINABLES', NULL, NULL, '3184018312', '3184018312', '1116235203-1', 'TRAV 12 NO 21-35', '...', 1, 2),
(1664, 4, 'MARIA LUCIA  ', 'HURTADO', NULL, NULL, '233156', '8234620', '34320874', 'KRA 6 16A N 23', 'NULL', 1, 4),
(1665, 4, 'MARLIN ', 'VIDAL', NULL, NULL, '316 3628396', '316 3628396', '1.130.613.249', 'CALI', 'N', 1, 4),
(1666, 1, 'LIDA YANETH', 'GONZALEZ SARRIA', NULL, NULL, '0', '0', '36184201', '0', '0', 1, 1),
(1667, 1, 'SUPER DISTRIBUIDORA', 'SAS', NULL, NULL, '0', '0', '900325928-1', '0', '0', 1, 1),
(1668, 1, 'CREM', 'HELADO', NULL, NULL, '0', '0', '16272169-0', '0', '0', 1, 1),
(1669, 1, 'ADECCO', '0', NULL, NULL, '0', '0', '0', '0', '0', 1, 1),
(1670, 1, 'LOWIS MAURICIO', 'CHALA', NULL, NULL, '0', '0', '94533814', '0', '0', 1, 1),
(1671, 4, 'RELOJERIA ', 'YINYER', NULL, NULL, '8242259', '8242259', '8065971532-02', 'PASAJE COMERCIAL LOCAL 17', 'N', 1, 4),
(1672, 1, 'IMPORTACIONES DENTAL', '0', NULL, NULL, '0', '0', '0', '0', '0', 1, 1),
(1673, 1, 'PEGAMORI', '0', NULL, NULL, '0', '0', '0', '0', '0', 1, 1),
(1674, 4, 'ANDREA ', 'CERON', NULL, NULL, '8368778', NULL, '1061740453', 'CALLE 57 N 10-46', 'NULL', 1, 4),
(1675, 1, 'STIVEN', 'TORRES', NULL, NULL, '0', '0', '1130674360', '0', '0', 1, 1),
(1676, 4, 'PUBLICAR PUBLICIDAD ', 'MULTIMEDIA S.A.S', NULL, NULL, '18000964444', NULL, '860001317-4', 'BOGOTA', 'NULL', 1, 4),
(1677, 2, 'SERVI', 'ENVIOS', NULL, NULL, '2245402', '3164449769', '890920990-3', 'CRA 25 NO 30-12', '...', 1, 2),
(1678, 2, 'CRISTIAN ALEJANDRO ', 'ROLDAN PELAEZ', NULL, NULL, '3183886657', '3183886657', '1116249562', 'CRA 23A NO. 5-32', 'crisalej_14@hotmail.com', 1, 2),
(1679, 1, 'JOSE JAIRO', 'DUQUE VALDEZ', NULL, NULL, '0', '0', '16797694', '0', '0', 1, 1),
(1680, 3, 'RODOLFO ', 'CRUZ ESCOBAR', NULL, NULL, '2725227', '3166108443', '16282500', 'CALLE 38 NO 21-66', 'RCE14@HOTMAIL.COM', 1, 3),
(1681, 3, 'ALEXANDER ', 'ALADINO VALENCIA', NULL, NULL, 'NO REFIERE', '3006125168', '6645414', 'CRA 45A NO 47A46', 'NULL', 1, 3),
(1682, 1, 'CHRISTIAN', 'PEÑA MOLINA', NULL, NULL, '0', '0', '1143845372', '0', '0', 1, 1),
(1683, 1, 'NILSA MILENA', 'LOPEZ OSORIO', NULL, NULL, '0', '0', '67009920', '0', '0', 1, 1),
(1684, 4, 'LOLY LUZ', 'TORRES MONTAÑO', NULL, NULL, '3136708923', NULL, '1061703934', 'CALLE 55 11-71', 'NULL', 1, 4),
(1685, 1, 'CRISTIAN EDUARDO', 'IZQUIERDO GONZALEZ', NULL, NULL, '0', '0', '1143971327', '0', '0', 1, 1),
(1686, 2, 'ASABEL ERMEZUL ', 'BEDOYA POLOCHE', NULL, NULL, '3192847772', '3192847772', '4733350', 'LA MORALIA', '...', 1, 2),
(1687, 4, 'JOHANA', 'ITAZ', NULL, NULL, '3203717548', '3203717548', '1024500615', 'SANTA FE', 'N', 1, 4),
(1688, 4, 'YINETH ANGELI', 'MORA GUEVARA', NULL, NULL, '3114498319', NULL, '1088736273', 'PASTO', 'NULL', 1, 4),
(1689, 1, 'HERNANDEZ GAVIRIA', 'FRESIA', NULL, NULL, '0', '0', '66899406', '0', '0', 1, 1),
(1690, 2, 'COMFANDI', 'TULUA', NULL, NULL, '........', '......', '890303208-5', '.......', '........', 1, 2),
(1691, 2, 'FRANCISCO JAVIER', 'MARTINEZ', NULL, NULL, '3156889877', '3156889877', '16365612', 'CRA 10 NO 26A-30', NULL, 1, 2),
(1692, 2, 'ALVARO JOSE ', 'MORALES VELA', NULL, NULL, '3122576614', '3122576614', '6200118', 'CRA 6 NO 1 SUR 22 BUGALAGRANDE', 'AJMV8211@HOTMAIL.COM', 1, 2),
(1693, 2, 'EL RINCON', 'DE LAS LLLAVES', NULL, NULL, '2252133', '3122135036', '12565748-9', 'CLL 24A NO 25-51', NULL, 1, 2),
(1694, 4, 'gaseosas', 'posada tobon S.A', NULL, NULL, '3103897195', '3103897195', '890903939-5', 'Cl 69 N 9-10', 'no tiene', 1, 4),
(1695, 1, 'ENVIA', 'MENSAJERÍA Y MERCANCIA.', NULL, NULL, '0', '0', '800185306', '0', '0', 1, 1),
(1696, 2, 'DIEGO ARMANDO ', 'IMBACHI NIETO', NULL, NULL, '3187613181', '3187613181', '1144026114', 'CRA 32A NO 25-25', 'keshi1989@hotmail.com', 1, 2),
(1697, 4, 'JHON HAROLD', 'GARCIA ', NULL, NULL, '3137365476', NULL, '71290112', 'CALLE 11 A 66-10', 'NULL', 1, 4),
(1698, 1, 'Javier', 'Orozco', NULL, NULL, '6675393', '3206314918', '10.489.396', 'Carrera 95 No. 46 - 68 Valle del lili', 'acom.farmaceutico@gmail.com', 1, 1),
(1699, 1, 'Tintoreria Esperanza Collazos', 'LAVATEX', NULL, NULL, 'C', 'C', '29.580.622', 'C', 'C', 1, 1),
(1700, 1, 'CLAUDIA', 'MARTINEZ JOVEL', NULL, NULL, '0', '0', '29435397', '0', '0', 1, 1),
(1701, 1, 'INTERNET Y PAPELERIA', 'DEL NORTE', NULL, NULL, '3727492', NULL, '4334133-1', 'AV. VASQUEZ COBO # 30N-87', NULL, 1, 1),
(1702, 1, 'METALICAS ARKO', '0', NULL, NULL, '0', '0', '0', '0', '0', 1, 1),
(1703, 4, 'ADRIANA PATRICIA', 'MORALES ULCHUR', NULL, NULL, '3167909035', NULL, '1061707587', 'VILLA DEL NORTE', 'NULL', 1, 4),
(1704, 1, 'MI.COM', '0', NULL, NULL, '0', '0', '0', '0', '0', 1, 1),
(1705, 1, 'STFGROUP', 'SA', NULL, NULL, '0', '0', '0', '0', '0', 1, 1),
(1706, 4, 'DISTRIBUIDORA Y COMERCIALIZADORA', 'CAUCA LTDA', NULL, NULL, '8217576', '578217576', '900248705-4', 'CARRERA 11 #2N-18', 'NO TIENE', 1, 4),
(1707, 3, 'DIANA PAOLA', 'AGUIRRE', NULL, NULL, '2712767', NULL, '1113645107-9', 'CALLE 28 ·26.28', 'NULL', 1, 3),
(1708, 1, 'LUIS ERNESTO', 'BANGUERO GUTIERREZ', NULL, NULL, '0', '0', '94040415', '0', '0', 1, 1),
(1709, 3, 'FRIJOLES VERDES', 'VERDES', NULL, NULL, '3120660', NULL, '900747098-2', 'CLL 31 Nº44-239', 'NULL', 1, 3),
(1710, 3, 'MIRLELLY', 'HERNANDEZ CASTRO', NULL, NULL, '3113663716', '3113663716', '29683747', 'KR 35A Nº 58A62', 'mirlelly85@hotmail.es', 1, 3),
(1711, 3, 'WILSON', 'VALENCIA ROJAS', NULL, NULL, '2747182', '3104330784', '94.319.693', 'CLL 58 Nº 41A49', 'wilvaro@hotmail.es', 1, 3),
(1712, 3, 'johana patricia', 'ruiz', NULL, NULL, '2855713', '2855713', '31.320.443', 'cr 31nº 23-44', 'calidad@cenal.com.co', 1, 3),
(1713, 3, 'JUAN DAVID', 'OTALVAREZ PEREZ', NULL, NULL, '3188512705', '3188512705', '1.113.644.491', 'CR 222 Nº 20-19', 'NO TIENE', 1, 3),
(1714, 4, 'CLAUDIA MILENA ', 'HORMIGA ', NULL, NULL, '8221132', NULL, '34565123', 'KRA 11 9-39', 'NULL', 1, 4),
(1715, 2, 'MULTIPLASTICOS ', 'DEL VALLE', NULL, NULL, '2247609', '2247609', '94231905-3', 'CRA 23 NO 28-36', NULL, 1, 2),
(1716, 3, 'GASPARINI', 'NO REGUISTRA', NULL, NULL, '3157084145', '3157084145', '1113658100', 'CLL32 Nº 25-12', 'NO REGUISTRA', 1, 3),
(1717, 2, 'JUAN FERNANDO ', 'JARAMILLO CARMONA', NULL, NULL, '2249267', '3136180955', '94368188', 'CRA 23 NO 38A-28', 'juanchopele06@hotmail.com', 1, 2),
(1718, 4, 'HOTEL ', 'ARCADA PAYANESA S.A.S', NULL, NULL, '8321717', NULL, '900708368-1', 'CALLE 2 -4-62', 'NULL', 1, 4),
(1719, 1, 'MULTIMAQUINAS', '0', NULL, NULL, '0', '0', '0', '0', '0', 1, 1),
(1720, 4, 'RIVER A ', 'CRUZ', NULL, NULL, '3113944157', '3113944157', '1064676441', 'CALLE 23 Nº5A-36', 'NO TIENE', 1, 4),
(1721, 2, 'FELIPE ', 'DIAZ GARCIA', NULL, NULL, '3177595585', '3177595585', '1115069611', 'CLL 1CN NO 21-40', 'veterinario@gmail.com', 1, 2),
(1722, 1, 'PILAR', 'MALDONADO PASCUAS', NULL, NULL, '0', '0', '31969959', '0', '0', 1, 1),
(1723, 1, 'JUAN CARLOS', 'PATIÑO', NULL, NULL, '0', '0', '94411008', '0', '0', 1, 1),
(1724, 1, 'REDETRANS', '0', NULL, NULL, '0', '0', '830038007-7', '0', '0', 1, 1),
(1725, 4, 'DIRTRIBUIDORA UNIVERSAL', 'DE POPAYAN', NULL, NULL, '8244662', '3136710628', '900779615-1', 'KRA 5-7-13', 'NULL', 1, 4),
(1726, 4, 'DISTRIBUIDORA UNIVERSAL ', 'DE POPAYAN', NULL, NULL, '8244662', NULL, '900779615-8', 'KRA 5-7-13', 'NULL', 1, 4),
(1727, 4, 'JAIME ANDRES', 'TORRES', NULL, NULL, '3148893747', '3148893747', '10294814', 'CIUDAD CAMPESTRE LA LIOJA', 'NO TIENE ', 1, 4),
(1728, 4, 'DANIEL ALEJANDRO', 'RIVERA', NULL, NULL, '3005582457', NULL, '94357955', 'CALLE 18 56-40', 'NULL', 1, 4),
(1729, 1, 'VIDRIOS Y ALUMINIOS', 'EL SOL 2', NULL, NULL, '0', '0', '1144143012-6', '0', '0', 1, 1),
(1730, 2, 'TONOS', 'JM', NULL, NULL, '2306668', '2306668', '2660461', 'CLL 22 NO 3A-04', '...', 1, 2),
(1731, 1, 'JUAN CARLOS ', 'CRUZ GARCIA', NULL, NULL, '0', '0', '1012371236', '1', '0', 1, 1),
(1732, 1, 'EXITO', 'LA FLORA', NULL, NULL, '0', '0', '0', '0', '0', 1, 1),
(1733, 1, 'ALFREDO', 'LOPEZ GUERRERO', NULL, NULL, '0', '0', '14952051', '0', '0', 1, 1),
(1734, 1, 'PAOLA ANDREA', 'ECHEVERRY', NULL, NULL, '0', '0', '29707415', '0', '0', 1, 1),
(1735, 3, 'CICLO PCOPY ', 'COPY', NULL, NULL, '281083', '281083', '15903009-6', 'CR 28 Nº 28-19', 'NO APLICA', 1, 3),
(1736, 1, 'VERONICA', 'SANCHEZ CORRALES', NULL, NULL, '0', '0', '1144039289', '0', '0', 1, 1),
(1737, 1, 'ELECTRONICA', 'DIGITAL', NULL, NULL, '0', '0', '13528341', '0', '0', 1, 1),
(1738, 1, 'GRUPO EMPRESARIAL ', 'SILVER FERRETERIA', NULL, NULL, '0', '0', '900420715', '0', '0', 1, 1),
(1739, 1, 'FERRETERÍA ALUMINIO', 'VIDRIO Y MADERA', NULL, NULL, '0', '0', '8894224', '0', '0', 1, 1),
(1740, 1, 'Cristian Eduardo', 'Izquierdo Gonzalez', NULL, NULL, 'c', 'c', '1.143.971.327', 'c', 'c', 1, 1),
(1741, 2, 'ELIFE', 'SOLUCIONES INTELIGENTES ', NULL, NULL, '3158619463', '3158619463', '94511684-2', 'CLL 2 OESTE NO 24A-183 OFC 502 CALI', 'ALIFEIMPORTS@GMAIL.COM', 1, 1),
(1742, 2, 'ADALBERTO ', 'AGUADO SANCHEZ', NULL, NULL, '3172164290', '3172164290', '1116242027', 'CLL 30 NO 26-67 ', 'adalbertoaguadosanche@gmail.com', 1, 2),
(1743, 3, 'COORDINADORA', 'ACOPY', NULL, NULL, 'NO APLICA', 'NO APLICA', '890-904-713-2', 'CARRERA 36 Nº 13-290', 'NO APLICA', 1, 3),
(1744, 4, 'cindy yohana', 'delgado guzman', NULL, NULL, '3175564175', '3175564175', '1061721506', 'calle 8 norte Nº 6a-164', 'no tiene', 1, 4),
(1745, 4, 'DIANA ', 'TORRES', NULL, NULL, '3157133002', NULL, '52717477', 'KRA 1 -1-27', 'NULL', 1, 4),
(1746, 1, 'DISTRIBUIDORA ', 'LA 11', NULL, NULL, '0', '0', '31321667-2', '0', '0', 1, 1),
(1747, 1, 'DIEGO FERNANDO ', 'CHAMORRO SCARPETA', NULL, NULL, '0', '1', '94064400', '1', '0', 1, 1),
(1748, 3, 'TODO EN ARTES', 'GRAFICAS', NULL, NULL, '3154384763', '3154384763', '94.306.236-8', 'CALLE 37A Nº20-25', 'NO APLICA', 1, 3),
(1749, 1, 'WILDER', 'JIMENEZ REALPE', NULL, NULL, '0', '0', '94486249', '0', '0', 1, 1),
(1750, 1, 'SANDRA LUCIA', 'CAINA RODRIGUEZ', NULL, NULL, '0', '0', '38554012', '0', '0', 1, 1),
(1751, 4, 'JESUS DAVID', 'DORADO', NULL, NULL, '3016721481', NULL, '76324202', 'CALLE 4 57 C20', 'NULL', 1, 4),
(1752, 3, 'JUAN CARLOS ', 'POSO L', NULL, NULL, '2586632', '2586632', '94.556.203-7', 'CALLE 31 Nº 24-09', 'NO APLICA', 1, 3),
(1753, 3, 'JOSE ANTONI', 'PANTOJA DIAZ', NULL, NULL, '314081499', '314081499', '87491147', 'CALLE 60 A Nº 35-53', 'NO APLICA', 1, 3),
(1754, 1, 'El', 'Tiempo', NULL, NULL, '2940100', 'na', '860001022-7', 'Cll 26 68B70 Bogota', 'na', 1, 1),
(1755, 3, 'UNIVERSIDAD', 'SANTIAGO DE CALI', NULL, NULL, 'NO APLICA', 'NO APLICA', '890303797-1', 'NO APLICA', 'NO APLICA', 1, 3),
(1756, 4, 'ferreteria la reina', 'fabio nelson pelaez arias', NULL, NULL, '8216471', '8214010', '10291252-3', 'calle 15 nº 15-82', 'no tiene', 1, 4),
(1757, 3, 'INSU', 'PAPELES', NULL, NULL, '31552152006', '31552152006', '1.113.654.390-5', 'CALLE 29Nº 30-48', 'NO APLICA', 1, 3),
(1758, 1, 'CESAR AUGUSTO', 'ROBLEDO RODRIGUEZ', NULL, NULL, '0', '0', '94074046', '0', '0', 1, 1),
(1759, 3, 'JAIRO', 'ESCOBAR DUQUE', NULL, NULL, '2864721', '3137666572', '16.279.848', 'CALLE34 Nº 44-77', 'jaitearocher2@hotmail.com', 1, 3),
(1760, 3, 'FUNDACION PROYECTO', 'UBIKATE', NULL, NULL, '3186415302', '3186415302', '900366847-7', 'AVENIDA 15 OESTE Nº 19-360', 'fundaubikate@hotmail.com', 1, 3),
(1761, 1, 'FUNDACION', 'PROYECTO UBIKATE', NULL, NULL, '3705506', '0', '900366847-7', '0', '0', 1, 1),
(1762, 3, 'PLASTI', 'TODO', NULL, NULL, '281632', 'NO APLICA', '16.884.006-5', 'CALLE 31 Nº 22-35', 'NO APLICA', 1, 3),
(1763, 3, 'JUAN CARLOS', 'LEMA JIMENEZ', NULL, NULL, '2813264', '2813264', '1113646297', 'CALLE 31 Nº 31-72', 'NO APLICA', 1, 3),
(1764, 4, 'serviindustriales', 'del cauca', NULL, NULL, '8306333', '8306333', '34560123-3', 'kra 7 n 2n 50', 'NULL', 1, 4),
(1765, 2, 'ANA MARIA ', 'VILLEGAZ', NULL, NULL, '3117352154', '3117352154', '29877414', 'CLL 29 NO 32-11', 'anmavi70@yahoo.es', 1, 2),
(1766, 1, 'TAPETES Y PISOS', 'DEL PACIFICO LTDA.', NULL, NULL, '6685492', '0', '0', '0', '0', 1, 1),
(1767, 1, 'MILLER ALEXIS', 'PEÑA HERNANDEZ', NULL, NULL, '0', '0', '1144183595', '0', '0', 1, 1),
(1768, 4, 'RCN RADIO', 'LA MEGA', NULL, NULL, '231122-230813', '0', '890903910-12', 'CARRERA 7 N9N-66', 'NO TIENE', 1, 4),
(1769, 3, 'IVAN ', 'VELAS QUEZ', NULL, NULL, '3178136961', '3178136961', '6391131', 'CALLE 35B Nº 2-19', 'NO APLICA', 1, 3),
(1770, 1, 'EXPRESO', 'PALMIRA', NULL, NULL, '1', '0', '0', '0', '0', 1, 1),
(1771, 1, 'CRISTIAN ANDRES  ', 'LENIS CAMPO', NULL, NULL, '0', '0', '1118291185', '0', '0', 1, 1),
(1772, 1, 'SANTIAGO', 'MONTENEGRO GRAJALES', NULL, NULL, '0', '0', '1143846700', '0', '0', 1, 1),
(1773, 4, 'LUZ ADRIANA ', 'MANQUILLO CERON', NULL, NULL, '3113264941', NULL, '1144034636', 'LA LADERA', 'NULL', 1, 4),
(1774, 1, 'JAVIER ANTONIO', 'ÑAÑEZ MACIAS', NULL, NULL, '0', '0', '4611487', '0', '0', 1, 1),
(1775, 1, 'WILLIAM ANDRES', 'MONTENEGRO CARDONA', NULL, NULL, '0', '0', '1130612460', '0', '0', 1, 1),
(1776, 3, 'SUPER', 'INTER', NULL, NULL, 'NO APLICA', 'NO APLICA', '890900608-9', 'NO APLICA', 'NO APLICA', 1, 3),
(1777, 1, 'ANDREA DEL CARMEN ', 'GOMEZ VALLEJO', NULL, NULL, '0', '0', '36950774', '0', '0', 1, 1),
(1778, 4, 'CRISTIAN DAVID', 'VALVERDE ORDOÑEZ', NULL, NULL, '3206181249', '3206181249', '1025900300', 'SAUCES', 'NO TIENE', 1, 4),
(1779, 3, 'JORGE ARIEL', 'VIVAS RAMOS', NULL, NULL, 'NO APLICA', 'NO APLICA', '10.535.414', 'NO APLICA', 'NO APLICA', 1, 3),
(1780, 4, 'NOTARIA ', 'TERCERA', NULL, NULL, '8220012', NULL, '13008051-1', 'KRA 8  2-12', 'NULL', 1, 4),
(1781, 3, 'MARLIN ', 'VIDAL', NULL, NULL, 'NO APLICA', 'NO APLICA', '1.130.613.245', 'NO APLICA', 'NO APLICA', 1, 3),
(1782, 1, 'SENTIMIENTOS CAPTURES', 'ROCHA ', NULL, NULL, '0', '0', '162880653', '0', '0', 1, 1),
(1783, 1, 'MARIA AMPARO', 'GUTIERREZ', NULL, NULL, '4006313', '3156079672', '38943577', 'CLL 70 TRA F # 28F-19 B/ CALIPSO', 'NULL', 1, 1),
(1784, 1, 'MADERAS ', 'LOS PINOS DEL VALLE', NULL, NULL, '4006313', '3156079672', '38943577', 'CLL 70 TRAN 28 F-19 B/ CALIPSO', 'NULL', 1, 1),
(1785, 1, 'CESAR AUGUSTO', 'ROBLEDO RODRIGUEZ', NULL, NULL, '0', '0', '94074046', '0', '0', 1, 1),
(1786, 2, 'SUB- INTENDENTE ARMANDO ', 'PALMA', NULL, NULL, '3108321216', '3108321216', '11805823', 'CUADRANTE 16', '...', 1, 2),
(1787, 4, 'LUIS FERNEY', 'RESTREPO', NULL, NULL, '3217716819', '3217716819', '15533634-1', 'CALLE 7 #15A-04', 'NULL', 1, 4),
(1788, 3, 'FREY', 'CADENA GARCIA', NULL, NULL, '667685', '667685', '18.389.273-1', 'PASARELA CALI', 'NO APLICA', 1, 3),
(1789, 1, 'MARIA ANGELICA', 'VIASUS CIFUENTES', NULL, NULL, '0', '0', '31711665', '0', '0', 1, 1),
(1790, 3, 'super', 'carteles', NULL, NULL, '2878688', '3184754106', '14.652.391-3', 'CALLE 31 Nº 31-72', 'NO APLICA ', 2, 3),
(1791, 4, 'DAVID HERNAN ', 'PEREZ SOLARTE ', NULL, NULL, '3133911373', NULL, '10297020', 'KRA 36 C 14-46', 'NULL', 1, 4),
(1792, 2, 'MARIA ACENETH ', 'GAÑAN', NULL, NULL, '2252563', '2252563', '41609239', 'CRA 33 NO 37-14 FATIMA', '...', 1, 2),
(1793, 4, 'NESTOR JAVIER', 'TOBAR GUERRERO', NULL, NULL, '3108379981', NULL, '10291203', 'KRA 17 16-52', 'NULL', 1, 4),
(1794, 1, 'DISTRIBUIDOR ELÉCTRICO ', 'DE CALI SAS', NULL, NULL, '8890188', '8897636', '9005897340', NULL, 'DISTRIBUIDORELECTRICODECALI@HOTMAIL.COM', 1, 1),
(1795, 1, 'ORGANIK', 'S.A', NULL, NULL, '0', '0', '800228372', '0', '0', 1, 1),
(1796, 2, 'JULIANA ANDREA ', 'BETANCUR', NULL, NULL, '3173680968', '3173680968', '31.794.856', 'DG 16 NO 25AI-04', 'ABB24@HOTMAIL.COM', 1, 2),
(1797, 1, 'YESENIA', 'LENIS GOMEZ', NULL, NULL, '0', '0', '29677713', '0', '0', 1, 1),
(1798, 2, 'LUZ ERENIA ', 'SAAC HURTADO ', NULL, NULL, '3117774047', '3117774047', '66679123', 'CRA 10 NO 14-16', 'LUZERENIA1404@HOTMAIL.COM', 1, 2),
(1799, 2, 'DIANA CAROLINA ', 'OCAMPO SANCHEZ', NULL, NULL, '3226339340', '3226339340', '38756878', 'CLL 60 NO 52B-03 SEVILLA', '..', 1, 2),
(1800, 4, 'CYNDI VANESSA', 'MIRANDA MUÑOZ', NULL, NULL, '3225353107', '3225353107', '1061724660', 'CARRERA 21 Nº 2-61', 'VANESITA.GREEN204@HOTMAIL.COM', 1, 4),
(1801, 1, 'TODO PINTURAS', 'AMERICAS', NULL, NULL, '0', '0', '11306047811', '0', '0', 1, 1),
(1802, 4, 'FRANCISCO ROLANDO', 'ARIAS NOREÑA', NULL, NULL, '3006254922', NULL, '1061795349', 'KRA 9 80 N 22', 'NULL', 1, 4),
(1803, 3, 'DANIEL LEJANDRO', 'RIVERA MARIN', NULL, NULL, '3336660', '3336660', '94357955', 'CALLE 18 Nº 40CA50', 'NO APLICA', 1, 3),
(1804, 1, 'IZONE', NULL, NULL, NULL, '0', '0', '0', '0', '0', 1, 1),
(1805, 3, 'FREDY', 'ANTIA TRUJILLO', NULL, NULL, '3148561809', '3148561809', '16270889', 'CR 15B N\' 47A62', 'NO APLICA ', 1, 3),
(1806, 3, 'INGRI JOHANA', 'SALAZARVARGAS', NULL, NULL, '2879374', '3178575876', '1112879459', 'CLL 34A Nº 13-17', 'NO APLICA', 1, 3),
(1807, 1, 'Friomundo', 'Soluciones en refrigeración', NULL, NULL, '8810312 - ', '8810261', '805.018.722-9', 'Carrera 5 No. 19 -63', '@', 1, 1),
(1808, 1, 'CITYPC', 'LTDA', NULL, NULL, '0', '0', '0', '0', '0', 1, 1),
(1809, 1, 'VÍCTOR ALFONSO', 'YULE MARIN', NULL, NULL, '0', '0', '8050265960', '0', '0', 1, 1),
(1810, 1, 'BLADIMIR', 'ARCE PEREZ', NULL, NULL, '0', '0', '94525313', '0', '0', 1, 1),
(1811, 2, 'JAVIER DE JESUS', 'AGREDO', NULL, NULL, '3168207287', '3168207287', '16349143', 'CLL 12C NO 38-05 EL DORADO ', '...', 1, 2),
(1812, 3, 'PUBLICAR', 'PUBLICAR', NULL, NULL, '6465544', NULL, '860001317-4', 'NO APLICA', 'NULL', 1, 3),
(1813, 1, 'MONTAJES ELECTRICOS', 'DEL VALLE', NULL, NULL, '0', '0', '0', '0', '0', 1, 1),
(1814, 1, 'FERRETORNILLOS', 'SANTANDER', NULL, NULL, '8830394', NULL, '632868668', NULL, NULL, 1, 1),
(1815, 1, 'COMPUSEXTA', NULL, NULL, NULL, '8897003', '3164403210', '166825384', 'CRA 6 · 16-56', NULL, 1, 1),
(1816, 2, 'LUIS FELIPE ', 'HORTA GUTIERREZ', NULL, NULL, '2305625', '3173501432', '1.116.234.757', 'CLL 21 6BW-10 ', '..', 1, 2),
(1817, 2, 'JULIAN ANDRES', 'TORO ESCOBAR', NULL, NULL, '3164087392', '3164087392', '14801079', 'CLL 42B NO 33-79', 'NULL', 1, 2),
(1818, 1, 'Colacril', 'PTTY S.A.S', NULL, NULL, '3885500', '5143161', '16351010', 'Cl 15 N.18-18 ', 'no suministra', 2, 1),
(1819, 1, 'INSTITUTO NUESTRA', 'SEÑORA DEL CARMEN', NULL, NULL, '0', '0', '0', '0', '0', 1, 1),
(1820, 1, 'MONICA ', 'ARANGO SANTAMARIA', NULL, NULL, '0', '0', '31478409', '0', '0', 1, 1),
(1821, 1, 'ROSALBA', 'JIMENEZ MARTINEZ', NULL, NULL, '0', '0', '52155619', '0', '0', 1, 1),
(1822, 1, 'AAA AUDIOVISUALES', 'A TIEMPO Y CIA. LTDA', NULL, NULL, '0', NULL, '8050251118', '0', '0', 1, 1),
(1823, 2, 'SEBASTIAN ', 'GOMEZ', NULL, NULL, '3176710886', '3176710886', '1116264939', '....', '....', 1, 2),
(1824, 2, 'ANGELICA MARIA ', 'GONZALEZ', NULL, NULL, '2252563', '2252563', '29760975', 'CRA 33 NO 37-14', '....', 1, 2),
(1825, 1, 'AGENCIA DE MODELOS', 'PRODUCTORA Y REPRESENTACIONES EL MOLINO S.A.S', NULL, NULL, '0', '0', '0', '0', '0', 1, 1),
(1826, 1, 'XYZ', 'PRINT S.A.S', NULL, NULL, '0', '0', '9007143888', '0', '0', 1, 1),
(1827, 4, 'FELIPE ', 'SALAZAR SANCHEZ', NULL, NULL, '3136066832', '3136066832', '94492702', 'CALLE 63 N 10-AN-33', 'NULL', 1, 4),
(1828, 4, 'EYDER JULIO', 'PINO', NULL, NULL, '3152632536', NULL, ' 4.695.971', 'KRA 39 -836', 'NULL', 1, 4),
(1829, 1, 'CRISTIAN CAMILO', 'GARCES SOTO', NULL, NULL, '0', '0', '1151951900', '0', '0', 1, 1),
(1830, 1, 'IGLESIA CRISTIANA', 'PROVISIÓN DIVINA', NULL, NULL, '0', '0', '8050265960', '0', '0', 1, 1),
(1831, 4, 'ARNOLDO ', 'RIOS M', NULL, NULL, '0', '3136362569', '10756329', 'CALLE 68 N 17-105 BELLO HORIZONTE', 'NULL', 1, 4),
(1832, 1, 'FERRE', 'LOPEZ', NULL, NULL, '4477794', '4414436', '7532772-6', NULL, NULL, 1, 1),
(1833, 1, 'TORNINORTE', 'POPULAR', NULL, NULL, '3731158', NULL, '31995758-9', 'CALLE 44 # 5N-13', NULL, 1, 1),
(1834, 1, 'EL CLAVO', 'PRODUCCIONES S.A.S', NULL, NULL, '0', '0', '900516560-3', '0', '0', 1, 1),
(1835, 1, 'FERRETODO', 'LA 16', NULL, NULL, '0', '0', '9006149369', '0', '0', 1, 1),
(1836, 3, 'MELISSA', 'LEPESQUEUR GORDILLO', NULL, NULL, '314495308', '314495308', '29684666', 'CRR 33 Nº 33-40', 'NO APLICA', 1, 3),
(1837, 1, 'AW COMERCIALIZADORA', 'SAXHO', NULL, NULL, '1', '1', '1', '1', '1', 1, 1),
(1838, 3, 'TATIANA', 'VALLEJO GARCIA', NULL, NULL, '3147409300', '3168616182', '1113640618', 'NO APLICA', 'NO APLICA', 1, 3),
(1839, 3, 'LUZ KARIME ', 'VILLADA MURILLO', NULL, NULL, '3206548153', '3206548153', '1113620940', 'CALLE 35A Nº 41-36', 'NO APLICA', 1, 3),
(1840, 1, 'STEFANY ', 'GUTIERREZ LARRAHONDO', NULL, NULL, '0', '0', '1144030418', '0', '0', 1, 1),
(1841, 1, 'CLAUDIA LIZETH ', 'RODRIGUEZ ORTEGA', NULL, NULL, '0', '0', '1143845449', '0', '0', 1, 1),
(1842, 1, 'JOSE ALBEIRO ', 'FLOREZ ESCUDERO', NULL, NULL, '0', '0', '14623023', '0', '0', 1, 1),
(1843, 1, 'CINDY JOHANA ', 'CHAVARRO TABORDA', NULL, NULL, '0', '0', '1072651135', '0', '0', 1, 1),
(1844, 1, 'NIDIA DOLORES', 'ORDOÑEZ SAAVEDRA', NULL, NULL, '0', '0', '29124648', '0', '0', 1, 1),
(1845, 1, 'MIO', 'ENCONEXION', NULL, NULL, '0', '0', '9003813153', '0', '0', 1, 1),
(1846, 1, 'DISTRIBUIDORES TUBOS Y ACCESORIOS', 'PVC', NULL, NULL, '5141747', NULL, '1.130.657.463', 'CALLE 15 # 17-20', 'NULL', 1, 1),
(1847, 2, 'MARLYN', 'VIDAL CASTRILLON', NULL, NULL, '3163628396', '3163628396', '1130613249', 'KR  1C BIS-64-41 ', 'COMERCIAL@CENAL', 1, 1),
(1848, 2, 'RODRIGO', 'GUZMAN DAVILA', NULL, NULL, '3206905949', '3206905949', '16361124', 'CL  17 36A  19 ', 'elperiodicodenuestraregion@hotmail.com', 1, 2),
(1849, 1, 'RADIO CADENA NACIONAL', 'RCN', NULL, NULL, 'NA', 'NA', 'NA', 'NA', 'NA', 1, 1),
(1850, 4, 'EVEREST ELECTRONICA LTDA', '---------------', NULL, NULL, '8392167', '8392167', '8001853261', 'CALLE 3N # 10-64', 'EVEREST_POPAYAN@LIVE.COM', 1, 4),
(1851, 4, 'JORGE ENRIQUE', 'ALVARADO', NULL, NULL, '3113944348', '3113944348', '4632536', '0', '0', 1, 4),
(1852, 4, 'SUMINISTROS MARTA HERNANDEZ', 'SUMINISTROS MARTA HERNANDEZ ', NULL, NULL, '3105083344', '3105083344', '34564831-8', 'CRA 10 17N 48', 'MARTAISABEL.HERNANDEZ@YAHOO.COM', 1, 4),
(1853, 4, 'HOSTAL CUIDAD BONITA', 'HOSTAL CUIDAD BONITA', NULL, NULL, '8394365', '3104750682', '1058933417-3', 'CRA 11 # 2 N -35', 'HOSTALCUIDADBONITAPOPAYAN@HOTMAIL.COM', 1, 4),
(1854, 1, 'NOTI5', 'S.A.', NULL, NULL, '5560612', 'NA', '805014199', 'CRA 38D 4-25', 'NA', 1, 1),
(1855, 1, 'RAMON ALBERTO', 'OCAMPO', NULL, NULL, '0', '0', '94526860', '0', '0', 1, 1),
(1856, 1, 'JORGE ANDRÉS ', 'DELGADO RIVERA', NULL, NULL, '0', '0', '1144148686', '0', '0', 1, 1),
(1857, 1, 'JOSÉ GREGORIO ', 'HERNANDEZ TRUJILLO', NULL, NULL, '0', '0', '1114819070', '0', '0', 1, 1),
(1858, 2, 'GLORIA STELLA ', 'CORDOBA HERNANDEZ', NULL, NULL, '3128909788', '3128909788', '66802634', 'KR  1 No. 4-99', 'NULL', 1, 5),
(1859, 4, 'CAROLINA', 'MUÑOZ', NULL, NULL, '3195251751', '3195251751', '1061694672', 'CALLE 3 A 15-23', 'CAROLINA23@HOTMAIL.COM', 1, 4),
(1860, 3, 'ROSSY YOHANA', 'BIASINO M', NULL, NULL, '3154582730', '3154582730', '29673264', 'CALLE 32A nO. 38-26', 'rossyyohana@hotmail.com', 1, 3),
(1861, 4, 'DIANA CATALINA', 'RUA GOMEZ', NULL, NULL, '3043915108', '3043915108', '1061735734-5', 'CENTRO', 'NO TIENE', 1, 4),
(1862, 1, 'MARTIN ALONSO', 'VEGA DAVILA', NULL, NULL, '0', '0', '74370664', '0', '0', 1, 1),
(1863, 1, 'FRANCI IRLENI', 'MENESES', NULL, NULL, '0', '0', '66988324', '0', '0', 1, 1),
(1864, 2, 'JUAN CARLOS ', 'LLANOS PEREA', NULL, NULL, '3152103192', '3152103192', '14798497', 'CALLEJON AGUACLARA SAN ANTONIO 32-37', 'NULL', 1, 2),
(1865, 3, 'EME ', 'DECORACIONES', NULL, NULL, '0', '0', '900632210-7', 'CARRERA 28 No. 36-60', '0', 1, 3),
(1866, 3, 'PRICE ', 'SMART', NULL, NULL, '3982223', '0', '900319753-3', 'CALLE 64N No. 5B-183', '0', 1, 1),
(1867, 1, 'IMPORMAQUINAS', 'M.M', NULL, NULL, '3776826', NULL, '5557789', 'AV 5 NORTE No 24N-29', 'NULL', 1, 1),
(1868, 2, 'JULIAN ANDRES ', 'RAMIREZ CRUZ', NULL, NULL, '3174643536', '3174643536', '1116237643', 'KR  33 36 59 ', 'NULL', 1, 2),
(1869, 4, 'FERRETERIA DEL CAUCA LIMITADA', 'FERRETERIA DEL CAUCA LIMITADA', NULL, NULL, '8214760', '8214760', '800200792-5', 'NA', 'NULL', 1, 4),
(1870, 1, 'PETALOS Y RAMAS', 'RAMIREZ', NULL, NULL, '3165592052', '3137948361', '31714283-5', 'CRA10No20-35', 'NULL', 1, 1),
(1871, 4, 'FERRETERIA LIDER', 'VARGAS Y HERRERA LTDA', NULL, NULL, '8208819', '8208819', '800149179-2', 'CENTRO', 'NA', 1, 4),
(1872, 3, 'MACHIMBRES', 'DEL VALLE', NULL, NULL, '2859501', '0', '10278696-6', 'CALLE 28  27-18', '0', 1, 3),
(1873, 1, 'LILIANA', 'DOMINGUEZ SABOGAL', NULL, NULL, '5140542', '3113894196', '42102467-7', 'CL 9F 24-28', 'NULL', 1, 1),
(1874, 1, 'JORGE HUMBERTO', 'RESTREPO ZAPATA', NULL, NULL, 'NO', '3226182439', '16681694', 'CALLE 68 #4N-33', 'NULL', 1, 1),
(1875, 2, 'MARIA ANGELICA', 'ESPINOSA', NULL, NULL, '3152934539', '3152934539', '1116250730', 'TULUA', 'NULL', 1, 2),
(1876, 1, 'RONALD JAVIER', 'ZAPATA USME', NULL, NULL, 'NO', '3104556475', '94540081', 'CRA 44 # 53-11', 'egon_539@hotmail.com', 1, 1),
(1877, 1, 'JOSE LUIS ', 'CURAN', NULL, NULL, '1', '3153055393', '16766451', 'CARRERA 44 No 37-78', 'NULL', 1, 1),
(1878, 4, 'MUNDO FIESTAS', 'MUNDO FIESTAS', NULL, NULL, '3202367138', '3202367138', '43287233-8', 'CALLE 8 No 5-71', 'NA', 1, 4),
(1879, 4, 'GUSTAVO ', 'MOSQUERA', NULL, NULL, '3164487210', NULL, '1061742667', 'CALLE 32 N 4-07', 'NULL', 1, 4),
(1880, 2, 'WILIAN ANTONIO ', 'MACIAS MARMOLEJO', NULL, NULL, '3117432368', '3117432368', '6115230', 'LA PRADERA ANDALUCIA Q', 'NULL', 1, 5),
(1881, 1, 'VIVERO BELLA ', 'SUIZA  56', NULL, NULL, 'N', '3206292104', '1010083284-8', 'CRA 56 No7 OESTE-199', 'NO', 1, 1),
(1882, 3, 'DICAM', 'PALMIRA', NULL, NULL, '2741441', '3122572950', '94308619-4', 'CALLE 31 No. 24-81', 'NULL', 1, 3),
(1883, 3, 'RONALD JAVIER', 'ZAPATA', NULL, NULL, '0', '3104556475', '94540081', 'CARRERA 44 No. 53-11', 'NULL', 1, 3),
(1884, 4, 'JUAN CARLOS ', 'CARVAJAL', NULL, NULL, '3186415302', NULL, '900366847-7', 'CALI', 'NULL', 1, 4),
(1885, 2, 'ANDRES ALBERTO', 'CARDONA ESPINOSA', NULL, NULL, '3003651686', '3003651686', '16936656', 'KR  27  29 61 ', 'NULL', 1, 2),
(1886, 2, 'JHON SERGIO ', 'LOAIZA QUINTERO', NULL, NULL, '2242679', '3164824803', '6499144', 'CL  30A  21 39 ', 'NULL', 1, 2),
(1887, 4, 'LUZ ADRIANA ', 'LOPEZ', NULL, NULL, '3183599064', NULL, '29178034', 'CALI', 'NULL', 1, 4),
(1888, 1, 'JORGE ELIECER', 'CARVAJAL', NULL, NULL, 'NO', '3146076439', '16637799', 'CLLE 24 10-44', 'NO', 1, 1),
(1889, 2, 'JORGE ANDRES', 'LOAIZA', NULL, NULL, '3174436931', '3174436931', '1094909869', 'KR 25 25 30', 'NULL', 1, 2),
(1890, 2, 'QUIMICOS ', 'MAELSA', NULL, NULL, '2257704', '2257704', '66716430', 'CL  29 24A 10', 'NULL', 1, 2),
(1891, 1, 'GERMAN', 'PEREZ', NULL, NULL, 'NO', '3164914542', '1144164495', 'CLLE 75 3AN-32', 'NO', 1, 1),
(1892, 1, 'LILIANA ANDREA', 'GALLEGO DUQUE', NULL, NULL, '3883956', '3173069396', '66986196', 'CLLE 54 4D-46', 'NO', 1, 1),
(1893, 1, 'JOHANA', 'REALPE OSPINA', NULL, NULL, 'NO', 'NO', '1144130383', 'NO', 'NO', 1, 1),
(1894, 1, 'ANDRES ALBERTO', 'ARANGO GIRALDO', NULL, NULL, 'NO', 'NO', '1130595270', 'NO', 'NO', 1, 1),
(1895, 1, 'ARIADNA LUCIA', 'BOLAÑOS MARTINEZ', NULL, NULL, 'NO', 'NO', '1130595270', 'NO', 'NO', 1, 1),
(1896, 2, 'CLAUDIA ', 'RAYO', NULL, NULL, '3175739898', '3175739898', '31491451', 'KR 38A  17 65 ', 'NULL', 1, 2),
(1897, 2, 'JUANCHO', '.COM', NULL, NULL, '3113411911', '3113411911', '94283948', 'MAZ 5A  CA 3', 'NULL', 1, 2),
(1898, 3, 'TOTUS SOLUCIONES', 'INTEGRALES', NULL, NULL, '6687788', '0', '900793730-5', 'AVEN 5AN No. 23DN-68', 'NULL', 1, 1),
(1899, 3, 'VIDRIOS Y ALUMINIOS', 'ANDRES', NULL, NULL, '3176211279', NULL, '0', 'CALLE 10 D No. 25-217', 'NULL', 1, 3),
(1900, 2, 'JUGLARES ', 'PRODUCCIONES', NULL, NULL, '3104556475', '3104556475', '94540081', 'KR 44 11 CIUIDAD CORDOBA', 'NULL', 1, 1),
(1901, 4, 'RONAL JAVIER ', 'ZAPATA USME ', NULL, NULL, '3104556475', NULL, '94540081', 'K 44 53-11', 'NULL', 1, 4),
(1902, 1, 'ALUMINIOS, PERFILES Y VIDRIOS', 'OSCAR', NULL, NULL, '8852465', '3155175033', '66.948.277-2', 'CRA 9 # 21-64', NULL, 1, 1),
(1903, 1, 'MISCELANEA TATI', 'NO', NULL, NULL, '8856323', 'NO', 'NO', 'CLLE 15 NU 8-103', 'NO', 1, 1),
(1904, 1, 'MANUEL ARMANDO', 'AREVALO CERON', NULL, NULL, '5555112', '3117870523', '76322021', 'CRA 129 18A-00', 'armajardines@hotmail.com', 1, 1),
(1905, 2, 'LLAVES Y CERRAJERIA ', 'EL MAGO', NULL, NULL, '3014070697', '3014070697', '16365535', 'CR 30 20 30 ', 'NULL', 1, 2),
(1906, 4, 'LIZETH NATALIA', 'INSUASTI', NULL, NULL, '3104244342', NULL, '1061723376', 'CALLE 23 N 6-46', 'NULL', 1, 4),
(1907, 4, 'SERVIEVENTOS', 'CIUDAD BLANCA ', NULL, NULL, '3206793231', NULL, '34552651', 'KRA 8 10 AN 25', 'NULL', 1, 4),
(1908, 4, 'HAROL ERNEY', 'ORDOÑEZ GOMEZ', NULL, NULL, '3137845344', NULL, '76029481', 'KRA 22 A N 100', 'NULL', 1, 4),
(1909, 4, 'fundacion proyecto ', ' ubikate', NULL, NULL, '3705506', '3186415302', '900366847-7', 'av 15 19-360', 'NULL', 1, 4),
(1910, 3, 'Aglomerados', ' de Colombia Ltda', NULL, NULL, '2855811', '0', '805004427-1', 'Carrera 26 No. 32-157', '0', 1, 3),
(1911, 2, 'JUNTA DE ACCION COMUNAL ', 'ROLDANILLO', NULL, NULL, '3188741038', '3188741038', '66708108', 'KR 15 25 41 ', 'NULL', 1, 2),
(1912, 3, 'SANDRA MILENA ', 'BEJARANO', NULL, NULL, '0', '3148725130', '66919462', 'Calle 42 No. 19-51', '0', 1, 3),
(1913, 4, 'LUCY ARACELY', 'MELO MARTINEZ', NULL, NULL, '3206290700', NULL, '52267517', 'KRA 15N 55-92', 'NULL', 1, 4),
(1914, 1, 'Edinson ', 'Girdaldo Zuluaga', NULL, NULL, '8892168', '3117247243', '94042300-7', 'cr 15 No 3-30 barrio San Pedro', 'no refiere', 1, 1),
(1915, 2, 'OSCAR EDUARDO ', 'TANGARIFE OBANDO', NULL, NULL, '3117315222', '3117315222', '1116253509', 'KR 17A 26 24', 'NULL', 1, 2),
(1916, 1, 'Redetrans', 'no', NULL, NULL, '5781919', 'no', '830038007-7', 'transv 6 #13-05', 'no', 1, 1),
(1917, 1, 'carlos', 'burgos', NULL, NULL, 'no', 'no', '94522656', 'no', 'no', 1, 1),
(1918, 1, 'ELECTRICOS DEL VALLE S.A', 'D', NULL, NULL, '5142412', '4851411', '890304345-0', 'CR 50 #9B-20', 'E', 1, 1),
(1919, 3, 'ALMACEN', 'PRAGA', NULL, NULL, '2732084', '0', '815002944-3', 'CRA 27 No. 31-33', '0', 1, 3),
(1920, 4, 'drogeria ', 'ALIANZA', NULL, NULL, '8202020', NULL, '817004260-0', 'KA 6 10 N 135', 'NULL', 1, 4),
(1921, 2, 'ERNESTO ', 'DELGADO LOPEZ', NULL, NULL, '2323364', '3154655858', '1116262055', 'CL  5C  17 27 ', 'NULL', 1, 2),
(1922, 1, 'seguridad industrial cali', 'no', NULL, NULL, '6837678', '3178947282', '1112463550', 'cra 70 a # 72bl308', 'seguinducali@yahoo.com', 1, 1),
(1923, 2, 'FUNDACION', 'PROYECTO UBIKATE', NULL, NULL, '3186415302', NULL, '900366847', 'AV. 15 OESTE 19 360 CAN', 'NULL', 1, 2),
(1924, 1, 'drogueria', 'san jorge', NULL, NULL, '6536868', 'no', '805002583', 'clle 23bn nu 3n-100', 'no', 1, 1),
(1925, 2, 'AUTOSERVICIO EL', 'CAMPESINO', NULL, NULL, '2244272', '2244272', '16340659', 'KR  22 29 02 ', 'NULL', 1, 2),
(1926, 2, 'FERRETERIA ', 'GONZALEZ', NULL, NULL, '2247989', '2247989', '900124929', 'CL  28  23 51 ', 'NULL', 1, 2),
(1927, 1, 'luis jesus', 'abadia quiñones', NULL, NULL, 'no', '3182209005', '6100395', 'cra 28 e 2 #72w-47', 'no', 1, 1),
(1928, 4, 'MARCO ANDRES ', 'DIAZ ', NULL, NULL, '3146184630', NULL, '10290963', 'KRA 17 A 2-61', 'NULL', 1, 4),
(1929, 4, 'LAVA SECO', 'EL JARDIN', NULL, NULL, '8234416', NULL, '34540114-1', 'KRA 6 A 21 N 25', 'NULL', 1, 4),
(1930, 4, 'ANGIE ALEJANDRA', 'VIVAS', NULL, NULL, '3225803428', NULL, '1061535373', 'CALLE 9 18-A 25', 'NULL', 1, 4),
(1931, 1, 'claudia ', 'valencia molina', NULL, NULL, '5537976', '3016363970', '31202338', 'clle 9c # 53-40', 'no', 1, 1),
(1932, 3, 'GLORIA', 'GARCIA GUEVARA', NULL, NULL, '0', '3125136570', '63515059', 'Calle 46 No. 43-199', '0', 1, 3),
(1933, 1, 'jessica alexandra', 'zapata lozano', NULL, NULL, 'no', 'no', '1143865003', 'no', 'no', 1, 1),
(1934, 2, 'TULUA ', 'AIRES', NULL, NULL, '3164404354', '3164404354', '94379949', 'KR 10 9 05', 'NULL', 1, 2),
(1935, 4, 'JORGE CAMILO', 'MUÑOZ ', NULL, NULL, '3178430763', NULL, '76309917', 'CALLE 17 32-12', 'NULL', 1, 4),
(1936, 1, 'brayan andres', 'campo ramos', NULL, NULL, 'no', '3164071316', '1107079334', 'no', 'no', 1, 1),
(1937, 2, 'SERVICIO INTEGRAL', 'DE ASEO ESPECIAL', NULL, NULL, '6665123', '6665123', '805007083', 'KR 24 13 387 CALI YUMBO', 'NULL', 1, 2),
(1938, 1, 'teatro', 'municipal', NULL, NULL, 'no', 'no', 'no', 'no', 'no', 1, 1),
(1939, 4, 'INFOSUR ', 'HERMES RODRIGUEZ POLO', NULL, NULL, '8242812', NULL, '12109146-0', 'CRA 6 # 9-74', 'NULL', 1, 4),
(1940, 1, 'producciones', 'son latino', NULL, NULL, 'no', 'no', '16673714-6', 'no', 'produccionessonlatinohotmail.com', 1, 1),
(1941, 4, 'JACKSON ', 'BURBANO', NULL, NULL, '3127723070', '3127723070', '76324378', 'NA ', 'NA ', 1, 4),
(1942, 2, 'COSMO', 'ELECTRY LA 23', NULL, NULL, '2257220', '2257220', '16367955', 'KR  23  21 52 ', 'NULL', 1, 2),
(1943, 4, 'HECTOR ', 'ROSERO ', NULL, NULL, 'NA ', '3136184797', '12989539', 'NA ', 'NA ', 1, 4),
(1944, 3, 'EL SABOR', 'PAISA', NULL, NULL, '0', '3164035017', '76029507-5', 'CALLE 31 No. 24-15', '0', 1, 3),
(1945, 4, 'MARIA ISLEY', 'VERGARA ', NULL, NULL, '3145755474', NULL, '34529886', 'KRA 27 A 5-104', 'NULL', 1, 4),
(1946, 2, 'ALIMENTAR', 'JOSE WILIAN ALVIS', NULL, NULL, '3167470203', '3167470203', '2942123', 'KR  23 33 67', 'NULL', 1, 2),
(1947, 1, 'javier ivan', 'muñoz orozco', NULL, NULL, 'no', 'no', '1130601128', 'no', 'no', 1, 1),
(1948, 4, 'VIDRIOS  ', 'APOLO ', NULL, NULL, '3103742102', NULL, '76313260-9', 'KRA  6 25 N-15', 'NULL', 1, 4),
(1949, 1, 'LAS TRES ', 'EMES', NULL, NULL, '1', '1', '1', 'CALLE 5 #66-18 ', '1', 1, 1),
(1950, 2, 'HUGO', 'CAICEDO BLANDON', NULL, NULL, '3146598887', '3146598887', '94255703', 'KR  9  20 42 ', 'NULL', 1, 5),
(1951, 2, 'ALMACEN EL', 'VAQUERO', NULL, NULL, '3174349659', '3174349659', '66712268', 'KR  23 26 39', 'NULL', 1, 2),
(1952, 2, 'TULUA', 'QUIMICOS', NULL, NULL, '2248965', '2248965', '16362117', 'NO REGISTRA', 'NULL', 1, 2),
(1953, 1, 'JENNY', 'TORRES TABARES', NULL, NULL, '5542572', '0', '48659980', 'CARRERA 36 No 4B-78', 'PUBLIBANDERAS@YAHOO.COM.CO', 1, 1),
(1954, 2, 'DEISY MARYURY', 'MARTINEZ', NULL, NULL, '3152168822', '3152168822', '38795127', 'CL  25 9 58 ', 'NULL', 1, 2),
(1955, 3, 'GLORIA TIGREROS', 'BARANZA', NULL, NULL, '0', '3183315813', '38859937', 'Calle 22 No. 10-36', '0', 1, 3),
(1956, 1, 'JOHN JAMES', 'BARONA OBANDO', NULL, NULL, '1', '3205866138', '94415294', NULL, NULL, 1, 1),
(1957, 1, 'Martha Cecilia', 'Ocampo Eslava', NULL, NULL, NULL, '3115177126', '31973790', NULL, NULL, 1, 1),
(1958, 1, 'ANA BOLENA', 'RAYO', NULL, NULL, '1', '3168690074', '66824531', '1', '1', 1, 1),
(1959, 2, 'JORGE ELIECER', 'OSORIO CIFUENTES', NULL, NULL, '2256278', '3155750765', '16351482', 'KR  28A  16 15', 'NULL', 1, 2),
(1960, 3, 'VARIEDADES', 'EL DESPELOTE', NULL, NULL, '2726749', '0', '16631086-9', 'Carrera 28 No. 29-69', '0', 1, 3),
(1961, 1, 'EDGAR ', 'VIERA', NULL, NULL, '1', '1', '1', '1', '1', 1, 1),
(1962, 1, 'papeleria medellin', 'ltda', NULL, NULL, '8808028', '3127648910', '8050038737', 'car9 No10-39', '1', 1, 1),
(1963, 4, 'ALEXANDRA ', 'BUITRO  GONZALEZ', NULL, NULL, '3117091360', NULL, '1061751063', 'KRA  1 B E 19-12', 'NULL', 1, 4),
(1964, 4, 'TECNI ', 'LLAVES', NULL, NULL, '8381945', NULL, '14252767', 'KRA 14 3 A 24', 'NULL', 1, 4),
(1965, 4, 'ELSA VIRGINIA ', 'TEJADA SANDOVAL', NULL, NULL, '8226023', '3128845945', '34538240-5', 'CALLE 6 # 8-69', 'NULL', 1, 4),
(1966, 3, 'JF ', 'FERROMATERIALES', NULL, NULL, '2745386', '0', '1113677644-1', 'Calle 70 No. 28-54', '0', 1, 3),
(1967, 3, 'SAN FLORIAN', 'SAS', NULL, NULL, '2871515', '0', '900458053-1', 'Carrera 27 No. 32-60', '0', 1, 3),
(1968, 4, 'FERROPINTURAS DEL CAUCA ', 'NA', NULL, NULL, '8 361062', '8 361062', '800200792-5', 'CALLE 5 # 18-22', 'NA', 1, 4),
(1969, 1, 'ZULENY ', 'MEJIA RIOS', NULL, NULL, '3174177441', NULL, '38613022', NULL, NULL, 1, 1),
(1970, 4, 'METALICAS AZ', 'NA', NULL, NULL, '8243865', '8243865', '76276595-1', 'CRA 8 # 6-24', 'NA', 1, 4),
(1971, 4, 'CvS', 'EQUIPAR  Y CIA ', NULL, NULL, '8232401', NULL, '891502316-1', 'CALLE 1 N K 4 A ', 'NULL', 2, 4),
(1972, 4, 'PIO PIO ', 'NA', NULL, NULL, '8243010', '8243010', '900703966-1', 'CENTRO', 'NA', 1, 4),
(1973, 2, 'WILLIAN ', 'CRUZ', NULL, NULL, '3207592776', '3207592776', '94356443', 'CL 5 3 21 ', 'NULL', 1, 2),
(1974, 3, 'Alba Yineth', 'Gaviria Giraldo', NULL, NULL, '0', '3117844235', '38681219', 'Calle 24 No. 21-49', '0', 1, 3),
(1975, 1, 'JUAN FELIPE', 'GALINDO MARQUEZ', NULL, NULL, '1', '1', '76045377', '1', '1', 1, 1),
(1976, 2, 'STEFANIA ', 'MOTATO GAÑAN', NULL, NULL, '3178871990', '3178871990', '1.144.176.527', 'CRA 23 NUM 32- 41 ', 'AUDITORIA@CENAL.COM.CO', 1, 1),
(1977, 1, 'VIDRIOS Y ALUMINIOS', 'SAN NICOLAS', NULL, NULL, '3155436216', '1', '1', 'CRA 7 No 17-33', '1', 1, 1),
(1978, 3, 'MONICA ', 'RAMIREZ', NULL, NULL, '0', '3158395145', '1113630379', 'LA BUITRERA ', '0', 1, 3),
(1979, 1, 'YULI DEICY ANDREA', 'ARCOS ARCOS', NULL, NULL, '1', '3156355517', '38610903', '1', '1', 1, 1),
(1980, 4, 'MARIA ALEJANDRA ', 'CHICANGANA', NULL, NULL, '8320019', '3172830408', '343166451', 'CENTRO', 'NA', 1, 4),
(1981, 4, 'CHARLES ', 'BARRAGAN', NULL, NULL, '0', NULL, '16799464', 'CALI', 'NULL', 1, 4),
(1982, 3, 'STEPHANIA', 'MOTATO', NULL, NULL, '0', '0', '1144176527', 'Calle 34 No.2 Bis-70', '0', 1, 3),
(1983, 4, 'MAXIPAPEL DISTRIBUIDORA ', 'MAXIPAPEL DISTRIBUIDORA ', NULL, NULL, '8376928', '3117401341', '1124848130-0', 'SAUSALITO', 'NA', 1, 4),
(1984, 4, 'SABESTIAN ', 'SOTELO', NULL, NULL, '3205216331', NULL, '1061746132', 'CALLE26 N 4-A 58', 'NULL', 1, 4),
(1985, 4, 'SEBASTIAN', 'SOTELO', NULL, NULL, '3205216331', NULL, '1061746132', 'CALE26 N4A 58', 'NULL', 1, 4),
(1986, 1, 'BRILLA', 'SEGUROS GENERALES SURAMERICANA', NULL, NULL, NULL, NULL, '8001676434', NULL, NULL, 1, 1),
(1987, 4, 'NAUREL ROMAN ', 'CRUZ', NULL, NULL, '8888888', '3113465768', '10565431', 'NA', 'NA', 1, 4),
(1988, 3, 'Gloria Mora', 'Zambrano', NULL, NULL, '3155194655', '0', '31148271', 'Carrera 33 No. 25-25', '0', 1, 3),
(1989, 3, 'POSTRES Y PASTELES', 'CASA BLANCA', NULL, NULL, '2738776', '0', '71002254', '0', '0', 1, 3),
(1990, 3, 'Titanium ', 'Store', NULL, NULL, '2756375', '3168306695', '0', 'Calle 31 no. 23-73', '0', 1, 3),
(1991, 3, 'FERRETERIA EL PUNTO', 'DEL CERRAJERO', NULL, NULL, '2713435', '0', '900360864-5', 'Carrera 35 No. 37-86', '0', 1, 3),
(1992, 1, 'JOSE MARINO', 'QUINTERO CHICANGANA', NULL, NULL, NULL, NULL, '1010083284', NULL, NULL, 1, 1),
(1993, 2, 'CRISTHIAN CAMILO', 'SANCHEZ ERAZO', NULL, NULL, '3104470697', '3104470697', '1112100165', 'MZ 35 CASA 18', 'NULL', 1, 2),
(1994, 3, 'FLOR MARY', 'MOSQUERA', NULL, NULL, '0', '3113313384', '43251512', 'Carrera 26 No. 67-19', '0', 1, 3),
(1995, 3, 'FERROTORNILLOS', 'LABANCERA', NULL, NULL, '0', '3153055393', '900200246-8', 'Carrera 44 No. 37-78', '0', 1, 1),
(1996, 4, 'GERSON CAMILO', 'CALVACHE', NULL, NULL, '3135391560', NULL, '1061771343', 'CALLE 17 57 N 47', 'NULL', 1, 4),
(1997, 2, 'LIBRERIA Y PAPELERIA ', 'RAYMAR ', NULL, NULL, '2236823', '2236823', '29305246', 'CL 5  5 35 ', 'NULL', 1, 6),
(1998, 2, 'CACHARRERIA ', 'AQUI ES FULGENCIO', NULL, NULL, '2258425', '2258425', '14991721', 'KR  2  26 45 ', 'NULL', 1, 2),
(1999, 2, 'TALLER ', 'VIVIANA', NULL, NULL, '3184393120', '3184393120', '1144055976', 'CL  26 22 49', 'NULL', 1, 2),
(2000, 4, 'CACHARRERIA ', 'MILENIO ', NULL, NULL, '3148037434', '3148037434', '66824745-5', 'ESMERALDA ', 'NA', 1, 4),
(2001, 2, 'LINA MARIA ', 'LOPEZ', NULL, NULL, '3103996977', '3103996977', '66784177', 'no registra', 'NULL', 1, 2),
(2002, 2, 'JENNIFER ', 'RAMIREZ PAREJA', NULL, NULL, '3157718352', '3157718352', '1116352034', 'CL  3B  22 22', 'NULL', 1, 2),
(2003, 4, 'FERRETERIA  Y ELECTRICOS JHON', 'FERRETERIA  Y ELECTRICOS JHON', NULL, NULL, '8234985', '3165280941', '1061709338', 'CALLE 3 N # 6-09', 'NA', 1, 4),
(2004, 1, 'MAYRA SUELY', 'GRUESO RIASCOS', NULL, NULL, NULL, '3043453705', '114025419', NULL, NULL, 1, 1),
(2005, 4, 'LA IMPRESORA', 'DEL CAUCA', NULL, NULL, '8222177', NULL, '900595930-2', 'KRA 3 1A N 47', 'NULL', 1, 4),
(2006, 1, 'Leonel ', 'Tamayo Sarria', NULL, NULL, '4859291', NULL, '16621116', NULL, NULL, 1, 1),
(2007, 1, 'ALISER', 'S.A.S', NULL, NULL, '3250706', NULL, '805026596', 'CARRERA 37 #14-46', 'ventas@alisersas.com', 1, 1),
(2008, 1, 'alianza estrategica en servicios nacionales ', 'sas', NULL, NULL, '8843729', NULL, '900106565-0', 'cra 8 #9-72 piso 3', NULL, 1, 1),
(2009, 4, 'ADRIANA ', 'CORDOBA', NULL, NULL, '3218401737', NULL, '272811073', 'CALLE 12 A 8A 19', 'NULL', 1, 4),
(2010, 1, 'IMPORTACIONES NIÑOLANDIA', 'SAS', NULL, NULL, '8842168', NULL, '9004462149', 'CRA9 # 13-83 LOCAL 141', NULL, 1, 1),
(2011, 3, 'EL HOGAR', 'ELECTRICO', NULL, NULL, '2733499', '0', '14947895', 'Calle 31 No. 25-66', '0', 1, 3),
(2012, 1, 'Andres ', 'Guevara', NULL, NULL, NULL, '3152160439', '1144182045', 'cra 39c #39-15', NULL, 1, 1),
(2013, 3, 'MARY YULIETH', 'AGUDELO', NULL, NULL, '0', '3117826092', '1113637360', 'Diagonal 31a No.10-90', '0', 1, 3),
(2014, 1, 'GLORIA KARINA', 'PRADO GONZALEZ ', NULL, NULL, '3857981', '3176588228', '38643185', 'calle 18a No. 55-96 cañaverales 5', NULL, 1, 1),
(2015, 1, 'JOHN FREDDY ', 'CAICEDO SOLIZ', NULL, NULL, NULL, '3014929783', '1112466986', NULL, NULL, 1, 1),
(2016, 1, 'EDISON ', 'PEREZ BECERRA', NULL, NULL, '8801910', '3012410950', '16273353', NULL, NULL, 1, 1),
(2017, 2, 'PAOLA ALEJANDRA ', 'FAJARDO ', NULL, NULL, '3147207225', '3147207225', '38790459', 'CL  34  33 44 ', 'NULL', 1, 2),
(2018, 3, 'PAULA ANDREA', 'REYES OCAMPO', NULL, NULL, '0', '3194505569', '1113646577', 'Calle 30a No. 40-30', 'vip2palmira@cenal.com.co', 1, 3),
(2019, 2, 'OLIVER ', 'CASTAÑO', NULL, NULL, '3155954787', '3128204624', '6433335', 'CL 25 33 24', 'NULL', 1, 2),
(2020, 3, 'Palmiequipos', '0', NULL, NULL, '2872541', '0', '16260237-1', 'Carrera 32 No. 27-58', '0', 1, 3),
(2021, 4, 'LADY FRANSSESCA', 'CASTRO', NULL, NULL, '3127713154', NULL, '1061704580', 'CALLE 7  39-10', 'NULL', 1, 4),
(2022, 1, 'CONJUNTO RESIDENCIAL ', 'KANELA', NULL, NULL, NULL, NULL, '146132303', NULL, NULL, 1, 1),
(2023, 4, 'WALDECY  ', 'BARBOSA DE FARIA ', NULL, NULL, '3175708847', NULL, '522967', 'CALLE 5 3-13', 'NULL', 1, 4),
(2024, 3, 'FERRETERIA', 'VILLA', NULL, NULL, '0', '0', '16251080-4', 'Carrera 28 No. 28-20', '0', 1, 3),
(2025, 2, 'SOLUCIONES ', 'INTELIGENTES', NULL, NULL, '4839633', NULL, '94511684', 'CL 2 OESTE 24A  183', 'NULL', 1, 1),
(2026, 1, 'JOSE EDUAR', 'IBARBO MORENO', NULL, NULL, NULL, '3184747873', '14476637', NULL, NULL, 1, 1),
(2027, 3, 'GINA MARCELA', 'PAZ', NULL, NULL, '0', '3126128868', '1112220470', 'Carrera 2 No. 43D-11', '0', 1, 3),
(2028, 3, 'HERNAN FELIPE', 'DIAZ', NULL, NULL, '2759764', '3014593920', '6394878', 'Calle 34 No. 42a-16', '0', 1, 3),
(2029, 1, 'WILLIAM MARTINEZ', 'M&M ADHESIVOS', NULL, NULL, '8831558', '3157798174', '94373572-3', 'CALLE 21 No 5-57 ', 'MMPUBLICIDAD1@HOTMAIL.COM', 1, 1),
(2030, 1, 'MARIA ERNESTINA', 'AMU', NULL, NULL, NULL, NULL, '31856234', NULL, NULL, 1, 1),
(2031, 4, 'EXPO ADORNOS SAS', 'EXPO ADORNOS SAS', NULL, NULL, '8381391', '8381391', '900509940-1', 'CENTRO', 'NA', 1, 4),
(2032, 4, 'CRISTIAN ANDRES', 'DAZA', NULL, NULL, '3117806097', '3117806097', '76323645', 'CALLE 1 12-45', 'NULL', 1, 4),
(2033, 2, 'FARMACEUTICOS SAN ', 'CARLOS', NULL, NULL, '2255091', NULL, '38893633', 'CL  27  38 ESQUINA', 'NULL', 1, 2),
(2034, 4, 'ALMACÉN SUPER GANGA LA 17 ', 'NA', NULL, NULL, '8227548', '3158152735', '94428060-2', 'ESMERALDA ', 'NA', 1, 4),
(2035, 4, 'TEXTILES ESMERALDA ', 'NA', NULL, NULL, '88888888', '3137620649', '76325556-5', 'ESMERALDA', 'NA', 1, 4),
(2036, 4, 'TEXTIMODA', 'NA', NULL, NULL, '8362281', '8316999', '14989056-8', 'ESMERALDA', 'NA', 1, 4),
(2037, 4, 'MASTIN PAPELERIA ', 'NA', NULL, NULL, '8225712', 'NA', '76321691-3', 'ESMERALDA', 'NA', 1, 4),
(2038, 4, 'DISTRIMODA SEXTA ', 'NA', NULL, NULL, '8888888', '3136725753', '9845129-0', 'ESMERALDA ', 'NA', 1, 4),
(2039, 4, 'TALLER FER ', 'NA', NULL, NULL, '555555555', '3127282655', '10529919-1', 'CENTRO', 'NA', 1, 4),
(2040, 4, 'PROAGRO ', 'NA', NULL, NULL, '8319278', '3174338610', '900847546-1', 'B/BOLIVAR', 'NA', 1, 4),
(2041, 1, 'GOLINE', 'COMPANY S.A.S', NULL, NULL, 'C', '3183335333', '900.656.651-5', 'CL 34 Norte No. 2BN - 23', 'C', 1, 1),
(2042, 4, 'ANDERSON ', 'TOBAR GONZALEZ', NULL, NULL, '3142273953', '3142273953', '1061703748', 'KRA 1AE 12- 24', 'NULL', 1, 4),
(2043, 2, 'PROMOCIONES Y DESCUENTOS', 'LA 27', NULL, NULL, 'NO REPORTA', 'NO REPORTA', '94152737', 'CL  27  26 48 ', 'NULL', 1, 2),
(2044, 2, 'ALMACENES', 'EL BOTON', NULL, NULL, '2251010', '2242022', '6054610', 'KR  24  27 43 ', 'NULL', 1, 2),
(2045, 1, 'Augusto ', 'Sanchez Varon', NULL, NULL, NULL, NULL, '94416924', NULL, NULL, 1, 1),
(2046, 4, 'SUPER FIESTAS MIL ', 'SUPER FIESTAS MIL ', NULL, NULL, '8317788', '3204014736', '88888888', 'CENTRO ', 'SUPERFIESTASMIL1000@GMAIL.COM', 1, 4),
(2047, 4, 'ARMANDO', 'MENDEZ', NULL, NULL, '3148339753', NULL, '10535738', 'CLL 8A #17-60', 'NULL', 1, 4),
(2048, 3, 'JORGE HUMBERTO', 'TABIMA', NULL, NULL, '2855661', '3156743375', '79675255', 'Carrera 27 No. 37a-41', '0', 1, 3),
(2049, 1, 'JOSE RAUL ', 'BARREIRO  VARGAS', NULL, NULL, '3374628', '3187130911', '14836191', 'CRA 42A #14A -33 BARRIO GUABAL', NULL, 1, 1),
(2050, 4, 'PICA PIKE', 'PICA PIKE', NULL, NULL, '8332424', '3175564175', '8888888888', 'BELALCAZAR', 'NA', 1, 4),
(2052, 3, 'DISTRIREMATES', 'THINE', NULL, NULL, '2867479', '0', '900747059-5', 'Calle 31 No. 28-59', '0', 1, 3),
(2053, 1, 'cesar ', 'video games evolutions', NULL, NULL, '3185824597', '3108945399', NULL, NULL, NULL, 1, 1),
(2054, 1, 'MAYLE KARIME', 'RIVERA ROSERO', NULL, NULL, NULL, '3175139055', '38462250-5', 'AV 5AN #23DN-68 LOCAL 225', NULL, 1, 1),
(2055, 3, 'CRISTALERIA', 'LA MEJOR LTDA', NULL, NULL, '2867503', '0', '805027305-9', '0', '0', 1, 3),
(2056, 3, 'REMATES', 'EL GAFUFO', NULL, NULL, '2873269', '0', '900529504-7', 'Carrera 28 No. 30-39', '0', 1, 3),
(2057, 2, 'PLASTIDESECHABLES', 'LA 29', NULL, NULL, '2246320', '3182702095', '1116235174', 'CL  29  23 25 ', 'NULL', 1, 2),
(2058, 1, 'klaro tecnologia avanzada', 'tecnologia avanzada en computadores', NULL, NULL, '3087349', '3166328794', '67030554', 'av. 5an #23 dn-68  pasarela local 148-220', NULL, 1, 1),
(2059, 4, 'HUGO FABIAN ', 'NARANJO ', NULL, NULL, '3206627491', NULL, '10308825', 'CALLE 6# 21 -46', 'NULL', 1, 4),
(2060, 1, 'CDISCOUNT', 'COLOMBIA SAS', NULL, NULL, NULL, NULL, '24527519361', NULL, NULL, 1, 1);
INSERT INTO `proveedores` (`id`, `sede_id`, `nombres`, `apellidos`, `created_at`, `deleted_at`, `telefono`, `celular`, `num_documento`, `direccion`, `email`, `identificacion_id`, `ciudad_id`) VALUES
(2061, 3, 'RICARD', 'CREATIVO', NULL, NULL, '2875843', '3206934342', '6646213', 'Calle 25 No. 29-03', '0', 1, 3),
(2062, 3, 'CRISTIAN DAVID', 'VARGAS', NULL, NULL, '2848745', '3126481497', '1143850745', 'Calle 22b No. 21-72', '0', 1, 3),
(2063, 1, 'ISABEL CRISTINA', 'HERRERA TORO', NULL, NULL, NULL, NULL, '66985148', NULL, NULL, 1, 1),
(2064, 2, 'DULFANERI', 'ACEVEDO JARAMILLO', NULL, NULL, '3117284012', '3117284012', '29874886', 'VEREDA GUASANO', 'NULL', 1, 2),
(2065, 2, 'KAREN MAYERLI', 'CABRERA DIAZ ', NULL, NULL, '3137341800', '3137341800', '1116260603', 'NO REGISTRA', 'NULL', 1, 2),
(2066, 2, 'LEIDY VIVIANA ', 'CORTES SOLIS', NULL, NULL, '3188298017', '3183298017', '97071310519', 'NO REGISTRA', 'NULL', 1, 2),
(2067, 2, 'DIANA MARITZA ', 'PARRA FAJARDO', NULL, NULL, '3155211592', '3155211592', '31790266', 'KR  22  14 83 ', 'NULL', 1, 2),
(2068, 2, 'TOGAS ', 'JEAN SEBASTIAN', NULL, NULL, '3717246', '3173745937', '31882934', 'KR  36 31 25 ', 'NULL', 1, 2),
(2069, 1, 'ALMACEN REFRIGERACION', 'MINERVINE', NULL, NULL, '8807968', NULL, '890101057-2', 'CALLE 14 No3-00', NULL, 1, 1),
(2070, 3, 'ERWIN PEÑA', 'BAUTISTA', NULL, NULL, '0', '3187304865', '11110445756', 'CALLE 6 No. 6b-39 apto 301', 'erwin28pu@hotmail.com', 1, 1),
(2071, 1, 'LESLY JINETH ', 'ARIAS MACIAS', NULL, NULL, NULL, NULL, '1107055430', NULL, NULL, 1, 1),
(2072, 1, 'LAURA ANGELICA', 'VIASUS CIFUENTES', NULL, NULL, NULL, '3206779687', '31711665', 'CRA 23 #11A-17', NULL, 1, 1),
(2073, 3, 'FERRO', 'MILENIO', NULL, NULL, '2738068', '0', '8401390-8', '0', '0', 1, 3),
(2074, 4, 'RUBEN DARIO ', 'MONTILLA', NULL, NULL, '3165282743', NULL, '34315809', 'KRA 11 52N 70', 'NULL', 1, 4),
(2075, 3, 'GIRO', 'PUBLICIDAD', NULL, NULL, '2757186', '3154384763', '94306236-8', 'Calle 37 No. 20-25', '0', 1, 3),
(2076, 4, 'SANTIAGO ', 'MONTENEGRO ', NULL, NULL, 'POPAYAN ', '88888888888', '1143846700', 'NA', 'SFDFDFGDFG', 1, 4),
(2077, 1, 'GRAFICAS AMERICA', 'LTDA', NULL, NULL, '8963571', '8852154', '805009992-2', 'CRA 5#18-65', NULL, 1, 1),
(2078, 3, 'ANDAMIOS Y', 'ENCOFRADOS PALMIRA', NULL, NULL, '0', '3164822086', '6407538', 'Calle 47a no. 34c-20', '0', 1, 3),
(2079, 3, 'RESTAURANTE', 'DONDE PAVA', NULL, NULL, '2727930', '3164227952', '6402339-9', 'Cra 24 No. 30-43', '0', 1, 3),
(2080, 4, 'SERGIO DANIEL ', 'MEDINA RAMIREZ', NULL, NULL, '3016262772', '3016262772', '1059904181', 'TRAN 9 57N 670', 'NULL', 1, 4),
(2081, 1, 'CARMEN ELENA', 'ANGULO IBARGUEN', NULL, NULL, NULL, NULL, '66747404', NULL, NULL, 1, 1),
(2082, 2, 'JAVIER LUBIN ', 'ROJAS AYALA ', NULL, NULL, '3185224107', '3185224107', '16946863', 'CL 42A  43 15', 'NULL', 1, 2),
(2083, 4, 'DEISY PILAR ', 'CLAROS PLAZA', NULL, NULL, '3148729421', '3148729421', '1061693017', 'TIMBIO ', 'deisyclaros@hotmail.com', 1, 4),
(2084, 3, 'JEAN CARLO', 'CASTRO ZAPATA', NULL, NULL, '2857916', '0', '1113674599', 'Calle 69A No. 26A 73', '0', 1, 3),
(2085, 1, 'STEPHANY PEÑA FLOREZ ', 'CELITEL', NULL, NULL, NULL, NULL, '11135331537', NULL, NULL, 1, 1),
(2086, 3, 'PAPELERIA', 'PALMILEE', NULL, NULL, '0', '3122200504', '29681531-6', 'CALLE 31 No. 22-75', '0', 1, 3),
(2087, 2, 'CEL.COM', 'CEL.COM', NULL, NULL, '2254618', NULL, '1116235195-9', 'CRA 26 NUM 27-18', 'NULL', 1, 2),
(2088, 1, 'SUBWAY DE OCCIDENTE', 'S.A.S', NULL, NULL, NULL, NULL, '8050197026', 'AV 4 NORTE # 7n46', NULL, 1, 1),
(2089, 1, 'VIVIANA ANDREA ', 'GONZALEZ', NULL, NULL, NULL, NULL, '1010014543', NULL, NULL, 1, 1),
(2090, 3, 'CALYPSO', 'S.A.S', NULL, NULL, '2758551', '0', '860075208-7', 'Carrera 28 No. 27-24', '0', 1, 3),
(2091, 2, 'PROECOLIM DETERGENTES INDUSTRIALES ', 'S.A.S', NULL, NULL, '2251210', '3172986566', '900.758.332-9', 'CLL 33 Nº 25-47', 'NULL', 1, 2),
(2092, 2, 'RUBIER A', 'GALVIZ CASTAÑO', NULL, NULL, '2246811', NULL, '2.942.123-7', 'CRA 21 Nº 30-41 SAJONIA', 'NULL', 1, 2),
(2093, 3, 'RUTH ESTER', 'ARZAYUS', NULL, NULL, '2724260', '3158379717', '66759882', 'Carrera 25 No. 36-39', '0', 1, 3),
(2094, 2, 'CAMILO ', 'SACIPA RODRIGUEZ X', NULL, NULL, '4868566', '3195352535', '1130604713', 'CLL 32 NUM 23-12 ', 'NULL', 1, 2),
(2095, 1, 'BIOPRINT', 'TECHNICAL PRINTERS', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1),
(2096, 4, 'ESTAMPANDO IDEAS', 'IDEAS', NULL, NULL, '8335929', '3206416022', '1061720414-8', 'KRA 15 1-11', 'NULL', 1, 4),
(2097, 3, 'Enmarkemos', 's', NULL, NULL, '2730127', '3166182435', '0', 'Calle 31 No. 23-49', '0', 1, 3),
(2098, 4, 'LUZ DARY ', 'SEMANATE PABON', NULL, NULL, '3136624285', '3136624285', '34566654', 'CALLE 2 A 38-65', 'NULL', 1, 4),
(2099, 1, 'CASA ODONTOLOGICA', 'IMPORTADORA Y COMERCIALIZADORA ', NULL, NULL, '', '', '9005526951', '', '', 1, 1),
(2100, 2, 'FERNANDO ', 'TOBON MOLINA', NULL, NULL, '2249102', NULL, '8305133-NIT805026596', 'CRA 23 NUM 32', 'NULL', 1, 2),
(2101, 4, 'JUAN CARLOS ', 'PALOMINO', NULL, NULL, '3167099880', NULL, '10544375', 'KRA 4 AE  17 B 54', 'NULL', 1, 4),
(2102, 2, 'CAFESALUD', 'EPS', NULL, NULL, '2253414', '3167497486', '800140949', 'CLL 26 NUM 33A 54', 'NULL', 1, 2),
(2104, 2, 'FADIA SALEK ', 'FATAT CASTAÑO ', NULL, NULL, '3176667835', '3176667835', '1115077798', 'CRA 6 NUM 5-37 CARMELO', 'NULL', 1, 2),
(2105, 2, 'ODALID AMPARO', ' CASTRILLON', NULL, NULL, '3168136697', '3168136697', '31203237', 'TULUA ', 'NULL', 1, 2),
(2106, 2, 'SERGIO', 'GALVIS LOPEZ', NULL, NULL, '3153944562', '3153944562', '1112101380', 'CLL 2DA SUR NUM 7-80 COCICOIMPA', 'NULL', 1, 6),
(2107, 2, 'CARLOS ALFONSO ', 'GONZALEZ  M ', NULL, NULL, '2248883', '3155558289', '16346198', 'CR 26 NUM 23-31 ', 'NULL', 1, 2),
(2108, 2, 'SANDRA MILENA ', 'BEDOYA GOMEZ ', NULL, NULL, '3168924332', '3168924332', '66803311', 'CRA 5TA NUM 16-61  ANDALUCIA', 'NULL', 1, 5),
(2109, 1, 'HENRY ARNOLD ', 'MORALES GARCIA', NULL, NULL, NULL, '3184106807', '16933790', 'CRA 28 #32-36 LA FORTALEZA', NULL, 1, 1),
(2110, 3, 'CASA ODONTOLOGICA', 'Y COMERCIALIZADORA', NULL, NULL, '8308700', '0', '900552695-1', 'Carrera 11 No. 8n-50', '0', 1, 4),
(2111, 4, 'william', 'sierra', NULL, NULL, '3136922558', NULL, '80545501', 'no', 'NULL', 1, 4),
(2112, 3, 'SANDWICH', 'CUBANO', NULL, NULL, '0', '0', '311511447', 'Carrera 28 No. 32-02', '0', 1, 3),
(2113, 1, 'Google', 'Inc', NULL, NULL, '01800 7466 453', 'Carrera 11A #94-45, ', 'na', 'Carrera 11A #94-45, Floor 8th', 'na', 1, 1),
(2114, 3, 'PAOLA ANDREA', 'QUINTERO M.', NULL, NULL, '0', '0', '1113647048', '0', '0', 1, 3),
(2115, 1, 'TATIANA ', 'MONTENEGRO GRAJALES', NULL, NULL, NULL, '3175621165', '1143846789', NULL, NULL, 1, 1),
(2116, 2, 'ANA BOLENA ', 'APONTE ', NULL, NULL, '3104214900', '3104214900', '1113036697', 'TULUA', 'NULL', 1, 2),
(2117, 1, 'JHON JAIRO ', 'BUCHELI ERAZO', NULL, NULL, NULL, NULL, 'E17244901', NULL, NULL, 1, 1),
(2118, 2, 'SYSTEMAS  Y ', 'RECARGAS JP', NULL, NULL, '2256177', '3152478774', '94388488-8', 'CLL 33 NUM 20-29', 'NULL', 1, 2),
(2119, 3, 'ANTONIO ', 'ERAZO', NULL, NULL, '0', '3113613598', '16248836', 'Calle 35 No. 28-43', '0', 1, 3),
(2120, 2, 'MAURICIO', 'MENDEZ SANDOVAL ', NULL, NULL, '3113945104', '2243072', '79625182', 'CLL 29 NUM 27-69', 'NULL', 1, 2),
(2121, 3, 'JOHNKER ANDRES', 'TORRES', NULL, NULL, '2865659', '3157923127', '94318862', 'Carrera 25 No 12A-83', '0', 1, 3),
(2122, 2, 'GLOBAL HOSPITALARIOS', 'JHS', NULL, NULL, '2251613', '3183813548', '16785037-9', 'CRA 39 NUM 27-35 ', 'NO REGISTRA', 1, 2),
(2123, 4, 'PAULA ANDREA', 'LOPEZ GOMEZ', NULL, NULL, '3206546193', '3206546193', '34322173', 'CRA 48BN 15-50', 'NULL', 1, 4),
(2124, 1, 'INCOCREDITO', 'ASOCIACION', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1),
(2125, 2, 'SERVYPAGOS', 'OUTSORCING S.A', NULL, NULL, '1234', NULL, '821003259-2', 'TULUA', 'NULL', 1, 2),
(2126, 2, 'SURTIDRIGAS', 'S.A', NULL, NULL, '2244838', NULL, '94391240-1', 'CLL 26 NUM 35-15', 'NULL', 1, 2),
(2127, 4, 'YAQUELINE', 'RIVERA LOPEZ', NULL, NULL, '3163654284', '3163654284', '25284776', 'CALLE 36N #4B -81 CASA 188', 'N/A', 1, 4),
(2128, 3, 'HECTOR LUIS ', 'SAA RUIZ', NULL, NULL, '0', '3108334046', '1113525003', 'Manzana D Casa No.2', 'hectorluissaaruiz@hotmail.com', 1, 3),
(2129, 4, 'GUILLERMO', 'CAMPO', NULL, NULL, '3163235847', '3163235847', '76319080', 'CLLE 26315-40', 'NULL', 1, 4),
(2130, 1, 'MILTON ', 'SAAVEDRA ', NULL, NULL, NULL, NULL, '94522924', NULL, NULL, 1, 1),
(2131, 1, 'SAYCO', 'SAYCO', NULL, NULL, '', '', '0000', '', '', 1, 1),
(2132, 1, 'ROA Y ABOGADOS', 'ASOCIADOS', NULL, NULL, 'NA', '3142309110', '900805333-8', 'CALLE 16 23 65', 'jeff.roat@gmail.com', 1, 1),
(2133, 1, 'RED DE SALUD DEL SURORIENTE', 'E.S.E.', NULL, NULL, '3280847', '3177639065', '805027338-1', 'CRA 43 39 A 00', 'NA', 1, 1),
(2134, 1, 'DAVID ', 'DOMINGUEZ OSPINA', NULL, NULL, NULL, NULL, '94061778', NULL, 'davdom9@hotmail.com', 1, 1),
(2135, 1, 'LADY LILIAM ', 'CORTAZAR LOZANO', NULL, NULL, NULL, NULL, '31486509', NULL, 'ladypsi77@yahoo.com', 1, 1),
(2136, 1, 'LICET INDIRA ', 'VARGAS QUIJANO', NULL, NULL, NULL, NULL, '1130606739', NULL, 'gandhy_25@hotmail.com', 1, 1),
(2137, 1, 'DEFENSA ', 'CIVIL', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1),
(2138, 2, 'SUMINISTROS ELECTRONICOS ', 'LA 28', NULL, NULL, '2249497', NULL, '66710063-0', 'CLL 28 N 24-56', 'NULL', 1, 2),
(2139, 4, 'RONALD ALEXIS ', 'GALLEGO MARTINEZ', NULL, NULL, '3122231968', '3122231968', '10302501', 'CRA 12#23-63', 'NULL', 1, 4),
(2140, 1, 'JENNY FERNANDA ', 'BAHAMON GOMEZ', NULL, NULL, NULL, '3017418940', '38604900', NULL, NULL, 1, 1),
(2141, 4, 'JAIME HOMERO', 'GALVIS TORREZ', NULL, NULL, '3206391039', '3206391039', '10518953', 'CRA 20A #8B-11', 'NULL', 1, 4),
(2142, 2, 'IVAN ANDRES', 'MUÑOZ', NULL, NULL, '3176947009', '3176947009', '14800755', 'CLL 4º A · 19-14 ', 'IVAN.MUÑOZ@co.nestle.com', 1, 2),
(2143, 3, 'PLASTIEMPAQUES', 'DE PALMIRA', NULL, NULL, '2712767', '0', '1113645107-9', 'Calle 28 No. 26-28', '0', 1, 3),
(2144, 1, 'SI ', 'S.A.', NULL, NULL, '6410000', NULL, '890301753', 'CL 12 8-13', 'NULL', 1, 1),
(2145, 3, 'SOLUCIONES', 'PRINTER', NULL, NULL, '2877453', '3177383665', '94332017-1', 'Calle 30 No. 23-36', '0', 1, 3),
(2146, 2, 'NANCY JOHANA ', 'BEDOYA RAMIREZ ', NULL, NULL, '3182217122', '3182217122', '1116234831', 'MZ 33 CASA 2 BOSQUES DE MARACAIBO', 'JOBERAZ@hotmail.com', 1, 2),
(2147, 4, 'MARIA ALEJANDRA', 'VARONA TABORDA', NULL, NULL, '8233305', '3007646134', '34316401', 'CALLE 32N  14A-62', 'alejandravarona22@gmail.com', 1, 4),
(2148, 4, 'YADDY ALEXANDRA', 'TORRES MARTINEZ', NULL, NULL, '8206188', '3155853875', '48600044', 'CARRERA 5 10-73', 'yamada@misena.edu.co', 1, 4),
(2149, 2, 'EDGAR ALONSO ', 'BRAVO COLONIA ', NULL, NULL, '3147694320', '3147694320', '1053808824', 'TULUA ', 'EABC@hotmail.com', 1, 2),
(2150, 1, 'max', 'printer', NULL, NULL, NULL, NULL, '900474722-8', 'av. 5 ana 23 dn 68 local 288', NULL, 1, 1),
(2151, 1, 'electrovariedades', 'panama', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1),
(2152, 4, 'almacen servimos', 'servimos', NULL, NULL, '8241437', '8241437', '891500555-4', 'cra 4 #5-79', 'NULL', 1, 4),
(2153, 2, 'MADERAS DEL ', 'FUTURO', NULL, NULL, '2257321', '2259664', '94369445', 'CRA 28 NUM 27-68', 'NULL', 1, 2),
(2154, 4, 'LASER Y TINTAS', 'KEN', NULL, NULL, '3126041129', '3126041129*', '345370151', 'CRA 3#1MN-15', 'NULL', 1, 4),
(2155, 1, 'COOPERATIVA INTEGRAL DE', 'TAXIS BELALCAZAR', NULL, NULL, '1', NULL, '891500277', '1', 'NULL', 1, 1),
(2156, 1, 'COOMOTORISTAS', 'DEL CAUCA', NULL, NULL, '1', '1', '891500045', '1', 'NULL', 1, 1),
(2157, 1, 'LICET INDIRA', 'VARGAS QUIJANO', NULL, NULL, '0', '3113247681', '1130606739', 'CRA 31 15 - 27', 'NULL', 1, 1),
(2158, 1, 'YICET INDIRA ', 'VARGAS QUIJANO', NULL, NULL, '1', '1', '1130606739', '1', 'NULL', 1, 1),
(2159, 1, 'DIEGO MAURICIO', 'PINZON TRUJILLO', NULL, NULL, '6608002', NULL, '5821258', 'AV 5AN 23 DN 68', 'NULL', 1, 1),
(2160, 1, 'BRIGITH NATALY', 'CHACON MURILLAS', NULL, NULL, '3924521', '3162579488', '1143832027', 'CL 43 39B 39', 'NULL', 1, 1),
(2161, 3, 'PASARELA', 'PALMIRA', NULL, NULL, '0', '0', '94556203-7', '0', '0', 1, 3),
(2162, 1, 'DAGOBERTO', 'AYALA AYALA', NULL, NULL, '1', '3156599227', '94323523', 'PALMIRA', 'NULL', 1, 1),
(2163, 3, 'ADRIANA', ' SANCHEZ VELASCO', NULL, NULL, '0', '3106026031', '29707180', 'Carrera 15 No. 5-32', '0', 1, 3),
(2164, 1, 'RODRIGO ERNESTO', 'GOMEZ AGUILAR', NULL, NULL, '1', '3105188090', '434418', 'CL 59 D 2A 13', 'NULL', 1, 1),
(2165, 1, 'JULIAN', 'ORTEGA', NULL, NULL, '3857155', '3154008827', '94537525', 'CL 42 83-20', 'NULL', 1, 1),
(2166, 1, 'SANDRA LORENA', 'CAMPAZ PUENTES', NULL, NULL, '4331382', '3155190798', '31713037', 'CRA 1 C 1 72-89', 'NULL', 1, 1),
(2167, 4, 'JULIA INES', 'SARRIA', NULL, NULL, '3117705906', '3117705906', '34559287', 'CALLE 7  21A-89', 'julis-1305@hotmail.com', 1, 4),
(2168, 3, 'BELLATELA', 'S.A', NULL, NULL, '2856129', '0', '800138082-1', 'Clle 29 No. 26a-15', '0', 1, 3),
(2169, 1, 'AGROINDUSTRIAL', 'PANIQUESO', NULL, NULL, '1', '1', '890315845-9', '1', '1', 1, 1),
(2170, 1, 'YAMILETH JUDITH', 'BASTIDAS URIBE', NULL, NULL, '1', '1', '27180529-3', '1', '1', 1, 1),
(2171, 2, 'SR WOK ', 'ORIENTAL BUFFET ', NULL, NULL, '2359880', '2359880', 'NT 900013167-2', 'LA HERRADURA TULUA', 'NULL', 1, 2),
(2172, 4, 'GIMNASIO', 'CALIBIO', NULL, NULL, '8326385', '8326406', '800096573-2', 'CALLE54 N #9-40', 'NULL', 1, 4),
(2173, 2, 'ELECTRICOS', 'LOZANO ', NULL, NULL, '3185124738', '3185124738', '16359073-8', 'CRA 26 NUM 26-55 APTO 207 ', 'NULL', 1, 2),
(2174, 1, 'EFECTIVO LTDA', '0', NULL, NULL, '0', '0', '830131993-1', '0', '0', 1, 1),
(2175, 3, 'COPY', 'FLASH', NULL, NULL, '0', '3187275339', '1113628374-7', 'Calle 31 No. 22-81', '0', 1, 3),
(2176, 4, 'DIDIER PAOLO', 'TRUJILLO BRICEÑO', NULL, NULL, '0', '3104321580', '79899001', 'CONJUNTO MONTESOL CASA  49', 'didierpaolo@gmail.com', 1, 4),
(2177, 1, 'JAIME', 'RIVERA', NULL, NULL, '0', '0', '123000', '0', '0', 1, 1),
(2178, 2, 'TECNI', 'LLAVES', NULL, NULL, '2257035', '2257035', '18598268-9', 'CLL 26A NO 22-57', 'NO REGISTRA', 1, 2),
(2179, 2, 'DISTRIBUIDORA', ' LA PLAZUELA', NULL, NULL, '2320073', 'NO REGISTRA', '900477861-7', 'CLL 28 22-56', 'NO REGISTRA', 1, 2),
(2180, 3, 'EXITO', 'PALMIRA', NULL, NULL, '2812125', '0', '0', '0', '0', 1, 3),
(2181, 3, 'INDUSTRIAS MEDICAS', 'SANAR', NULL, NULL, '2753253', '0', '16276988-4', 'Calle 41 No. 30-20', '0', 1, 3),
(2182, 3, 'DARSALUD Y', 'BIENESTAR', NULL, NULL, '2807241', '0', '835000779-8', 'Carrera 28 No. 33-97', '0', 1, 3),
(2183, 3, 'LABORATORIO CLI', 'PAOLA DELGADO', NULL, NULL, '2719593', '0', '52010220-6', 'Calle 34 No. 27-97', '0', 1, 3),
(2184, 1, 'CRISTIAN ALEJANDRO ', 'ROLDAN  PELAEZ', NULL, NULL, '0', '0', '1116249562', '0', '0', 1, 1),
(2185, 1, 'ALBA LORENA', 'ZULUAGA CANO', NULL, NULL, '0', '0', '66729379', '0', '0', 1, 1),
(2187, 1, 'CLINICA VETERINARIA', 'ZAMUDIO', NULL, NULL, '1', '1', '31832128-7', '1', '1', 1, 1),
(2188, 3, 'FERROELECTRICOS', 'S', NULL, NULL, '3163118284', '3156087677', '6645668', 'Cra. 25 No. 30-20', '0', 1, 3),
(2189, 3, 'ORBITEC SOLUCI', 'TECNOLOGICAS', NULL, NULL, '0', '0', '16836610-1', 'Carrera 25 No. 30-38', '0', 1, 3),
(2190, 1, 'DIANA LORENA', 'VILLA CALVACHE', NULL, NULL, NULL, '3017399096', '1144135528', 'CL 71F 3EN 40 B/ LARES DE COMFENALCO', NULL, 1, 1),
(2191, 1, 'CIMEX COLOMBIA', 'SAS', NULL, NULL, '1', '1', '800202146-6', '1', '1', 1, 1),
(2192, 3, 'SUPERDROGAS', 'LA 28', NULL, NULL, '2830191', '0', '35316987-9', 'Carrera 28 No. 34-04', '0', 1, 3),
(2193, 4, 'MARIA DEL CARMEN', 'COLLAZOS ASTUDILLO', NULL, NULL, '8363300', '3166954179', '34537128', 'CARRERA 7B  26A-35', 'COLLAZOSASTUDILLO@GMAIL.COM', 1, 4),
(2194, 2, 'DIEGO ALEXANDER', 'PATIÑO GIL', NULL, NULL, '3155957603', '3155957603', '1116245398', 'CLL21  NO 22-54', 'NO REGISTRA', 1, 2),
(2195, 2, 'KELLY TATIANA', 'DUQUE SANDOBAL', NULL, NULL, '3205334588', '3205334588', '1116263056', 'CRA 14 25-31', 'NO REGISTRA', 1, 2),
(2196, 1, 'GILBERTO ', 'MOSQUERA VALENCIA', NULL, NULL, '3930152', '3007785660', '14956683', NULL, 'NULL', 1, 1),
(2197, 4, 'TRANSPORTADORA LA PRENSA', 'DEL VALLE', NULL, NULL, '4853888', '7210298', '8903010674', 'cRA 32 nO 10 - 151', 'NULL', 1, 4),
(2198, 3, 'MARIA CAMILA', 'CABRERA', NULL, NULL, '2723190', '3188801630', '1113688394', 'Carrera 32a No. 66-13', '0', 1, 3),
(2199, 3, 'HOMECENTER', 'PALMIRA', NULL, NULL, '0', '0', '800242106-2', '0', '0', 1, 3),
(2200, 4, 'mueble', 'com', NULL, NULL, '8226023', '3128845945', '345382405', 'calle 68-69', 'NULL', 1, 4),
(2201, 4, 'DIANA LILIBETH', 'YASNO MUÑOZ', NULL, NULL, '3176207670', '3176207670', '1061697643', 'CALLE 26 CN #4-77', 'NULL', 1, 4),
(2202, 2, 'DISTRIBUIDORA', 'CALI PLASTICOS LTDA', NULL, NULL, '2258895', '2258895', '890312487-1', 'CLL 26 NO 22-65', 'NO REGISTRA', 1, 2),
(2203, 1, 'EYDER', 'LOPEZ DELGADO', NULL, NULL, NULL, NULL, '94426116', NULL, NULL, 1, 1),
(2204, 1, 'ANGELICA MARIA', 'CASTILLO', NULL, NULL, NULL, '3146171005', '67027286', 'CL 15 53-132 APTO 203', NULL, 1, 1),
(2205, 2, 'FERNANDO', 'TOBON MOLINA', NULL, NULL, 'NO REGISTRO', 'NO REGISTRA', '18301133', 'NO REGISTRA', 'NO REGISTRA', 1, 2),
(2206, 3, 'HARRY ', 'PLOTTER', NULL, NULL, '0', '3183480831', '0', 'Calle 30 No. 23-70', '0', 1, 3),
(2207, 2, 'BLANCA ROSA', 'NAVARRETE', NULL, NULL, '3145882570', '3145882570', '66719717', 'NO REGISTRA', 'NO REGISTRA', 1, 2),
(2208, 2, 'CARLOS ALBERTO ', 'CORREA TREJOS', NULL, NULL, '3163458507', '3163458507', 'NO REGISTRA', 'NO REGISTRA', 'NO REGISTRA', 1, 2),
(2209, 3, 'Jhon Jairo ', 'Sanchez Rosero', NULL, NULL, '0', '3135760988', '1113636920', 'Carrera 30 No. 19-16', '0', 1, 3),
(2210, 1, 'MUNICIPIO DE CALIMA', 'DARIEN', NULL, NULL, '092-2533220', '1', '890309611-8', 'CL 10 6-25', '1', 1, 1),
(2211, 1, 'DEPARTAMENTO ADMINISTRATIVO ', 'DE HACIENDA MUNICIPAL', NULL, NULL, NULL, NULL, '890399011-3', NULL, NULL, 1, 1),
(2212, 3, 'DISTRIMAFER', 'COLOMBIA', NULL, NULL, '2859743', '0', '900504525-3', 'Carrera 25 No. 29-62', '0', 1, 3),
(2213, 1, 'ADRIAN', 'VILLOTA', NULL, NULL, NULL, '3162977399', '94447741', NULL, NULL, 1, 1),
(2214, 3, 'DISTRIBUIDORA', 'PALMITEX', NULL, NULL, '2722020', '0', '900092422-3', 'Calle 30 No. 24-52', '0', 1, 3),
(2215, 3, 'JUAN DIEGO', 'ZULUAGA JAMOY', NULL, NULL, '2872047', '3104979546', '94.328.395', 'Calle 23 No. 21-78', '0', 1, 3),
(2216, 1, 'MANUELA ALEJANDRA', 'VALDERRAMA ECHEVERRY', NULL, NULL, NULL, '3164906942', '29671004', 'CL 11 43-67 B/ DEPARTAMENTAL', NULL, 1, 1),
(2217, 1, 'NATHALIA', 'VERNAZA MORALES', NULL, NULL, NULL, '3156047238', '1143829476', 'CL 8 OE 14 - 25 B/ NACIONAL', NULL, 1, 1),
(2218, 2, 'LUIS ANGEL ', 'SALDARRIAGA', NULL, NULL, '3163267763', '3163267763', '1116250313', 'MZ 62 C5 17', 'NO REGISTRA', 1, 2),
(2219, 1, 'Saara Jennifer ', 'Villarrial Camacho', NULL, NULL, NULL, '3167822118', '1087125754', NULL, NULL, 1, 1),
(2220, 1, 'ACUAZUL', 'LDC SAS', NULL, NULL, '5245111', NULL, '900384096-9', 'AV 9 A OE 38 120', NULL, 1, 1),
(2221, 2, 'CPC', 'VENTA DE TECNOLOGIA', NULL, NULL, 'NO REGISTRA', 'NO REGISTRA', '1116249929-9', 'TULUA', 'NO RG', 1, 2),
(2222, 4, 'isabel cristina ', 'giraldo', NULL, NULL, '8364059', NULL, '1061735715-5', 'u antonio nariño', 'NULL', 1, 4),
(2223, 1, 'William', 'Sierra', NULL, NULL, 'n', 'n', '80545501', 'n', 'n', 1, 4),
(2224, 4, 'CARLOS FELIPE', 'SALAZAR MUÑOZ', NULL, NULL, '3148144796', '3148144796', '76327411', 'CALLE 26AN  8-21', 'carlofelipesa@hotmail.com', 1, 4),
(2225, 4, 'JORGE IGNACIO', 'BETANCOURT ZAPATA', NULL, NULL, '8371023', '3155859132', '76308291', 'CALLE 4  26-69 CAMILO TORRES', 'JORGEIGNACIO_88@YAHOO.ES', 1, 4),
(2227, 1, 'LINA FERNANDA ', 'SARRIA', NULL, NULL, NULL, NULL, '29109114', NULL, NULL, 1, 1),
(2228, 1, 'RICARDO JAVIER ', 'RONDO CRUZ', NULL, NULL, NULL, '3148485889', '94499527', NULL, NULL, 1, 1),
(2229, 2, 'TECNODONTO', ' TALLER DE MANTENIMIENTO ', NULL, NULL, '3182285262', '3182285262', '94154611-3', 'CR 32 A NUM 24-50 ALBERNIA ', 'NULL', 1, 2),
(2230, 4, 'MARTHA ISABEL ', 'MONTILLA BURBANO', NULL, NULL, '8365030', '3104570590', '1061699027', 'Calle 13 1E-38 Las Ferias ', 'isabelita0307@gmail.com', 1, 4),
(2231, 1, 'BRILLOS', 'JOYEROS', NULL, NULL, NULL, NULL, '31862857-6', NULL, NULL, 1, 1),
(2232, 3, 'BIOPRINTERS', 'S', NULL, NULL, '3739292', '3217674946', '1058816984-7', 'Aven 5an No. 23DN-68', '0', 1, 1),
(2233, 3, 'ESTACION DE', 'PEAJE', NULL, NULL, '0', '0', '830059605-1', 'RECTA CALI', '0', 1, 1),
(2234, 1, 'BANCO DE BOGOTA', NULL, NULL, NULL, NULL, NULL, '860002964-4', NULL, NULL, 1, 1),
(2235, 3, 'LA', 'PASARELA ', NULL, NULL, '6677311', '0', '800089662', 'Aveni 5n No. 23Dn -68', '0', 1, 1),
(2236, 4, 'EPICENTRO', 'ELECTRICO', NULL, NULL, '8212505', '8212505', '16740037-5', 'CALLE 6A#18-13', 'NULL', 1, 4),
(2237, 2, 'JUAN CARLOS ', 'GONZALEZ HOYOS', NULL, NULL, '3173318102', '3173318102', '16356390', 'NO REGISTRA', 'NO REGISTRA', 1, 2),
(2238, 2, 'CARLOS ANDRES ', 'SANDOVAL ESCOBAR', NULL, NULL, 'NO REGISTRA', 'NO REGISTRA', '1115083453', 'NO REGISTRA', 'NO REGISTRA', 1, 2),
(2239, 2, 'WILDER', 'JARAMILLO', NULL, NULL, 'NO REGISTRA', 'NO REGISTRA', '94367552', 'NO REGISTRA', 'NO REGISTRA', 1, 2),
(2240, 4, 'HELDER YECIT', 'GIRON MUÑOZ', NULL, NULL, '3173750070', '3177537092', '16936869', 'CALLE 2  40A-20 ', 'yesid_giron@hotmail.com', 1, 4),
(2241, 4, 'KEVIN', 'CELULARES Y ACCESORIOS ', NULL, NULL, '3137229677', '3137229677', '10290773-4', 'PASAJE BRASILIA', 'NULL', 1, 4),
(2242, 1, 'JENNIFER', 'BELTRAN CAMAYO', NULL, NULL, '3854764', '3128594940', '1118284773', 'CRA 11D 36 58', NULL, 1, 1),
(2243, 1, 'SANDRA LUCIA', 'MUÑOZ SANCHEZ', NULL, NULL, '3926686', '3166959041', '1118288851', 'AV 3 E NTE 62 93 C.38', NULL, 1, 1),
(2244, 1, 'ANDRES ', 'MATEUS BONILLA', NULL, NULL, '39252357', '3226485021', '94532385', 'CARRERA 28-4 #72W-06 BARRIO POBLADO 2', NULL, 1, 1),
(2245, 1, 'OSCAR', 'ZULUAGA GOMEZ', NULL, NULL, NULL, NULL, '70901361-5', NULL, NULL, 1, 1),
(2246, 2, 'DISTRIBUIDORA', 'LA PLAZUELA', NULL, NULL, '2320073', 'NO REGISTRA', '9004778617', 'CLL 28 22-56', 'NO REGISTRA', 1, 2),
(2247, 4, 'YULIETH ALEXANDRA ', 'FLOREZ URREA', NULL, NULL, '3207337509', '3207337509', '1061803984', 'calle 4e#58-32', 'NULL', 1, 4),
(2248, 2, 'ANA MILENA', 'BEDOYA RAMIREZ', NULL, NULL, 'NO REGISTRA', '3183622482', '38795545', 'CLL33 21-57', 'ANA8480@HOTMAIL.COM', 1, 2),
(2249, 2, 'EL PALACIO', 'DEL MALETIN', NULL, NULL, 'NO REGISTRA', '3172544428', '116242562-8', 'CRA 22 22-26', 'NO REGISTRA', 1, 2),
(2250, 2, 'BIZ', 'TECHNOLOGY', NULL, NULL, '3015393800', '3015393800', '1094884197-8', 'CRA 23 26-72', 'NO REGISTRA', 1, 2),
(2251, 4, 'BRAYAN STIVEN ', 'SANCHEZ', NULL, NULL, '3225885120', '3225885120', '1061788107', 'CALLE 5#25-108', 'NULL', 1, 4),
(2252, 3, 'GIOVANNY ANDRES', 'PARRA P.', NULL, NULL, '3168918805', '3007735139', '14696229', 'Carrera 33a No. 32a-20', '0', 1, 3),
(2253, 1, 'ARDENT', NULL, NULL, NULL, NULL, NULL, '31378997', NULL, NULL, 1, 1),
(2254, 1, 'MARGARETH', 'ZULUAGA ARICAPA', NULL, NULL, '3345268', '3175745268', '1130674579', 'CRA 42 12C 25', NULL, 1, 1),
(2255, 1, 'SERGIO ALONSO', 'GARCIA ESCOBAR', NULL, NULL, NULL, '3152744253', '1113624323', 'CL 43 25 64', NULL, 1, 1),
(2256, 4, 'FABIO ANDRES', 'ARCOS RODRIGUEZ', NULL, NULL, '8320055', '3137711235', '1061686790', 'CALLE 1 38-36 MA. OCCIDENTE', 'andresito29@hotmail.com', 1, 4),
(2257, 3, 'GERMAN ', 'SANTAMAIRA', NULL, NULL, '0', '3145873904', '0', '0', '0', 1, 3),
(2258, 1, 'HERCULES PUBLICIDAD', 'LTDA.', NULL, NULL, '8890908', NULL, '9000164466', 'CRA 4 22 - 07', 'herculespublicidad@yahoo.es', 1, 1),
(2259, 1, 'COMERCIALIZADORA MADEN', 'LTDA.', NULL, NULL, NULL, NULL, '800004599-1', NULL, NULL, 1, 1),
(2260, 2, 'FLORISTERIA', 'LA REINA', NULL, NULL, '2258800', '3168329808', '66709684-2', 'CRA 26 NO 29-90', 'NO REGISTRA', 1, 2),
(2261, 1, 'MARLENY CASTAÑO GIRALDO', 'PANADERIA KUTTY', NULL, NULL, NULL, NULL, '43794861-8', NULL, NULL, 1, 1),
(2262, 2, 'TECNOLOGIA Y', 'REPARACION', NULL, NULL, '2248644', 'NO', '66715784-5', 'CRA 22 26-54', 'NO', 1, 2),
(2263, 1, 'ARCO IRIS', 'EVENTOS SAS', NULL, NULL, '5572390', '3007872902', '900632584-6', NULL, NULL, 1, 1),
(2264, 1, 'TORNILLOS Y PARTES', 'PLAZA SA', NULL, NULL, NULL, NULL, '800112440', NULL, NULL, 1, 1),
(2265, 3, 'FENALCO', NULL, NULL, NULL, '8983535', '8983516', '890303215-7', 'Carrera 9 No. 5-23', '0', 1, 1),
(2266, 1, 'JOSE ALEJANDRO', 'OTERO VALENCIA', NULL, NULL, '4100423', '3156878770', '16669922', 'CL 31 2 27', NULL, 1, 1),
(2267, 1, 'DISTIBUIDORA ROMY', 'SPORT', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1),
(2268, 1, 'DISTRIBUIDORA ROMY', 'SPORT', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1),
(2270, 2, 'KIKIRY', 'MUU', NULL, NULL, '2320215', 'NO REGISTRA', 'NO REGISTRA', 'CRA 26  A NO 40-78 ', 'NO REGISTRA', 1, 2),
(2271, 2, 'mke', 'technology s.a.s', NULL, NULL, '2322525', '3174390423', '805018073-7', 'CRA 26  29-81', 'NO', 1, 2),
(2272, 3, 'LUIS ANIBAL', 'ZAPATA', NULL, NULL, '0', '0', '16254469', '0', '0', 1, 3),
(2273, 1, 'HENRY DAVID', 'QUINTANA BALLESTEROS', NULL, NULL, '3068747', '3173369592', '1143860198', 'CRA 13 42-31 B/CHAPINERO', NULL, 1, 1),
(2274, 1, 'FERAR PUBLICIDAD', NULL, NULL, NULL, NULL, '3183867708', '16931806-2', NULL, NULL, 1, 1),
(2275, 4, 'JAVIER ALBERTO', 'SALAZAR TOBAR', NULL, NULL, '8210638', '3117451765', '10308649', 'Cra. 48 No. 1N-26 ', 'jsalazar@unimayor.edu.co', 1, 4),
(2276, 1, 'YURISISTEMAS', 'CASTAÑO', NULL, NULL, '6677370', NULL, '29753257-6', 'AVENIDA 5AN No 23DN-68', NULL, 1, 1),
(2277, 3, 'BLANCA ALICIA', 'CASTAÑO VARGAS', NULL, NULL, '0', '3162802649', '31883503', 'Carrera 25 No. 27-49', '0', 1, 3),
(2278, 1, 'CAROLINA', 'MONDRAGON', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1),
(2279, 1, 'HACIENDA ', 'MUNICIPAL', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1),
(2280, 3, 'ELIANA ', 'CEBALLOS GARCIA', NULL, NULL, '0', '3167500718', '1112767705', 'ALAMEDA', '0', 1, 3),
(2281, 3, 'LUZ ANGELA ', 'PALACIOS GAÑAN', NULL, NULL, '0', '0', '0', '0', '0', 1, 3),
(2282, 2, 'FEMENINAS', 'TLUA', NULL, NULL, '2257953', 'NO ', '31274268-5', 'CLL 27 NO 26-57 ', 'NO', 1, 2),
(2283, 4, 'MARIA CECILIA', 'MUÑOZ CIFUENTES', NULL, NULL, '8362641', '3004035649', '1061691464', 'CARRERA 9  27N-150 APTO 406', 'mcmc_ck@hotmail.com', 1, 4),
(2284, 4, 'CLARA NAYIBE ', 'ZUÑIGA LEDESMA', NULL, NULL, '0', '3123223929', '52737821', 'CARRERA 74N ESTE 03-33', 'clara.ledesma@hotmail.com', 1, 4),
(2285, 4, 'JAIME ALEJANDRO ', 'LOPEZ TEJADA', NULL, NULL, '8361832', '3013896729', '1092716', 'CARRERA 1A 6-33', 'alopez0810@hotmai.com', 1, 4),
(2286, 1, 'JHON DEIVY', 'TORRES OREJUELA', NULL, NULL, '3012718019', '3225106903', '1130600871', NULL, NULL, 1, 1),
(2287, 1, 'JOHNNATAN ', 'ESCOBAR HENAO', NULL, NULL, NULL, '3196625680', '1112466030', 'CL 79 8N 23 B/FLORALIA', NULL, 1, 1),
(2288, 4, 'NUEVO DIARIO DE', ' OCCIDENTE S.A', NULL, NULL, '4860555', '6816000', '805017188-0', 'CALLE 8 #5-20', 'LEGALES@DIARIOOCCIDENTE.COM.CO', 1, 1),
(2289, 2, 'LITOGRAFIA', 'IDEAS', NULL, NULL, '2304521', 'NO REGISTRA', '94391266-0', 'CRA 22 NO 14-83 ', 'NO REGISTRA', 1, 2),
(2290, 3, 'JESSICA ALEJANDRA', 'VASQUEZ OSORIO', NULL, NULL, '0', '3168438637', '1113673312', '0', '0', 1, 3),
(2291, 3, 'UNIVERSIDAD', 'EL BOSQUE', NULL, NULL, '6489000', '0', '860066789-6', 'Carrera 7B No. 132-11', '0', 1, 3),
(2292, 4, 'LEIDY ROCIO', 'ADRADA VARONA', NULL, NULL, '835 07 73', '311 634 04 53 ', '42145267', 'LA RIOJA CASA B11', 'leidyadrada@hotmail.com', 1, 4),
(2293, 1, 'LILIANA SABOGAL LILIANA', 'PRO-PUBLIC', NULL, NULL, '5140542', '3113894196', '42102467-7', 'CL 9F 24 28', NULL, 1, 1),
(2294, 3, 'BRYAM ALEXIS', 'HURTADO', NULL, NULL, '0', '3217258558', '10072630922', '0', '0', 1, 3),
(2295, 1, 'ESE ', 'SURORIENTE', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1),
(2296, 1, 'DUVAN ', 'VALENZUELA CARABALI', NULL, NULL, NULL, NULL, '1130663415', NULL, NULL, 1, 1),
(2297, 3, 'ALMACEN PINTURAS', 'PALMIRA', NULL, NULL, '2722622', '0', '31144919-4', 'Carrera 28 No. 28-29', '0', 1, 3),
(2298, 4, 'NESTOR JULIO ', 'PAZ VELASCO', NULL, NULL, '8373624', '3122022664', '17081234', 'CRA 13#3-11', 'PUBLIPAZ_43@HOTMAIL.COM', 1, 4),
(2299, 4, 'LA SEMILLA', 'ESCONDIDA', NULL, NULL, '8206437', '8206437', '900718951-7', 'CALLE 5 No 2-28', 'NULL', 1, 4),
(2300, 4, 'DISREAL', 'DEL CAUCA', NULL, NULL, '8243009', '8242068', '817004218-0', 'CARRERA 3 No 7-46', 'NULL', 1, 4),
(2301, 1, 'LEYSA JENNIFER ', 'LASSO VERGARA', NULL, NULL, '3337698', '3183624112', '1113661568', 'CL 18 61 29 B/ GUADALUPE', NULL, 1, 1),
(2302, 2, 'DIEGO ', 'CAICEDO', NULL, NULL, '3183530064', '3183530064', '6200153', 'NO REGISTRA', 'NO REGISTRA', 1, 2),
(2303, 2, 'ADRIANA', 'ARANGO', NULL, NULL, 'NO REGISTRA', '3103993009', '66727276', 'NO REGISTRA', 'NO REGISTRA', 1, 2),
(2304, 4, 'ADALBERTO', 'DORADO TUMBO', NULL, NULL, '3165017765', '3165017765', '4616245', 'CALLE 3B # 56 -07', 'salvandovidass.o.s@hotmail.es', 1, 4),
(2305, 1, 'FRIOREPUESTOS ', 'SAS', NULL, NULL, NULL, NULL, '8903102765', NULL, NULL, 1, 1),
(2306, 1, 'ELECTRICOS ', 'DEL VALLE', NULL, NULL, NULL, NULL, '8903043450', NULL, NULL, 1, 1),
(2307, 1, 'PRODUCTOS ALIMENTICIOS ', 'LA LOCURA S.A', NULL, NULL, NULL, NULL, '890328444-5', NULL, NULL, 1, 1),
(2308, 2, 'DON', 'PROSPERO', NULL, NULL, '0', '0', '805026596-0', 'NO', '0', 1, 2),
(2309, 1, 'NANO ', 'COMPUTO', NULL, NULL, NULL, NULL, '1151939918-6', NULL, NULL, 1, 1),
(2310, 2, 'MI ', 'BARRIO', NULL, NULL, '0', '0', '16359017-3', '0', '0', 1, 2),
(2311, 4, 'GRANERO', 'MILENIO ESTELAR', NULL, NULL, '8240661', NULL, '105365474', 'CARRERA 4 No 7-23', 'N/A', 1, 4),
(2312, 2, 'NATALIA', 'GIRALDO CANO', NULL, NULL, '3173083351', 'NO ', '1116271250', 'NO ', 'NO ', 1, 2),
(2313, 2, 'MARIA FERNANDA', 'VILLAREAL OSORIO', NULL, NULL, 'NO REGISTRA', 'NO REGISTRA', '1112302849', 'NO RTEGISTRA', 'NO ', 1, 2),
(2314, 1, 'NIKO ', 'SYSTEM', NULL, NULL, NULL, NULL, '16508487-3', NULL, NULL, 1, 1),
(2315, 2, 'CRISTOBAL ', 'GARZON SOTO', NULL, NULL, 'NO REGISTRA', 'NO REGISTRA', '16367233', 'NO REGISTRA', 'NO TEGISTRA', 1, 2),
(2316, 1, 'CARLOS MARIO', 'ACEVEDO RAMIREZ', NULL, NULL, NULL, '3142031606', '1151938874', 'CRA 4 C1 5N 84', NULL, 1, 1),
(2317, 2, 'NATALY ', 'HOYOS VALENCIA', NULL, NULL, 'NO REGISTA', 'NO REGISTRA', '1094933520', 'SEVILLA', 'NO REGISTRA', 1, 2),
(2318, 1, 'CLAUDIA XIMENA', 'POSSO VALENCIA', NULL, NULL, NULL, NULL, '66759979', NULL, NULL, 1, 1),
(2319, 1, 'ANGELICA MARIA', 'TRUJILLO TAMAYO', NULL, NULL, NULL, '3156935957', '29684748', NULL, NULL, 1, 1),
(2320, 3, 'SULAIMA ', 'CABRERA MELENDEZ', NULL, NULL, '0', '3163311969', '1113640539', 'Carrera 45a No. 47a-17', 'suly-8924@hotmail.com', 1, 3),
(2321, 1, 'LIBARDO ', 'SOTO', NULL, NULL, NULL, '3192361435', '14608233', NULL, NULL, 1, 1),
(2322, 4, 'ELECTRICOS SAMUEL', 'Y/O MAGALI MOLINA', NULL, NULL, '8305051', '3105133615', '345705031', 'KRA 4B No 26BN-17', 'N/A', 1, 4),
(2323, 4, 'CARLOS', 'OTALARA', NULL, NULL, '8365051', '3105133615', '10300341', 'KRA 4B No 26bn-17', 'n/a', 1, 4),
(2324, 1, 'CRISTIAN STIVEN', 'GUAUÑA GUAUÑA', NULL, NULL, NULL, '3167274044', '1112479126', NULL, NULL, 1, 1),
(2325, 2, 'TIENDA AGROMASCOTA', 'H.A', NULL, NULL, '3103712340', '3113474197', '66.803.281-1', 'CRA 5 16-71 ', 'NO REGISTRA', 1, 2),
(2326, 1, 'ANDREA', 'FLOREZ', NULL, NULL, NULL, NULL, '66986613', NULL, NULL, 1, 1),
(2327, 1, 'ARTES LISTOSTAR', 'COM', NULL, NULL, NULL, NULL, '31960056-3', NULL, NULL, 1, 1),
(2328, 2, 'ERIKA  VIVIANA', 'GIL HURTADO', NULL, NULL, 'NO', '3113067897', '1114061892', 'URB LA PAZ MZ N CASA 5', 'NO REGISTRA', 1, 2),
(2329, 2, 'TECNOLOGIA Y', 'SERVICIO', NULL, NULL, '2246701', '3128126101', '94366740-5', 'CRA 23 NO 24-26', 'NO REGISTRA', 1, 2),
(2330, 3, 'PINTURAS Y ', 'ACABADOS', NULL, NULL, '2758568', '0', '43552166', 'Calle 28 No. 26-57', '0', 1, 3),
(2331, 4, 'Javier Eduardo', 'Díaz Mosquera', NULL, NULL, '3207201500', '3207201500', '76233461', 'Kra 36 No 4A - 55', 'pedritomusic@hotmail.com', 1, 4),
(2332, 2, 'ELECTRO', 'ANDRADE', NULL, NULL, '2248759', 'NO R', '16343340-1', 'CRA 23 NO 25-09', 'NO R', 1, 2),
(2333, 4, 'YAMILE', 'HIDALGO URREA', NULL, NULL, '3117977346', '3122580039', '34325772', 'POPAYAN', 'Yamihidalgo17@hotmail.com', 1, 4),
(2334, 4, 'NUBIA ANGELICA', 'NARVAEZ ESPINOSA', NULL, NULL, '3104553037', '3104553037', '34569039', 'CALLE 53N  13-72', 'angespinosa@hotmail.es', 1, 4),
(2335, 4, 'MONICA ', 'VILLAQUIRAN CASTILLO', NULL, NULL, '3137745453', '3146652622', '34331866', 'PARQUE DE LAS GARZAS TORRE 17 APT 106', 'monivica1@hotmail.com', 1, 4),
(2336, 1, 'MADERAS RINCON', NULL, NULL, NULL, '4265777', NULL, '66970890-1', 'CRA 29 36-24', NULL, 1, 1),
(2337, 2, 'DESECHABLES', 'LA 22', NULL, NULL, '2244873', 'NO REGISTRA', '2684632-7', 'CRA 22  27-12', 'NO REGISTRA', 1, 2),
(2338, 1, 'VICTOR ALFONSO ', 'YULE MARIN ', NULL, NULL, NULL, NULL, '1130664454', NULL, NULL, 1, 1),
(2339, 3, 'DECORVIDRIO', NULL, NULL, NULL, '2723025', '0', '16280385-9', 'Calle 30 No. 30-54', '0', 1, 3),
(2340, 1, 'ANDRES FELIPE ', 'GUERRERO OCAMPO ', NULL, NULL, NULL, NULL, '1130665545-9', NULL, NULL, 1, 1),
(2341, 1, 'FERROELECTRICOS', '4TA NORTE', NULL, NULL, '3722994', '3186934429', '66902738-8', 'AV 4 N 38N 20', NULL, 1, 1),
(2342, 3, 'ALUMINIUM', NULL, NULL, NULL, '3174256203', '0', '16278334-7', 'Calle 35 No. 28-34', '0', 1, 3),
(2343, 1, 'SAARA JENNIFER', 'VILLAREAL CAMACHO', NULL, NULL, NULL, NULL, '1087125754', NULL, NULL, 1, 1),
(2344, 2, 'paisa', 'arlex', NULL, NULL, '2249172', 'NO REGISTRA', '2249172', 'cra 26  38-48', 'NO REGISTRA', 1, 2),
(2345, 3, 'FERRETERIA', 'TUBOLAMINAS', NULL, NULL, '2748982', '0', '890324420-0', 'Carrera 34c No. 42-88', '0', 1, 3),
(2346, 4, 'REPRESENTACIONES', 'LOGUS S.A.S', NULL, NULL, '4483855', '4483855', '830514992-9', 'CALLE47 # 78A-38', 'logus@une.net.co', 1, 1),
(2347, 3, 'ANDAMIOS', 'LA 47', NULL, NULL, '2812619', '3178626330', '1113649445', 'Calle 47 No. 34D-72', '0', 1, 3),
(2348, 1, 'FERROELECTRICOS ', 'LA 5 NORTE ', NULL, NULL, '4454701', NULL, '1151937097-5', 'CRA 5N #38N-19', NULL, 1, 1),
(2349, 2, 'MARLI BIVIANA', 'GOMEZ GIRALDO', NULL, NULL, 'NO REGISTRA', '3166970320', '1116238385-5', 'NO REGISTRA', 'NO REGISTRA', 1, 2),
(2350, 2, 'MANGUERAS Y PLASTICOS', 'PEÑA', NULL, NULL, '2255224', '3115893715', '5598056-7', 'CRA 23  28-62', 'NO REGISTRA', 1, 2),
(2351, 1, 'ACEL SOPORTES TV', '0', NULL, NULL, '3841664', '3173567772', '29112409', 'CL 70 NO 7B 37', '0', 1, 1),
(2352, 1, 'JORGE HERNAN', 'ALARCON', NULL, NULL, '4478502', '0', '16627999', 'CL 45 A No 7 N 41', '0', 1, 1),
(2353, 2, 'CACHARRERIA', 'EXITO', NULL, NULL, '2248193', 'NO REGISTRA', '1144038261', 'CRA 23  26-47', 'NO REGISTRA', 1, 2),
(2354, 1, 'JOHNNY ', 'PUBLICIDAD', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1),
(2355, 2, 'DIANA ', 'HORTA', NULL, NULL, 'NO', '316810709', '38792667', 'NO REGISTRA', 'NO', 1, 2),
(2356, 2, 'JONATAN ', 'ROLDAN PELAEZ', NULL, NULL, 'N', '3185828386', '1113623662', 'NO REGISTRA', 'NO REGISTRA', 1, 2),
(2357, 3, 'CARLOS ANDRES', 'CORTES CORREA', NULL, NULL, '3122521518', '3173123331', '0', 'Calle 5 No. 4-54 el Bolo', '0', 1, 3),
(2358, 4, 'RUTAS AGENCIA  DE VIAJES', 'TU PROXIMO DESTINO', NULL, NULL, '3146705177', '3103653649', '1061722326-7', 'CALLE 1 No 17 A 20', 'cadatas@hotmail.com', 1, 4),
(2359, 2, 'ALEJANDRO ', 'RODRIGUEZ ZULUAGA', NULL, NULL, 'NO REGISTRA', '3174242263', '1112103824', 'NO REGISTRA', 'NO REGISTRA', 1, 2),
(2360, 2, 'J COBO ', 'PINTURAS', NULL, NULL, '5645508', '2705051', '16353952-1', 'CRA 30 24-116 TULUA', 'NO REGISTRA', 1, 2),
(2361, 2, 'RESTAURANTE LA MEGA', 'DE DON KARLOS', NULL, NULL, '2334545', 'NO REGISTRA', '38860225-8', 'XLL 38 NO 21-25', 'NO REISTRA', 1, 2),
(2362, 2, 'JAIME', ' VASQUEZ', NULL, NULL, 'NO REGISTRO', '3128590890', '6357397', 'CLL 24 A 5 OESTE 10', 'NO REGISTRA', 1, 2),
(2363, 1, 'CAROLINA', 'RINCON ARAGON', NULL, NULL, 'S', 'S', '29178809', 'A', 'A', 1, 1),
(2364, 2, 'ERIKA TATIANA', 'ZAMBRANO VALDERRAMA', NULL, NULL, '2255992', '3183808676', '1116242876', 'CRA 15  25-23', 'NO REGISTRA', 1, 2),
(2365, 2, 'VIVIANA ', 'HOYOS TORRES', NULL, NULL, '2255992', '3165850359', '1116257316', 'CLL 26A  15-B12', 'NO REGISTRA', 1, 2),
(2366, 2, 'YENY ', 'MARTINEZ', NULL, NULL, 'NO REGISTRA', '3172255705', '41959365', 'CRA 24B 4A 04 ALAMEDA 1', 'NO REGISTRA', 1, 2),
(2367, 2, 'FERROELECTRICOS', 'EL CASTILLO', NULL, NULL, '2244809', '3172884750', '1077451482-2', 'CRA 30  15-22 ', 'NO REGISTRA', 1, 2),
(2368, 4, 'agroindustrial ', 'pan i queso', NULL, NULL, '4453551', '4453551', '890315845-9', 'la 14 av 6ta', 'NULL', 1, 1),
(2369, 2, 'PREFABRICADOS', 'DI MARIO', NULL, NULL, '2242666', '3128580700', '70781331', 'CRA 30  9-45', 'NO REGISTRA', 1, 2),
(2370, 2, 'RAFAEL', 'BERNAL CIFUENTES', NULL, NULL, 'NO REGISTRA', '3116301481', '19124329', 'CRA  23  35A-32', 'NO REGISTRA', 1, 2),
(2371, 2, 'ILUMINANDO', 'TV', NULL, NULL, 'NO', '2246855', '1116262087-6', 'CRA 23 25-16', 'NO REGISTRA', 1, 2),
(2372, 3, 'VIDRIOS JUBAL', 'S.A.S', NULL, NULL, '2724344', '2727212', '900817229-1', 'Calle 31 No. 22-39', '0', 1, 3),
(2373, 1, 'IDEAS CREATIVAS', 'PUBLICIDAD Y DISEÑO', NULL, NULL, '3854642', '3167124111', '31292103', 'CRA 5 17 54 ', 'IDEASCREATIVAS@GMAIL.COM', 1, 1),
(2374, 4, 'coomotoristas', 'del cauca', NULL, NULL, '8232700', '8231092', '891500045-1', 'calle1 bis #8-35', 'NULL', 1, 4),
(2375, 2, 'NUEVOS Y USADOS', 'LA 21', NULL, NULL, '2251875', 'NO REGISTRA', '38792246-0', 'CRA 21  24-47', 'NO REGISTRA', 1, 2),
(2376, 2, 'MAQUINAGRO ', 'DE OCCIDENTE', NULL, NULL, '2240450', 'NO ', '94365466-7', 'CLL 25 NO 19-35', 'NO', 1, 2),
(2377, 2, 'TORNICENTRO', 'FERRETERIA', NULL, NULL, '2241383', 'NO REGISTRA', '16618702-4', 'CLL 24  31-07', 'NO REGISTRA', 1, 2),
(2378, 2, 'PANELES &', 'BOARDS S.A.S', NULL, NULL, '2251368', '2262693', '900665315-3', 'CLL 25 NO 20-69', 'NO REGISTRA', 1, 2),
(2379, 2, 'SURTI ', 'COLORS', NULL, NULL, '2325957', '3156668178', '31791317-5', 'CRA 33  33-73 ESQ', 'NO REGISTRA', 1, 2),
(2380, 2, 'ALUM FER TULUA', 'S.A.S', NULL, NULL, '2251599', '2241034', '900050647-3', 'CRA 25  30-86', 'NO REGISTRA', 1, 2),
(2381, 1, 'Breylan', 'Benaly Suarez', NULL, NULL, '0', '0', '76307997', '0', '0', 1, 1),
(2382, 1, 'CARLOS HUMBERTO', 'AGUIRRE MUÑOZ', NULL, NULL, NULL, NULL, '1114881026', NULL, NULL, 1, 1),
(2383, 3, 'LORENA ', 'JIMENEZ JURADO', NULL, NULL, '0', '3182874338', '1113635940', 'Calle 34 No. 32-43', '0', 1, 3),
(2384, 2, 'FERREHOGAR', 'LA 25', NULL, NULL, '3173809137', '3175131738', '42139295-5', 'CLL 25 NO 18-05', 'NO REGISTRA', 1, 2),
(2385, 2, 'TECNICAMPO DEL CENTRO', 'S.A.S', NULL, NULL, '2246882', 'NO REGISTRA', '900765464-1', 'CRA 23 N 29A 10', 'NO REGISTRA', 1, 2),
(2386, 2, 'MADERAS GIRALDO', 'LA 26', NULL, NULL, '2254688', '3154136065', '16484810-4', 'CLL 26 NO 30-53', 'NO REGISTRA', 1, 2),
(2387, 2, 'FERROELECTRICOS', 'VILLEGAS', NULL, NULL, '2246618', '2243264', '16351089-9', 'CLL 28 23-45', 'NO REGISTRA', 1, 2),
(2388, 1, 'HUMMINGBIRD', 'COLMBIA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1),
(2389, 2, 'LA LLAVE CORAZON ', 'DEL VALLE', NULL, NULL, '2246220', '3127688761', '29868962-1', 'CLL 26 A NO 22-15', 'NO REGISTRA', 1, 2),
(2390, 3, 'MIGUEL ANTONIO', 'LARA', NULL, NULL, '2759684', '0', '16683425-5', 'Calle 32 No. 26-29', '0', 1, 3),
(2391, 4, 'MONICA ALEJANDRA', 'ZAMBRANO SOLANO', NULL, NULL, '3175920223', '3117769375', '1061738030', 'Calle 16 No. 7-38 Barrio Primero de mayo', 'aleja-zambrano@hotmail.com', 1, 4),
(2392, 2, 'LAMINAS Y HIERROS', 'FERRETERIA ', NULL, NULL, '2254718', '3175745001', '13832944-5', 'CLL 21 NO 24-67', 'NO REGISTRA', 1, 2),
(2393, 2, 'wilmer', 'aguirre', NULL, NULL, 'no registra', '3113961006', '94365388', 'nno registra', 'no registra', 1, 2),
(2394, 4, 'ADRIANA RIVERA', 'INMOBILIARIA', NULL, NULL, '8231214', 'NA', '25282273-4', 'CALLE 14N #6A-08', 'NA', 1, 4),
(2395, 1, 'FERNANDO', 'GALINDO GARCIA', NULL, NULL, '0', '0', '94320431', '0', '0', 1, 1),
(2396, 1, 'EMERSON', 'MONTAÑA NARVAEZ', NULL, NULL, '0', '0', '10345875', '0', '0', 1, 1),
(2397, 2, 'CLUB COLONIAL', 'COMFENALCO VALLE', NULL, NULL, 'NO REGISTRA', 'NO REGISTRA', '890.303.093-5', 'TULUA', 'NO REGISTRA', 1, 2),
(2398, 1, 'Maria Elena ', 'Sinisterra', NULL, NULL, '0', '0', '41599270', '0', '0', 1, 1),
(2399, 4, 'DIANA KATERINE', 'GUAÑARITA SOLARTE', NULL, NULL, '8 39 37 43', '320 760 5561', '1061745723', 'Carrera 41 No. 3-44 María Occidente', 'Kate_solarte1992@yahoo.com', 1, 4),
(2400, 4, 'MEGAELECTROIC', ',S', NULL, NULL, '3016809735', '3016809735', '76314086-8', 'CALLE 11 A No 2-64', 'N/A', 1, 4),
(2401, 1, 'HOME  SENTRY ', NULL, NULL, NULL, NULL, NULL, '860001584-4', NULL, NULL, 1, 1),
(2402, 2, 'LUZ ENEDIA ', 'SALGADO', NULL, NULL, 'no registra', '3116257230', '66709943', 'no registra', 'no registra', 1, 2),
(2403, 1, 'AR', 'MASCOTAS', NULL, NULL, '4413423', '3217039500', '1130622611-2', 'CARRAR 14 No. 40-18', NULL, 1, 1),
(2404, 1, 'KRIKA ', 'COSMETIC', NULL, NULL, '8963420', '8854345', '71653570-7', 'CRA 5 No.14-04- L123', NULL, 1, 1),
(2405, 4, 'JOSE GERMAN ', 'VELEZ', NULL, NULL, '3165423659', '3165423659', '94394152', 'CRA 28A #16-45', 'NULL', 1, 2),
(2406, 1, 'ALEXANDER ', 'CASTRO CORREA', NULL, NULL, NULL, '3154103289', '94414525', NULL, NULL, 1, 1),
(2407, 1, 'FLOR MARGARITA', 'MURILLO RIVAS', NULL, NULL, NULL, NULL, '66728573', NULL, NULL, 1, 1),
(2408, 4, 'JULIETH CATHERINE', 'RAMIREZ CUARAN', NULL, NULL, '3137952968-317300849', '3137952968-317300849', '1085266518', 'Kra 19 A N° 18b-87 B/ Pajonal. Diagonal 14', 'julitoktik@gmail.com', 1, 4),
(2409, 2, 'VIVIANA ', 'MARMOLEJO QUINTERO', NULL, NULL, 'NO REGISTRA', '3108349649', '111303960', 'CRA 7 NO 1-154', 'NO REGISTRA', 1, 2),
(2410, 3, 'ELIZABETH ', 'DAZA RAMIREZ', NULL, NULL, '0', '3152972308', '1118303104', 'Transv 7a No. D28-84', '0', 1, 3),
(2411, 1, 'VITRAL STUDIO ', 'LUIS GOMEZ', NULL, NULL, NULL, '3172388963', NULL, NULL, NULL, 1, 1),
(2412, 4, 'drogueria', 'farnatcol', NULL, NULL, '8350555', '8350555', '0034341427-8', 'cra 48 #1-49', 'NULL', 1, 4),
(2413, 1, 'BOLSA DE EMPLEO', 'COMPUTRABAJO', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1),
(2414, 4, 'GAMA', '3D', NULL, NULL, '3136520507', '3104406205', '34561933', 'Kra 5 PASAJE COMERCIAL LA QUINTA LOCAL 51', 'gama_3d@hotmail.com', 1, 4),
(2415, 2, 'SUPPORT', 'DENT', NULL, NULL, '3164211993', '3185357650', '1116265417-7', 'CLL 33 NO  25-52', 'NO REGISTRA', 1, 2),
(2416, 4, 'JHONATHAN GUILLERMO', 'BURBANO MENESES', NULL, NULL, '3128425358', '3147939804', '15817345', 'CALLE 20N  4B-11 ', 'jbm_07@hotmail.com', 1, 4),
(2417, 4, 'MAVYS ', 'MARTINEZ MUÑOZ', NULL, NULL, '0', '300 596 2012', '25787891 M/ría', 'Calle 32C # 86 31 Las Mercedes', 'mavys731@gmail.com', 1, 4),
(2418, 2, 'MEDINSUMOS DE OCCIDENTE', 'LIBER GAITAN GIL', NULL, NULL, '2245668', 'NO REGISTRA', '18391944-1', 'CLL 27 N 34-14 ', 'NO REGISTRA', 1, 2),
(2419, 1, 'CARLOS ALBERTO', 'RUIZ RESTREPO', NULL, NULL, NULL, '3104001375', '16883864', NULL, NULL, 1, 1),
(2420, 2, 'HILDEBRANDO ', 'TREJOS', NULL, NULL, 'NO REGISTRA', '3207254437', '6484815', 'CLL 28 N 6BIS 15', 'NO REGISTRA', 1, 2),
(2421, 3, 'CSI', 'Consultores', NULL, NULL, '3824773', '0', '900096360-3', 'Calle 42 No. 85E-38', '0', 1, 3),
(2422, 3, 'CACHARRERIA ', 'LOS MARINILLOS', NULL, NULL, '0', '0', '31484229-9', 'Calle 30 No. 25-22', '0', 1, 3),
(2423, 1, 'Gabriel Enrique', 'Diaz Gonzalez', NULL, NULL, NULL, NULL, '1111746667', NULL, NULL, 1, 1),
(2424, 2, 'DROGAS ALBERTO ', 'CARDONA ESPINOZA', NULL, NULL, '2309456', '2256688', '6500366-8', 'CLL 25  16-02', 'NO REGISTRA', 1, 2),
(2425, 1, 'G&S', 'COMPUTER', NULL, NULL, NULL, NULL, '1130665545-9', NULL, NULL, 1, 1),
(2426, 2, 'RAFAEL ELIECER', 'BERNAL CIFUENTES', NULL, NULL, '2243768', '3116301481', '19124329', 'CRA 23  35A 32 BARRIO SAJONIA', 'NO REGISTRA ', 1, 2),
(2427, 1, 'PVC ACABADOS', 'S.A.S', NULL, NULL, '3429766', NULL, '900264227-2', 'CALLE 6 No 31-29', 'WWW.PVCACABADOS.COM', 1, 1),
(2428, 2, 'MUNDI ', 'TORNILLOS ', NULL, NULL, '2323410', 'NO ', '41211787-2', 'CLL 24  NO 30-16', 'NO', 1, 2),
(2429, 3, 'NUEVO DIARIO', 'OCCIDENTE', NULL, NULL, '0', '0', '805017188', '0', '0', 1, 3),
(2430, 1, 'JUAN JOSE ', 'URIBE ECHEVERRY', NULL, NULL, NULL, '3104860373', '93375349', NULL, NULL, 1, 1),
(2431, 2, 'LUIS NOE', 'MONTAÑO CHINGATE', NULL, NULL, 'NO REGISTRA', '3105054767', '6464913', 'NARIÑO', 'NO', 1, 2),
(2432, 2, 'CIELO ', 'ARTECO', NULL, NULL, '2255627', 'NO REGIOSTRA', '94477640-3', 'CRA 24 NO 23-65', 'NO REGISTRA', 1, 2),
(2433, 1, 'EYNER ', 'VILLAMARIN ALVAREZ', NULL, NULL, NULL, '3122829171', '16833186', 'CALL 1C OESTE No. 82B28 ALTO NAPOLES', NULL, 1, 1),
(2434, 1, 'RICHARD ', 'HENAO DONNEYS', NULL, NULL, NULL, '304242269', '16829900', 'CALLE 31No37-11 SAN CARLOS', NULL, 1, 1),
(2435, 4, 'VARIEDADES ', 'MARTINEZ', NULL, NULL, '3186075524', '3186075524', '31712271-8', 'CALLE 6#5-90', 'NULL', 1, 4),
(2436, 1, 'SHAGGY FERNANDO', 'SHAGGY FERNANDO', NULL, NULL, '4679900', '0', '14413562740', 'AV 6B # 23 - 73', '0', 1, 1),
(2437, 3, 'FABIOLA ', 'HURTADO PERNIA', NULL, NULL, '0', '3105239600', '29705668', 'Cra 44a No. 44-121', '0', 1, 3),
(2438, 2, 'MONTANO', 'S.A.S', NULL, NULL, '2248188', '3165262099', '900377924', 'CRA 23 28-30', 'NO REGISTRA', 1, 2),
(2439, 2, 'Rosa Maria ', 'Yela Garcia', NULL, NULL, '2311690', '3184787676', '38.791.798', 'dig 23 9-11 chimonangos', 'no registra', 1, 2),
(2440, 4, 'RICARDO CESAR', 'MORENO YAÑEZ', NULL, NULL, '3118963093', '3118963093', '76327748', 'CALLE 70N  5A-31 LA PAZ', 'rcdo_77@hotmail.com', 1, 4),
(2441, 2, 'VENTA DE REPUESTOS', 'SERVITECNIFRIO', NULL, NULL, '2321331', '3155667328', '6357250-1', 'CLL 25  27-03', 'NO REGISTRA', 1, 2),
(2442, 3, 'CACHARRERIA', 'EL SOL', NULL, NULL, '2722064', '0', '800150320-7', 'Carrera 26 No. 29-29', '0', 1, 3),
(2443, 2, 'MERCEDES', 'CUNDUMI SINISTERRA', NULL, NULL, 'NO ', '3216093325', '38796771', 'CRA 19 32-62 ', 'NO REGISTRA', 1, 2),
(2444, 4, 'SUPER TIENDA ', 'SOLARTE', NULL, NULL, '8361905', '8361905', '34329791-5', 'CALLE 8 n 4-79', 'NULL', 1, 4),
(2445, 1, 'ELBA MARIA', 'GOMEZ VOLERAS', NULL, NULL, '0', '3175005705', '29116304', 'CRA 2C # 40 - 49', 'emgmaria@yahoo.com', 1, 1),
(2446, 2, 'TIENDA', 'MULTICELL 26', NULL, NULL, '2248830', '3104640395', '94153784-4', 'CRA 26  27-28 ', 'NO REGISTRA', 1, 2),
(2447, 2, 'MEGAVIDRIOS', 'LA 26', NULL, NULL, 'NO REGISTR', '3138660203', '14893638-0', 'TULUA', 'NO', 1, 2),
(2448, 4, 'JESUS FABIAN', 'SANCHEZ SANCHEZ', NULL, NULL, '3145260599', '3145260599', '94041527', 'KRA 21 A No 07 A - 05', 'NULL', 1, 4),
(2449, 4, 'CRIDTHIAN EDUARDO', 'ESPITIA LOPEZ', NULL, NULL, '8211005', '0', '1144028380-2', 'KRA 17 No 5-09', 'NULL', 1, 4),
(2450, 4, 'CRISTIAN EDUARDO', 'ESPITIA LOPEZ', NULL, NULL, '8211005', '**', '1144028380-1', 'KRA 17 No 5-09', 'NULL', 1, 4),
(2451, 4, 'FESTY EVENTOS', 'WILLIAM RICARDO OCAMPO', NULL, NULL, '8241404', '3153717753', '1061721857-5', 'KRA 8 No 6-10', 'NULL', 1, 4),
(2452, 4, 'SURTI ELECTRICOS R.E.', 'DAVIS ANDRES ROJAS ', NULL, NULL, '8392497', '3167073102', '1061776549-4', 'CALLE 5 No 14-28', 'NULL', 1, 4),
(2453, 4, 'WILLIAM', 'MEJIA', NULL, NULL, '320682207', '320682207', '10543256', 'CALLE 7 No 20A-33', 'NULL', 1, 4),
(2454, 4, 'HUGO HERNAN', 'DIAGO', NULL, NULL, '***', '****', '10295442', '****', 'NULL', 1, 4),
(2455, 4, 'maxi', 'pan', NULL, NULL, '8373014', '8373014', '70901049-1', 'cra 9 #18-16', 'NULL', 1, 4),
(2456, 1, 'LAVANDERIA ', 'DELUJO', NULL, NULL, '5564568', '3217880597', '0', 'CRA 35 # 4B - 10', 'NULL', 1, 1),
(2457, 3, 'EDINSON', 'QUINTERO TELLO', NULL, NULL, '0', '3155152623', '94305953', 'Calle 40a No. 41-53', '0', 1, 3),
(2458, 4, 'WILLIAM SANTIAGO', 'GUZMAN CHAMORRO', NULL, NULL, '8329780', '3113545248', '1061696470', 'TRANSVERSAL 9  56N-97 CASA 3 BLOQUE 2', 'santiagoguzman516@gmail.com', 1, 4),
(2459, 4, 'LIDA PATRICIA', 'DE LA TORRE', NULL, NULL, '3493709969', '3195101280', '63468487', 'CARERRA 1 27BN-33 YANACONAS', 'ldelatorrediaz76@gmail.com', 1, 4),
(2460, 1, 'Maria de los angeles', 'Fajardo hoyos', NULL, NULL, '3793626', '3148428551', '1143841926', 'clle 2 oeste # 24bis -20', 'mari_fa14@hotmail.com', 1, 1),
(2461, 4, 'ALMACEN CASA LIMPIA POAYAN', 'Y/O LMA CONSUELO PAZ REINOSO', NULL, NULL, '8242087', '0', '34538414-1', 'CALLE 6 No 9-71', 'NULL', 1, 4),
(2462, 3, 'DROGUERIAS ', 'UNIDAS PARRA', NULL, NULL, '2723500', '0', '900539401-1', 'Calle 30 No. 24-86', '0', 1, 3),
(2463, 3, 'SILLAS Y', 'SILLAS', NULL, NULL, '0', '0', '0', 'Carrera 24 No. 32-24', '0', 1, 3),
(2464, 1, 'COOPETRANS', 'TULUA', NULL, NULL, '0', '0', '891900254-9', '#', 'NULL', 1, 1),
(2465, 4, 'DISTRIBUIDORA CERAMICAS ', 'MODERNA DEL CAUCA', NULL, NULL, '8373197', '8211048', '900130730-0', 'CALLE 5# 15-20', 'NULL', 1, 4),
(2466, 4, 'FERROELECTRICOS ', 'CONSTRUCASA', NULL, NULL, '8381415', '3128312164', '34561852-9', 'CALLE 4 #16-17', 'NULL', 1, 4),
(2467, 1, 'LUZ ADRIANA', 'GONZALEZ HERNANDEZ', NULL, NULL, '0', '3166329795', '1116247711', 'AVE 2A # 28 - N28', 'adri-2506@hotmail.com', 1, 1),
(2468, 2, 'WILLIAM ', 'CRUZ ', NULL, NULL, '3155399288', '3207592776', '94356443', 'ANDALACIA', 'NO REGISTRA', 1, 2),
(2469, 1, 'JOSE JULIAN', 'GOMEZ VOLVERAS', NULL, NULL, '0', '3178950863', '14839487', '#', 'NULL', 1, 1),
(2470, 3, 'LOS TRES', 'REYES', NULL, NULL, '2737699', '3184969272', '31160681-4', 'Calle 30 No. 21-38', '0', 1, 3),
(2471, 4, 'LAVA AMIGA', 'ALQUILER DE LAVADORAS', NULL, NULL, '3108269115', '3113213286', '1061710217', 'POPAYAN', 'NULL', 1, 4),
(2472, 2, 'MONICA JOHANA ', 'GALVIS', NULL, NULL, '3183758043', 'NO REGISTRA', '1116237455', 'MZ 14 CS 44 BOSQUES ', 'NO REGISTR', 1, 2),
(2473, 2, 'DPOSITO DE ARENA ', 'LA 8', NULL, NULL, '2250981', '3185603739', '94393699-5', 'CRA 28 CON QUIN ', 'NO REGISTRA', 1, 2),
(2474, 2, 'DEPOSITO DE ARENA ', 'LA 28', NULL, NULL, '2250981', '3186503739', '94393699-5', 'CRA 28 CON 38 ESQUINA', 'NO REGISTRA', 1, 2),
(2475, 2, 'JOSE', 'QUINTERO', NULL, NULL, 'NO REGISTRA', '3207295685', '1010083284', 'CRA 56 7 OESTE 1-99 CALI', 'NO REISTRA', 1, 1),
(2476, 2, 'estacion de servicio', 'el divino niño jesus', NULL, NULL, '2249449', 'no registra', '94391893-9', 'cll 48  27a-13', 'no registra', 1, 2),
(2477, 4, 'ALMACEEN', 'LA LIMPIEZA', NULL, NULL, '8241733', '3147418052', '76333598-8', 'KRA 8 No 6-51', 'N/A', 1, 4),
(2478, 4, 'ALMACEN LA ', 'LIMPIEZA', NULL, NULL, '8241733', '3147418052', '76333598-8', 'KRA 8 No 6-51', 'N/A', 1, 4),
(2479, 3, 'TRANSPORTADORA', 'PRENSA DEL VALLE', NULL, NULL, '4853888', '0', '890301067-4', 'Cra 32 No. 10-151', '0', 1, 1),
(2480, 2, 'RICURAS DEL PANDEBONO', 'EL PRINCIPE', NULL, NULL, '2253122', 'NO REGISTRA', '21872806-7', 'CLL 41  25-99', 'NO REGISTRA', 1, 2),
(2481, 4, 'la casa de ', 'la balinera', NULL, NULL, '8232914', '8232914', '10538650-5', 'cra 9#9-08', 'NULL', 1, 4),
(2482, 4, 'la casa de ', 'los empaques', NULL, NULL, '3117422536', '8235927', '10549402-1', 'calle 1#10-30', 'NULL', 1, 4),
(2483, 4, 'chapas y manijas ', 'la 11', NULL, NULL, '8320476', '8320476', '34543509-0', 'cra 11#2-08', 'NULL', 1, 4);
INSERT INTO `proveedores` (`id`, `sede_id`, `nombres`, `apellidos`, `created_at`, `deleted_at`, `telefono`, `celular`, `num_documento`, `direccion`, `email`, `identificacion_id`, `ciudad_id`) VALUES
(2484, 1, 'Santiago Roberto ', 'Luna Muñoz', NULL, NULL, 'd', 'd', 'd', 'd', 'd', 1, 1),
(2485, 4, 'ALEEX JULIAN', 'VELEZ ALEGRIA', NULL, NULL, '0', '3175020091', '76324076', 'KRA 2 No 16 N -18 CASA 93', 'AJVELEZ_A@YAHOO.COM', 1, 4),
(2486, 4, 'ALEX JULIAN', 'VELEZ ALEGRIA', NULL, NULL, '0', '3175020091', '76324076', 'ALTOS DE TULCAN KRA 2 No 16 N - 18 CASA 93', 'ajvelez_a@yahoo.com', 1, 4),
(2487, 3, 'Salamandra', 'Estampados', NULL, NULL, '2856294', '3162453175', '14696476-1', 'Calle 28 No. 31-75', '0', 1, 3),
(2488, 3, 'MUEBLARIA Y ', 'COLCHONERIA JAR', NULL, NULL, '2727726', '0', '0', 'Calle 29 No. 23-32', '0', 1, 3),
(2489, 4, 'LEONARDO CASAS PRADO', 'Y/O DISTRIBUIDORA Y PAPELERA LUZ', NULL, NULL, '8221218', '0', '763213981', 'CALLE 5 No 5-85', 'NULL', 1, 4),
(2490, 2, 'AGRICULTURA Y SERVICIOS ', 'S.A', NULL, NULL, '2325454', 'NO REGISTRA', '805020771-6', 'CRA 40  27-04', 'NO REGISTRA', 1, 2),
(2491, 2, 'FERRETERIA ANDAMIOS', 'JAIRO ARANGO', NULL, NULL, '2256948', '3007803371', '75035006', 'CLL 27 NO  18-26', 'NO REGISTRA', 1, 2),
(2492, 4, 'LEIDY YOHANA', 'FAJARDO ARDILA', NULL, NULL, '0', '320325 9873', '1061767049', 'Carrera 19D #11ª 40 Pajonal', 'leidyf93@hotmail.com', 1, 4),
(2493, 2, 'SERVI ENVIOS', 'EXPRESS', NULL, NULL, 'NO ', '316444769', '16364968-4', 'CRA 25  30-12', 'NO REGISTRA', 1, 2),
(2494, 4, 'distribuidora ', 'superior del cauca', NULL, NULL, '8224171', NULL, '25559621-5', 'calle 4#11-16', 'NULL', 1, 4),
(2495, 4, 'CURADURIA URBANA No, 2', 'ALEXANDER RICARDO VARGAS', NULL, NULL, '8205262', '*', '76310351-7', 'CALLE 5 No 10-46', '***', 1, 4),
(2496, 4, 'COPICENTRO', 'PATRICIA TRUJILLO ALZATE', NULL, NULL, '8241970', '***', '34537577-7', 'CALLE 5 No 7-04', '***', 1, 4),
(2497, 4, 'FERRETERÍA ', 'ELÉCTRICA', NULL, NULL, '0', '3144266969', '1085273432-1', 'CALLE 4 No 14-37 B/ CADILLAL ', '**', 1, 4),
(2498, 1, 'JULY MARCELA', 'LASSO LOPEZ', NULL, NULL, '4887530', '3156953376', '1144052337', 'cra 47a # 40 - 22 ', '#', 1, 1),
(2499, 2, 'SANDRA MILENA', 'VELAZQUEZ', NULL, NULL, 'NO REGISTRA', '3166787121', '31644254', 'CLL 14 B 15 B 39- LA CAMPIÑA', 'NO REGISTRA', 1, 2),
(2500, 4, 'almacen ', 'el rey', NULL, NULL, '8243463', '8243463', '617000290-8', 'calle 7#4-08', 'NULL', 1, 4),
(2501, 4, 'PRINTDIAMAND', '/ DIEGO ROA ROA', NULL, NULL, '8314666', '3186901088', '79567569-1', 'CARRERA 6 A No 3N-45 LOCAL 2 CENTRO COMERCIAL LA E', '**', 1, 4),
(2502, 1, 'SOLUCIONES INTEGRALES ', 'SERV&PLAG', NULL, NULL, '5247895', '3167589120', '16287438-2', 'cra 23No. 9b-59 barrio bretaña', 'info@fumiextintores.com.co', 1, 1),
(2503, 4, 'GERSON ', 'ESCOBAR', NULL, NULL, '3166359464', '3166359464', '16761793', 'CALLE 27a #86-46', 'NULL', 1, 1),
(2504, 4, 'ADRIANA KARINA ', 'VALENCIA AGREDO', NULL, NULL, '3172644653', '3163447070', '34700146', 'CALLE 10  5-12 EMPEDRADO', 'adkaval21@hotmail.com', 1, 4),
(2505, 4, 'ARQUIDIOCESIS DE POPAYAN ', 'PARROQUIA DE SAN FRANCISCO', NULL, NULL, '8240160', '0', '817002387-8', 'CALLE 4 No 9 -32', '**', 1, 4),
(2506, 4, 'GEOVANY ANDRES ', 'ARIAS', NULL, NULL, '3117495266', '3117495266', '10291265', 'VEREDA DE TORRES', 'N/A', 1, 4),
(2507, 1, 'LUIS HERNANDO', 'CASTAÑO ANGEL', NULL, NULL, '0', '3146101055', '16944935', 'Cra 98c # 54 - 86', '#', 1, 1),
(2508, 4, 'CUEROS VÉLEZ', 'S.A.S.', NULL, NULL, '8323062', '**', '800191700-8', 'CENTRO COMERCIAL CAMPANARIO', '**', 1, 4),
(2509, 4, 'DAVID', 'SUASA', NULL, NULL, '3503094947', '****', '10295916', '****', '***', 1, 4),
(2510, 1, 'CONCENTRADOS', 'LA MASCOTA', NULL, NULL, '4326796', '0', '38640142-1', 'CLLE 72 No. 3 n  - 03 ', '#', 1, 1),
(2511, 4, 'SERVI-FIESTA', 'GRACIELA ARAGON SARRIA', NULL, NULL, '8241493', '***', '25252699-1', 'KRA 10 A No 6-37', 'N/A', 1, 4),
(2512, 4, 'DISTRIFLORES LA CUARTA', 'ANA MILENA RIVERA ', NULL, NULL, '8210749', '**', '34552570', 'CALLE 4 No 21-32', '**', 1, 4),
(2513, 1, 'GENITH YOMARA', 'RODRIGUEZ DIAZ', NULL, NULL, '0', '3226420502', '66755643', 'CRA 41 # 48A - 08 ', '2', 1, 1),
(2514, 4, 'CAROLINA', 'ZUÑIGA', NULL, NULL, '3146311648', '0', '34319346', 'CALLE 4 No 9-79', '**', 1, 4),
(2515, 4, 'GRUPO CORDOBA S.A.S.', 'CARANTANTA', NULL, NULL, '8367977', '0', '900281222-8', 'KRA 9 No 11N-18', '**', 1, 4),
(2516, 2, 'JORGE ELIECER ', 'ACEVEDO DIAZ', NULL, NULL, 'NO REGISTRA', '3182200924', '94319666', 'CLL 29 NO 32-43 ', 'JORGE5606@HOTMAIL.COM', 1, 2),
(2517, 4, 'LUZ EIDI', 'TRUJILLO POLINDARA', NULL, NULL, '320 716 38 72', '320 716 38 72', '1.061.686.079', 'CALLE 3  3-116', 'luet26@hotmail.com', 1, 4),
(2518, 2, 'Rocio', 'Morales Lopez', NULL, NULL, '2248644', 'no registra', '66715784-5', 'cra 22  26-54', 'noregistra', 1, 2),
(2519, 4, 'JUAN DAVID', 'SALAZAR CATAMUSCAY', NULL, NULL, '3218497183', '3218497183', '1061734410', 'CARRERA 21A  2-32 PANDIGUANDO', 'jdasalazarc@gmail.com', 1, 4),
(2520, 4, 'ANA MILENA ', 'SALAZAR', NULL, NULL, '311 394 2638', '311 394 2638', '34.556.913', 'CRA 9#3-22', 'NULL', 1, 4),
(2521, 2, 'PUBLI', 'SCREEN', NULL, NULL, '2336969', '3154933979', '16364081-7', 'CRA 27 NO 23-46', 'NO REGISTRA', 1, 2),
(2522, 2, 'MARIANA ', 'GIRALDO AGUDELO', NULL, NULL, 'NO REGISTRA', '3107477415', '1118391067', 'BARRIO EL BOSQUE', 'NO REGISTRA', 1, 2),
(2523, 3, 'MAIRA ALEJANDRA ', 'RIVERA GOMEZ', NULL, NULL, '0', '3108745742', '1114888489', 'CRA 24 NO. 10-57', '0', 1, 3),
(2524, 3, 'ANGELICA MARIA ', 'SANCHEZ ', NULL, NULL, '0', '3207936208', '29685824', 'CALLE 12 NO. 14-76', '0', 1, 3),
(2525, 2, 'SOLO ACABADOS', 'LA 23 ', NULL, NULL, '2242015', 'NO REGISTRA', '66729205-3', 'CRA 23 NO 25-26 ', 'NO REGISTRA', 1, 2),
(2526, 3, 'SUPER ', 'EVENTOS', NULL, NULL, '3116358246', '3177921094', '1113624527-9', 'CRA 33 NO. 64-74', '0', 1, 3),
(2527, 2, 'DANIEL ', 'OSPINA PASIMINIO', NULL, NULL, 'NO REGISTRA', '3117461269', '1116275088', 'CRA 18 19-22', 'NO REGISTRA', 1, 2),
(2528, 2, 'JOHN ALEJANDRO', 'SALGADO MONTOYA', NULL, NULL, 'NO REGISTRA', '3155075513', '1007877642', 'CRA 28 10B-09  SANTA RITA', 'NO REGISTRA', 1, 2),
(2529, 2, 'FERROELECTRICOS ', 'JH', NULL, NULL, '2249899', '3172844089', '66724486-3', 'CRA 25  29-37', ' NO REGISTRA', 1, 2),
(2530, 2, 'FERRETERIA ANDAMIOS Y EQUIPOS', 'ARANGO', NULL, NULL, '2324800', '3007803371', '94389535-0', 'CLL 27 18-26', 'NO REGISTRA', 1, 2),
(2531, 1, 'TORNILLOS', 'CALI #5', NULL, NULL, '4481380', '3', '16740143-8', 'CRA 1 # 31 - 02', '@', 1, 1),
(2532, 3, 'EDGAR ', 'RINCON', NULL, NULL, '0', '3155791623', '16281524', 'CRA 31 No. 45A-04', '0', 1, 3),
(2533, 4, 'VIDRIOS Y ALUMINIOS ', 'LA LUNA ', NULL, NULL, '8237321', '8237321', '76313263', 'CRA.6 N.6N-23 B.BOLIVAR ', 'NULL', 1, 4),
(2534, 4, 'javier', 'solis', NULL, NULL, '3155512342', '3155512342', '76331201', 'cra 14 #10a 22', 'NULL', 1, 4),
(2535, 4, 'GRUPO EDITORRIAL', 'EL PERIODICO S.A.', NULL, NULL, '7310048   7312799', '0', '900169179-0', 'CALLE 18 No 47-160', 'N/A', 1, 4),
(2536, 4, 'FREDY', 'NAVIA', NULL, NULL, '3173506675', '3173506675', '10546399', 'YANACONAS BLOQUE G CASA 15', 'NULL', 1, 4),
(2537, 2, 'GRISCOLDEXT', 'EXTINTORES', NULL, NULL, '3168318269', '3207015559', '794316622', 'TRANSV  28 28B  17B', 'NO REGISTRA', 1, 2),
(2538, 1, 'ELECTRO ', 'ILUMINACIONES CYD SAS', NULL, NULL, '3854195', '3166884296', '900816880-2', '·', '@', 1, 1),
(2539, 4, 'ZONA DE ', 'IMPACTO', NULL, NULL, '8320526', '3148832874', '34563130', 'KRA 6#6-28', 'N.A', 1, 4),
(2540, 4, 'MARISOL', 'RENGIFO RENGIFO ', NULL, NULL, '3126918178', '3126918178', '1061798733', 'TUNEL BAJO ETAPA 2', 'N/A', 1, 4),
(2541, 4, 'MERCEDES ', 'HOYOS ', NULL, NULL, '3207431905', '3207431905', '25298327', 'CRA 12BARRIO LOMAS DE L VIRGEN ', 'NULL', 1, 4),
(2542, 1, 'JHON JAIRO ', 'GAVIRIA TORRES', NULL, NULL, NULL, '3165099781', '94455452', 'CALL 29B no 6A-52 B/TERRON', NULL, 1, 1),
(2543, 4, 'SEFORA', 'CHANCHI', NULL, NULL, '**', '3148305733', '25637778', 'VEREDA EL TUNEL', '**', 1, 4),
(2544, 1, 'GERSON DARIO', 'GOMEZ ', NULL, NULL, NULL, '3145091727', '94265192', 'CRA 42BIS No.16-58 b/GUABAL', NULL, 1, 1),
(2545, 4, 'JENNY LUCIA', 'FAJARDO MUÑOZ', NULL, NULL, '300-4044661', '320-7592324', '25278519', 'Calle 2 #21 D 32', 'jelufa@hotmail.com', 1, 4),
(2546, 1, 'JESUS ANDRES', 'HERNANDEZ ESPADA', NULL, NULL, '0', '3174275592', '16288995', 'CRA 141 # 22 - 80 ', '@', 1, 1),
(2547, 2, 'ALONSO ', 'OSPITIA', NULL, NULL, '3163669210', '3163669210', '16347108', 'BARRIO SAN FRANCISCO', 'NO REGISTRA', 1, 2),
(2548, 1, 'ASTROMOTOS ', 'S.A', NULL, NULL, 's', 's', '805016864-7', 's', 's', 1, 1),
(2549, 2, 'MISCELANEA Y VARIEDADES', 'PAPIROS', NULL, NULL, 'NO REGISTRA', '3207516335', '6500054-5', 'CLL 30  18-08', 'NO REGISTRA', 1, 2),
(2550, 1, 'CIMEX COLOMBIA', 'SAS', NULL, NULL, '5245362', '3153817834', '800202146-6', 'AVE 3 BIS NORTE 23D N 23', '@', 1, 1),
(2551, 4, 'ALUMINIOS', 'ESTELAR', NULL, NULL, '8310626', '**', '1061723659-9', 'CARRERA 11 No 2-58 P-1', 'dabeibandrade@gmail.com', 1, 4),
(2552, 4, 'TORNILLOS ', 'BAUTISTA', NULL, NULL, '8235170', '**', '25266761-1', 'CALLE 1 N  No 8-34', 'NULL', 1, 4),
(2553, 1, 'NELSON FABIAN', 'ORTIZ JARAMILLO', NULL, NULL, '0', '3162069806', '87102953', 'CLL 62 B # 1A 9 - 365 APT 3D24', '@', 1, 1),
(2554, 4, 'EL PUNTO DE', 'CARO', NULL, NULL, 'N/A', 'N/A', '34319346-8', 'CALLE 4 9-63', 'NULL', 1, 4),
(2555, 1, 'ESTANTES Y VITRINAS', 'CALI DAD', NULL, NULL, '0', '3164567093', '1144188266-3', 'CRA 8 NO. 20- 55', '@', 1, 1),
(2556, 1, 'BOLSAS ', 'MARINILLA', NULL, NULL, '8853169', '0', '14465429-2', 'CRA 9 No. 20 - 62', '@', 1, 1),
(2557, 1, 'CHOCO ', 'RECREA', NULL, NULL, '3963045', '3182356370', '1143851299-6', '·#', '@', 1, 1),
(2558, 1, 'MINISTERIO ', 'SALUD PUBLICA', NULL, NULL, '0', '0', '0', '0', '0', 1, 1),
(2559, 1, 'EDWARD ', 'BENITEZ AGUDELO', NULL, NULL, '0', '3122218675', '6322303', 'FINCA BONANZA ROSO VALLE', '@', 1, 1),
(2560, 2, 'HECTOR FABIO ', 'HENAO DIAZ', NULL, NULL, '3161226630', '3161226630', '94365712', 'CRA 27 A  27 BIS -45', 'NO REGISTRA', 1, 2),
(2561, 2, 'CARLOS HERNESTO', 'HURTADO', NULL, NULL, 'NO REGISTRA', '3142378839', '1116439040', 'CRA 36  20-10 ALVERNIA', 'NO REGISTRA', 1, 2),
(2562, 2, 'EDWIN ALBERTO', 'VARELA', NULL, NULL, 'NO REGISTRA', '3218205984', '94150105', 'CRA 30  38-59', 'NO REGISTRA', 1, 2),
(2563, 2, 'ALFONSO ', 'VELAZQUEZ MUNARES', NULL, NULL, 'NO REGISTRA', '3005333884', '1116235206', 'MZ 16 CS 13 BOSQUES', 'NO REGISTRA', 1, 2),
(2564, 1, 'SONIA PATRICIA', 'CARVAJAL MORALES', NULL, NULL, '0', '3147615663', '1097400262', 'AVE 2B NORTE # 32 AN  - 33', '@', 1, 1),
(2565, 1, 'CASA MEDICA Y', 'DROGUERIA ALKAMY', NULL, NULL, '5543732', '3137543339', '1151955441-2', 'CLL 5 # 38 - 65 ', '@', 1, 1),
(2566, 3, 'PAPELERIA', 'FERNANDEZ', NULL, NULL, '2723866', '0', '94504687-5', 'CALLE 29 No. 30-58', '0', 3, 3),
(2567, 4, 'WILLIAM', 'GIRON', NULL, NULL, '3122512332', '3122512332', '76312370', 'CARRERA 27 No 4 A -15', 'N/A', 1, 4),
(2568, 2, 'FABIAN AUGUSTO', 'LEON', NULL, NULL, 'NO REGISTRA', '3135416996', '1116268520', 'NO REGISTRA', 'NO REGISTRA', 1, 2),
(2569, 3, 'LLEILYN YURANI', 'MARTINEZ CRIOLLO', NULL, NULL, '0', '3148783480', '1112225469', 'CRA 15 No. 6-70', '0', 1, 3),
(2570, 3, 'LUISA MARIA ', 'MONCADA CUESTA', NULL, NULL, '0', '3147712042', '1053800798', 'CRA 23 No. 17-91', '0', 1, 3),
(2571, 2, 'NUTRI', 'BRUNO', NULL, NULL, '3157379313', '3117264031', '147999613', 'CRA 22 NO 21A-10 ', 'NO REGISTRA', 1, 2),
(2572, 2, 'MEYEMBER', 'ORTIZ', NULL, NULL, 'NO REGISTRA', '3014510346', '1062282016', 'CRA 22 41- 04', 'NO REG', 1, 2),
(2573, 1, 'JORGE ENRIQUE', 'HUERTAS', NULL, NULL, '3796633', '3146685728', '16745418-0', '#', '@', 1, 1),
(2574, 3, 'AMBIENTES DE', 'APRENDIZAJE S.A.S', NULL, NULL, '3730004', '3104156446', '900699497-1', 'CALLE 4 No. 25-16', '0', 1, 3),
(2575, 1, 'DIEGO FERNANDO', 'GUERRERO CUELLAR', NULL, NULL, '0', '3116155739', '14838991', 'AVE 2 BIS # 34 N 25', '@', 1, 1),
(2576, 2, 'JOSE ALBERTO', 'VARELA QUIÑONEZ', NULL, NULL, '2251567', '3163246793', '16350065', 'CLL 26 A 26-49 LAS DELICIAS', 'NO REGISTRA', 1, 2),
(2577, 2, 'PARASOLES ', 'EL OASIS', NULL, NULL, '2254656', '3162894514', '66718520-1', 'CRA 28 NO 21-42 ', 'NO REGISTRA', 1, 2),
(2578, 3, 'JESUS EDILSON ', 'OSPINA DIAZ', NULL, NULL, '0', '3113653561', '4860125', 'CALLE 24A T16-83', '0', 1, 3),
(2579, 2, 'LUZ ADRIANA ', 'ARIAS TORO', NULL, NULL, 'NO REGISTRA', '3155019248', '99022617091', 'CLL 36 27-38 SALESIANOA', 'NO REGISTRA', 1, 2),
(2580, 4, 'talabarteria ', 'popayan ', NULL, NULL, 'N/A', 'N/A', 'N/A', 'popayan ', 'N/A', 1, 4),
(2581, 3, 'MEGA', '1000 Y 2000', NULL, NULL, '2899000', '0', '0', 'CALLE 29 No. 26-10', '0', 1, 3),
(2582, 3, 'GRUPO MUNDIAL', 'D Y G', NULL, NULL, '3740006', '3192057347', '0', 'CENTRO COMERCIAL PASARELA CALI LOCAL 128', '0', 1, 3),
(2583, 3, 'RESTAURANTE', 'PINACOTECA', NULL, NULL, '2852616', '0', '94321257-5', 'CRA. 24 No. 21-21', '0', 1, 3),
(2584, 3, 'DIEGO ORLANDO', 'MURILLO VELEZ', NULL, NULL, '4894968', '3116216025', '94306521', 'CALLE 63 No. 7V 25 APTO 403A', '0', 1, 3),
(2585, 2, 'ALBA LUCIA ', 'GONZALEZ ESPINOSA', NULL, NULL, '2237035', '3108201256', '29305861', 'CRA3 4-30', 'NO REGISTRA', 1, 2),
(2586, 2, 'JOHN ALEXANDER ', 'VALENCIA PINEDA', NULL, NULL, 'NO', '3153404787', '1116233642', 'CALL 22  1A-18', 'NO', 1, 2),
(2587, 4, 'LUIS', 'HOYOS', NULL, NULL, '3206524931', '3206524931', '1061687229', 'NA', 'NA', 1, 4),
(2588, 4, 'TRIGO', 'MIEL', NULL, NULL, '8241797', '3154814190', '36998666-9', 'KRA 9 No 5-81', 'N/A', 1, 4),
(2589, 2, 'CENTRO VETERINARIO', 'SERVICANES', NULL, NULL, '2320899', '3206554150', '29881455-2', 'CRA 27 NO 23-41', 'NO REGISTRA', 1, 2),
(2590, 2, 'ANGEL ', 'A.G', NULL, NULL, '2250004', 'NO REGISTRA', '70904452-0', 'CALLE 27  24-39', 'NO REGISTRA', 1, 2),
(2591, 2, 'KOBA COLOMBIA ', 'S.A.S', NULL, NULL, '3865060', 'NO REGISTRA', '900276962-1', 'CRA 31  NO 34-11', 'NO', 1, 2),
(2592, 2, 'MAPRO', 'QUIMICOS', NULL, NULL, '2247232', '3103821167', '1116238739-9', 'CRA 25  29-07', 'NO REGISTRA', 1, 2),
(2593, 2, 'VITAL GROUP', 'TULUA S.A.S', NULL, NULL, '3217490003', '3188140202', '9008809067', 'CRA 24  22-59 LOCAL 1 ', 'NO REGISTRA', 1, 2),
(2594, 2, 'CARLOS ALBERTO', 'RAMIREZ CANO', NULL, NULL, '2254321', '3177777467', '6498631', 'CLL 21 30-55 NVO ALVERNI', 'NO REGISTRA', 1, 2),
(2595, 1, 'LEYSA JENNIFER', 'LASSO', NULL, NULL, NULL, NULL, '1113661568', NULL, NULL, 1, 1),
(2596, 2, 'VARIEDADES', 'LA 22', NULL, NULL, 'NO ', 'NO ', '64996961', 'CLL 27  CRA 22 ESQ', 'NO ', 1, 2),
(2597, 2, 'SANDRA JIMENA', 'GUERRERA TRASLAVIÑA', NULL, NULL, 'NO', '3173785555', '42159214', 'CRA 39A 13-02 MORALES', 'NO', 1, 2),
(2598, 2, 'CACHARRERIA Y PAPELERIA', 'ROCKY ', NULL, NULL, 'NO REGISTRA', 'NO REGISTRA', '303891362', 'CLL 26 A NO 11-03 ', 'NO REGISTRA', 1, 2),
(2599, 3, 'FERRETERIA Y CACHARRERIA ', 'LOS PAISAS', NULL, NULL, '0', '3154875108', '0', 'CALLE 30 No. 24-01', '0', 1, 3),
(2600, 4, 'VICTORIA EUGENIA ', 'CORDOBA LASSO', NULL, NULL, '8236060', '3128892199', '34570575', 'cARRERA 9  16n-30', 'vcserviciossas@hotmail.com', 1, 4),
(2601, 2, 'JHONATAN ', 'ROLDAN PELAEZ', NULL, NULL, 'NO REGISTRA', '3172966322', '1113623662', 'CRA 23 A  NO 05-32', 'NO REGISTRA', 1, 2),
(2602, 1, 'COMERSEGINDUSTRIAL', 'SAS', NULL, NULL, '8830029', '0', '800194982-1', 'CRA 6 # 20-56', '@', 1, 1),
(2603, 2, 'JAIME HERNAN', 'VELAZQUEZ ARANGO', NULL, NULL, '2245759', '3175171471', '16363107', 'CRA 23 34-36', 'NO REGISTRA', 1, 2),
(2604, 4, 'EDISON ANDRES', 'ARTEAGA LOPEZ', NULL, NULL, '3003480966', '3003477767', '1061707298', 'CALLE 56N  TRANSV 9-66 SANTA LICIA', 'edison_arteaga@outlook.com', 1, 4),
(2605, 4, 'OCTI ', 'EXPRESS', NULL, NULL, '3218780533', '3218780533', '34560619', 'BIBLIOTECA RAFAEL MAYA', 'papeleriaoctiexpress@hotmail.com', 1, 4),
(2606, 3, 'OLIMPICA', 'S.A.', NULL, NULL, '0', '0', '890.107.487-3', 'CALLE 47 No. 33-01', '0', 1, 3),
(2607, 1, 'INK TECH ', 'RECARGAS Y SUMINISTROS', NULL, NULL, '4044347', '3003859047', '94432671-8', 'AVE 2DN No. 24n - 06', '@', 1, 1),
(2608, 1, 'CASA BANQUETES', 'LUCY GARCIA', NULL, NULL, '4455862', '3127253448', '0', 'CRA 27A # 36A -72B', '@', 1, 1),
(2609, 2, 'DIANA ISABEL', 'AGUALIMPIA', NULL, NULL, '3188026340', 'NO REGISTRA', '31932060', 'CRA 39  18-34', 'NO REGISTRA', 1, 2),
(2610, 3, 'ENVIA', 'MENSAJERIA Y MERCANCIAS', NULL, NULL, '0', '0', '8000185306-4', '0', '0', 1, 3),
(2611, 2, 'KELLY JOHANA ', 'VASQUEZ RAMIREZ', NULL, NULL, 'NO ', '3128327027', '98110619219', 'CLL 13 48-38', 'NO REGISTRA', 2, 2),
(2612, 4, 'LUIS ALBERTO', 'MEDINA SOLARTE', NULL, NULL, '8316112', '3136674026', '76305127', 'CALLE 5  27-14', 'luisalbertomedinas@gmail.com', 1, 4),
(2613, 1, 'INMOBILIARIA ALAIDOS ', 'S.A.S CENTURY', NULL, NULL, '5146172', '0', '900483426-0', 'CR 66 #11-70', '0', 1, 1),
(2614, 2, 'JOSE LUIS', 'UNAS GOMEZ', NULL, NULL, '2261215', '3188276650', '94154162', 'CLL 28C 37-50', 'NO REGISTRA', 1, 2),
(2615, 3, 'KAREN DAHANA', 'BENJUMEA ALVAREZ', NULL, NULL, '0', '3174493651', '1113683786', 'CALLE 33A No. 35-33', '0', 1, 3),
(2616, 3, 'MARINELA', 'MONTENEGRO DIAZ', NULL, NULL, '0', '3006642302', '29659141', 'CARRERA 21A No. 17-32', '0', 1, 3),
(2617, 1, 'COMPUHOLLYWOOD', 'COMPUHOLLYWOOD', NULL, NULL, '3399789', '4853726', '38563965-6', 'CRA 56 No. 10-33', '@', 1, 1),
(2618, 2, 'JAIME', 'MILLAN', NULL, NULL, 'NO REGISTRA', 'NO REGISTRA', '10973898189', 'NO REGISTRA', 'NO REGISTRA', 1, 2),
(2619, 4, 'YULIANA ', 'PEÑA', NULL, NULL, '3504119203', '3105151896', '1061767187', 'TRANSVERSAL33 C No 16A - 06 BARRIO 31 DE MARZO', 'N/A', 1, 4),
(2620, 2, 'ALMACEN', 'JAMAICO ', NULL, NULL, '3154234636', '3168493529', '12195086-6', 'CRA 21 NO  27-19 CEL 3154234636', 'NO REGISTRA', 1, 2),
(2621, 2, 'EVENTOS Y TRANSPORTES ', 'JPI', NULL, NULL, '2247617', '3182823085', '11166260025-0', 'CLL 32 A NO  22-35', 'NO REGISTRA', 1, 2),
(2622, 4, 'PEDRO', 'VELASCO MENDEZ', NULL, NULL, '3225069912', '3225069912', '1061689018', 'CALLE 71 AN No 7B - 51 BARRIO LA PAZ', 'N/A', 1, 4),
(2623, 2, 'RUSBEL', 'VELASQUEZ', NULL, NULL, 'NO', '3206711230', '94365411', 'CRA 26 -31,28 SAJONIA', 'NO REGISTRA', 1, 2),
(2624, 2, 'MARTHA LILIANA ', 'GIRON', NULL, NULL, 'NO REGISTRA', '3185277110', '1114058836', 'CLL 5  1A-70', 'NO REGISTTRA', 1, 2),
(2625, 2, 'GUILLERMO', 'PULGARIN', NULL, NULL, 'NO REGISTRA', 'NO REGISTRA', '891400819-4', 'NO REGISTRA', 'NO REGISTRA', 1, 2),
(2626, 4, 'DISEÑOS', 'PROFESIONALES', NULL, NULL, '6504420', '**', '1130671638-1', 'AV 4 NORTE #20N-23 BARRIO VERSALLES', 'ventas@profesionales.co', 1, 1),
(2627, 4, 'PRINTTINK', 'PEDRO JOAQUIN ROA ROA', NULL, NULL, '8242309', '**', '94515167', 'CALLE 7 No 6-23', 'N/A', 1, 4),
(2628, 3, 'ZULENY', 'MEJIA RIOS', NULL, NULL, '0', '0', '38613022', '0', '0', 1, 3),
(2629, 4, 'ANDRES', 'ROMAN BRAVO ', NULL, NULL, '3164953014', '3164953014', '1061739279', 'CALLE 10 #14-40 ', 'wndresromwn@hotmail.com', 1, 4),
(2630, 2, 'KELLY JOHANA ', 'VALENCIA PISO', NULL, NULL, 'NO REGISTRA', '3226669012', '1115087655', 'CRA 17 14-37 SUCRE- BUGA', 'NO REGISTRA', 1, 6),
(2631, 1, 'COSMOFIESTAS', 'SAS', NULL, NULL, '3799155', NULL, '900635553-1', 'AV 6N 33-06', NULL, 1, 1),
(2632, 2, 'MARTHA CECILIA', 'ESPINOSA CARDONA', NULL, NULL, 'NO REGISTRA', '3156135728', '66728153', 'CLL 30  34-428 VICTORIA', 'NO REGISTRA', 1, 2),
(2634, 1, 'papeleria ', 'mundo color ', NULL, NULL, NULL, NULL, '805024493-1', NULL, NULL, 1, 1),
(2635, 1, 'FOTODO STUDIO', 'ALEJANDRA ROGEBER', NULL, NULL, '3733916', '3153582214', '16680741-4', 'CARRERA 39 #27-43', 'D', 1, 1),
(2636, 1, 'ALEX', 'HORA LOCA', NULL, NULL, '1', '1', '1', 'yumbo', '1', 1, 1),
(2637, 2, 'IGLESIA', 'MISION PAZ A LAS NACIONES', NULL, NULL, '3154776478', '3153670814', '80062282', 'CENTRO COMERCIALDEL PARQUE', 'NO REGISTRA', 1, 2),
(2638, 3, 'PALMICERAMICAS', 'PALMICERAMICAS', NULL, NULL, '2844163', '3014623112', '0', 'CALLE 28 No. 26-44', '0', 1, 3),
(2639, 4, 'CAUCAPLAST', 'ROGER GOMEZ', NULL, NULL, '8206436', '0', '10527167-0', 'CALLE 8 No 4--41', '**', 1, 4),
(2640, 2, 'COPIAS IMPRESIONES ', 'DC', NULL, NULL, 'NO REGISTRA', 'NO REGISTRA', '29874575-9', 'CLL 42 NO 22.17', 'NO REGISTRA', 1, 2),
(2641, 1, 'GRUPO ELECTRICO', 'DE CALI LTDA.', NULL, NULL, '5246869', '8893433', '900246582-6', 'CRA 6 No. 18-50', '@', 1, 1),
(2642, 4, 'COPY TINTAS', 'POPAYAN', NULL, NULL, '8317149', '3127771646', '763330841-1', 'CRA 15 No. 4-05 B cadillal ', 'copytintaspopayan@hotmail.com', 1, 4),
(2643, 2, 'FABIO NELSON ', 'PATIÑO', NULL, NULL, 'NO REGISTRA', '3104447349', '6537996', 'CRA 24 2B-21 PORTALES DEL RIO', 'NO REGISTRA', 1, 2),
(2644, 2, 'copias ', 'y color ', NULL, NULL, 'no registra', '3159261879', '1116272273-2', 'cra 27  34-27', 'no registra', 1, 2),
(2645, 1, 'MEISY', 'MENDEZ TORRES', NULL, NULL, '0', '3158584627', '38559008', 'AVE 5 OESTE No. 20-40', '@', 1, 1),
(2646, 1, 'DEISURY', 'VALENCIA', NULL, NULL, '4033162', '315', '66959017', 'DIAG 26  con trasver 103 p 5 No. 18-35 ', '@', 1, 1),
(2647, 1, 'CARLOS ANDRES', 'JURADO GUZMAN', NULL, NULL, '0', '3005082848', '94064783', 'COMFENALCO YANACONAS', '@', 1, 1),
(2648, 4, 'LIZANDRO', 'PASINGA CIFUENTES', NULL, NULL, '3024620689', '3024620689', '990122-15149', 'TIMBIO VEREDA LAS PIEDRAS ', 'NULL', 2, 4),
(2649, 2, 'PATRICIA EUGENIA', 'QUITIAN MARTINEZ', NULL, NULL, 'NO REGISTRA', '3205856217', '31790230', 'MZ 25 CAS 12 BOSQUES DE MARACAIBO', 'NO REGISTRA', 1, 2),
(2650, 2, 'RAQUEL ANDREA', 'ORDOÑEZ LOPEZ', NULL, NULL, 'NO REGISTRA', '3163233583', '31792727', 'TRASV 7B  21-28 HORIZONTE', 'NO REGISTRA', 1, 2),
(2651, 3, 'PATRICIA ESMERALDA', 'YELA GONZALEZ', NULL, NULL, '2739107', '3234874184', '29671007', 'CARRERA 33 No. 63-41', '0', 1, 3),
(2652, 3, 'NORLAN ENOC', 'GRIJALBA PALLARES', NULL, NULL, '0', '3152264371', '6406845', 'CARRERA 30A No. 20-66', '0', 1, 3),
(2653, 1, 'RAFAEL', 'ORTIZ VELZ', NULL, NULL, NULL, '3004913546', '94532374', NULL, NULL, 1, 1),
(2654, 3, 'PATRICIA ', 'GONZALEZ HERRERA', NULL, NULL, '0', '3135181825', '29687835', 'CALLE 59A NO. 34E-61', '0', 1, 3),
(2655, 3, 'TECNI', 'ALZATE', NULL, NULL, '2733654', '3113543570', '16254117-1', 'CALLE 28 No. 28-33', '0', 1, 3),
(2656, 2, 'HEYDI PATRICIA', 'MENDEZ GARCIA', NULL, NULL, 'NO REGISTRA', '3163865002', '52975267', 'CLL 9 17-45 SANTA INES', 'HEYDIDIMG83@HOTMAL.COM', 1, 2),
(2657, 2, 'JHONATHAN ALEJANDRO', 'AVILA VALENCIA', NULL, NULL, '2303139', '3053526352', '1116237432', 'CLL4 22C- 35  PALMAR', 'JHONATHAN457@GMAIL.COM', 1, 2),
(2658, 2, 'DISTRIBUIDORA', 'ARCO IRES JH', NULL, NULL, '2305951', 'NO REGISTRA', 'NO REGISTRA', 'CLL25  12-109', 'NO REGISTRA', 1, 2),
(2659, 2, 'DISTRIBUIDORA Y ', 'CAC', NULL, NULL, '2246323', 'NO REGISTRA', '16368438', 'CLL 28  24-33', 'NO REGISTRA', 1, 2),
(2660, 1, 'RICARDO ', 'GARZON MEDINA', NULL, NULL, '0', '3007779056', '79279655', 'CLL 73NORTE # 2A - 18', '@', 1, 1),
(2661, 2, 'Maria Celene', 'Betancur', NULL, NULL, 'NO REGISTRA', '3146513014', '29463752', 'CLL35  31-21', 'NO REGISTRA', 1, 2),
(2662, 1, 'ALBERTO JR', 'CARDENAS RIOS', NULL, NULL, '0', '3017294250', '1127229499', 'CLLE 21NORTE # 5BN - 22', '@', 1, 1),
(2663, 1, 'GABY DAYANA', 'CANO PEÑA', NULL, NULL, '4379044', '3235811741', '1107104776', 'cra 29b#36-44 Barrio Diamante', 'gaby.dayana.cano@gmail.com', 1, 1),
(2664, 2, 'BAR- RESTAURANTE', 'SANTA LUCIA', NULL, NULL, '2244405', '3012295291', '163569025', 'CRA 40 JUNTO AL RIO LA RIVERA', 'NO REGISTRA', 1, 2),
(2665, 2, 'HOTEL ', 'LA BASTILLA OLIMPICA', NULL, NULL, '2255605', 'NO REGISTRA', '821002874-8', 'CRA 27A  42-07', 'HOTEL_LABASTILLA@HOTMAL.COM', 1, 2),
(2666, 1, 'MARIA DEL PILAR', 'BLANCO GARCIA', NULL, NULL, '0', '3175156379', '31566857', 'CLL 27 # 6 N - 13', '@', 1, 1),
(2667, 1, 'DEISSY JASMIN', 'AHUMADA BENAVIDES', NULL, NULL, '0', '3234166634', '1089076496', 'CLL 42 # 4B  43', '@', 1, 1),
(2668, 4, 'CARLOS ALBERTO', 'RÍOS PRIETO', NULL, NULL, '8393433', '3108262903', '19324507', 'CALLE 3 No 3-42', 'N/A', 1, 4),
(2669, 2, 'CHRYSTIAN MAURICIO', 'PEREZ SERNA', NULL, NULL, 'NO REGISTRA', '3156226165', '1116264985', 'CRA 5  NO  20-70', 'NO REGISTRA', 1, 2),
(2670, 4, 'DISTRIBUIDORA Y COMERCIALIZADORA', 'AMERICANA', NULL, NULL, '8335036', '3155113888', '1061709624-3', 'CALLE 1 N No 13-22', 'dary_florez@hotmail.com', 1, 4),
(2671, 2, 'SUPER MASCOTAS', 'TULUA', NULL, NULL, '2250397', 'NO REGISTRA', '298734004', 'CRA 23  29-75', 'NO REGISTRA', 1, 2),
(2672, 1, 'A.R. ', 'MASCOTAS', NULL, NULL, '4413423', '3217039500', '1130622611-2', 'CRA 14 # 40-18', '@', 1, 1),
(2673, 1, 'COPY LASER', 'DIGITAL', NULL, NULL, NULL, '3188553283', '66831577-3', NULL, NULL, 1, 1),
(2674, 1, 'LEIDY ZULEIMA', 'HIDALGO CRIOLLO', NULL, NULL, '0', '3113679302', '1086358894', 'CLL 29 # 68B - 59', '@', 1, 1),
(2675, 1, 'GUSTAVO ADOLFO', 'GIRON RESTREPO', NULL, NULL, '0', '3155488008', '16917468', 'CLL 14 # 85A - 66', '@', 1, 1),
(2676, 3, 'JAIDIVY ', 'VIVAS PERDOMO', NULL, NULL, '0', '3173049121', '29.664.680', 'CALLE 32C#1E-32', '0', 1, 3),
(2677, 3, 'KAREN VANESSA ', 'RESTREPO BETANCOURT', NULL, NULL, '0', '3136851203', '1.112.231.190', 'CALLE 10 # 6-14', '0', 1, 3),
(2678, 2, 'HAROLD ENRIQUE', 'HURTADO PEREZ', NULL, NULL, 'NO REFIERE', '3104983053', '1129488281', 'CLL 28B 43-23 JAZMIN', 'NO REQUIERE', 1, 2),
(2679, 1, 'PRO PUBLIC ', 'PROMOCIONES', NULL, NULL, '', '', '.901041852-2', '', '', 1, 1),
(2680, 2, 'JUAN DIEGO', 'TENORIO', NULL, NULL, 'NO REGISTRA', '3168758194', '1116262931', 'CLL 25  32-31', 'NO REGISTRA', 1, 2),
(2681, 1, 'IMAGENES &', 'MERCADEO', NULL, NULL, '6824123', '3154386854', '805017580-5', NULL, NULL, 1, 1),
(2682, 2, 'PROINGSA', 'INDUSTRIALES  S.A.S', NULL, NULL, 'NO REGISTRA', 'NO REGISTRA', '900562887-1', 'NO REGISTRA', 'NO REGISTRA', 1, 2),
(2683, 2, 'CC', 'LA HERRADURA', NULL, NULL, '2249507', 'NO REGISTRA', 'NO REGISTRA', 'Cl. 28, Tuluá, Valle del Cauca', 'NO REGISTRA', 1, 2),
(2684, 4, 'ANGELA ANDREA ', 'BELALCAZAR ROJAS', NULL, NULL, '0', '3168266469', '27.397.191 de PUPIAL', 'MZ 4 casa 41 Villa del Viento ', 'andresitocami@gmail.com', 1, 4),
(2685, 1, 'ROGER', 'DIAZ', NULL, NULL, NULL, NULL, '16456455', NULL, NULL, 1, 1),
(2686, 4, 'ACRILICOS ', 'J.F', NULL, NULL, '3147429453', '3147429453', '76312405', 'ESMERALDA', 'N/A', 1, 4),
(2687, 2, 'Paula Andrea ', 'Morales Hernandez', NULL, NULL, 'no registra', '3173204624', '29819581', 'cll 22 1 a oeste 24 nuevo farfan', 'no registra', 1, 2),
(2688, 1, 'ALMACENES SI', 'S.A.S', NULL, NULL, '1', NULL, '890301753-9', NULL, NULL, 1, 1),
(2689, 3, 'JOSE LUIS ', 'ARROYAVE GARCIA', NULL, NULL, '0', '3188340112', '1114823589', 'CALLE 8 No. 24A-124', '0', 1, 3),
(2690, 1, 'LISANDRO ', 'GOMEZ CORTES', NULL, NULL, NULL, '3206626053', '94351648', NULL, NULL, 1, 1),
(2691, 2, 'JULIAN ', 'ORTEGA HIGUITA', NULL, NULL, 'NO REGISTA', '3154008827', '94537525', 'CLL 42 83-20', 'NO REGISTRA', 1, 2),
(2692, 1, 'Paula Andrea', 'Velez Zorrilla', NULL, NULL, NULL, NULL, '67039893', NULL, NULL, 1, 1),
(2693, 2, 'PARQUEADERO ', 'C.A.M LA 25', NULL, NULL, 'NO REGISTRA', 'no registra', '55055853-2', 'CLL 25  25 ESQUINA', 'no registra', 1, 2),
(2694, 2, 'ALMACEN', 'LUIS E SANDOVAL', NULL, NULL, 'NO REGISTRA', 'NO REGISTRA', '2242681', 'CLL 26  24-61', 'NO REGISTRA', 1, 2),
(2695, 3, 'RAFAEL', 'VELASCO', NULL, NULL, '2726406', '0', '2411865', '0', '0', 1, 3),
(2696, 2, 'CC COMUNICACIONES', 'LA 25', NULL, NULL, '2316245', '3168866418', '1116242259-0', 'NO REGISTRA', 'CCOMUNICACIONES@HOTMAIL.COM', 1, 2),
(2697, 4, 'CAROLINA', 'RAMOS GARCÍA', NULL, NULL, '0', '3137131633', '1061697270 Popayán', 'Agrupación 12 # 12-26 La Aldea.', 'caritoramos01@hotmail.com', 1, 4),
(2698, 4, 'BICITIENDA', 'ROSA MARGORTH MARTINEZ', NULL, NULL, '8366990', '3206821441', '34565157-6', 'CALLE 5 # 19-31', 'N/A', 1, 4),
(2699, 1, 'PLASTICOS Y DESECHABLES ', 'LA 3A', NULL, NULL, NULL, NULL, '66979020-1', NULL, NULL, 1, 1),
(2700, 1, 'OLÍMPICA Mauricio ', 'Lemos Lozano', NULL, NULL, 'DS', 'd', '94539485', 'd', 'd', 1, 1),
(2701, 1, 'MIX Karen', 'Martinez Pulgarin', NULL, NULL, 'c', 'c', '1151943488', 'c', 'c', 1, 1),
(2702, 2, 'TELESERVICIOS', 'CENTRALES TELEFONICA', NULL, NULL, 'NO REGISTRA', '3177511331', '31792537-3', 'CLL 20 NO 26-54', 'NO REGISTRA', 1, 2),
(2703, 3, 'LILIA ISABEL ', 'GIRALDO CONTRERAS', NULL, NULL, '2874094', '3006225029', '1103108778', 'CALLE 28 No. 17A-23', '0', 1, 3),
(2704, 2, 'FERROSOLUCIONES', 'HV', NULL, NULL, '2247439', '3186625611', 'NO ', 'CLL 21 NO 28A-73', 'FERRESOLUCIONESHV@GMAIL.COM', 1, 2),
(2705, 2, 'FERRESOLUCIONES', 'HV', NULL, NULL, '2247439', '3186625611', 'NO REGISTRA', 'CLL 21 NO 28A-73', 'FERRESOLUCIONESHV@GMAIL.COM', 1, 2),
(2706, 3, 'GABRIELA', 'AMPUDIA ALVEAR', NULL, NULL, '2866034', '3104090730', '31132641', 'CRA. 27A No. 60-104', '0', 1, 3),
(2707, 4, 'RED ESPECIALIZADA EN TRANSPORTE', 'REDETRANS S.A.', NULL, NULL, '**', '**', '**', '**', '**', 1, 4),
(2708, 1, 'EL PUNTO ', 'DE LA TECNOLOGIA', NULL, NULL, NULL, NULL, '900809496-8', NULL, NULL, 1, 1),
(2709, 4, 'COOPERATIVA ', 'TRANSPORTADORA DE TIMBIO', NULL, NULL, '1111', '11111', '8915005934', 'TERMINAL DE TRANSPORTE', '1111', 1, 4),
(2710, 1, 'SUPERMERCADO', 'COMFANDI', NULL, NULL, NULL, NULL, '890303208-5', NULL, NULL, 1, 1),
(2711, 4, 'SEDHANK S.A.S', 'SOLUCIONES EMPRESARIALES ', NULL, NULL, '8397112', '3116095022', '900989594-2', 'CALLE 12 No 10A-09', 'sedhank@gmail.com', 1, 4),
(2712, 1, 'EXPRESSO', 'BOLIVARIANO', NULL, NULL, NULL, NULL, '860005108-1', NULL, NULL, 1, 1),
(2713, 1, 'VICTOR HUGO', 'OSORIO MONTALVO', NULL, NULL, '1', '3122170954', '1143831364', 'CALLE 3 22-69 LIBERTADORES', 'NULL', 1, 1),
(2714, 2, 'LA COSECHA', 'DE MI CAMPO', NULL, NULL, '2254096', 'NO REGISTRA', '94191671-2', 'CLL 27 A 21-50', 'NO REGISTRA', 1, 2),
(2715, 2, 'ELECTICROS ', 'JHON W', NULL, NULL, '2247211', '3183033169', '94153935-1', 'CRA 23N  25-56', 'NO REGISTRA', 1, 2),
(2716, 2, 'ESTACION DE SERVICIO', 'EDS EL TERMINAL', NULL, NULL, '22249998', 'BO REGISTRA', '6492295', 'CRA 20 27A-28', 'NO REGISTRA', 1, 2),
(2717, 2, 'EL REBAJON DEL VALLE', 'S.A.S', NULL, NULL, '2257246', '2257263', '901023519-8', 'CLL 28  20A-16', 'NO REGISTRA', 1, 2),
(2718, 4, 'OMAR GABRIEL', 'ZUÑIGA ORDOÑEZ', NULL, NULL, '0', '3004366289', '4417494', 'CALLE 31N  6-81', 'gomar_zuniga@hotmail.com', 1, 4),
(2719, 2, 'CURADURIA URBANA', 'DE TULUA', NULL, NULL, '2248731', 'NO REGISTRA', '16344691-4', 'NO REGISTRA', 'NO REGISTRA', 1, 2),
(2720, 3, 'FERRERIA ', 'DJ', NULL, NULL, '0', '3178496208', '31910682-0', '0', '0', 1, 3),
(2721, 3, 'LA CASA ', 'DE LOS SALDOS', NULL, NULL, '0', '0', '16703974-4', 'CRA 24 No. 30-55', '0', 1, 3),
(2722, 4, 'MARIO ERNESTO ', 'GARCIA CASTILLO ', NULL, NULL, '8369309', '3013978595', '76323981 POPAYÁN', 'CALLE 8 NO 21 A 55 ', 'megarcia18@misena.edu.co', 1, 4),
(2723, 4, 'COSME', 'HOYOS', NULL, NULL, '***', '3112324580', '93419002', 'NUEVO TEQUENDAMA MANZANA B CASA 23', 'N/A', 1, 4),
(2724, 4, 'STUDENTAL', 'ISABEL CRISTINA GIRALDO', NULL, NULL, '3188279397', '3188279397', '1061735715-5', 'LOCAL UNIVERSIDAD ANTONIO NARIÑO', '***', 1, 4),
(2725, 2, 'ELIZABETH ', 'MEJIA JARAMILLO', NULL, NULL, 'NO REGISTRA', '3155628657', '31198021', 'CLL 41  23-52', 'LIZ8262@HOTMAIL.COM', 1, 2),
(2726, 2, 'ADIELA', 'JIMENES FRANCO', NULL, NULL, '2246935', '3116300153', '66701614', 'CLL 17 A 34-36 ', 'ADIJIMENEZF66@GMAIL.COM', 1, 2),
(2727, 4, 'JAMES FERNANDO', ' GOMEZ RIOS', NULL, NULL, '3137596949', '3177336404', '76.332.283 de Popayá', 'CARRERA 9A # 60N-199 CASA M5 ASTURIAS', 'jamesgomezvet@hotmail.com', 1, 4),
(2728, 1, 'JOSE FRANCISCO', 'RODRIGUEZ MORALES', NULL, NULL, '6824123', '3007779890', '79686364-7', 'CALL 51N 2DN-04', NULL, 1, 1),
(2729, 2, 'TIENDA', 'DECAL WORKS ', NULL, NULL, '2245752', 'NO REGISTRA', '1116234605-2', 'CRA 22 16-77', 'NO REGISTRA', 1, 2),
(2730, 4, 'DELBY JHOANNA ', 'SALAZAR LOPEZ', NULL, NULL, '8388100', '3153169861', '34324221', 'CALLE 4  25-69 CAMILO TORRES', 'delbyjohanna@hotmail.com', 1, 4),
(2731, 1, 'VIVIANA ANDREA', 'MARIN OROZCO', NULL, NULL, 'n', '3218082252', '1130625833', 'calle 70 No. 3n-80', NULL, 1, 1),
(2732, 3, 'JOHN ALEXANDER', 'OCORO LERMA', NULL, NULL, '0', '3167098433', '1113625474', 'CARRERA 32 No. 44-13', '0', 1, 3),
(2733, 1, 'Maria Eugenia ', 'Cano Ramirez', NULL, NULL, 'n', '3107012634', '66906177', 'carrera 52 No 13E-31 primra de mayo', NULL, 1, 1),
(2734, 2, 'DISTRIBUIDORA ', 'SANTANDER', NULL, NULL, '2259805', '3185110030', '16360910-1', 'CRA 33  34-54', 'NO REGISTRA', 1, 2),
(2735, 3, 'MAYRA ALEXANDRA', 'GONZALEZ PALACIO', NULL, NULL, '0', '3183636459', '1113684570', 'CALLE 35 No. 22-35', '0', 1, 3),
(2736, 3, 'CAROLINA', 'RESTREPO ORTIZ', NULL, NULL, '0', '3156035924', '29681063', 'CRA. 18 No. 23-44', '0', 1, 3),
(2737, 1, 'RODRIGO ', 'CARLOSAMA CRUZ', NULL, NULL, NULL, NULL, '6248837', NULL, NULL, 1, 1),
(2738, 4, 'Gaseosas Posada Tobón ', 'S.A.', NULL, NULL, '0180005159 59', '3104219089', '890903939-5 ', '**', '**', 1, 4),
(2739, 4, 'LUIS CARLOS', 'SALAZAR BOLAÑOS', NULL, NULL, '0', '3176975516', '76314870', 'CARRERA 29 21-17', 'lukasb282000@yahoo.es', 1, 4),
(2740, 2, 'Martin Ariel ', 'Castaño Gonzalez', NULL, NULL, 'no registra', '7630693', '76306931', 'cll 31 43-86', 'no registra', 1, 2),
(2741, 1, 'DAISY VIVIAN', 'RENGIFO MARMOLEJO', NULL, NULL, '3136932489', '3128262291', '25531608', 'CALLE 6A 11-37', 'viviancita1984@gmail.com', 1, 1),
(2742, 3, 'KOBA ', 'COLOMBIA S.A.S', NULL, NULL, '3865060', '0', '900276962-1', '0', '0', 1, 3),
(2743, 2, 'LA ', 'CLAVE', NULL, NULL, '2246221', '3167035716', '87061370933-1', 'CLL 26 NO  22-37 ', 'NO REGISTRA', 1, 2),
(2744, 1, 'EPEXPRESS', 'NO REFIERE', NULL, NULL, '6644689', NULL, '800160068', 'CARRERA 34 Nº 10-229', 'NULL', 1, 1),
(2745, 2, 'OLIMPICA', 'S.A', NULL, NULL, '2242495', '2253185', '890107487-3', 'CRA 20 CLL 27', 'NO REGISTRA', 1, 2),
(2746, 1, 'Secretaria ', 'de Educación Municipal', NULL, NULL, '1', '1', '1', '1', '1', 1, 1),
(2747, 2, 'LAURA MANUELA', ' HENAO ACHEVERRY', NULL, NULL, 'NO REGISTRA', '3104307888', '99042911573', 'CRA 15 A  26C-11', 'NO REGISTRA', 1, 2),
(2748, 2, 'BERNARDO ', 'DUQUE SALAZAR', NULL, NULL, 'NO REGISTRA', '3122813594', '6180848', 'NO REGISTRA', 'NO REGISTRA', 1, 2),
(2749, 4, 'BEATRIZ ELENA', 'SOMERSON ROMERO', NULL, NULL, '3107036257', '3107036257', '1.081.812.679', 'CALLE 8  19-22', 'hellennasomer@gmail.com', 1, 4),
(2750, 2, 'MARIA DEL PILAR', 'LOPEZ', NULL, NULL, 'NO REGISTRA', '3117916221', '38796480', 'VEREDA CENEGUETA', 'NO REGISTRA', 1, 2),
(2751, 1, 'GLOBAL', 'FINANCIERA', NULL, NULL, '3451271', '3176472165', '901046858-9', 'AV 6 27-613', 'GERENCIA.BLONALFINANCIERA@GMAIL.COM', 1, 1),
(2752, 2, 'ELECTRONICAS', 'HAROLD', NULL, NULL, '2246643', '2246643', '16362431-2', 'CLL 28 24-39 ', 'NO REGISTRA', 1, 2),
(2753, 3, 'CLAUDIA PATRICIA ', 'HENAO RAMIREZ', NULL, NULL, '0', '3116462701', '1116439755', 'CALLE 35 No. 5EB-46', '0', 1, 3),
(2754, 4, 'FERRETERIA ELECTRICA ', 'LEEE', NULL, NULL, '3112033302', '3112033302', '1085273432', 'CRA 15 # 4-16 CADILLAL ', '....', 1, 4),
(2755, 4, 'MUNDO ', 'CARPINTERO ', NULL, NULL, '212948', '3113033773', '25281475', 'CRA 20 #7A-05', '....', 1, 4),
(2756, 1, 'ALINO', 'ALIMENTOS INOCUOS', NULL, NULL, '8821820', NULL, '79524763-8', 'CRA 3No 6-/83 OF 202 B7 SAN FERNANDO', NULL, 1, 1),
(2757, 4, 'FARMALATAM ', 'COLOMBIA SAS', NULL, NULL, '....', '...', '900659494-9', 'BOGOTA', 'NULL', 1, 4),
(2758, 4, 'ERNESTO', 'UMBAL ', NULL, NULL, '3113812085', '3113812085', '10538729', 'POPAYAN ', '...', 1, 4),
(2759, 1, 'ANDRES FERNANDO ', 'VALENCIA', NULL, NULL, NULL, '3003105545', '94454085', NULL, NULL, 1, 1),
(2760, 1, 'JOSE FERNELLY', 'MARTINEZ', NULL, NULL, NULL, '3235453672', '16480354', NULL, NULL, 1, 1),
(2761, 1, 'FRANCISNED ', 'ECHEVERRY ALVAREZ', NULL, NULL, 's', 's', '16677219', 's', 's', 1, 1),
(2762, 1, 'TIENDA VETERINARIA Y SPA', ' ATHENA', NULL, NULL, '4376796', NULL, '1234191229-8', 'CALL 72I 3N-03 BARRIO/ FLORALIA', NULL, 1, 1),
(2763, 1, 'JOSE LUIS', 'CRUZ', NULL, NULL, NULL, '3154087531', '94525161', 'cra 26H3 No72p1-46 bariio lagos 2', 'NULL', 1, 1),
(2764, 1, 'DOCTOR PORTATIL', 'CAROLINA ARISTIZABAL', NULL, NULL, NULL, NULL, '1130591354-1', 'AV 5AN No23DN-68 PASARELA', NULL, 1, 1),
(2765, 1, 'CAROLINA', 'LOPEZ HURTADO', NULL, NULL, NULL, '3166953695', '66969462', NULL, NULL, 1, 1),
(2766, 4, 'MIRYAM INES', 'CASTILLO GUAITACO', NULL, NULL, '8374825', '3123345442', '34550962', 'CALLE 2 A No. 27-39', 'miryamicastillo@gmail.com', 1, 4),
(2767, 2, 'MR', 'SHEK', NULL, NULL, 'NO ', '3187038142', '1116238922|', 'CLL 38 21-53', 'NO REGISTRA', 1, 2),
(2768, 4, 'JULIAN ANDRES', ' PRADO LOPEZ', NULL, NULL, '0', '3184000732', '10302661', 'CALLE 17N  4-03 POMONA', 'julianho390@hotmail.com', 1, 4),
(2769, 2, 'DIANA ', 'ZUÑIGA TAMAYO', NULL, NULL, 'NO REGISTRA', '2252691', '31791430', 'CLL 20  32A-14', 'NO REGISTRA', 1, 2),
(2770, 2, 'DISTRIBUIDORA ', 'SANTA MARTA', NULL, NULL, '3173580239', '3217176580', '574290801', 'CLL 229 NO 22-53', 'NO REGISTRA', 1, 2),
(2771, 2, 'TERESA DE JESUS', 'GUASMAYAN', NULL, NULL, '2255170', '2255194', '29886584-7', 'NO REGISTRA', 'NO REGISTRA', 1, 2),
(2772, 3, 'EXHIALAMBRE', 'ORLANDO ASTUDILLO ZUÑIGA', NULL, NULL, '8243865', '0', '76.296.528-3', 'CRA. 8 No. 6-15', '0', 1, 3),
(2773, 3, 'LEIDY MARCELA', 'TAMAYO ', NULL, NULL, '0', '3218186005', '1113688849', 'CRA 9 No.6-46', '0', 1, 3),
(2774, 4, 'ASIA SUPPLIES ', 'POPAYAN ', NULL, NULL, '8396890', '8396890', '76318454-3', 'cALLE 6 No. 10-47', 'ASIASUPPLIES@HOTMAIL.COM', 1, 4),
(2775, 3, 'JORGE ALBERTO', 'PINTO ESCOBAR', NULL, NULL, '0', '3156044327', '14695803', 'CRA. 25 No. 54-54', '0', 1, 3),
(2776, 2, 'RFRILAV', 'JC', NULL, NULL, '2244718', '3155914855', 'NO REGISTRA', 'CLL 25  30-52', 'NO REGISTRA', 1, 2),
(2777, 2, 'REFRILAV', 'JC', NULL, NULL, '2244718', '3127712450', 'NO REGISTRA', 'CLL 25  30-52', 'NO REGISTRA', 1, 2),
(2778, 3, 'YELIFEN CATERINE', 'GIRALDO DUQUE', NULL, NULL, '0', '3215165528', '1113665819', 'CRA 29A No.4-19', '0', 1, 3),
(2779, 2, 'KATHERIN JOHANA ', 'CORTES SOLIS', NULL, NULL, 'NO REGISTRA', '3183298017', '1006220251', 'CLLJON GUAYABAL 28 A 28 AGUACLARA', 'NO REGISTRA', 1, 2),
(2780, 3, 'PRODUCTORA', 'RADIAL A.S', NULL, NULL, '0', '0', '6078753-5', '0', '0', 1, 3),
(2781, 1, 'HERPATEL ', 'HERNANDO PAEZ LONDOÑO', NULL, NULL, '8801416', '8801757', '14989910-3', 'CARRERA 09 No. 08-26', NULL, 1, 1),
(2782, 4, 'LA TIENDA DEL COMPUTADOR', 'JHOJANA MARIA VILLAMARIN SANCHEZ', NULL, NULL, '8242499', '3017482066', '34331754', 'CALLE 6 No 9-36', 'N/A', 1, 4),
(2783, 2, 'ASEHOGAR ', 'LA 33', NULL, NULL, '3157955673', '3207019878', '1116255818-4', 'CRA 33 NO 31-80 ESQUINA', 'NO REGISTRA', 1, 2),
(2784, 2, 'BODEGA', 'LA ESPERANZA', NULL, NULL, '2243115', '2246374', '16347386-6', 'CRA 23 NO 29-04', 'NO REGISTRA', 1, 2),
(2785, 4, 'CLAUDIA ANGELICA', 'DAZZA PINEDA', NULL, NULL, '8365188', '3206671818', '52911354', 'CARRERA 10A  8-96 ', 'claudazza23@hotmail.com', 1, 4),
(2786, 4, 'JORGE ELIECER', 'LAGUNA ARENAS', NULL, NULL, '0', '3206583139', '13850595 Barranca', 'CRA 4b No 60bn-16  BARRIO: LOS ANGELES.', 'jorgeuke@gmail.com', 1, 4),
(2787, 4, 'PAOLA ANDREA', 'PATIÑO ALVAREZ', NULL, NULL, '3128540250', '3128540250', '25291183 POPAYÁN', 'TRANSV  1AE 9A-92 MOSCOPAN', 'paopatino322@gmail.com ', 1, 4),
(2788, 3, 'TALLER ', 'J.M.', NULL, NULL, '2724419', '0', '16.242.621-0', 'CALLE 30 No. 20-10', '0', 1, 3),
(2789, 2, 'CASA JUAN ', 'DM', NULL, NULL, 'NO REGISTRA', 'NO REGISTRA', '1112101260-1', 'CLL 27  27-02', 'NO REGISTRA', 1, 2),
(2790, 2, 'SERVI', 'PAIS', NULL, NULL, '2247304', '3128654695', '94393419-1', 'CRA 33 NO  34-01', 'NO REGISTRA', 1, 2),
(2791, 4, 'LLAVES DEL NORTE', 'IVAN ANDRES VALVERDE', NULL, NULL, '8201044', '3137186381', '76320429', 'KRA 6 No 19 A 11', 'N/A', 1, 4),
(2792, 2, 'KAROLINA', 'PIEDRAHITA CAICEDO', NULL, NULL, 'NO REGISTRA', '3156165170', '66715362', 'CLL 25B 1-57 SAN PEDRO CLAVER TULUA', 'NO REGISTRA', 1, 2),
(2793, 4, 'LADY ANDREA ', 'ARCINIEGAS CHAMORRO ', NULL, NULL, '3207651962', NULL, '1086103041 PUPIALES', 'CARRERA 6A  5N-22 URB EL UVO', 'andrea.arciniegas77@gmail.com', 1, 4),
(2794, 2, 'ADRIANA MALLERLY ', 'RODRIGUEZ SERRANO', NULL, NULL, '3016210398', '*3053073229', '1014192115', 'CLL 25  33A 14', 'NULL', 1, 2),
(2795, 4, 'JOSE ALEJANDRO ', 'FERNANDEZ OROZCO', NULL, NULL, '8363700', '3166906663', '10535054', 'CALLE 16AN  14-40', 'afernandezo10@hotmail.com', 1, 4),
(2796, 1, 'luis enrique', 'rivera', NULL, NULL, NULL, NULL, '94515352', NULL, NULL, 1, 1),
(2797, 2, 'DIVAS', 'FANTASY', NULL, NULL, '2249765', 'NO REGISTRA', '70697682-9', 'CLL27  24-23', 'NO REGISTRA', 1, 2),
(2798, 2, 'CASA', 'PATIN', NULL, NULL, 'NO REGISTRA', '3135178476', '1116725037-6', 'CLL 26  22-45', 'NO REGISTRA', 1, 2),
(2799, 3, 'DISCOVERY', 'ENERGY', NULL, NULL, '2856431', '0', '16.268.539-7', 'CARRERA 27 No. 30-68', '0', 1, 3),
(2800, 1, 'alcaldia mayor de bogota', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1),
(2801, 3, 'MARDENSEY', 'MONTOYA ESQUIVEL ', NULL, NULL, '0', '3166456092', '1114830282', 'CRA 28A # 69B-29 ', '0', 1, 3),
(2802, 3, 'RESTAURANTE ', 'LAS DELICIAS DE RUFI', NULL, NULL, '0', '3162516726', '31277798-0', 'CALLE 31 No. 24-15', '0', 1, 3),
(2803, 1, 'ANDRES ORLANDO', 'AGUILAR NUÑEZ', NULL, NULL, NULL, '3166709182', '14139744', 'CRA 49A#15-40 TORRE C APTO 801', NULL, 1, 1),
(2804, 1, 'JESSICA ', 'MOSQUERA MONTAÑO', NULL, NULL, NULL, '3164350799', '144165353', 'CRA 7#73-103', NULL, 1, 1),
(2805, 1, 'CARLOS ANDRES ', 'PARRA SERNA', NULL, NULL, NULL, '3188538643', '94511210', 'CRA 85C #55B-27', NULL, 1, 1),
(2806, 4, 'RAFAEL ALEXANDER', 'SANDOVAL VIDAL', NULL, NULL, '8317708', '3152609640', '76332898', 'Calle 6a # 2 – 18 Loma de Cartagena', 'rafaelsan@uniautonoma.edu.co', 1, 4),
(2807, 1, 'MASTER ELECTRICO DEL VALLE S.A', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1),
(2808, 1, 'CALI ELECTRICOS SAS', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1),
(2809, 2, 'BRAYAN  FERNANDO ', 'RODRIGUEZ', NULL, NULL, 'NO REGISTRA', '3136883882', '1116244148', 'CRA 26 A 39-58', 'NO REGISTRA', 1, 2),
(2810, 2, 'JHON HAROLD ', 'ARIAS LLANOS', NULL, NULL, 'NO REGISTRA', '3225916046', '99112512183', 'NUEVO FARFAN', 'NO REGISTRA', 1, 2),
(2811, 3, 'LADY VANESSA ', 'VALENCIA CASTRO', NULL, NULL, '0', '3178833170', '1113682252', 'CRA. 34A No. 66-43', 'O', 1, 3),
(2812, 2, 'ALIÑOS Y VIVERES', 'SAZON Y COLOR', NULL, NULL, '2246958', 'NO REGISTRA', '6281710-8', 'CLL 28  21-43', 'NO REGISTRA', 1, 2),
(2813, 1, 'laura marcela', ' arbelaez', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1),
(2814, 1, 'LADY YURANI', 'FIGUEREDO ACOSTA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1),
(2815, 2, 'JUAN SEBASTIAN', 'MARIN RODRIGUEZ', NULL, NULL, 'NO REGISTRA', '3113293972', 'NO REGISTRA', 'CRA 28 A 19-44', 'NO REGISTRA', 1, 2),
(2816, 1, 'miscelanea y ferroelectricos las torres', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1),
(2817, 1, 'ELECTRO AVENDAÑO', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1),
(2818, 1, 'VALLAMOVIL SAS', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1),
(2819, 2, 'VANESSA ', 'CALERO LOZANO', NULL, NULL, 'NO REGISTRA', '3146310266', '29873752', 'CRA 27  40C-16', 'NO REGISTRA', 1, 2),
(2820, 3, 'MARTHA LUCIA', 'CHAVEZ CHAVEZ', NULL, NULL, '0', '312294592', '66655506', 'CALLE 4 NO. 8-26', '0', 1, 3),
(2821, 2, 'PANADERIA Y CAFETERIA ', 'KALPER', NULL, NULL, '2246199', 'NO REGISTRA', '21481158-4', 'CLL27 21-21', 'NO REGISTRA', 1, 2),
(2822, 1, 'VICTOR EDUARDO ', 'FLOREZ ', NULL, NULL, NULL, '3184276728', '1144061198', 'CRA 45 # 37-39', 'vic_eduardo8@hotmail.com', 1, 1),
(2823, 4, 'KAREN CAMILA', 'RIASCOS LOZADA ', NULL, NULL, '3228825912', '3228825912', '1002960648', 'TIMBIO', 'NULL', 2, 4),
(2824, 1, 'vigilancia de su vehiculo', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1),
(2825, 1, '2 FACTURA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1),
(2826, 3, 'PAOLA ANDREA', 'PEÑA', NULL, NULL, '2849369', '3004715988', '31.640.788', 'CARRERA 42 # T 23-116', '0', 1, 3),
(2827, 4, 'NATHALIA ', 'BRAVO CORDOBA', NULL, NULL, '8367977', '***', '1018409079-5', 'KRA 9 No 11 N 18', '***', 1, 4),
(2828, 1, 'JUAN FERNADO ', 'PEREA', NULL, NULL, NULL, NULL, '14609537', NULL, NULL, 1, 1),
(2829, 2, 'JOSE GERMAN', 'VELEZ', '2017-06-05 22:51:03', NULL, '2252525', '3182546565', '1116249562', 'CRA 23 NUM 44-44', 'GERMANCHO@HOTMAIL.COM', 1, 2),
(2830, 3, 'JOHANNA MARCELA', 'POLO VILLANUEVA', '2017-06-06 20:01:00', NULL, '0', '310 442 2730', '1.112.223.034', 'CALLE 5A Nº 16-04 APTO 3', '0', 1, 3),
(2831, 2, 'Papeleria', 'Santa Maria', '2017-06-07 21:05:15', NULL, '2251000', 'No registra', '94377734-8', 'Cra 24 no 26-23', 'no registra', 3, 2),
(2832, 2, 'EL ACIERTO', 'PUBLICIDAD', '2017-06-07 22:08:48', NULL, '2248704', 'NO REGISTRA', '900.136.588-8', 'CALLE 23 Nº 22-35', 'NO REGISTRA', 3, 2),
(2833, 2, 'CATHERINE ', 'MONDRAGON', '2017-06-27 12:38:23', NULL, '2250199', '3218893787', '38791862', 'Cra 23 n 15-12', 'cathe.mp@hotmail.com', 1, 2),
(2834, 2, 'RICK OBRIAN', 'HERNANDEZ', '2017-06-27 12:52:41', NULL, 'No registra', '3167337511', '1053798326', 'Cll 9 b 17-88', 'no registra', 1, 2),
(2835, 2, 'JAIME ALBERTO', 'BERMUDEZ LOAIZA', '2017-06-27 12:59:42', NULL, 'NO REGISTRA', '3117293645', '75108450', 'CRA 31 A N 66-35', 'jaime.bermudez986@gmail.com', 1, 2),
(2836, 1, 'Domingo', 'Cuaran', '2017-06-27 16:35:02', NULL, '.', '.', '.', '.', '.', 1, 1),
(2837, 1, 'Domingo', 'Cuaran', '2017-06-27 16:36:44', NULL, '.', '.', '.', '.', '.', 1, 1),
(2838, 1, 'Domingo ', 'Cuaran', '2017-06-27 16:38:32', NULL, '.', '.', '16791654', '.', '.', 1, 1),
(2839, 1, 'NIKO SYSTEM', '.', '2017-06-27 20:00:33', NULL, '.', '.', '.', '.', '.', 3, 1),
(2840, 4, 'MARIA ALEJANDRA', 'BALCAZAR MUÑOZ', '2017-06-27 20:05:51', NULL, '8249914', '300 6377077', '25288285', 'CALLE 64 BN #9-20 URB LA FLORID', 'clinicabalcazar@gmail.com.co', 1, 4),
(2841, 4, 'JULIA YANET', 'BOLAÑOS PANTOJA', '2017-06-27 20:15:48', NULL, '8374737', '3005509471', '37.002.044 IPIALES', 'Kra 13 N° 10-22 B/JUAN23', 'juliayanet@yahoo.com.mx', 1, 4),
(2842, 1, 'LEYSA JENNIFER', 'LASSO VERGARA', '2017-06-27 22:17:44', NULL, '.', '.', '.', '.', '.', 1, 1),
(2843, 1, 'ENRIQUE ', 'RIVERA', '2017-06-27 23:05:58', NULL, '.', '.', '94515352', '.', '.', 1, 1),
(2844, 1, 'Ferreteria electricos del norte', 'Electricos del norte', '2017-06-27 23:29:05', NULL, '.', '.', '.', '.', '.', 1, 1),
(2845, 1, 'ALARMAS', 'Y CHAPAS CALI', '2017-06-28 00:05:44', NULL, '.', '.', '343273762', '.', '.', 3, 1),
(2846, 2, 'JORGE', 'ALVAREZ', '2017-06-28 16:50:48', NULL, 'NO REGISTRA', '3153582052', '6360629', 'MZ 14 CS 1 BOSQUES D M', 'NO REGISTRA', 1, 2),
(2847, 2, 'PAPELERIA', 'SANTA MARIA', '2017-06-28 21:17:17', NULL, '2256000', '3102251000', '94377734-8', 'CRA 24 NO 26-23', 'PAPELERIASANTAMARIA@HOTMAIL.COM', 3, 2),
(2848, 3, 'FERRETERIA MARIA ', 'SOLO LLAVES', '2017-06-29 23:52:01', NULL, '2713568', '3155559696', '31.161.358-4', 'CALLE 28 No. 26-51', 'N/A', 3, 3),
(2849, 1, 'GLORIA MARIA', 'VARGAS MARULANDA', '2017-06-30 17:09:54', NULL, '8888642', '3127885170', '1107099012', 'AV 9 OESTE #41A-22', '.*', 1, 1),
(2850, 1, 'ESTEFANIA', 'CUELLAR QUIROZ', '2017-06-30 20:22:39', NULL, '.', '.', '1.113.654.620', '.', '.', 1, 1),
(2851, 3, 'Daniela ', 'Ortiz Gomez ', '2017-06-30 23:01:00', NULL, '0', '3153570648', '1.113.657.542', 'Calle 26A No. 19-46', '0', 1, 3),
(2852, 2, 'YENY MARIBEL', 'QUICENO', '2017-07-01 14:19:08', NULL, '2249887', '3192371938', '66782174', 'CLL 33 A 18 D 28', 'NO REGISTRA', 1, 2),
(2853, 2, 'KELLY VANESSA', 'ARANGO DIAZ', '2017-07-04 23:05:50', NULL, 'NO REGISTRA', '3176916940', '1116267988', 'CRA 21 16-A 05', 'NO REGISTRA', 1, 2),
(2854, 2, 'DROGAS', 'SANA SANA', '2017-07-05 21:50:27', NULL, '2250859', 'NO REGISTRA', '66715745-8', 'CRA 21. 28-12', 'NO REGISTRA', 3, 2),
(2855, 2, 'MARIA EUGENIA', 'ESCOBAR LONDOÑO', '2017-07-06 21:58:02', NULL, 'NO REGISTRA', '3116040042', '29832674', 'CLL 54  44-23  ', 'NO REGISTRA', 1, 2),
(2856, 1, 'Diana.', 'Acosta jimenez', '2017-07-07 13:32:01', NULL, '.', '.', '1004162039', '.', '.', 1, 1),
(2857, 1, 'Julian fernando', 'Cuero', '2017-07-07 17:25:39', NULL, '.', '3136400811', '91278960', '.', '.', 1, 1),
(2858, 1, 'JAVIER EDUARDO', 'PALACIOS BLANCO', '2017-07-08 14:20:15', NULL, '.', '.', '94488913', '.', '.', 1, 1),
(2859, 2, 'MISCELANEA', 'SUPER GIRALDO', '2017-07-08 16:06:49', NULL, 'NO REGISTRA', 'NO REGISTRA', '29532615-8', 'CLL 34 25-27', 'NO REGISTRA', 3, 2),
(2860, 2, 'Luz Adriana ', 'Lasso s', '2017-07-11 16:16:18', NULL, 'No registra', '3116250154', '38796200', 'No registra', 'no registra', 1, 2),
(2861, 1, 'ENRIQUE', 'OLIVERA BORJA', '2017-07-11 21:17:35', NULL, '.', '3185214313', '14010486', '.', '.', 1, 1),
(2862, 1, 'TIENDA TECNOLOGICA', '.', '2017-07-14 00:14:17', NULL, '6679818', '.', '16917636-9', 'AV 5A 23 DN 68', '.', 3, 1),
(2863, 1, 'Afilado electronico de cuchillas', '.', '2017-07-14 14:51:16', NULL, '.', '.', '.', '.', '.', 1, 1),
(2864, 3, 'MARSORY ', 'ANZOLA SANCHEZ', '2017-07-14 19:41:39', NULL, '2850468', '3102018082', '29.662.550', 'CALLE 35A No. 40-116', 'N/A', 1, 3),
(2865, 1, 'Maria eugenia', 'Ceballos villegas', '2017-07-15 18:05:06', NULL, '3769071', '3122096815', '66722436', 'Calle 1 a #62a 130 apto 204 torre 2', 'mariaeugeniaceballosvillegas@gmail.com.co', 1, 1),
(2866, 1, 'FRANCIA ELENA ', 'CUBIDES ', '2017-07-15 18:56:44', NULL, '4487832', '3155522355', '38561075', 'DIAGONAL 28D No t29-72', '.', 1, 1),
(2867, 2, 'Natali Alexandra ', 'Sanchez Gonzalez', '2017-07-15 19:07:31', NULL, 'No registra', 'No registraº', '1112299548', 'No registra', 'no registraº', 1, 2),
(2868, 1, 'JANEY ', 'TULCAN', '2017-07-15 19:18:26', NULL, '.', '.', '38.461.280', '.', '.', 1, 1),
(2869, 2, 'Maria de los Angeles ', 'Valencia', '2017-07-17 22:58:36', NULL, 'No registra', '3186859949', '1116252700', 'Cra 23 a 4-28 alameda 1', 'no registra', 1, 2),
(2870, 4, 'ANA MARIA', 'CASTRO GONZALEZ', '2017-07-19 14:58:54', NULL, '3212617671', '3212617671', '52352722', 'Cra 17 No 57 N 804', 'castrogonzalezanamaria@gmail.com', 1, 4),
(2871, 1, 'ORDONEZ SAAVEDRA NIDIA DOLORES', '.', '2017-07-20 00:46:46', NULL, '.', '.', '.', '.', '.', 3, 1),
(2872, 1, 'Claudia marcela', ' caldon velasco', '2017-07-21 16:52:25', NULL, '.', '3207052082', '25283047', 'Av 6 bis 13 oeste 107', '.', 1, 1),
(2873, 2, 'Almacenes', 'Ara', '2017-07-22 18:10:16', NULL, 'No registra', 'No registra', '900480569-1', 'Cl 25 con tranz 12 esquina', 'no registra', 3, 2),
(2874, 1, 'MARIA ISABEL', 'ALEGRIA CAICEDO', '2017-07-22 21:41:13', NULL, '.', '3104002411', '34604770', 'CALLE 45 #86-47', 'ISA_ALEGRIA@HOTMAIL.COM', 1, 1),
(2875, 1, 'Infashion', '.', '2017-07-24 18:35:10', NULL, '.', '.', '900842732', '.', '.', 3, 1),
(2876, 3, 'BODYTECH', '-', '2017-07-26 22:29:51', NULL, '744 22 22 ', '0', '830.033.206-3', 'CALLE 31 No. 44-239', '0', 3, 3),
(2877, 1, 'DISTRIBUCIONES DANOCOA', '.', '2017-07-27 17:08:53', NULL, '3087886', '.', '1151966665-2', 'AV 5 AN 23 DN 68', '.', 3, 1);
INSERT INTO `proveedores` (`id`, `sede_id`, `nombres`, `apellidos`, `created_at`, `deleted_at`, `telefono`, `celular`, `num_documento`, `direccion`, `email`, `identificacion_id`, `ciudad_id`) VALUES
(2878, 2, 'Estanquillo', 'El sol', '2017-07-28 00:36:16', NULL, '2243828', 'No registra', '14795253-9', 'Cra 26 25-49', 'no registra', 3, 2),
(2879, 1, 'Elvis alexis', 'Gomajoa andrade', '2017-07-28 12:59:38', NULL, '.', '3217620724', '16940461', 'Calle 48 # 48c - 44', 'cartera.suroriente@gmail.com', 1, 1),
(2880, 4, 'CRISTIAN ANDRES', 'NAVARRETE MUÑOZ', '2017-07-28 19:41:45', NULL, '3208805291', '3208805291', '1061795832', 'CALLE 9 #32-23 31 DE MARZO ', 'N/A', 1, 4),
(2881, 3, 'A & M', 'BIOMEDICA', '2017-07-28 19:56:44', NULL, '3173123331', '3173123331', '1113526323-3', 'CRA. 5 No.  3-164 EL BOLO SAN ISIDRO', '0', 3, 3),
(2882, 3, 'DARLING ISABEL', 'LARA', '2017-07-28 22:51:52', NULL, '2759684', '0', '114.385.1928-0', 'CALLE 32 No. 26-29 LOCAL 112', '0', 3, 3),
(2883, 3, 'DIANA ISABEL', 'LARA V', '2017-07-28 22:55:03', NULL, '2759684', '0', '1143851928-2', 'CALLE 32 NO. 26-29 LOCAL 112', '0', 3, 3),
(2884, 2, 'GUIA COMERCIA', 'CONTACTO', '2017-07-28 23:05:32', NULL, 'No registra', 'No registra', 'NO REGISTRA', 'NO REGISTR', 'no registra', 1, 2),
(2885, 2, 'Gustavo Gutierrez', 'Panaderia peter pan', '2017-07-28 23:07:32', NULL, '2246076', 'No registra', '16721111-1', 'Cra 19 30-70', 'no registra', 3, 2),
(2886, 2, 'MARIA IDALIA', 'ARENAS', '2017-07-29 19:01:12', NULL, 'NO REGISTRA', '3177396147', '66676608', 'CLL 6A  22A52', 'NO REGISTRA', 1, 2),
(2887, 3, 'HEINI JOHANA', 'OSPINA CARREÑO', '2017-07-31 19:06:11', NULL, '0', '3188799757', '1113675896', 'MANZANA 2 CASA 15 / PRADERA', '0', 1, 1033),
(2888, 1, 'Jackeline', 'Figueroa', '2017-07-31 21:49:05', NULL, '.', '3103898470', '67014586', 'Av 43 oeste No 5b 18', '.', 1, 1),
(2889, 1, 'LUZ IRENE', 'GUERRERO', '2017-07-31 22:01:13', NULL, '.', '3174692951', '34554652', 'CARRERA 80 OESTE BIS 1 A 22', '.', 1, 1),
(2890, 4, 'CAMILO', 'NIETO URIBE', '2017-07-31 22:07:33', NULL, '0', '3185455257', '1061754574 POPAYAN', 'CARRERA 8A  12-69 EMPEDRADO', 'johnatan@unicauca.edu.co', 1, 4),
(2891, 1, 'JOSE EDUARDO ', 'CARRERA', '2017-08-01 01:03:15', NULL, '.', '.', '94.409.423', '.', '.', 1, 1),
(2892, 4, 'MARIAN YULIETH', 'MENESES ASTUDILLO ', '2017-08-01 22:18:01', NULL, '3178627554', '0', '1144208707', 'CALLE 7B  17-48 LA ESMERALDA', 'mymeneses5@misena.edu.co', 1, 4),
(2893, 4, 'CARLOS', 'MUÑOZ ', '2017-08-03 14:28:24', NULL, '8381945', '3146706308', '1061761016', 'CRA 14 N° 3A 24 EL CADILLAL', 'N/A', 1, 4),
(2894, 4, 'JAIRO ARMANDO', 'ASTUDILLO LAGOS', '2017-08-03 22:13:01', NULL, '8381619', '3206044374', '1061729245 POPAYAN', 'CALLE 2  10A-48 SAN FRANCISCO', 'jairoastudillo2011@gmail.com', 1, 4),
(2895, 4, 'SOLUCIONES ELECTRICAS ', 'SELECT', '2017-08-03 23:04:56', NULL, '3155262556', '3147902141', '10296395', 'CALLE 4 # 15-57 ', 'doradojes@hotmail.com', 3, 4),
(2896, 1, 'Carolina', 'Osorio', '2017-08-04 13:57:57', NULL, 'Na', 'Na', '30398858', 'Jjj', 'na', 1, 1),
(2897, 1, 'Adriana', 'Arias', '2017-08-04 14:12:08', NULL, 'Na', 'Na', '1130667596', 'Na', 'na', 1, 1),
(2898, 1, 'JAIME ', 'MOSQUERA', '2017-08-04 14:28:13', NULL, 'NA', 'NA', '16752265', 'NA', 'NA', 1, 1),
(2899, 1, 'FRANCY', 'MENESES ', '2017-08-04 14:40:08', NULL, 'NA', 'NA', '66988324', 'NA', 'NA', 1, 1),
(2900, 1, 'GUSTAVO', 'GIRON', '2017-08-04 15:14:25', NULL, 'NA', 'NA', '16917468', 'NA', 'NA', 1, 1),
(2901, 1, 'JAIME ', 'ROJAS', '2017-08-04 15:59:26', NULL, 'NA', 'NA', '16632908', 'NA', 'NA', 1, 1),
(2902, 1, 'Luis ', 'Arango', '2017-08-04 16:16:22', NULL, 'Na', 'Na', '16287023', 'Na', 'na', 1, 1),
(2903, 1, 'Diana', 'Perrilla', '2017-08-04 16:23:03', NULL, 'Na', 'Na', '0', 'Na', 'na', 1, 1),
(2904, 1, 'Diana ', 'Acosta', '2017-08-04 16:31:59', NULL, 'Na', 'Na', '0', 'Na', 'na', 1, 1),
(2905, 1, 'Jorge ', 'Humberto ', '2017-08-04 20:18:27', NULL, 'Na', 'Na', '16681694', 'Na', 'na', 1, 1),
(2906, 1, 'Claudia ', 'Espinosa', '2017-08-04 21:01:43', NULL, 'Na', 'Na', '0', 'Na', 'Na', 1, 1),
(2907, 4, 'FERRETERIA ', 'CENTRAL', '2017-08-04 22:07:11', NULL, '8243843', '8243477', '105257631', 'CALLE 7 # 7-81', 'NA', 3, 4),
(2908, 4, 'DUP TECHNOLOGY', 'DUP TECHNOLOGY', '2017-08-04 22:14:44', NULL, '3122377195', '3122377195', '1015998662', 'CALLE 7 N° 5-52', 'N/A', 3, 4),
(2909, 3, 'S & J', 'TECNOLOGY', '2017-08-04 22:38:29', NULL, '2855586', '0', '900.959.277-4', 'CALLE 31 No. 24-17', '0', 3, 3),
(2910, 2, 'Don limpio', 'Vm', '2017-08-05 16:13:34', NULL, '2301760', '3177236457', '60361160-7', 'Cll 25  18-05', 'no registra', 3, 2),
(2911, 4, 'CARLOS ANDRES', 'DORADO BASTIDAS', '2017-08-09 14:57:18', NULL, '3127698030', '3207343102', '10297716 POPAYAN', 'CARRERA 40B  2-66 ', 'andresdorado@gmail.com', 1, 4),
(2912, 4, 'VIVIANA MERCEDES', 'PAZ REALPE', '2017-08-09 14:58:21', NULL, '3012971938', '3122184764', '59311788 PASTO', 'CARERA 4B  28AN-49 YAMBITARÁ', 'vivipana84@hotmail.com', 1, 4),
(2913, 3, 'JESUS ALBERTO', 'PEREA NUÑEZ', '2017-08-10 21:14:50', NULL, '0', '0', '1113534667', 'FLORIDA', '0', 1, 1024),
(2914, 3, 'YURI MILENA', 'LOZANO JARAMILLO', '2017-08-10 21:16:30', NULL, '0', '31471060400', '1113658566', 'CALLE 7 No. 9-03', '0', 1, 1024),
(2915, 1, 'LUZ KARIME ', 'ENCARNACION', '2017-08-11 21:04:03', NULL, '1', '3215798182', '113669929', 'CALLE 2 OEST NO 24 A 94', 'luzkaya@hotmail.es', 1, 1),
(2916, 1, 'LIBARDO ', 'SOTO ', '2017-08-11 21:37:28', NULL, '0', '3192361435', '14608233', 'CALLE 98 C No. 20 - 07', 'libardosoto@hotmail.com', 1, 1),
(2917, 1, 'ALBERTO ', 'CAMACHO OCAMPO', '2017-08-11 22:44:19', NULL, '6629028', '3177954457', '94428501', 'CARRERA 13 NO. 74 - 142', 'albertocamachoocampo@gmail.com', 1, 1),
(2918, 3, 'ALEJANDRA ', 'BETANCOURTH MULATO', '2017-08-14 22:07:23', NULL, '0', '3166949650', '1113673651', 'CRA 4 No. 2-485 PALMASECA', '0', 1, 3),
(2919, 3, 'CALZADO', 'EVELYN', '2017-08-14 22:16:42', NULL, '0', '3175124486', '29.684.474-8', 'CALLE 28 CRA 26 GALERIA CENTRAL L-148', '0', 3, 3),
(2920, 2, 'Muebles', 'Shalom', '2017-08-14 23:28:56', NULL, '2247875', '3102813777', '1116258713-3', 'Cll25  22-63 ', 'no registra', 3, 2),
(2921, 1, 'LAURA MARCELA', 'ARBELAEZ TUMBO ', '2017-08-15 19:17:31', NULL, '.', '.', '1.112.496.892', '.', 'vguauna@gmail.com', 1, 1),
(2922, 1, 'VICTOR MARIO', 'TORO CARDENAS', '2017-08-15 21:41:48', NULL, '.', '.', '16.377.004', '.', '.', 1, 1),
(2923, 1, 'MARIA CAROLINA', 'BERMUDEZ', '2017-08-15 21:46:34', NULL, '.', '.', '1.143.941.272', '.', '.', 1, 1),
(2924, 2, 'Arsesa', 'Epp laboral', '2017-08-15 22:15:46', NULL, 'No registra', '3186948363', '29736726-3', 'Cll 21  29-56 ', 'no registra', 2, 2),
(2925, 2, 'Pinturas', 'Chaspu color´s', '2017-08-15 22:19:18', NULL, '2248306', '3177817238', '1116262484-7', 'Cra 29  22-03 ', 'no registra', 3, 2),
(2926, 3, 'ELECTRONICAS', ' J & P', '2017-08-15 22:29:08', NULL, '0', '3188290923', '16.728.479-8', 'CARRERA 24 No. 30-85', '0', 3, 3),
(2927, 1, 'BERNARDO ', 'ABADIA MORALES', '2017-08-16 00:15:00', NULL, '3714099', '3164242514', '94425091', 'CARRERA 20 # 10 - 51', 'babadia@hotmail.com', 1, 1),
(2928, 4, 'MARIAN YULIETH', 'MENESES ASTUDILLO', '2017-08-16 01:00:07', NULL, '3152623418', '3178627554', '1144208707 CALI', 'CALLE 7B  17-48 ESMERALDA', 'mymeneses5@misena.edu.co', 1, 4),
(2929, 2, 'Milton fabian', 'Beltran lopez', '2017-08-17 16:07:05', NULL, '3154244186', '3154290631', '94256929', 'Cra 4b 26-c10 san pedro claver', 'no registra', 1, 2),
(2930, 4, 'Maritza Ortiz ', 'Ortiz ', '2017-08-17 19:56:21', NULL, '312798853', '312798853', '67013773', 'CALLE 11 # 10-33 ', 'n/a', 1, 4),
(2931, 1, 'YULIANA ', 'HENAO ROA', '2017-08-18 00:11:34', NULL, '4363840', '3128494804', '1130663030', 'Calle 79 # 28 e 22', 'a', 1, 1),
(2932, 1, 'DENTAL DG', 'STORE', '2017-08-18 15:15:13', NULL, '6678521', 'NA', '21777681-7', 'CALLE 13N 3N 31', 'NA', 3, 1),
(2933, 2, 'ESPECIALIDADES DIAGNOSTICAS', 'IHR LTDA', '2017-08-18 18:34:03', NULL, 'NO REGISTRA', 'NO REGISTRA', '890325601-1', 'CLL 8 NO 39-86', 'SERVICIOALCLIENTE@IHRDIAGNOSTICA.COM', 3, 2),
(2934, 2, 'Lina marcela', 'Guerrero', '2017-08-18 21:46:43', NULL, 'O registra', '3116944862', '1116278350', 'Cra c17-09', 'no registra', 1, 2),
(2935, 1, 'Redeban ', 'Multicolor', '2017-08-19 20:23:33', NULL, '.', '.', '830070527', '.', '.', 3, 1),
(2936, 2, 'Salsamentaria', 'Avileña', '2017-08-23 15:57:42', NULL, 'No registra', '3122584800', '31792464-4', 'Cra 21 n 25-09', 'no registra', 1, 2),
(2937, 1, 'El bodegazo', 'Tecnologico', '2017-08-23 16:19:52', NULL, '.', '.', '.', '.', '.', 3, 1),
(2938, 1, 'Laser digital ', 'Impresores', '2017-08-23 20:27:53', NULL, '.', '.', '.', '.', '.', 1, 1),
(2939, 1, 'Espacios y diseño', '.', '2017-08-24 20:09:42', NULL, '.', '.', '.', '.', '.', 1, 1),
(2940, 1, 'DISTRIALCOS', '.', '2017-08-24 21:31:17', NULL, '.', '.', '.', '.', '.', 1, 1),
(2941, 1, 'Hernan velez', '.', '2017-08-25 15:03:39', NULL, '.', '.', '.', '.', '.', 1, 1),
(2942, 1, 'Andrea', 'Florez', '2017-08-25 23:41:32', NULL, '.', '.', '.', '.', '.', 1, 1),
(2943, 4, 'Distribuidora ', 'Superior del cauca', '2017-08-26 15:59:47', NULL, '.', '.', '.', '.', '.', 3, 1),
(2944, 4, 'Surti electricos', '.', '2017-08-26 16:00:32', NULL, '.', '.', '.', '.', '.', 3, 1),
(2945, 1, 'Almacen ', 'Herras plas', '2017-08-26 19:56:58', NULL, '.', '.', '.', '.', '.', 1, 1),
(2946, 1, 'Parqueaderos', ',.', '2017-08-26 20:01:25', NULL, '.', '.', '.', '.', ',', 3, 1),
(2947, 2, 'Claudia patricia', 'Escobar', '2017-08-30 20:01:21', NULL, '1111111', '111111111', '111111111', '1111111', '111111111', 1, 2),
(2948, 2, 'SANDRA LILIANA', 'DIEZ ARIAS', '2017-08-30 20:16:03', NULL, 'NO REGISTRA', '3167608879', '1116232943', 'CLL 32  24-35 SAJONIA', 'NO REGISTRA', 1, 2),
(2949, 1, 'Copy ', 'Eva', '2017-08-30 21:59:58', NULL, '.', '.', '.', '.', '.', 1, 1),
(2950, 1, 'ELIANA MARIA ', 'VILLANUEVA ROJAS', '2017-08-31 16:55:56', NULL, '.', ',', '38.462.292', '.', '..', 1, 1),
(2951, 1, 'MARITZA ', 'VILLAREAL', '2017-08-31 21:44:54', NULL, '.', '.', '1.144.104.559', '.', '.', 1, 1),
(2952, 1, 'INGRID JOHANNA VANEGAS', '.', '2017-09-01 13:41:31', NULL, '.', '.', '.', '.', '.', 1, 1),
(2953, 1, 'Diana Marcela ', 'Delgado Gutierrez', '2017-09-01 19:27:00', NULL, '.', '.', '29351552', '.', '.', 1, 1),
(2954, 2, 'El punto', ' del cuero', '2017-09-01 20:17:33', NULL, '2249200', 'No registra', '24813711-5', 'Cra 25 26-30 2249200', 'no registra', 3, 2),
(2955, 1, 'JOSE FERNANDO ', 'BOTERO MESA', '2017-09-01 22:15:44', NULL, '...', '..', '16794688', '...', '..', 1, 1),
(2956, 3, 'DIANA MARIA ', 'TIMANA MENA', '2017-09-04 22:37:01', NULL, '3017400275', '3105476066', '1113685859', 'CRA 5 No. 7-35', '0', 1, 3),
(2957, 4, 'LUIS GUILLERMO', 'MAYORGA  GONZALEZ', '2017-09-04 22:50:46', NULL, '3168328493', '3168328493', '1949039-5', 'KRA 11 No 62N 127', 'N/A', 3, 4),
(2958, 2, 'Distribuidora de agua en botellon', 'H2o', '2017-09-05 16:40:16', NULL, 'No registra', '3234275260', '14796526-9', 'Cra 22 no 22-41', 'no registra', 3, 2),
(2959, 1, 'Oscar eduardo', ' castillo', '2017-09-05 19:21:49', NULL, ',', ',', ',', ',', ',', 1, 1),
(2960, 2, 'ANDRES FELIPE', 'ZORRILLA', '2017-09-06 21:13:46', NULL, 'NO REFIERE', '3182165846', '6499168', 'CLL 26  NO 14-30', 'NO REGISTRA', 1, 2),
(2961, 3, 'Maria Fernanda ', 'Giraldo Londoño', '2017-09-08 16:03:07', NULL, '0', '0', '66978231', '0', '0', 1, 3),
(2962, 3, 'LUIS CARLOS ', 'CHAVEZ PORRAS', '2017-09-08 19:28:23', NULL, '3104067001', '3184265770', '16.690.057', 'TRANS 30 No. 5E-51', '0', 1, 3),
(2963, 1, 'Arte libre', '.', '2017-09-08 19:29:49', NULL, '.', '.', '.', '.', '.', 1, 1),
(2964, 2, 'Graficas ', 'Mr', '2017-09-09 16:28:50', NULL, '2247488', '3155256682', '29872992-8', 'Cra 23 no 24-14', 'no registra', 3, 2),
(2965, 1, 'El imperio del plastico', '.', '2017-09-09 18:17:09', NULL, '.', '.', '.', '.', '.', 1, 1),
(2966, 2, 'El gran bumeran', 'Restaurante', '2017-09-11 13:23:39', NULL, '2332624', '3184282444', '3116117236', 'Cll 27  35-62 ', 'no registra', 3, 2),
(2967, 2, 'ANGIE PAOLA ', 'ROMERO VENTE', '2017-09-11 15:03:17', NULL, 'NO REGISTRA', '3136729160', '1116280196', 'BARRIO GUAYACANES RTULUA', 'NO REGISTRA', 1, 2),
(2968, 2, 'Mauricio', 'Rada', '2017-09-11 21:07:14', NULL, 'No registra', '3173409746', '14800636', 'Cll 26 a 1 14-60', '360producciones7@gmail.com', 1, 2),
(2969, 3, 'EDWIN', 'CORREA CARVAJAL', '2017-09-11 22:36:35', NULL, '0', '3104449102', '1.113.693.639', 'CALLE 22 NO. 21-90', '0', 1, 3),
(2970, 1, 'SANDRA LORENA ', 'MUÑOZ LANCHEROS', '2017-09-15 15:43:58', NULL, '.', '.', '1107044317', '.', '.', 1, 1),
(2971, 1, 'SUSANA ', 'QUINTERO COTACIO', '2017-09-15 16:57:16', NULL, '.', '.', '1144057581', '.', '.', 1, 1037),
(2972, 1, 'Edward ', 'Libreros florez', '2017-09-15 19:00:14', NULL, '.', '.', '.', '.', '.', 1, 1),
(2973, 1, 'JORGE ALEJANDRO CASILIMAS				', '.', '2017-09-15 19:32:01', NULL, '.', '.', '.', '.', '.', 1, 1),
(2974, 2, 'Esmeralda', 'Bustamante Serrano', '2017-09-18 20:43:00', NULL, 'No registra', '3117582641', '1108830729', 'Cll 27a57 san antonio', 'NO REGISTRA', 1, 2),
(2975, 2, 'Kenny Johana', 'Vergara Martinez', '2017-09-18 20:44:19', NULL, 'No registra', '3105044443', '1110548618', 'Vll 38 18b19 pueblo nuevo', 'no registra', 1, 2),
(2976, 4, 'NAPOLEON ', 'GIRON ORDOÑEZ', '2017-09-20 01:21:05', NULL, '3215390366', '3215390366', '7336871', 'LOMAS DE GRANADA ', 'N/A', 1, 4),
(2977, 1, 'Comfandi ', 'Cali', '2017-09-20 21:47:04', NULL, '.', '.', '.', '.', '.', 1, 1),
(2978, 1, 'Credibanco', '.', '2017-09-21 20:21:52', NULL, '.', '.', '.', '.', '.', 1, 1),
(2979, 1, 'ANDRES ', 'HERNANDEZ', '2017-09-21 22:18:20', NULL, '.', '.', '.', '.', '.', 1, 1),
(2980, 2, 'Luisa fernanda ', 'Ramirez bastidas', '2017-09-21 22:48:26', NULL, 'No registra', '3156018791', '1116277238', 'Cll 26a 11-34', 'no registra', 1, 2),
(2981, 2, 'Haider alfonso', 'Vinasco castro', '2017-09-21 23:19:18', NULL, 'No registra', '3186058032', '1116251441', 'Cra 22b 5-04', 'no registra', 1, 2),
(2982, 3, 'EL CHUSPOLOGO', 'PLASTICOS Y DESECHABLES', '2017-09-22 20:24:40', NULL, '2812719', '3136520625', '38.565.368-8', 'Cra. 26 No. 27-60', '0', 3, 3),
(2983, 4, 'CAMILA', ' ANAYA ', '2017-09-22 22:08:46', NULL, '8398830', '3106615321', '1061778023', 'Calle 3 # 27-79', 'kamilaanaya0296@gmail.com', 1, 4),
(2984, 3, 'PUNTO REPUESTOS', 'HOGAR', '2017-09-22 22:18:05', NULL, '2855319', '3117452384', '111', 'Cra. 25 No. 30-59', '0', 3, 3),
(2985, 3, 'FERROELECTRICOS', 'PALMIRA', '2017-09-25 21:28:25', NULL, '275 84 32', '311 7621730', '1.113.644.027-3', 'CRA 26 No. 30-41', '0', 1, 3),
(2986, 4, 'LISSETH XIOMARA ', 'VILLA ORDOÑEZ ', '2017-09-25 22:05:22', NULL, '3127472232', '3168740988', '1061744442', 'Calle 3 norte # 10-22', 'lidersocial@comunidadhumanista.org ', 1, 4),
(2987, 2, 'ALONSO', 'OSPITIA CORREA', '2017-09-26 13:03:37', NULL, 'NO REGISTRA', '3163669210', '16347108 ', 'BARRIO SAN FRANCISCO PARCELA 2 CASA 8', 'NO REGISTRA', 1, 2),
(2988, 4, 'LADY PIEDAD', 'GIL LIZCANO', '2017-09-26 15:26:19', NULL, '3102563802', '3102563802', '52816031', 'CARRERA 56 3B-15 LOMAS DE GRANADA', 'ladypiedadgil@gmail.com', 1, 4),
(2989, 4, 'EIDER JAVIER ', 'CUEVAS', '2017-09-26 16:23:09', NULL, '3205408757', '3205408757', '76308911', 'CALLE 12 # 4-30', 'N/A', 1, 4),
(2990, 3, ' DIANA LORENA', 'MONTOYA RAMIREZ', '2017-09-27 16:29:19', NULL, '0', '3128300834', '1.113.666.905', 'CRA 25A # 47B - 09', '0', 1, 3),
(2991, 4, 'JUAN CARLOS', ' VELASCO', '2017-09-27 17:05:30', NULL, '8352826', '3105018818', '76311500', 'KRA 16 B No 5N-03   URBANIZACION EL UVO', 'velascojuancarlos64@hotmail.com', 1, 4),
(2992, 4, 'GERALDINIE ', 'VILLADA LLENTEN', '2017-09-28 14:55:38', NULL, '3124214843', '3136083342', '1060879756', 'Valencia', 'geraldinallanten@gmail.com', 1, 4),
(2993, 3, 'LUCENA MARISOL', 'ESCOBAR MUÑOZ', '2017-09-29 16:32:44', NULL, '2860256', '3146932568', '66.764.495', 'CRA 15B No. 23-28 B/ SEMBRADOR', '0', 1, 3),
(2994, 3, 'JOHAN DAVID', 'LUCIO SERNA', '2017-09-29 19:52:24', NULL, '2755215', '3178550091', '1113659857', 'CRA 26 No. 13-24 B/ LAS AMERICAS', '0', 1, 3),
(2995, 3, 'JUAN MANUEL ', 'RESTREPO ARANGO', '2017-09-29 20:15:27', NULL, '2607300', '317 7519062', '94043704 ', 'Carrera 14 # 14 - 45 VILLAGORGONA', '0', 1, 3),
(2996, 4, 'ALMACEN MULTICAUCHOS', 'TODO EN CAUCHOS / EDGAR RODRIGO LÓPEZ A.', '2017-09-30 14:51:06', NULL, '8202409', '0', '4609072-0', 'CALLE 1A No 8-55', 'N/A', 3, 4),
(2997, 3, 'QUIMICA ', 'ACTIVA', '2017-09-30 16:34:13', NULL, '2710587', '0', '31979208-1', 'CRA 28 No. 27-21', '0', 3, 3),
(2998, 2, 'Sandro', 'CARDENAS VITERY', '2017-09-30 18:48:50', NULL, 'NO REGISTRA', '3187621186', '98370954', 'NO REGISTRA', 'NO REGISTRA', 1, 2),
(2999, 1, 'Damoca', 'Distribuiciones ', '2017-10-02 18:59:18', NULL, '.', '.', '.', '.', '.', 1, 1),
(3000, 2, 'OMAR H OSORIO ', 'LIP TRONIX', '2017-10-03 14:45:42', NULL, '3007823328', '3154258768', '94368317-1', 'NO REGISTRA', 'LIPTRONIX@HOTMAIL.COM', 3, 2),
(3001, 2, 'WILLIAM DE JESUS', 'QUIRAMA ZAPATA', '2017-10-03 17:17:05', NULL, '3185258035', '3127475122', '16358892', 'CRA 27 NO 12A 26 ', 'NOREGISTRA', 1, 2),
(3002, 4, 'JUAN FELIPE ', 'NARVAEZ LOPEZ', '2017-10-03 23:46:25', NULL, '8350751', '3108411998', '1061779499', 'CALLE 35N  3-16 YAMBITARÁ', 'juanfelipe9521@gmail.com', 1, 4),
(3003, 4, 'OSCAR', 'ALTA PELUQUERIA INTERNACIONAL', '2017-10-04 00:54:37', NULL, '8241339', '3117708046', '34547305-3', 'CALLE 7 # 10A - 25', 'N/A', 3, 4),
(3004, 4, 'ALQUILER DE LAVADORAS', 'BURBUJAS', '2017-10-04 20:34:52', NULL, '3128195337', '3043626612', '25284657', '**', '**', 3, 4),
(3005, 1, 'Wilmer ', 'Caicedo', '2017-10-04 21:15:46', NULL, '.', '.', '.', '.', '.', 1, 1),
(3006, 1, 'FUMIEXTINTORES', '.', '2017-10-05 13:54:38', NULL, '.', '.', '.', '.', '.', 1, 1),
(3007, 1, 'Jonathan', '.', '2017-10-06 20:06:02', NULL, '.', '.', '.', '.', '.', 1, 1),
(3008, 2, 'Carlos augusto ', 'Villada hoyos', '2017-10-06 21:52:20', NULL, '2249489', '3166476064', '16379254', 'Calle 27 21 58', 'cristaleria el mellizo', 3, 2),
(3009, 1, 'Jessica Lorena ', 'Arboleda Calderon ', '2017-10-06 22:29:54', NULL, '.', '.', '1130679362', '.', '.', 1, 1),
(3010, 2, 'CRISTALERIA', 'EL MELLIZO', '2017-10-07 12:50:57', NULL, '2249489', 'NO RGISTRA', '16379254', 'CLL 27-21-58', 'NO REGISTRA', 3, 2),
(3011, 4, 'CELL MOVIL', 'DIEGO LOPEZ', '2017-10-07 19:49:43', NULL, '8320206', '**', '1061706111-3', 'PASAJE COMERCIAL 1ER  NIVEL ', '**', 3, 4),
(3012, 1, 'CARLOS ARTURO', 'GOMEZ G', '2017-10-09 20:56:00', NULL, '.', '.', '.', '.', '.', 1, 1),
(3013, 2, 'AGROCENTRO DEL VALLE', 'S.A.S', '2017-10-09 21:24:26', NULL, '2253210', 'NO REGISTRA', '900984649-6', 'CRA 23  28-38', 'NO REGISTRA', 3, 2),
(3014, 2, 'DISTRIBUIDORA CORAZON DEL VALLE', 'DISTRICOR S.A.S', '2017-10-10 20:35:38', NULL, '2241052', 'NO REGITRA', '821.000.570-5', 'CLL 26 NO 30-60', 'NO REGISTRA', 3, 2),
(3015, 3, 'PALMIPOR ', 'S.A.S ', '2017-10-10 21:37:42', NULL, '2758231', '3136461808', '800.095.296-2', 'CRA 29 No. 32-121', '0', 3, 3),
(3016, 1, 'MUNDIAL ', 'DE TORNILLO', '2017-10-11 21:32:25', NULL, '.', '.', '.', '.', '.', 1, 5),
(3017, 2, 'Club Dental', 'DEPOSITO DENTAL', '2017-10-12 22:57:24', NULL, '2255699', '3166197958', '38793946-2', 'CRA 25 NO 30-70', 'NO REGISTRA', 3, 2),
(3018, 1, 'Gabriela', 'Tabares', '2017-10-13 16:12:54', NULL, '.', '.', '.', '.', '.', 1, 5),
(3019, 3, 'SuPrint', 'Imprenta Digital', '2017-10-13 20:46:33', NULL, '2878688', '0', '14.652.391-3', 'CALLE 31 NO. 31-72', '0', 3, 3),
(3020, 2, 'KATERINE ', 'ORTIZ GRISALES', '2017-10-13 21:10:03', NULL, 'NO REGISTRA', '3127944990', '38755312', 'CLL 63A 52-44 VILLA DE PAZ', 'NO REGISTRA', 1, 2),
(3021, 1, 'INCGRID YURANNY ', 'PITO BUBU', '2017-10-13 21:48:26', NULL, '.', '.', '1113539401', '.', '.', 1, 1),
(3022, 1, 'INGRID YURANNY', 'PITO BUBU', '2017-10-13 21:50:16', NULL, '.', '.', '1113539401', '.', '.', 1, 1),
(3023, 2, 'YURI JIMENA', 'LADINO SANCHEZ', '2017-10-14 13:14:47', NULL, 'NO REGISTRA', 'NO REGISTRA', '29786228', 'SAN PEDRO', 'NO REGISTRA', 1, 2),
(3024, 2, 'ALVARO ANDRES', 'CAMACHO SEGURA', '2017-10-17 14:45:31', NULL, 'No registra', '3185873595', '16775462', 'Cll 31 a no 37-62 barrio mira flores', 'no registra', 1, 2),
(3025, 4, 'DANIEL ALEJANDRO', 'MOLANO GABALAN', '2017-10-17 17:28:16', NULL, '3012923656', '3012923656', '10303830 POPAYAN', 'CAARRERA 9  11-18 SAN CAMILO', 'danielmolano1984@gmail.com', 1, 4),
(3026, 4, 'ANGELA MARIA', 'REALPE MOPAN', '2017-10-17 17:29:47', NULL, '3043375492', '3043375492', '1061749731 POPAYAN', 'CALLE 2  2-49 ', 'angelamaria_realpe@hotmail.com', 1, 4),
(3027, 4, 'MARIA CAMILA', 'ANAYA', '2017-10-17 22:39:14', NULL, '8398830', '3106615321', '1061778023', 'CALLE 3 # 27-79', 'N/A', 1, 4),
(3028, 2, 'WOLFAN ', 'ALVARADO VIVI', '2017-10-17 23:27:27', NULL, '2336969', 'NO REGISTRA', '16364081', 'CRA 27 23-46', 'NO REGISTRA', 1, 2),
(3029, 1, 'ROBINSON ', 'LADINO', '2017-10-18 20:12:26', NULL, '.', '.', '.', '.', '.', 1, 1),
(3030, 2, 'JAMES DE JESUS', 'SERNA RAMIREZ', '2017-10-18 20:54:12', NULL, 'NO REGISTRA', '3175673436', '16359295', 'CRA 24 A 16 65', 'NO REGISTRA', 1, 2),
(3031, 4, 'UBICAMOS COLOMBIA', 'LEIDA BAQUERO', '2017-10-18 23:04:51', NULL, '**', '**', '34326266', '**', '**', 1, 4),
(3032, 2, 'ANYI CAROLINA', 'GUTIERREZ', '2017-10-19 22:46:55', NULL, 'NO REGISTRA', '3195364690', '1116270290', 'HOSPITAL ULPIANO TASCON', 'NO REGISTRA', 1, 2),
(3033, 3, 'JUAN DAVID', 'OTALVARO', '2017-10-20 13:19:14', NULL, '2729640', '0', '1113644491', 'CALLE 28 NO, 26-51', '0', 1, 3),
(3034, 1, 'Gabriela ', 'Guiral vargas', '2017-10-20 15:25:11', NULL, '.', '.', '.', '.', '.', 1, 1),
(3035, 4, 'FERRE FULL Y MAS', 'JINETH PUSCUS MACA', '2017-10-20 22:01:23', NULL, '8226515', '***', '34566246-8', 'KRA 16 No 4-25', '***', 3, 4),
(3036, 3, 'ANGELA MARIA ', 'CIFUENTES OTERO', '2017-10-23 22:48:11', NULL, '0', '0', '1112220188', 'CALLE 4 NO. 3-65', '0', 1, 1033),
(3037, 4, 'FAURY ALEJANDRO ', 'DIAZ POLINDARA', '2017-10-24 15:38:26', NULL, '8369042', '3217671548', '1061688835 POPAYAN', 'CARRERA 11 7-01 VALENCIA', 'faldipo@hotmail.com', 1, 4),
(3038, 3, 'OLGA MARIA', 'LONDOÑO', '2017-10-24 19:42:29', NULL, '0', '3158188497', '31148990', 'CARRERA 22 NO. 32-101', '0', 1, 3),
(3039, 3, 'RICARDO JOAQUIN ', 'CAICEDO LONDOÑO', '2017-10-24 19:43:33', NULL, '0', '0', '14698957', 'CRA', '0', 1, 3),
(3040, 2, 'ATH. DISTRIBUCIONES', 'ARTICULOS IMPORTADOS', '2017-10-26 22:18:13', NULL, 'NO REGISTRA', '3155634973', '16716501-0', 'NO REGISTRA', 'NO REGISTRA', 3, 2),
(3041, 2, 'WILLIAM ANDRES ', 'REYES VELASQUEZ', '2017-10-27 15:38:22', NULL, 'NO REGISTRA', 'NO REGISTRA', '94153807', 'NO REGISTRA', 'NO REGISTRA', 1, 2),
(3042, 4, 'Daniela', 'Guauña Guauña ', '2017-10-27 20:20:10', NULL, '3215147149', '3206286672', '106180384', 'VEREDA SILOE ', 'N/A', 1, 4),
(3043, 2, 'URIEL OLMEDO', 'TAPASCO CAÑAS', '2017-10-27 22:18:49', NULL, '2307975', '3108484048', '94368122', 'TRAV 12 25-16', 'NO REGISTRA', 1, 2),
(3044, 3, 'LEIDY VANESSA ', 'SOLARTE', '2017-10-30 22:26:18', NULL, '0', '3167293396', '1113628770', 'CALLE 25 D No. 38-21 B/ OLIMPICO', '0', 1, 3),
(3045, 4, 'MAXIDULCES ', 'LA QUINTA', '2017-10-30 22:59:49', NULL, '8208871', '8208871', '34560244', 'CRA 5A N° -65 ', 'N/A', 1, 4),
(3046, 3, 'CENTRO CULTURAL COLOMBO AMERICANO', 'CALI', '2017-11-01 23:43:34', NULL, '6875800', '0', '890.300.445-0', 'CALLE 13 NORTE No. 8-45', '0', 3, 3),
(3047, 3, 'ADOLFO LEON', 'CORDERO SERRATO', '2017-11-02 23:52:55', NULL, '2755435', '3154190503', '94.305.820-5', 'CALLE 25 NO. 31-34 B/ BARRIO NUEVO', '0', 1, 3),
(3048, 4, 'BORIS PLAST ', 'POPAYAN ', '2017-11-03 01:10:58', NULL, '8220113', '3188426468', '34559243', 'CALLE 7 A # 5A - 18 CENTRO ', 'N/A', 3, 4),
(3049, 4, 'COMUNICACIONES ', 'STAR POPAYAN ', '2017-11-03 01:14:15', NULL, '3125878689', '3108257784', '1061694282-0', 'LOCAL 7', 'N/A', 3, 4),
(3050, 2, 'DOLLARCITY ', 'BUGA ZONA ROSA', '2017-11-03 22:33:05', NULL, 'NO REGISTRA', 'NO REGISTRA', '900943243-4', 'CLL 3NO 8-81/87', 'NO REGISTRA', 3, 2),
(3051, 2, 'Julian Alejandro Hernandez', 'Click Publicitario', '2017-11-04 16:25:54', NULL, '2247198', '3168924198', '1116247583-5', 'Clll 30 no 25-68', 'no regstra', 3, 2),
(3052, 2, 'RAFAEL HERNANDO', 'RAMIREZ ALVARES', '2017-11-04 19:16:00', NULL, 'NO REGISTRA', '3164396929', '19384968', 'CRA 25 33-54', 'NO REGISTRA', 1, 2),
(3053, 4, 'DIANA ZUGEIDY ', 'URBANO SILVA', '2017-11-07 13:43:21', NULL, '3162900457', '3176827805', '25281151', 'CALLE 5A  21-40', 'dia_a2009@hotmail.com', 1, 4),
(3054, 4, 'GRAN MADRUGON ', 'DEL CAUCA  ', '2017-11-07 22:30:33', NULL, '8395895', '8395895', '1061748431-5', 'CALLE 7 # 5-52 ', 'N/A', 3, 4),
(3055, 3, 'EDNA ANDREA ', 'FILOTEO', '2017-11-07 22:55:14', NULL, '0', '3126146902', '1112220406', 'PRADERA', '0', 1, 1033),
(3056, 2, 'CENTRO LABORAL DE CAPACITACION LABORAL', 'CENAL', '2017-11-10 14:28:30', NULL, '2257787', 'NO REGISTRA', '805026596-0', 'CRA 27A 22-390', 'DIRECCIONTULUA@CENAL.COM.CO', 3, 2);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `recibo_caja`
--

DROP TABLE IF EXISTS `recibo_caja`;
CREATE TABLE IF NOT EXISTS `recibo_caja` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `usuario_id` int(10) UNSIGNED DEFAULT NULL,
  `sede_id` int(10) UNSIGNED DEFAULT NULL,
  `consecutivo` int(11) DEFAULT NULL,
  `descripcion` varchar(1024) DEFAULT NULL,
  `descuento` float DEFAULT '0',
  `impresion` tinyint(1) DEFAULT NULL,
  `fecha_pago` date DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `impresion_cuadre` tinyint(1) DEFAULT '0',
  `ingreso_recibo` tinyint(1) DEFAULT '0',
  `concepto_anulacion` varchar(400) DEFAULT NULL,
  `id_concepto_anulacion` int(11) DEFAULT NULL,
  `impresion_foga` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `fk_recibo_caja_sede` (`sede_id`),
  KEY `fk_recibo_caja_usuario` (`usuario_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `recibo_caja`
--

INSERT INTO `recibo_caja` (`id`, `usuario_id`, `sede_id`, `consecutivo`, `descripcion`, `descuento`, `impresion`, `fecha_pago`, `created_at`, `deleted_at`, `impresion_cuadre`, `ingreso_recibo`, `concepto_anulacion`, `id_concepto_anulacion`, `impresion_foga`) VALUES
(1, 1, 1, 1, '', 0, 1, '2017-11-15', '2017-11-15 16:04:02', NULL, 0, 0, NULL, NULL, 0),
(2, 1, 1, 2, '', 0, 0, '2017-11-15', '2017-11-15 19:41:07', NULL, 0, 0, NULL, NULL, 0),
(3, 1, 1, 3, '', 0, 1, '2017-11-22', '2017-11-22 14:32:35', NULL, 0, 0, NULL, NULL, 0);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `recibo_caja_detalle`
--

DROP TABLE IF EXISTS `recibo_caja_detalle`;
CREATE TABLE IF NOT EXISTS `recibo_caja_detalle` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `recibo_caja_id` int(10) UNSIGNED DEFAULT NULL,
  `detalle_factura_id` int(10) UNSIGNED DEFAULT NULL,
  `programas_id` int(10) UNSIGNED DEFAULT NULL,
  `valor` decimal(10,2) DEFAULT NULL,
  `observacion` varchar(1024) DEFAULT NULL,
  `saldo` decimal(10,2) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `concepto_id` int(10) UNSIGNED DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_recibo_caja_detalle_concepto` (`concepto_id`),
  KEY `fk_recibo_caja_detalle_detalle_factura` (`detalle_factura_id`),
  KEY `fk_recibo_caja_detalle_programas` (`programas_id`),
  KEY `fk_recibo_caja_detalle_recibo_caja` (`recibo_caja_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `recibo_caja_detalle`
--

INSERT INTO `recibo_caja_detalle` (`id`, `recibo_caja_id`, `detalle_factura_id`, `programas_id`, `valor`, `observacion`, `saldo`, `created_at`, `deleted_at`, `concepto_id`) VALUES
(1, 1, 1, 0, '60000.00', 'Pago ', '0.00', '2017-11-15 16:04:02', NULL, 1),
(2, 2, 2, 0, '22000.00', 'Pago ', '0.00', '2017-11-15 19:41:07', NULL, 3),
(3, 3, 3, 0, '40000.00', 'Pago ', '0.00', '2017-11-22 14:32:35', NULL, 6),
(4, 3, 4, 0, '90000.00', 'Pago Cuota Noviembre de 2017', '0.00', '2017-11-22 14:32:36', NULL, 2);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `recibo_caja_pivot_estudiante`
--

DROP TABLE IF EXISTS `recibo_caja_pivot_estudiante`;
CREATE TABLE IF NOT EXISTS `recibo_caja_pivot_estudiante` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `recibo_caja_id` int(10) UNSIGNED DEFAULT NULL,
  `estudiante_id` int(10) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_recibo_caja_pivot_estudiante_estudiante` (`estudiante_id`),
  KEY `fk_recibo_caja_pivot_estudiante_recibo_caja` (`recibo_caja_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `recibo_caja_pivot_proveedores`
--

DROP TABLE IF EXISTS `recibo_caja_pivot_proveedores`;
CREATE TABLE IF NOT EXISTS `recibo_caja_pivot_proveedores` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `recibo_caja_id` int(10) UNSIGNED DEFAULT NULL,
  `proveedores_id` int(10) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_recibo_caja_pivot_proveedores_proveedores` (`proveedores_id`),
  KEY `fk_recibo_caja_pivot_proveedores_recibo_caja` (`recibo_caja_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `recordar_me`
--

DROP TABLE IF EXISTS `recordar_me`;
CREATE TABLE IF NOT EXISTS `recordar_me` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `usuario_id` int(10) UNSIGNED NOT NULL,
  `ip_address` varchar(50) CHARACTER SET utf8 COLLATE utf8_spanish2_ci NOT NULL,
  `hash_cookie` varchar(32) CHARACTER SET utf8 COLLATE utf8_spanish2_ci NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `recordar_me_ip_address_hash_cookie_Idx` (`ip_address`,`hash_cookie`) USING BTREE,
  KEY `recordar_me_usuario_id_Idx` (`usuario_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=54 DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `recordar_me`
--

INSERT INTO `recordar_me` (`id`, `usuario_id`, `ip_address`, `hash_cookie`, `created_at`) VALUES
(1, 25, '181.49.229.122', '2ca0ce86b200779fd93b2cd5fea01667', '2017-06-05 21:22:59'),
(2, 25, '190.147.173.137', '6f36640aeb4b8ed2569ebe261caeaa9c', '2017-06-27 14:34:52'),
(3, 9, '181.49.219.211', '872bb0621ec2dba7f3dd357ee388f5ac', '2017-06-27 19:07:55'),
(4, 25, '190.147.173.137', 'fd296f85cb19ea744645d7661e5b3ead', '2017-06-27 20:00:53'),
(6, 9, '181.49.219.211', '27d68255a4a713e267f6746273d3e60e', '2017-06-28 15:22:21'),
(7, 9, '181.49.219.211', '0782c59dfb52610a5b36b5f99399a118', '2017-06-28 16:46:31'),
(8, 40, '181.49.219.211', '69983cfb9d07e3b3a1f83cb8cf7a15cb', '2017-06-29 12:33:16'),
(9, 40, '181.49.219.211', 'cb608263ea57ec7e7b83912b690dbd3a', '2017-06-29 21:06:14'),
(10, 40, '181.49.219.211', '1ee779cbae61387dce3cb09e6347176f', '2017-06-30 13:06:17'),
(12, 46, '190.147.170.11', '0a44a5c60db7727f621db6c088805fbc', '2017-06-30 15:48:37'),
(13, 43, '190.147.170.11', '6a97b4b05141d0c917ab335cc9a716f5', '2017-06-30 15:55:23'),
(14, 45, '190.147.170.11', 'e9096b2eca3295f9de8e83722ff6bc79', '2017-06-30 21:11:40'),
(15, 6, '181.49.219.211', '9fba5e04d5628709afda49f06c4cbcc0', '2017-07-08 13:37:08'),
(16, 23, '181.52.243.71', 'a4eac7da7e6e809e1db4aeee0feb087e', '2017-07-08 16:36:23'),
(18, 6, '181.49.219.211', 'ca1cda73400509a82615497122663561', '2017-07-11 23:09:39'),
(19, 6, '181.49.219.211', '7130eced7d3354a28b0ba9c4b4f5cc48', '2017-07-13 22:07:36'),
(20, 6, '181.49.219.211', 'e25d3876ad8a42cb2c88ffc37fce7a81', '2017-07-15 00:22:33'),
(21, 6, '181.49.219.211', '2efa859978801dd171c9d60ade115356', '2017-07-15 14:37:13'),
(23, 52, '181.49.219.211', '014f6c662f293dc46fece47cc1fc9cad', '2017-07-17 21:52:07'),
(24, 52, '181.49.219.211', 'ea7d5094bced8c9b02da83718caa174a', '2017-07-18 13:24:11'),
(25, 52, '181.49.219.211', '3cad46a8119db0d2fe38e31a0b304f65', '2017-07-18 17:10:29'),
(26, 52, '181.49.219.211', 'e39b5b0d7bcef03cc1d39d8751b9684b', '2017-07-21 15:22:02'),
(27, 25, '186.81.193.100', 'ea6ad166586a2dd7da4a4fc875a841be', '2017-07-31 15:19:28'),
(28, 25, '186.81.193.100', '263b73e5408343a4b5a766e173639c8d', '2017-07-31 21:26:45'),
(29, 52, '181.49.219.211', 'a36bdf415fffbd7153cd82218e064c3d', '2017-08-10 23:47:51'),
(31, 39, '181.49.219.211', '37064ebfd5b761b1b21223c05ea53bea', '2017-08-16 16:43:21'),
(32, 25, '186.81.193.100', '6a1bf4e04c6b179acfec53b3af85ea8b', '2017-08-17 18:43:37'),
(34, 55, '190.146.41.81', '3e1697fcd709a5dbedf3050cd13ea2ca', '2017-08-19 13:01:48'),
(35, 25, '186.81.193.100', '80cebd596edc158e74df87ffe46fa818', '2017-08-22 19:29:05'),
(37, 43, '181.49.219.211', '74ee7b2d5aff40700ac740cdf668e564', '2017-09-11 18:51:55'),
(38, 43, '181.49.219.211', '35e81ac15d2bcc3c2302a6b82ada5df9', '2017-09-11 22:26:59'),
(39, 25, '186.81.193.100', '22f681ebfc6c028ec53642f582016cb3', '2017-09-12 21:57:30'),
(40, 43, '181.49.219.211', 'ab92c0bfdaa92b6b5780517827b79be5', '2017-09-13 13:16:10'),
(41, 43, '181.49.219.211', 'b700a18d4f9856cdd0b833a2a5f3ca8f', '2017-09-13 19:58:39'),
(42, 43, '181.49.219.211', 'fd54ddcd64788c058f151593b1f11c5e', '2017-09-14 15:36:45'),
(43, 43, '181.49.219.211', '31575cbf05ed14c41309525a86063f4c', '2017-09-14 16:11:13'),
(45, 43, '181.49.219.211', 'a6abce44830addd46413895319e5fbe1', '2017-09-14 21:28:10'),
(46, 43, '181.49.219.211', 'ba2e28dbc2b47cee876608460d00f560', '2017-09-14 22:34:37'),
(47, 43, '181.49.219.211', '714041c183691a99de40b40cfc3aa1dd', '2017-09-14 22:34:41'),
(48, 43, '181.49.219.211', 'cd8640b3c41ad9950e2e423c47d7d943', '2017-09-15 14:21:26'),
(49, 43, '181.49.219.211', '9de4018719d56bb0f440010879158e06', '2017-09-15 21:32:33'),
(50, 43, '181.49.219.211', '487789608e7659f15797cbd550f8f1ce', '2017-09-16 15:25:11'),
(51, 43, '181.49.219.211', '85c83789f3f443d4d05b60cd948e3323', '2017-09-16 17:52:35'),
(52, 46, '181.49.219.211', 'a286cca6a2db4a3b079ada9838051be6', '2017-09-20 14:12:54'),
(53, 43, '181.49.219.211', '400c5eaff08f840e9cde5c1d09376bd9', '2017-09-26 23:26:42');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sede`
--

DROP TABLE IF EXISTS `sede`;
CREATE TABLE IF NOT EXISTS `sede` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `nombre` varchar(25) CHARACTER SET utf8 COLLATE utf8_spanish2_ci DEFAULT NULL,
  `direccion` varchar(255) CHARACTER SET utf8 COLLATE utf8_spanish2_ci DEFAULT NULL,
  `ciudad` varchar(255) CHARACTER SET utf8 COLLATE utf8_spanish2_ci DEFAULT NULL,
  `telefono` varchar(150) CHARACTER SET utf8 COLLATE utf8_spanish2_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `consecutivo_estudiante` int(11) DEFAULT NULL,
  `codigo_sede` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `sede`
--

INSERT INTO `sede` (`id`, `nombre`, `direccion`, `ciudad`, `telefono`, `created_at`, `deleted_at`, `consecutivo_estudiante`, `codigo_sede`) VALUES
(1, 'Cenal Cali', 'Calle 34 No. 2 Bis - 70', 'Cali', '681-7301', '2016-11-23 19:56:30', NULL, 3112, 2),
(2, 'Cenal Tuluá', 'Carrera 23 No. 32-41', 'Tuluá', '224-3285', '2016-11-23 21:06:31', NULL, 1189, 3),
(3, 'Cenal Palmira', 'Calle 31 No. 23-44', 'Palmira', '266-0099', '2016-11-23 21:06:53', NULL, 1477, 4),
(4, 'Cenal Popayán', 'Carrera 3 No. 1A Norte - 15', 'Popayán', '822-1132', '2017-01-17 05:00:00', NULL, 843, 5),
(5, 'CBC-CENAL CALI', NULL, NULL, NULL, NULL, '2017-06-27 03:00:02', NULL, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tarifas`
--

DROP TABLE IF EXISTS `tarifas`;
CREATE TABLE IF NOT EXISTS `tarifas` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `inscripcion` int(11) NOT NULL,
  `matricula` int(11) NOT NULL,
  `estampilla` int(11) NOT NULL,
  `cuota_inicial` int(11) NOT NULL,
  `duracion` int(11) NOT NULL,
  `jornada_id` int(11) NOT NULL,
  `sede_id` int(11) NOT NULL,
  `programa_id` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=282 DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `tarifas`
--

INSERT INTO `tarifas` (`id`, `inscripcion`, `matricula`, `estampilla`, `cuota_inicial`, `duracion`, `jornada_id`, `sede_id`, `programa_id`, `created_at`, `deleted_at`) VALUES
(1, 40000, 260000, 48000, 130000, 4, 1, 1, 2, '2017-10-23 15:42:32', NULL),
(2, 40000, 260000, 48000, 130000, 4, 2, 1, 2, '2017-10-23 15:42:32', NULL),
(3, 40000, 260000, 48000, 110000, 4, 3, 1, 2, '2017-10-23 15:42:32', NULL),
(4, 40000, 260000, 48000, 110000, 4, 6, 1, 2, '2017-10-23 15:42:32', NULL),
(5, 40000, 260000, 48000, 130000, 5, 4, 1, 2, '2017-10-23 15:42:32', NULL),
(6, 40000, 260000, 48000, 110000, 5, 5, 1, 2, '2017-10-23 15:42:32', NULL),
(7, 40000, 220000, 42000, 105000, 4, 1, 1, 4, '2017-10-23 15:42:32', NULL),
(8, 40000, 220000, 42000, 105000, 4, 2, 1, 4, '2017-10-23 15:42:32', NULL),
(9, 40000, 220000, 42000, 95000, 4, 3, 1, 4, '2017-10-23 15:42:32', NULL),
(10, 40000, 220000, 42000, 95000, 4, 6, 1, 4, '2017-10-23 15:42:32', NULL),
(11, 40000, 220000, 42000, 105000, 5, 4, 1, 4, '2017-10-23 15:42:32', NULL),
(12, 40000, 220000, 42000, 95000, 5, 5, 1, 4, '2017-10-23 15:42:32', NULL),
(13, 40000, 220000, 37000, 95000, 4, 1, 1, 1, '2017-10-23 15:42:32', NULL),
(14, 40000, 220000, 37000, 95000, 4, 2, 1, 1, '2017-10-23 15:42:32', NULL),
(15, 40000, 220000, 37000, 95000, 4, 3, 1, 1, '2017-10-23 15:42:32', NULL),
(16, 40000, 220000, 37000, 95000, 4, 6, 1, 1, '2017-10-23 15:42:32', NULL),
(17, 40000, 220000, 37000, 95000, 5, 4, 1, 1, '2017-10-23 15:42:32', NULL),
(18, 40000, 220000, 37000, 95000, 5, 5, 1, 1, '2017-10-23 15:42:32', NULL),
(19, 40000, 220000, 37000, 95000, 4, 1, 1, 5, '2017-10-23 15:42:32', NULL),
(20, 40000, 220000, 37000, 95000, 4, 2, 1, 5, '2017-10-23 15:42:32', NULL),
(21, 40000, 220000, 37000, 95000, 4, 3, 1, 5, '2017-10-23 15:42:32', NULL),
(22, 40000, 220000, 37000, 95000, 4, 6, 1, 5, '2017-10-23 15:42:32', NULL),
(23, 40000, 220000, 37000, 95000, 5, 4, 1, 5, '2017-10-23 15:42:32', NULL),
(24, 40000, 220000, 37000, 95000, 5, 5, 1, 5, '2017-10-23 15:42:32', NULL),
(25, 40000, 180000, 22000, 120000, 3, 1, 1, 64, '2017-10-23 15:42:32', NULL),
(26, 40000, 180000, 22000, 120000, 3, 2, 1, 64, '2017-10-23 15:42:32', NULL),
(27, 40000, 180000, 22000, 100000, 3, 3, 1, 64, '2017-10-23 15:42:32', NULL),
(28, 40000, 180000, 22000, 100000, 3, 6, 1, 64, '2017-10-23 15:42:32', NULL),
(29, 40000, 180000, 22000, 120000, 4, 4, 1, 64, '2017-10-23 15:42:32', NULL),
(30, 40000, 180000, 22000, 100000, 4, 5, 1, 64, '2017-10-23 15:42:32', NULL),
(31, 40000, 90000, 26000, 90000, 3, 1, 1, 77, '2017-10-23 15:42:32', NULL),
(32, 40000, 90000, 26000, 90000, 3, 2, 1, 77, '2017-10-23 15:42:32', NULL),
(33, 40000, 90000, 26000, 80000, 3, 3, 1, 77, '2017-10-23 15:42:32', NULL),
(34, 40000, 90000, 26000, 90000, 3, 6, 1, 77, '2017-10-23 15:42:32', NULL),
(35, 40000, 90000, 26000, 90000, 4, 4, 1, 77, '2017-10-23 15:42:32', NULL),
(36, 40000, 90000, 26000, 80000, 4, 5, 1, 77, '2017-10-23 15:42:32', NULL),
(37, 40000, 180000, 41000, 120000, 4, 1, 1, 11, '2017-10-23 15:42:32', NULL),
(38, 40000, 180000, 41000, 120000, 4, 2, 1, 11, '2017-10-23 15:42:32', NULL),
(39, 40000, 180000, 41000, 120000, 4, 3, 1, 11, '2017-10-23 15:42:32', NULL),
(40, 40000, 180000, 41000, 120000, 4, 6, 1, 11, '2017-10-23 15:42:32', NULL),
(41, 40000, 180000, 41000, 120000, 5, 4, 1, 11, '2017-10-23 15:42:32', NULL),
(42, 40000, 180000, 41000, 120000, 5, 5, 1, 11, '2017-10-23 15:42:32', NULL),
(43, 40000, 180000, 27000, 95000, 3, 1, 1, 6, '2017-10-23 15:42:32', NULL),
(44, 40000, 180000, 27000, 95000, 3, 2, 1, 6, '2017-10-23 15:42:32', NULL),
(45, 40000, 180000, 27000, 80000, 3, 3, 1, 6, '2017-10-23 15:42:32', NULL),
(46, 40000, 180000, 27000, 80000, 3, 6, 1, 6, '2017-10-23 15:42:32', NULL),
(47, 40000, 180000, 27000, 95000, 4, 4, 1, 6, '2017-10-23 15:42:32', NULL),
(48, 40000, 180000, 27000, 80000, 4, 5, 1, 6, '2017-10-23 15:42:32', NULL),
(49, 40000, 100000, 15000, 90000, 2, 1, 1, 10, '2017-10-23 15:42:32', NULL),
(50, 40000, 100000, 15000, 90000, 2, 2, 1, 10, '2017-10-23 15:42:32', NULL),
(51, 40000, 100000, 15000, 80000, 2, 3, 1, 10, '2017-10-23 15:42:32', NULL),
(52, 40000, 100000, 15000, 90000, 2, 6, 1, 10, '2017-10-23 15:42:32', NULL),
(53, 40000, 100000, 15000, 90000, 3, 4, 1, 10, '2017-10-23 15:42:32', NULL),
(54, 40000, 100000, 15000, 80000, 3, 5, 1, 10, '2017-10-23 15:42:32', NULL),
(55, 40000, 90000, 26000, 90000, 3, 1, 1, 78, '2017-10-23 15:42:32', NULL),
(56, 40000, 90000, 26000, 90000, 3, 2, 1, 78, '2017-10-23 15:42:32', NULL),
(57, 40000, 90000, 26000, 80000, 3, 3, 1, 78, '2017-10-23 15:42:32', NULL),
(58, 40000, 90000, 26000, 90000, 3, 6, 1, 78, '2017-10-23 15:42:32', NULL),
(59, 40000, 90000, 26000, 90000, 4, 4, 1, 78, '2017-10-23 15:42:32', NULL),
(60, 40000, 90000, 26000, 80000, 4, 5, 1, 78, '2017-10-23 15:42:32', NULL),
(61, 40000, 60000, 22000, 90000, 3, 1, 1, 7, '2017-10-23 15:42:32', NULL),
(62, 40000, 60000, 22000, 90000, 3, 2, 1, 7, '2017-10-23 15:42:32', NULL),
(63, 40000, 60000, 22000, 80000, 3, 3, 1, 7, '2017-10-23 15:42:32', NULL),
(64, 40000, 60000, 22000, 90000, 3, 6, 1, 7, '2017-10-23 15:42:32', NULL),
(65, 40000, 60000, 22000, 90000, 4, 4, 1, 7, '2017-10-23 15:42:32', NULL),
(66, 40000, 60000, 22000, 80000, 4, 5, 1, 7, '2017-10-23 15:42:32', NULL),
(67, 40000, 60000, 20000, 70000, 3, 1, 1, 8, '2017-10-23 15:42:32', NULL),
(68, 40000, 60000, 20000, 70000, 3, 2, 1, 8, '2017-10-23 15:42:32', NULL),
(69, 40000, 60000, 20000, 70000, 3, 3, 1, 8, '2017-10-23 15:42:32', NULL),
(70, 40000, 60000, 20000, 70000, 3, 6, 1, 8, '2017-10-23 15:42:32', NULL),
(71, 40000, 60000, 20000, 70000, 4, 4, 1, 8, '2017-10-23 15:42:32', NULL),
(72, 40000, 60000, 20000, 70000, 4, 5, 1, 8, '2017-10-23 15:42:32', NULL),
(73, 40000, 70000, 23000, 85000, 3, 1, 1, 9, '2017-10-23 15:42:32', NULL),
(74, 40000, 70000, 23000, 85000, 3, 2, 1, 9, '2017-10-23 15:42:32', NULL),
(75, 40000, 70000, 23000, 65000, 3, 3, 1, 9, '2017-10-23 15:42:32', NULL),
(76, 40000, 70000, 23000, 65000, 3, 6, 1, 9, '2017-10-23 15:42:32', NULL),
(77, 40000, 70000, 23000, 85000, 4, 4, 1, 9, '2017-10-23 15:42:32', NULL),
(78, 40000, 70000, 23000, 65000, 4, 5, 1, 9, '2017-10-23 15:42:32', NULL),
(79, 30000, 260000, 0, 120000, 4, 1, 2, 13, '2017-10-23 18:36:10', NULL),
(80, 30000, 260000, 0, 120000, 4, 2, 2, 13, '2017-10-23 18:36:10', NULL),
(81, 30000, 260000, 0, 110000, 4, 3, 2, 13, '2017-10-23 18:36:10', NULL),
(82, 30000, 260000, 0, 110000, 4, 6, 2, 13, '2017-10-23 18:36:10', NULL),
(83, 30000, 260000, 0, 120000, 5, 4, 2, 13, '2017-10-23 18:36:10', NULL),
(84, 30000, 260000, 0, 120000, 5, 5, 2, 13, '2017-10-23 18:36:10', NULL),
(85, 30000, 260000, 0, 120000, 5, 7, 2, 13, '2017-10-23 18:36:10', NULL),
(86, 30000, 220000, 0, 100000, 4, 1, 2, 15, '2017-10-23 18:36:10', NULL),
(87, 30000, 220000, 0, 100000, 4, 2, 2, 15, '2017-10-23 18:36:10', NULL),
(88, 30000, 220000, 0, 95000, 4, 3, 2, 15, '2017-10-23 18:36:10', NULL),
(89, 30000, 220000, 0, 95000, 4, 6, 2, 15, '2017-10-23 18:36:10', NULL),
(90, 30000, 220000, 0, 100000, 5, 4, 2, 15, '2017-10-23 18:36:10', NULL),
(91, 30000, 220000, 0, 100000, 5, 5, 2, 15, '2017-10-23 18:36:10', NULL),
(92, 30000, 220000, 0, 100000, 5, 7, 2, 15, '2017-10-23 18:36:10', NULL),
(93, 30000, 220000, 0, 85000, 4, 1, 2, 12, '2017-10-23 18:36:10', NULL),
(94, 30000, 220000, 0, 85000, 4, 2, 2, 12, '2017-10-23 18:36:10', NULL),
(95, 30000, 220000, 0, 75000, 4, 3, 2, 12, '2017-10-23 18:36:10', NULL),
(96, 30000, 220000, 0, 75000, 4, 6, 2, 12, '2017-10-23 18:36:10', NULL),
(97, 30000, 220000, 0, 85000, 5, 4, 2, 12, '2017-10-23 18:36:10', NULL),
(98, 30000, 220000, 0, 85000, 5, 5, 2, 12, '2017-10-23 18:36:10', NULL),
(99, 30000, 200000, 0, 80000, 4, 1, 2, 16, '2017-10-23 18:36:10', NULL),
(100, 30000, 200000, 0, 80000, 4, 2, 2, 16, '2017-10-23 18:36:10', NULL),
(101, 30000, 200000, 0, 75000, 4, 3, 2, 16, '2017-10-23 18:36:10', NULL),
(102, 30000, 200000, 0, 75000, 4, 6, 2, 16, '2017-10-23 18:36:10', NULL),
(103, 30000, 200000, 0, 80000, 5, 4, 2, 16, '2017-10-23 18:36:10', NULL),
(104, 30000, 200000, 0, 80000, 5, 5, 2, 16, '2017-10-23 18:36:10', NULL),
(105, 30000, 90000, 0, 80000, 3, 1, 2, 74, '2017-10-23 18:36:10', NULL),
(106, 30000, 90000, 0, 80000, 3, 2, 2, 74, '2017-10-23 18:36:10', NULL),
(107, 30000, 90000, 0, 70000, 3, 3, 2, 74, '2017-10-23 18:36:10', NULL),
(108, 30000, 90000, 0, 80000, 3, 6, 2, 74, '2017-10-23 18:36:10', NULL),
(109, 30000, 90000, 0, 80000, 4, 4, 2, 74, '2017-10-23 18:36:10', NULL),
(110, 30000, 90000, 0, 70000, 4, 5, 2, 74, '2017-10-23 18:36:10', NULL),
(111, 30000, 180000, 0, 90000, 2, 1, 2, 14, '2017-10-23 18:36:10', NULL),
(112, 30000, 180000, 0, 90000, 2, 2, 2, 14, '2017-10-23 18:36:10', NULL),
(113, 30000, 180000, 0, 80000, 2, 3, 2, 14, '2017-10-23 18:36:10', NULL),
(114, 30000, 180000, 0, 80000, 2, 6, 2, 14, '2017-10-23 18:36:10', NULL),
(115, 30000, 180000, 0, 90000, 3, 4, 2, 14, '2017-10-23 18:36:10', NULL),
(116, 30000, 180000, 0, 90000, 3, 5, 2, 14, '2017-10-23 18:36:10', NULL),
(117, 30000, 180000, 0, 110000, 4, 1, 2, 22, '2017-10-23 18:36:10', NULL),
(118, 30000, 180000, 0, 110000, 4, 2, 2, 22, '2017-10-23 18:36:10', NULL),
(119, 30000, 180000, 0, 100000, 4, 3, 2, 22, '2017-10-23 18:36:10', NULL),
(120, 30000, 180000, 0, 100000, 4, 6, 2, 22, '2017-10-23 18:36:10', NULL),
(121, 30000, 180000, 0, 110000, 5, 4, 2, 22, '2017-10-23 18:36:10', NULL),
(122, 30000, 180000, 0, 110000, 5, 5, 2, 22, '2017-10-23 18:36:10', NULL),
(123, 30000, 180000, 0, 80000, 3, 1, 2, 17, '2017-10-23 18:36:10', NULL),
(124, 30000, 180000, 0, 80000, 3, 2, 2, 17, '2017-10-23 18:36:10', NULL),
(125, 30000, 180000, 0, 70000, 3, 3, 2, 17, '2017-10-23 18:36:10', NULL),
(126, 30000, 180000, 0, 70000, 3, 6, 2, 17, '2017-10-23 18:36:10', NULL),
(127, 30000, 180000, 0, 80000, 4, 4, 2, 17, '2017-10-23 18:36:10', NULL),
(128, 30000, 180000, 0, 80000, 4, 5, 2, 17, '2017-10-23 18:36:10', NULL),
(129, 30000, 100000, 0, 80000, 2, 1, 2, 21, '2017-10-23 18:36:10', NULL),
(130, 30000, 100000, 0, 80000, 2, 2, 2, 21, '2017-10-23 18:36:10', NULL),
(131, 30000, 100000, 0, 70000, 2, 3, 2, 21, '2017-10-23 18:36:10', NULL),
(132, 30000, 100000, 0, 70000, 2, 6, 2, 21, '2017-10-23 18:36:10', NULL),
(133, 30000, 100000, 0, 80000, 3, 4, 2, 21, '2017-10-23 18:36:10', NULL),
(134, 30000, 100000, 0, 80000, 3, 5, 2, 21, '2017-10-23 18:36:10', NULL),
(135, 30000, 100000, 0, 80000, 3, 7, 2, 21, '2017-10-23 18:36:10', NULL),
(136, 30000, 60000, 0, 75000, 3, 1, 2, 18, '2017-10-23 18:36:10', NULL),
(137, 30000, 60000, 0, 75000, 3, 2, 2, 18, '2017-10-23 18:36:10', NULL),
(138, 30000, 60000, 0, 65000, 3, 3, 2, 18, '2017-10-23 18:36:10', NULL),
(139, 30000, 60000, 0, 65000, 3, 6, 2, 18, '2017-10-23 18:36:10', NULL),
(140, 30000, 60000, 0, 75000, 4, 4, 2, 18, '2017-10-23 18:36:10', NULL),
(141, 30000, 60000, 0, 75000, 4, 5, 2, 18, '2017-10-23 18:36:10', NULL),
(142, 30000, 60000, 0, 75000, 4, 7, 2, 18, '2017-10-23 18:36:10', NULL),
(143, 30000, 60000, 0, 65000, 3, 1, 2, 19, '2017-10-23 18:36:10', NULL),
(144, 30000, 60000, 0, 65000, 3, 2, 2, 19, '2017-10-23 18:36:10', NULL),
(145, 30000, 60000, 0, 65000, 3, 3, 2, 19, '2017-10-23 18:36:10', NULL),
(146, 30000, 60000, 0, 65000, 3, 6, 2, 19, '2017-10-23 18:36:10', NULL),
(147, 30000, 60000, 0, 65000, 4, 4, 2, 19, '2017-10-23 18:36:10', NULL),
(148, 30000, 60000, 0, 65000, 4, 5, 2, 19, '2017-10-23 18:36:10', NULL),
(149, 30000, 60000, 0, 65000, 4, 7, 2, 19, '2017-10-23 18:36:10', NULL),
(150, 30000, 260000, 0, 120000, 4, 1, 3, 24, '2017-10-23 18:47:44', NULL),
(151, 30000, 260000, 0, 120000, 4, 2, 3, 24, '2017-10-23 18:47:45', NULL),
(152, 30000, 260000, 0, 110000, 4, 3, 3, 24, '2017-10-23 18:47:45', NULL),
(153, 30000, 260000, 0, 110000, 4, 6, 3, 24, '2017-10-23 18:47:45', NULL),
(154, 30000, 260000, 0, 120000, 5, 4, 3, 24, '2017-10-23 18:47:45', NULL),
(155, 30000, 260000, 0, 110000, 5, 5, 3, 24, '2017-10-23 18:47:45', NULL),
(156, 30000, 220000, 0, 105000, 4, 1, 3, 26, '2017-10-23 18:47:45', NULL),
(157, 30000, 220000, 0, 105000, 4, 2, 3, 26, '2017-10-23 18:47:45', NULL),
(158, 30000, 220000, 0, 95000, 4, 3, 3, 26, '2017-10-23 18:47:45', NULL),
(159, 30000, 220000, 0, 95000, 4, 6, 3, 26, '2017-10-23 18:47:45', NULL),
(160, 30000, 220000, 0, 105000, 5, 4, 3, 26, '2017-10-23 18:47:45', NULL),
(161, 30000, 220000, 0, 95000, 5, 5, 3, 26, '2017-10-23 18:47:45', NULL),
(162, 30000, 220000, 0, 90000, 4, 1, 3, 23, '2017-10-23 18:47:45', NULL),
(163, 30000, 220000, 0, 90000, 4, 2, 3, 23, '2017-10-23 18:47:45', NULL),
(164, 30000, 220000, 0, 80000, 4, 3, 3, 23, '2017-10-23 18:47:45', NULL),
(165, 30000, 220000, 0, 80000, 4, 6, 3, 23, '2017-10-23 18:47:45', NULL),
(166, 30000, 220000, 0, 90000, 5, 4, 3, 23, '2017-10-23 18:47:45', NULL),
(167, 30000, 220000, 0, 80000, 5, 5, 3, 23, '2017-10-23 18:47:45', NULL),
(168, 30000, 220000, 0, 90000, 4, 1, 3, 27, '2017-10-23 18:47:45', NULL),
(169, 30000, 220000, 0, 90000, 4, 2, 3, 27, '2017-10-23 18:47:45', NULL),
(170, 30000, 220000, 0, 80000, 4, 3, 3, 27, '2017-10-23 18:47:45', NULL),
(171, 30000, 220000, 0, 80000, 4, 6, 3, 27, '2017-10-23 18:47:45', NULL),
(172, 30000, 220000, 0, 90000, 5, 4, 3, 27, '2017-10-23 18:47:45', NULL),
(173, 30000, 220000, 0, 80000, 5, 5, 3, 27, '2017-10-23 18:47:45', NULL),
(174, 30000, 90000, 0, 80000, 3, 1, 3, 75, '2017-10-23 18:47:45', NULL),
(175, 30000, 90000, 0, 80000, 3, 2, 3, 75, '2017-10-23 18:47:45', NULL),
(176, 30000, 90000, 0, 70000, 3, 3, 3, 75, '2017-10-23 18:47:45', NULL),
(177, 30000, 90000, 0, 80000, 3, 6, 3, 75, '2017-10-23 18:47:45', NULL),
(178, 30000, 90000, 0, 80000, 4, 4, 3, 75, '2017-10-23 18:47:45', NULL),
(179, 30000, 90000, 0, 70000, 4, 5, 3, 75, '2017-10-23 18:47:45', NULL),
(180, 30000, 180000, 0, 105000, 2, 1, 3, 25, '2017-10-23 18:47:45', NULL),
(181, 30000, 180000, 0, 105000, 2, 2, 3, 25, '2017-10-23 18:47:45', NULL),
(182, 30000, 180000, 0, 95000, 2, 3, 3, 25, '2017-10-23 18:47:45', NULL),
(183, 30000, 180000, 0, 95000, 2, 6, 3, 25, '2017-10-23 18:47:45', NULL),
(184, 30000, 180000, 0, 105000, 3, 4, 3, 25, '2017-10-23 18:47:45', NULL),
(185, 30000, 180000, 0, 95000, 3, 5, 3, 25, '2017-10-23 18:47:45', NULL),
(186, 30000, 180000, 0, 105000, 4, 1, 3, 33, '2017-10-23 18:47:45', NULL),
(187, 30000, 180000, 0, 105000, 4, 2, 3, 33, '2017-10-23 18:47:45', NULL),
(188, 30000, 180000, 0, 95000, 4, 3, 3, 33, '2017-10-23 18:47:45', NULL),
(189, 30000, 180000, 0, 95000, 4, 6, 3, 33, '2017-10-23 18:47:45', NULL),
(190, 30000, 180000, 0, 105000, 5, 4, 3, 33, '2017-10-23 18:47:45', NULL),
(191, 30000, 180000, 0, 95000, 5, 5, 3, 33, '2017-10-23 18:47:45', NULL),
(192, 30000, 180000, 0, 85000, 3, 1, 3, 28, '2017-10-23 18:47:45', NULL),
(193, 30000, 180000, 0, 85000, 3, 2, 3, 28, '2017-10-23 18:47:45', NULL),
(194, 30000, 180000, 0, 75000, 3, 3, 3, 28, '2017-10-23 18:47:45', NULL),
(195, 30000, 180000, 0, 75000, 3, 6, 3, 28, '2017-10-23 18:47:45', NULL),
(196, 30000, 180000, 0, 85000, 4, 4, 3, 28, '2017-10-23 18:47:45', NULL),
(197, 30000, 180000, 0, 75000, 4, 5, 3, 28, '2017-10-23 18:47:45', NULL),
(198, 30000, 100000, 0, 80000, 2, 1, 3, 32, '2017-10-23 18:47:45', NULL),
(199, 30000, 100000, 0, 80000, 2, 2, 3, 32, '2017-10-23 18:47:45', NULL),
(200, 30000, 100000, 0, 70000, 2, 3, 3, 32, '2017-10-23 18:47:45', NULL),
(201, 30000, 100000, 0, 70000, 2, 6, 3, 32, '2017-10-23 18:47:45', NULL),
(202, 30000, 100000, 0, 80000, 3, 4, 3, 32, '2017-10-23 18:47:45', NULL),
(203, 30000, 100000, 0, 70000, 3, 5, 3, 32, '2017-10-23 18:47:45', NULL),
(204, 30000, 60000, 0, 80000, 3, 1, 3, 29, '2017-10-23 18:47:45', NULL),
(205, 30000, 60000, 0, 80000, 3, 2, 3, 29, '2017-10-23 18:47:45', NULL),
(206, 30000, 60000, 0, 70000, 3, 3, 3, 29, '2017-10-23 18:47:45', NULL),
(207, 30000, 60000, 0, 70000, 3, 6, 3, 29, '2017-10-23 18:47:45', NULL),
(208, 30000, 60000, 0, 80000, 4, 4, 3, 29, '2017-10-23 18:47:45', NULL),
(209, 30000, 60000, 0, 70000, 4, 5, 3, 29, '2017-10-23 18:47:45', NULL),
(210, 30000, 60000, 0, 65000, 3, 1, 3, 30, '2017-10-23 18:47:45', NULL),
(211, 30000, 60000, 0, 65000, 3, 2, 3, 30, '2017-10-23 18:47:45', NULL),
(212, 30000, 60000, 0, 60000, 3, 3, 3, 30, '2017-10-23 18:47:45', NULL),
(213, 30000, 60000, 0, 60000, 3, 6, 3, 30, '2017-10-23 18:47:45', NULL),
(214, 30000, 60000, 0, 65000, 4, 4, 3, 30, '2017-10-23 18:47:45', NULL),
(215, 30000, 60000, 0, 60000, 4, 5, 3, 30, '2017-10-23 18:47:45', NULL),
(216, 30000, 260000, 0, 115000, 4, 1, 4, 35, '2017-10-23 19:08:11', NULL),
(217, 30000, 260000, 0, 115000, 4, 2, 4, 35, '2017-10-23 19:08:11', NULL),
(218, 30000, 260000, 0, 105000, 4, 3, 4, 35, '2017-10-23 19:08:11', NULL),
(219, 30000, 260000, 0, 105000, 4, 6, 4, 35, '2017-10-23 19:08:11', NULL),
(220, 30000, 260000, 0, 115000, 5, 4, 4, 35, '2017-10-23 19:08:11', NULL),
(221, 30000, 260000, 0, 105000, 5, 5, 4, 35, '2017-10-23 19:08:11', NULL),
(222, 30000, 220000, 0, 100000, 4, 1, 4, 37, '2017-10-23 19:08:11', NULL),
(223, 30000, 220000, 0, 100000, 4, 2, 4, 37, '2017-10-23 19:08:11', NULL),
(224, 30000, 220000, 0, 95000, 4, 3, 4, 37, '2017-10-23 19:08:11', NULL),
(225, 30000, 220000, 0, 95000, 4, 6, 4, 37, '2017-10-23 19:08:11', NULL),
(226, 30000, 220000, 0, 100000, 5, 4, 4, 37, '2017-10-23 19:08:11', NULL),
(227, 30000, 220000, 0, 100000, 5, 5, 4, 37, '2017-10-23 19:08:11', NULL),
(228, 30000, 220000, 0, 85000, 4, 1, 4, 34, '2017-10-23 19:08:11', NULL),
(229, 30000, 220000, 0, 85000, 4, 2, 4, 34, '2017-10-23 19:08:11', NULL),
(230, 30000, 220000, 0, 80000, 4, 3, 4, 34, '2017-10-23 19:08:11', NULL),
(231, 30000, 220000, 0, 80000, 4, 6, 4, 34, '2017-10-23 19:08:11', NULL),
(232, 30000, 220000, 0, 85000, 5, 4, 4, 34, '2017-10-23 19:08:11', NULL),
(233, 30000, 220000, 0, 80000, 5, 5, 4, 34, '2017-10-23 19:08:11', NULL),
(234, 30000, 220000, 0, 85000, 4, 1, 4, 38, '2017-10-23 19:08:11', NULL),
(235, 30000, 220000, 0, 85000, 4, 2, 4, 38, '2017-10-23 19:08:11', NULL),
(236, 30000, 220000, 0, 80000, 4, 3, 4, 38, '2017-10-23 19:08:11', NULL),
(237, 30000, 220000, 0, 80000, 4, 6, 4, 38, '2017-10-23 19:08:11', NULL),
(238, 30000, 220000, 0, 85000, 5, 4, 4, 38, '2017-10-23 19:08:11', NULL),
(239, 30000, 220000, 0, 80000, 5, 5, 4, 38, '2017-10-23 19:08:11', NULL),
(240, 30000, 90000, 0, 85000, 3, 1, 4, 80, '2017-10-23 19:08:11', NULL),
(241, 30000, 90000, 0, 85000, 3, 2, 4, 80, '2017-10-23 19:08:11', NULL),
(242, 30000, 90000, 0, 75000, 3, 3, 4, 80, '2017-10-23 19:08:11', NULL),
(243, 30000, 90000, 0, 85000, 3, 6, 4, 80, '2017-10-23 19:08:11', NULL),
(244, 30000, 90000, 0, 85000, 4, 4, 4, 80, '2017-10-23 19:08:11', NULL),
(245, 30000, 90000, 0, 75000, 4, 5, 4, 80, '2017-10-23 19:08:11', NULL),
(246, 30000, 180000, 0, 100000, 3, 1, 4, 36, '2017-10-23 19:08:11', NULL),
(247, 30000, 180000, 0, 100000, 3, 2, 4, 36, '2017-10-23 19:08:11', NULL),
(248, 30000, 180000, 0, 90000, 3, 3, 4, 36, '2017-10-23 19:08:11', NULL),
(249, 30000, 180000, 0, 90000, 3, 6, 4, 36, '2017-10-23 19:08:11', NULL),
(250, 30000, 180000, 0, 100000, 3, 4, 4, 36, '2017-10-23 19:08:11', NULL),
(251, 30000, 180000, 0, 90000, 3, 5, 4, 36, '2017-10-23 19:08:11', NULL),
(252, 30000, 180000, 0, 100000, 4, 1, 4, 44, '2017-10-23 19:08:11', NULL),
(253, 30000, 180000, 0, 100000, 4, 2, 4, 44, '2017-10-23 19:08:11', NULL),
(254, 30000, 180000, 0, 90000, 4, 3, 4, 44, '2017-10-23 19:08:11', NULL),
(255, 30000, 180000, 0, 90000, 4, 6, 4, 44, '2017-10-23 19:08:11', NULL),
(256, 30000, 180000, 0, 100000, 5, 4, 4, 44, '2017-10-23 19:08:11', NULL),
(257, 30000, 180000, 0, 90000, 5, 5, 4, 44, '2017-10-23 19:08:11', NULL),
(258, 30000, 180000, 0, 90000, 3, 1, 4, 39, '2017-10-23 19:08:11', NULL),
(259, 30000, 180000, 0, 90000, 3, 2, 4, 39, '2017-10-23 19:08:11', NULL),
(260, 30000, 180000, 0, 80000, 3, 3, 4, 39, '2017-10-23 19:08:11', NULL),
(261, 30000, 180000, 0, 80000, 3, 6, 4, 39, '2017-10-23 19:08:11', NULL),
(262, 30000, 180000, 0, 90000, 4, 4, 4, 39, '2017-10-23 19:08:11', NULL),
(263, 30000, 180000, 0, 80000, 4, 5, 4, 39, '2017-10-23 19:08:11', NULL),
(264, 30000, 100000, 0, 75000, 2, 1, 4, 43, '2017-10-23 19:08:11', NULL),
(265, 30000, 100000, 0, 75000, 2, 2, 4, 43, '2017-10-23 19:08:11', NULL),
(266, 30000, 100000, 0, 70000, 2, 3, 4, 43, '2017-10-23 19:08:11', NULL),
(267, 30000, 100000, 0, 70000, 2, 6, 4, 43, '2017-10-23 19:08:11', NULL),
(268, 30000, 100000, 0, 75000, 3, 4, 4, 43, '2017-10-23 19:08:11', NULL),
(269, 30000, 100000, 0, 70000, 3, 5, 4, 43, '2017-10-23 19:08:11', NULL),
(270, 30000, 60000, 0, 75000, 3, 1, 4, 40, '2017-10-23 19:08:11', NULL),
(271, 30000, 60000, 0, 75000, 3, 2, 4, 40, '2017-10-23 19:08:11', NULL),
(272, 30000, 60000, 0, 70000, 3, 3, 4, 40, '2017-10-23 19:08:11', NULL),
(273, 30000, 60000, 0, 70000, 3, 6, 4, 40, '2017-10-23 19:08:11', NULL),
(274, 30000, 60000, 0, 75000, 4, 4, 4, 40, '2017-10-23 19:08:11', NULL),
(275, 30000, 60000, 0, 70000, 4, 5, 4, 40, '2017-10-23 19:08:11', NULL),
(276, 30000, 60000, 0, 65000, 3, 1, 4, 41, '2017-10-23 19:08:11', NULL),
(277, 30000, 60000, 0, 65000, 3, 2, 4, 41, '2017-10-23 19:08:11', NULL),
(278, 30000, 60000, 0, 60000, 3, 3, 4, 41, '2017-10-23 19:08:11', NULL),
(279, 30000, 60000, 0, 60000, 3, 6, 4, 41, '2017-10-23 19:08:11', NULL),
(280, 30000, 60000, 0, 65000, 4, 4, 4, 41, '2017-10-23 19:08:11', NULL),
(281, 30000, 60000, 0, 60000, 4, 5, 4, 41, '2017-10-23 19:08:11', NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `users`
--

DROP TABLE IF EXISTS `users`;
CREATE TABLE IF NOT EXISTS `users` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(191) NOT NULL,
  `email` varchar(191) NOT NULL,
  `password` varchar(191) NOT NULL,
  `rol` int(11) DEFAULT '0' COMMENT '0 = estudiante 1 = profesor',
  `remember_token` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `password`, `rol`, `remember_token`, `created_at`, `updated_at`) VALUES
(1, 'Duvier Marin Escobar', 'duvierm24@gmail.com', '$2y$10$UhqRjwilc7Wln5H0MRIngutVu/wDUaxZA887.uNr5uPJp2CIyQV6C', 0, 'xqJ6W6XfWzyauRDmXnqwvTNR7nrbItmozuEqtgB5hCLPyXQZTYiI2mTyUoIu', '2017-10-21 23:12:05', '2017-10-21 23:12:05'),
(2, 'Jhonny alejandro Diaz Tello', 'jhonnyalejo2212@gmail.com', '$2y$12$OxmKkJqD8qBFbkzDoXnbT.UbqfQvisDb97SI/rsVkgZ.pybBDaNOG', 0, NULL, NULL, NULL),
(3, 'RAMON ALBERTO OCAMPO TENORIO', 'inocampo1125@gmail.com', '$2y$12$zzyHqpKUvaeK7LdmLJZypOkC3mHY1pka747ba9AQpQj4CMWrSo8my', 0, NULL, NULL, NULL),
(4, 'Estudiante De  Prueba', 'estudiante@gmail.com', '$2y$12$rAJuXQE17ouOrpLgFDFe8uQFtTZnwJDzMHzC7CjucWExhOKbHNnHu', 0, 'ToYMobnc6mu2tMYygWg0aXqqY9ndTjN3PFkXGaDwlD6vl36xuGBv6rD1IO4E', NULL, NULL),
(5, 'Duvier Marin Escobar', 'duvierm24@gmail.com', '$2y$12$mTG/b4YFCp1qcr4xdmmN.uUzafKpobwvmXPow3ZirMjkJJbVykwgO', 0, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuario`
--

DROP TABLE IF EXISTS `usuario`;
CREATE TABLE IF NOT EXISTS `usuario` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_name` varchar(80) CHARACTER SET utf8 COLLATE utf8_spanish2_ci NOT NULL,
  `password` varchar(32) CHARACTER SET utf8 COLLATE utf8_spanish2_ci NOT NULL,
  `actived` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `last_login_at` timestamp NULL DEFAULT NULL,
  `credencial_id` int(10) UNSIGNED DEFAULT NULL,
  `sede_id` int(10) UNSIGNED DEFAULT NULL,
  `changue_password` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `nm_user_user_Idx` (`user_name`) USING BTREE,
  KEY `nm_user_user_password_Idx` (`user_name`,`password`) USING BTREE,
  KEY `usuario_actived_Idx` (`actived`) USING BTREE,
  KEY `usuario_user_password_actived_Idx` (`user_name`,`password`,`actived`) USING BTREE,
  KEY `fk_usuario_credencial` (`credencial_id`),
  KEY `fk_usuario_sede` (`sede_id`)
) ENGINE=InnoDB AUTO_INCREMENT=60 DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `usuario`
--

INSERT INTO `usuario` (`id`, `user_name`, `password`, `actived`, `created_at`, `updated_at`, `deleted_at`, `last_login_at`, `credencial_id`, `sede_id`, `changue_password`) VALUES
(1, 'admin', '655ccd537938976f5d1bfea11392856f', 1, '2017-11-22 14:32:18', NULL, NULL, '2017-11-22 14:32:18', 7, 1, 1),
(2, 'pruebatesorería', 'MAESTRO2017', 1, '2017-05-31 21:23:33', NULL, '2017-05-31 21:23:33', NULL, 2, 1, 0),
(3, 'jmosquera', '5f0b904c6dcf6ec31b2b2d505e1de436', 1, '2017-08-25 21:48:51', '2017-08-25 21:48:51', NULL, '2017-08-01 00:46:53', 3, 1, 0),
(4, 'jchavarro', '71345bc57a6e3e34fc891eff53befb32', 1, '2017-08-25 21:49:03', '2017-08-25 21:49:03', NULL, '2017-06-30 17:09:55', 3, 1, 0),
(5, 'vguauña', 'fb0bd9a06844c4c5b062ac240807fdc5', 1, '2017-11-14 12:57:26', '2017-08-03 19:59:37', NULL, '2017-11-14 12:57:26', 5, 1, 1),
(6, 'vflorez', '0da33628390308d4f29dd5b562d03d96', 1, '2017-11-11 15:55:19', '2017-09-07 15:19:57', NULL, '2017-11-11 15:55:19', 3, 1, 1),
(7, 'gcano', '45dd8b6fb4b986ca93efa700ff5d251e', 1, '2017-11-14 13:34:17', '2017-10-26 14:46:35', NULL, '2017-11-14 13:34:17', 1, 1, 1),
(8, 'jortega', '5429f92a6679e9488aa59791b80467c0', 1, '2017-07-07 15:51:31', NULL, NULL, '2017-06-30 16:40:10', 6, 1, 0),
(9, 'aoaguilar', '83946193fe94dd0b396fba2908c2979e', 1, '2017-11-11 18:27:53', '2017-09-16 15:37:25', NULL, '2017-11-11 18:27:53', 3, 1, 1),
(10, 'lcortes', '79d8a9d244c8bc4bebabe175859989af', 1, '2017-11-14 13:33:59', NULL, NULL, '2017-11-14 13:33:59', 2, 2, 1),
(11, 'pquitian', 'bdee83206f2d42a0d1ff70c4f8785f42', 1, '2017-11-14 13:52:06', NULL, NULL, '2017-11-14 13:52:06', 6, 2, 1),
(12, 'rodoñez', '690e108b8b87d93b34564031c0b977d4', 1, '2017-11-11 17:01:39', NULL, NULL, '2017-11-11 17:01:39', 6, 2, 1),
(13, 'pmorales', 'a853f7940117233662c63e0f6db4517b', 0, '2017-07-07 15:53:29', NULL, NULL, NULL, 2, 2, 0),
(14, 'pquintero', 'ad891472d4e32680c6d7a4df9117fd43', 0, '2017-07-07 15:53:37', NULL, NULL, '2017-06-30 22:59:35', 6, 3, 0),
(15, 'scabrera', 'be448584a60f363d97857c31afc71761', 1, '2017-11-14 13:42:30', NULL, NULL, '2017-11-14 13:42:30', 2, 3, 1),
(16, 'pyela', 'e3d3f643171e3e7a25a6b451dc55e479', 0, '2017-07-07 15:53:56', NULL, NULL, '2017-06-30 23:39:52', 6, 3, 0),
(17, 'jpolo', '0d5e5c9ee2d57b3a2a853d22cd0f1c05', 1, '2017-11-14 13:53:31', NULL, NULL, '2017-11-14 13:53:31', 6, 3, 1),
(18, 'mcastillo', '3e317925a7951bb80f5d336bfc86076b', 1, '2017-11-14 12:12:49', NULL, NULL, '2017-11-14 12:12:49', 2, 4, 1),
(19, 'yflorez', '8bdd5009049f4be9411392d71fd20e1b', 1, '2017-11-14 12:04:15', NULL, NULL, '2017-11-14 12:04:15', 6, 4, 1),
(20, 'lpinzon', 'c7fdd8ca61615d3e41675e47e742923e', 1, '2017-07-12 21:55:18', NULL, '2017-07-12 21:55:18', '2017-07-12 15:58:13', 5, 2, 0),
(21, 'cpinto', '6d425a305d27230b0d0a5e89ae7c8df6', 1, '2017-11-13 19:57:25', NULL, NULL, '2017-11-13 19:57:25', 5, 3, 1),
(22, 'cmotato', 'a949aefe77ba2209696eb38ada449d1e', 1, '2017-11-09 21:25:05', NULL, NULL, '2017-11-09 21:25:05', 5, 4, 1),
(23, 'aroldan', '5e9293ec0e9af596e20497dac3ef20ba', 1, '2017-07-10 21:16:26', NULL, NULL, '2017-07-10 21:16:26', 5, 2, 0),
(24, 'yrivera', '493f92b056d1e243d28bf76f0953d68f', 1, '2017-11-11 19:11:35', NULL, NULL, '2017-11-11 19:11:35', 5, 4, 1),
(25, 'ngrijalba', 'eabf7cb2b8fa15d3988c5ec8823b059c', 1, '2017-10-28 20:20:39', NULL, NULL, '2017-10-28 20:20:18', 5, 3, 1),
(26, 'smotato', 'c610851a0afc2745c5f73ad4cf237df6', 1, '2017-08-23 17:19:02', '2017-08-23 17:18:33', NULL, '2017-08-23 17:19:02', 5, 1, 0),
(28, 'palmira1', 'ad891472d4e32680c6d7a4df9117fd43', 1, '2017-07-07 15:53:18', NULL, NULL, NULL, 6, 3, 0),
(29, 'L CORTES', '5d6dde7ecaf2d1c2f0fcef0dfde28adf', 1, '2017-07-07 15:52:27', NULL, NULL, NULL, 2, 2, 0),
(30, 'jhonny', '21232f297a57a5a743894a0e4a801fc3', 1, '2017-10-09 15:09:01', '2017-09-22 14:41:30', NULL, '2017-10-09 15:09:01', 6, 3, 0),
(31, ' pquintero', 'ad891472d4e32680c6d7a4df9117fd43', 0, '2017-07-07 15:43:05', NULL, NULL, NULL, 6, 3, 0),
(33, 'jpalaciostesorero', '55b48e190cdf511a9740cf059d8d8370', 1, '2017-07-07 15:52:03', NULL, NULL, '2017-06-27 00:16:05', 2, 1, 0),
(34, 'jpalaciosestudiante', '55b48e190cdf511a9740cf059d8d8370', 1, '2017-07-07 15:51:52', NULL, NULL, NULL, 3, 1, 0),
(35, 'jpalaciosprofesor', '55b48e190cdf511a9740cf059d8d8370', 1, '2017-07-07 15:51:56', NULL, NULL, NULL, 4, 1, 0),
(36, 'jpalaciosdirector', '55b48e190cdf511a9740cf059d8d8370', 1, '2017-07-07 15:51:47', NULL, NULL, NULL, 5, 1, 0),
(37, 'jpalaciosservicio', '55b48e190cdf511a9740cf059d8d8370', 1, '2017-07-07 15:51:59', NULL, NULL, NULL, 6, 1, 0),
(38, 'gvargas', '8a16e8903df108714b5267eff9878604', 1, '2017-11-14 14:15:32', '2017-09-16 15:41:16', NULL, '2017-11-14 14:15:32', 2, 1, 1),
(39, 'jpalacios', '55b48e190cdf511a9740cf059d8d8370', 1, '2017-11-09 22:46:44', NULL, NULL, '2017-11-09 22:46:44', 1, 1, 1),
(40, 'ecuellar', 'd34483e99d6232c6438b8c32d6db3be7', 1, '2017-11-14 13:50:13', NULL, NULL, '2017-11-14 13:50:13', 6, 1, 1),
(41, 'ramono', '9010e85e0d037f6ab9ea2249ddf5d3bb', 1, '2017-11-08 20:28:37', '2017-10-27 13:27:56', NULL, '2017-11-08 20:28:37', 5, 1, 1),
(42, 'David Alejandro Castillo', '3dde9fb6da49943ffb612b2bdd3b7472', 1, '2017-07-07 15:49:25', NULL, '2017-06-30 15:24:54', NULL, 6, 1, 0),
(43, 'dcastilloglobal', '7344ca46d374e28a58ad3b57ca6dddc3', 1, '2017-11-14 11:53:55', NULL, NULL, '2017-11-14 11:53:55', 6, 1, 1),
(44, 'mbuitronglobal', '3dde9fb6da49943ffb612b2bdd3b7472', 1, '2017-07-22 15:26:39', NULL, NULL, '2017-07-22 15:26:39', 6, 1, 0),
(45, 'dgarciaglobal', '3dde9fb6da49943ffb612b2bdd3b7472', 1, '2017-09-11 12:07:40', NULL, NULL, '2017-09-11 12:07:40', 6, 1, 0),
(46, 'hlopezglobal', '3dde9fb6da49943ffb612b2bdd3b7472', 1, '2017-11-04 12:30:26', NULL, NULL, '2017-11-04 12:30:26', 6, 1, 0),
(47, 'javierpalacios', 'e926bd5d844ef1aa130da3d42abf1078', 1, '2017-11-09 15:01:26', NULL, NULL, '2017-11-09 15:01:26', 1, 1, 1),
(48, 'inocampo', '9010e85e0d037f6ab9ea2249ddf5d3bb', 1, '2017-11-09 13:54:10', NULL, NULL, '2017-11-09 13:54:10', 1, 1, 1),
(49, 'dortiz', '3358d4b3d4a9b01d44d1aa2fcfa1c1c6', 1, '2017-11-14 13:16:48', NULL, NULL, '2017-11-14 13:16:48', 6, 3, 1),
(51, 'nsanchez', 'ee31adf0f3ff3d7789481564e429b571', 1, '2017-11-11 22:25:21', NULL, NULL, '2017-11-11 22:25:21', 5, 2, 1),
(52, 'eolivera', 'd60f20d0f71975a25321c396221f3582', 1, '2017-11-11 19:52:19', '2017-09-07 15:20:25', NULL, '2017-11-11 19:52:19', 3, 1, 1),
(53, 'cbermudez', 'fbc82e5797ccc262f36914d4a828103d', 1, '2017-11-14 13:54:38', '2017-08-15 19:38:05', NULL, '2017-11-14 13:54:38', 5, 1, 1),
(54, 'YHENAO', 'd9eb97b5d010484e5dd8e933fba75003', 1, '2017-11-14 14:13:37', '2017-09-19 12:48:19', NULL, '2017-11-14 14:13:37', 2, 1, 1),
(55, 'sldiez', 'b1a1f79ed1ec56adb9c628130041bd09', 1, '2017-11-11 12:49:32', NULL, NULL, '2017-11-11 12:49:32', 6, 2, 1),
(56, 'cpescobar', 'd3de0cc4b25661404156e24566ac1694', 1, '2017-11-14 14:16:00', NULL, NULL, '2017-11-14 14:16:00', 6, 2, 1),
(57, 'mceballos', '5abd42e3b18e1204ffebb27ac7aa796d', 1, '2017-11-10 14:04:43', '2017-10-04 15:00:22', NULL, '2017-11-10 14:04:43', 1, 1, 1),
(58, 'YPITO', '9a80e4a99e93b9ac009ca0c6dcfe6bb8', 1, '2017-11-14 13:05:39', NULL, NULL, '2017-11-14 13:05:39', 6, 1, 1),
(59, 'lvsolarte', '2b72fd416b3218faaaa4927252b2e8b8', 1, '2017-11-14 13:18:36', NULL, NULL, '2017-11-14 13:18:36', 6, 3, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuario_credencial`
--

DROP TABLE IF EXISTS `usuario_credencial`;
CREATE TABLE IF NOT EXISTS `usuario_credencial` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `usuario_id` int(10) UNSIGNED NOT NULL,
  `credencial_id` int(10) UNSIGNED NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `usuario_credencial_usuario_id_credencial_id_Idx` (`usuario_id`,`credencial_id`),
  KEY `usuario_credencial_credencial_id_Idx` (`credencial_id`) USING BTREE,
  KEY `usuario_credencial_usuario_id_Idx` (`usuario_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=57 DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `usuario_credencial`
--

INSERT INTO `usuario_credencial` (`id`, `usuario_id`, `credencial_id`, `created_at`, `deleted_at`) VALUES
(1, 1, 7, '2017-06-04 20:17:40', NULL),
(2, 2, 2, '2017-05-31 19:56:49', NULL),
(3, 3, 3, '2017-08-25 21:48:51', NULL),
(4, 4, 3, '2017-08-25 21:49:03', NULL),
(5, 5, 5, '2017-08-03 19:59:37', NULL),
(6, 6, 3, '2017-09-07 15:19:57', NULL),
(7, 7, 1, '2017-10-26 14:46:35', NULL),
(8, 8, 6, '2017-05-31 21:58:04', NULL),
(9, 9, 3, '2017-09-16 15:37:25', NULL),
(10, 10, 2, '2017-06-05 14:09:34', NULL),
(11, 11, 6, '2017-06-05 14:42:42', NULL),
(12, 12, 6, '2017-06-05 14:42:59', NULL),
(13, 13, 2, '2017-06-05 14:23:46', NULL),
(14, 14, 6, '2017-07-04 12:22:21', NULL),
(15, 15, 2, '2017-06-05 15:44:23', NULL),
(16, 16, 6, '2017-07-04 12:21:58', NULL),
(17, 17, 6, '2017-06-05 14:45:37', NULL),
(18, 18, 2, '2017-06-05 14:52:23', NULL),
(19, 19, 6, '2017-06-05 14:53:38', NULL),
(20, 20, 5, '2017-06-05 14:55:55', NULL),
(21, 21, 5, '2017-06-05 14:57:00', NULL),
(22, 22, 5, '2017-06-05 14:57:51', NULL),
(23, 23, 5, '2017-06-05 15:00:03', NULL),
(24, 24, 5, '2017-06-05 15:00:31', NULL),
(25, 25, 5, '2017-06-05 17:04:44', NULL),
(26, 26, 5, '2017-08-23 17:18:33', NULL),
(27, 28, 6, '2017-06-05 18:23:53', NULL),
(28, 29, 2, '2017-06-06 12:28:24', NULL),
(29, 30, 6, '2017-09-22 14:41:30', NULL),
(30, 31, 6, '2017-07-04 12:22:16', NULL),
(31, 33, 2, '2017-06-07 22:51:34', NULL),
(32, 34, 3, '2017-06-07 22:52:01', NULL),
(33, 35, 4, '2017-06-07 22:52:25', NULL),
(34, 36, 5, '2017-06-07 22:52:46', NULL),
(35, 37, 6, '2017-06-07 22:58:44', NULL),
(36, 38, 2, '2017-09-16 15:41:16', NULL),
(37, 39, 1, '2017-06-27 21:51:04', NULL),
(38, 40, 6, '2017-06-28 21:02:12', NULL),
(39, 41, 5, '2017-10-27 13:27:56', NULL),
(40, 42, 6, '2017-06-30 15:24:26', NULL),
(41, 43, 6, '2017-06-30 15:25:25', NULL),
(42, 44, 6, '2017-06-30 15:25:54', NULL),
(43, 45, 6, '2017-06-30 15:26:19', NULL),
(44, 46, 6, '2017-06-30 15:26:46', NULL),
(45, 47, 1, '2017-06-30 15:27:15', NULL),
(46, 48, 1, '2017-07-01 12:55:21', NULL),
(47, 49, 6, '2017-07-01 14:46:50', NULL),
(48, 51, 5, '2017-07-12 14:13:04', NULL),
(49, 52, 3, '2017-09-07 15:20:25', NULL),
(50, 53, 5, '2017-08-15 19:38:05', NULL),
(51, 54, 2, '2017-09-19 12:48:19', NULL),
(52, 55, 6, '2017-08-18 16:06:07', NULL),
(53, 56, 6, '2017-08-18 16:07:34', NULL),
(54, 57, 1, '2017-10-04 15:00:22', NULL),
(55, 58, 6, '2017-10-02 23:56:52', NULL),
(56, 59, 6, '2017-10-24 22:28:53', NULL);

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `aux_consecutivo`
--
ALTER TABLE `aux_consecutivo`
  ADD CONSTRAINT `fk_aux_consecutivo_estudiante` FOREIGN KEY (`estudiante_id`) REFERENCES `estudiante` (`id`),
  ADD CONSTRAINT `fk_aux_consecutivo_sede` FOREIGN KEY (`sede_id`) REFERENCES `sede` (`id`);

--
-- Filtros para la tabla `becas`
--
ALTER TABLE `becas`
  ADD CONSTRAINT `fk_becas_sede` FOREIGN KEY (`sede_id`) REFERENCES `sede` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `bitacora`
--
ALTER TABLE `bitacora`
  ADD CONSTRAINT `fk_bitacora_usuario` FOREIGN KEY (`usuario_id`) REFERENCES `usuario` (`id`);

--
-- Filtros para la tabla `ciudad`
--
ALTER TABLE `ciudad`
  ADD CONSTRAINT `fk_ciudad_departamento` FOREIGN KEY (`departamento_id`) REFERENCES `departamento` (`id`);

--
-- Filtros para la tabla `control_acceso_user`
--
ALTER TABLE `control_acceso_user`
  ADD CONSTRAINT `fk_control_acceso_user_control_acceso` FOREIGN KEY (`control_acceso_id`) REFERENCES `control_acceso` (`id`),
  ADD CONSTRAINT `fk_control_acceso_user_usuario` FOREIGN KEY (`usuario_id`) REFERENCES `usuario` (`id`);

--
-- Filtros para la tabla `cuadre`
--
ALTER TABLE `cuadre`
  ADD CONSTRAINT `fk_cuadre_sede` FOREIGN KEY (`sede_id`) REFERENCES `sede` (`id`),
  ADD CONSTRAINT `fk_cuadre_usuario_creador` FOREIGN KEY (`usuario_id_creador`) REFERENCES `usuario` (`id`),
  ADD CONSTRAINT `fk_cuadre_usuario_cuadre` FOREIGN KEY (`usuario_id_cuadre`) REFERENCES `usuario` (`id`);

--
-- Filtros para la tabla `detalle_egresos`
--
ALTER TABLE `detalle_egresos`
  ADD CONSTRAINT `fk_detalle_egresos_cuadre` FOREIGN KEY (`cuadre_id`) REFERENCES `cuadre` (`id`),
  ADD CONSTRAINT `fk_detalle_egresos_gastos_detalles` FOREIGN KEY (`gastos_detalles_id`) REFERENCES `gastos_detalles` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `detalle_factura`
--
ALTER TABLE `detalle_factura`
  ADD CONSTRAINT `fk_detalle_factura_concepto` FOREIGN KEY (`concepto_id`) REFERENCES `concepto` (`id`),
  ADD CONSTRAINT `fk_detalle_factura_factura` FOREIGN KEY (`factura_id`) REFERENCES `factura` (`id`),
  ADD CONSTRAINT `fk_detalle_factura_planes` FOREIGN KEY (`planes_id`) REFERENCES `planes` (`id`);

--
-- Filtros para la tabla `detalle_ingresos`
--
ALTER TABLE `detalle_ingresos`
  ADD CONSTRAINT `fk_detalle_ingresos_cuadre` FOREIGN KEY (`cuadre_id`) REFERENCES `cuadre` (`id`);

--
-- Filtros para la tabla `estudiante`
--
ALTER TABLE `estudiante`
  ADD CONSTRAINT `fk_estudiante_ciudad` FOREIGN KEY (`ciudad_id`) REFERENCES `ciudad` (`id`),
  ADD CONSTRAINT `fk_estudiante_estado_civil` FOREIGN KEY (`estado_civil_id`) REFERENCES `estado_civil` (`id`),
  ADD CONSTRAINT `fk_estudiante_estudiante_status` FOREIGN KEY (`estudiante_status_id`) REFERENCES `estudiante_status` (`id`),
  ADD CONSTRAINT `fk_estudiante_genero` FOREIGN KEY (`genero_id`) REFERENCES `genero` (`id`),
  ADD CONSTRAINT `fk_estudiante_identificacion` FOREIGN KEY (`identificacion_id`) REFERENCES `identificacion` (`id`),
  ADD CONSTRAINT `fk_estudiante_jornadas` FOREIGN KEY (`jornadas_id`) REFERENCES `jornadas` (`id`),
  ADD CONSTRAINT `fk_estudiante_nivel_academico` FOREIGN KEY (`nivel_academico_id`) REFERENCES `nivel_academico` (`id`),
  ADD CONSTRAINT `fk_estudiante_programas` FOREIGN KEY (`programas_id`) REFERENCES `programas` (`id`),
  ADD CONSTRAINT `fk_estudiante_sede` FOREIGN KEY (`sede_id`) REFERENCES `sede` (`id`);

--
-- Filtros para la tabla `estudiante_codigo`
--
ALTER TABLE `estudiante_codigo`
  ADD CONSTRAINT `fk_estudiante_codigo_estudiante` FOREIGN KEY (`estudiante_id`) REFERENCES `estudiante` (`id`);

--
-- Filtros para la tabla `estudiante_pivot_beca`
--
ALTER TABLE `estudiante_pivot_beca`
  ADD CONSTRAINT `fk_estudiantePivotBeca_becas` FOREIGN KEY (`becas_id`) REFERENCES `becas` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_estudiantePivotBeca_estudiante` FOREIGN KEY (`estudiante_id`) REFERENCES `estudiante` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `forma_pago_detalle`
--
ALTER TABLE `forma_pago_detalle`
  ADD CONSTRAINT `fk_forma_pago_detalle_forma_pago` FOREIGN KEY (`forma_pago_id`) REFERENCES `forma_pago` (`id`),
  ADD CONSTRAINT `fk_forma_pago_detalle_recibo_caja` FOREIGN KEY (`recibo_caja_id`) REFERENCES `recibo_caja` (`id`);

--
-- Filtros para la tabla `gastos`
--
ALTER TABLE `gastos`
  ADD CONSTRAINT `fk_gasto_sede` FOREIGN KEY (`sede_id`) REFERENCES `sede` (`id`),
  ADD CONSTRAINT `fk_gastos_proveedores` FOREIGN KEY (`proveedores_id`) REFERENCES `proveedores` (`id`),
  ADD CONSTRAINT `fk_gastos_usuario` FOREIGN KEY (`usuario_id`) REFERENCES `usuario` (`id`);

--
-- Filtros para la tabla `gastos_detalles`
--
ALTER TABLE `gastos_detalles`
  ADD CONSTRAINT `fk_detalles_gasto_gasto` FOREIGN KEY (`gasto_id`) REFERENCES `gastos` (`id`),
  ADD CONSTRAINT `fk_gastos_detalles_concepto` FOREIGN KEY (`concepto_id`) REFERENCES `concepto` (`id`);

--
-- Filtros para la tabla `menu_pivot_user`
--
ALTER TABLE `menu_pivot_user`
  ADD CONSTRAINT `fk_menu_pivot_user_menu` FOREIGN KEY (`menu_id`) REFERENCES `menu` (`id`),
  ADD CONSTRAINT `fk_menu_pivot_user_usuario` FOREIGN KEY (`usuario_id`) REFERENCES `usuario` (`id`);

--
-- Filtros para la tabla `preinscritos`
--
ALTER TABLE `preinscritos`
  ADD CONSTRAINT `fk_preinscritos_jornadas` FOREIGN KEY (`jornadas_id`) REFERENCES `jornadas` (`id`),
  ADD CONSTRAINT `fk_preinscritos_programas` FOREIGN KEY (`programas_id`) REFERENCES `programas` (`id`),
  ADD CONSTRAINT `fk_preinscritos_sede` FOREIGN KEY (`sede_id`) REFERENCES `sede` (`id`);

--
-- Filtros para la tabla `programas`
--
ALTER TABLE `programas`
  ADD CONSTRAINT `fk_programas_sede` FOREIGN KEY (`sede_id`) REFERENCES `sede` (`id`);

--
-- Filtros para la tabla `proveedores`
--
ALTER TABLE `proveedores`
  ADD CONSTRAINT `fk_proveedores_ciudad` FOREIGN KEY (`ciudad_id`) REFERENCES `ciudad` (`id`),
  ADD CONSTRAINT `fk_proveedores_identificacion` FOREIGN KEY (`identificacion_id`) REFERENCES `identificacion` (`id`),
  ADD CONSTRAINT `fk_proveedores_sede` FOREIGN KEY (`sede_id`) REFERENCES `sede` (`id`);

--
-- Filtros para la tabla `recibo_caja`
--
ALTER TABLE `recibo_caja`
  ADD CONSTRAINT `fk_recibo_caja_sede` FOREIGN KEY (`sede_id`) REFERENCES `sede` (`id`),
  ADD CONSTRAINT `fk_recibo_caja_usuario` FOREIGN KEY (`usuario_id`) REFERENCES `usuario` (`id`);

--
-- Filtros para la tabla `recibo_caja_detalle`
--
ALTER TABLE `recibo_caja_detalle`
  ADD CONSTRAINT `fk_recibo_caja_detalle_concepto` FOREIGN KEY (`concepto_id`) REFERENCES `concepto` (`id`),
  ADD CONSTRAINT `fk_recibo_caja_detalle_detalle_factura` FOREIGN KEY (`detalle_factura_id`) REFERENCES `detalle_factura` (`id`),
  ADD CONSTRAINT `fk_recibo_caja_detalle_programas` FOREIGN KEY (`programas_id`) REFERENCES `programas` (`id`),
  ADD CONSTRAINT `fk_recibo_caja_detalle_recibo_caja` FOREIGN KEY (`recibo_caja_id`) REFERENCES `recibo_caja` (`id`);

--
-- Filtros para la tabla `recibo_caja_pivot_estudiante`
--
ALTER TABLE `recibo_caja_pivot_estudiante`
  ADD CONSTRAINT `fk_recibo_caja_pivot_estudiante_estudiante` FOREIGN KEY (`estudiante_id`) REFERENCES `estudiante` (`id`),
  ADD CONSTRAINT `fk_recibo_caja_pivot_estudiante_recibo_caja` FOREIGN KEY (`recibo_caja_id`) REFERENCES `recibo_caja` (`id`);

--
-- Filtros para la tabla `recibo_caja_pivot_proveedores`
--
ALTER TABLE `recibo_caja_pivot_proveedores`
  ADD CONSTRAINT `fk_recibo_caja_pivot_proveedores_proveedores` FOREIGN KEY (`proveedores_id`) REFERENCES `proveedores` (`id`),
  ADD CONSTRAINT `fk_recibo_caja_pivot_proveedores_recibo_caja` FOREIGN KEY (`recibo_caja_id`) REFERENCES `recibo_caja` (`id`);

--
-- Filtros para la tabla `recordar_me`
--
ALTER TABLE `recordar_me`
  ADD CONSTRAINT `fk_recordar_me_usuario` FOREIGN KEY (`usuario_id`) REFERENCES `usuario` (`id`);

--
-- Filtros para la tabla `usuario`
--
ALTER TABLE `usuario`
  ADD CONSTRAINT `fk_usuario_credencial` FOREIGN KEY (`credencial_id`) REFERENCES `credencial` (`id`),
  ADD CONSTRAINT `fk_usuario_sede` FOREIGN KEY (`sede_id`) REFERENCES `sede` (`id`);

--
-- Filtros para la tabla `usuario_credencial`
--
ALTER TABLE `usuario_credencial`
  ADD CONSTRAINT `fk_usuarios_credenciales_credenciales` FOREIGN KEY (`credencial_id`) REFERENCES `credencial` (`id`),
  ADD CONSTRAINT `fk_usuarios_credenciales_usuarios` FOREIGN KEY (`usuario_id`) REFERENCES `usuario` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
