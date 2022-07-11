
IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_buscar_mantenedores_nombre' AND type = 'P')
	DROP PROCEDURE pa_buscar_mantenedores_nombre
GO
/****** Object:  StoredProcedure [dbo].[pa_buscar_mantenedores_nombre]    Script Date: 27/04/2020 10:56:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
----------------------------------------------------------------------------------
-- Author: Jeffrey Garcia
-- Created: 25/04/2020  
-- Sistema: ws_wa_DistribuidoraVDC
-- Modulo: Permisos
-- Descripci�n: Buscar mantenedores por nombre
-- Log Modificaciones: 
-- CODIGO    REQUERIMIENTO          NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[pa_buscar_mantenedores_nombre]
(
	@p_mant  varchar(150) -- nombre del mantenedor
)		
AS
	BEGIN
		
		SELECT modu.codModulo as 'codModulo' ,modu.descripcion as 'nomModulo',
                men.codMenu as 'codMenu',men.descripcion as 'nomMantenedor'
                FROM tblModulo as modu 
                INNER JOIN tblMenu as men on modu.codModulo = men.codModulo
                WHERE men.marcaBaja = 0 and modu.marcaBaja = 0
                and men.estado = 1 AND modu.estado = 1 and 	men.descripcion LIKE '%'+ @p_mant +'%'			
                ORDER BY modu.orden,men.orden

	END	
