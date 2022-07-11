
IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_listar_preventa_promociones' AND type = 'P')
	DROP PROCEDURE pa_listar_preventa_promociones
GO
----------------------------------------------------------------------------------
-- Author: Wilmer Sanchez IDE-SOLUTION
-- Created: 16/01/2020  
-- Sistema: ws_wa_DistribuidoraVDC
-- Descripción: Traer lista promociones de preventa
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_listar_preventa_promociones
(
	@p_codPrev INT -- codigo de preventa
)		
AS
	BEGIN
		DECLARE @g_const_0 SMALLINT -- valor 0
		DECLARE @g_const_vacio CHAR(1) -- Constante vacio
		DECLARE @g_const_2000 SMALLINT -- Constante 2000
		DECLARE @g_const_msj VARCHAR(200) -- Mensaje
		BEGIN TRY		
			
			SET @g_const_vacio = '';
			SET @g_const_0 = 0;
			SET @g_const_2000 = 2000
			SET @g_const_msj = 'Consulta exitosa'

			SET NOCOUNT ON;

			SELECT codPreventa,codPromocion,itemPreventa,itemPromocionado 
					, @g_const_2000 AS codigo
					, @g_const_msj as mensaje
			FROM tblPreventaPromocion 
			WHERE codPreventa = @p_codPrev AND marcaBaja = @g_const_0

		END TRY
		BEGIN CATCH
			SELECT
					@g_const_0 AS codPreventa, 
					@g_const_0 AS codPromocion,  
					@g_const_0 AS itemPreventa, 
					@g_const_0 AS itemPromocionado, 
					ERROR_NUMBER() AS codigo,
					ERROR_MESSAGE() AS mensaje
					


		END CATCH

	END	
GO

--exec pa_listar_preventa_promociones 1

