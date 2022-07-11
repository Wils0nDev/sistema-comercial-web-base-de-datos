
IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_listar_descuentos_fecha' AND type = 'P')
	DROP PROCEDURE pa_listar_descuentos_fecha
GO
----------------------------------------------------------------------------------
-- Author: Wilmer Sanchez IDE-SOLUTION
-- Created: 13/01/2020  
-- Sistema: ws_wa_DistribuidoraVDC
-- Descripción: Traer lista de descuentos por fecha 
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_listar_descuentos_fecha
(
	@p_fech DATE, -- fecha
	@p_estado SMALLINT, -- estado
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

			IF @p_estado = @g_const_0 
				BEGIN
					SELECT pr.ntraDescuento,dp.flag,CONCAT(pr.ntraDescuento,dp.flag) AS ntra_flag,pr.descripcion as desc_desc, pr.horaInicial,pr.horaFin,
					 dp.descripcion as desc_det,dp.valorInicial,dp.valorFinal,dp.detalle,dp.estado,pr.tipoDescuento 
					, @g_const_2000 AS codigo
					,@g_const_msj as mensaje
					FROM tblDescuentos pr 
					INNER JOIN tblDetalleDescuentos dp ON pr.ntraDescuento = dp.ntraDescuento
					WHERE pr.fechaInicial <=  @p_fech AND  pr.fechaFin  >= @p_fech AND pr.marcaBaja = @g_const_0;
				END
			ELSE
				BEGIN
					IF @p_flag = @g_const_0
						BEGIN
							SELECT pr.ntraDescuento,dp.flag,CONCAT(pr.ntraDescuento,dp.flag) AS ntra_flag,pr.descripcion as desc_desc, pr.horaInicial,pr.horaFin,
							 dp.descripcion as desc_det,dp.valorInicial,dp.valorFinal,dp.detalle,dp.estado,pr.tipoDescuento 
							, @g_const_2000 AS codigo
							,@g_const_msj as mensaje
							FROM tblDescuentos pr 
							INNER JOIN tblDetalleDescuentos dp ON pr.ntraDescuento = dp.ntraDescuento
							WHERE pr.fechaInicial <=  @p_fech AND  pr.fechaFin >= @p_fech AND pr.estado = @p_estado AND pr.marcaBaja = @g_const_0;
						END
					ELSE
						BEGIN
							SELECT pr.ntraDescuento,dp.flag,CONCAT(pr.ntraDescuento,dp.flag) AS ntra_flag,pr.descripcion as desc_desc, pr.horaInicial,pr.horaFin,
							 dp.descripcion as desc_det,dp.valorInicial,dp.valorFinal,dp.detalle,dp.estado,pr.tipoDescuento 
							, @g_const_2000 AS codigo
							,@g_const_msj as mensaje
							FROM tblDescuentos pr 
							INNER JOIN tblDetalleDescuentos dp ON pr.ntraDescuento = dp.ntraDescuento
							WHERE pr.fechaInicial <=  @p_fech AND  pr.fechaFin >= @p_fech AND pr.estado = @p_estado AND dp.flag = @p_flag AND pr.marcaBaja = @g_const_0;
						END
					
				END

			
		END TRY
		BEGIN CATCH
			SELECT
					@g_const_0 AS ntraDescuento, 
					@g_const_0 AS flag, 
					@g_const_vacio AS ntra_flag,
					@g_const_vacio AS desc_desc, 
					@g_const_vacio AS horaInicial, 
					@g_const_vacio AS horaFin, 
					@g_const_vacio AS desc_det, 
					@g_const_vacio AS valorInicial, 
					@g_const_vacio AS valorFinal,
					@g_const_0 AS detalle, 
					@g_const_0 AS estado, 
					@g_const_0 AS tipoDescuento, 
					ERROR_NUMBER() AS codigo,
					ERROR_MESSAGE() AS mensaje
		END CATCH

	END	
GO

--exec pa_listar_descuentos_fecha '13/01/2020',0,0



 