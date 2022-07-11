
IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_listar_promociones_fecha' AND type = 'P')
	DROP PROCEDURE pa_listar_promociones_fecha
GO
----------------------------------------------------------------------------------
-- Author: Wilmer Sanchez IDE-SOLUTION
-- Created: 13/01/2020  
-- Sistema: ws_wa_DistribuidoraVDC
-- Descripción: Traer lista de promociones por fecha 
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_listar_promociones_fecha
(
	@p_fech DATE, -- fecha
	@p_estado SMALLINT, -- estado (0- sin filtro de estado,  >0- mas filtros por estado (1:activo, 2: inactivo))
	@p_flag INT -- filtro de flag (0 - sin estado , >0 - con filtro de flag)
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

			IF @p_estado = @g_const_0 
				BEGIN
					SELECT pr.ntraPromocion,dp.flag,CONCAT(pr.ntraPromocion,dp.flag) AS ntra_flag,pr.descripcion as desc_promo, pr.horaInicial,pr.horaFin,
					dp.descripcion as desc_det,dp.valorInicial,dp.valorFinal,dp.detalle,dp.estado 
					, @g_const_2000 AS codigo
					,@g_const_msj as mensaje
					FROM tblPromociones pr 
					INNER JOIN tblDetallePromociones dp ON pr.ntraPromocion = dp.ntraPromocion
					WHERE pr.fechaInicial <=  @p_fech AND  pr.fechaFin >= @p_fech AND pr.marcaBaja = @g_const_0
				END
			ELSE
				BEGIN
					IF @p_flag = @g_const_0
						BEGIN
							SELECT pr.ntraPromocion,dp.flag,CONCAT(pr.ntraPromocion,dp.flag) AS ntra_flag,pr.descripcion as desc_promo,pr.horaInicial,pr.horaFin,
							dp.descripcion as desc_det,dp.valorInicial,dp.valorFinal,dp.detalle,dp.estado 
							, @g_const_2000 AS codigo
							,@g_const_msj as mensaje
							FROM tblPromociones pr 
							INNER JOIN tblDetallePromociones dp ON pr.ntraPromocion = dp.ntraPromocion
							WHERE pr.fechaInicial <=  @p_fech AND  pr.fechaFin >= @p_fech AND pr.estado = @p_estado AND pr.marcaBaja = @g_const_0;
						END
					ELSE
						BEGIN
							SELECT pr.ntraPromocion,dp.flag,CONCAT(pr.ntraPromocion,dp.flag) AS ntra_flag,pr.descripcion as desc_promo,pr.horaInicial,pr.horaFin,
							dp.descripcion as desc_det,dp.valorInicial,dp.valorFinal,dp.detalle,dp.estado 
							, @g_const_2000 AS codigo
							,@g_const_msj as mensaje
							FROM tblPromociones pr 
							INNER JOIN tblDetallePromociones dp ON pr.ntraPromocion = dp.ntraPromocion
							WHERE pr.fechaInicial <=  @p_fech AND  pr.fechaFin >= @p_fech AND pr.estado = @p_estado AND dp.flag = @p_flag AND pr.marcaBaja = @g_const_0;
						END
					
				END

			
		END TRY
		BEGIN CATCH
			SELECT
					@g_const_0 AS ntraPromocion, 
					@g_const_0 AS flag, 
					@g_const_vacio AS ntra_flag,
					@g_const_vacio AS desc_promo, 
					@g_const_vacio AS horaInicial, 
					@g_const_vacio AS horaFin, 
					@g_const_vacio AS desc_det, 
					@g_const_vacio AS valorInicial, 
					@g_const_vacio AS valorFinal,
					@g_const_0 AS detalle, 
					@g_const_0 AS estado, 
					ERROR_NUMBER() AS codigo,
					ERROR_MESSAGE() AS mensaje
					


		END CATCH

	END	
GO

--exec pa_listar_promociones_fecha '13/01/2020',0,0



 