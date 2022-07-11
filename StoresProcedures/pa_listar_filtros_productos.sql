
IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_listar_filtros_productos' AND type = 'P')
	DROP PROCEDURE pa_listar_filtros_productos
GO
----------------------------------------------------------------------------------
-- Author: Jose Chumioque IDE-SOLUTION
-- Created: 06/01/2020  
-- Sistema: Sistema de Preventas
-- Modulo: General
-- Descripción: Consultar articulos por filtros
-- Log Modificaciones: 
-- CODIGO    REQUERIMIENTO          NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_listar_filtros_productos	
(
 @codCategoria INT, 
 @codSubcategoria INT,
 @codProveedor INT,
 @codFabricante INT,
 @descripcion VARCHAR(200)
 )
AS
SET NOCOUNT ON

BEGIN
        DECLARE @g_const_0 INT -- valor 0
		DECLARE @g_const_1 SMALLINT -- valor 1
		DECLARE @g_const_9 SMALLINT -- valor 9
		DECLARE @g_const_12 SMALLINT -- valor 9
		DECLARE @g_const_3000 SMALLINT -- valor 3000
		DECLARE @g_const_2000 SMALLINT -- valor 2000
		DECLARE @g_caracter CHAR(1)
		DECLARE @codigo INT -- Codigo 
		DECLARE @mensaje VARCHAR(100) -- mensaje
		DECLARE @estado SMALLINT -- 0:EXITO, 1:error interno
        DECLARE @g_descCategoria    VARCHAR(200)
		DECLARE @g_descSubcategoria VARCHAR(200)
		DECLARE @g_descProveedor    VARCHAR(200)
		DECLARE @g_descFabricante   VARCHAR(200)
		DECLARE @g_descUnidadBase   VARCHAR(50)
		DECLARE @g_undbase         INT   --Codigo de Unidad Base
		DECLARE @g_stock SMALLINT --Stock de articulo de almacen principal
		DECLARE @g_codproducto     VARCHAR(10) --Codigo de producto
		DECLARE @g_codcategoria    INT --Codigo de categoria
		DECLARE @g_codsubcategoria INT --Codigo de sub categoria
		DECLARE @g_codProveedor    INT --Codigo de Proveedor
		DECLARE @g_codFabricante   INT --Codigo de Fabricante
		DECLARE @g_descripcion    VARCHAR(200) --Descripcion de producto
		DECLARE @g_fechavencimiento DATE --Fecha de vencimiento
		CREATE TABLE #listArticulo 
		(codProducto VARCHAR(10),codCategoria INT,descCategoria VARCHAR(200),codSubcategoria INT,descSubcategoria VARCHAR(200),
		                            codProveedor INT,descProveedor VARCHAR(200),codFabricante INT,descFabricante VARCHAR(200),descripcion VARCHAR(200),
									fechavencimiento DATE,stockAlmprincipal SMALLINT,descUnidadBase VARCHAR(50),codigo INT,estado SMALLINT,mensaje VARCHAR(100)); --tabla temporal

BEGIN TRY      
           SET @g_const_0 = 0;
		   SET @g_const_1 = 1;
		   SET @g_const_9 = 9;
		   SET @g_const_12 = 12;
		   SET @g_const_2000 = 2000;
		   SET @g_const_3000 = 3000;

		   SET @g_caracter = ''
		   SET @estado = 0;
		   SET @mensaje = 'EXITO';
		   SET @g_descCategoria = NULL;
		   SET @g_descSubcategoria = NULL;
		   SET @g_descProveedor = NULL;
		   SET @g_descFabricante = NULL;
		   SET @g_descUnidadBase = NULL;
		   SET @g_undbase = 0;
		   SET @g_stock = 0;
		   SET @g_codproducto = 0;
		   SET @g_codcategoria = 0;
		   SET @g_codsubcategoria = 0;
		   SET @g_codProveedor = 0;
		   SET @g_codFabricante = 0;
		   SET @g_descripcion = NULL;
		   SET @g_fechavencimiento = NULL;


