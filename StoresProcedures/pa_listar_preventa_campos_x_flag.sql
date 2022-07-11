IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_listar_preventa_campos_x_flag' AND type = 'P')
	DROP PROCEDURE pa_listar_preventa_campos_x_flag
GO
----------------------------------------------------------------------------------
-- Author: Diego Sanchez IDE-SOLUTION
-- Created: 10/03/2020  
-- Sistema: Sistema Distribuidora Virgen del Carmen.
-- Descripción: lista de campos para los filtros de las preventas
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[pa_listar_preventa_campos_x_flag]
@flag int
AS
BEGIN
	IF @flag = 1 --obtener lista de vendedores
	SELECT usr.ntraUsuario as codigo, CONCAT(per.nombres,' ', per.apellidoPaterno,' ',per.apellidoMaterno) as descripcion FROM tblUsuario usr
    INNER JOIN tblPersona per on usr.codPersona = per.codPersona
	WHERE usr.codPerfil = 1 and usr.marcaBaja = 0;

	IF @flag = 2 --obtener lista de cliente
		select cli.codPersona as codigo, 
		CASE
		WHEN per.tipoPersona = 1 THEN CONCAT(per.nombres,' ', per.apellidoPaterno,' ',per.apellidoMaterno)
		WHEN per.tipoPersona = 2 THEN per.razonSocial
		END as descripcion
		from tblCliente cli	inner join tblPersona per on per.codPersona = cli.codPersona where cli.marcaBaja = 0 and per.marcaBaja=0;

	IF @flag = 3 --obtener lista de rutas
		SELECT ntraRutas as codigo, concat(pseudonimo,'  -  ',descripcion) as descripcion FROM tblRutas
		WHERE marcaBaja = 0;

	IF @flag = 4 --obtener lista de productos
		select codProducto as codigo, CONCAT(codProducto, '  ' ,descripcion) as descripcion from tblProducto
		WHERE marcaBaja = 0;

	IF @flag = 5 --obtener lista de proveedores
		select ntraProveedor as codigo, CONCAT(abreviatura, '   ', descripcion) as descripcion from tblProveedor
		where marcaBaja = 0;
	
	IF @flag = 6 --PROODUCTOS SOLO PARA VENTA
		select codProducto as codigo, descripcion from tblProducto where tipoProducto = 1 and flagVenta = 1 and marcaBaja=0

	IF @flag = 7 --obtener lista de productos + no venta
		select codProducto as codigo, descripcion from tblProducto
		WHERE marcaBaja = 0;

	IF @flag = 8 --obtener lista ciudades de los clientes (importadora)
		BEGIN
		SELECT DISTINCT p.codUbigeo  AS codigo, d.nombre AS descripcion FROM tblCliente c
		inner join tblPersona p ON p.codPersona = c.codPersona
		inner join tblDistrito d ON d.ubigeo = p.codUbigeo;
		END

	IF @flag = 9 --estados de stock minimo
		select correlativo as codigo, descripcion from tblConcepto where codConcepto = 34 and correlativo > 0 and marcaBaja = 0;

END