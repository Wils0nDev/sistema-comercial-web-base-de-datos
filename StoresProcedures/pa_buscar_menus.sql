IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_buscar_menus' AND type = 'P')
	DROP PROCEDURE pa_buscar_menus
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
----------------------------------------------------------------------------------
-- Author: Jeffrey Garcia IDE-SOLUTION
-- Created: 24/04/2020
-- Sistema: VirgenDelCarmenMantenedor
-- Descripcion: listado de menus
-- Log Modificaciones:
-- CODIGO NOMBRE FECHA MOTIVO
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[pa_buscar_menus]
AS
BEGIN 
	SET NOCOUNT ON;  
	BEGIN TRY
        BEGIN   
            	SELECT modu.codModulo as 'codModulo' ,modu.descripcion as 'nomModulo',
                men.codMenu as 'codMenu',men.descripcion as 'nomMantenedor'
                FROM tblModulo as modu 
                INNER JOIN tblMenu as men on modu.codModulo = men.codModulo
                WHERE men.marcaBaja = 0 and modu.marcaBaja = 0
                and men.estado = 1 AND modu.estado = 1				
                ORDER BY modu.orden,men.orden
        END
    END TRY
    BEGIN CATCH
        SELECT ERROR_NUMBER() as 'codError' , 'Error en pa_buscar_menus' + ERROR_MESSAGE() as 'mensaje'
    END CATCH
END
