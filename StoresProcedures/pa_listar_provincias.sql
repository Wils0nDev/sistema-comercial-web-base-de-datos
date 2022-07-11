
IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_listar_provincias' AND type = 'P')
	DROP PROCEDURE pa_listar_provincias
GO
----------------------------------------------------------------------------------
-- Author: Wilmer Sanchez IDE-SOLUTION
-- Created: 26/02/2020  
-- Sistema: ws_wa_DistribuidoraVDC
-- Descripción: Listar provincias
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_listar_provincias		
(
	@p_codDep CHAR(2),
	@p_codProv CHAR(2)  -- Codigo de provincia, Si es 00 entonces traerá todos las provincias
)
AS
	BEGIN
		DECLARE @g_const_0 SMALLINT -- valor 0
		DECLARE @g_const_todos CHAR(2) -- Constante para traer todos
		
		SET @g_const_0 = 0
		SET @g_const_todos = '00'
		
		SET NOCOUNT ON;  
		
		IF @p_codProv = @g_const_todos
			BEGIN
				SELECT codDepartamento,codProvincia,nombre FROM tblProvincia WHERE codDepartamento = @p_codDep AND marcaBaja = @g_const_0				
			END
		ELSE
			BEGIN
				SELECT codDepartamento,codProvincia,nombre FROM tblProvincia WHERE codDepartamento = @p_codDep AND codProvincia = @p_codProv AND marcaBaja = @g_const_0
			END
		
		

	END	
GO

--exec pa_listar_provincias '14','00'

 