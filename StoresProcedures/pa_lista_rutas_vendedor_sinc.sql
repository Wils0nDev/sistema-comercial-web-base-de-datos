
IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_lista_rutas_vendedor_sinc' AND type = 'P')
	DROP PROCEDURE pa_lista_rutas_vendedor_sinc
GO
----------------------------------------------------------------------------------
-- Author: Wilmer Sanchez IDE-SOLUTION
-- Created: 16/01/2020  
-- Sistema: ws_wa_DistribuidoraVDC
-- Descripción: Traer lista de rutas de vendedor
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_lista_rutas_vendedor_sinc
(
	@codUsuario INT -- numero de transaccion de usuario
)		
AS
	BEGIN
		DECLARE @g_const_0 SMALLINT -- valor 0
		BEGIN TRY		
			
			SET @g_const_0 = 0;

			SET NOCOUNT ON;
			
			SELECT * FROM v_listar_rutas_asignadas_x_vendedor
			WHERE ntraUsuario =  @codUsuario AND estado = @g_const_0
			ORDER BY ORDEN ASC

		END TRY
		BEGIN CATCH
			SELECT
					ERROR_NUMBER() AS estado,
					ERROR_MESSAGE() AS RUTA

		END CATCH

	END	
GO

--exec pa_lista_rutas_vendedor_sinc 1

