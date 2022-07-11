
IF EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_anular_preventa' AND type = 'P')
DROP PROCEDURE pa_anular_preventa
GO
----------------------------------------------------------------------------------
-- Author: Alex Llamo IDE-SOLUTION
-- Created: 02/03/2020
-- Sistema: ws_wa_DistribuidoraVDC
-- Descripcion: Anular preventa
-- Log Modificaciones:
-- CODIGO NOMBRE FECHA MOTIVO
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_anular_preventa
(
	@p_ntraPreventa INT			--ntra preventa
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @flag INT;						--flag de proceso
	DECLARE @msje VARCHAR(250);				--mensaje de error
	DECLARE @codProducto VARCHAR(20);		--codigo producto
	DECLARE @codAlmacen INT;				--codigo almacen
	DECLARE @cantidadUnidadBase INT;		--cantidad unidad base

	SET @flag = 0;
	SET @msje = 'Exito';
	SET @cantidadUnidadBase = 0;
	SET @codAlmacen = 0;
	SET @codProducto = '';

	BEGIN TRY
		BEGIN TRANSACTION
			SET @cantidadUnidadBase = 0;
			SET @codAlmacen = 0;
			SET @codProducto = 0;
			--REVERSION DE STOCKS
			DECLARE cur_stock CURSOR LOCAL STATIC READ_ONLY FORWARD_ONLY FOR 
			SELECT cantidadUnidadBase, codAlmacen, codProducto
			FROM tblDetallePreventa WHERE codPreventa = @p_ntraPreventa
			OPEN cur_stock;  
			FETCH NEXT FROM cur_stock INTO @cantidadUnidadBase, @codAlmacen, @codProducto
			WHILE @@FETCH_STATUS = 0
				BEGIN
					UPDATE tblInventario SET stock = stock + @cantidadUnidadBase 
					WHERE codAlmacen = @codAlmacen AND codProducto = @codProducto AND marcaBaja = 0;
						
					FETCH NEXT FROM cur_stock INTO @cantidadUnidadBase, @codAlmacen, @codProducto;
				END
			CLOSE cur_stock;
			DEALLOCATE cur_stock;

			--ANULAR PREVENTA
			UPDATE tblPreventa SET estado = 2
			WHERE ntraPreventa = @p_ntraPreventa;

		COMMIT TRANSACTION

		SELECT @flag as flag , @msje as msje
	END TRY
	BEGIN CATCH
		IF (XACT_STATE()) <> 0 
		BEGIN
			ROLLBACK TRANSACTION
		END
		SET @flag = ERROR_NUMBER();
		SET @msje = 'Error en pa_anular_preventa ' + ERROR_MESSAGE();
		SELECT @flag as flag , @msje as msje
	END CATCH
END
