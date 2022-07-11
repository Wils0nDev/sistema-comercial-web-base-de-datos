
IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_listar_distritos' AND type = 'P')
	DROP PROCEDURE pa_listar_distritos
GO
----------------------------------------------------------------------------------
-- Author: Wilmer Sanchez IDE-SOLUTION
-- Created: 26/02/2020  
-- Sistema: ws_wa_DistribuidoraVDC
-- Descripción: Listar distritos
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_listar_distritos		
(
	@p_codDep CHAR(2),
	@p_codProv CHAR(2), -- Codigo de distrito, Si es 00 entonces traerá todos los distritos por departamento
	@p_codDis CHAR(2)  -- Codigo de distrito, Si es 00 entonces traerá todos los distritos
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
				SELECT codDepartamento,codProvincia,codDistrito,nombre,ubigeo FROM tblDistrito WHERE codDepartamento = @p_codDep AND marcaBaja = @g_const_0
			
			END
		ELSE
			BEGIN
				IF @p_codDis = @g_const_todos
					BEGIN
						SELECT codDepartamento,codProvincia,codDistrito,nombre,ubigeo FROM tblDistrito WHERE codDepartamento = @p_codDep AND codProvincia = @p_codProv AND marcaBaja = @g_const_0
					END
				ELSE
					BEGIN
						SELECT codDepartamento,codProvincia,codDistrito,nombre,ubigeo FROM tblDistrito WHERE codDepartamento = @p_codDep AND codProvincia = @p_codProv AND codDistrito = @p_codDis AND marcaBaja = @g_const_0
		
					END
			END
		
		
		

	END	
GO

--exec pa_listar_distritos '14','01','00'

 