IF EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_registrar_producto' AND type = 'P')
DROP PROCEDURE pa_registrar_producto
GO
----------------------------------------------------------------------------------
-- Author: Dany Gelacio -IDE SOLUTION
-- Created: 19/03/2020
-- Sistema: web virgen del Carmen
-- Descripcion: Registrar producto
-- Log Modificaciones:
-- CODIGO NOMBRE FECHA MOTIVO
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE pa_registrar_producto
(
	@p_descripcion VARCHAR(200), -- descripcion
	@p_codUndBaseVenta int,		 -- unidad base de venta
	@p_codCategoria int,		 -- codigo de categoria
	@p_codSubCat int,			 -- codigo de subcategoria
	@p_tipoProduc int,			 -- tipo de producto
	@p_flagVent smallint,		 -- flag de venta
	@p_codFabricante int,		 -- codigo de fabricante
	@p_proveedor int,			 --codigo de proveedor
	@resultado VARCHAR(10) OUTPUT,
	@codregistro VARCHAR(10)  OUTPUT
)
AS
BEGIN
	SET NOCOUNT ON;
		DECLARE @codProduc VARCHAR(10);				-- Codigo producto
		DECLARE @nombFabricante VARCHAR(20);		--nombre del fabricante
		DECLARE @numCategoria VARCHAR(20);			--número de categoria	
		
		DECLARE @User varchar(4);				    -- codigo usuario
		DECLARE @ip varchar(20);			        --ip
		DECLARE @mac Varchar(20);			        -- mac
	BEGIN TRY
		SET @User=1;
		SET @ip= '192.168.1.1';
		set @mac='A-AA-AAA-AAAA';
		
			BEGIN TRANSACTION
				select  @nombFabricante = descripcion From tblFabricante WHERE ntraFabricante = @p_codFabricante and marcaBaja=0;

				SET @nombFabricante=LEFT(@nombFabricante,2);
				SET @numCategoria = RIGHT('00' + Ltrim(Rtrim(@p_codCategoria)),2);
				SET @codProduc = @nombFabricante+@numCategoria +RIGHT('00' + CAST(NEXT VALUE FOR Cod_Prod_Seq AS varchar), 3)

				INSERT INTO tblProducto(codProducto,descripcion,codUnidadBaseventa,
				codCategoria, codSubcategoria,tipoProducto,flagVenta,codFabricante,
				usuario,ip, mac) values
				(@codProduc,@p_descripcion,@p_codUndBaseVenta,@p_codCategoria,@p_codSubCat,
				@p_tipoProduc,@p_flagVent,@p_codFabricante,@User,
				@ip,@mac);

				INSERT INTO tblAbastecimento(codProducto, codProveedor,usuario,ip,mac) values(@codProduc, @p_proveedor,@User,
					@ip,@mac);
					
			SELECT @resultado = '0';
			SELECT @codregistro = @codProduc;
			COMMIT TRANSACTION
		
	END TRY
	BEGIN CATCH
		SELECT @resultado = '1'
		SELECT @codregistro = '-1';
		IF (XACT_STATE()) <> 0 
		BEGIN
			ROLLBACK TRANSACTION
		END
		SELECT ERROR_NUMBER() as error, ERROR_MESSAGE() as MEN
	END CATCH
END
