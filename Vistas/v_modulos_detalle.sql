IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'v_modulos_detalle' AND type = 'V')
	DROP VIEW v_modulos_detalle
GO

----------------------------------------------------------------------------------
-- Author: Jeffrey Garcia
-- Created: 22/04/2020  
-- Sistema: WEB / BARRA DE NAVEGACION
-- Descripción: Vista listar modulos y detalle de modulos
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW v_modulos_detalle
AS
	SELECT modu.codModulo as 'codModulo' ,modu.descripcion as 'nomModulo',modu.orden as 'ordenModu',
		men.codMenu as 'codMenu',men.ruta as 'rutaMantenedor',men.descripcion as 'nomMantenedor', 
		men.orden as 'ordenMen',op.codResponsable as 'responsable',op.codPermiOpera as codPermiso,men.codModulo as codModuloM
		FROM tblModulo as modu 
		INNER JOIN tblMenu as men on modu.codModulo = men.codModulo
		INNER JOIN tblPermiOpera as op on op.codMenu = men.codMenu
		WHERE
		op.marcaBaja = 0 and men.marcaBaja = 0 and modu.marcaBaja = 0
		and men.estado = 1 AND modu.estado = 1; 

	GO