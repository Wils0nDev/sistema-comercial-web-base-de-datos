
IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_listar_detalle_flag_promocion' AND type = 'P')
	DROP PROCEDURE pa_listar_detalle_flag_promocion
GO
----------------------------------------------------------------------------------
-- Author: Wilmer Sanchez IDE-SOLUTION
-- Created: 13/01/2020  
-- Sistema: ws_wa_DistribuidoraVDC
-- Descripción: Traer lista detalle de promociones 
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_listar_detalle_flag_promocion
(
	@p_ntra INT, -- numero de transaccion
	@p_flag INT -- flag
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

			SELECT CONCAT(df.ntraPromocion,df.flag) AS ntra_flag,df.flag,df.descripcion,df.valorEntero1,df.valorEntero2,df.valorMoneda1,
			df.valorMoneda2,df.valorCadena1,df.valorCadena2,df.valorFecha1,df.valorFecha2,df.estado 
			, @g_const_2000 AS codigo
			, @g_const_msj as mensaje
			FROM tblDetallePromociones dp
			INNER JOIN tblDetalleFlagPromocion df ON (dp.ntraPromocion = df.ntraPromocion AND dp.flag = df.flag )
			WHERE dp.ntraPromocion = @p_ntra AND dp.flag = @p_flag AND dp.marcaBaja = @g_const_0 AND df.marcaBaja = @g_const_0 


			
		END TRY
		BEGIN CATCH
			SELECT
					@g_const_vacio AS ntra_flag, 
					@g_const_0 AS flag, 
					@g_const_vacio AS descripcion, 
					@g_const_0 AS valorEntero1, 
					@g_const_0 AS valorEntero2, 
					@g_const_0 AS valorMoneda1, 
					@g_const_0 AS valorMoneda2, 
					@g_const_vacio AS valorCadena1, 
					@g_const_vacio AS valorCadena2,
					GETDATE()  AS valorFecha1,
					GETDATE()  AS valorFecha2,
					@g_const_0 AS estado, 
					ERROR_NUMBER() AS codigo,
					ERROR_MESSAGE() AS mensaje
					


		END CATCH

	END	
GO

--exec pa_listar_detalle_flag_promocion 1,1

