
IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_listar_departamentos' AND type = 'P')
	DROP PROCEDURE pa_listar_departamentos
GO
----------------------------------------------------------------------------------
-- Author: Wilmer Sanchez IDE-SOLUTION
-- Created: 26/02/2020  
-- Sistema: ws_wa_DistribuidoraVDC
-- Descripción: Listar departamentos
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_listar_departamentos		
(
	@p_codDep CHAR(2) -- Codigo de departamento, Si es 00 entonces traerá todos los departamentos
)
AS
	BEGIN
		DECLARE @g_const_0 SMALLINT -- valor 0
		DECLARE @g_const_todos CHAR(2) -- Constante para traer todos
		
		SET @g_const_0 = 0
		SET @g_const_todos = '00'
		
		SET NOCOUNT ON;  
		
		IF @p_codDep = @g_const_todos
			BEGIN
				SELECT codDepartamento,nombre FROM tblDepartamento WHERE marcaBaja = @g_const_0				
			END
		ELSE
			BEGIN
				SELECT codDepartamento,nombre FROM tblDepartamento WHERE codDepartamento = @p_codDep AND marcaBaja = @g_const_0
			END
		
		

	END	
GO

--exec pa_listar_departamentos '00'

 