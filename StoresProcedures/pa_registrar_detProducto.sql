IF EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_registrar_detProducto' AND type = 'P')
DROP PROCEDURE pa_registrar_detProducto
GO
----------------------------------------------------------------------------------
-- Author: Dany Gelacio -IDE SOLUTION
-- Created: 23/03/2020
-- Sistema: web virgen del Carmen
-- Descripcion: Detalle presentación de producto
-- Log Modificaciones:
-- CODIGO NOMBRE FECHA MOTIVO
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE pa_registrar_detProducto(
	@p_codProduc varchar(10), 	  -- Codigo de producto
	@p_codPresentacion int,		  -- codigo de detalle presentacion
	@p_cantDetall int,			  -- cantidad de cada unidad de presentacion
	@resultado INT OUTPUT
)								  
AS			
BEGIN
	SET NOCOUNT ON;
	DECLARE @User varchar(4);			  -- usuario
	DECLARE @ip varchar(20);			  -- ip
	DECLARE @mac varchar(20);			  -- mac

	BEGIN TRY
		SET @User=1;
		SET @ip= '192.168.1.1';
		set @mac='A-AA-AAA-AAAA';
		
		BEGIN TRANSACTION

				 INSERT INTO tblDetallePresentacion(codProducto, codPresentancion, cantidadUnidadBase, usuario,ip,mac)
					values(@p_codProduc,@p_codPresentacion,@p_cantDetall,@User,@ip,@mac)				

			SELECT  @resultado = 0
		COMMIT TRANSACTION

		
	END TRY
	BEGIN CATCH
	
		SELECT @resultado = 1
		IF (XACT_STATE()) <> 0 
		BEGIN
			ROLLBACK TRANSACTION
		END
		SELECT ERROR_NUMBER() as error, ERROR_MESSAGE() as MEN
	END CATCH
END