DECLARE qcur_articulos CURSOR LOCAL STATIC READ_ONLY FORWARD_ONLY FOR 
		 SELECT tblProducto.codProducto AS Codproducto,
          tblProducto.codCategoria      AS Codcategoria,
		  tblProducto.codSubcategoria   AS Codsubcategoria,
		  tblAbastecimento.codProveedor AS CodProveedor,
		  tblProducto.codFabricante     AS CodFabricante,
		  tblProducto.descripcion       AS descProducto,
		  tblDetalleLote.fechaVncto     AS fechVencimiento,
		  tblProducto.codUnidadBaseventa AS undBase
		  FROM 
		  tblProducto 
		  INNER JOIN tblAbastecimento
		  ON tblProducto.codProducto = tblAbastecimento.codProducto
		  INNER JOIN tblDetalleLote
		  ON tblProducto.codProducto = tblDetalleLote.codProducto
		  WHERE tblProducto.marcaBaja      = @g_const_0
		  AND   tblAbastecimento.marcaBaja = @g_const_0;
OPEN qcur_articulos;  
 FETCH NEXT FROM qcur_articulos 
 INTO @g_codproducto,@g_codcategoria,@g_codsubcategoria,@g_codProveedor,@g_codFabricante,@g_descripcion,@g_fechavencimiento,@g_undbase; 
 WHILE @@FETCH_STATUS = @g_const_0  
	BEGIN
		SELECT @g_descCategoria = descripcion FROM tblCategoria WHERE ntraCategoria = @g_codcategoria AND marcaBaja = @g_const_0;
		SELECT @g_descSubcategoria = descripcion FROM tblSubcategoria WHERE ntraSubcategoria = @g_codsubcategoria AND marcaBaja = @g_const_0;
		SELECT @g_descProveedor = descripcion  FROM tblProveedor WHERE ntraProveedor = @g_codProveedor AND marcaBaja = @g_const_0;
		SELECT @g_descFabricante = descripcion FROM tblFabricante WHERE ntraFabricante = @g_codFabricante AND marcaBaja = @g_const_0;	
	 	SELECT @g_descUnidadBase = descripcion FROM tblConcepto WHERE codConcepto = @g_const_12 AND correlativo = @g_undbase; 		
		SELECT @g_stock = stock FROM  tblInventario  INNER JOIN tblAlmacen ON  codAlmacen= ntraAlmacen 		                                                                                     
		WHERE abreviatura = 'ALMP' AND codProducto = @g_codproducto;
		
		INSERT INTO #listArticulo
		SELECT @g_codproducto,@g_codcategoria,@g_descCategoria,@g_codsubcategoria,@g_descSubcategoria,@g_codProveedor,@g_descProveedor,
		@g_codFabricante,@g_descFabricante,@g_descripcion,@g_fechavencimiento,@g_stock,@g_descUnidadBase,@g_const_2000,@g_const_0,@mensaje
		SET @g_codproducto = NULL;
		SET @g_stock = 0;
		FETCH NEXT FROM qcur_articulos 
		INTO @g_codproducto,@g_codcategoria,@g_codsubcategoria,@g_codProveedor,@g_codFabricante,@g_descripcion,@g_fechavencimiento,@g_undbase;   
	 END
 CLOSE qcur_articulos;  
 DEALLOCATE qcur_articulos;	
	 	 IF @codCategoria = @g_const_0 AND @codSubcategoria = @g_const_0 AND @codProveedor = @g_const_0
		AND @codFabricante = @g_const_0 AND (LEN(TRIM(@descripcion)) = @g_const_0)
		BEGIN 
		SELECT codProducto,codCategoria,descCategoria,codSubcategoria,descSubcategoria,codProveedor,descProveedor,codFabricante,descFabricante,descripcion,fechavencimiento,stockAlmprincipal,descUnidadBase,codigo,estado,mensaje
		FROM #listArticulo;		 
		END	
	 
	 IF @codCategoria > @g_const_0 AND @codSubcategoria = @g_const_0 AND @codProveedor = @g_const_0
		AND @codFabricante = @g_const_0 AND (LEN(TRIM(@descripcion)) = @g_const_0)
		BEGIN 
		SELECT codProducto,codCategoria,descCategoria,codSubcategoria,descSubcategoria,codProveedor,descProveedor,codFabricante,descFabricante,descripcion,fechavencimiento,stockAlmprincipal,descUnidadBase,codigo,estado,mensaje
		FROM #listArticulo WHERE codCategoria = @codCategoria;		 
		END		
	 IF @codCategoria = @g_const_0 AND @codSubcategoria <> @g_const_0 AND @codProveedor = @g_const_0
		AND @codFabricante = @g_const_0 AND (LEN(TRIM(@descripcion)) = @g_const_0)
		BEGIN
		SELECT codProducto,codCategoria,descCategoria,codSubcategoria,descSubcategoria,codProveedor,descProveedor,codFabricante,descFabricante,descripcion,fechavencimiento,stockAlmprincipal,descUnidadBase,codigo,estado,mensaje
		FROM #listArticulo WHERE codSubcategoria = @codSubcategoria; 
		END
	 IF @codCategoria = @g_const_0 AND @codSubcategoria = @g_const_0 AND @codProveedor <> @g_const_0
		AND @codFabricante = @g_const_0 AND (LEN(TRIM(@descripcion)) = @g_const_0)
		BEGIN

		SELECT codProducto,codCategoria,descCategoria,codSubcategoria,descSubcategoria,codProveedor,descProveedor,codFabricante,descFabricante,descripcion,fechavencimiento,stockAlmprincipal,descUnidadBase,codigo,estado,mensaje
		FROM #listArticulo WHERE codProveedor=@codProveedor;
		 END
	 IF @codCategoria = @g_const_0 AND @codSubcategoria = @g_const_0 AND @codProveedor = @g_const_0
		AND @codFabricante <> @g_const_0 AND (LEN(TRIM(@descripcion)) = @g_const_0)
		BEGIN

		SELECT codProducto,codCategoria,descCategoria,codSubcategoria,descSubcategoria,codProveedor,descProveedor,codFabricante,descFabricante,descripcion,fechavencimiento,stockAlmprincipal,descUnidadBase,codigo,estado,mensaje
		FROM #listArticulo WHERE codFabricante=@codFabricante;
	    END
    IF @codCategoria = @g_const_0 AND @codSubcategoria = @g_const_0 AND @codProveedor = @g_const_0
		AND @codFabricante = @g_const_0 AND (LEN(TRIM(@descripcion)) <> @g_const_0)
		BEGIN
		SELECT codProducto,codCategoria,descCategoria,codSubcategoria,descSubcategoria,codProveedor,descProveedor,codFabricante,descFabricante,descripcion,fechavencimiento,stockAlmprincipal,descUnidadBase,codigo,estado,mensaje
		FROM #listArticulo WHERE descripcion LIKE '%' + TRIM(@descripcion) + '%';
			END
		
	IF @codCategoria <> @g_const_0 AND @codSubcategoria <> @g_const_0 AND @codProveedor = @g_const_0
		AND @codFabricante = @g_const_0 AND (LEN(TRIM(@descripcion)) = @g_const_0)
		BEGIN
		SELECT codProducto,codCategoria,descCategoria,codSubcategoria,descSubcategoria,codProveedor,descProveedor,codFabricante,descFabricante,descripcion,fechavencimiento,stockAlmprincipal,descUnidadBase,codigo,estado,mensaje
		FROM #listArticulo WHERE codCategoria=@codCategoria AND codSubcategoria=@codSubcategoria;
		
		END
	IF @codCategoria = @g_const_0 AND @codSubcategoria <> @g_const_0 AND @codProveedor <> @g_const_0
		AND @codFabricante = @g_const_0 AND (LEN(TRIM(@descripcion)) = @g_const_0)
		BEGIN

		SELECT codProducto,codCategoria,descCategoria,codSubcategoria,descSubcategoria,codProveedor,descProveedor,codFabricante,descFabricante,descripcion,fechavencimiento,stockAlmprincipal,descUnidadBase,codigo,estado,mensaje
		FROM #listArticulo WHERE codSubcategoria=@codSubcategoria  AND codProveedor=@codProveedor;
		END
    IF @codCategoria = @g_const_0 AND @codSubcategoria = @g_const_0 AND @codProveedor <> @g_const_0
		AND @codFabricante <> @g_const_0 AND (LEN(TRIM(@descripcion)) = @g_const_0)
		BEGIN

		SELECT codProducto,codCategoria,descCategoria,codSubcategoria,descSubcategoria,codProveedor,descProveedor,codFabricante,descFabricante,descripcion,fechavencimiento,stockAlmprincipal,descUnidadBase,codigo,estado,mensaje
		FROM #listArticulo WHERE codProveedor=@codProveedor AND codFabricante=@codFabricante;
		END
    IF @codCategoria = @g_const_0 AND @codSubcategoria = @g_const_0 AND @codProveedor = @g_const_0
		AND @codFabricante <> @g_const_0 AND (LEN(TRIM(@descripcion)) <> @g_const_0)
		BEGIN
		SELECT codProducto,codCategoria,descCategoria,codSubcategoria,descSubcategoria,codProveedor,descProveedor,codFabricante,descFabricante,descripcion,fechavencimiento,stockAlmprincipal,descUnidadBase,codigo,estado,mensaje
		FROM #listArticulo WHERE codFabricante=@codFabricante  AND descripcion LIKE '%' + TRIM(@descripcion) + '%';
		END
    IF @codCategoria <> @g_const_0 AND @codSubcategoria = @g_const_0 AND @codProveedor<> @g_const_0
		AND @codFabricante = @g_const_0 AND (LEN(TRIM(@descripcion)) = @g_const_0)
		BEGIN
		SELECT codProducto,codCategoria,descCategoria,codSubcategoria,descSubcategoria,codProveedor,descProveedor,codFabricante,descFabricante,descripcion,fechavencimiento,stockAlmprincipal,descUnidadBase,codigo,estado,mensaje
		FROM #listArticulo WHERE codCategoria=@codCategoria AND codProveedor=@codProveedor;
		 END
	IF @codCategoria <> @g_const_0 AND @codSubcategoria = @g_const_0 AND @codProveedor= @g_const_0
		AND @codFabricante <> @g_const_0 AND (LEN(TRIM(@descripcion)) = @g_const_0)
		BEGIN
		SELECT codProducto,codCategoria,descCategoria,codSubcategoria,descSubcategoria,codProveedor,descProveedor,codFabricante,descFabricante,descripcion,fechavencimiento,stockAlmprincipal,descUnidadBase,codigo,estado,mensaje
		FROM #listArticulo WHERE codCategoria=@codCategoria  AND codFabricante=@codFabricante;
		END
	IF @codCategoria <> @g_const_0 AND @codSubcategoria = @g_const_0 AND @codProveedor = @g_const_0
		AND @codFabricante = @g_const_0 AND (LEN(TRIM(@descripcion)) <> @g_const_0)
		BEGIN

		SELECT codProducto,codCategoria,descCategoria,codSubcategoria,descSubcategoria,codProveedor,descProveedor,codFabricante,descFabricante,descripcion,fechavencimiento,stockAlmprincipal,descUnidadBase,codigo,estado,mensaje
		FROM #listArticulo WHERE codCategoria = @codCategoria AND descripcion LIKE '%' + TRIM(@descripcion) + '%';			
		END 
	IF @codCategoria = @g_const_0 AND @codSubcategoria <> @g_const_0 AND @codProveedor = @g_const_0
		AND @codFabricante <> @g_const_0 AND (LEN(TRIM(@descripcion)) = @g_const_0)
		BEGIN

		SELECT codProducto,codCategoria,descCategoria,codSubcategoria,descSubcategoria,codProveedor,descProveedor,codFabricante,descFabricante,descripcion,fechavencimiento,stockAlmprincipal,descUnidadBase,codigo,estado,mensaje
		FROM #listArticulo WHERE codSubcategoria= @codSubcategoria AND codFabricante= @codFabricante;
		END
	IF @codCategoria = @g_const_0 AND @codSubcategoria <> @g_const_0 AND @codProveedor = @g_const_0
		AND @codFabricante = @g_const_0 AND (LEN(TRIM(@descripcion)) <> @g_const_0)
		BEGIN		
		SELECT codProducto,codCategoria,descCategoria,codSubcategoria,descSubcategoria,codProveedor,descProveedor,codFabricante,descFabricante,descripcion,fechavencimiento,stockAlmprincipal,descUnidadBase,codigo,estado,mensaje
		FROM #listArticulo WHERE codSubcategoria= @codSubcategoria AND descripcion LIKE '%' + TRIM(@descripcion) + '%';			
		END
	 IF @codCategoria = @g_const_0 AND @codSubcategoria = @g_const_0 AND @codProveedor <> @g_const_0
		AND @codFabricante = @g_const_0 AND (LEN(TRIM(@descripcion)) <> @g_const_0)
		BEGIN	
		SELECT codProducto,codCategoria,descCategoria,codSubcategoria,descSubcategoria,codProveedor,descProveedor,codFabricante,descFabricante,descripcion,fechavencimiento,stockAlmprincipal,descUnidadBase,codigo,estado,mensaje
		FROM #listArticulo WHERE codProveedor=@codProveedor AND descripcion LIKE '%' + TRIM(@descripcion) + '%';	
		END
	IF @codCategoria <> @g_const_0 AND @codSubcategoria <> @g_const_0 AND @codProveedor <> @g_const_0
		AND @codFabricante = @g_const_0 AND (LEN(TRIM(@descripcion)) = @g_const_0)
		BEGIN		
		SELECT codProducto,codCategoria,descCategoria,codSubcategoria,descSubcategoria,codProveedor,descProveedor,codFabricante,descFabricante,descripcion,fechavencimiento,stockAlmprincipal,descUnidadBase,codigo,estado,mensaje
		FROM #listArticulo WHERE codCategoria=@codCategoria AND codSubcategoria=@codSubcategoria AND codProveedor=@codProveedor;		
		END
    IF @codCategoria = @g_const_0 AND @codSubcategoria <> @g_const_0 AND @codProveedor <> @g_const_0
		AND @codFabricante <> @g_const_0 AND (LEN(TRIM(@descripcion)) = @g_const_0)
		BEGIN 
		SELECT codProducto,codCategoria,descCategoria,codSubcategoria,descSubcategoria,codProveedor,descProveedor,codFabricante,descFabricante,descripcion,fechavencimiento,stockAlmprincipal,descUnidadBase,codigo,estado,mensaje
		FROM #listArticulo WHERE codSubcategoria=@codSubcategoria AND codProveedor=@codProveedor AND codFabricante=@codFabricante;	
		END
	IF @codCategoria = @g_const_0 AND @codSubcategoria = @g_const_0 AND @codProveedor <> @g_const_0
		AND @codFabricante <> @g_const_0 AND (LEN(TRIM(@descripcion)) <> @g_const_0)
		BEGIN	
		SELECT codProducto,codCategoria,descCategoria,codSubcategoria,descSubcategoria,codProveedor,descProveedor,codFabricante,descFabricante,descripcion,fechavencimiento,stockAlmprincipal,descUnidadBase,codigo,estado,mensaje
		FROM #listArticulo WHERE codProveedor=@codProveedor AND codFabricante=@codFabricante AND descripcion LIKE '%' + TRIM(@descripcion) + '%';	
		END	
   IF @codCategoria <> @g_const_0 AND @codSubcategoria = @g_const_0 AND @codProveedor <> @g_const_0
		AND @codFabricante <> @g_const_0 AND (LEN(TRIM(@descripcion)) = @g_const_0)
		BEGIN
		SELECT codProducto,codCategoria,descCategoria,codSubcategoria,descSubcategoria,codProveedor,descProveedor,codFabricante,descFabricante,descripcion,fechavencimiento,stockAlmprincipal,descUnidadBase,codigo,estado,mensaje
		FROM #listArticulo WHERE codCategoria=@codCategoria AND codProveedor= @codProveedor AND codFabricante=@codFabricante;	
		END
 IF @codCategoria <> @g_const_0 AND @codSubcategoria = @g_const_0 AND @codProveedor= @g_const_0
		AND @codFabricante <> @g_const_0 AND (LEN(TRIM(@descripcion)) <> @g_const_0)
		BEGIN
		SELECT codProducto,codCategoria,descCategoria,codSubcategoria,descSubcategoria,codProveedor,descProveedor,codFabricante,descFabricante,descripcion,fechavencimiento,stockAlmprincipal,descUnidadBase,codigo,estado,mensaje
		FROM #listArticulo WHERE codCategoria=@codCategoria  AND codFabricante=@codFabricante AND descripcion LIKE '%' + TRIM(@descripcion) + '%';
		END

 IF @codCategoria <> @g_const_0 AND @codSubcategoria = @g_const_0 AND @codProveedor <> @g_const_0
		AND @codFabricante <> @g_const_0 AND (LEN(TRIM(@descripcion)) <> @g_const_0)
		BEGIN
		SELECT codProducto,codCategoria,descCategoria,codSubcategoria,descSubcategoria,codProveedor,descProveedor,codFabricante,descFabricante,descripcion,fechavencimiento,stockAlmprincipal,descUnidadBase,codigo,estado,mensaje
		FROM #listArticulo WHERE codCategoria=@codCategoria  AND codFabricante=@codFabricante AND codProveedor=@codProveedor  AND descripcion LIKE '%' + TRIM(@descripcion) + '%';
		END

 IF @codCategoria <> @g_const_0 AND @codSubcategoria <> @g_const_0 AND @codProveedor = @g_const_0
		AND @codFabricante <> @g_const_0 AND  (LEN(TRIM(@descripcion)) = @g_const_0)
		BEGIN
		SELECT codProducto,codCategoria,descCategoria,codSubcategoria,descSubcategoria,codProveedor,descProveedor,codFabricante,descFabricante,descripcion,fechavencimiento,stockAlmprincipal,descUnidadBase,codigo,estado,mensaje
		FROM #listArticulo WHERE codCategoria=@codCategoria  AND codFabricante=@codFabricante AND codSubcategoria=@codSubcategoria;
		END
   IF @codCategoria <> @g_const_0 AND @codSubcategoria <> @g_const_0 AND @codProveedor <> @g_const_0
		AND @codFabricante <> @g_const_0 AND  (LEN(TRIM(@descripcion)) = @g_const_0)
		BEGIN
		SELECT codProducto,codCategoria,descCategoria,codSubcategoria,descSubcategoria,codProveedor,descProveedor,codFabricante,descFabricante,descripcion,fechavencimiento,stockAlmprincipal,descUnidadBase,codigo,estado,mensaje
		FROM #listArticulo WHERE codCategoria=@codCategoria  AND codFabricante=@codFabricante AND codSubcategoria=@codSubcategoria AND  codProveedor=@codProveedor ;
		END
   IF @codCategoria <> @g_const_0 AND @codSubcategoria <> @g_const_0 AND @codProveedor <> @g_const_0
		AND @codFabricante <> @g_const_0 AND  (LEN(TRIM(@descripcion)) <> @g_const_0)
		BEGIN
		SELECT codProducto,codCategoria,descCategoria,codSubcategoria,descSubcategoria,codProveedor,descProveedor,codFabricante,descFabricante,descripcion,fechavencimiento,stockAlmprincipal,descUnidadBase,codigo,estado,mensaje
		FROM #listArticulo WHERE codCategoria=@codCategoria  AND codFabricante=@codFabricante AND codSubcategoria=@codSubcategoria AND  codProveedor=@codProveedor 
		AND descripcion LIKE '%' + TRIM(@descripcion) + '%';
		END

		
END TRY
BEGIN CATCH
                SET @codigo = @g_const_3000;
				SET @estado = @g_const_1;
				SET @mensaje = ERROR_MESSAGE();
			SELECT '' AS codproducto,@g_const_0 as codCategoria,'' as descCategoria,@g_const_0 as codSubcategoria,'' as descSubcategoria,@g_const_0 as codProveedor,'' as descProveedor,
			@g_const_0 as codFabricante,'' as descFabricante,'' as descripcion, '' as fechavencimiento, @g_const_0 as stockAlmprincipal, '' as descUnidadBase,
			@codigo as codigo, @estado as estado,@mensaje as mensaje
END CATCH
END


