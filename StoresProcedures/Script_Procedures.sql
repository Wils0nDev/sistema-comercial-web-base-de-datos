IF DB_NAME() = 'BD_virgendelcarmen'
	set noexec on
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_obtener_existencia_articulo' AND type = 'P')
	DROP PROCEDURE pa_obtener_existencia_articulo
GO
----------------------------------------------------------------------------------
-- Author: Jose Chumioque IDE-SOLUTION
-- Created: 29/01/2020  
-- Sistema: Sistema de Preventas
-- Modulo: General
-- Descripci�n: validar si existe un articulo
-- Log Modificaciones: 
-- CODIGO    REQUERIMIENTO          NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[pa_obtener_existencia_articulo]	
(
@codProducto  VARCHAR(10)
)
AS
SET NOCOUNT ON

BEGIN
        DECLARE @g_const_0 SMALLINT; -- valor 0
		DECLARE @g_const_1 SMALLINT;  --valor 1
		DECLARE @g_cant SMALLINT; --articulo
     
           SET @g_const_0 = 0;
		   SET @g_const_1 = 1;
		   SET @g_cant = 0; 
   select @g_cant = count(*) from tblProducto where codProducto = TRIM(@codProducto) 
   and marcaBaja = @g_const_0;  
   select @g_cant as cantidad
END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_listar_detalle_almacen' AND type = 'P')
	DROP PROCEDURE pa_listar_detalle_almacen
GO
----------------------------------------------------------------------------------
-- Author: Jose Chumioque IDE-SOLUTION
-- Created: 13/01/2020  
-- Sistema: Sistema de Preventas
-- Modulo: General
-- Descripci�n: Listar detalle de almacenes
-- Log Modificaciones: 
-- CODIGO    REQUERIMIENTO          NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[pa_listar_detalle_almacen]	
(
@codArticulo  VARCHAR(10)
)
AS
SET NOCOUNT ON

BEGIN
        DECLARE @g_const_0 INT -- valor 0	

BEGIN TRY      
           SET @g_const_0 = 0;
  
   if len(trim(@codArticulo)) > 0 
    BEGIN
    select ntraAlmacen,alm.descripcion,pro.codProducto,COALESCE(stock,@g_const_0) as stock
    from tblAlmacen as alm  left join tblInventario as inv on codAlmacen=ntraAlmacen and inv.marcaBaja=@g_const_0 and inv.codProducto= @codArticulo 
                            left join tblProducto as pro on inv.codProducto = pro.codProducto and pro.marcaBaja = @g_const_0
    where alm.marcaBaja= @g_const_0 
	
   END
END TRY
BEGIN CATCH
           SELECT   
	        ERROR_NUMBER() AS ErrorNumber  
	       ,ERROR_MESSAGE() AS ErrorMessage;
END CATCH
END
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_listar_datos_select_x_flag' AND type = 'P')
	DROP PROCEDURE pa_listar_datos_select_x_flag
GO
----------------------------------------------------------------------------------
-- Author: WILSON IDE-SOLUTION
-- Created: 13/01/2020  
-- Sistema: ws_wa_DistribuidoraVDC
-- Descripci�n: Traer lista de datos por flag
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[pa_listar_datos_select_x_flag]   
( 
@flag integer    
)
AS   
BEGIN
    IF @flag = 1 
	SELECT u.ntraUsuario, CONCAT(p.nombres,' ', p.apellidoPaterno,' ',p.apellidoMaterno) as vendedor FROM tblUsuario u
    INNER JOIN tblPersona p on u.codPersona = p.codPersona
	INNER JOIN tblPerfil pe on u.codPerfil = pe.codigo
	WHERE p.marcaBaja = 0 AND u.marcaBaja = 0 and u.codPerfil = 1
	
	IF @flag = 2
		SELECT correlativo, descripcion FROM tblConcepto 
		WHERE codConcepto = 2 AND correlativo > 0 AND marcaBaja = 0;

	IF @flag = 3
		SELECT ntraRutas,descripcion,pseudonimo FROM tblRutas
		WHERE marcaBaja = 0;
	
	IF @flag = 4
	SELECT correlativo, descripcion FROM tblConcepto 
	WHERE codConcepto = 8 AND correlativo > 0 AND marcaBaja = 0;

	IF @flag = 5
	begin
	SELECT ntraCategoria as correlativo,descripcion FROM tblCategoria WHERE marcaBaja = 0;
	end

	IF @flag = 6
	begin
	SELECT ntraSubcategoria as correlativo,descripcion FROM tblSubcategoria WHERE marcaBaja = 0;
	end

	IF @flag = 7
		SELECT codDepartamento, nombre FROM tblDepartamento WHERE marcaBaja = 0;

	IF @flag = 8
		SELECT codDepartamento, codProvincia, nombre FROM tblProvincia WHERE marcaBaja = 0;

	IF @flag = 9
		SELECT codDepartamento, codProvincia,  codDistrito, nombre FROM tblDistrito WHERE marcaBaja = 0;
	IF @flag = 10
    SELECT correlativo,descripcion FROM tblConcepto 
	WHERE codConcepto = 11 AND correlativo > 0 AND marcaBaja = 0;

	IF @flag = 11
		SELECT correlativo, descripcion FROM tblConcepto 
		WHERE codConcepto = 1 AND correlativo > 0 AND marcaBaja = 0;

	IF @flag = 12
		SELECT correlativo, descripcion FROM tblConcepto 
		WHERE codConcepto = 3 AND correlativo > 0 AND marcaBaja = 0;

	IF @flag = 13
		SELECT correlativo, descripcion FROM tblConcepto 
		WHERE codConcepto = 4 AND correlativo > 0 AND marcaBaja = 0;

	IF @flag = 14
		SELECT correlativo, descripcion FROM tblConcepto 
		WHERE codConcepto = 5 AND correlativo > 0 AND marcaBaja = 0;

	IF @flag = 15
		SELECT correlativo, descripcion FROM tblConcepto 
		WHERE codConcepto = 7 AND correlativo > 0 AND marcaBaja = 0;

	IF @flag = 16
		SELECT ntraRutas as correlativo, descripcion FROM tblRutas
		WHERE marcaBaja = 0;
	IF @flag = 17
	   select ntraAlmacen as correlativo,upper(descripcion) as descripcion from tblAlmacen where marcaBaja = 0;

	IF @flag = 18
		SELECT ntraSucursal,descripcion FROM tblSucursal WHERE marcaBaja = 0;
	
	IF @flag = 19 -- estados de la preventa
		SELECT correlativo, descripcion FROM tblConcepto WHERE codConcepto = 17 AND correlativo > 0 AND marcaBaja = 0;
	IF @flag = 20 -- origen de venta de la preventa
		SELECT correlativo, descripcion FROM tblConcepto WHERE codConcepto = 18 AND correlativo > 0 AND marcaBaja = 0;
	IF @flag = 21 -- tipo venta de la preventa
		SELECT correlativo, descripcion FROM tblConcepto WHERE codConcepto = 19 AND correlativo > 0 AND marcaBaja = 0;
	IF @flag = 22 -- tipo documento de la preventa
		SELECT correlativo, descripcion FROM tblConcepto WHERE codConcepto = 20 AND correlativo > 0 AND marcaBaja = 0;

	IF @flag = 23 --PROVEEDORES
		SELECT ntraProveedor, descripcion, abreviatura FROM tblProveedor WHERE marcaBaja = 0;

	IF @flag = 23 --DATOS DE LA PROMOCION
		SELECT ntraPromocion, descripcion, fechaInicial, fechaFin, horaInicial, horaFin FROM tblPromociones WHERE marcaBaja = 0;

	IF @flag = 24 -- Listar estado  usuarios

	SELECT correlativo, descripcion FROM tblConcepto WHERE codConcepto = 14 AND correlativo > 0 AND marcaBaja = 0;
			
			
	IF @flag = 25 -- TIPO DE VENTA
		SELECT ntraConcepto, codConcepto, correlativo, descripcion FROM tblConcepto where codConcepto = 19 and marcaBaja = 0

	IF @flag = 26 -- TIPO UNIDAD DE PRODUCTO 
		SELECT  correlativo, descripcion FROM tblConcepto where codConcepto = 12 and marcaBaja = 0 AND correlativo > 0

	IF @flag = 27 -- FABRICANTE
		SELECT  ntraFabricante, descripcion FROM tblFabricante where marcaBaja = 0

	IF @flag = 28 -- ESTADO DE PROMOCION
		SELECT ntraConcepto, codConcepto, correlativo, descripcion FROM tblConcepto where codConcepto = 24 and marcaBaja = 0

	IF @flag = 29 -- TIPO DE PRUCTO 
		SELECT correlativo, descripcion FROM tblConcepto where codConcepto = 23 and marcaBaja = 0 AND correlativo >0
		
	IF @flag = 30 -- ESTADOS DE FACTURA
		SELECT correlativo, descripcion FROM tblConcepto where codConcepto = 28 and marcaBaja = 0 AND correlativo >0
		
	IF @flag = 31 -- MEDIOS DE PAGO
	SELECT ntraMedioPago as correlativo, descripcion FROM tblMediosDePago where  marcaBaja = 0

	IF @flag = 32 -- PERFILES DE USUARIOS
	SELECT codigo, descripcion FROM tblPerfil WHERE marcaBaja = 0

	IF @flag = 33 -- ESTADO DEL DESCUENTO
	SELECT correlativo as codigo, descripcion FROM tblConcepto where codConcepto = 30 and correlativo>0 and marcaBaja = 0

	IF @flag = 34 -- ESTADOS DE TRANSACCION DE PAGO
	SELECT correlativo, descripcion FROM tblConcepto where codConcepto = 33 and correlativo>0 and marcaBaja = 0

	IF @flag = 35 -- TIPO DE INDICADOR DE OBJETIVO
		SELECT correlativo, descripcion FROM tblConcepto where codConcepto = 35 and marcaBaja = 0 AND correlativo >0
	
	IF @flag = 36 -- FLAG DE METAS Y OBJETIVOS
		SELECT correlativo, descripcion FROM tblConcepto where codConcepto = 36 and marcaBaja = 0 AND correlativo >0
		
	IF @flag = 37 -- TIPOS DE REGISTROS
		SELECT correlativo, descripcion FROM tblConcepto where codConcepto = 39 and marcaBaja = 0 AND correlativo >0

	IF @flag = 38 -- ESTADOS DE CAJA
		SELECT correlativo, descripcion FROM tblConcepto where codConcepto = 41 and marcaBaja = 0 AND correlativo >0
	IF @flag = 52 -- TIPO DE MONEDA
		SELECT correlativo, descripcion FROM tblConcepto where codConcepto = 21 and marcaBaja = 0 AND correlativo >0
END
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_buscar_vendedor_sinc' AND type = 'P')
	DROP PROCEDURE pa_buscar_vendedor_sinc
GO
----------------------------------------------------------------------------------
-- Author: Wilmer Sanchez IDE-SOLUTION
-- Created: 13/01/2020  
-- Sistema: ws_wa_DistribuidoraVDC
-- Descripci�n: Traer lista de clientes por ruta
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_buscar_vendedor_sinc
(
	@p_codUsuario INT -- codigo usuario
)		
AS
	BEGIN
		DECLARE @g_const_0 SMALLINT -- valor 0
		DECLARE @g_const_vacio CHAR(1) -- constante vacio
		DECLARE @g_const_espacio CHAR(1) -- constante espacio
		DECLARE @g_const_2000 SMALLINT -- Constante 2000
		DECLARE @g_const_msj VARCHAR(200) -- Mensaje
		BEGIN TRY		
			
			SET @g_const_vacio = '';
			SET @g_const_espacio = ' ';
			SET @g_const_0 = 0;
			SET @g_const_2000 = 2000
			SET @g_const_msj = 'Consulta exitosa'
			SET NOCOUNT ON; 

			select ntraUsuario,
			codPerfil,
			tipoDocumento,
			numeroDocumento,
			apellidoPaterno,
			apellidoMaterno,
			nombres,
			TRIM(						
				COALESCE(p.apellidoPaterno,@g_const_vacio)+ @g_const_espacio+ 
				COALESCE(p.apellidoMaterno,@g_const_vacio) + @g_const_espacio+ 
				COALESCE(p.nombres,@g_const_vacio)
			)  as nombreCompleto, 
			COALESCE(direccion,@g_const_vacio) as direccion,
			COALESCE(correo,@g_const_vacio) as correo,
			COALESCE(telefono,@g_const_vacio) as telefono,
			COALESCE(celular,@g_const_vacio) as celular
			, @g_const_2000 AS codigo
			, @g_const_msj as mensaje
			from tblUsuario u 
			INNER JOIN tblPersona p on u.codPersona = p.codPersona
			WHERE u.ntraUsuario = @p_codUsuario AND p.marcaBaja = @g_const_0 AND u.marcaBaja = @g_const_0


			
		END TRY
		BEGIN CATCH

			SELECT
					@g_const_0 AS ntraUsuario, 
					@g_const_0 AS codPerfil, 
					@g_const_0 AS tipoDocumento, 
					@g_const_vacio AS numeroDocumento, 
					@g_const_vacio AS apellidoPaterno, 
					@g_const_vacio AS apellidoMaterno,
					@g_const_vacio AS nombres, 
					@g_const_vacio as nombreCompleto, 
					@g_const_vacio AS direccion, 
					@g_const_vacio AS correo, 
					@g_const_vacio AS telefono, 
					@g_const_vacio AS celular,
					ERROR_NUMBER() AS codigo,
					ERROR_MESSAGE() AS mensaje


		END CATCH

	END	
	
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_eliminar_rutas_asignadas' AND type = 'P')
	DROP PROCEDURE pa_eliminar_rutas_asignadas
GO
----------------------------------------------------------------------------------
-- Author: WILSON IDE-SOLUTION
-- Created: 13/01/2020  
-- Sistema: ws_wa_DistribuidoraVDC
-- Descripción: Eliminar rutas asignadas
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[pa_eliminar_rutas_asignadas]
(
	@codUsuario INT,
	@codRuta INT,
	@resultado INT OUTPUT
)

AS
	BEGIN
		BEGIN TRY
			UPDATE tblRutasAsignadas SET marcaBaja = 9  WHERE codUsuario = @codUsuario and codRuta = @codRuta
			SELECT @resultado = @codUsuario			
		END TRY
		BEGIN CATCH
				SELECT  
					ERROR_NUMBER() AS NumeroDeError   
				   ,ERROR_STATE() AS NumeroDeEstado    
				   ,ERROR_LINE() AS  NumeroDeLinea  
				   ,ERROR_MESSAGE() AS MensajeDeError;  
		END CATCH
END

GO
IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_insertar_rutas_asignadas' AND type = 'P')
	DROP PROCEDURE pa_insertar_rutas_asignadas
GO
----------------------------------------------------------------------------------
-- Author: WILSON IDE-SOLUTION
-- Created: 13/01/2020  
-- Sistema: ws_wa_DistribuidoraVDC
-- Descripción: Insertar rutas asignadas
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[pa_insertar_rutas_asignadas]
(
	@codUsuario INT,
	@codRuta INT,
	@codOrden INT,
	@diaSemana SMALLINT,
	@resultado INT OUTPUT
)

AS
	BEGIN
	DECLARE @contRuta INT
	DECLARE @codUser INT 

BEGIN TRY
	SET @contRuta = 0
		SELECT @contRuta = count(codRuta), @codUser = codUsuario  FROM tblRutasAsignadas WHERE codRuta = @codRuta and marcaBaja = 0
		GROUP BY codUsuario

		IF @contRuta = 0
			BEGIN
			INSERT INTO tblRutasAsignadas
			(codUsuario,codRuta,codOrden,diaSemana,usuario)
			VALUES (@codUsuario,@codRuta,@codOrden,@diaSemana,'evasquez');

			SELECT @resultado = 0
				
		END
		ELSE 
			BEGIN
			SELECT @resultado = @codUser
		 END
END TRY
BEGIN CATCH

		SELECT  
			ERROR_NUMBER() AS NumeroDeError   
            ,ERROR_STATE() AS NumeroDeEstado    
            ,ERROR_LINE() AS  NumeroDeLinea  
            ,ERROR_MESSAGE() AS MensajeDeError;  
END CATCH

END
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_listar_almacen_sinc' AND type = 'P')
	DROP PROCEDURE pa_listar_almacen_sinc
GO
----------------------------------------------------------------------------------
-- Author: Wilmer Sanchez IDE-SOLUTION
-- Created: 13/01/2020  
-- Sistema: ws_wa_DistribuidoraVDC
-- Descripci�n: Traer lista de almacenes
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_listar_almacen_sinc	
AS
	BEGIN
		DECLARE @g_const_0 SMALLINT -- valor 0
		DECLARE @g_const_vacio CHAR(1) -- Constante vacio
		DECLARE @g_const_2000 SMALLINT -- Constante 2000
		DECLARE @g_const_msj VARCHAR(200) -- Mensaje
		DECLARE @g_const_almacen CHAR(5) -- Almacen principal
		BEGIN TRY		
			
			SET @g_const_vacio = '';
			SET @g_const_0 = 0;
			SET @g_const_2000 = 2000
			SET @g_const_msj = 'Consulta exitosa'
			SET @g_const_almacen = 'ALMP'
			SET NOCOUNT ON;

			SELECT ntraAlmacen,abreviatura,descripcion,@g_const_2000 as codigo,@g_const_msj as mensaje FROM tblAlmacen where marcaBaja = @g_const_0 AND abreviatura = @g_const_almacen

			
		END TRY
		BEGIN CATCH
			SELECT
					@g_const_0 AS ntraAlmacen, 
					@g_const_vacio AS abreviatura, 
					@g_const_vacio AS descripcion, 
					ERROR_NUMBER() AS codigo,
					ERROR_MESSAGE() AS mensaje
					


		END CATCH

	END	
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_update_stock_almacen' AND type = 'P')
	DROP PROCEDURE pa_update_stock_almacen
GO
----------------------------------------------------------------------------------
-- Author: Jose Chumioque IDE-SOLUTION
-- Created: 16/01/2020  
-- Sistema: Sistema de Preventas
-- Modulo: General
-- Descripci�n: Registrar/Actualizar stock por almacen
-- Log Modificaciones: 
-- CODIGO    REQUERIMIENTO          NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_update_stock_almacen	
(
@stock  INT,
@codArticulo  VARCHAR(10),
@codAlmacen INT
)
AS
SET NOCOUNT ON

BEGIN
        DECLARE @g_const_0 INT -- valor 0	
		DECLARE @g_const_1 INT -- valor 0
		DECLARE @g_cant    SMALLINT --Cantidad
		DECLARE @codigo INT -- Codigo 
		DECLARE @mensaje VARCHAR(100) -- mensaje
		DECLARE @g_const_3000 SMALLINT -- valor 3000
		DECLARE @g_const_2000 SMALLINT -- valor 2000
		DECLARE @estado SMALLINT -- 0:EXITO, 1:error interno
BEGIN TRY      
           SET @g_const_0 = 0;
		   SET @g_const_1 = 1;
		   SET @g_cant = 0;
		   SET @estado = 0;
		   SET @mensaje = '';
		   SET @g_const_2000 = 2000;
		   SET @g_const_3000 = 3000;
  
    SELECT @g_cant = count(ntraInventario) FROM tblInventario 
    WHERE  codProducto = @codArticulo
    AND codAlmacen = @codAlmacen
    AND marcaBaja = @g_const_0
	IF  @g_cant = @g_const_0
	BEGIN
	  BEGIN TRANSACTION
	   INSERT INTO tblInventario (codAlmacen,codProducto,stock,marcaBaja,usuario)
	   VALUES (@codAlmacen,@codArticulo,@stock,@g_const_0,'');
	   COMMIT TRANSACTION 
	    SET @codigo = @g_const_2000;
        SET @estado = @g_const_0;
		SET @mensaje = 'REGISTRO EXITOSO';	
	END
	ELSE
	BEGIN
	  BEGIN TRANSACTION
	    update tblInventario SET stock = @stock
        WHERE  codProducto = @codArticulo
        AND codAlmacen = @codAlmacen 
        AND marcaBaja = @g_const_0;
		COMMIT TRANSACTION 
		SET @codigo = @g_const_2000;
        SET @estado = @g_const_0;
		SET @mensaje = 'ACTUALIZACION CORRECTA';
	 END
	  SELECT  @codigo as codigo, @estado as estado , @mensaje as mensaje
END TRY
BEGIN CATCH
      BEGIN TRANSACTION
        SET @codigo = @g_const_3000;
        SET @estado = @g_const_1;
	    SET @mensaje = ERROR_MESSAGE();
		SELECT  @codigo as codigo, @estado as estado , @mensaje as mensaje
		ROLLBACK TRANSACTION		
END CATCH
END
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_actualizar_rutas_asignadas' AND type = 'P')
	DROP PROCEDURE pa_actualizar_rutas_asignadas
GO
----------------------------------------------------------------------------------
-- Author: WILSON IDE-SOLUTION
-- Created: 13/01/2020  
-- Sistema: ws_wa_DistribuidoraVDC
-- Descripción: Actualizar rutas asiganadas
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[pa_actualizar_rutas_asignadas]
(
	@codUsuario INT,
	@codRuta INT,
	@diaSemana INT,
	@codRutaAnterior INT,
	@resultado INT OUTPUT
)

AS
	BEGIN
	DECLARE @contRuta INT
	DECLARE @codUser INT 
	DECLARE @dia INT
	DECLARE @ruta INT 
	  
BEGIN TRY
		SET @contRuta = 0

		SELECT @contRuta = count(codRuta), @codUser = codUsuario , @dia = diaSemana, @ruta = codRuta FROM tblRutasAsignadas WHERE codRuta = @codRuta and marcaBaja = 0
		GROUP BY codUsuario, diaSemana, codRuta

		IF @contRuta = 0
		BEGIN
		UPDATE tblRutasAsignadas SET codRuta = @codRuta, diaSemana = @diaSemana WHERE codUsuario = @codUsuario and codRuta = @codRutaAnterior
		SELECT @resultado = 0
		END
		ELSE 
			BEGIN
			IF @contRuta > 0 AND @diaSemana <> @dia AND @codUsuario = @codUser AND @ruta = @codRutaAnterior
			BEGIN 
			UPDATE tblRutasAsignadas SET  diaSemana = @diaSemana WHERE codUsuario = @codUsuario and codRuta = @codRutaAnterior
			SELECT @resultado = 0
			END
			ELSE
			BEGIN 
			SELECT @resultado = @codUser
			END
			
		END 
		
END TRY
BEGIN CATCH
		SELECT @resultado = 0
		SELECT  
			ERROR_NUMBER() AS NumeroDeError   
            ,ERROR_STATE() AS NumeroDeEstado    
            ,ERROR_LINE() AS  NumeroDeLinea  
            ,ERROR_MESSAGE() AS MensajeDeError;  
END CATCH

END
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_listar_clientes_ruta_sinc' AND type = 'P')
	DROP PROCEDURE pa_listar_clientes_ruta_sinc
GO
----------------------------------------------------------------------------------
-- Author: Wilmer Sanchez IDE-SOLUTION
-- Created: 13/01/2020  
-- Sistema: ws_wa_DistribuidoraVDC
-- Descripci?n: Traer lista de clientes por ruta
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_listar_clientes_ruta_sinc
(
	@p_codRuta INT
)		
AS
	BEGIN
		DECLARE @g_const_0 SMALLINT -- valor 0
		DECLARE @g_const_vacio CHAR(1)
		DECLARE @g_const_espacio CHAR(1)
		BEGIN TRY		
			
			SET @g_const_vacio = '';
			SET @g_const_espacio = ' ';
			SET @g_const_0 = 0;
			SET NOCOUNT ON; 

			SELECT  p.codPersona, 
					p.tipoPersona, 
					p.tipoDocumento, 
					p.numeroDocumento, 
					p.ruc, 
					p.razonSocial,
					p.nombres, 
					p.apellidoPaterno, 
					p.apellidoMaterno,
					TRIM(
						COALESCE(p.nombres,@g_const_vacio)+ @g_const_espacio+ 
						COALESCE(p.apellidoPaterno,@g_const_vacio)+ @g_const_espacio+ 
						COALESCE(p.apellidoMaterno,@g_const_vacio) + @g_const_espacio +  
						COALESCE(p.numeroDocumento,@g_const_vacio) + @g_const_espacio + 
						COALESCE(p.razonSocial,@g_const_vacio) + @g_const_espacio + 
						COALESCE(	p.ruc, @g_const_vacio)
					)  as 'nombreCodigo', 
					p.direccion, 
					p.correo, 
					p.telefono, 
					p.celular,
					c.frecuenciaCliente, 
					c.tipoListaPrecio, 
					c.codRuta,
					COALESCE(c.ordenAtencion,@g_const_0) AS 'ordenAtencion',
					p.codUbigeo,
					2000 AS 'codigo',
					'Consulta exitosa' as mensaje

				FROM tblPersona p INNER JOIN tblCliente c ON p.codPersona = c.codPersona
				WHERE p.marcaBaja = @g_const_0 AND c.marcaBaja = @g_const_0 AND c.codRuta = @p_codRuta
				ORDER BY c.fechaProceso,c.horaProceso ASC
			
		END TRY
		BEGIN CATCH

			SELECT
					@g_const_0 AS codPersona, 
					@g_const_0 AS tipoPersona, 
					@g_const_0 AS tipoDocumento, 
					@g_const_vacio AS numeroDocumento, 
					@g_const_vacio AS ruc, 
					@g_const_vacio AS razonSocial,
					@g_const_vacio AS nombres, 
					@g_const_vacio AS apellidoPaterno, 
					@g_const_vacio AS apellidoMaterno,
					@g_const_vacio as nombreCodigo, 
					@g_const_vacio AS direccion, 
					@g_const_vacio AS correo, 
					@g_const_vacio AS telefono, 
					@g_const_vacio AS celular,
					@g_const_0 AS frecuenciaCliente, 
					@g_const_0 AS tipoListaPrecio, 
					@g_const_0 AS codRuta,
					@g_const_0 AS ordenAtencion,
					ERROR_NUMBER() AS codigo,
					ERROR_MESSAGE() AS mensaje


		END CATCH

	END	
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_listar_descuentos_fecha' AND type = 'P')
	DROP PROCEDURE pa_listar_descuentos_fecha
GO
----------------------------------------------------------------------------------
-- Author: Wilmer Sanchez IDE-SOLUTION
-- Created: 13/01/2020  
-- Sistema: ws_wa_DistribuidoraVDC
-- Descripci�n: Traer lista de descuentos por fecha 
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


IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_listar_detalle_flag_descuento' AND type = 'P')
	DROP PROCEDURE pa_listar_detalle_flag_descuento
GO
----------------------------------------------------------------------------------
-- Author: Wilmer Sanchez IDE-SOLUTION
-- Created: 13/01/2020  
-- Sistema: ws_wa_DistribuidoraVDC
-- Descripci�n: Traer lista detalle de descuentos 
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_listar_detalle_flag_descuento
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

			SELECT CONCAT(df.ntraDescuento,df.flag) AS ntra_flag,df.flag,df.descripcion,df.valorEntero1,df.valorEntero2,df.valorMoneda1,
			df.valorMoneda2,df.valorCadena1,df.valorCadena2,df.valorFecha1,df.valorFecha2,df.estado 
			, @g_const_2000 AS codigo
			, @g_const_msj as mensaje
			FROM tblDetalleDescuentos dp
			INNER JOIN tblDetalleFlagDescuento df ON (dp.ntraDescuento = df.ntraDescuento AND dp.flag = df.flag )
			WHERE dp.ntraDescuento = @p_ntra AND dp.flag = @p_flag AND dp.marcaBaja = @g_const_0 AND df.marcaBaja = @g_const_0 
 

			
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


IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_listar_detalle_flag_promocion' AND type = 'P')
	DROP PROCEDURE pa_listar_detalle_flag_promocion
GO
----------------------------------------------------------------------------------
-- Author: Wilmer Sanchez IDE-SOLUTION
-- Created: 13/01/2020  
-- Sistema: ws_wa_DistribuidoraVDC
-- Descripci�n: Traer lista detalle de promociones 
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



IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_listar_detalle_preventas' AND type = 'P')
	DROP PROCEDURE pa_listar_detalle_preventas
GO
----------------------------------------------------------------------------------
-- Author: Wilmer Sanchez IDE-SOLUTION
-- Created: 16/01/2020  
-- Sistema: ws_wa_DistribuidoraVDC
-- Descripci�n: Traer lista detalles de preventas
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_listar_detalle_preventas
(
	@p_codPrev INT -- numero de transaccion de usuario
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

			SELECT codPreventa,itemPreventa,codPresentacion,codProducto,codAlmacen,cantidadPresentacion,cantidadUnidadBase,precioVenta,TipoProducto
			, @g_const_2000 AS codigo
			, @g_const_msj as mensaje
			FROM tblDetallePreventa WHERE codPreventa = @p_codPrev AND marcaBaja = @g_const_0

		END TRY
		BEGIN CATCH
			SELECT
					@g_const_0 AS codPreventa, 
					@g_const_0 AS itemPreventa,  
					@g_const_0 AS codPresentacion, 
					@g_const_vacio AS codProducto, 
					@g_const_0 AS codAlmacen, 
					@g_const_0 AS cantidadPresentacion,
					@g_const_0 AS cantidadUnidadBase, 
					@g_const_0 AS precioVenta, 
					@g_const_0 AS TipoProducto, 
					ERROR_NUMBER() AS codigo,
					ERROR_MESSAGE() AS mensaje
					


		END CATCH

	END	
	
	
GO
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


GO

IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_listar_presentacion_productos_sinc' AND type = 'P')
	DROP PROCEDURE pa_listar_presentacion_productos_sinc
GO
----------------------------------------------------------------------------------
-- Author: Wilmer Sanchez IDE-SOLUTION
-- Created: 15/01/2020  
-- Sistema: ws_wa_DistribuidoraVDC
-- Descripci�n: Traer lista de presentaciones de producto
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_listar_presentacion_productos_sinc
AS
	BEGIN
		DECLARE @g_const_0 SMALLINT -- valor 0
		DECLARE @g_const_vacio CHAR(1) -- Constante vacio
		DECLARE @g_const_2000 SMALLINT -- Constante 2000
		DECLARE @g_const_msj VARCHAR(200) -- Mensaje
		DECLARE @g_const_espacio CHAR(1) -- espacio
		BEGIN TRY		
			
			SET @g_const_vacio = '';
			SET @g_const_0 = 0;
			SET @g_const_2000 = 2000
			SET @g_const_msj = 'Consulta exitosa'
			SET @g_const_espacio= ' '

			SET NOCOUNT ON;

			SELECT codProducto,codPresentancion,cantidadUnidadBase,@g_const_2000 AS codigo,@g_const_msj AS mensaje FROM tblDetallePresentacion 
			WHERE marcaBaja = @g_const_0 

		END TRY
		BEGIN CATCH
			SELECT
					@g_const_vacio AS codProducto, 
					@g_const_0 AS codPresentancion, 
					@g_const_0 AS cantidadUnidadBase, 
					ERROR_NUMBER() AS codigo,
					ERROR_MESSAGE() AS mensaje
					


		END CATCH

	END	
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_listar_preventa_descuentos' AND type = 'P')
	DROP PROCEDURE pa_listar_preventa_descuentos
GO
----------------------------------------------------------------------------------
-- Author: Wilmer Sanchez IDE-SOLUTION
-- Created: 16/01/2020  
-- Sistema: ws_wa_DistribuidoraVDC
-- Descripci�n: Traer lista descuentos de preventa
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_listar_preventa_descuentos
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

			SELECT codPreventa,codDescuento,itemPreventa,importe 
			, @g_const_2000 AS codigo
					, @g_const_msj as mensaje
			FROM tblPreventaDescuento WHERE codPreventa = @p_codPrev AND marcaBaja = @g_const_0


		END TRY
		BEGIN CATCH
			SELECT
					@g_const_0 AS codPreventa, 
					@g_const_0 AS codDescuento,  
					@g_const_0 AS itemPreventa, 
					@g_const_0 AS importe, 
					ERROR_NUMBER() AS codigo,
					ERROR_MESSAGE() AS mensaje
					


		END CATCH

	END	
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_listar_preventa_promociones' AND type = 'P')
	DROP PROCEDURE pa_listar_preventa_promociones
GO
----------------------------------------------------------------------------------
-- Author: Wilmer Sanchez IDE-SOLUTION
-- Created: 16/01/2020  
-- Sistema: ws_wa_DistribuidoraVDC
-- Descripci�n: Traer lista promociones de preventa
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


IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_listar_productos_sinc' AND type = 'P')
	DROP PROCEDURE pa_listar_productos_sinc
GO
----------------------------------------------------------------------------------
-- Author: Wilmer Sanchez IDE-SOLUTION
-- Created: 13/01/2020  
-- Sistema: ws_wa_DistribuidoraVDC
-- Descripción: Traer lista de inventarios
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_listar_productos_sinc	
AS
	BEGIN
		DECLARE @g_const_0 SMALLINT -- valor 0
		DECLARE @g_const_vacio CHAR(1) -- Constante vacio
		DECLARE @g_const_2000 SMALLINT -- Constante 2000
		DECLARE @g_const_msj VARCHAR(200) -- Mensaje
		DECLARE @g_const_espacio CHAR(1) -- espacio
		BEGIN TRY		
			
			SET @g_const_vacio = '';
			SET @g_const_0 = 0;
			SET @g_const_2000 = 2000
			SET @g_const_msj = 'Consulta exitosa'
			SET @g_const_espacio= ' '

			SET NOCOUNT ON;

			SELECT codProducto,descripcion,CONCAT(codProducto,@g_const_espacio ,descripcion) as cod_des,codCategoria,
			codUnidadBaseventa,tipoProducto,@g_const_2000 AS codigo,@g_const_msj AS mensaje  FROM tblProducto where marcaBaja = @g_const_0

		END TRY
		BEGIN CATCH
			SELECT
					@g_const_vacio AS codProducto, 
					@g_const_vacio AS descripcion, 
					@g_const_vacio AS cod_des, 
					@g_const_0 AS codCategoria, 
					@g_const_0 AS codUnidadBaseventa,
					@g_const_0 AS tipoProducto, 
					ERROR_NUMBER() AS codigo,
					ERROR_MESSAGE() AS mensaje
					


		END CATCH

	END	
GO




IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_listar_promociones_fecha' AND type = 'P')
	DROP PROCEDURE pa_listar_promociones_fecha
GO
----------------------------------------------------------------------------------
-- Author: Wilmer Sanchez IDE-SOLUTION
-- Created: 13/01/2020  
-- Sistema: ws_wa_DistribuidoraVDC
-- Descripci�n: Traer lista de promociones por fecha 
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

IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_listar_fabricante' AND type = 'P')
	DROP PROCEDURE pa_listar_fabricante
GO
----------------------------------------------------------------------------------
-- Author: Jose Chumioque IDE-SOLUTION
-- Created: 10/01/2020  
-- Sistema: Sistema de Preventas
-- Modulo: General
-- Descripci�n: Listar Fabricantes
-- Log Modificaciones: 
-- CODIGO    REQUERIMIENTO          NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_listar_fabricante	
AS
SET NOCOUNT ON
BEGIN
        DECLARE @g_const_0 INT -- valor 0	

BEGIN TRY      
           SET @g_const_0 = 0;
   BEGIN
	 SELECT ntraFabricante,descripcion
	 FROM tblFabricante WHERE marcaBaja = @g_const_0;
   END
END TRY
BEGIN CATCH
           SELECT   
	        ERROR_NUMBER() AS ErrorNumber  
	       ,ERROR_MESSAGE() AS ErrorMessage;
END CATCH
END

GO

IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_calcular_total_almacen' AND type = 'P')
	DROP PROCEDURE pa_calcular_total_almacen
GO
----------------------------------------------------------------------------------
-- Author: Jose Chumioque IDE-SOLUTION
-- Created: 12/02/2020  
-- Sistema: Sistema de Preventas
-- Modulo: General
-- Descripci�n: Calcular el monto de stock por almacen
-- Log Modificaciones: 
-- CODIGO    REQUERIMIENTO          NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[pa_calcular_total_almacen]	
(
@codArticulo  VARCHAR(10)
)
AS
SET NOCOUNT ON

BEGIN
        DECLARE @g_const_0 INT -- valor 0	

BEGIN TRY      
           SET @g_const_0 = 0;
  
   if len(trim(@codArticulo)) > 0 
    BEGIN
	select sum(COALESCE(stock,@g_const_0) )as TotalStock 
	from  tblProducto  pro left join tblInventario  inv
	on inv.codProducto = pro.codProducto and pro.marcaBaja = @g_const_0 and inv.marcaBaja=@g_const_0
	where pro.codProducto = trim(@codArticulo)
	
   END
END TRY
BEGIN CATCH
           SELECT   
	        ERROR_NUMBER() AS ErrorNumber  
	       ,ERROR_MESSAGE() AS ErrorMessage;
END CATCH
END
GO



IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_listar_proveedor' AND type = 'P')
	DROP PROCEDURE pa_listar_proveedor
GO
----------------------------------------------------------------------------------
-- Author: Jose Chumioque IDE-SOLUTION
-- Created: 10/01/2020  
-- Sistema: Sistema de Preventas
-- Modulo: General
-- Descripci�n: Listar Proveedores
-- Log Modificaciones: 
-- CODIGO    REQUERIMIENTO          NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_listar_proveedor	
AS
SET NOCOUNT ON

BEGIN
        DECLARE @g_const_0 INT -- valor 0	

BEGIN TRY      
           SET @g_const_0 = 0;
   BEGIN
	 SELECT ntraProveedor,descripcion
	 FROM tblProveedor WHERE marcaBaja = @g_const_0;
   END
END TRY
BEGIN CATCH
           SELECT   
	        ERROR_NUMBER() AS ErrorNumber  
	       ,ERROR_MESSAGE() AS ErrorMessage;
END CATCH
END
GO



IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_listar_subcategoria' AND type = 'P')
	DROP PROCEDURE pa_listar_subcategoria
GO
----------------------------------------------------------------------------------
-- Author: Jose Chumioque IDE-SOLUTION
-- Created: 06/01/2020  
-- Sistema: Sistema de Preventas
-- Modulo: General
-- Descripci�n: Listar subcategorias de Productos
-- Log Modificaciones: 
-- CODIGO    REQUERIMIENTO          NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_listar_subcategoria	
(
@codSubCategoria INT
)
AS
SET NOCOUNT ON

BEGIN
        DECLARE @g_const_0 INT -- valor 0	

BEGIN TRY      
           SET @g_const_0 = 0;
   BEGIN
	 SELECT ntraSubcategoria,descripcion
	 FROM tblSubcategoria WHERE codCategoria =@codSubCategoria AND  marcaBaja = @g_const_0;
   END
END TRY
BEGIN CATCH
           SELECT   
	        ERROR_NUMBER() AS ErrorNumber  
	       ,ERROR_MESSAGE() AS ErrorMessage;
END CATCH
END
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_obtener_codigo_almacen' AND type = 'P')
	DROP PROCEDURE pa_obtener_codigo_almacen
GO
----------------------------------------------------------------------------------
-- Author: Jose Chumioque IDE-SOLUTION
-- Created: 23/01/2020  
-- Sistema: Sistema de Preventas
-- Modulo: General
-- Descripci�n: Obtener el codigo de almacen
-- Log Modificaciones: 
-- CODIGO    REQUERIMIENTO          NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_obtener_codigo_almacen	
(
@descAlmacen  VARCHAR(100)
)
AS
SET NOCOUNT ON

BEGIN
        DECLARE @g_const_0 SMALLINT; -- valor 0
		DECLARE @g_const_1 SMALLINT;  --valor 1
		DECLARE @codigo INT; -- Codigo 
		DECLARE @mensaje VARCHAR(100); -- mensaje
		DECLARE @estado SMALLINT; -- 0:EXITO, 1:error interno
		DECLARE @ntralm INT;     --Codigo de almacen

BEGIN TRY      
           SET @g_const_0 = 0;
		   SET @g_const_1 = 1;
		   SET @estado = 0;
		   SET @mensaje = 'EXITO';
		   SET @ntralm = 0;
		   SET @codigo = 2000;
 
    select @ntralm = ntraAlmacen from tblAlmacen
    where upper(descripcion) = TRIM(@descAlmacen) and marcaBaja = @g_const_0;

   SELECT @ntralm as codAlmacen,@codigo as codigo,@estado as estado,@mensaje as mensaje
END TRY
BEGIN CATCH
            SET @codigo = 3000;
		    SET @estado = @g_const_1;
		    SET @mensaje = ERROR_MESSAGE();
			SET @ntralm = @g_const_0;
	SELECT @ntralm as codAlmacen,@codigo as codigo,@estado as estado,@mensaje as mensaje
END CATCH
END


GO
IF EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_registrar_modificar_cliente' AND type = 'P')
DROP PROCEDURE pa_registrar_modificar_cliente
GO
----------------------------------------------------------------------------------
-- Author: Alex Llamo IDE-SOLUTION
-- Created: 06/01/2020
-- Sistema: ws_wa_DistribuidoraVDC
-- Descripción: Registrar y modificar cliente
-- Log Modificaciones:
-- CODIGO NOMBRE FECHA MOTIVO
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_registrar_modificar_cliente
(
	@p_proceso TINYINT,						--proceso 1:registro 2:modificacion
	@p_codigo INTEGER,						--codigo de persona
	@p_tipoPersona TINYINT,					--tipo persona
	@p_tipoDocumento TINYINT,				--tipo documento
	@p_numDocumento VARCHAR(15),			--numero documento
	@p_ruc VARCHAR(15),						--ruc
	@p_razonSocial VARCHAR(50),				--razon social
	@p_nombres VARCHAR(30),					--nombres
	@p_apePaterno VARCHAR(20),				--apellido paterno
	@p_apeMaterno VARCHAR(20),				--apellido materno
	@p_direccion VARCHAR(100),				--direccion
	@p_correo VARCHAR(60),					--correo
	@p_telefono VARCHAR(15),				--telefono
	@p_celular CHAR(9),						--celular
	@p_ubigeo CHAR(6),						--ubigeo

	@p_ordenAtencion SMALLINT = NULL,		--orden tencion
	@p_perfilCliente TINYINT = NULL,		--perfil cliente
	@p_clasificacion TINYINT = NULL,		--clasificacion 
	@p_frecuencia TINYINT,					--frecuencia
	@p_tipoListaPrecio TINYINT,				--tipo lista precio
	@p_codRuta INT,							--codigo de ruta

	@p_coordenadaX VARCHAR(100),				--coordenadaX (latitud)
	@p_coordenadaY VARCHAR(100),				--coordenadaY (longitud)
	
	@p_usuario VARCHAR(20),					--usuario
	@p_ip VARCHAR(20),						--direccion ip
	@p_mac VARCHAR(20)						--mac
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @flag INT;			--flag de proceso
	DECLARE @msje VARCHAR(250);		--mensaje de error
	DECLARE @codPersona INT;		--codigo de persona
	DECLARE @codigo VARCHAR(10);	--codigo generado
	DECLARE @Upper INT;				--valor maximo para numero aleatorio
	DECLARE @Lower INT;				--valor minimo para numero aleatorio
	DECLARE @cont INT;				--contador
	DECLARE @bandera INT;			--bandera de proceso
	DECLARE @codPuntoEntrega INT;	--codigo punto de entrega

	SET @flag = 0;
	SET @msje = 'Exito';
	SET @codPersona = 0;
	SET @codigo = null;
	SET @Upper = 0;
	SET @Lower = 0;
	SET @cont = 0;
	SET @bandera = 0;
	SET @codPuntoEntrega = 0;

	BEGIN TRY
		IF(@p_proceso = 1)		--proceso registro
		BEGIN
			IF (@p_tipoPersona = 1 AND @p_tipoDocumento = 1)
			BEGIN
				SET @codPersona = @p_numDocumento;
			END
			ELSE
			BEGIN
				SET @bandera = 0
				WHILE(@bandera = 0)
				BEGIN
					SET @cont = 0
					--numero aleatorio del 0 al 999999
					SET @Lower = 0
					SET @Upper = 999999 
					SET @codigo = ROUND(((@Upper - @Lower -1) * RAND() + @Lower), 0)
					--completando para tener un numero con 6 digitos
					SET @codigo = SUBSTRING(REPLICATE('0', 6),1,6 - LEN(@codigo)) + @codigo
					--concatenamos 99 al numero generado
					SET @codigo = '99' + LTRIM(RTRIM(@codigo));
					--almacenamos el codigo en un entero para agilizar la busqueda
					SET @codPersona = @codigo
					--verificamos la existencia del codigo generado
					SELECT @cont = COUNT(codPersona) FROM tblPersona WHERE codPersona = @codPersona
					IF (@cont = 0) --codigo disponible
					BEGIN 
						SET @bandera = 1
					END
				END
			END
			BEGIN TRANSACTION
				INSERT INTO tblPersona (codPersona, tipoPersona, tipoDocumento, numeroDocumento, ruc, razonSocial, nombres, apellidoPaterno, 
				apellidoMaterno, direccion, correo, telefono, celular, codUbigeo, marcaBaja, usuario, ip, mac) 
				VALUES(@codPersona, @p_tipoPersona, @p_tipoDocumento, @p_numDocumento, @p_ruc, @p_razonSocial, @p_nombres, @p_apePaterno, @p_apeMaterno, 
				@p_direccion, @p_correo, @p_telefono, @p_celular, @p_ubigeo, 0, @p_usuario, @p_ip, @p_mac);

				INSERT INTO tblCliente(codPersona, ordenAtencion, perfilCliente, clasificacionCliente, frecuenciaCliente, tipoListaPrecio, codRuta, marcaBaja, 
				usuario, ip, mac)
				VALUES (@codPersona, @p_ordenAtencion, @p_perfilCliente, @p_clasificacion, @p_frecuencia, @p_tipoListaPrecio, @p_codRuta, 0,
				@p_usuario, @p_ip, @p_mac);

				--#
					INSERT INTO tblLocalizacion(codPersona,coordenadaX,coordenadaY,marcaBaja,usuario,ip,mac) 
					VALUES(@codPersona,@p_coordenadaX,@p_coordenadaY,0, @p_usuario, @p_ip, @p_mac);
				--#

				SET @cont = 0;
				SELECT @cont = COUNT(codPersona) FROM tblPuntoEntrega WHERE codPersona = @codPersona
				IF (@cont = 0)
				BEGIN 
					INSERT INTO tblPuntoEntrega (coordenadaX, coordenadaY, codUbigeo, direccion, referencia, ordenEntrega, codPersona, usuario, ip, mac)
					VALUES(@p_coordenadaX,@p_coordenadaY, @p_ubigeo, @p_direccion, null, null, @codPersona, @p_usuario, @p_ip, @p_mac);

					SET @codPuntoEntrega = (SELECT @@IDENTITY);
				END

			COMMIT TRANSACTION
		END
		ELSE
		BEGIN
			IF(@p_proceso = 2) --proceso modificacion
			BEGIN
				BEGIN TRANSACTION
					UPDATE tblPersona SET razonSocial = @p_razonSocial, nombres = @p_nombres, apellidoPaterno = @p_apePaterno, apellidoMaterno = @p_apeMaterno, direccion = @p_direccion, correo = @p_correo, telefono = @p_telefono, celular = @p_celular
					WHERE codPersona = @p_codigo AND marcaBaja = 0;
					
					UPDATE tblCliente SET ordenAtencion = @p_ordenAtencion, perfilCliente = @p_perfilCliente, clasificacionCliente = @p_clasificacion,
					frecuenciaCliente = @p_frecuencia, tipoListaPrecio = @p_tipoListaPrecio, codRuta = @p_codRuta
					WHERE codPersona = @p_codigo AND marcaBaja = 0;
					
					UPDATE tblLocalizacion SET coordenadaX = @p_coordenadaX, coordenadaY = @p_coordenadaY
					WHERE codPersona = @p_codigo AND marcaBaja = 0;
				COMMIT TRANSACTION
			END
		END

		SELECT @flag as flag , @msje as msje, @codPersona as codPersona, @codPuntoEntrega as codPuntoEntrega
	END TRY
	BEGIN CATCH
		IF (XACT_STATE()) <> 0 
		BEGIN
			ROLLBACK TRANSACTION
		END
		SET @flag = ERROR_NUMBER();
		SET @msje = 'Error en pa_registrar_modificar_cliente ' + ERROR_MESSAGE();
		SET @codPersona = 0;
		SET @codPuntoEntrega = 0;
		SELECT @flag as flag , @msje as msje, @codPersona as codPersona, @codPuntoEntrega as codPuntoEntrega
	END CATCH
END
GO


IF EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_registrar_modificar_preventa' AND type = 'P')
DROP PROCEDURE pa_registrar_modificar_preventa
GO
----------------------------------------------------------------------------------
-- Author: Alex Llamo IDE-SOLUTION
-- Created: 30/01/2020
-- Sistema: ws_wa_DistribuidoraVDC
-- Descripcion: Registrar y modificar preventa
-- Log Modificaciones:
-- CODIGO NOMBRE FECHA MOTIVO
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_registrar_modificar_preventa
(
	@p_proceso TINYINT,				--proceso 1:registro 2:modificacion
	@p_ntraPreventa INT,			--ntra preventa
	@p_codCliente INT,				--codigo cliente
	@p_codUsuario INT,				--codigo de usuario
	@p_codPuntoEntrega INT,			--codigo punto de entrega
	@p_tipoMoneda TINYINT,			--moneda
	@p_tipoVenta TINYINT,			--tipo de venta
	@p_tipoDocumentoVenta TINYINT,	--tipo documento venta
	@p_fecha DATE,			--fecha
	@p_fechaEntrega DATE,	--fecha entrega
	@p_fechaPago DATE,		--fecha pago
	@p_flagRecargo TINYINT,			--flag recargo
	@p_recargo MONEY,				--recargo
	@p_igv MONEY,					--igv
	@p_isc MONEY,					--isc
	@p_total MONEY,					--total
	@p_estado TINYINT,				--estado
	@p_origenVenta TINYINT,			--origen venta
	@p_listaDetalles XML,			--lista de detalle de preventa
	@p_listaPreventaPromocion XML = NULL,			--lista preventa promocion
	@p_listaPreventaDescuento XML = NULL,			--lista preventa descuento
	@p_usuario VARCHAR(20),					--usuario
	@p_ip VARCHAR(20),						--direccion ip
	@p_mac VARCHAR(20),						--mac
	@p_horaEntrega TIME(0),				--horaEntrega
	@p_codSucursal INT						--codSucursal
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @flag INT;						--flag de proceso
	DECLARE @msje VARCHAR(250);				--mensaje de error
	DECLARE @ntra INT;						--numero de transaccion
	DECLARE @itemPreventa TINYINT;			--item preventa
	DECLARE @codPresentacion INT;			--codigo presentacion
	DECLARE @codProducto VARCHAR(20);		--codigo producto
	DECLARE @codAlmacen INT;				--codigo almacen
	DECLARE @cantidadPresentacion INT;		--cantidad presentacion
	DECLARE @cantidadUnidadBase INT;		--cantidad unidad base
	DECLARE @precioVenta MONEY;				--precio venta
	DECLARE @tipoProducto TINYINT;			--tipo producto
	
	DECLARE @codPromocion INT;				--codigo de promocion
	DECLARE @itemPromocionado TINYINT;		--item promocionado
	DECLARE @codDescuento INT;				--codigo de descuento
	DECLARE @importe MONEY;					--importe

	SET @flag = 0;
	SET @msje = 'Exito';
	SET @ntra = 0;
	SET @itemPreventa = 0;
	SET @codPresentacion = 0;
	SET @codProducto = '';
	SET @codAlmacen = 0;
	SET @cantidadPresentacion = 0;
	SET @cantidadUnidadBase = 0;
	SET @precioVenta = 0;
	SET @tipoProducto = 0;
	
	SET @codPromocion = 0;
	SET @itemPromocionado = 0;
	SET @codDescuento = 0;
	SET @importe = 0;

	BEGIN TRY
		IF(@p_proceso = 1)		--proceso registro
		BEGIN
			BEGIN TRANSACTION
				INSERT INTO tblPreventa(codCliente, codUsuario, codPuntoEntrega, tipoMoneda, tipoVenta, tipoDocumentoVenta, 
				fecha, fechaEntrega, fechaPago, flagRecargo, recargo, igv, isc, total, estado, marcaBaja, usuario, ip, mac, 
				origenVenta, horaEntrega, codSucursal)
				VALUES (@p_codCliente, @p_codUsuario, @p_codPuntoEntrega, @p_tipoMoneda, @p_tipoVenta, @p_tipoDocumentoVenta, 
				@p_fecha, @p_fechaEntrega, null, @p_flagRecargo, @p_recargo, @p_igv, @p_isc, @p_total, @p_estado, 0, @p_usuario, 
				@p_ip, @p_mac, @p_origenVenta, @p_horaEntrega, @p_codSucursal);
				

				SET @ntra = (SELECT @@IDENTITY);

				DECLARE cur_detalle CURSOR LOCAL STATIC READ_ONLY FORWARD_ONLY FOR 
				SELECT cast(colx.query('data(itemPreventa)') as varchar), cast(colx.query('data(codPresentacion)') as varchar), 
				cast(colx.query('data(codProducto)') as varchar), cast(colx.query('data(codAlmacen)') as varchar), 
				cast(colx.query('data(cantidadPresentacion)') as varchar), cast(colx.query('data(cantidadUnidadBase)') as varchar), 
				cast(colx.query('data(precioVenta)') as varchar), cast(colx.query('data(TipoProducto)') as varchar) 
				FROM @p_listaDetalles.nodes('ArrayOfCEN_Detalle_Preventa/CEN_Detalle_Preventa') AS Tabx(Colx)              
				OPEN cur_detalle;  
				FETCH NEXT FROM cur_detalle INTO @itemPreventa, @codPresentacion, @codProducto, @codAlmacen,
				@cantidadPresentacion, @cantidadUnidadBase, @precioVenta, @tipoProducto;
				WHILE @@FETCH_STATUS = 0
					BEGIN
						INSERT INTO tblDetallePreventa( codPreventa, itemPreventa, codPresentacion, codProducto, codAlmacen,
						cantidadPresentacion, cantidadUnidadBase, precioVenta, TipoProducto, marcaBaja, usuario, ip, mac)
						VALUES( @ntra, @itemPreventa, @codPresentacion, @codProducto, @codAlmacen, @cantidadPresentacion,
						@cantidadUnidadBase, @precioVenta, @tipoProducto, 0, @p_usuario, @p_ip, @p_mac);
						
						--Disminuir stock
						UPDATE tblInventario SET stock = stock - @cantidadUnidadBase 
						WHERE codAlmacen = @codAlmacen AND codProducto = @codProducto AND marcaBaja = 0;

						FETCH NEXT FROM cur_detalle INTO @itemPreventa, @codPresentacion, @codProducto, @codAlmacen,
				@cantidadPresentacion, @cantidadUnidadBase, @precioVenta, @tipoProducto;
					END
				CLOSE cur_detalle;  
				DEALLOCATE cur_detalle;

				--Preventa Promocion
				SET @itemPreventa = 0;
				
				IF(NOT @p_listaPreventaPromocion IS NULL)
				BEGIN
					DECLARE cur_promocion CURSOR LOCAL STATIC READ_ONLY FORWARD_ONLY FOR 
					SELECT cast(colx.query('data(codPromocion)') as varchar), cast(colx.query('data(itemPreventa)') as varchar), 
					cast(colx.query('data(itemPromocionado)') as varchar)
					FROM @p_listaPreventaPromocion.nodes('ArrayOfCEN_Preventa_Promocion/CEN_Preventa_Promocion') AS Tabx(Colx)              
					OPEN cur_promocion;  
					FETCH NEXT FROM cur_promocion INTO @codPromocion, @itemPreventa, @itemPromocionado
					WHILE @@FETCH_STATUS = 0
						BEGIN
							INSERT INTO tblPreventaPromocion(codPreventa, codPromocion, itemPreventa, itemPromocionado, usuario, ip, mac)
							VALUES( @ntra, @codPromocion, @itemPreventa, @itemPromocionado, @p_usuario, @p_ip, @p_mac);
						
							FETCH NEXT FROM cur_promocion INTO @codPromocion, @itemPreventa, @itemPromocionado;
						END
					CLOSE cur_promocion;  
					DEALLOCATE cur_promocion;
				END
				
				--Preventa Descuento
				SET @itemPreventa = 0;
				
				IF(NOT @p_listaPreventaDescuento IS NULL)
				BEGIN
					DECLARE cur_descuento CURSOR LOCAL STATIC READ_ONLY FORWARD_ONLY FOR 
					SELECT cast(colx.query('data(codDescuento)') as varchar), cast(colx.query('data(itemPreventa)') as varchar),
					cast(colx.query('data(importe)') as varchar)
					FROM @p_listaPreventaDescuento.nodes('ArrayOfCEN_Preventa_Descuento/CEN_Preventa_Descuento') AS Tabx(Colx)

					OPEN cur_descuento;  
					FETCH NEXT FROM cur_descuento INTO @codDescuento, @itemPreventa, @importe
					WHILE @@FETCH_STATUS = 0
						BEGIN
							INSERT INTO tblPreventaDescuento(codPreventa, codDescuento, itemPreventa, importe, usuario, ip, mac)
							VALUES( @ntra, @codDescuento, @itemPreventa, @importe, @p_usuario, @p_ip, @p_mac);
						
							FETCH NEXT FROM cur_descuento INTO  @codDescuento, @itemPreventa, @importe;
						END
					CLOSE cur_descuento;  
					DEALLOCATE cur_descuento;
				END
				

			COMMIT TRANSACTION
		END
		ELSE
		BEGIN
			IF(@p_proceso = 2) --proceso modificacion
			BEGIN
				BEGIN TRANSACTION
					--ACTUALIZAR PREVENTA
					UPDATE tblPreventa SET tipoVenta = @p_tipoVenta, tipoDocumentoVenta = @p_tipoDocumentoVenta,
					flagRecargo = @p_flagRecargo, recargo = @p_recargo, fechaEntrega = @p_fechaEntrega,
					igv = @p_igv, total = @p_total, codPuntoEntrega = @p_codPuntoEntrega, horaEntrega = @p_horaEntrega
					WHERE ntraPreventa = @p_ntraPreventa;

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

					--DAR BAJA A DETALLES, PREVENTA PROMOCION Y PREVENTA DESCUENTO
					DELETE FROM tblPreventaPromocion WHERE codPreventa = @p_ntraPreventa AND marcaBaja = 0;
					DELETE FROM tblPreventaDescuento WHERE codPreventa = @p_ntraPreventa AND marcaBaja = 0;
					DELETE FROM tblDetallePreventa WHERE codPreventa = @p_ntraPreventa AND marcaBaja = 0;
					/*UPDATE tblDetallePreventa SET marcaBaja = 9 WHERE codPreventa = @p_ntraPreventa AND marcaBaja = 0;
					UPDATE tblPreventaPromocion SET marcaBaja = 9 WHERE codPreventa = @p_ntraPreventa AND marcaBaja = 0;
					UPDATE tblPreventaDescuento SET marcaBaja = 9 WHERE codPreventa = @p_ntraPreventa AND marcaBaja = 0;*/

					--DETALLES
					SET @cantidadUnidadBase = 0;
					SET @codAlmacen = 0;
					SET @codProducto = 0;
					DECLARE cur_detalle CURSOR LOCAL STATIC READ_ONLY FORWARD_ONLY FOR 
					SELECT cast(colx.query('data(itemPreventa)') as varchar), cast(colx.query('data(codPresentacion)') as varchar), 
					cast(colx.query('data(codProducto)') as varchar), cast(colx.query('data(codAlmacen)') as varchar), 
					cast(colx.query('data(cantidadPresentacion)') as varchar), cast(colx.query('data(cantidadUnidadBase)') as varchar), 
					cast(colx.query('data(precioVenta)') as varchar), cast(colx.query('data(TipoProducto)') as varchar) 
					FROM @p_listaDetalles.nodes('ArrayOfCEN_Detalle_Preventa/CEN_Detalle_Preventa') AS Tabx(Colx)              
					OPEN cur_detalle;  
					FETCH NEXT FROM cur_detalle INTO @itemPreventa, @codPresentacion, @codProducto, @codAlmacen,
					@cantidadPresentacion, @cantidadUnidadBase, @precioVenta, @tipoProducto;
					WHILE @@FETCH_STATUS = 0
						BEGIN
							INSERT INTO tblDetallePreventa( codPreventa, itemPreventa, codPresentacion, codProducto, codAlmacen,
							cantidadPresentacion, cantidadUnidadBase, precioVenta, TipoProducto, marcaBaja, usuario, ip, mac)
							VALUES( @p_ntraPreventa, @itemPreventa, @codPresentacion, @codProducto, @codAlmacen, @cantidadPresentacion,
							@cantidadUnidadBase, @precioVenta, @tipoProducto, 0, @p_usuario, @p_ip, @p_mac);
						
							--DISMINUIR STOCK
							UPDATE tblInventario SET stock = stock - @cantidadUnidadBase 
							WHERE codAlmacen = @codAlmacen AND codProducto = @codProducto AND marcaBaja = 0;

							FETCH NEXT FROM cur_detalle INTO @itemPreventa, @codPresentacion, @codProducto, @codAlmacen,
						@cantidadPresentacion, @cantidadUnidadBase, @precioVenta, @tipoProducto;
						END
					CLOSE cur_detalle;  
					DEALLOCATE cur_detalle;

					--PREVENTA PROMOCION
					SET @itemPreventa = 0;
					IF(NOT @p_listaPreventaPromocion IS NULL)
					BEGIN
						DECLARE cur_promocion CURSOR LOCAL STATIC READ_ONLY FORWARD_ONLY FOR 
						SELECT cast(colx.query('data(codPromocion)') as varchar), cast(colx.query('data(itemPreventa)') as varchar), 
						cast(colx.query('data(itemPromocionado)') as varchar)
						FROM @p_listaPreventaPromocion.nodes('ArrayOfCEN_Preventa_Promocion/CEN_Preventa_Promocion') AS Tabx(Colx)              
						OPEN cur_promocion;  
						FETCH NEXT FROM cur_promocion INTO @codPromocion, @itemPreventa, @itemPromocionado
						WHILE @@FETCH_STATUS = 0
							BEGIN
								INSERT INTO tblPreventaPromocion(codPreventa, codPromocion, itemPreventa, itemPromocionado, usuario, ip, mac)
								VALUES( @p_ntraPreventa, @codPromocion, @itemPreventa, @itemPromocionado, @p_usuario, @p_ip, @p_mac);
						
								FETCH NEXT FROM cur_promocion INTO @codPromocion, @itemPreventa, @itemPromocionado;
							END
						CLOSE cur_promocion;  
						DEALLOCATE cur_promocion;
					END

					--PREVENTA DESCUENTO
					SET @itemPreventa = 0;
					IF(NOT @p_listaPreventaDescuento IS NULL)
					BEGIN
						DECLARE cur_descuento CURSOR LOCAL STATIC READ_ONLY FORWARD_ONLY FOR 
						SELECT cast(colx.query('data(codDescuento)') as varchar), cast(colx.query('data(itemPreventa)') as varchar),
						cast(colx.query('data(importe)') as varchar)
						FROM @p_listaPreventaDescuento.nodes('ArrayOfCEN_Preventa_Descuento/CEN_Preventa_Descuento') AS Tabx(Colx)

						OPEN cur_descuento;  
						FETCH NEXT FROM cur_descuento INTO @codDescuento, @itemPreventa, @importe
						WHILE @@FETCH_STATUS = 0
							BEGIN
								INSERT INTO tblPreventaDescuento(codPreventa, codDescuento, itemPreventa, importe, usuario, ip, mac)
								VALUES( @p_ntraPreventa, @codDescuento, @itemPreventa, @importe, @p_usuario, @p_ip, @p_mac);
						
								FETCH NEXT FROM cur_descuento INTO  @codDescuento, @itemPreventa, @importe;
							END
						CLOSE cur_descuento;  
						DEALLOCATE cur_descuento;
					END

					SET @ntra = @p_ntraPreventa;
				COMMIT TRANSACTION
			END
		END

		SELECT @flag as flag , @msje as msje, @ntra as ntraPreventa
	END TRY
	BEGIN CATCH
		IF (XACT_STATE()) <> 0 
		BEGIN
			ROLLBACK TRANSACTION
		END
		SET @flag = ERROR_NUMBER();
		SET @msje = 'Error en pa_registrar_modificar_preventa ' + ERROR_MESSAGE();
		SELECT @flag as flag , @msje as msje, @ntra as ntraPreventa
	END CATCH
END
GO


IF EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_registrar_modificar_punto_entrega_sinc' AND type = 'P')
DROP PROCEDURE pa_registrar_modificar_punto_entrega_sinc
GO
----------------------------------------------------------------------------------
-- Author: Alex Llamo IDE-SOLUTION
-- Created: 30/01/2020
-- Sistema: ws_wa_DistribuidoraVDC
-- Descripci�n: Registrar y modificar punto de entrega
-- Log Modificaciones:
-- CODIGO NOMBRE FECHA MOTIVO
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_registrar_modificar_punto_entrega_sinc
(
@p_proceso TINYINT, --proceso 1:registro 2:modificacion
@p_coordenadaX VARCHAR(100), --coordenada x
@p_coordenadaY VARCHAR(100), --coordenada y
@p_codUbigeo CHAR(6), --codigo de ubigeo
@p_direccion VARCHAR(200), --codigo punto de entrega
@p_referencia VARCHAR(200), --referencia
@p_ordenEntrega SMALLINT, --orden entrega
@p_codPersona INT, --codigo persona
@p_usuario VARCHAR(20), --usuario
@p_ip VARCHAR(20), --direccion ip
@p_mac VARCHAR(20) --mac
)
AS
BEGIN
SET NOCOUNT ON;
DECLARE @flag INT; --flag de proceso
DECLARE @msje VARCHAR(250); --mensaje de error
DECLARE @ntra INT; --numero de transaccion

SET @flag = 0;
SET @msje = 'Exito';
SET @ntra = 0;

BEGIN TRY
IF(@p_proceso = 1) --proceso registro
BEGIN
BEGIN TRANSACTION
INSERT INTO tblPuntoEntrega (coordenadaX, coordenadaY, codUbigeo, direccion, referencia, ordenEntrega,
codPersona, marcaBaja, usuario, ip, mac)
VALUES(@p_coordenadaX, @p_coordenadaY, @p_codUbigeo, @p_direccion, @p_referencia, @p_ordenEntrega,
@p_codPersona, 0, @p_usuario, @p_ip, @p_mac)

SET @ntra = (SELECT @@IDENTITY)
COMMIT TRANSACTION
END
ELSE
BEGIN
IF(@p_proceso = 2) --proceso modificacion
BEGIN
BEGIN TRANSACTION
SET @ntra = 0;
COMMIT TRANSACTION
END
END

SELECT @flag as flag , @msje as msje, @ntra as ntraPuntoEntrega
END TRY
BEGIN CATCH
IF (XACT_STATE()) <> 0
BEGIN
ROLLBACK TRANSACTION
END
SET @flag = ERROR_NUMBER();
SET @msje = 'Error en pa_registrar_modificar_punto_entrega ' + ERROR_MESSAGE();
SELECT @flag as flag , @msje as msje, @ntra as ntraPuntoEntrega
END CATCH
END
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_listar_preventas_vendedor' AND type = 'P')
	DROP PROCEDURE pa_listar_preventas_vendedor
GO
----------------------------------------------------------------------------------
-- Author: Wilmer Sanchez IDE-SOLUTION
-- Created: 16/01/2020  
-- Sistema: ws_wa_DistribuidoraVDC
-- Descripci?n: Traer lista de preventas por vendedor
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_listar_preventas_vendedor
(
	@p_codUsu INT, -- numero de transaccion de usuario
	@p_fech DATE -- fecha filtro de inicio
)		
AS
	BEGIN
		DECLARE @g_const_0 SMALLINT -- valor 0
		DECLARE @g_const_vacio CHAR(1) -- Constante vacio
		DECLARE @g_const_2000 SMALLINT -- Constante 2000
		DECLARE @g_const_msj VARCHAR(200) -- Mensaje
			
			SET @g_const_vacio = '';
			SET @g_const_0 = 0;
			SET @g_const_2000 = 2000
			SET @g_const_msj = 'Consulta exitosa'

			SET NOCOUNT ON;

			SELECT  ntraPreventa,codCliente,codUsuario,codPuntoEntrega,tipoMoneda,tipoVenta,tipoDocumentoVenta,fecha,fechaEntrega,fechaPago
			,recargo,igv,isc,estado,total
			,(CASE   
			      WHEN (tblPersona.tipoPersona) = 2 THEN tblPersona.ruc ELSE tblPersona.numeroDocumento
			   END ) AS numeroDocumento,tblPersona.tipoPersona as 'tipoDocumento',
			   origenVenta,horaEntrega,codSucursal,flagRecargo
			, @g_const_2000 AS codigo
			, @g_const_msj as mensaje
			FROM tblPreventa LEFT JOIN tblPersona on tblPersona.codPersona = tblPreventa.codCliente
			
			where codUsuario= @p_codUsu AND fecha >= @p_fech  AND tblPreventa.marcaBaja = @g_const_0

	END	
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_listar_puntos_entregas' AND type = 'P')
	DROP PROCEDURE pa_listar_puntos_entregas
GO
----------------------------------------------------------------------------------
-- Author: Wilmer Sanchez IDE-SOLUTION
-- Created: 13/01/2020  
-- Sistema: ws_wa_DistribuidoraVDC
-- Descripci?n: Traer lista puntos de entrega 
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_listar_puntos_entregas	
AS
	BEGIN
		DECLARE @g_const_0 SMALLINT -- valor 0
		DECLARE @g_const_2 SMALLINT -- valor 2
		DECLARE @g_const_vacio CHAR(1) -- Constante vacio
		DECLARE @g_const_2000 SMALLINT -- Constante 2000
		DECLARE @g_const_msj VARCHAR(200) -- Mensaje
		BEGIN TRY		
			
			SET @g_const_vacio = '';
			SET @g_const_0 = 0;
			SET @g_const_2 = 2;
			SET @g_const_2000 = 2000
			SET @g_const_msj = 'Consulta exitosa'

			SET NOCOUNT ON;
			
			

			 SELECT ntraPuntoEntrega,coordenadaX,coordenadaY,tblPuntoEntrega.direccion,referencia,
			 ordenEntrega,tblPuntoEntrega.codPersona
			 ,(CASE   
			      WHEN (tblPersona.tipoPersona) = @g_const_2 THEN tblPersona.ruc ELSE tblPersona.numeroDocumento
			   END ) AS numeroDocumento,tblPersona.tipoPersona as 'tipoDocumento'
			, @g_const_2000 AS codigo
			, @g_const_msj as mensaje 
						FROM tblPuntoEntrega INNER JOIN tblPersona 
						ON tblPuntoEntrega.codPersona = tblPersona.codPersona
						where tblPuntoEntrega.marcaBaja =@g_const_0  
			
			
		END TRY
		BEGIN CATCH
			SELECT
					@g_const_0 AS ntraPuntoEntrega, 
					@g_const_vacio AS coordenadaX, 
					@g_const_vacio AS coordenadaY, 
					@g_const_vacio AS direccion,
					@g_const_vacio AS referencia,
					@g_const_0 AS ordenEntrega, 
					@g_const_0 AS codPersona, 
					@g_const_vacio AS numeroDocumento, 
					@g_const_0 AS tipoDocumento, 
					ERROR_NUMBER() AS codigo,
					ERROR_MESSAGE() AS mensaje
		END CATCH

	END	
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_listar_parametro_sinc' AND type = 'P')
	DROP PROCEDURE pa_listar_parametro_sinc
GO
----------------------------------------------------------------------------------
-- Author: Wilmer Sanchez IDE-SOLUTION
-- Created: 06/02/2020  
-- Sistema: ws_wa_DistribuidoraVDC
-- Descripci�n: Traer lista de parametros
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_listar_parametro_sinc		
AS
	BEGIN
		DECLARE @g_const_0 SMALLINT -- valor 0
		
		SET @g_const_0 = 0

		SET NOCOUNT ON;  
		SELECT  codParametro, tipo, valorEntero1, valorEntero2, valorCaneda1, valorCaneda2, valorMoneda1, 
						valorMoneda2, valorFloat1, valorFloat2, valorFecha1, valorFecha2
		FROM tblDetalleParametro where marcaBaja = @g_const_0

	END	
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_listar_inventario_sinc' AND type = 'P')
	DROP PROCEDURE pa_listar_inventario_sinc
GO
----------------------------------------------------------------------------------
-- Author: Wilmer Sanchez IDE-SOLUTION
-- Created: 13/01/2020  
-- Sistema: ws_wa_DistribuidoraVDC
-- Descripci�n: Traer lista de inventarios
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_listar_inventario_sinc	
AS
	BEGIN
		DECLARE @g_const_0 SMALLINT -- valor 0
		DECLARE @g_const_vacio CHAR(1) -- Constante vacio
		DECLARE @g_const_2000 SMALLINT -- Constante 2000
		DECLARE @g_const_msj VARCHAR(200) -- Mensaje
		DECLARE @g_const_almacen CHAR(5) -- Almacen principal
		BEGIN TRY		
			
			SET @g_const_vacio = '';
			SET @g_const_0 = 0;
			SET @g_const_2000 = 2000
			SET @g_const_msj = 'Consulta exitosa'
			SET @g_const_almacen = 'ALMP'
			SET NOCOUNT ON;

			SELECT ntraInventario,codAlmacen,codProducto,stock,@g_const_2000 as codigo,@g_const_msj as mensaje FROM tblInventario 
			INNER JOIN tblAlmacen ON tblInventario.codAlmacen = tblAlmacen.ntraAlmacen
			where tblInventario.marcaBaja = @g_const_0 AND tblAlmacen.abreviatura = @g_const_almacen

			
		END TRY
		BEGIN CATCH
			SELECT
					@g_const_0 AS ntraInventario, 
					@g_const_0 AS codAlmacen, 
					@g_const_vacio AS codProducto, 
					@g_const_0 AS stock, 
					ERROR_NUMBER() AS codigo,
					ERROR_MESSAGE() AS mensaje
					


		END CATCH

	END	
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_listar_conceptos_sinc' AND type = 'P')
	DROP PROCEDURE pa_listar_conceptos_sinc
GO
----------------------------------------------------------------------------------
-- Author: Wilmer Sanchez IDE-SOLUTION
-- Created: 13/01/2020  
-- Sistema: ws_wa_DistribuidoraVDC
-- Descripci�n: Traer lista de conceptos
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_listar_conceptos_sinc		
AS
	BEGIN
		DECLARE @g_const_0 SMALLINT -- valor 0
		
		BEGIN TRY		
			SET @g_const_0 = 0

			SET NOCOUNT ON;  
			SELECT codConcepto,correlativo,descripcion FROM tblConcepto WHERE marcaBaja =  @g_const_0 AND correlativo > @g_const_0
			
		END TRY
		BEGIN CATCH
			SELECT 
			@g_const_0 as codConcepto ,
			ERROR_NUMBER() AS correlativo,
			ERROR_MESSAGE() AS descripcion;  


		END CATCH

	END	
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_listar_precios_sinc' AND type = 'P')
	DROP PROCEDURE pa_listar_precios_sinc
GO
----------------------------------------------------------------------------------
-- Author: Wilmer Sanchez IDE-SOLUTION
-- Created: 13/01/2020  
-- Sistema: ws_wa_DistribuidoraVDC
-- Descripci�n: Traer lista de precios
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_listar_precios_sinc		
AS
	BEGIN
		DECLARE @g_const_0 SMALLINT -- valor 0
		DECLARE @g_const_7 SMALLINT -- valor 7
		DECLARE @g_const_vacio CHAR(1) -- Constante vacio
		DECLARE @g_const_2000 SMALLINT -- Constante 2000
		DECLARE @g_const_msj VARCHAR(200) -- Mensaje
		
		BEGIN TRY		
			SET @g_const_0 = 0
			SET @g_const_7 = 7
			SET @g_const_2000 = 2000
			SET @g_const_msj = 'Consulta exitosa'
			SET @g_const_vacio = '';

			SET NOCOUNT ON;  
			SELECT ntraPrecio,codProducto,tipoListaPrecio,precioVenta,descripcion 
			, @g_const_2000 AS codigo
			,@g_const_msj as mensaje
			FROM tblPrecio 
			INNER JOIN tblConcepto ON tblPrecio.tipoListaPrecio = tblConcepto.correlativo
			WHERE tblConcepto.codConcepto = @g_const_7 and tblPrecio.marcaBaja = @g_const_0
			
		END TRY
		BEGIN CATCH
			SELECT 
			@g_const_0 as ntraPrecio ,
			@g_const_vacio as codProducto,
			@g_const_0 as tipoListaPrecio,
			@g_const_0 as precioVenta,
			@g_const_vacio as descripcion,
			ERROR_NUMBER() AS correlativo,
			ERROR_MESSAGE() AS descripcion;  


		END CATCH

	END	
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_lista_rutas_vendedor_sinc' AND type = 'P')
	DROP PROCEDURE pa_lista_rutas_vendedor_sinc
GO
----------------------------------------------------------------------------------
-- Author: Wilmer Sanchez IDE-SOLUTION
-- Created: 16/01/2020  
-- Sistema: ws_wa_DistribuidoraVDC
-- Descripci�n: Traer lista de rutas de vendedor
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


IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_listar_categorias' AND type = 'P')
	DROP PROCEDURE pa_listar_categorias
GO
----------------------------------------------------------------------------------
-- Author: Wilmer Sanchez IDE-SOLUTION
-- Created: 03/01/2020  
-- Sistema: ws_wa_DistribuidoraVDC
-- Descripci�n: Traer lista de categorias
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_listar_categorias		
AS
	BEGIN
		DECLARE @g_const_0 SMALLINT -- valor 0
		
		BEGIN TRY		
			SET @g_const_0 = 0

			SET NOCOUNT ON;  
			SELECT ntraCategoria,descripcion FROM tblCategoria WHERE marcaBaja = @g_const_0 ORDER BY ntraCategoria 
			
		END TRY
		BEGIN CATCH
			SELECT   
	        ERROR_NUMBER() AS ErrorNumber  
	       ,ERROR_MESSAGE() AS ErrorMessage;  

		END CATCH

	END	
GO



IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_listar_rutas_asignadas_x_vendedor' AND type = 'P')
	DROP PROCEDURE pa_listar_rutas_asignadas_x_vendedor
GO
----------------------------------------------------------------------------------
-- Author: WilSON IDE-SOLUTION
-- Created: 13/01/2020  
-- Sistema: ws_wa_DistribuidoraVDC
-- Descripci�n: Listar rutas asignadas
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[pa_listar_rutas_asignadas_x_vendedor]   
    @codUsuario integer

	
AS   
BEGIN
    
	SELECT * FROM v_listar_rutas_asignadas_x_vendedor
	WHERE ntraUsuario =  @codUsuario
	ORDER BY ORDEN ASC

END
GO



IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_ordenar_rutas_asignadas' AND type = 'P')
	DROP PROCEDURE pa_ordenar_rutas_asignadas
GO
----------------------------------------------------------------------------------
-- Author: WilSON IDE-SOLUTION
-- Created: 13/01/2020  
-- Sistema: ws_wa_DistribuidoraVDC
-- Descripci�n: Ordenar rutas asignadas
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].pa_ordenar_rutas_asignadas
(
	@codUsuario INT,
	@codRuta INT,
	@codOrden INT,
	@resultado INT OUTPUT
)

AS
	BEGIN	  
BEGIN TRY
		UPDATE tblRutasAsignadas SET codOrden = @codOrden WHERE codUsuario = @codUsuario and codRuta = @codRuta
		SELECT @resultado = 0
END TRY
BEGIN CATCH
		SELECT @resultado = 0
		SELECT  
			ERROR_NUMBER() AS NumeroDeError   
            ,ERROR_STATE() AS NumeroDeEstado    
            ,ERROR_LINE() AS  NumeroDeLinea  
            ,ERROR_MESSAGE() AS MensajeDeError;  
END CATCH

END
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_actualizar_estado_rutas_asignadas' AND type = 'P')
	DROP PROCEDURE pa_actualizar_estado_rutas_asignadas
GO
----------------------------------------------------------------------------------
-- Author: WILSON IDE-SOLUTION
-- Created: 13/01/2020  
-- Sistema: ws_wa_DistribuidoraVDC
-- Descripci�n: Actualizar estado
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[pa_actualizar_estado_rutas_asignadas]
(
	
	@estado INT,
	@codRuta INT,
	@codUsuario INT,
	@resultado INT OUTPUT,
	@msje VARCHAR(250) OUTPUT,
	@codRutaResputa INT OUTPUT

)

AS
DECLARE @counestado INT
BEGIN
	SET NOCOUNT ON;	

	SET @msje = 'Exito';
	SET @codRutaResputa = @codRuta;
	SET @resultado = 0;
	SET @counestado = 0;

BEGIN TRY

			BEGIN TRANSACTION

			UPDATE  tblRutasAsignadas SET estado = @estado WHERE codRuta = @codRuta

			SELECT @counestado = COUNT(*) FROM tblRutasAsignadas WHERE estado = 0 and codUsuario = @codUsuario and marcaBaja = 0

			IF @counestado = 0
				BEGIN
				UPDATE tblRutasAsignadas SET estado = 0 WHERE  codUsuario = @codUsuario
			END 
			COMMIT TRANSACTION

			SELECT @resultado as resultado ,  @msje as msje, @codRutaResputa as codRuta			
	
END TRY
BEGIN CATCH
IF (XACT_STATE()) <> 0 
		BEGIN
			ROLLBACK TRANSACTION
		END
		SET @resultado = ERROR_NUMBER();
		SET @msje = 'Error en pa_actualizar_estado_rutas_asignadas ' + ERROR_MESSAGE();
		SET @codRutaResputa = 0;
		SELECT @resultado as resultado , @msje as msje, @codRutaResputa as codRutaResputa
END CATCH

END
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_insertar_rutas_bitacoras' AND type = 'P')
	DROP PROCEDURE pa_insertar_rutas_bitacoras
GO
----------------------------------------------------------------------------------
-- Author: WILSON IDE-SOLUTION
-- Created: 13/01/2020  
-- Sistema: ws_wa_DistribuidoraVDC
-- Descripci�n: Actualizar estado
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[pa_insertar_rutas_bitacoras]
(
	@codRuta INT,
	@codCliente VARCHAR(12),
	@fecha DATE,
	@visita SMALLINT,
	@motivo VARCHAR(500),
	@usuario VARCHAR(20),
	@ip VARCHAR(20),
	@mac VARCHAR(20),
	@cordenadaX VARCHAR(100),
	@cordenadaY VARCHAR (100),
	@estado SMALLINT,
	@resultado INT OUTPUT,
	@msje VARCHAR(250) OUTPUT,
	@codRutaResputa INT OUTPUT
)

AS
BEGIN
	SET NOCOUNT ON;	

	SET @msje = 'Exito';
	SET @codRutaResputa = @codRuta;
	SET @resultado = 0;

BEGIN TRY
	/*SET @contRuta = 0
		SELECT @contRuta = count(codRuta), @codUser = codUsuario  FROM tblRutasAsignadas WHERE codRuta = @codRuta and marcaBaja = 0
		GROUP BY codUsuario*/

		--IF @contRuta = 0
			--BEGIN
			BEGIN TRANSACTION
			INSERT INTO tblRutaBitacora
			(codRuta,codCliente,fecha,visita,motivo,marcaBaja,usuario,cordenadaX,cordenadaY,estado)
			VALUES (@codRuta,@codCliente,GETDATE(),@visita,@motivo,0,'11111111',@cordenadaX,@cordenadaY,0);
			COMMIT TRANSACTION

			SELECT @resultado as resultado ,  @msje as msje, @codRutaResputa as codRuta			
		/*END
		ELSE 
			BEGIN
			SELECT @resultado = @codUser
		 END*/
END TRY
BEGIN CATCH
IF (XACT_STATE()) <> 0 
		BEGIN
			ROLLBACK TRANSACTION
		END
		SET @resultado = ERROR_NUMBER();
		SET @msje = 'Error en pa_insertar_rutas_bitacoras ' + ERROR_MESSAGE();
		SET @codRutaResputa = 0;
		SELECT @resultado as resultado , @msje as msje, @codRutaResputa as codRutaResputa
END CATCH

END
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_listar_precios_x_productos' AND type = 'P')
	DROP PROCEDURE pa_listar_precios_x_productos
GO
----------------------------------------------------------------------------------
-- Author: Luis Llatas IDE-SOLUTION
-- Created: 10/02/2020  
-- Sistema: WEB / Mantenedor Precios
-- Descripci�n: Listar precios por productos
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_listar_precios_x_productos
(@codProveedor INT, @codFabricante INT, 
 @codCategoria INT, @codSubcategoria INT,
 @descripcion VARCHAR(200))		
AS
  SET NOCOUNT ON
--OBTENIENDO TODOS LOS ELEMENTOS: (1 FILTRO)
--1.Obtener todos los datos (sin filtrado) 
IF (@codProveedor = 0 AND @codFabricante = 0 AND 
    @codCategoria = 0 AND @codSubcategoria = 0 AND 
    @descripcion = '')
 BEGIN
   SELECT 
   codProveedor,descProveedor,codFabricante,descFabricante,
   codCategoria,descCategoria,codSubcategoria,descSubcategoria,
   codProducto,descProducto,precioCosto 
   FROM v_listar_precios
 END

--**************************************
----------------------------------- 
--DE 1 ELEMENTO - INICIO: (5 FILTROS)
------------------------------------
--{Proveedor}
-- Filtrado s�lo por c�digo de Proveedor (filtro independiente)
IF (@codProveedor <> 0 AND @codFabricante = 0 AND 
    @codCategoria = 0  AND @codSubcategoria = 0 AND 
    @descripcion = '')
   BEGIN 
   SELECT 
   codProveedor,descProveedor,codFabricante,descFabricante,
   codCategoria,descCategoria,codSubcategoria,descSubcategoria,
   codProducto,descProducto,precioCosto 
   FROM v_listar_precios WHERE codProveedor = @codProveedor
   END     

-- {Fabricante}
-- Filtrado s�lo por c�digo de Fabricante (filtro independiente)
IF (@codFabricante <> 0 AND @codProveedor = 0 AND 
    @codCategoria = 0   AND @codSubcategoria = 0 AND 
    @descripcion = '')
   BEGIN 
   SELECT 
   codProveedor,descProveedor,codFabricante,descFabricante,
   codCategoria,descCategoria,codSubcategoria,descSubcategoria,
   codProducto,descProducto,precioCosto 
   FROM v_listar_precios WHERE codFabricante = @codFabricante 
   END

-- {Categor�a}
-- Filtrado s�lo por c�digo de Categoria (Subcategoria todos)
IF (@codProveedor = 0 AND @codFabricante = 0 AND 
    @codCategoria <> 0 AND @codSubcategoria = 0 AND 
    @descripcion = '')
   BEGIN 
   SELECT 
   codProveedor,descProveedor,codFabricante,descFabricante,
   codCategoria,descCategoria,codSubcategoria,descSubcategoria,
   codProducto,descProducto,precioCosto 
   FROM v_listar_precios WHERE codCategoria = @codCategoria     
   END

-- {Subcategor�a}
-- Filtrado s�lo por c�digo de Categoria y Subcategoria
IF (@codCategoria <> 0 AND @codSubcategoria <> 0 AND
    @codProveedor = 0 AND @codFabricante = 0  AND
    @descripcion = '')
   BEGIN 
   SELECT 
   codProveedor,descProveedor,codFabricante,descFabricante,
   codCategoria,descCategoria,codSubcategoria,descSubcategoria,
   codProducto,descProducto,precioCosto 
   FROM v_listar_precios WHERE 
   codCategoria = @codCategoria AND 
   codSubcategoria = @codSubcategoria  
   END

-- {Producto}   
-- Filtrado s�lo por producto (Puede ser por c�digo � descripci�n)
IF (@descripcion != '' AND @codProveedor = 0 AND
    @codFabricante = 0 AND @codCategoria = 0 AND 
    @codSubcategoria = 0 
    )
   BEGIN 
   SELECT 
   codProveedor,descProveedor,codFabricante,descFabricante,
   codCategoria,descCategoria,codSubcategoria,descSubcategoria,
   codProducto,descProducto,precioCosto 
   FROM v_listar_precios WHERE 
   ((codProducto LIKE '%'+@descripcion+'%') OR (descProducto LIKE '%'+@descripcion+'%'))   
   END

----------------------------   
-- DE 1 ELEMENTO - FIN
----------------------------
--**************************************

----------------------------
-- DE 2 ELEMENTOS - INICIO: (9 FILTROS)
----------------------------
-- {Categoria,Fabricante}
-- Filtrado s�lo por c�digo de Fabricante y c�digo de Categoria (Subcategoria: Todos)
IF (@codFabricante <> 0 AND @codCategoria <> 0 AND 
    @codSubcategoria = 0 AND @codProveedor = 0 AND 
    @descripcion = '')
   BEGIN 
   SELECT 
   codProveedor,descProveedor,codFabricante,descFabricante,
   codCategoria,descCategoria,codSubcategoria,descSubcategoria,
   codProducto,descProducto,precioCosto 
   FROM v_listar_precios WHERE codFabricante = @codFabricante AND codCategoria = @codCategoria    
   END
  
--{Categoria,Proveedor}
-- Filtrado s�lo por c�digo de Proveedor y c�digo de Categoria (Subcategoria: Todos)
IF (@codProveedor <> 0 AND @codCategoria <> 0 AND
    @codFabricante = 0 AND @codSubcategoria = 0 AND 
    @descripcion = '')
   BEGIN 
   SELECT 
   codProveedor,descProveedor,codFabricante,descFabricante,
   codCategoria,descCategoria,codSubcategoria,descSubcategoria,
   codProducto,descProducto,precioCosto 
   FROM v_listar_precios WHERE codProveedor = @codProveedor AND codCategoria = @codCategoria    
   END

--{Categoria,Producto}
-- Filtrado s�lo por c�digo de Categoria (Subcategoria: Todos) y c�digo de Producto 
IF (@codProveedor = 0 AND @codCategoria <> 0 AND
    @codFabricante = 0 AND @codSubcategoria = 0 AND 
    @descripcion != '')
   BEGIN 
   SELECT 
   codProveedor,descProveedor,codFabricante,descFabricante,
   codCategoria,descCategoria,codSubcategoria,descSubcategoria,
   codProducto,descProducto,precioCosto 
   FROM v_listar_precios WHERE codCategoria = @codCategoria AND  
        ((codProducto LIKE '%'+@descripcion+'%') OR (descProducto LIKE '%'+@descripcion+'%'))    
   END

-- {Subcategoria,Fabricante}
-- Filtrado s�lo por c�digo de Fabricante, c�digo de Categoria y c�digo de Subcategoria
IF (@codFabricante <> 0 AND @codCategoria <> 0 AND 
    @codSubcategoria <> 0 AND @codProveedor = 0 AND 
    @descripcion = '')
   BEGIN 
   SELECT 
   codProveedor,descProveedor,codFabricante,descFabricante,
   codCategoria,descCategoria,codSubcategoria,descSubcategoria,
   codProducto,descProducto,precioCosto 
   FROM v_listar_precios WHERE codFabricante = @codFabricante AND codCategoria = @codCategoria
   AND codSubcategoria = @codSubcategoria  
   END

-- {Subcategoria,Proveedor}
-- Filtrado s�lo por c�digo de Proveedor, c�digo de Categoria y c�digo de Subcategoria
IF (@codProveedor <> 0 AND @codCategoria <> 0 AND 
    @codSubcategoria <> 0 AND @codFabricante = 0 AND 
    @descripcion = '')
   BEGIN 
   SELECT 
   codProveedor,descProveedor,codFabricante,descFabricante,
   codCategoria,descCategoria,codSubcategoria,descSubcategoria,
   codProducto,descProducto,precioCosto 
   FROM v_listar_precios 
   WHERE codProveedor = @codProveedor 
     AND codCategoria = @codCategoria
     AND codSubcategoria = @codSubcategoria
   END

-- {Subcategoria,Producto}
-- Filtrado s�lo por c�digo de Categoria y Subcategoria y Producto 
IF (@codProveedor = 0 AND @codCategoria <> 0 AND
    @codFabricante = 0 AND @codSubcategoria <> 0 AND 
    @descripcion != '')
   BEGIN 
   SELECT 
   codProveedor,descProveedor,codFabricante,descFabricante,
   codCategoria,descCategoria,codSubcategoria,descSubcategoria,
   codProducto,descProducto,precioCosto 
   FROM v_listar_precios WHERE codCategoria = @codCategoria AND codSubcategoria = @codSubcategoria AND  
        ((codProducto LIKE '%'+@descripcion+'%') OR (descProducto LIKE '%'+@descripcion+'%'))    
   END   

-- {Fabricante,Proveedor}
-- Filtrado s�lo por c�digo de Proveedor y c�digo de Fabricante
IF (@codProveedor <> 0 AND @codFabricante <> 0 AND 
    @codCategoria = 0  AND @codSubcategoria = 0 AND 
    @descripcion = '')
   BEGIN 
   SELECT 
   codProveedor,descProveedor,codFabricante,descFabricante,
   codCategoria,descCategoria,codSubcategoria,descSubcategoria,
   codProducto,descProducto,precioCosto 
   FROM v_listar_precios WHERE codProveedor = @codProveedor AND codFabricante = @codFabricante    
   END

-- {Fabricante,Producto}
-- Filtrado s�lo por C�digo de Fabricante y (C�digo de Producto y Descripci�n de Producto)
IF (@codFabricante <> 0 AND @descripcion != '' AND 
     @codProveedor = 0 AND @codCategoria = 0 AND
     @codSubcategoria = 0)
   BEGIN 
   SELECT 
   codProveedor,descProveedor,codFabricante,descFabricante,
   codCategoria,descCategoria,codSubcategoria,descSubcategoria,
   codProducto,descProducto,precioCosto 
   FROM v_listar_precios WHERE codFabricante = @codFabricante 
   AND ((codProducto LIKE '%'+@descripcion+'%') OR (descProducto LIKE '%'+@descripcion+'%'))
   END

-- {Proveedor,Producto}
-- Filtrado s�lo por C�digo de Proveedor y (C�digo de Producto y Descripci�n de Producto)
IF (@codProveedor <> 0 AND @descripcion != '' AND
     @codFabricante = 0 AND @codCategoria = 0 AND
     @codSubcategoria = 0)
   BEGIN 
   SELECT 
   codProveedor,descProveedor,codFabricante,descFabricante,
   codCategoria,descCategoria,codSubcategoria,descSubcategoria,
   codProducto,descProducto,precioCosto 
   FROM v_listar_precios WHERE 
   codProveedor = @codProveedor 
   AND ((codProducto LIKE '%'+@descripcion+'%') OR (descProducto LIKE '%'+@descripcion+'%'))
   END
-------------------------
-- DE 2 ELEMENTOS - FIN
-------------------------
--**************************************

----------------------------
-- DE 3 ELEMENTOS - INICIO: (8 FILTROS)
----------------------------
-- {Categoria,Fabricante,Proveedor}
-- Filtrado s�lo por C�digo de Proveedor, C�digo de Fabricante y C�digo de Categor�a (Subcategoria: Todos).
IF (@codProveedor <> 0 AND @codFabricante <> 0 AND @codCategoria <> 0 AND
     @codSubcategoria = 0 AND @descripcion = '')
   BEGIN 
   SELECT 
   codProveedor,descProveedor,codFabricante,descFabricante,
   codCategoria,descCategoria,codSubcategoria,descSubcategoria,
   codProducto,descProducto,precioCosto 
   FROM v_listar_precios WHERE 
   codProveedor = @codProveedor AND
   codFabricante = @codFabricante AND
   codCategoria = @codCategoria
   END 

-- {Categoria,Proveedor,Producto}
-- Filtrado s�lo por C�digo de Categoria (Subcategoria: Todos), C�digo de Proveedor y Producto (C�digo � Descripci�n).
IF (@codProveedor <> 0 AND @codFabricante = 0 AND @codCategoria <> 0 AND
     @codSubcategoria = 0 AND @descripcion != '')
   BEGIN 
   SELECT 
   codProveedor,descProveedor,codFabricante,descFabricante,
   codCategoria,descCategoria,codSubcategoria,descSubcategoria,
   codProducto,descProducto,precioCosto 
   FROM v_listar_precios WHERE 
   codProveedor = @codProveedor AND
   codCategoria = @codCategoria AND
   ((codProducto LIKE '%'+@descripcion+'%') OR (descProducto LIKE '%'+@descripcion+'%'))
   END

-- {Subcategoria,Fabricante,Proveedor}
-- Filtrado s�lo por C�digo de Subcategoria (Por tanto debe haber elegido una Categor�a), Fabricante y Proveedor
IF (@codProveedor <> 0 AND @codFabricante <> 0 AND 
    @codCategoria <> 0 AND @codSubcategoria <> 0 AND 
    @descripcion = '')
   BEGIN 
   SELECT 
   codProveedor,descProveedor,codFabricante,descFabricante,
   codCategoria,descCategoria,codSubcategoria,descSubcategoria,
   codProducto,descProducto,precioCosto 
   FROM v_listar_precios WHERE codProveedor = @codProveedor AND codFabricante = @codFabricante AND 
                               codCategoria = @codCategoria AND codSubcategoria = @codSubcategoria 
   END 

-- {Subcategoria,Proveedor,Producto} 
-- Filtrado s�lo por C�digo de Subcategoria (Por tanto debe haber elegido una Categor�a), C�digo de Proveedor y Producto (C�digo � Descripci�n).
IF (@codProveedor <> 0 AND @codFabricante = 0 AND @codCategoria <> 0 AND
     @codSubcategoria <> 0 AND @descripcion != '')
   BEGIN 
   SELECT 
   codProveedor,descProveedor,codFabricante,descFabricante,
   codCategoria,descCategoria,codSubcategoria,descSubcategoria,
   codProducto,descProducto,precioCosto 
   FROM v_listar_precios WHERE 
   codProveedor = @codProveedor AND
   codCategoria = @codCategoria AND
   codSubcategoria = @codSubcategoria AND
   ((codProducto LIKE '%'+@descripcion+'%') OR (descProducto LIKE '%'+@descripcion+'%'))
   END

-- {Fabricante,Proveedor,Producto}
-- Filtrado s�lo por C�digo de Fabricante, C�digo de Proveedor y Producto (C�digo o Descripcion).
IF (@codProveedor <> 0 AND @codFabricante <> 0 AND @codCategoria = 0 AND
     @codSubcategoria = 0 AND @descripcion != '')
   BEGIN 
   SELECT 
   codProveedor,descProveedor,codFabricante,descFabricante,
   codCategoria,descCategoria,codSubcategoria,descSubcategoria,
   codProducto,descProducto,precioCosto 
   FROM v_listar_precios WHERE 
   codProveedor = @codProveedor AND
   codFabricante = @codFabricante AND
   ((codProducto LIKE '%'+@descripcion+'%') OR (descProducto LIKE '%'+@descripcion+'%'))
   END

-- {Categor�a,Fabricante,Producto}
-- Filtrado s�lo por C�digo de Categor�a (Subcategoria: Todos), C�digo de Fabricante y Producto (C�digo o Descripcion).
IF (@codProveedor = 0 AND @codFabricante <> 0 AND @codCategoria <> 0 AND
     @codSubcategoria = 0 AND @descripcion != '')
   BEGIN 
   SELECT 
   codProveedor,descProveedor,codFabricante,descFabricante,
   codCategoria,descCategoria,codSubcategoria,descSubcategoria,
   codProducto,descProducto,precioCosto 
   FROM v_listar_precios WHERE 
   codFabricante = @codFabricante AND
   codCategoria = @codCategoria AND
   ((codProducto LIKE '%'+@descripcion+'%') OR (descProducto LIKE '%'+@descripcion+'%'))
   END

-- {Categor�a,Subcategor�a,Producto}
-- Filtrado s�lo por C�digo de Categor�a y C�digo de Subcategor�a, y Producto (C�digo o Descripcion).
IF (@codProveedor = 0 AND @codFabricante = 0 AND @codCategoria <> 0 AND
     @codSubcategoria <> 0 AND @descripcion != '')
   BEGIN 
   SELECT 
   codProveedor,descProveedor,codFabricante,descFabricante,
   codCategoria,descCategoria,codSubcategoria,descSubcategoria,
   codProducto,descProducto,precioCosto 
   FROM v_listar_precios WHERE 
   codCategoria = @codCategoria AND
   codSubcategoria = @codSubcategoria AND
   ((codProducto LIKE '%'+@descripcion+'%') OR (descProducto LIKE '%'+@descripcion+'%'))
   END

-- {Subcategr�a,Fabricante,Producto}
-- Filtrado s�lo por C�digo de Subcategor�a (Por tanto debe haber elegido una Categor�a) y Fabricante y Producto (C�digo o Descripcion).
IF (@codProveedor = 0 AND @codFabricante <> 0 AND @codCategoria <> 0 AND
     @codSubcategoria <> 0 AND @descripcion != '')
   BEGIN 
   SELECT 
   codProveedor,descProveedor,codFabricante,descFabricante,
   codCategoria,descCategoria,codSubcategoria,descSubcategoria,
   codProducto,descProducto,precioCosto 
   FROM v_listar_precios WHERE 
   codFabricante = @codFabricante AND
   codCategoria = @codCategoria AND
   codSubcategoria = @codSubcategoria AND
   ((codProducto LIKE '%'+@descripcion+'%') OR (descProducto LIKE '%'+@descripcion+'%'))
   END

----------------------------
-- DE 3 ELEMENTOS - FIN 
----------------------------
--**************************************

----------------------------
-- DE 4 ELEMENTOS - INICIO: (2 FILTROS)
----------------------------
--**************************************

-- {Categor�a,Fabricante,Proveedor,Producto}
-- Filtrado s�lo por C�digo de Categor�a (Subcategoria: Todos) y Fabricante y Proveedor y Producto (C�digo o Descripcion).
 IF (@codProveedor <> 0 AND @codFabricante <> 0 AND @codCategoria <> 0 AND
     @codSubcategoria = 0 AND @descripcion != '')
   BEGIN 
   SELECT 
   codProveedor,descProveedor,codFabricante,descFabricante,
   codCategoria,descCategoria,codSubcategoria,descSubcategoria,
   codProducto,descProducto,precioCosto 
   FROM v_listar_precios WHERE 
   codFabricante = @codFabricante AND
   codProveedor = @codProveedor AND
   codCategoria = @codCategoria AND
   ((codProducto LIKE '%'+@descripcion+'%') OR (descProducto LIKE '%'+@descripcion+'%'))
   END

-- {Subcategor�a,Fabricante,Proveedor,Producto}
-- Filtrado s�lo por Subcategor�a (Por tanto debe haber elegido una Categor�a) y Fabricante y Proveedor y Producto (C�digo de Producto � Descripci�n)
 IF (@codProveedor <> 0 AND @codFabricante <> 0 AND @codCategoria <> 0 AND
     @codSubcategoria <> 0 AND @descripcion != '')
   BEGIN 
   SELECT 
   codProveedor,descProveedor,codFabricante,descFabricante,
   codCategoria,descCategoria,codSubcategoria,descSubcategoria,
   codProducto,descProducto,precioCosto 
   FROM v_listar_precios WHERE 
   codFabricante = @codFabricante AND
   codProveedor = @codProveedor AND
   codCategoria = @codCategoria AND
   codSubcategoria = @codSubcategoria AND   
   ((codProducto LIKE '%'+@descripcion+'%') OR (descProducto LIKE '%'+@descripcion+'%'))
   END
   
----------------------------
-- DE 4 ELEMENTOS - FIN
----------------------------
--************************************** 

--NOTA:  SE UTILIZ� AN�LISIS COMBINATORIO PARA HALLAR TODOS LOS POSIBLES CASO A FILTRAR.    
		
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_listar_detalle_precio_x_producto' AND type = 'P')
	DROP PROCEDURE pa_listar_detalle_precio_x_producto
GO
----------------------------------------------------------------------------------
-- Author: Luis Llatas IDE-SOLUTION
-- Created: 10/02/2020  
-- Sistema: WEB / Mantenedor Precio
-- Descripción: Listar Detalle Precio por Producto
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE pa_listar_detalle_precio_x_producto
(@codProducto VARCHAR(10)
)
AS
BEGIN
SET NOCOUNT ON

DECLARE @const_0 tinyint 
DECLARE @const_1 tinyint
DECLARE @prefi_7 tinyint

SET @const_0 = 0
SET @const_1 = 1
SET @prefi_7 = 7
--pasar a tabla temporal resultado de store de conceptos 

SELECT correlativo,descripcion 
INTO #tmpConcepto 
FROM fu_buscar_conceptos_generales (@prefi_7)


SELECT con.correlativo as correlativo,con.descripcion as descripcion, 
( CASE WHEN (SELECT precioVenta FROM tblPrecio WHERE tblPrecio.codProducto = @codProducto AND tblPrecio.tipoListaPrecio = con.correlativo AND tblPrecio.marcaBaja = 0) IS NULL
       THEN ''
       ELSE (SELECT precioVenta FROM tblPrecio WHERE tblPrecio.codProducto = @codProducto AND tblPrecio.tipoListaPrecio = con.correlativo AND tblPrecio.marcaBaja = 0) END )
       AS precioVenta
     
FROM #tmpConcepto AS con 
LEFT JOIN tblPrecio AS pre
ON con.correlativo = pre.tipoListaPrecio AND pre.codProducto = @codProducto
WHERE con.correlativo <> @const_0 AND (pre.marcaBaja = 0 OR pre.marcabaja IS NULL);

DROP TABLE #tmpConcepto

END


GO



IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_registrar_actualizar_precio_x_producto' AND type = 'P')
	DROP PROCEDURE pa_registrar_actualizar_precio_x_producto
GO
----------------------------------------------------------------------------------
-- Author: Luis Llatas IDE-SOLUTION
-- Created: 10/02/2020  
-- Sistema: WEB / Mantenedor Precios
-- Descripción: Registrar Actualizar Precios por Producto
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

CREATE PROCEDURE pa_registrar_actualizar_precio_x_producto
(@codProducto VARCHAR(10),
 @tipoListaPrecio TINYINT,
 @precio MONEY,
 @codProveedor INT,
 @flag TINYINT
)
AS
 --Actualizar sólo en la tabla tblProducto
 IF @flag = 1 
   BEGIN
    UPDATE tblPrecio SET precioVenta = @precio WHERE codProducto = @codProducto AND tipoListaPrecio = 1 
    AND marcaBaja = 0;
   END

 --Actualizar sólo en la tabla tblPrecio
 IF @flag = 2
   BEGIN
    UPDATE tblPrecio SET precioVenta = @precio WHERE codProducto = @codProducto 
    AND tipoListaPrecio = @tipoListaPrecio 
    AND marcaBaja = 0;
   END  

 --Registrar sólo en la tabla tblPrecio
 IF @flag = 3
   BEGIN 
     INSERT INTO tblPrecio (codProducto,tipoListaPrecio,precioVenta,marcaBaja,usuario,ip,mac) 
     VALUES (@codProducto,@tipoListaPrecio,@precio,0,'lllatas','172.19.21.21','ABC-SA-21-SADA')                  
   END



GO


IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_listar_producto_precios_completo' AND type = 'P')
	DROP PROCEDURE pa_listar_producto_precios_completo
GO
----------------------------------------------------------------------------------
-- Author: Luis Llatas IDE-SOLUTION
-- Created: 10/02/2020  
-- Sistema: WEB / Mantenedor Precios
-- Descripción: Listar producto precios completo
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

CREATE PROCEDURE pa_listar_producto_precios_completo
AS
SELECT 
DISTINCT tblAbastecimento.codProducto AS codProducto,
       ( CASE WHEN (SELECT tblPrecio.precioVenta FROM tblPrecio WHERE tblPrecio.codProducto = tblAbastecimento.codProducto AND tblPrecio.tipoListaPrecio = 1 AND tblPrecio.marcaBaja = 0) IS NULL
       THEN ''
       ELSE tblPrecio.precioVenta END )
       AS precioVenta,
      ( CASE WHEN (SELECT tblPrecio.tipoListaPrecio FROM tblPrecio WHERE tblPrecio.codProducto = tblAbastecimento.codProducto AND tblPrecio.tipoListaPrecio = 1 AND tblPrecio.marcaBaja = 0) IS NULL
       THEN ''
       ELSE tblPrecio.tipoListaPrecio END )
       AS tipoListaPrecio,
       tblAbastecimento.codProveedor as codProveedor

FROM tblAbastecimento
LEFT JOIN tblPrecio
ON tblPrecio.codProducto = tblAbastecimento.codProducto      
WHERE  
      (tblPrecio.marcaBaja = 0 OR tblPrecio.marcaBaja IS NULL) AND 
      (tblAbastecimento.marcaBaja = 0 OR tblAbastecimento.marcaBaja IS NULL)
ORDER BY tblAbastecimento.codProveedor DESC
    

GO



IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_obtener_precio_x_producto' AND type = 'P')
	DROP PROCEDURE pa_obtener_precio_x_producto
GO
----------------------------------------------------------------------------------
-- Author: Luis Llatas IDE-SOLUTION
-- Created: 10/02/2020  
-- Sistema: WEB / Mantenedor Precios
-- Descripción: Obtener precios por producto
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

CREATE PROCEDURE pa_obtener_precio_x_producto
(@codProducto VARCHAR(10),
 @tipoListaPrecio TINYINT,
 @codProveedoor INT
)
AS
 DECLARE @cont  INT
 DECLARE @valor INT

SELECT @cont = COUNT(precioVenta) 
 FROM tblPrecio WHERE codProducto = @codProducto
 AND tipoListaPrecio = @tipoListaPrecio AND marcaBaja = 0

IF @tipoListaPrecio != 1
  BEGIN
	IF @cont = 0 
	  BEGIN
	    SET @valor = -1
	    SELECT @valor AS precioVenta
	  END
	ELSE
	  BEGIN
	     SELECT precioVenta FROM tblPrecio 
	     WHERE codProducto = @codProducto AND tipoListaPrecio = @tipoListaPrecio AND 
	     marcaBaja = 0  
	  END
  END
ELSE 
  BEGIN
	  SELECT tblPrecio.precioVenta AS precioVenta
    FROM tblPrecio WHERE codProducto = @codProducto
    AND tipoListaPrecio = 1  AND marcaBaja = 0 -- Se obtiene el PRECIO COSTO (que debera estar registrado siempre con tipo UNO(01))
  END  


GO 


IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_listar_conceptos' AND type = 'P')
	DROP PROCEDURE pa_listar_conceptos
GO
----------------------------------------------------------------------------------
-- Author: Luis Llatas IDE-SOLUTION 
-- Created: 10/02/2020  
-- Sistema: WEB / Mantenedor Precios
-- Descripci�n: Listar conceptos
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[pa_listar_conceptos]
(
 @p_pref INT
)	

AS 
  BEGIN
   SET NOCOUNT ON
       DECLARE @corr TINYINT -- correlativo del concepto 
       DECLARE @desc VARCHAR(250) -- descripcion del concepto
	
	 BEGIN TRY		

             SET @corr = 0;
	     SET @desc = '';
			
	     SELECT correlativo,descripcion FROM fu_buscar_conceptos_generales (@p_pref)
             SELECT @corr as 'correlativo', @desc as 'descripcion'

	 END TRY
         BEGIN CATCH
		   
			SET @desc = ERROR_MESSAGE()
			SELECT @corr as 'correlativo', @desc as 'descripcion'

	 END CATCH
END

GO

IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_validar_codigoproducto' AND type = 'P')
	DROP PROCEDURE pa_validar_codigoproducto

GO
----------------------------------------------------------------------------------
-- Author: Luis Llatas IDE-SOLUTION
-- Created: 10/02/2020  
-- Sistema: WEB / Mantenedor Precios
-- Descripci�n: Validar codigo de producto
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

CREATE PROCEDURE dbo.pa_validar_codigoproducto
(
@codProducto  VARCHAR(10)
)
AS
SET NOCOUNT ON

BEGIN
   
    SELECT count(codProducto) as cantidad FROM
    tblProducto where codProducto = @codProducto and marcabaja = 0
   

END

GO

IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_listar_rutas_bitacoras' AND type = 'P')
	DROP PROCEDURE pa_listar_rutas_bitacoras
GO
----------------------------------------------------------------------------------
-- Author: WILSON IDE-SOLUTION
-- Created: 13/01/2020  
-- Sistema: ws_wa_DistribuidoraVDC
-- Descripci�n: Actualizar bitacoras de ruta
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[pa_listar_rutas_bitacoras]
(
@codVendedor INTEGER,
@fechaActual INTEGER,
@fechaIncio DATE,
@fechaFin DATE,
@flagFiltro SMALLINT

)

AS   
BEGIN
	BEGIN TRY
	IF @flagFiltro = 1
	  BEGIN
			select  v.nombVendedor as vendedor, r.descripcion,  c.nombCliente as cliente, rb.visita as visita, rb.motivo, rb.fecha, c.razonsocial, rb.cordenadaX, rb.cordenadaY
			from tblRutaBitacora as rb 
				inner join tblRutasAsignadas as ra on ra.codRuta = rb.codRuta
				inner join tblRutas as r on ra.codRuta = r.ntraRutas
	
				inner join (
				select u.ntraUsuario as codVendedor, CONCAT(p.nombres,' ',p.apellidoPaterno,' ',p.apellidoMaterno) as nombVendedor 
				from tblPersona as p
					inner join tblUsuario as u on p.codPersona = u.codPersona
				WHERE u.codPerfil = 1 AND u.marcaBaja = 0 and p.marcaBaja = 0
		
				) as v on ra.codUsuario = v.codVendedor
				inner join (
				select p.numeroDocumento as codCliente, CONCAT(p.nombres,' ',p.apellidoPaterno,' ',p.apellidoMaterno) as nombCliente, p.ruc as ruc, p.razonSocial as razonsocial
				from tblPersona as p
					inner join tblCliente as ca on ca.codPersona = p.codPersona 
					where ca.marcaBaja = 0 and p.marcaBaja = 0
				) as c on rb.codCliente = c.codCliente OR rb.codCliente = c.ruc

			  WHERE ra.codUsuario = @codVendedor and MONTH(rb.fecha) = @fechaActual  and ra.marcaBaja = 0 and rb.marcaBaja = 0 and r.marcaBaja = 0
			  ORDER BY rb.fecha ASC, rb.horaProceso ASC
		END
		ELSE
		BEGIN
				select  v.nombVendedor as vendedor, r.descripcion,  c.nombCliente as cliente, rb.visita as visita, rb.motivo, rb.fecha, c.razonsocial, rb.cordenadaX, rb.cordenadaY
				from tblRutaBitacora as rb 
					inner join tblRutasAsignadas as ra on ra.codRuta = rb.codRuta
					inner join tblRutas as r on ra.codRuta = r.ntraRutas
	
					inner join (
					select u.ntraUsuario as codVendedor, CONCAT(p.nombres,' ',p.apellidoPaterno,' ',p.apellidoMaterno) as nombVendedor 
					from tblPersona as p
						inner join tblUsuario as u on p.codPersona = u.codPersona
					WHERE u.codPerfil = 1 AND u.marcaBaja = 0 and p.marcaBaja = 0
		
					) as v on ra.codUsuario = v.codVendedor
					inner join (
					select p.numeroDocumento as codCliente, CONCAT(p.nombres,' ',p.apellidoPaterno,' ',p.apellidoMaterno) as nombCliente, p.ruc as ruc, p.razonSocial as razonsocial
					from tblPersona as p
						inner join tblCliente as ca on ca.codPersona = p.codPersona 
						where ca.marcaBaja = 0 and p.marcaBaja = 0
					) as c on rb.codCliente = c.codCliente OR rb.codCliente = c.ruc

				 WHERE ra.codUsuario = 1 and (rb.fecha BETWEEN @fechaIncio AND @fechaFin )  and ra.marcaBaja = 0 and rb.marcaBaja = 0 and r.marcaBaja = 0
				 ORDER BY rb.fecha ASC, rb.horaProceso ASC
		END
	END TRY
	BEGIN CATCH
			IF (XACT_STATE()) <> 0 
					BEGIN
						ROLLBACK TRANSACTION
					END
					SELECT   
					ERROR_NUMBER() AS ErrorNumber  
					,ERROR_MESSAGE() AS ErrorMessage;
	END CATCH
END
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_buscar_dni_cliente' AND type = 'P')
	DROP PROCEDURE pa_buscar_dni_cliente
GO
----------------------------------------------------------------------------------
-- Author: Jonathan Macalupu S. IDE-SOLUTION
-- Created: 06/01/2020  
-- Sistema: Sistema Distribuidora Virgen del Carmen
-- Modulo: General
-- Descripci�n: Busca si existe el dni del cliente 
-----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[pa_buscar_dni_cliente]	
(
	@p_dni INT		-- dni del cliente
)

AS
	BEGIN
	SET NOCOUNT ON
		DECLARE @val TINYINT		-- Valor de existencia codigo persona
		DECLARE @flag INT;			-- flag de proceso
		DECLARE @msje VARCHAR(250);	-- mensaje de error
		

		SET @flag = 0;
		SET @msje = 'Exito';
		SET @val = 0;

		BEGIN TRY		

			SELECT @val = COUNT(codPersona)
			FROM tblCliente
			WHERE codPersona = @p_dni AND marcaBaja = 0;

			SELECT @flag as flag , @msje as msje, @val as val

		END TRY
		BEGIN CATCH

			SET @flag = ERROR_NUMBER();
			SET @msje = 'Error en pa_buscar_dni_cliente ' + ERROR_MESSAGE();
			SET @val = 0;
			SELECT @flag as flag , @msje as msje, @val as val

		END CATCH

END
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_eliminar_cliente' AND type = 'P')
	DROP PROCEDURE pa_eliminar_cliente
GO
----------------------------------------------------------------------------------
-- Author: Jonathan Macalupu S. IDE-SOLUTION
-- Created: 20/01/2020  
-- Sistema: Sistema Distribuidora Virgen del Carmen
-- Modulo: General
-- Descripci�n: Eliminar clientes 
-----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[pa_eliminar_cliente]	
(
	@p_codPersona INT   --Codigo de persona
)

AS
	BEGIN
	SET NOCOUNT ON
		DECLARE @flag INT;						--flag de proceso
		DECLARE @msje VARCHAR(250);				--mensaje de error

		SET @flag = 0;
		SET @msje = 'Exito';

		BEGIN TRY		
			
			BEGIN TRANSACTION 
			
				UPDATE tblCliente SET marcaBaja = 9 WHERE codPersona = @p_codPersona AND marcaBaja = 0

				UPDATE tblPuntoEntrega SET marcaBaja = 9 WHERE codPersona = @p_codPersona AND marcaBaja = 0

			COMMIT TRANSACTION

			SELECT @flag as flag , @msje as msje

		END TRY

			BEGIN CATCH
				IF (XACT_STATE()) <> 0 
			BEGIN
				ROLLBACK TRANSACTION
			END
			SET @flag = ERROR_NUMBER();
			SET @msje = 'Error en pa_eliminar_cliente ' + ERROR_MESSAGE();
			SELECT @flag as flag , @msje as msje

		END CATCH

END
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_listar_clientes' AND type = 'P')
	DROP PROCEDURE pa_listar_clientes
GO
----------------------------------------------------------------------------------
-- Author: Jonathan Macalupu S. IDE-SOLUTION
-- Created: 06/01/2020  
-- Sistema: Sistema Distribuidora Virgen del Carmen
-- Modulo: General
-- Descripción: Listar clientes 
-----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[pa_listar_clientes]	
(
	@p_tipoDocumento INT,			-- Tipo de docuemento
	@p_numDocumento VARCHAR(15),    -- Numero de docuemento
	@p_nombres VARCHAR(70)          -- Nombres del cliente
)

AS
	BEGIN
	SET NOCOUNT ON
		DECLARE @cod INT					-- codigo persona
		DECLARE @tper TINYINT				-- tipo persona
		DECLARE @tdoc TINYINT				-- tipo de documento
		DECLARE @ndoc VARCHAR(15)			-- numero de documento
		DECLARE @ruc VARCHAR(15)			-- ruc
		DECLARE @rSocial varchar(50)		-- razon social
		DECLARE @nomb VARCHAR(30)			-- nombres
		DECLARE @apellPaterno VARCHAR(20)	-- apellido Paterno
		DECLARE @apellMaterno VARCHAR(20)	-- apellido Materno
		DECLARE @direccion VARCHAR(100)		-- direccion
		DECLARE @correo VARCHAR(60)			-- correo
		DECLARE @telefono VARCHAR(15)		-- telefono
		DECLARE @celular CHAR(9)			-- celular
		DECLARE @perfil TINYINT				-- perfil de cliente
		DECLARE @clasificacion TINYINT		-- clasificacion de cliente
		DECLARE @frecuencia TINYINT			-- frecuencia de cliente
		DECLARE @tipolistaPrecio TINYINT	-- Tipo Lista precio del cliente
		DECLARE @codRuta INT				-- Codigo de Ruta del Cliente
		DECLARE @ordenAtencion SMALLINT		-- Orden de atencion de cliente
		DECLARE @ubigeoDomicilio CHAR(6);	-- Ubigeo Domicilio Fiscal
		DECLARE @coordenadaX VARCHAR(100)   -- CoordenadaX
		DECLARE @coordenadaY VARCHAR(100)   -- CoordenadaY

		DECLARE @flag INT;					-- flag de proceso
		DECLARE @msje VARCHAR(250);			-- mensaje de error
	
		BEGIN TRY		

			SET @cod = 0
			SET @tper = 0  
			SET @tdoc = 0 
			SET @ndoc = '' 
			SET @ruc = '' 
			SET @rSocial = '' 
			SET @nomb = '' 
			SET @apellPaterno = '' 
			SET @apellMaterno = '' 
			SET @direccion = '' 
			SET @correo = '' 
			SET @telefono = '' 
			SET @celular = ''
			SET @perfil = 0
			SET @clasificacion = 0
			SET @frecuencia = 0
			SET @tipolistaPrecio = 0
			SET @codRuta = 0
			SET @ordenAtencion = 0
			SET @ubigeoDomicilio = ''
			SET @flag = 0;
			SET @msje = 'Exito';
			
			IF @p_tipoDocumento = 0 AND @p_numDocumento = '' AND @p_nombres = '' 
			BEGIN
				SELECT p.codPersona, p.tipoPersona, p.tipoDocumento, p.numeroDocumento, p.ruc, p.razonSocial,
				p.nombres, p.apellidoPaterno, p.apellidoMaterno, p.direccion, p.correo, p.telefono, p.celular,
				c.perfilCliente, c.clasificacionCliente, c.frecuenciaCliente, c.tipoListaPrecio, c.codRuta,
				c.ordenAtencion, p.codUbigeo,l.coordenadaX, l.coordenadaY
				FROM tblPersona p INNER JOIN tblCliente c ON p.codPersona = c.codPersona
				INNER JOIN tblLocalizacion l on c.codPersona = l.codPersona
				WHERE p.marcaBaja = 0 AND c.marcaBaja = 0
				ORDER BY c.fechaProceso DESC, c.horaProceso DESC;
			END
			IF @p_numDocumento != '' AND @p_tipoDocumento != 0
			BEGIN	
				SELECT p.codPersona, p.tipoPersona, p.tipoDocumento, p.numeroDocumento, p.ruc, p.razonSocial,
				p.nombres, p.apellidoPaterno, p.apellidoMaterno, p.direccion, p.correo, p.telefono, p.celular,
				c.perfilCliente, c.clasificacionCliente, c.frecuenciaCliente, c.tipoListaPrecio, c.codRuta,
				c.ordenAtencion, p.codUbigeo,l.coordenadaX, l.coordenadaY
				FROM tblPersona p 
				INNER JOIN tblCliente c ON p.codPersona = c.codPersona
				INNER JOIN tblLocalizacion l on c.codPersona = l.codPersona
				WHERE P.tipoDocumento = @p_tipoDocumento AND (p.numeroDocumento = @p_numDocumento OR p.ruc = @p_numDocumento)
				AND p.marcaBaja = 0 AND c.marcaBaja = 0;
			END
			IF @p_nombres != '' AND @p_tipoDocumento = 0
			BEGIN
				SELECT codPersona, tipoPersona, tipoDocumento, numeroDocumento, ruc, razonSocial,
				nombres, apellidoPaterno, apellidoMaterno, direccion, correo, telefono, celular,
				perfilCliente, clasificacionCliente, frecuenciaCliente, tipoListaPrecio, codRuta,
				ordenAtencion, codUbigeo, coordenadaX, coordenadaY
				FROM v_listar_clientes
				WHERE nombreCompleto LIKE '%' + @p_nombres + '%' OR razonSocial LIKE '%' + @p_nombres + '%';
			END	

			SELECT @cod as 'p.codPersona', @tper as 'p.tipoPersona', @perfil as 'c.perfilCliente', @tdoc as 'p.tipoDocumento', @ndoc as 'p.numeroDocumento', @ruc as 'p.ruc', 
			@rSocial as 'p.razonSocial', @nomb as 'p.nombres', @apellPaterno as 'p.apellidoPaterno', @apellMaterno as 'apellidoMaterno',
			@direccion as 'p.direccion', @correo as 'p.correo', @telefono as 'p.telefono', @celular as 'p.celular',
			@perfil as 'c.perfilCliente', @clasificacion as 'clasificacionCliente', @frecuencia as 'c.frecuenciaCliente', @tipolistaPrecio as 'c.tipoListaPrecio',
			@codRuta as 'c.codRuta', @ordenAtencion as 'c.ordenAtencion', @ubigeoDomicilio as 'p.codUbigeo',@coordenadaX as 'l.coordenadaX', @coordenadaX as 'l.coordenadaY',@flag as 'flag' , @msje as 'msje'

		END TRY
		BEGIN CATCH

			SET @flag = ERROR_NUMBER();
			SET @msje = 'Error en pa_listar_clientes ' + ERROR_MESSAGE();

			SELECT @cod as 'p.codPersona', @tper as 'p.tipoPersona', @perfil as 'c.perfilCliente', @tdoc as 'p.tipoDocumento', @ndoc as 'p.numeroDocumento', @ruc as 'p.ruc', 
			@rSocial as 'p.razonSocial', @nomb as 'p.nombres', @apellPaterno as 'p.apellidoPaterno', @apellMaterno as 'apellidoMaterno',
			@direccion as 'p.direccion', @correo as 'p.correo', @telefono as 'p.telefono', @celular as 'p.celular',
			@perfil as 'c.perfilCliente', @clasificacion as 'clasificacionCliente', @frecuencia as 'c.frecuenciaCliente', @tipolistaPrecio as 'c.tipoListaPrecio',
			@codRuta as 'c.codRuta', @ordenAtencion as 'c.ordenAtencion', @ubigeoDomicilio as 'p.codUbigeo',@coordenadaX as 'l.coordenadaX', @coordenadaY as 'l.coordenadaY', @flag as 'flag' , @msje as 'msje'

		END CATCH

END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_listar_puntosEntrega_Cliente' AND type = 'P')
	DROP PROCEDURE pa_listar_puntosEntrega_Cliente
GO
----------------------------------------------------------------------------------
-- Author: Jonathan Macalupu S. IDE-SOLUTION
-- Created: 06/01/2020  
-- Sistema: Sistema Distribuidora Virgen del Carmen
-- Modulo: General
-- Descripci�n: Listar puntos de entrega del cliente 
-----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[pa_listar_puntosEntrega_Cliente]	
(
	@p_codPersona INT   --Codigo de persona
)

AS
	BEGIN
	SET NOCOUNT ON
		DECLARE @ntraPuntoEntrega INT -- numero de transaccion
		DECLARE @UbigeoPuntoEntega CHAR(6) -- ubigeo del punto de entrega
		DECLARE @direccion VARCHAR(200) -- direccion del punto de entrega
		DECLARE @referencia VARCHAR(200) -- referencia
		DECLARE @ordenEntrega SMALLINT; -- Orden de entrega

		DECLARE @flag INT;					-- flag de proceso
		DECLARE @msje VARCHAR(250);			-- mensaje de error
	
		BEGIN TRY		

			SET @ntraPuntoEntrega = 0
			SET @UbigeoPuntoEntega = '' 
			SET @direccion = ''
			SET @referencia = ''
			SET @ordenEntrega = 0 
			SET @flag = 0;
			SET @msje = 'Exito'

			SELECT ntraPuntoEntrega, codUbigeo, coordenadaX, coordenadaY, direccion, referencia, ordenEntrega
			FROM tblPuntoEntrega
			WHERE codPersona = @p_codPersona AND marcaBaja = 0 
			ORDER BY fechaProceso, horaProceso;
		

			SELECT @ntraPuntoEntrega as 'ntraPuntoEntrega', @UbigeoPuntoEntega  as 'codUbigeo', @direccion as 'direccion', @referencia as 'referencia', 
			@ordenEntrega as 'ordenEntrega', @flag as 'flag' , @msje as 'msje'

		END TRY
		BEGIN CATCH
			SET @flag = ERROR_NUMBER();
			SET @msje = 'Error en pa_listar_puntosEntrega_Cliente ' + ERROR_MESSAGE();

			SELECT @ntraPuntoEntrega as 'ntraPuntoEntrega', @UbigeoPuntoEntega  as 'codUbigeo', @direccion as 'direccion', @referencia as 'referencia', 
			@ordenEntrega as 'ordenEntrega', @flag as 'flag' , @msje as 'msje'

		END CATCH

END
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_registrar_modificar_punto_entrega' AND type = 'P')
	DROP PROCEDURE pa_registrar_modificar_punto_entrega
GO
----------------------------------------------------------------------------------
-- Author: Jonathan Macalupu S. IDE-SOLUTION
-- Created: 30/01/2020
-- Sistema: 
-- Descripci�n: Registrar y Eliminar punto de entrega (Eliminacion logica)
-- Log Modificaciones:
-- CODIGO NOMBRE FECHA MOTIVO
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[pa_registrar_modificar_punto_entrega]
(
	@p_proceso TINYINT,					--proceso 1:registro 2:modificacion
	@p_ntra INT,                        --Numero de trasaccion del punto de entrega
	@p_coordenadaX VARCHAR(100),		--coordenada x
	@p_coordenadaY VARCHAR(100),		--coordenada y
	@p_codUbigeo CHAR(6),				--codigo de ubigeo
	@p_direccion VARCHAR(200),			--codigo punto de entrega
	@p_referencia VARCHAR(200),			--referencia
	@p_ordenEntrega SMALLINT,			--orden entrega
	@p_codPersona INT,					--codigo persona
	@p_usuario VARCHAR(20),				--usuario
	@p_ip VARCHAR(20),					--direccion ip
	@p_mac VARCHAR(20)					--mac
)
AS
BEGIN

	SET NOCOUNT ON;
	DECLARE @flag INT;						--flag de proceso
	DECLARE @msje VARCHAR(250);				--mensaje de error
	DECLARE @ntra INT;						--numero de transaccion

	SET @flag = 0;
	SET @msje = 'Exito';
	SET @ntra = 0;

	BEGIN TRY
		IF(@p_proceso = 1)		--proceso registro
		BEGIN
			BEGIN TRANSACTION
				INSERT INTO tblPuntoEntrega (coordenadaX, coordenadaY, codUbigeo, direccion, referencia, ordenEntrega,
				codPersona, usuario, ip, mac)
				VALUES(@p_coordenadaX, @p_coordenadaY, @p_codUbigeo, @p_direccion, @p_referencia, @p_ordenEntrega,
				@p_codPersona, @p_usuario, @p_ip, @p_mac);
				
				SET @ntra = (SELECT @@IDENTITY)
			COMMIT TRANSACTION
		END
		ELSE
		BEGIN
	    IF(@p_proceso = 2) --proceso eliminacion logica
			BEGIN
				BEGIN TRANSACTION
					UPDATE tblPuntoEntrega SET marcaBaja = 9
					WHERE ntraPuntoEntrega = @p_ntra;
				COMMIT TRANSACTION
			END
		END

		SELECT @flag as flag , @msje as msje, @ntra as ntraPuntoEntrega
		
	END TRY
	BEGIN CATCH
	
		IF (XACT_STATE()) <> 0 
		BEGIN
			ROLLBACK TRANSACTION
		END
		SET @flag = ERROR_NUMBER();
		SET @msje = 'Error en pa_registrar_modificar_punto_entrega ' + ERROR_MESSAGE();
		SELECT @flag as flag , @msje as msje, @ntra as ntraPuntoEntrega
		
	END CATCH
END
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_listar_preventa_campos_x_flag' AND type = 'P')
	DROP PROCEDURE pa_listar_preventa_campos_x_flag
GO
----------------------------------------------------------------------------------
-- Author: Diego Sanchez IDE-SOLUTION
-- Created: 10/03/2020  
-- Sistema: Sistema Distribuidora Virgen del Carmen.
-- Descripción: lista de campos para los filtros de las preventas
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[pa_listar_preventa_campos_x_flag]
@flag int
AS
BEGIN
	IF @flag = 1 --obtener lista de vendedores
	SELECT usr.ntraUsuario as codigo, CONCAT(per.nombres,' ', per.apellidoPaterno,' ',per.apellidoMaterno) as descripcion FROM tblUsuario usr
    INNER JOIN tblPersona per on usr.codPersona = per.codPersona
	WHERE usr.codPerfil = 1 and usr.marcaBaja = 0;

	IF @flag = 2 --obtener lista de cliente
		select cli.codPersona as codigo, 
		CASE
		WHEN per.tipoPersona = 1 THEN CONCAT(per.nombres,' ', per.apellidoPaterno,' ',per.apellidoMaterno)
		WHEN per.tipoPersona = 2 THEN per.razonSocial
		END as descripcion
		from tblCliente cli	inner join tblPersona per on per.codPersona = cli.codPersona where cli.marcaBaja = 0 and per.marcaBaja=0;

	IF @flag = 3 --obtener lista de rutas
		SELECT ntraRutas as codigo, concat(pseudonimo,'  -  ',descripcion) as descripcion FROM tblRutas
		WHERE marcaBaja = 0;

	IF @flag = 4 --obtener lista de productos
		select codProducto as codigo, CONCAT(codProducto, '  ' ,descripcion) as descripcion from tblProducto
		WHERE marcaBaja = 0;

	IF @flag = 5 --obtener lista de proveedores
		select ntraProveedor as codigo, CONCAT(abreviatura, '   ', descripcion) as descripcion from tblProveedor
		where marcaBaja = 0;
	
	IF @flag = 6 --PROODUCTOS SOLO PARA VENTA
		select codProducto as codigo, descripcion from tblProducto where tipoProducto = 1 and flagVenta = 1 and marcaBaja=0

	IF @flag = 7 --obtener lista de productos + no venta
		select codProducto as codigo, descripcion from tblProducto
		WHERE marcaBaja = 0;

	IF @flag = 8 --obtener lista ciudades de los clientes (importadora)
		BEGIN
		SELECT DISTINCT p.codUbigeo  AS codigo, d.nombre AS descripcion FROM tblCliente c
		inner join tblPersona p ON p.codPersona = c.codPersona
		inner join tblDistrito d ON d.ubigeo = p.codUbigeo;
		END

	IF @flag = 9 --estados de stock minimo
		select correlativo as codigo, descripcion from tblConcepto where codConcepto = 34 and correlativo > 0 and marcaBaja = 0;

END
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_listar_preventa_detalle' AND type = 'P')
	DROP PROCEDURE pa_listar_preventa_detalle
GO
----------------------------------------------------------------------------------
-- Author: Diego Sanchez IDE-SOLUTION
-- Created: 15/03/2020  
-- Sistema: Sistema Distribuidora Virgen del Carmen.
-- Descripción: Traer lista de detale de la preventa
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[pa_listar_preventa_detalle]
@npreventa int
as
BEGIN
select  dpre.itemPreventa as item, dpre.codProducto,pro.descripcion, dpre.cantidadPresentacion as cantidad,dpre.cantidadUnidadBase,
alm.descripcion as descAlmacen, dpre.codAlmacen, unb.descripcion as um, dpre.codPresentacion as codUnidad, 
tpr.descripcion as tipo, dpre.TipoProducto as codTipo, dpre.precioVenta as precio, ISNULL(dpd.importe,0) as descuento, 
ISNULL(dpd.codDescuento,0) as codDec, ISNULL(dpp.codPromocion,0) as codPro,  ISNULL(dto.descripcion,'') as descrDesc,
ISNULL(pmo.descripcion,'') as descrPro, ISNULL(detpro.valorInicial,'') as codProdPrincipal, 
ISNULL(dpp.itemPreventa,0) as itempreventa
from tblDetallePreventa dpre
inner join tblProducto pro on pro.codProducto = dpre.codProducto
left join tblPreventaDescuento dpd on dpd.codPreventa = dpre.codPreventa and dpd.itemPreventa = dpre.itemPreventa
left join tblDescuentos dto on dto.ntraDescuento = dpd.codDescuento
left join tblPreventaPromocion dpp on dpp.codPreventa = dpre.codPreventa and dpp.itemPromocionado = dpre.itemPreventa
left join tblPromociones pmo on pmo.ntraPromocion = dpp.codPromocion
left join tblDetallePromociones detpro on detpro.ntraPromocion = pmo.ntraPromocion and detpro.flag=1
inner join tblAlmacen alm on dpre.codAlmacen=alm.ntraAlmacen
inner join (select correlativo, descripcion from tblConcepto where codConcepto = 12 and marcaBaja = 0)
as unb on dpre.codPresentacion = unb.correlativo
inner join (select correlativo, descripcion from tblConcepto where codConcepto = 22 and marcaBaja = 0)
as tpr on dpre.TipoProducto = tpr.correlativo
where dpre.codPreventa = @npreventa  and dpre.marcaBaja = 0
order by dpre.itemPreventa;
END
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_listar_preventa_filtros' AND type = 'P')
	DROP PROCEDURE pa_listar_preventa_filtros
GO
----------------------------------------------------------------------------------
-- Author: Diego Sanchez IDE-SOLUTION
-- Created: 10/03/2020  
-- Sistema: Sistema Distribuidora Virgen del Carmen.
-- Descripci�n: Traer lista de preventa por filtros
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[pa_listar_preventa_filtros]
@ntraPreventa int, --numero de preventa
@codUsuario int,	--codigo del vendedor
@codCliente int,	--codigo del cliente
@estado int,	--estado de la preventa
@codTipo_venta int,	--codigo tipo de venta
@codTipo_doc int,	--codigo tipo de venta
@codOrigen_venta int, --codigo origen de venta
@codRuta int, --codigo de ruta
@codProveedor int, --codigo del proveedor
@codProducto varchar(10),--sku del producto
@codfechaEntregaI date,	--fecha de entrega inicial
@codfechaEntregaF date,	--fecha de entrega final
@codfechaRegistroI date,	--fecha de registro inicial
@codfechaRegistroF date		--fecha de registro final

AS
BEGIN
	declare @csql nvarchar(1000) --consulta sql
	declare @diasMax int	--dias maximo
	declare @fecha1 date
	declare @fecha2 date
	set @fecha1 = @codfechaRegistroI
	set @fecha2 = @codfechaRegistroF
	select @diasMax = valorEntero1 from tblDetalleParametro where codParametro = 7;

	if @fecha1 = '' and @fecha2 = ''
	begin
		set @fecha2 = GETDATE()
		set @fecha1 = DATEADD(DAY,-@diasMax,@fecha2)
	end

	set @csql = 'select distinct ntraPreventa, vendedor, tipoPersona, cliente, identificacion, ruta, direccion, tVenta, tDoc, oVenta, estPre, fecha, fechaEntrega,'+
				' recargo, igv, moneda, total, estado, sucursal, codUbigeo, codUsuario, codCliente, codPuntoEntrega from v_preventa_filtros_web where 1=1 '

	if @ntraPreventa != 0
		set @csql = @csql + ' and ntraPreventa = ' + convert(varchar, @ntraPreventa)
	if @codUsuario != 0
		set @csql = @csql + ' and codUsuario = ' + convert(varchar, @codUsuario)
	if @codCliente != 0
		set @csql = @csql + ' and codCliente = ' + convert(varchar, @codCliente)
	if @estado != 0
		set @csql = @csql + ' and estado = ' + convert(varchar, @estado)
	if @codTipo_venta != 0
		set @csql = @csql + ' and tipoVenta = ' + convert(varchar, @codTipo_venta)
	if @codTipo_doc != 0
		set @csql = @csql + ' and tipoDocumentoVenta = ' + convert(varchar, @codTipo_doc)
	if @codOrigen_venta != 0
		set @csql = @csql + ' and origenVenta = ' + convert(varchar, @codOrigen_venta)
	if @codRuta != 0
		set @csql = @csql + ' and ntraRutas = ' + convert(varchar, @codRuta)
	if @codProveedor != 0
		set @csql = @csql + ' and codProveedor = ' + convert(varchar, @codProveedor)
	if @codProducto != ''
		set @csql = @csql + ' and codProducto = ''' + convert(varchar, @codProducto) + ''''
	if @fecha1 != '' and @fecha2 != ''
		set @csql = @csql+' and fecha BETWEEN ''' + convert(varchar, @fecha1)+''''+' and '''+convert(varchar, @fecha2)+''''
	if @codfechaEntregaI != '' and @codfechaEntregaF != ''
		set @csql = @csql+' and fechaEntrega BETWEEN ''' + convert(varchar, @codfechaEntregaI)+''''+' and '''+convert(varchar, @codfechaEntregaF)+''''
			
	EXEC (@csql)
	--select @csql

END
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_validar_preventa_fechaR' AND type = 'P')
	DROP PROCEDURE pa_validar_preventa_fechaR
GO
----------------------------------------------------------------------------------
-- Author: Diego Sanchez IDE-SOLUTION
-- Created: 20/03/2020  
-- Sistema: Sistema Distribuidora Virgen del Carmen.
-- Descripci�n: Validar cantidad de dias maximo en la fecha de registro de la preventa
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[pa_validar_preventa_fechaR]
@codfechaRegistroI date,
@codfechaRegistroF date
AS
BEGIN
	DECLARE @diasMax SMALLINT -- valor 0-- Contador de usuario activo
	declare @fecha1 date
	declare @fecha2 date
	declare @diferencia int
	declare @msj varchar(50)
	declare @resp int
	set @fecha1 = @codfechaRegistroI
	set @fecha2 = @codfechaRegistroF
	select @diasMax = valorEntero1 from tblDetalleParametro where codParametro = 7;

	set @diferencia = DATEDIFF(DAY,@fecha1,@fecha2)
		
	if @diferencia > @diasMax
		begin
		set @resp = 0 ;
		set @msj = 'El rango de fechas maximo es de '+ Convert(varchar,@diasMax) +' dias';
		end
	else
		begin
		set @resp = 1 ;
		set @msj = 'ok';
		end

	select @resp as codMsj, @msj as mensaje;
END
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_obtener_descripcion_ubigeo' AND type = 'P')
	DROP PROCEDURE pa_obtener_descripcion_ubigeo
GO
----------------------------------------------------------------------------------
-- Author: Diego Sanchez IDE-SOLUTION
-- Created: 23/03/2020  
-- Sistema: Sistema Distribuidora Virgen del Carmen.
-- Descripci�n: Obtener la descripcion del ubigeo
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[pa_obtener_descripcion_ubigeo]
@codUbigeo char(6)
AS
BEGIN

DECLARE @depa char(2)
DECLARE @prov char(2)
DECLARE @dist char(2)
DECLARE @departamento varchar(50)
DECLARE @provincia varchar(50)
DECLARE @distrito varchar(50)

set @depa = SUBSTRING(@codUbigeo,1,2);
set @prov = SUBSTRING(@codUbigeo,3,2);
set @dist = SUBSTRING(@codUbigeo,5,2);

select @departamento = nombre from tblDepartamento where codDepartamento = @depa and marcaBaja = 0 
select @provincia = nombre from tblProvincia where codDepartamento = @depa and codProvincia = @prov and marcaBaja = 0 
select @distrito = nombre from tblDistrito where codDepartamento = @depa and codProvincia = @prov and codDistrito = @dist and marcaBaja = 0;

select @codUbigeo as codigo, concat(@departamento,' - ', @provincia, ' - ', @distrito) as descripcion

END
GO


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
GO


IF EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_preventa_almacenes_producto' AND type = 'P')
DROP PROCEDURE pa_preventa_almacenes_producto
GO
----------------------------------------------------------------------------------
-- Author: Alex Llamo IDE-SOLUTION
-- Created: 10/03/2020
-- Sistema: VirgenDelCarmenMantenedor
-- Descripcion: obtener almacenes de producto
-- Log Modificaciones:
-- CODIGO NOMBRE FECHA MOTIVO
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_preventa_almacenes_producto
(
	@p_codProducto VARCHAR(50)		--codigo producto
)
AS
BEGIN
	SET NOCOUNT ON;
	--DECLARE @flag INT;				--flag de proceso
	--DECLARE @msje VARCHAR(100);		--mensaje
	
	BEGIN TRY
		select alm.ntraAlmacen as 'codAlmacen', alm.descripcion as 'descripcion', inv.stock as 'stock'
		FROM tblAlmacen alm INNER JOIN tblInventario inv ON alm.ntraAlmacen = inv.codAlmacen
		WHERE inv.codProducto = @p_codProducto AND inv.stock > 0
		AND alm.marcaBaja = 0 AND inv.marcaBaja = 0
	
	END TRY

	BEGIN CATCH
		SELECT ERROR_NUMBER() as 'codAlmacen', 'Error en pa_preventa_almacenes_producto ' + ERROR_MESSAGE() as 'descripcion', 0 as 'stock'
	END CATCH
END
GO

IF EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_preventa_buscar_cliente' AND type = 'P')
DROP PROCEDURE pa_preventa_buscar_cliente
GO
----------------------------------------------------------------------------------
-- Author: Alex Llamo IDE-SOLUTION
-- Created: 09/03/2020
-- Sistema: ws_wa_DistribuidoraVDC
-- Descripcion: Buscar cliente preventa
-- Log Modificaciones:
-- CODIGO NOMBRE FECHA MOTIVO
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_preventa_buscar_cliente
(
	/*@p_flag INT,			--flag
	@p_codCliente INT,		--codigo cliente
	@p_nombres VARCHAR(30)			--nombres*/
	@p_cadena VARCHAR(50)			--cadena
)
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN TRY
		SELECT codPersona as codCliente, nombres, tipoListaPrecio, numDocumento
		FROM v_preventa_listar_clientes
		WHERE concatenado LIKE '%'+ RTRIM(LTRIM(@p_cadena)) + '%'

	/*IF(@p_flag = 1)
		BEGIN
		

			SELECT p.codPersona as 'codCliente', (CASE WHEN (p.tipoPersona) = 2 THEN UPPER(p.razonSocial) ELSE UPPER(p.apellidoPaterno + ' ' + p.apellidoMaterno + ' ' + p.nombres) END) AS 'nombres', 
			c.tipoListaPrecio as 'tipoListaPrecio'
			FROM tblPersona p INNER JOIN tblCliente c ON p.codPersona = c.codPersona
			WHERE CAST(p.codPersona AS varchar(12)) LIKE '%'+ CAST(@p_codCliente AS varchar(12)) + '%'
		
		END
	ELSE
		BEGIN
			SELECT p.codPersona as 'codCliente', (CASE WHEN (p.tipoPersona) = 2 THEN UPPER(p.razonSocial) ELSE UPPER(p.apellidoPaterno + ' ' + p.apellidoMaterno + ' ' + p.nombres) END) AS 'nombres', 
			c.tipoListaPrecio as 'tipoListaPrecio'
			FROM tblPersona p INNER JOIN tblCliente c ON p.codPersona = c.codPersona
			WHERE p.apellidoPaterno like '%'+ @p_nombres + '%' OR p.apellidoMaterno like '%'+ @p_nombres + '%'
			OR p.nombres like '%'+ @p_nombres + '%' OR p.razonSocial like '%'+ @p_nombres + '%'
		END*/
	
	END TRY

	BEGIN CATCH
		SELECT ERROR_NUMBER() as 'codCliente', 'Error en pa_preventa_buscar_cliente ' + ERROR_MESSAGE() as 'nombres', 1 as 'tipoListaPrecio', '' as 'numDocumento'
	END CATCH
END
GO

IF EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_preventa_buscar_producto' AND type = 'P')
DROP PROCEDURE pa_preventa_buscar_producto
GO
----------------------------------------------------------------------------------
-- Author: Alex Llamo IDE-SOLUTION
-- Created: 09/03/2020
-- Sistema: ws_wa_DistribuidoraVDC
-- Descripcion: Buscar producto preventa
-- Log Modificaciones:
-- CODIGO NOMBRE FECHA MOTIVO
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_preventa_buscar_producto
(
	@p_cadena VARCHAR(50)			--cadena
)
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN TRY
		SELECT codProducto, descripcion
		FROM v_preventa_listar_productos
		WHERE concatenado LIKE '%'+ RTRIM(LTRIM(@p_cadena)) + '%'
	
	END TRY

	BEGIN CATCH
		SELECT ERROR_NUMBER() as 'codProducto', 'Error en pa_preventa_buscar_producto ' + ERROR_MESSAGE() as 'descripcion'
	END CATCH
END
GO

IF EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_preventa_descuentos' AND type = 'P')
DROP PROCEDURE pa_preventa_descuentos
GO
----------------------------------------------------------------------------------
-- Author: Alex Llamo IDE-SOLUTION
-- Created: 10/03/2020
-- Sistema: VirgenDelCarmenMantenedor
-- Descripcion: obtener descuentos vigentes de un producto
-- Log Modificaciones:
-- CODIGO NOMBRE FECHA MOTIVO
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_preventa_descuentos
(
	@p_codProducto VARCHAR(15), --codigo de producto
	@p_codCliente INT,			--codigo cliente
	@p_codUsuario INT,			--codigo vendedor
	@p_tipoVenta INT,			--tipo venta
	@p_tipoDescuento INT		--tipo descuento
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @ntraDescuento INT;				--ntra promocion
	DECLARE @descDescuento VARCHAR(200);	--descripcion de promocion
	DECLARE @cont INT;						--contador
	DECLARE @flag INT;						--flag proceso
	DECLARE @valorCadena VARCHAR(50);		--cadena
	DECLARE @valorEntero INT;				--entero
	DECLARE @contador INT;				--entero

	DECLARE @tipoDescuento INT;				--tipo descuento
	DECLARE @valorDescuento MONEY;			--valoor descuento

	SET @ntraDescuento = 0;
	SET @descDescuento = '';
	SET @cont = 0;
	SET @flag = 0;
	SET @valorCadena = '';
	SET @valorEntero = 0;
	SET @contador = 0;

	BEGIN TRY
		DECLARE cur_dsctos CURSOR LOCAL STATIC READ_ONLY FORWARD_ONLY FOR 
		SELECT d.ntraDescuento, d.descripcion
		FROM tblDescuentos d INNER JOIN tblDetalleDescuentos dd ON d.ntraDescuento = dd.ntraDescuento
		WHERE (SELECT CONVERT (date, GETDATE(), 5) ) BETWEEN d.fechaInicial AND d.fechaFin 
		AND (select convert(char(8), getdate(), 108) as [hh:mm:ss]) BETWEEN d.horaInicial AND d.horaFin
		AND dd.valorInicial = @p_codProducto
		AND dd.flag = 1 AND d.tipoDescuento = @p_tipoDescuento AND d.estado = 1 AND dd.estado = 1 AND d.marcaBaja = 0 AND dd.marcaBaja = 0
		OPEN cur_dsctos;  
		FETCH NEXT FROM cur_dsctos INTO @ntraDescuento, @descDescuento
		WHILE @@FETCH_STATUS = 0
			BEGIN
				--FLAG 4 VENDEDOR QUE APLICA A LA PROMOCION
				SET @cont = 0;
				SELECT @cont = COUNT(ntraDescuento) FROM tblDetalleDescuentos
				WHERE ntraDescuento = @ntraDescuento AND flag = 4 AND estado = 1 AND marcaBaja = 0;
				IF(@cont > 0)
				BEGIN
					SET @valorEntero = 0;
					SELECT @valorEntero = COUNT(valorInicial)
					FROM tblDetalleDescuentos
					WHERE ntraDescuento = @ntraDescuento AND valorInicial = @p_codUsuario AND flag = 4 AND estado = 1 AND marcaBaja = 0;
					IF(@valorEntero = 0)
					BEGIN
						SET @flag = 1;
					END
				END
				
				--FLAG 5 CLIENTE QUE APLICA A LA PROMOCION
				IF (@flag = 0)
				BEGIN 
					SET @cont = 0;
					SELECT @cont = COUNT(ntraDescuento) FROM tblDetalleDescuentos
					WHERE ntraDescuento = @ntraDescuento AND flag = 5 AND estado = 1 AND marcaBaja = 0;
					IF(@cont > 0)
					BEGIN
						SET @valorEntero = 0;
						SELECT @valorEntero = COUNT(valorInicial)
						FROM tblDetalleDescuentos
						WHERE ntraDescuento = @ntraDescuento AND valorInicial = @p_codCliente AND flag = 5 AND estado = 1 AND marcaBaja = 0;
						IF(@valorEntero = 0)
						BEGIN
							SET @flag = 1;
						END
					END
				END 
				
				--FLAG 6 VECES QUE SE PUEDE USAR EL DESCUENTO
				IF (@flag = 0)
				BEGIN 
					SET @cont = 0;
					SELECT @cont = COUNT(ntraDescuento) FROM tblDetalleDescuentos
					WHERE ntraDescuento = @ntraDescuento AND flag = 6 AND estado = 1 AND marcaBaja = 0;
					IF(@cont > 0)
					BEGIN
						SET @valorEntero = 0;
						SET @contador = 0;
						SELECT @contador = COUNT(DISTINCT(dsc.codPreventa)) 
						FROM tblPreventaDescuento dsc INNER JOIN tblPreventa pre ON dsc.codPreventa = pre.ntraPreventa
						WHERE pre.estado != 2 AND dsc.codDescuento = @ntraDescuento AND dsc.marcaBaja = 0 AND pre.marcaBaja = 0;

						SELECT @valorEntero = valorInicial
						FROM tblDetalleDescuentos
						WHERE ntraDescuento = @ntraDescuento AND flag = 6 AND estado = 1 AND marcaBaja = 0;
						IF(@contador > @valorEntero)
						BEGIN
							SET @flag = 1;
						END
					END
				END
				
				--FLAG 7 VECES QUE UN VENDEDOR PUEDE USAR EL DESCUENTO
				IF (@flag = 0)
				BEGIN 
					SET @cont = 0;
					SELECT @cont = COUNT(ntraDescuento) FROM tblDetalleDescuentos
					WHERE ntraDescuento = @ntraDescuento AND flag = 7 AND estado = 1 AND marcaBaja = 0;
					IF(@cont > 0)
					BEGIN
						SET @valorEntero = 0;
						SET @contador = 0;
						SELECT @contador = COUNT(DISTINCT(codPreventa))
						FROM tblPreventaDescuento dsc INNER JOIN tblPreventa pre ON dsc.codPreventa = pre.ntraPreventa
						WHERE pre.estado != 2 AND dsc.codDescuento = @ntraDescuento and pre.codUsuario = @p_codUsuario 
						AND dsc.marcaBaja = 0 AND pre.marcaBaja = 0;

						SELECT @valorEntero = valorInicial
						FROM tblDetalleDescuentos
						WHERE ntraDescuento = @ntraDescuento AND flag = 7 AND estado = 1 AND marcaBaja = 0;
						IF(@contador > @valorEntero)
						BEGIN
							SET @flag = 1;
						END
					END
				END
				
				--FLAG 8 VECES QUE UN CLIENTE PUEDE USAR EL DESCUENTO
				IF (@flag = 0)
				BEGIN 
					SET @cont = 0;
					SELECT @cont = COUNT(ntraDescuento) FROM tblDetalleDescuentos
					WHERE ntraDescuento = @ntraDescuento AND flag = 8 AND estado = 1 AND marcaBaja = 0;
					IF(@cont > 0)
					BEGIN
						SET @valorEntero = 0;
						SET @contador = 0;
						SELECT @contador = COUNT(DISTINCT(codPreventa))
						FROM tblPreventaDescuento dsc 
						INNER JOIN tblPreventa pre ON dsc.codPreventa = pre.ntraPreventa 
						WHERE pre.estado != 2 AND dsc.codDescuento = @ntraDescuento and pre.codCliente = @p_codCliente
						AND dsc.marcaBaja = 0 AND pre.marcaBaja = 0;

						SELECT @valorEntero = valorInicial
						FROM tblDetalleDescuentos
						WHERE ntraDescuento = @ntraDescuento AND flag = 8 AND estado = 1 AND marcaBaja = 0;
						IF(@contador > @valorEntero)
						BEGIN
							SET @flag = 1;
						END
					END
				END
				
				--FLAG 10 PROMOCION PARA VENTA AL CONTADO O CREDITO
				IF (@flag = 0)
				BEGIN
					SET @cont = 0;
					SELECT @cont = COUNT(ntraDescuento) FROM tblDetalleDescuentos
					WHERE ntraDescuento = @ntraDescuento AND flag = 10 AND estado = 1 AND marcaBaja = 0;
					IF(@cont > 0)
					BEGIN
						SET @valorEntero = 0;
						SELECT @valorEntero = COUNT(valorInicial)
						FROM tblDetalleDescuentos
						WHERE ntraDescuento = @ntraDescuento AND valorInicial = @p_tipoVenta AND flag = 10 AND estado = 1 AND marcaBaja = 0;
						IF(@valorEntero = 0)
						BEGIN
							SET @flag = 1;
						END
					END
				END


				IF (@flag = 0)
				BEGIN
					SELECT @valorDescuento = valorInicial, @tipoDescuento = valorFinal
					FROM tblDetalleDescuentos
					WHERE ntraDescuento = @ntraDescuento AND flag = 3 AND estado = 1 AND marcaBaja = 0;

					SELECT @ntraDescuento as ntraDescuento, @descDescuento as descDescuento, valorInicial as valor, valorFinal as tipo,
					@valorDescuento as valorDescuento, @tipoDescuento as tipoDescuento
					FROM tblDetalleDescuentos
					WHERE ntraDescuento = @ntraDescuento AND flag = 2 AND estado = 1 AND marcaBaja = 0;
				END
					

				SET @flag = 0;
				FETCH NEXT FROM cur_dsctos INTO @ntraDescuento, @descDescuento;
			END
		CLOSE cur_dsctos;  
		DEALLOCATE cur_dsctos;
	
	END TRY

	BEGIN CATCH
		SELECT ERROR_NUMBER() as 'ntraDescuento', 'Error en pa_preventa_descuentos ' + ERROR_MESSAGE() as 'descDescuento', 0 as 'valor', 0 as 'tipo',
		0 as 'valorDescuento', 0 as 'tipoDescuento'
	END CATCH
END
GO

IF EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_preventa_listar_puntos_entrega' AND type = 'P')
DROP PROCEDURE pa_preventa_listar_puntos_entrega
GO
----------------------------------------------------------------------------------
-- Author: Alex Llamo IDE-SOLUTION
-- Created: 10/03/2020
-- Sistema: VirgenDelCarmenMantenedor
-- Descripcion: Listar puntos de entrega de cliente
-- Log Modificaciones:
-- CODIGO NOMBRE FECHA MOTIVO
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_preventa_listar_puntos_entrega
(
	@p_codcliente INT		--codigo de persona
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @flag INT;				--flag de proceso
	DECLARE @msje VARCHAR(100);		--mensaje

	--SET @flag = 0;
	--SET @msje = 'EXITO';
	
	BEGIN TRY
		SELECT ntraPuntoEntrega as 'codPuntoEntrega', direccion as 'descripcion'
		FROM tblPuntoEntrega
		WHERE codPersona = @p_codcliente AND marcaBaja = 0
	
	END TRY

	BEGIN CATCH
		--SET @flag = 0;
		--SET @msje = 'EXITO';
		SELECT ERROR_NUMBER() as 'codPuntoEntrega', 'Error en pa_preventa_listar_puntos_entrega ' + ERROR_MESSAGE() as 'descripcion'
	END CATCH
END
GO

IF EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_preventa_parametros' AND type = 'P')
DROP PROCEDURE pa_preventa_parametros
GO
----------------------------------------------------------------------------------
-- Author: Alex Llamo IDE-SOLUTION
-- Created: 10/03/2020
-- Sistema: VirgenDelCarmenMantenedor
-- Descripcion: obtener parametros preventa
-- Log Modificaciones:
-- CODIGO NOMBRE FECHA MOTIVO
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_preventa_parametros
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @flag INT;				--flag de proceso
	DECLARE @msje VARCHAR(100);		--mensaje
	DECLARE @porcentajeRecargo MONEY;
	DECLARE @igv MONEY;
	DECLARE @flagRecargo INT;

	SET @flag = 0;
	SET @msje = 'EXITO';
	SET @porcentajeRecargo = 0;
	SET @igv = 0;
	SET @flagRecargo = 0;
	
	
	BEGIN TRY
		
		-- porcentaje recargo
		SELECT @porcentajeRecargo = valorMoneda1 FROM tblDetalleParametro 
		WHERE codParametro = 1 AND marcaBaja = 0;

		-- igv
		SELECT @igv = valorMoneda1 FROM tblDetalleParametro 
		WHERE codParametro = 2 AND marcaBaja = 0;

		-- flag de uso de recargo
		SELECT @flagRecargo = valorEntero1 FROM tblDetalleParametro 
		WHERE codParametro = 3 AND marcaBaja = 0;

		SELECT @porcentajeRecargo as 'porcentajeRecargo', @igv as 'igv', @flagRecargo as 'flagRecargo', @flag as 'flag', @msje as 'msje'
	
	END TRY

	BEGIN CATCH
		SET @flag = 1;
		SET @msje = 'Error en pa_preventa_parametros ' + ERROR_MESSAGE();
		SELECT ERROR_NUMBER() as 'porcentajeRecargo', 0 as 'igv', 0 as 'flagRecargo', @flag as 'flag', @msje as 'msje'
	END CATCH
END
GO

IF EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_preventa_precio_producto' AND type = 'P')
DROP PROCEDURE pa_preventa_precio_producto
GO
----------------------------------------------------------------------------------
-- Author: Alex Llamo IDE-SOLUTION
-- Created: 10/03/2020
-- Sistema: VirgenDelCarmenMantenedor
-- Descripcion: obtener precio de producto
-- Log Modificaciones:
-- CODIGO NOMBRE FECHA MOTIVO
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_preventa_precio_producto
(
	@p_codProducto VARCHAR(50),		--codigo producto
	@p_tipoListaPrecio INT			--tipo lista precio
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @flag INT;				--flag de proceso
	DECLARE @msje VARCHAR(100);		--mensaje

	SET @flag = 0;
	SET @msje = 'EXITO';
	
	BEGIN TRY
		SELECT pre.precioVenta as 'precioVenta', pro.tipoProducto as 'tipoProducto', @flag as 'flag', @msje as 'msje'
		FROM tblPrecio pre INNER JOIN tblProducto pro ON pre.codProducto = pro.codProducto
		WHERE pre.codProducto = @p_codProducto AND pre.tipoListaPrecio = @p_tipoListaPrecio 
		AND pre.marcaBaja = 0 AND pro.marcaBaja = 0;
	
	END TRY

	BEGIN CATCH
		SET @flag = 1;
		SET @msje = 'Error en pa_preventa_precio_producto ' + ERROR_MESSAGE();
		SELECT ERROR_NUMBER() as 'precioVenta', 0 as 'tipoProducto', @flag as 'flag', @msje as 'msje'
	END CATCH
END
GO

IF EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_preventa_presentacion_producto' AND type = 'P')
DROP PROCEDURE pa_preventa_presentacion_producto
GO
----------------------------------------------------------------------------------
-- Author: Alex Llamo IDE-SOLUTION
-- Created: 10/03/2020
-- Sistema: VirgenDelCarmenMantenedor
-- Descripcion: obtener presentaciones de producto
-- Log Modificaciones:
-- CODIGO NOMBRE FECHA MOTIVO
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_preventa_presentacion_producto
(
	@p_codProducto VARCHAR(50)		--codigo producto
)
AS
BEGIN
	SET NOCOUNT ON;
	--DECLARE @flag INT;				--flag de proceso
	--DECLARE @msje VARCHAR(100);		--mensaje
	
	BEGIN TRY
		SELECT pre.codPresentancion, con.descripcion, pre.cantidadUnidadBase
		FROM tblDetallePresentacion pre INNER JOIN tblConcepto con ON pre.codPresentancion = con.correlativo
		WHERE con.codConcepto = 12 AND pre.codProducto = @p_codProducto AND pre.marcaBaja = 0 AND con.marcaBaja = 0
		ORDER BY codPresentancion ASC
	
	END TRY

	BEGIN CATCH
		SELECT ERROR_NUMBER() as 'codPresentancion', 'Error en pa_preventa_presentacion_producto ' + ERROR_MESSAGE() as 'descripcion', 0 as 'cantidadUnidadBase'
	END CATCH
END
GO

IF EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_preventa_productos_promocion' AND type = 'P')
DROP PROCEDURE pa_preventa_productos_promocion
GO
----------------------------------------------------------------------------------
-- Author: Alex Llamo IDE-SOLUTION
-- Created: 10/03/2020
-- Sistema: VirgenDelCarmenMantenedor
-- Descripcion: obtener productos regalo por acceder a promocion
-- Log Modificaciones:
-- CODIGO NOMBRE FECHA MOTIVO
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_preventa_productos_promocion
(
	@p_ntraPromocion INT		--transaccion promocion
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @valorEntero1 INT;
	DECLARE @valorEntero2 INT;
	DECLARE @valorMoneda1 MONEY;
	DECLARE @valorMoneda2 MONEY;
	DECLARE @valorCadena1 VARCHAR(20);
	DECLARE @valorCadena2 VARCHAR(20);
	DECLARE @valorFecha1  VARCHAR(20);
	DECLARE @valorFecha2  VARCHAR(20);

	SET @valorEntero1 = 0;
	SET @valorEntero2 = 0;
	SET @valorMoneda1 = 0;
	SET @valorMoneda2 = 0;
	SET @valorCadena1 = '';
	SET @valorCadena2 = '';
	SET @valorFecha1  = '';
	SET @valorFecha2  = '';
	
	
	BEGIN TRY
		--DECLARE cur_promos CURSOR LOCAL STATIC READ_ONLY FORWARD_ONLY FOR 
		--SELECT valorEntero1, valorEntero2, valorMoneda1, valorMoneda2, valorCadena1, valorCadena2, valorFecha1, valorFecha2 
		--FROM tblDetalleFlagPromocion 
		--WHERE ntraPromocion = @p_ntraPromocion AND flag = 3 
		--AND estado = 1 AND marcaBaja = 0;
		--OPEN cur_promos;  
		--FETCH NEXT FROM cur_promos INTO @valorEntero1, @valorEntero2, @valorMoneda1, @valorMoneda2, @valorCadena1, @valorCadena2, @valorFecha1, @valorFecha2 
		--WHILE @@FETCH_STATUS = 0
		--	BEGIN
		--		SELECT pro.codUnidadBaseventa as codUnidadBase, con.descripcion as descUnidadBase, pro.descripcion as descProducto, alm.descripcion as descAlmacen,
		--		@valorEntero1 as valorEntero1, @valorEntero2 as valorEntero2, @valorMoneda1 as valorMoneda1, @valorMoneda2 as valorMoneda2, 
		--		@valorCadena1 as valorCadena1, @valorCadena2 as valorCadena2, @valorFecha1 as valorFecha1, @valorFecha2 as valorFecha2
		--		FROM tblProducto pro INNER JOIN tblInventario inv ON pro.codProducto = inv.codProducto 
		--		INNER JOIN tblAlmacen alm ON alm.ntraAlmacen = inv.codAlmacen
		--		INNER JOIN tblConcepto con ON pro.codUnidadBaseventa = con.correlativo
		--		WHERE pro.codProducto = @valorCadena1 AND inv.codAlmacen = @valorEntero2 AND con.codConcepto = 12
		--		AND pro.marcaBaja = 0 AND inv.marcaBaja = 0 AND alm.marcaBaja = 0 AND con.marcaBaja = 0;
		--		FETCH NEXT FROM cur_promos INTO @valorEntero1, @valorEntero2, @valorMoneda1, @valorMoneda2, @valorCadena1, @valorCadena2, @valorFecha1, @valorFecha2 ;
		--	END
		--CLOSE cur_promos;  
		--DEALLOCATE cur_promos;
		SELECT pro.codUnidadBaseventa as codUnidadBase, con.descripcion as descUnidadBase, pro.descripcion as descProducto, alm.descripcion as descAlmacen,
		valorEntero1, valorEntero2, valorMoneda1, valorMoneda2, valorCadena1, valorCadena2, valorFecha1, valorFecha2 
		FROM tblProducto pro INNER JOIN tblInventario inv ON pro.codProducto = inv.codProducto 
		INNER JOIN tblAlmacen alm ON alm.ntraAlmacen = inv.codAlmacen
		INNER JOIN tblConcepto con ON pro.codUnidadBaseventa = con.correlativo
		INNER JOIN tblDetalleFlagPromocion det ON det.valorCadena1 = pro.codProducto
		WHERE det.ntraPromocion = @p_ntraPromocion AND inv.codAlmacen = det.valorEntero2 AND con.codConcepto = 12
		AND pro.marcaBaja = 0 AND inv.marcaBaja = 0 AND alm.marcaBaja = 0 AND con.marcaBaja = 0;

	END TRY

	BEGIN CATCH
		SELECT 
		0 as codUnidadBase, '' as descUnidadBase, '' as descproducto, '' as descAlmacen,
		ERROR_NUMBER() as valorEntero1, 0 as valorEntero2, 0 as valorMoneda1, 
		0 as valorMoneda2, 'Error en pa_preventa_productos_promocion ' + ERROR_MESSAGE() as valorCadena1, 
		'' as valorCadena2, '' as valorFecha1, '' as valorFecha2
	END CATCH
END
GO

IF EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_preventa_promociones' AND type = 'P')
DROP PROCEDURE pa_preventa_promociones
GO
----------------------------------------------------------------------------------
-- Author: Alex Llamo IDE-SOLUTION
-- Created: 10/03/2020
-- Sistema: VirgenDelCarmenMantenedor
-- Descripcion: obtener promociones vigentes de un producto
-- Log Modificaciones:
-- CODIGO NOMBRE FECHA MOTIVO
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_preventa_promociones
(
	@p_codProducto VARCHAR(15), --codigo de producto
	@p_codCliente INT,			--codigo cliente
	@p_codUsuario INT,			--codigo vendedor
	@p_tipoVenta INT			--tipo venta
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @ntraPromocion INT;				--ntra promocion
	DECLARE @descPromocion VARCHAR(200);	--descripcion de promocion
	DECLARE @cont INT;						--contador
	DECLARE @flag INT;						--flag proceso
	DECLARE @valorCadena VARCHAR(50);		--cadena
	DECLARE @valorEntero INT;				--entero
	DECLARE @contador INT;				--entero

	SET @ntraPromocion = 0;
	SET @descPromocion = '';
	SET @cont = 0;
	SET @flag = 0;
	SET @valorCadena = '';
	SET @valorEntero = 0;
	SET @contador = 0;

	BEGIN TRY
		DECLARE cur_promos CURSOR LOCAL STATIC READ_ONLY FORWARD_ONLY FOR 
		SELECT p.ntraPromocion, p.descripcion
		FROM tblPromociones p INNER JOIN tblDetallePromociones dp ON p.ntraPromocion = dp.ntraPromocion
		WHERE (SELECT CONVERT (date, GETDATE(), 5) ) BETWEEN p.fechaInicial AND p.fechaFin 
		AND (select convert(char(8), getdate(), 108) as [hh:mm:ss]) BETWEEN p.horaInicial AND p.horaFin
		AND dp.valorInicial = @p_codProducto
		AND dp.flag = 1 AND p.estado = 1 AND dp.estado = 1 AND p.marcaBaja = 0 AND dp.marcaBaja = 0
		OPEN cur_promos;  
		FETCH NEXT FROM cur_promos INTO @ntraPromocion, @descPromocion
		WHILE @@FETCH_STATUS = 0
			BEGIN
				--FLAG 4 VENDEDOR QUE APLICA A LA PROMOCION
				SET @cont = 0;
				SELECT @cont = COUNT(ntraPromocion) FROM tblDetallePromociones
				WHERE ntraPromocion = @ntraPromocion AND flag = 4 AND estado = 1 AND marcaBaja = 0;
				IF(@cont > 0)
				BEGIN
					SET @valorEntero = 0;
					SELECT @valorEntero = COUNT(valorInicial)
					FROM tblDetallePromociones
					WHERE ntraPromocion = @ntraPromocion AND valorInicial = @p_codUsuario AND flag = 4 AND estado = 1 AND marcaBaja = 0;
					IF(@valorEntero = 0)
					BEGIN
						SET @flag = 1;
					END
				END

				--FLAG 5 CLIENTE QUE APLICA A LA PROMOCION
				IF (@flag = 0)
				BEGIN 
					SET @cont = 0;
					SELECT @cont = COUNT(ntraPromocion) FROM tblDetallePromociones
					WHERE ntraPromocion = @ntraPromocion AND flag = 5 AND estado = 1 AND marcaBaja = 0;
					IF(@cont > 0)
					BEGIN
						SET @valorEntero = 0;
						SELECT @valorEntero = COUNT(valorInicial)
						FROM tblDetallePromociones
						WHERE ntraPromocion = @ntraPromocion AND valorInicial = @p_codCliente AND flag = 5 AND estado = 1 AND marcaBaja = 0;
						IF(@valorEntero = 0)
						BEGIN
							SET @flag = 1;
						END
					END
				END 

				--FLAG 6 VECES QUE SE PUEDE USAR LA PROMOCION
				IF (@flag = 0)
				BEGIN 
					SET @cont = 0;
					SELECT @cont = COUNT(ntraPromocion) FROM tblDetallePromociones
					WHERE ntraPromocion = @ntraPromocion AND flag = 6 AND estado = 1 AND marcaBaja = 0;
					IF(@cont > 0)
					BEGIN
						SET @valorEntero = 0;
						SET @contador = 0;
						SELECT @contador = COUNT(DISTINCT(pro.codPreventa)) 
						FROM tblPreventaPromocion pro INNER JOIN tblPreventa pre ON pro.codPreventa = pre.ntraPreventa
						WHERE pre.estado != 2 AND pro.codPromocion = @ntraPromocion AND pro.marcaBaja = 0 AND pre.marcaBaja = 0;

						SELECT @valorEntero = valorInicial
						FROM tblDetallePromociones
						WHERE ntraPromocion = @ntraPromocion AND flag = 6 AND estado = 1 AND marcaBaja = 0;
						IF(@contador > @valorEntero)
						BEGIN
							SET @flag = 1;
						END
					END
				END

				--FLAG 7 VECES QUE UN VENDEDOR PUEDE USAR LA PROMOCION
				IF (@flag = 0)
				BEGIN 
					SET @cont = 0;
					SELECT @cont = COUNT(ntraPromocion) FROM tblDetallePromociones
					WHERE ntraPromocion = @ntraPromocion AND flag = 7 AND estado = 1 AND marcaBaja = 0;
					IF(@cont > 0)
					BEGIN
						SET @valorEntero = 0;
						SET @contador = 0;
						SELECT @contador = COUNT(DISTINCT(codPreventa))
						FROM tblPreventaPromocion pro INNER JOIN tblPreventa pre ON pro.codPreventa = pre.ntraPreventa
						WHERE pre.estado != 2 AND pro.codPromocion = @ntraPromocion and pre.codUsuario = @p_codUsuario 
						AND pro.marcaBaja = 0 AND pre.marcaBaja = 0;

						SELECT @valorEntero = valorInicial
						FROM tblDetallePromociones
						WHERE ntraPromocion = @ntraPromocion AND flag = 7 AND estado = 1 AND marcaBaja = 0;
						IF(@contador > @valorEntero)
						BEGIN
							SET @flag = 1;
						END
					END
				END

				--FLAG 8 VECES QUE UN CLIENTE PUEDE USAR LA PROMOCION
				IF (@flag = 0)
				BEGIN 
					SET @cont = 0;
					SELECT @cont = COUNT(ntraPromocion) FROM tblDetallePromociones
					WHERE ntraPromocion = @ntraPromocion AND flag = 8 AND estado = 1 AND marcaBaja = 0;
					IF(@cont > 0)
					BEGIN
						SET @valorEntero = 0;
						SET @contador = 0;
						SELECT @contador = COUNT(DISTINCT(codPreventa))
						FROM tblPreventaPromocion pro 
						INNER JOIN tblPreventa pre ON pro.codPreventa = pre.ntraPreventa 
						WHERE pre.estado != 2 AND pro.codPromocion = @ntraPromocion and pre.codCliente = @p_codCliente
						AND pro.marcaBaja = 0 AND pre.marcaBaja = 0;

						SELECT @valorEntero = valorInicial
						FROM tblDetallePromociones
						WHERE ntraPromocion = @ntraPromocion AND flag = 8 AND estado = 1 AND marcaBaja = 0;
						IF(@contador > @valorEntero)
						BEGIN
							SET @flag = 1;
						END
					END
				END

				--FLAG 9 PROMOCION PARA VENTA AL CONTADO O CREDITO
				IF (@flag = 0)
				BEGIN
					SET @cont = 0;
					SELECT @cont = COUNT(ntraPromocion) FROM tblDetallePromociones
					WHERE ntraPromocion = @ntraPromocion AND flag = 9 AND estado = 1 AND marcaBaja = 0;
					IF(@cont > 0)
					BEGIN
						SET @valorEntero = 0;
						SELECT @valorEntero = COUNT(valorInicial)
						FROM tblDetallePromociones
						WHERE ntraPromocion = @ntraPromocion AND valorInicial = @p_tipoVenta AND flag = 9 AND estado = 1 AND marcaBaja = 0;
						IF(@valorEntero = 0)
						BEGIN
							SET @flag = 1;
						END
					END
				END


				IF (@flag = 0)
				BEGIN 
					SELECT @ntraPromocion as ntraPromocion, @descPromocion as descPromocion, valorInicial as valor, valorFinal as tipo
					FROM tblDetallePromociones
					WHERE ntraPromocion = @ntraPromocion AND flag = 2 AND estado = 1 AND marcaBaja = 0;
				END
					

				SET @flag = 0;
				FETCH NEXT FROM cur_promos INTO @ntraPromocion, @descPromocion;
			END
		CLOSE cur_promos;  
		DEALLOCATE cur_promos;
	
	END TRY

	BEGIN CATCH
		SELECT ERROR_NUMBER() as 'ntraPromocion', 'Error en pa_preventa_promociones ' + ERROR_MESSAGE() as 'descPromocion', 0 as 'valor', 0 as 'tipo'
	END CATCH
END
GO
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
GO
IF EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_listar_filtros_product' AND type = 'P')
DROP PROCEDURE pa_listar_filtros_product
GO
----------------------------------------------------------------------------------
-- Author: Dany Gelacio -IDE SOLUTION
-- Created: 19/03/2020
-- Sistema: web virgen del Carmen
-- Descripcion: Filtros de producto
-- Log Modificaciones:
-- CODIGO NOMBRE FECHA MOTIVO
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE pa_listar_filtros_product
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

        DECLARE @g_const_0 INT				       -- valor 0
		DECLARE @g_const_1 SMALLINT			       -- valor 1
		DECLARE @g_const_9 SMALLINT			       -- valor 9
		DECLARE @g_const_12 SMALLINT               -- valor 12
		DECLARE @g_const_23 SMALLINT               -- valor 23
		DECLARE @g_const_3000 SMALLINT             -- valor 3000
		DECLARE @g_const_2000 SMALLINT             -- valor 2000
		DECLARE @g_caracter CHAR(1)			      
		DECLARE @codigo INT                        -- Codigo 
		DECLARE @mensaje VARCHAR(250)              -- mensaje
		DECLARE @estado SMALLINT                   -- 0:EXITO, 1:error interno
        DECLARE @g_descCategoria    VARCHAR(200)   -- descripcion de categoria
		DECLARE @g_descSubcategoria VARCHAR(200)   -- descripcion de subcategoria
		DECLARE @g_descProveedor    VARCHAR(200)   -- descripcion de proveedor
		DECLARE @g_descFabricante   VARCHAR(200)   -- descripcion de fabricante
		DECLARE @g_descUnidadBase   VARCHAR(50)    -- descripcion de unidad base
		DECLARE @g_undbase         INT             --Codigo de Unidad Base
		DECLARE @g_tipoProducto SMALLINT           --codigo tipo de producto (1:venta, 2:promocion)
		DECLARE @g_desctipoProduct VARCHAR(200)    -- Descripcion tipo de producto de tabla concepto
		DECLARE @g_flagVenta SMALLINT              --flag de venta 1: venta, 0:agregado
		DECLARE @g_codproducto     VARCHAR(10)     --Codigo de producto
		DECLARE @g_codcategoria    INT             --Codigo de categoria
		DECLARE @g_codsubcategoria INT             --Codigo de sub categoria
		DECLARE @g_codProveedor    INT             --Codigo de Proveedor
		DECLARE @g_codFabricante   INT             --Codigo de Fabricante
		DECLARE @g_descripcion    VARCHAR(200)      --Descripcion de producto
				

		CREATE TABLE #listProducto 
		(codProducto VARCHAR(10),codCategoria INT,descCategoria VARCHAR(200),codSubcategoria INT,descSubcategoria VARCHAR(200),
		                            codProveedor INT,descProveedor VARCHAR(200),codFabricante INT,descFabricante VARCHAR(200),descripcion VARCHAR(200),
									descUnidadBase VARCHAR(50),tipoProducto SMALLINT, desctipoProducto VARCHAR(200),flagVenta SMALLINT) --tabla temporal
								
																		
BEGIN TRY      
           SET @g_const_0 = 0;
		   SET @g_const_1 = 1;
		   SET @g_const_9 = 9;
		   SET @g_const_12 = 12;
		   SET @g_const_23 = 23;
		   SET @g_const_2000 = 2000;
		   SET @g_const_3000 = 3000;

		   SET @g_caracter = ''		
		   SET @g_descCategoria = NULL;
		   SET @g_descSubcategoria = NULL;
		   SET @g_descProveedor = NULL;
		   SET @g_descFabricante = NULL;
		   SET @g_descUnidadBase = NULL;
		   SET @g_undbase = 0;
		   SET @g_tipoProducto = 0;
		   SET @g_desctipoProduct = NULL;
		   SET @g_flagVenta = 1;
		   SET @g_codproducto = 0;
		   SET @g_codcategoria = 0;
		   SET @g_codsubcategoria = 0;
		   SET @g_codProveedor = 0;
		   SET @g_codFabricante = 0;
		   SET @g_descripcion = NULL;	 


DECLARE qcur_productos CURSOR LOCAL STATIC READ_ONLY FORWARD_ONLY FOR 
		 SELECT tblProducto.codProducto AS Codproducto,
          tblProducto.codCategoria      AS Codcategoria,
		  tblProducto.codSubcategoria   AS Codsubcategoria,		
		  tblAbastecimento.codProveedor AS CodProveedor,		
		  tblProducto.codFabricante     AS CodFabricante,
		  tblProducto.descripcion       AS descProducto,		  
		  tblProducto.codUnidadBaseventa AS undBase,
		  tblProducto.tipoProducto AS tipoProducto,		  
		  tblProducto.flagVenta AS flagVenta
		  from tblProducto INNER JOIN tblAbastecimento on tblAbastecimento.codProducto=tblProducto.codProducto 
		  where tblProducto.marcaBaja = @g_const_0 ;

		
OPEN qcur_productos;  
 FETCH NEXT FROM qcur_productos 
 INTO @g_codproducto,@g_codcategoria,@g_codsubcategoria,@g_codProveedor,@g_codFabricante,@g_descripcion,@g_undbase, @g_tipoProducto,@g_flagVenta;
 WHILE @@FETCH_STATUS = @g_const_0  
	BEGIN
		SELECT @g_descCategoria = descripcion FROM tblCategoria WHERE ntraCategoria = @g_codcategoria AND marcaBaja = @g_const_0;
		SELECT @g_descSubcategoria = descripcion FROM tblSubcategoria WHERE ntraSubcategoria = @g_codsubcategoria AND marcaBaja = @g_const_0;
		SELECT @g_descProveedor = descripcion  FROM tblProveedor INNER JOIN tblAbastecimento on codProveedor=ntraProveedor WHERE codProveedor = @g_codProveedor AND tblAbastecimento.marcaBaja = @g_const_0; --(@#)1-A
		SELECT @g_descFabricante = descripcion FROM tblFabricante WHERE ntraFabricante = @g_codFabricante AND marcaBaja = @g_const_0;	
	 	SELECT @g_descUnidadBase = descripcion FROM tblConcepto WHERE codConcepto = @g_const_12 AND correlativo = @g_undbase; 
		SELECT @g_desctipoProduct = descripcion FROM tblConcepto WHERE codConcepto = @g_const_23 AND correlativo = @g_tipoProducto; 
	
		
		INSERT INTO #listProducto
		SELECT @g_codproducto,@g_codcategoria,@g_descCategoria,@g_codsubcategoria,@g_descSubcategoria,@g_codProveedor,@g_descProveedor,
		@g_codFabricante,@g_descFabricante,@g_descripcion,@g_descUnidadBase, @g_tipoProducto,@g_desctipoProduct,@g_flagVenta
		
		SET @g_codproducto = NULL;
		
		FETCH NEXT FROM qcur_productos 
		INTO @g_codproducto,@g_codcategoria,@g_codsubcategoria,@g_codProveedor,@g_codFabricante,@g_descripcion,@g_undbase, @g_tipoProducto,@g_flagVenta;   
	 END
 CLOSE qcur_productos;  
 DEALLOCATE qcur_productos;	
	 	 IF @codCategoria = @g_const_0 AND @codSubcategoria = @g_const_0 AND @codProveedor = @g_const_0
		AND @codFabricante = @g_const_0 AND (LEN(TRIM(@descripcion)) = @g_const_0)
		BEGIN 
		SELECT codProducto,codCategoria,descCategoria,codSubcategoria,descSubcategoria,codProveedor,descProveedor,codFabricante,descFabricante,
		descripcion,descUnidadBase,tipoProducto,desctipoProducto, flagVenta
	
		FROM #listProducto;		 
		END	
	 
	 IF @codCategoria > @g_const_0 AND @codSubcategoria = @g_const_0 AND @codProveedor = @g_const_0
		AND @codFabricante = @g_const_0 AND (LEN(TRIM(@descripcion)) = @g_const_0)
		BEGIN 
		SELECT codProducto,codCategoria,descCategoria,codSubcategoria,descSubcategoria,codProveedor,descProveedor
		,codFabricante,descFabricante,descripcion,descUnidadBase,tipoProducto,desctipoProducto, flagVenta
		
		FROM #listProducto WHERE codCategoria = @codCategoria;		 
		END		
	 IF @codCategoria = @g_const_0 AND @codSubcategoria <> @g_const_0 AND @codProveedor = @g_const_0
		AND @codFabricante = @g_const_0 AND (LEN(TRIM(@descripcion)) = @g_const_0)
		BEGIN
		SELECT codProducto,codCategoria,descCategoria,codSubcategoria,descSubcategoria,codProveedor,descProveedor,
		codFabricante,descFabricante,descripcion,descUnidadBase,tipoProducto,desctipoProducto, flagVenta
		
		FROM #listProducto WHERE codSubcategoria = @codSubcategoria; 
		END
	 IF @codCategoria = @g_const_0 AND @codSubcategoria = @g_const_0 AND @codProveedor <> @g_const_0
		AND @codFabricante = @g_const_0 AND (LEN(TRIM(@descripcion)) = @g_const_0)
		BEGIN

		SELECT codProducto,codCategoria,descCategoria,codSubcategoria,descSubcategoria,codProveedor,descProveedor,
		codFabricante,descFabricante,descripcion,descUnidadBase,tipoProducto,desctipoProducto, flagVenta
		
		FROM #listProducto WHERE codProveedor=@codProveedor;
		 END
	 IF @codCategoria = @g_const_0 AND @codSubcategoria = @g_const_0 AND @codProveedor = @g_const_0
		AND @codFabricante <> @g_const_0 AND (LEN(TRIM(@descripcion)) = @g_const_0)
		BEGIN

		SELECT codProducto,codCategoria,descCategoria,codSubcategoria,descSubcategoria,codProveedor,descProveedor,codFabricante,
		descFabricante,descripcion,descUnidadBase,tipoProducto,desctipoProducto, flagVenta
		
		FROM #listProducto WHERE codFabricante=@codFabricante;
	    END
    IF @codCategoria = @g_const_0 AND @codSubcategoria = @g_const_0 AND @codProveedor = @g_const_0
		AND @codFabricante = @g_const_0 AND (LEN(TRIM(@descripcion)) <> @g_const_0)
		BEGIN
		SELECT codProducto,codCategoria,descCategoria,codSubcategoria,descSubcategoria,codProveedor,
		descProveedor,codFabricante,descFabricante,descripcion,descUnidadBase,tipoProducto,desctipoProducto, flagVenta
		
		FROM #listProducto WHERE descripcion LIKE '%' + TRIM(@descripcion) + '%';
			END
		
	IF @codCategoria <> @g_const_0 AND @codSubcategoria <> @g_const_0 AND @codProveedor = @g_const_0
		AND @codFabricante = @g_const_0 AND (LEN(TRIM(@descripcion)) = @g_const_0)
		BEGIN
		SELECT codProducto,codCategoria,descCategoria,codSubcategoria,descSubcategoria,codProveedor,descProveedor,
		codFabricante,descFabricante,descripcion,descUnidadBase,tipoProducto,desctipoProducto, flagVenta
		
		FROM #listProducto WHERE codCategoria=@codCategoria AND codSubcategoria=@codSubcategoria;
		
		END
	IF @codCategoria = @g_const_0 AND @codSubcategoria <> @g_const_0 AND @codProveedor <> @g_const_0
		AND @codFabricante = @g_const_0 AND (LEN(TRIM(@descripcion)) = @g_const_0)
		BEGIN

		SELECT codProducto,codCategoria,descCategoria,codSubcategoria,descSubcategoria,codProveedor,
		descProveedor,codFabricante,descFabricante,descripcion,descUnidadBase,tipoProducto,desctipoProducto, flagVenta
		
		FROM #listProducto WHERE codSubcategoria=@codSubcategoria  AND codProveedor=@codProveedor;
		END
    IF @codCategoria = @g_const_0 AND @codSubcategoria = @g_const_0 AND @codProveedor <> @g_const_0
		AND @codFabricante <> @g_const_0 AND (LEN(TRIM(@descripcion)) = @g_const_0)
		BEGIN

		SELECT codProducto,codCategoria,descCategoria,codSubcategoria,descSubcategoria,codProveedor,descProveedor,
		codFabricante,descFabricante,descripcion,descUnidadBase,tipoProducto,desctipoProducto, flagVenta
		
		FROM #listProducto WHERE codProveedor=@codProveedor AND codFabricante=@codFabricante;
		END
    IF @codCategoria = @g_const_0 AND @codSubcategoria = @g_const_0 AND @codProveedor = @g_const_0
		AND @codFabricante <> @g_const_0 AND (LEN(TRIM(@descripcion)) <> @g_const_0)
		BEGIN
		SELECT codProducto,codCategoria,descCategoria,codSubcategoria,descSubcategoria,codProveedor,descProveedor,
		codFabricante,descFabricante,descripcion,descUnidadBase,tipoProducto,desctipoProducto, flagVenta
		
		FROM #listProducto WHERE codFabricante=@codFabricante  AND descripcion LIKE '%' + TRIM(@descripcion) + '%';
		END
    IF @codCategoria <> @g_const_0 AND @codSubcategoria = @g_const_0 AND @codProveedor<> @g_const_0
		AND @codFabricante = @g_const_0 AND (LEN(TRIM(@descripcion)) = @g_const_0)
		BEGIN
		SELECT codProducto,codCategoria,descCategoria,codSubcategoria,descSubcategoria,codProveedor,descProveedor,
		codFabricante,descFabricante,descripcion,descUnidadBase,tipoProducto,desctipoProducto, flagVenta
		
		FROM #listProducto	 WHERE codCategoria=@codCategoria AND codProveedor=@codProveedor;
		 END
	IF @codCategoria <> @g_const_0 AND @codSubcategoria = @g_const_0 AND @codProveedor= @g_const_0
		AND @codFabricante <> @g_const_0 AND (LEN(TRIM(@descripcion)) = @g_const_0)
		BEGIN
		SELECT codProducto,codCategoria,descCategoria,codSubcategoria,descSubcategoria,codProveedor,descProveedor,
		codFabricante,descFabricante,descripcion,descUnidadBase,tipoProducto,desctipoProducto, flagVenta
		
		FROM #listProducto	 WHERE codCategoria=@codCategoria  AND codFabricante=@codFabricante;
		END
	IF @codCategoria <> @g_const_0 AND @codSubcategoria = @g_const_0 AND @codProveedor = @g_const_0
		AND @codFabricante = @g_const_0 AND (LEN(TRIM(@descripcion)) <> @g_const_0)
		BEGIN

		SELECT codProducto,codCategoria,descCategoria,codSubcategoria,descSubcategoria,codProveedor,descProveedor,codFabricante,
		descFabricante,descripcion,descUnidadBase,tipoProducto,desctipoProducto, flagVenta
		
		FROM #listProducto WHERE codCategoria = @codCategoria AND descripcion LIKE '%' + TRIM(@descripcion) + '%';			
		END 
	IF @codCategoria = @g_const_0 AND @codSubcategoria <> @g_const_0 AND @codProveedor = @g_const_0
		AND @codFabricante <> @g_const_0 AND (LEN(TRIM(@descripcion)) = @g_const_0)
		BEGIN

		SELECT codProducto,codCategoria,descCategoria,codSubcategoria,descSubcategoria,codProveedor,descProveedor,codFabricante,
		descFabricante,descripcion,descUnidadBase,tipoProducto,desctipoProducto, flagVenta
		
		FROM #listProducto WHERE codSubcategoria= @codSubcategoria AND codFabricante= @codFabricante;
		END
	IF @codCategoria = @g_const_0 AND @codSubcategoria <> @g_const_0 AND @codProveedor = @g_const_0
		AND @codFabricante = @g_const_0 AND (LEN(TRIM(@descripcion)) <> @g_const_0)
		BEGIN		
		SELECT codProducto,codCategoria,descCategoria,codSubcategoria,descSubcategoria,codProveedor,descProveedor,
		codFabricante,descFabricante,descripcion,descUnidadBase,tipoProducto,desctipoProducto, flagVenta
		
		FROM #listProducto WHERE codSubcategoria= @codSubcategoria AND descripcion LIKE '%' + TRIM(@descripcion) + '%';			
		END
	 IF @codCategoria = @g_const_0 AND @codSubcategoria = @g_const_0 AND @codProveedor <> @g_const_0
		AND @codFabricante = @g_const_0 AND (LEN(TRIM(@descripcion)) <> @g_const_0)
		BEGIN	
		SELECT codProducto,codCategoria,descCategoria,codSubcategoria,descSubcategoria,codProveedor,descProveedor,
		codFabricante,descFabricante,descripcion,descUnidadBase,tipoProducto,desctipoProducto, flagVenta
		
		FROM #listProducto WHERE codProveedor=@codProveedor AND descripcion LIKE '%' + TRIM(@descripcion) + '%';	
		END
	IF @codCategoria <> @g_const_0 AND @codSubcategoria <> @g_const_0 AND @codProveedor <> @g_const_0
		AND @codFabricante = @g_const_0 AND (LEN(TRIM(@descripcion)) = @g_const_0)
		BEGIN		
		SELECT codProducto,codCategoria,descCategoria,codSubcategoria,descSubcategoria,codProveedor,descProveedor,
		codFabricante,descFabricante,descripcion,descUnidadBase,tipoProducto,desctipoProducto, flagVenta
		
		FROM #listProducto WHERE codCategoria=@codCategoria AND codSubcategoria=@codSubcategoria AND codProveedor=@codProveedor;		
		END
    IF @codCategoria = @g_const_0 AND @codSubcategoria <> @g_const_0 AND @codProveedor <> @g_const_0
		AND @codFabricante <> @g_const_0 AND (LEN(TRIM(@descripcion)) = @g_const_0)
		BEGIN 
		SELECT codProducto,codCategoria,descCategoria,codSubcategoria,descSubcategoria,codProveedor,descProveedor,
		codFabricante,descFabricante,descripcion,descUnidadBase,tipoProducto,desctipoProducto, flagVenta
		
		FROM #listProducto WHERE codSubcategoria=@codSubcategoria AND codProveedor=@codProveedor AND codFabricante=@codFabricante;	
		END
	IF @codCategoria = @g_const_0 AND @codSubcategoria = @g_const_0 AND @codProveedor <> @g_const_0
		AND @codFabricante <> @g_const_0 AND (LEN(TRIM(@descripcion)) <> @g_const_0)
		BEGIN	
		SELECT codProducto,codCategoria,descCategoria,codSubcategoria,descSubcategoria,codProveedor,descProveedor,
		codFabricante,descFabricante,descripcion,descUnidadBase,tipoProducto,desctipoProducto, flagVenta
		
		FROM #listProducto WHERE codProveedor=@codProveedor AND codFabricante=@codFabricante AND descripcion LIKE '%' + TRIM(@descripcion) + '%';	
		END	
   IF @codCategoria <> @g_const_0 AND @codSubcategoria = @g_const_0 AND @codProveedor <> @g_const_0
		AND @codFabricante <> @g_const_0 AND (LEN(TRIM(@descripcion)) = @g_const_0)
		BEGIN
		SELECT codProducto,codCategoria,descCategoria,codSubcategoria,descSubcategoria,codProveedor,descProveedor,codFabricante,
		descFabricante,descripcion,descUnidadBase,tipoProducto,desctipoProducto, flagVenta
		
		FROM #listProducto WHERE codCategoria=@codCategoria AND codProveedor= @codProveedor AND codFabricante=@codFabricante;	
		END
 IF @codCategoria <> @g_const_0 AND @codSubcategoria = @g_const_0 AND @codProveedor= @g_const_0
		AND @codFabricante <> @g_const_0 AND (LEN(TRIM(@descripcion)) <> @g_const_0)
		BEGIN
		SELECT codProducto,codCategoria,descCategoria,codSubcategoria,descSubcategoria,codProveedor,descProveedor,codFabricante,
		descFabricante,descripcion,descUnidadBase,tipoProducto,desctipoProducto, flagVenta
		
		FROM #listProducto WHERE codCategoria=@codCategoria  AND codFabricante=@codFabricante AND descripcion LIKE '%' + TRIM(@descripcion) + '%';
		END

 IF @codCategoria <> @g_const_0 AND @codSubcategoria = @g_const_0 AND @codProveedor <> @g_const_0
		AND @codFabricante <> @g_const_0 AND (LEN(TRIM(@descripcion)) <> @g_const_0)
		BEGIN
		SELECT codProducto,codCategoria,descCategoria,codSubcategoria,descSubcategoria,codProveedor,descProveedor,
		codFabricante,descFabricante,descripcion,descUnidadBase,tipoProducto,desctipoProducto, flagVenta
		
		FROM #listProducto WHERE codCategoria=@codCategoria  AND codFabricante=@codFabricante AND codProveedor=@codProveedor  AND descripcion LIKE '%' + TRIM(@descripcion) + '%';
		END

 IF @codCategoria <> @g_const_0 AND @codSubcategoria <> @g_const_0 AND @codProveedor = @g_const_0
		AND @codFabricante <> @g_const_0 AND  (LEN(TRIM(@descripcion)) = @g_const_0)
		BEGIN
		SELECT codProducto,codCategoria,descCategoria,codSubcategoria,descSubcategoria,codProveedor,descProveedor,
		codFabricante,descFabricante,descripcion,descUnidadBase,tipoProducto,desctipoProducto, flagVenta
	
		FROM #listProducto WHERE codCategoria=@codCategoria  AND codFabricante=@codFabricante AND codSubcategoria=@codSubcategoria;
		END
   IF @codCategoria <> @g_const_0 AND @codSubcategoria <> @g_const_0 AND @codProveedor <> @g_const_0
		AND @codFabricante <> @g_const_0 AND  (LEN(TRIM(@descripcion)) = @g_const_0)
		BEGIN
		SELECT codProducto,codCategoria,descCategoria,codSubcategoria,descSubcategoria,codProveedor,descProveedor,
		codFabricante,descFabricante,descripcion,descUnidadBase,tipoProducto,desctipoProducto, flagVenta
	
		FROM #listProducto WHERE codCategoria=@codCategoria  AND codFabricante=@codFabricante AND codSubcategoria=@codSubcategoria AND  codProveedor=@codProveedor ;
		END
   IF @codCategoria <> @g_const_0 AND @codSubcategoria <> @g_const_0 AND @codProveedor <> @g_const_0
		AND @codFabricante <> @g_const_0 AND  (LEN(TRIM(@descripcion)) <> @g_const_0)
		BEGIN
		SELECT codProducto,codCategoria,descCategoria,codSubcategoria,descSubcategoria,codProveedor,descProveedor,codFabricante,
		descFabricante,descripcion,descUnidadBase,tipoProducto,desctipoProducto, flagVenta
		
		FROM #listProducto WHERE codCategoria=@codCategoria  AND codFabricante=@codFabricante AND codSubcategoria=@codSubcategoria AND  codProveedor=@codProveedor 
		AND descripcion LIKE '%' + TRIM(@descripcion) + '%';
		END

		
END TRY
BEGIN CATCH
                SET @codigo = @g_const_3000;
				SET @estado = @g_const_1;
				SET @mensaje = ERROR_MESSAGE();
			SELECT '' AS codproducto,@g_const_0 as codCategoria,'' as descCategoria,@g_const_0 as codSubcategoria,'' as descSubcategoria,@g_const_0 as codProveedor,'' as descProveedor,
			@g_const_0 as codFabricante,'' as descFabricante,'' as descripcion, '' as descUnidadBase, @g_const_0 as tipoProducto,' ' as desctipoProducto,@g_const_0 as flagVenta
			
END CATCH
END
GO
IF EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_eliminar_producto' AND type = 'P')
DROP PROCEDURE pa_eliminar_producto
GO
-----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
-- Autor: Dany Gelacio IDE-SOLUTION
-- Created: 15/03/2020  
-- Sistema: Sistema Distribuidora Virgen del Carmen
-- Modulo: General
-- Descripci�n: Eliminar producto
-- CODIGO NOMBRE FECHA MOTIVO
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE pa_eliminar_producto	
(
	@codProducto VARCHAR(10),   --Codigo de producto
	@resultado int  OUTPUT
)

AS
	BEGIN
		BEGIN TRY		
			UPDATE tblProducto SET marcaBaja = 9 WHERE codProducto = @codProducto AND marcaBaja = 0

			UPDATE tblDetallePresentacion SET marcaBaja = 9 WHERE codProducto = @codProducto AND marcaBaja = 0

			UPDATE tblAbastecimento set marcaBaja = 9 where codProducto = @codProducto and marcaBaja = 0
				SELECT @resultado = 0
		END TRY
			BEGIN CATCH
				SELECT  
				   ERROR_NUMBER() AS NumeroDeError   
				   ,ERROR_STATE() AS NumeroDeEstado    
				   ,ERROR_LINE() AS  NumeroDeLinea  
				   ,ERROR_MESSAGE() AS MensajeDeError; 

		END CATCH

END



GO

IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_actualizar_rutas' AND type = 'P')
	DROP PROCEDURE pa_actualizar_rutas
GO
----------------------------------------------------------------------------------
-- Author: KVASQUEZ IDE-SOLUTION
-- Created: 13/01/2020  
-- Sistema: ws_wa_DistribuidoraVDC
-- Descripci�n: Actualizar datos de Ruta
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[pa_actualizar_rutas]
(
	@descripcion varchar(100),	--Nombre de la Ruta
	@pseudonimo varchar(100),	--Abreviatura
	@ntraRutas int				--Codigo de la Ruta
)
AS
BEGIN TRY
		BEGIN
		UPDATE tblRutas SET descripcion = @descripcion, pseudonimo = @pseudonimo WHERE ntraRutas = @ntraRutas
		END
END TRY
BEGIN CATCH
		SELECT  
			ERROR_NUMBER() AS NumeroDeError   
            ,ERROR_STATE() AS NumeroDeEstado    
            ,ERROR_LINE() AS  NumeroDeLinea  
            ,ERROR_MESSAGE() AS MensajeDeError;  
			
END CATCH

GO

IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_insertar_rutas' AND type = 'P')
	DROP PROCEDURE pa_insertar_rutas
GO
----------------------------------------------------------------------------------
-- Author: KEVIN V IDE-SOLUTION
-- Created: 14/03/2020  
-- Sistema: ws_wa_DistribuidoraVDC
-- Descripci�n: Insertar rutas
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[pa_insertar_rutas]
(
	@descripcion varchar(100),		--Nombre de la Ruta
	@pseudonimo varchar(100),		--Abreviatura
	@codSucursal INT				--codigo de Sucursal
)

AS
	BEGIN 

BEGIN TRY
			BEGIN
			INSERT INTO tblRutas
			(descripcion,pseudonimo,codSucursal,usuario,ip,mac)
			VALUES (@descripcion,@pseudonimo,1,'kvasquez','172.18.1.184','00:1B:44:11:3A:B7');
				
		END
END TRY
BEGIN CATCH

		SELECT  
			ERROR_NUMBER() AS NumeroDeError   
            ,ERROR_STATE() AS NumeroDeEstado    
            ,ERROR_LINE() AS  NumeroDeLinea  
            ,ERROR_MESSAGE() AS MensajeDeError;  
END CATCH

END


GO

IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_eliminar_rutas' AND type = 'P')
	DROP PROCEDURE pa_eliminar_rutas
GO
----------------------------------------------------------------------------------
-- Author: Kevin V - IDE-SOLUTION
-- Created: 10/03/2020  
-- Sistema: ws_wa_DistribuidoraVDC
-- Descripci�n: Eliminar Rutas
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[pa_eliminar_rutas]
(
	@codRuta INT,				--codigo de la ruta
	@resultado INT OUTPUT		--mensaje
)

AS
	BEGIN
		BEGIN TRY
			UPDATE tblRutas SET marcaBaja = 9  WHERE ntraRutas = @codRuta	
			SELECT @resultado = @codRuta	
		END TRY
		BEGIN CATCH
				SELECT  
					ERROR_NUMBER() AS NumeroDeError   
				   ,ERROR_STATE() AS NumeroDeEstado    
				   ,ERROR_LINE() AS  NumeroDeLinea  
				   ,ERROR_MESSAGE() AS MensajeDeError;  
		END CATCH
END

GO
IF EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_listar_detalle_documento_venta' AND type = 'P')
DROP PROCEDURE pa_listar_detalle_documento_venta
GO
----------------------------------------------------------------------------------
-- Author: WilSON IDE-SOLUTION
-- Created: 24/03/2020  
-- Sistema: ws_wa_DistribuidoraVDC
-- Descripci�n: listar detalle documento venta
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[pa_listar_detalle_documento_venta]   
(
--@p_codVendedor INTEGER,
@p_flagFiltro SMALLINT,
@p_fechaActual INT =  NULL ,
@p_estado SMALLINT =  NULL,
@p_cliente INT =  NULL,
@p_vendedor INT =  NULL,
@p_fechaInicial DATE =  NULL,
@p_fechaFinal DATE =  NULL,
@p_codTipoDoc INT = NULL,
@p_codFactura INT = NULL,
@p_serie  VARCHAR(20) = NULL,
@p_nroDocumento INT = NULL
)			
AS   
BEGIN
    IF @p_flagFiltro = 1
	BEGIN
		SELECT * FROM v_listar_detalle_documento_venta
		WHERE MONTH(fechaTransaccion) = @p_fechaActual and estadov = 1  
		ORDER BY fechaTransaccion DESC
	END

	IF @p_flagFiltro = 2
	BEGIN
		IF @p_fechaInicial != ''
		BEGIN
			SELECT * FROM v_listar_detalle_documento_venta
			WHERE
			(@p_estado = 0 OR @p_estado = estadov)
			AND (@p_cliente = 0 OR @p_cliente = codCliente)
			AND (@p_vendedor = 0 OR @p_vendedor = codVendedor)
			AND (@p_fechaInicial IS NULL OR fechaTransaccion >= @p_fechaInicial)
			AND (@p_fechaFinal IS NULL OR fechaTransaccion <= @p_fechaFinal)
			AND (@p_codTipoDoc = 0 OR @p_codTipoDoc = tipodocumento)
			AND (@p_codFactura = 0 OR ntraVenta = @p_codFactura)
			AND (@p_serie IS NULL or serie = @p_serie )
			AND (@p_nroDocumento = 0 or nroDocumento = @p_nroDocumento )
			ORDER BY fechaTransaccion DESC
		END
		ELSE
		BEGIN
			SELECT * FROM v_listar_detalle_documento_venta
			WHERE
			(@p_estado = 0 OR @p_estado = estadov)
			AND (@p_cliente = 0 OR @p_cliente = codCliente)
			AND (@p_vendedor = 0 OR @p_vendedor = codVendedor)
			AND (MONTH(fechaTransaccion) = @p_fechaActual)
			AND (@p_codTipoDoc = 0 OR @p_codTipoDoc = tipodocumento)
			AND (@p_codFactura = 0 OR ntraVenta = @p_codFactura)
			AND (@p_serie IS NULL or serie = @p_serie )
			AND (@p_nroDocumento = 0 or nroDocumento = @p_nroDocumento )
			ORDER BY fechaTransaccion DESC
		END

	END
END
GO

IF EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_auto_nom_buscar_usuario' AND type = 'P')
DROP PROCEDURE pa_auto_nom_buscar_usuario
GO
-----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
-- Autor: Joseph Lenin Guivar IDE-SOLUTION
-- Created: 27/03/2020  
-- Sistema: Sistema Distribuidora Virgen del Carmen
-- Modulo: General
-- Descripci�n:  autocompletar nombres usuario
-- CODIGO NOMBRE FECHA MOTIVO
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[pa_auto_nom_buscar_usuario]
(
	/*@p_flag INT,			--flag
	@p_codCliente INT,		--codigo cliente
	@p_nombres VARCHAR(30)			--nombres*/
	@p_cadena VARCHAR(50)			--cadena
)
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN TRY
		SELECT codPersona as codUsuario , numDoc , nombres
		FROM v_auto_nom_listar_usuario
		WHERE concatenado LIKE '%'+ RTRIM(LTRIM(@p_cadena)) + '%'

		END TRY

	BEGIN CATCH
		SELECT ERROR_NUMBER() as 'codCliente', 'Error en pa_auto_nom_buscar_usuario ' + ERROR_MESSAGE() as 'nombres', '' as 'numDocumento'
	END CATCH
END
GO
IF EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_buscar_usuario' AND type = 'P')
DROP PROCEDURE pa_buscar_usuario
GO
-----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
-- Autor: Joseph Lenin Guivar IDE-SOLUTION
-- Created: 27/03/2020  
-- Sistema: Sistema Distribuidora Virgen del Carmen
-- Modulo: General
-- Descripci�n:  listar usuario
-- CODIGO NOMBRE FECHA MOTIVO
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[pa_buscar_usuario]
(
	                                  
	@p_codUsuario		INT					= NULL,		--Numero de documento Persona
	@p_codEstado		INT					= NULL,		--
	@p_flagFiltro		SMALLINT
)
AS
BEGIN 
	SET NOCOUNT ON;
	BEGIN TRY
	IF @p_flagFiltro = 1
		BEGIN 
			SELECT *  FROM v_listar_usuario
			ORDER BY usuarioPersona 
		END 
	IF @p_flagFiltro = 2
		BEGIN 
			
			SELECT *  FROM v_listar_usuario
			WHERE	
				 (@p_codEstado		= 0 OR  @p_codEstado = codEstado)
			AND (@p_codUsuario		= 0 OR   @p_codUsuario = codPersona)
		END 
	END TRY
	BEGIN CATCH
		SELECT ERROR_NUMBER() , 'Error en pa_buscar_usuario ' + ERROR_MESSAGE() 
	END CATCH
END 
GO
IF EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_eliminar_usuario' AND type = 'P')
DROP PROCEDURE pa_eliminar_usuario
GO
-----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
-- Autor: Joseph Lenin Guivar IDE-SOLUTION
-- Created: 27/03/2020  
-- Sistema: Sistema Distribuidora Virgen del Carmen
-- Modulo: General
-- Descripci�n:  Eliminar usuario
-- CODIGO NOMBRE FECHA MOTIVO
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[pa_eliminar_usuario]	
(
	@p_codPersona INT   --Codigo de persona
)

AS
	BEGIN
	SET NOCOUNT ON
		DECLARE @flag INT;						--flag de proceso
		DECLARE @msje VARCHAR(250);				--mensaje de error

		SET @flag = 0;
		SET @msje = 'Exito';

		BEGIN TRY		
			
			BEGIN TRANSACTION 
			
				UPDATE tblUsuario SET marcaBaja = 9 WHERE codPersona = @p_codPersona AND marcaBaja = 0

				COMMIT TRANSACTION

			SELECT @flag as flag , @msje as msje

		END TRY

			BEGIN CATCH
				IF (XACT_STATE()) <> 0 
			BEGIN
				ROLLBACK TRANSACTION
			END
			SET @flag = ERROR_NUMBER();
			SET @msje = 'Error en pa_eliminar_usuario ' + ERROR_MESSAGE();
			SELECT @flag as flag , @msje as msje

		END CATCH

END
GO
IF EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_insertar_usuario' AND type = 'P')
DROP PROCEDURE pa_insertar_usuario
GO
-----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
-- Autor: Joseph Lenin Guivar IDE-SOLUTION
-- Created: 27/03/2020  
-- Sistema: Sistema Distribuidora Virgen del Carmen
-- Modulo: General
-- Descripci�n:  insertar usuario
-- CODIGO NOMBRE FECHA MOTIVO
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[pa_insertar_usuario]	
(
@numDocumento VARCHAR(15),
				
	@p_nombres		VARCHAR(30),				
	@p_apePaterno	VARCHAR(20),			
	@p_apeMaterno	 VARCHAR(20),			
	@p_direccion	 VARCHAR(100),			
	@p_correo		VARCHAR(60),				
	@p_telefono		VARCHAR(15),
	@p_celular		CHAR(9),					
------------------------------------------------	
	@p_ubigeo		CHAR(6),
	@marcaBaja		 TINYINT,
	@fechProceso	date ,
	@horaProceso		time,
	----------------------------------------------------------------
	@p_usuario VARCHAR(20),				
	@p_ip VARCHAR(20),					
	@p_mac VARCHAR(20),
 ------------***************************-------------------------------------------------
	 --@p_codUsuario INTEGER,
	 @users  VARCHAR(20),
	 @codPerfil INT,
	 @codEstado TINYINT,
	 @codPersona INT,
	 @codSucursal int ,
	 @password varbinary

/*
	@p_usuario1 VARCHAR(20),				
	@p_ip1 VARCHAR(20),					
	@p_mac1 VARCHAR(20)		
*/	
)
AS
BEGIN
/*
		SET NOCOUNT ON;
		DECLARE @mensaje VARCHAR(100);		-- mensaje
		--DECLARE @flag INT;					--flag de proceso
		DECLARE @codPersona INT;			--codigo de persona
		
		--SET @flag = 0;
		SET @mensaje = 'CONSULTA EXITOSA';
		SET @codPersona = 0;
	*/	
		
	BEGIN TRY
	/*
		IF (@p_tipoPersona = 1 AND @p_tipoDocumento = 1)
			BEGIN
				SET @codPersona = @p_numDocumento;
			END

			*/
		--BEGIN TRANSACTION
			BEGIN

				INSERT INTO tblPersona (codPersona, tipoPersona, tipoDocumento, numeroDocumento, ruc, razonSocial, nombres, apellidoPaterno, 
				apellidoMaterno, direccion, correo, telefono, celular, codUbigeo, marcaBaja, usuario, ip, mac) 
				
				VALUES (@numDocumento, 1 , 1, @numDocumento, '', '', @p_nombres, @p_apePaterno, 
				@p_apeMaterno, @p_direccion,@p_correo,@p_telefono, @p_celular,'','' , 'jguivar', '210.163.32.12', 'BH:12:H5:2B') ;


				--INSERT INTO tblLocalizacion(codPersona,coordenadaX,coordenadaY,marcaBaja,usuario,ip,mac) 
				--VALUES(@codPersona,@p_coordenadaX,@p_coordenadaY,0, @p_usuario, @p_ip, @p_mac);
			/*
				@users 
				@codPerfil 
				@codEstado 
				@codPersona 
				@codSucursal
				@password 
			*/

				--INSERT INTO tblUsuario(ntraUsuario,users,codPersona , codPerfil, estado, marcaBaja, fechaProceso,horaProceso,horaProceso,usuario,ip,mac,password,codSucursal)
				--VALUES ('', @users , @codPerfil, @estado, @marcaBaja, @fechaProceso,@horaProceso,@password,@codSucursal);
			END



			Select * from tblUsuario
				--COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
	/*
	IF (XACT_STATE()) <> 0 
		BEGIN
			ROLLBACK TRANSACTION
		END
		SET @flag = ERROR_NUMBER();
		SET @mensaje = 'Error en pa_insertar_usuario ' + ERROR_MESSAGE();
		SET @codPersona = 0;
		
		SELECT @flag as flag , @mensaje as msje, @codPersona as codPersona
	END CATCH
	*/
	SELECT  
			ERROR_NUMBER() AS NumeroDeError   
            ,ERROR_STATE() AS NumeroDeEstado    
            ,ERROR_LINE() AS  NumeroDeLinea  
            ,ERROR_MESSAGE() AS MensajeDeError; 
END CATCH
END
GO
IF EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_actualizar_usuario' AND type = 'P')
DROP PROCEDURE pa_actualizar_usuario
GO
-----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
-- Autor: Joseph Lenin Guivar IDE-SOLUTION
-- Created: 27/03/2020  
-- Sistema: Sistema Distribuidora Virgen del Carmen
-- Modulo: General
-- Descripci�n:  actualizar usuario
-- CODIGO NOMBRE FECHA MOTIVO
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[pa_actualizar_usuario]	
(
	@p_tipoPersona TINYINT,					
	@p_tipoDocumento TINYINT,
	@p_numDocumento VARCHAR(15),
	@p_codUsuario INTEGER,				
	@p_nombres VARCHAR(30),				
	@p_apePaterno VARCHAR(20),			
	@p_apeMaterno VARCHAR(20),			
	@p_direccion VARCHAR(100),			
	@p_correo VARCHAR(60),				
	@p_telefono VARCHAR(15),
	@p_ubigeo CHAR(6),
	@p_celular CHAR(9),					
	@p_codEstado TINYINT,
	
	 @users  VARCHAR(20),
	 @codPerfil INT,
	 @estado TINYINT , 
	 @marcaBaja TINYINT,
	 @fechaProceso date,
	 @horaProceso time,
	 @codSucursal int ,
	 @password varbinary,
	
	
	@p_usuario VARCHAR(20),				
	@p_ip VARCHAR(20),					
	@p_mac VARCHAR(20)					
)
AS
BEGIN
		SET NOCOUNT ON;
		DECLARE @mensaje VARCHAR(100);		-- mensaje
		DECLARE @flag INT;					--flag de proceso
		DECLARE @codPersona INT;			--codigo de persona
		
		SET @flag = 0;
		SET @mensaje = 'CONSULTA EXITOSA';
		SET @codPersona = 0;
		
		
	BEGIN TRY
		IF (@p_tipoPersona = 1 AND @p_tipoDocumento = 1)
			BEGIN
				SET @codPersona = @p_numDocumento;
			END
			BEGIN TRANSACTION
				INSERT INTO tblPersona (codPersona, tipoPersona, tipoDocumento, numeroDocumento, nombres, apellidoPaterno, 
				apellidoMaterno, direccion, correo, telefono, celular, codUbigeo, marcaBaja, usuario, ip, mac) 
				VALUES(@codPersona, @p_tipoPersona, @p_tipoDocumento, @p_numDocumento, @p_nombres, @p_apePaterno, @p_apeMaterno, 
				@p_direccion, @p_correo, @p_telefono, @p_celular, @p_ubigeo, 0, @p_usuario, @p_ip, @p_mac);

				--INSERT INTO tblLocalizacion(codPersona,coordenadaX,coordenadaY,marcaBaja,usuario,ip,mac) 
				--VALUES(@codPersona,@p_coordenadaX,@p_coordenadaY,0, @p_usuario, @p_ip, @p_mac);

				--INSERT INTO tblUsuario(codPersona,users  , codPerfil, estado, marcaBaja, fechaProceso,horaProceso,horaProceso,password,codSucursal)
				--VALUES (@codPersona, @users  , @codPerfil, @estado, @marcaBaja, @fechaProceso,@horaProceso,@password,@codSucursal);


				COMMIT TRANSACTION
					END TRY
	BEGIN CATCH
		IF (XACT_STATE()) <> 0 
		BEGIN
			ROLLBACK TRANSACTION
		END
		SET @flag = ERROR_NUMBER();
		SET @mensaje = 'Error en pa_actualizar_usuario ' + ERROR_MESSAGE();
		SET @codPersona = 0;
		
		SELECT @flag as flag , @mensaje as msje, @codPersona as codPersona
	END CATCH
END
GO

IF EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_notacredito_obtener_detalleventa' AND type = 'P')
DROP PROCEDURE pa_notacredito_obtener_detalleventa
GO
----------------------------------------------------------------------------------
-- Author: Alex Llamo IDE-SOLUTION
-- Created: 23/03/2020
-- Sistema: VirgenDelCarmenMantenedor
-- Descripcion: obtener detalle de venta por codigo
-- Log Modificaciones:
-- CODIGO NOMBRE FECHA MOTIVO
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_notacredito_obtener_detalleventa
(
	@p_codigo INT				--codigo de venta
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @itemVenta TINYINT; 
	DECLARE @codProducto VARCHAR(10); 
	DECLARE @descProducto VARCHAR(200); 
	DECLARE @cantidadPresentacion INT; 
	DECLARE @cantidadUnidadBase INT; 
	DECLARE @precioVenta MONEY; 
	DECLARE @descAlmacen VARCHAR(20); 
	DECLARE @descUnidadBase VARCHAR(250);
	DECLARE @tipoProducto TINYINT; 
	DECLARE @descTipProducto VARCHAR(250); 
	DECLARE @descuento MONEY;
	DECLARE @can_disponible INT;
	DECLARE @can_devueltos INT;
	
	DECLARE @cantidad INT;
	DECLARE @can_dev INT;
	DECLARE @dsct_disponible MONEY;
	DECLARE @importe MONEY;

	SET @itemVenta = 0; 
	SET @codProducto = ''; 
	SET @descProducto = ''; 
	SET @cantidadPresentacion = 0; 
	SET @cantidadUnidadBase = 0; 
	SET @precioVenta = 0; 
	SET @descAlmacen = ''; 
	SET @descUnidadBase = '';
	SET @tipoProducto = 0; 
	SET @descTipProducto = ''; 
	SET @descuento = 0;
	SET @can_disponible = 0;
	SET @can_devueltos = 0;
	SET @dsct_disponible = 0;
	SET @importe = 0;

	CREATE TABLE #temporal
	(itemVenta TINYINT, 
	codProducto VARCHAR(10), 
	descProducto VARCHAR(200), 
	cantidadPresentacion INT, 
	cantidadUnidadBase INT, 
	precioVenta MONEY, 
	descAlmacen VARCHAR(20), 
	descUnidadBase VARCHAR(250),
	tipoProducto TINYINT, 
	descTipProducto VARCHAR(250), 
	descuento MONEY,
	can_disponible INT,
	can_devueltos INT,
	dsct_disponible MONEY);

	BEGIN TRY
		DECLARE cur_stock CURSOR LOCAL STATIC READ_ONLY FORWARD_ONLY FOR 
		SELECT dv.itemVenta, dv.codProducto, pro.descripcion as descProducto, dv.cantidadPresentacion, dv.cantidadUnidadBase,
		dv.precioVenta, alm.descripcion as descAlmacen, con.descripcion as descUnidadBase, dv.TipoProducto as tipoProducto,
		est.descripcion as descTipProducto, ISNULL(dpd.importe,0) as descuento
		FROM tblDetalleVenta dv
		INNER JOIN tblConcepto con ON dv.codPresentacion = con.correlativo
		INNER JOIN tblAlmacen alm ON dv.codAlmacen = alm.ntraAlmacen
		INNER JOIN tblProducto pro ON dv.codProducto = pro.codProducto
		inner join (select correlativo, descripcion from tblConcepto where codConcepto = 22) as est on dv.TipoProducto = est.correlativo
		left join tblVentaDescuento dpd on dpd.codVenta = dv.codVenta and dpd.itemVenta = dv.itemVenta
		WHERE dv.codVenta = @p_codigo AND con.codConcepto = 12
		AND pro.marcaBaja = 0 AND dv.marcaBaja = 0 AND alm.marcaBaja = 0 AND con.marcaBaja = 0
		ORDER BY dv.itemVenta ASC;

		OPEN cur_stock;  
		FETCH NEXT FROM cur_stock INTO @itemVenta, @codProducto, @descProducto, @cantidadPresentacion, @cantidadUnidadBase, @precioVenta, 
		@descAlmacen, @descUnidadBase, @tipoProducto, @descTipProducto, @descuento
		WHILE @@FETCH_STATUS = 0
			BEGIN
				SET @can_dev = 0;
				SELECT @can_dev = SUM(cantidadPresentacion) FROM tblDetalleVenta
				WHERE codVenta IN (SELECT codVentaNega FROM tblNotaCredito WHERE codVenta = @p_codigo AND marcaBaja = 0) 
				AND codProducto = @codProducto AND marcaBaja = 0;

				IF(@can_dev IS NULL)
					SET @can_dev = 0;

				SET @cantidad = 0;
				SET @cantidad = @cantidadPresentacion - @can_dev;

				SET @importe = 0;
				SELECT @importe = SUM(importe) FROM tblVentaDescuento
				WHERE codVenta IN (SELECT codVentaNega FROM tblNotaCredito WHERE codVenta = @p_codigo AND marcaBaja = 0) 
				AND itemVenta = @itemVenta AND marcaBaja = 0;

				IF(@importe IS NULL)
					SET @importe = 0;

				SET @dsct_disponible = @descuento + @importe;

				INSERT INTO #temporal 
				SELECT @itemVenta , @codProducto, @descProducto, @cantidadPresentacion, @cantidadUnidadBase, @precioVenta, 
				@descAlmacen, @descUnidadBase, @tipoProducto, @descTipProducto, @descuento, @cantidad , @can_dev, @dsct_disponible;
				
				FETCH NEXT FROM cur_stock INTO 
				@itemVenta , @codProducto, @descProducto, @cantidadPresentacion, @cantidadUnidadBase, @precioVenta, 
				@descAlmacen, @descUnidadBase, @tipoProducto, @descTipProducto, @descuento
			END
		CLOSE cur_stock;
		DEALLOCATE cur_stock;

		SELECT * FROM #temporal
		--SELECT dv.itemVenta, dv.codProducto, pro.descripcion as descProducto, dv.cantidadPresentacion, dv.cantidadUnidadBase,
		--dv.precioVenta, alm.descripcion as descAlmacen, con.descripcion as descUnidadBase, dv.TipoProducto as tipoProducto,
		--est.descripcion as descTipProducto, ISNULL(dpd.importe,0) as descuento
		--FROM tblDetalleVenta dv
		--INNER JOIN tblConcepto con ON dv.codPresentacion = con.correlativo
		--INNER JOIN tblAlmacen alm ON dv.codAlmacen = alm.ntraAlmacen
		--INNER JOIN tblProducto pro ON dv.codProducto = pro.codProducto
		--inner join (select correlativo, descripcion from tblConcepto where codConcepto = 22) as est on dv.TipoProducto = est.correlativo
		--left join tblVentaDescuento dpd on dpd.codVenta = dv.codVenta and dpd.itemVenta = dv.itemVenta
		--WHERE dv.codVenta = @p_codigo AND con.codConcepto = 12
		--AND pro.marcaBaja = 0 AND dv.marcaBaja = 0 AND alm.marcaBaja = 0 AND con.marcaBaja = 0
		--ORDER BY dv.itemVenta ASC;
		
	END TRY

	BEGIN CATCH
		SELECT ERROR_NUMBER() as itemVenta, 'Error en pa_notacredito_obtener_detalleventa ' + ERROR_MESSAGE() as codProducto,
		'' as descProducto, 0 as cantidadPresentacion, 0 as cantidadUnidadBase, 0 as precioVenta, '' as descAlmacen, '' as descUnidadBase,
		0 as tipoProducto, '' as descTipProducto, 0 as descuento, 0 as can_disponible, 0 as can_devueltos
	END CATCH
END
GO

IF EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_notacredito_habilita_descuento' AND type = 'P')
DROP PROCEDURE pa_notacredito_habilita_descuento
GO
----------------------------------------------------------------------------------
-- Author: Alex Llamo IDE-SOLUTION
-- Created: 23/03/2020
-- Sistema: VirgenDelCarmenMantenedor
-- Descripcion: obtener valores para acceder al descuento
-- Log Modificaciones:
-- CODIGO NOMBRE FECHA MOTIVO
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_notacredito_habilita_descuento
(
	@p_codigo INT					-- codigo promocion
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @tipoDescuento INT;				--tipo descuento
	DECLARE @valorDescuento MONEY;			--valoor descuento

	SET @tipoDescuento = 0;
	SET @valorDescuento = 0;

	BEGIN TRY
		SELECT @valorDescuento = valorInicial, @tipoDescuento = valorFinal
		FROM tblDetalleDescuentos
		WHERE ntraDescuento = @p_codigo AND flag = 3 AND marcaBaja = 0;


		SELECT valorInicial as valor, valorFinal as tipo, @valorDescuento as valorDescuento, @tipoDescuento as tipoDescuento
		FROM tblDetalleDescuentos
		WHERE ntraDescuento = @p_codigo AND flag = 2 AND marcaBaja = 0;
	
	END TRY

	BEGIN CATCH
		SELECT ERROR_NUMBER() as valor, 'Error en pa_notacredito_habilita_descuento ' + ERROR_MESSAGE() as tipo, 
		0 as valorDescuento, 0 as tipoDescuento
	END CATCH
END
GO

IF EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_notacredito_habilita_promocion' AND type = 'P')
DROP PROCEDURE pa_notacredito_habilita_promocion
GO
----------------------------------------------------------------------------------
-- Author: Alex Llamo IDE-SOLUTION
-- Created: 23/03/2020
-- Sistema: VirgenDelCarmenMantenedor
-- Descripcion: obtener valores para acceder a la promocion
-- Log Modificaciones:
-- CODIGO NOMBRE FECHA MOTIVO
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_notacredito_habilita_promocion
(
	@p_codigo INT					-- codigo promocion
)
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		SELECT valorInicial as valor, valorFinal as tipo
		FROM tblDetallePromociones
		WHERE ntraPromocion = @p_codigo AND flag = 2 AND marcaBaja = 0;
	
	END TRY

	BEGIN CATCH
		SELECT ERROR_NUMBER() as valor, 'Error en pa_notacredito_habilita_promocion ' + ERROR_MESSAGE() as tipo
	END CATCH
END
GO

IF EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_notacredito_obtener_venta_descuento' AND type = 'P')
DROP PROCEDURE pa_notacredito_obtener_venta_descuento
GO
----------------------------------------------------------------------------------
-- Author: Alex Llamo IDE-SOLUTION
-- Created: 23/03/2020
-- Sistema: VirgenDelCarmenMantenedor
-- Descripcion: obtener detalle venta x descuentos
-- Log Modificaciones:
-- CODIGO NOMBRE FECHA MOTIVO
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_notacredito_obtener_venta_descuento
(
	@p_codigo INT				--codigo de venta
)
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		SELECT codDescuento, itemVenta, importe
		FROM tblVentaDescuento
		WHERE codVenta = @p_codigo AND marcaBaja = 0
		ORDER BY itemVenta ASC;
	
	END TRY

	BEGIN CATCH
		SELECT ERROR_NUMBER() as codDescuento, 'Error en pa_notacredito_obtener_venta_descuento ' + ERROR_MESSAGE() as msje, 0 as importe
	END CATCH
END
GO

IF EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_notacredito_obtener_venta_promocion' AND type = 'P')
DROP PROCEDURE pa_notacredito_obtener_venta_promocion
GO
----------------------------------------------------------------------------------
-- Author: Alex Llamo IDE-SOLUTION
-- Created: 23/03/2020
-- Sistema: VirgenDelCarmenMantenedor
-- Descripcion: obtener detalle venta x promociones
-- Log Modificaciones:
-- CODIGO NOMBRE FECHA MOTIVO
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_notacredito_obtener_venta_promocion
(
	@p_codigo INT				--codigo de venta
)
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		SELECT codPromocion, itemVenta, itemPromocionado
		FROM tblVentaPromocion
		WHERE codVenta = @p_codigo AND marcaBaja = 0
		ORDER BY itemPromocionado ASC;
	
	END TRY

	BEGIN CATCH
		SELECT ERROR_NUMBER() as codPromocion, 'Error en pa_notacredito_obtener_venta_promocion ' + ERROR_MESSAGE() as msje, 0 as itemPromocionado
	END CATCH
END
GO

IF EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_notacredito_obtener_motivos_nc' AND type = 'P')
DROP PROCEDURE pa_notacredito_obtener_motivos_nc
GO
----------------------------------------------------------------------------------
-- Author: Alex Llamo IDE-SOLUTION
-- Created: 23/03/2020
-- Sistema: VirgenDelCarmenMantenedor
-- Descripcion: obtener motivos de nota credito
-- Log Modificaciones:
-- CODIGO NOMBRE FECHA MOTIVO
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_notacredito_obtener_motivos_nc
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		SELECT codigoMotivo, descripcion
		FROM tblMotivoNotaCredito
		WHERE marcaBaja = 0
		ORDER BY codigoMotivo ASC
	
	END TRY

	BEGIN CATCH
		SELECT ERROR_NUMBER() as 'codigoMotivo', 'Error en pa_notacredito_obtener_motivos_nc ' + ERROR_MESSAGE() as 'descripcion'
	END CATCH
END
GO

IF EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_notacredito_obtener_venta' AND type = 'P')
DROP PROCEDURE pa_notacredito_obtener_venta
GO
----------------------------------------------------------------------------------
-- Author: Alex Llamo IDE-SOLUTION
-- Created: 23/03/2020
-- Sistema: VirgenDelCarmenMantenedor
-- Descripcion: obtener datos de venta por codigo
-- Log Modificaciones:
-- CODIGO NOMBRE FECHA MOTIVO
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_notacredito_obtener_venta
(
	@p_codigo INT				--codigo de venta
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @nomVendedor VARCHAR(100);

	SET @nomVendedor = '';

	BEGIN TRY
		
		SELECT @nomVendedor = UPPER(p.apellidoPaterno + ' ' + p.apellidoMaterno + ' ' + p.nombres)
		FROM tblVenta v INNER JOIN tblUsuario u ON v.codVendedor = u.ntraUsuario
		INNER JOIN tblPersona p ON u.codPersona = p.codPersona
		WHERE v.ntraVenta = @p_codigo AND v.estado != 3 
		AND v.marcaBaja = 0 AND u.marcaBaja = 0 AND p.marcaBaja = 0

		SELECT v.ntraVenta as ntraVenta, 
		(CASE WHEN (p.tipoPersona) = 2 THEN UPPER(p.razonSocial) ELSE UPPER(p.apellidoPaterno + ' ' + p.apellidoMaterno + ' ' + p.nombres) END) AS nomCliente,
		v.tipoCambio, v.serie, v.nroDocumento, @nomVendedor as nomVendedor, v.importeTotal, v.importeRecargo, v.tipoVenta
		FROM tblVenta v INNER JOIN tblPersona p ON v.codCliente = p.codPersona
		WHERE v.ntraVenta = @p_codigo AND v.estado != 3 AND v.marcaBaja = 0 AND p.marcaBaja = 0
		
	END TRY

	BEGIN CATCH
		SELECT ERROR_NUMBER() as ntraVenta, 'Error en pa_notacredito_obtener_venta ' + ERROR_MESSAGE() as nomCliente,
		0 as tipoCambio, '' as serie, 0 as nroDocumento, '' as nomVendedor, 0 as tipoVenta
	END CATCH
END
GO

IF EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_notacredito_buscar_ventas' AND type = 'P')
DROP PROCEDURE pa_notacredito_buscar_ventas
GO
----------------------------------------------------------------------------------
-- Author: Alex Llamo IDE-SOLUTION
-- Created: 23/03/2020
-- Sistema: VirgenDelCarmenMantenedor
-- Descripcion: buscar ventas
-- Log Modificaciones:
-- CODIGO NOMBRE FECHA MOTIVO
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_notacredito_buscar_ventas
(
	@p_codigo INT = NULL,				--codigo de venta
	@p_serie VARCHAR(20) = NULL,		--serie
	@p_numero INT = NULL,				--numero documento
	@p_fechaInicio DATE = NULL,			--fecha inicio
	@p_fechaFin DATE = NULL,			--fecha fin
	@p_codCliente INT = NULL,			--codigo cliente
	@p_codVendedor INT = NULL			--codigo vendedor
)
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		SELECT v.ntraVenta as 'ntraVenta', (CASE WHEN (p.tipoPersona) = 2 THEN UPPER(p.razonSocial) ELSE UPPER(p.apellidoPaterno + ' ' + p.apellidoMaterno + ' ' + p.nombres) END) AS 'nombres'
		FROM tblVenta v INNER JOIN tblPersona p ON v.codCliente = p.codPersona
		WHERE v.estado NOT IN (4,5,6) AND v.marcaBaja = 0 AND p.marcaBaja = 0
		--(SELECT MONTH(GETDATE())) = MONTH(v.fechaTransaccion)
		AND (@p_codigo IS NULL OR @p_codigo = v.ntraVenta)
		AND (@p_serie IS NULL OR @p_serie = v.serie)
		AND (@p_numero IS NULL OR @p_numero = v.nroDocumento)
		AND (@p_fechaInicio IS NULL OR v.fechaTransaccion >= @p_fechaInicio)
		AND (@p_fechaFin IS NULL OR v.fechaTransaccion <= @p_fechaFin)
		AND (@p_codCliente IS NULL OR @p_codCliente = v.codCliente)
		AND (@p_codVendedor IS NULL OR @p_codVendedor = v.codVendedor)
		ORDER BY v.ntraVenta DESC
	
	END TRY

	BEGIN CATCH
		SELECT ERROR_NUMBER() as 'ntraVenta', 'Error en pa_notacredito_buscar_ventas ' + ERROR_MESSAGE() as 'nombres'
	END CATCH
END
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_bloquear_usuario' AND type = 'P')
	DROP PROCEDURE pa_bloquear_usuario
GO
----------------------------------------------------------------------------------
-- Author: Wilmer Sanchez IDE-SOLUTION
-- Created: 20/02/2020  
-- Sistema: ws_wa_DistribuidoraVDC
-- Descripción: Bloquear usuario
-- Log Modificaciones: 
-- CODIGO    REQUERIMIENTO          NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_bloquear_usuario
(
	@p_codUsu INT			-- Usuario

)		
AS
	BEGIN
		DECLARE @codigo INT; -- Codigo 
		DECLARE @mensaje VARCHAR(100); -- mensaje
		DECLARE @g_const_2000 SMALLINT; -- valor 2000
		DECLARE @g_const_0 SMALLINT; -- Constante 0
		DECLARE @g_const_3 SMALLINT; -- Constante 3

		SET @mensaje = 'CONSULTA EXITOSA';
		SET @g_const_2000  = 2000;
		SET @g_const_0 = 0;
		SET @g_const_3 = 3;
		
		UPDATE tblUsuario
		SET estado = @g_const_3
		WHERE ntraUsuario = @p_codUsu AND marcaBaja = @g_const_0
		
		SELECT @g_const_2000 as 'codigo', @mensaje as 'mensaje'
			

	END	
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_buscar_det_parametro' AND type = 'P')
	DROP PROCEDURE pa_buscar_det_parametro
GO
----------------------------------------------------------------------------------
-- Author: Wilmer Sanchez IDE-SOLUTION
-- Created: 20/02/2020  
-- Sistema: ws_wa_DistribuidoraVDC
-- Descripción: Buscar detalle parametro
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_buscar_det_parametro		
(
	@p_cod INT			-- Usuario
)	
AS
	BEGIN
		DECLARE @g_const_0 SMALLINT -- valor 0
		
		SET @g_const_0 = 0
		
		SET NOCOUNT ON;  
		
		SELECT tblDetalleParametro.codParametro,
		tblDetalleParametro.tipo,
		tblDetalleParametro.valorEntero1,
		tblDetalleParametro.valorEntero2,
		tblDetalleParametro.valorCaneda1,
		tblDetalleParametro.valorCaneda2,
		tblDetalleParametro.valorMoneda1,
		tblDetalleParametro.valorMoneda2,
		tblDetalleParametro.valorFloat1,
		tblDetalleParametro.valorFloat2,
		tblDetalleParametro.valorFecha1,
		tblDetalleParametro.valorFecha2 
		
		FROM tblParametro INNER JOIN tblDetalleParametro 
		ON tblParametro.codigoParametro = tblDetalleParametro.codParametro
		WHERE tblParametro.codigoParametro = @p_cod AND tblParametro.marcaBaja = @g_const_0
		

	END	
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_cerrar_sesion_usuario' AND type = 'P')
	DROP PROCEDURE pa_cerrar_sesion_usuario
GO
----------------------------------------------------------------------------------
-- Author: Wilmer Sanchez IDE-SOLUTION
-- Created: 03/06/2019  
-- Sistema: ws_wa_DistribuidoraVDC
-- Modulo: General
-- Descripción: Cerrar sesion de usuario
-- Log Modificaciones: 
-- CODIGO    REQUERIMIENTO          NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_cerrar_sesion_usuario
(
	@p_codUsu INT,			-- Usuario
	@p_fecha_fin DATETIME -- Fecha de fin

)		
AS
	BEGIN
		DECLARE @mensaje VARCHAR(100); -- mensaje
		DECLARE @g_const_2000 SMALLINT; -- valor 2000
		DECLARE @g_const_0 SMALLINT; -- Constante 0

		SET @mensaje = '';
		SET @g_const_2000  = 2000;
		SET @g_const_0 = 0;
		
		UPDATE tblLogueoUsu
		SET FechaSalida = @p_fecha_fin
		WHERE codUsuario = @p_codUsu AND FechaSalida IS NULL AND marcabaja = @g_const_0
		
		SET @mensaje = 'ACTUALIZACION EXITOSA'

		SELECT @g_const_2000 as 'codigo', @mensaje as 'mensaje'
			

	END	
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_filtrar_venta_datos' AND type = 'P')
	DROP PROCEDURE pa_filtrar_venta_datos
GO
----------------------------------------------------------------------------------
-- Author: Wilmer Sanchez IDE-SOLUTION
-- Created: 05/03/2020  
-- Sistema: VirgenCarmenMantenedor
-- Descripción: Filtrar venta por codigo
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_filtrar_venta_datos	
(
	@p_ntraVenta INT -- Codigo de venta
)	
AS
	BEGIN
		
		SET NOCOUNT ON;  
		SELECT ntraVenta,serie,nroDocumento, codVendedor,vendedor,codCliente,identificacion, cliente,codUbigeo,tipoVenta, tVenta, tDoc, 
		estPre, fechaPago, fechaTransaccion, importeRecargo, IGV, importeTotal,tipoMoneda,moneda,ntraSucursal,sucursal,
		tipoDocumentoVenta,codPuntoEntrega,direccion,ruta,tipoPersona
						 from v_lista_ventas where ntraVenta = @p_ntraVenta
		

	END	
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_listar_cliente_sunat' AND type = 'P')
	DROP PROCEDURE pa_listar_cliente_sunat
GO
----------------------------------------------------------------------------------
-- Author: Wilmer Sanchez IDE-SOLUTION
-- Created: 05/03/2020  
-- Sistema: ws_wa_DistribuidoraVDC
-- Descripción: Traer cliente de base local de sunat
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_listar_cliente_sunat	
(
	@p_ruc bigint -- 
)	
AS
	BEGIN
		DECLARE @g_const_0 SMALLINT -- valor 0
		
		SET @g_const_0 = 0
		
		SET NOCOUNT ON;  
		SELECT RUC,razonSocial,estCont,condDom,ubigeo,tipVia,nomVia,codZona,nomZona,numero,interior,lote,
					departamento,manzana,kilometro FROM tblSUNAT WHERE RUC = @p_ruc
		

	END	
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_listar_departamentos' AND type = 'P')
	DROP PROCEDURE pa_listar_departamentos
GO
----------------------------------------------------------------------------------
-- Author: Wilmer Sanchez IDE-SOLUTION
-- Created: 26/02/2020  
-- Sistema: ws_wa_DistribuidoraVDC
-- Descripción: Listar departamentos
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_listar_departamentos		
(
	@p_codDep CHAR(2) -- Codigo de departamento, Si es 00 entonces traerá todos los departamentos
)
AS
	BEGIN
		DECLARE @g_const_0 SMALLINT -- valor 0
		DECLARE @g_const_todos CHAR(2) -- Constante para traer todos
		
		SET @g_const_0 = 0
		SET @g_const_todos = '00'
		
		SET NOCOUNT ON;  
		
		IF @p_codDep = @g_const_todos
			BEGIN
				SELECT codDepartamento,nombre FROM tblDepartamento WHERE marcaBaja = @g_const_0				
			END
		ELSE
			BEGIN
				SELECT codDepartamento,nombre FROM tblDepartamento WHERE codDepartamento = @p_codDep AND marcaBaja = @g_const_0
			END
		
		

	END	
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_listar_descuentos_venta' AND type = 'P')
	DROP PROCEDURE pa_listar_descuentos_venta
GO
----------------------------------------------------------------------------------
-- Author: Wilmer Sanchez IDE-SOLUTION
-- Created: 26/03/2020  
-- Sistema: VirgenCarmenMantenedor
-- Descripción: Listar descuentos de una venta
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_listar_descuentos_venta		
(
	@p_codVenta INT  -- Codigo de venta
)
AS
	BEGIN
		
		SET NOCOUNT ON;  
		
		SELECT DISTINCT vp.codVenta,vp.codDescuento,pr.descripcion
		FROM tblVentaDescuento vp 
		INNER JOIN tblDescuentos pr on vp.codDescuento = pr.ntraDescuento
		WHERE vp.codVenta = @p_codVenta
		
		
		

	END	
GO


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


IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_listar_localizacion_cliente' AND type = 'P')
	DROP PROCEDURE pa_listar_localizacion_cliente
GO
----------------------------------------------------------------------------------
-- Author: Wilmer Sanchez IDE-SOLUTION
-- Created: 05/03/2020  
-- Sistema: ws_wa_DistribuidoraVDC
-- Descripción: Listar localizacion por cliente
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_listar_localizacion_cliente	
(
	@p_codPer bigint -- 
)	
AS
	BEGIN
		DECLARE @g_const_0 SMALLINT -- valor 0
		
		SET @g_const_0 = 0
		
		SET NOCOUNT ON;  
		SELECT codPersona,coordenadaX,coordenadaY FROM tblLocalizacion WHERE codPersona = @p_codPer AND marcaBaja = @g_const_0
		
	END	
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_listar_login_fallido_usuario' AND type = 'P')
	DROP PROCEDURE pa_listar_login_fallido_usuario
GO
----------------------------------------------------------------------------------
-- Author: Wilmer Sanchez IDE-SOLUTION
-- Created: 20/02/2020  
-- Sistema: ws_wa_DistribuidoraVDC
-- Descripción: Listar login fallido por usuario
-- Log Modificaciones: 
-- CODIGO    REQUERIMIENTO          NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_listar_login_fallido_usuario
(
	@p_codUsu INT			-- Usuario
)		
AS
	BEGIN
		DECLARE @codigo INT; -- Codigo 
		DECLARE @g_const_0 SMALLINT; -- Constante 0
		

		SET @g_const_0 = 0;
		
		SELECT codUsuario,cantFallido,FechaRegistro 
		FROM tblLoginFallido 
		WHERE codUsuario = @p_codUsu AND marcaBaja = @g_const_0
			

	END	
GO



IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_listar_nc_fecha_venta' AND type = 'P')
	DROP PROCEDURE pa_listar_nc_fecha_venta
GO
----------------------------------------------------------------------------------
-- Author: Wilmer Sanchez IDE-SOLUTION
-- Created: 13/01/2020  
-- Sistema: VirgenCarmenMantenedor
-- Descripción: Traer lista fehca de transaccion de NC por venta 
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_listar_nc_fecha_venta
(
	@p_codVenta INT -- Codigo de venta
)
AS
	BEGIN
		DECLARE @g_const_0 SMALLINT -- valor 0
			
		SET @g_const_0 = 0;

		SET NOCOUNT ON;
		SELECT nc.ntraNotaCredito,nc.fecha,(per.apellidoPaterno + ' ' + per.apellidoPaterno + ' ' + per.apellidoMaterno) as 'vendedor' FROM tblNotaCredito nc
		LEFT JOIN tblUsuario usu ON nc.codUsuario = usu.ntraUsuario
		INNER JOIN tblPersona per ON usu.codPersona = per.codPersona
		WHERE nc.codVenta = @p_codVenta AND  nc.marcaBaja = @g_const_0
		
	END	
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_listar_pago_venta' AND type = 'P')
	DROP PROCEDURE pa_listar_pago_venta
GO
-------------------------------------------------------------------------------------
-- Author: Wilmer Sanchez IDE-SOLUTION
-- Created: 13/01/2020  
-- Sistema: VirgenCarmenMantenedor
-- Descripción: Traer lista de pago por venta 
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_listar_pago_venta
(
	@p_codVenta INT -- Codigo de venta
)
AS
	BEGIN
		DECLARE @g_const_0 SMALLINT -- valor 0
			
		SET @g_const_0 = 0;

		SET NOCOUNT ON;
		SELECT ntraTransaccionPago,fechaTransaccion,horaTransaccion FROM tblTranssaccionesPago WHERE codVenta = @p_codVenta AND marcaBaja = @g_const_0
		
		
	END	
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_listar_preventa_para_venta' AND type = 'P')
	DROP PROCEDURE pa_listar_preventa_para_venta
GO

----------------------------------------------------------------------------------
-- Author: Wilmer Sanchez IDE-SOLUTION
-- Created: 16/03/2020  
-- Sistema: ws_wa_DistribuidoraVDC
-- Descripción: Traer lista de preventa 
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_listar_preventa_para_venta
@ntraPreventa int, --numero de preventa
@codUsuario int,	--codigo del vendedor
@codCliente int,	--codigo del cliente
@codfechaRegistroI date,	--fecha de registro inicial
@codfechaRegistroF date		--fecha de registro final

AS
	BEGIN
		declare @csql nvarchar(1000) --consulta sql
		declare @diasMax int	--dias maximo
		declare @fecha1 date
		declare @fecha2 date
		set @fecha1 = @codfechaRegistroI
		set @fecha2 = @codfechaRegistroF
		select @diasMax = valorEntero2 from tblDetalleParametro where codParametro = 7;
	
		IF @fecha1 = '' and @fecha2 = ''
			BEGIN
				set @fecha2 = GETDATE()
				set @fecha1 = DATEADD(DAY,-@diasMax,@fecha2)
			END
	
	
		set @csql = 'select distinct ntraPreventa, codUsuario,vendedor,codCliente, cliente,tipoVenta, tVenta, tDoc, oVenta, estPre, fecha, fechaEntrega, recargo, igv, total,tipoMoneda,moneda,ntraSucursal,tipoDocumentoVenta,codPuntoEntrega' +
					' from v_preventa_filtros_web where estado = 1 '
	
		if @ntraPreventa != 0
			set @csql = @csql + ' and ntraPreventa = ' + convert(varchar, @ntraPreventa)
		if @codUsuario != 0
			set @csql = @csql + ' and codUsuario = ' + convert(varchar, @codUsuario)
		if @codCliente != 0
			set @csql = @csql + ' and codCliente = ' + convert(varchar, @codCliente)
		
		
		set @csql = @csql+' and fecha BETWEEN ''' + convert(varchar, @fecha1)+''''+' and '''+convert(varchar, @fecha2)+''''
				
		EXEC (@csql)
	
	END
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_listar_promociones_desc_sinc' AND type = 'P')
	DROP PROCEDURE pa_listar_promociones_desc_sinc
GO
----------------------------------------------------------------------------------
-- Author: Wilmer Sanchez IDE-SOLUTION
-- Created: 13/01/2020  
-- Sistema: ws_wa_DistribuidoraVDC
-- Descripción: Traer lista de promociones 
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_listar_promociones_desc_sinc

AS
	BEGIN
		DECLARE @g_const_0 SMALLINT -- valor 0
		DECLARE @g_const_vacio CHAR(1) -- Constante vacio
		DECLARE @g_const_2000 SMALLINT -- Constante 2000
		DECLARE @g_const_msj VARCHAR(200) -- Mensaje
			
		SET @g_const_vacio = '';
		SET @g_const_0 = 0;
		SET @g_const_2000 = 2000
		SET @g_const_msj = 'Consulta exitosa'

		SET NOCOUNT ON;
		
		SELECT ntraPromocion,descripcion as desc_promo FROM tblPromociones  WHERE marcaBaja = @g_const_0
			

	END	
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_listar_promociones_venta' AND type = 'P')
	DROP PROCEDURE pa_listar_promociones_venta
GO
----------------------------------------------------------------------------------
-- Author: Wilmer Sanchez IDE-SOLUTION
-- Created: 26/03/2020  
-- Sistema: VirgenCarmenMantenedor
-- Descripción: Listar promociones de una venta
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_listar_promociones_venta		
(
	@p_codVenta INT  -- Codigo de venta
)
AS
	BEGIN
		
		SET NOCOUNT ON;  
		
		SELECT DISTINCT vp.codVenta,vp.codPromocion,pr.descripcion
		FROM tblVentaPromocion vp 
		INNER JOIN tblPromociones pr on vp.codPromocion = pr.ntraPromocion
		WHERE vp.codVenta = @p_codVenta
		
		
		

	END	
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_listar_provincias' AND type = 'P')
	DROP PROCEDURE pa_listar_provincias
GO
----------------------------------------------------------------------------------
-- Author: Wilmer Sanchez IDE-SOLUTION
-- Created: 26/02/2020  
-- Sistema: ws_wa_DistribuidoraVDC
-- Descripción: Listar provincias
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_listar_provincias		
(
	@p_codDep CHAR(2),
	@p_codProv CHAR(2)  -- Codigo de provincia, Si es 00 entonces traerá todos las provincias
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
				SELECT codDepartamento,codProvincia,nombre FROM tblProvincia WHERE codDepartamento = @p_codDep AND marcaBaja = @g_const_0				
			END
		ELSE
			BEGIN
				SELECT codDepartamento,codProvincia,nombre FROM tblProvincia WHERE codDepartamento = @p_codDep AND codProvincia = @p_codProv AND marcaBaja = @g_const_0
			END
		
		

	END	
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_listar_sucursales' AND type = 'P')
	DROP PROCEDURE pa_listar_sucursales
GO
----------------------------------------------------------------------------------
-- Author: Wilmer Sanchez IDE-SOLUTION
-- Created: 13/01/2020  
-- Sistema: ws_wa_DistribuidoraVDC
-- Descripción: Traer lista de sucursales
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_listar_sucursales		
AS
	BEGIN
		DECLARE @g_const_0 SMALLINT -- valor 0
		
		SET @g_const_0 = 0
		
		SET NOCOUNT ON;  
		SELECT ntraSucursal,descripcion,codUbigeo,factor FROM tblSucursal WHERE marcaBaja =  @g_const_0 
		

	END	
GO



IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_registrar_login_fallido' AND type = 'P')
	DROP PROCEDURE pa_registrar_login_fallido
GO
----------------------------------------------------------------------------------
-- Author: Wilmer Sanchez IDE-SOLUTION
-- Created: 20/02/2020  
-- Sistema: ws_wa_DistribuidoraVDC
-- Descripción: Registro login fallido
-- Log Modificaciones: 
-- CODIGO    REQUERIMIENTO          NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_registrar_login_fallido
(
	@p_codUsu INT,			-- Usuario
	@p_cantFall SMALLINT,			-- tipo de logueo
	@p_fecha DATETIME, -- Fecha de inicio
	@p_ip VARCHAR(20), -- ip
	@p_mac VARCHAR(20) -- MAC

)		
AS
	BEGIN
		DECLARE @codigo INT; -- Codigo 
		DECLARE @mensaje VARCHAR(100); -- mensaje
		DECLARE @g_const_2000 SMALLINT; -- valor 2000
		DECLARE @g_const_0 SMALLINT; -- Constante 0
		

		SET @mensaje = 'CONSULTA EXITOSA';
		SET @g_const_2000  = 2000;
		SET @g_const_0 = 0;
		
		DELETE tblLoginFallido WHERE codUsuario = @p_codUsu AND marcaBaja = @g_const_0;

		INSERT INTO tblLoginFallido(codUsuario, cantFallido, FechaRegistro, usuario,ip,mac)
		VALUES(@p_codUsu,@p_cantFall,@p_fecha,@p_codUsu,@p_ip,@p_mac)
		
		SELECT @g_const_2000 as 'codigo', @mensaje as 'mensaje'
			

	END	
GO



IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_registrar_sesion_usuario' AND type = 'P')
	DROP PROCEDURE pa_registrar_sesion_usuario
GO
----------------------------------------------------------------------------------
-- Author: Wilmer Sanchez IDE-SOLUTION
-- Created: 03/06/2019  
-- Sistema: ws_wa_DistribuidoraVDC
-- Modulo: General
-- Descripción: Registro sesion de usuario
-- Log Modificaciones: 
-- CODIGO    REQUERIMIENTO          NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_registrar_sesion_usuario
(
	@p_codUsu INT,			-- Usuario
	@p_tipoLog SMALLINT,			-- tipo de logueo
	@p_fecha_ini DATETIME, -- Fecha de inicio
	@p_fecha_fin DATETIME = NULL, -- Fecha de fin
	@p_usuario VARCHAR(20)		-- Usuario

)		
AS
	BEGIN
		DECLARE @codigo INT; -- Codigo 
		DECLARE @mensaje VARCHAR(100); -- mensaje
		DECLARE @g_const_2000 SMALLINT; -- valor 2000
		DECLARE @ntra INT; --Numero de transaccion
		

		SET @mensaje = '';
		SET @g_const_2000  = 2000;
		SET @ntra = 0;
		
		INSERT INTO tblLogueoUsu(codUsuario, FechaIngreso, FechaSalida, tipoLogueo, usuario)
		VALUES(@p_codUsu,@p_fecha_ini,@p_fecha_fin,@p_tipoLog,@p_usuario)
		
		SET @ntra = SCOPE_IDENTITY()		
		SET @mensaje = 'CONSULTA EXITOSA'


		SELECT @ntra as 'ntra', @g_const_2000 as 'codigo', @mensaje as 'mensaje'
			

	END	
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_registrar_venta' AND type = 'P')
	DROP PROCEDURE pa_registrar_venta
GO
----------------------------------------------------------------------------------
-- Author: Wilmer Sanchez IDE-SOLUTION
-- Created: 30/01/2020
-- Sistema: ws_wa_DistribuidoraVDC
-- Descripcion: Registrar venta
-- Log Modificaciones:
-- CODIGO NOMBRE FECHA MOTIVO
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[pa_registrar_venta]
(
	-- # @p_serie varchar(20),				-- serie
	-- #@p_nroDocumento INT,			--Numero de documento de venta
	@p_tipoPago SMALLINT,				--Tipo de pago
	@p_codPreventa INT,				--codigo de preventa
	@p_codCliente INT,			--codigo cliente
	@p_codVendedor INT,			--codigo de vendedor
	@p_fechaTransaccion DATE,			--Fecha de transaccion
	@p_tipoMoneda SMALLINT,	--tipo moneda
	@p_tipoVenta SMALLINT,			--Tipo de venta
	@p_tipoCambio SMALLINT,			--Tipo de cambio
	@p_estado SMALLINT,	--Estado
	@p_importeTotal MONEY,		--Importe total
	@p_importeRecargo MONEY,			--Importe recargo
	@p_usuario varchar(20),				--Usuario
	@p_ip varchar(20),					--ip
	@p_mac varchar(20),					--mac
	@p_prestamo XML = NULL,			--lista preventa promocion
	@p_listaCronograma XML = NULL,			--lista preventa descuento
	@p_proceso SMALLINT,
	@p_codSucursal INT,						--codSucursal
	@p_fechaPago DATE,						--Fecha de pago
	@p_prFechaTrans DATETIME,						--Fecha de transaccion
	@p_cuentaCobro XML = NULL, -- Cuenta de pago
	@p_IGV MONEY,		--Importe total
	@p_tipoDocVenta tinyint, --Tipo de documento de venta
	@p_codPuntoEntrega INT, -- Codigo de punto de entrega
	@p_est_reg_cue_cob INT -- Estado para registro de Cuenta de cobro ( 1: si, 0: no)
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @p_serie varchar(20); -- SERIE
	DECLARE @p_nroDocumento INT; --Numero de documento para la venta
	
	
	DECLARE @flag INT;						--flag de proceso
	DECLARE @msje VARCHAR(250);				--mensaje de error
	DECLARE @ntra INT;						--numero de transaccion
	DECLARE @ntraPrestamo INT; -- numero de transaccion de prestamo
	-- Prestamo
	DECLARE @pr_importeTotal MONEY;
	DECLARE @pr_interesTotal MONEY;
	DECLARE @pr_plazo INT;
	DECLARE @pr_nroCuotas INT;
	DECLARE @pr_fechaTransaccion DATETIME;
	DECLARE @pr_tipoPrestamo SMALLINT;
	DECLARE @pr_estado SMALLINT;
	-- Cronograma
	DECLARE @cr_fechaPago DATE;
	DECLARE @cr_nroCuota INT;
	DECLARE @cr_importe MONEY;
	DECLARE @cr_estado INT;
	-- Cuenta de cobro
	DECLARE @cu_fechaPago DATE;
	DECLARE @cu_fechaTrans DATE;
	DECLARE @cu_horaTrans varchar(8);
	DECLARE @cu_importe MONEY;
	DECLARE @cu_estado SMALLINT;
	DECLARE @cu_responsable varchar(250);
	-- Detalle de preventa
	DECLARE @dp_itemPreventa tinyint;
	DECLARE @dp_codPresentacion INT;
	DECLARE @dp_codProducto varchar(10);
	DECLARE @dp_codAlmacen INT;
	DECLARE @dp_cantidadPresentacion INT;
	DECLARE @dp_cantidadUnidadBase INT;
	DECLARE @dp_precioVenta MONEY;
	DECLARE @dp_TipoProducto tinyint;
	-- Preventa promocion
	DECLARE @vp_codPromocion INT;
	DECLARE @vp_itemPreventa tinyint;
	DECLARE @vp_itemPromocionado tinyint;
	-- Preventa descuento
	DECLARE @vd_codDescuento INT;
	DECLARE @vd_itemPreventa tinyint;
	DECLARE @vd_importe MONEY;
	
	

	SET @p_serie = '';
	SET @p_nroDocumento = 0;
	

	SET @flag = 0;
	SET @msje = 'Venta registrada con exito';
	SET @ntra = 0;
	SET @ntraPrestamo = 0;
	
	SET @pr_importeTotal = 0;
	SET @pr_interesTotal = 0;
	SET @pr_plazo = 0;
	SET @pr_nroCuotas = 0;
	--SET @pr_fechaTransaccion = GETDATE() ;
	SET @pr_tipoPrestamo = 0;
	
	-- SET @cr_fechaPago DATE;
	SET @cr_nroCuota  = 0;
	SET @cr_importe  = 0;
	SET @cr_estado  = 0;
	
	BEGIN TRY
		IF(@p_proceso = 1)		--proceso registro
		BEGIN
			BEGIN TRANSACTION
			
				-- Buscamos la serie y numero de documento por sucursal
				IF @p_tipoDocVenta = 1
					BEGIN
						-- boleta
						SELECT @p_nroDocumento = correlativoB,@p_serie = serieB FROM tblSerieVenta where codSucursal = @p_codSucursal AND marcaBaja = 0
						SET @p_nroDocumento = @p_nroDocumento + 1
					END	
				
				IF @p_tipoDocVenta = 2
					BEGIN
						-- factura
						SELECT @p_nroDocumento = correlativoF,@p_serie = serieF FROM tblSerieVenta where codSucursal = @p_codSucursal AND marcaBaja = 0
						SET @p_nroDocumento = @p_nroDocumento + 1
					END	
			
				INSERT INTO tblVenta(serie, nroDocumento,tipoPago,codPreventa,codCliente,codVendedor,fechaTransaccion,tipoMoneda,
														tipoCambio,estado,importeTotal,importeRecargo,tipoVenta,codSucursal,IGV,fechaPago,tipoDocumentoVenta,codPuntoEntrega,usuario,ip,mac)
				VALUES (@p_serie, @p_nroDocumento,@p_tipoPago,@p_codPreventa,@p_codCliente,@p_codVendedor,@p_fechaTransaccion,@p_tipoMoneda,
														@p_tipoCambio,@p_estado,@p_importeTotal,@p_importeRecargo,@p_tipoVenta,@p_codSucursal,@p_IGV,@p_fechaPago,@p_tipoDocVenta,@p_codPuntoEntrega,@p_usuario,@p_ip,@p_mac);
				

				SET @ntra = (SELECT @@IDENTITY);
				
				-- Registro de detalle de productos de venta
				
				DECLARE cur_detalle_prev CURSOR LOCAL STATIC READ_ONLY FORWARD_ONLY FOR 
				SELECT itemPreventa, codPresentacion, codProducto, codAlmacen, cantidadPresentacion, cantidadUnidadBase, precioVenta, TipoProducto 
				FROM tblDetallePreventa WHERE codPreventa =  @p_codPreventa AND marcaBaja = 0            
				OPEN cur_detalle_prev;  
				FETCH NEXT FROM cur_detalle_prev INTO @dp_itemPreventa, @dp_codPresentacion, @dp_codProducto, @dp_codAlmacen, @dp_cantidadPresentacion,
																						 @dp_cantidadUnidadBase, @dp_precioVenta, @dp_TipoProducto;
				WHILE @@FETCH_STATUS = 0
					BEGIN
					
						INSERT INTO tblDetalleVenta(codVenta, itemVenta, codPresentacion, codProducto, codAlmacen, cantidadPresentacion, cantidadUnidadBase, precioVenta, TipoProducto, usuario, ip, mac)
						VALUES(@ntra,@dp_itemPreventa,@dp_codPresentacion,@dp_codProducto,@dp_codAlmacen,@dp_cantidadPresentacion,@dp_cantidadUnidadBase,@dp_precioVenta,@dp_TipoProducto,@p_usuario,@p_ip,@p_mac)
						
						FETCH NEXT FROM cur_detalle_prev INTO @dp_itemPreventa, @dp_codPresentacion, @dp_codProducto, @dp_codAlmacen, @dp_cantidadPresentacion,
																						 @dp_cantidadUnidadBase, @dp_precioVenta, @dp_TipoProducto;

					END
				CLOSE cur_detalle_prev;  
				DEALLOCATE cur_detalle_prev; 
				
				-- Registro de promociones venta
				
				DECLARE cur_prev_promo CURSOR LOCAL STATIC READ_ONLY FORWARD_ONLY FOR 
				SELECT codPromocion, itemPreventa, itemPromocionado 
				FROM tblPreventaPromocion WHERE codPreventa =  @p_codPreventa AND marcaBaja = 0            
				OPEN cur_prev_promo;  
				FETCH NEXT FROM cur_prev_promo INTO @vp_codPromocion, @vp_itemPreventa, @vp_itemPromocionado;
				WHILE @@FETCH_STATUS = 0
					BEGIN
						
						INSERT INTO tblVentaPromocion (codVenta, codPromocion, itemVenta, itemPromocionado, usuario, ip, mac)
						VALUES(@ntra,@vp_codPromocion,@vp_itemPreventa,@vp_itemPromocionado,@p_usuario,@p_ip,@p_mac)

						FETCH NEXT FROM cur_prev_promo INTO @vp_codPromocion, @vp_itemPreventa, @vp_itemPromocionado;

					END
				CLOSE cur_prev_promo;  
				DEALLOCATE cur_prev_promo;
				
				-- Registro de descuentos venta
				
				DECLARE cur_prev_desc CURSOR LOCAL STATIC READ_ONLY FORWARD_ONLY FOR 
				SELECT codDescuento, itemPreventa, importe
				FROM tblPreventaDescuento WHERE codPreventa =  @p_codPreventa AND marcaBaja = 0            
				OPEN cur_prev_desc;  
				FETCH NEXT FROM cur_prev_desc INTO @vd_codDescuento, @vd_itemPreventa, @vd_importe;
				WHILE @@FETCH_STATUS = 0
					BEGIN
						 
						 INSERT INTO tblVentaDescuento (codVenta, codDescuento, itemVenta, importe, usuario, ip, mac)
						 VALUES(@ntra,@vd_codDescuento, @vd_itemPreventa, @vd_importe,@p_usuario,@p_ip,@p_mac)

						FETCH NEXT FROM cur_prev_desc INTO @vd_codDescuento, @vd_itemPreventa, @vd_importe;

					END
				CLOSE cur_prev_desc;  
				DEALLOCATE cur_prev_desc;
				
				IF @p_tipoVenta = 2 
					BEGIN
						SET @pr_importeTotal = cast(@p_prestamo.query('data(CENPrestamo/importeTotal)') as varchar)
						SET @pr_interesTotal = cast(@p_prestamo.query('data(CENPrestamo/interesTotal)') as varchar)
						SET @pr_plazo = cast(@p_prestamo.query('data(CENPrestamo/plazo)') as varchar)
						SET @pr_nroCuotas = cast(@p_prestamo.query('data(CENPrestamo/nroCuotas)') as varchar)
						--SET @pr_fechaTransaccion = cast(@p_prestamo.query('data(CENPrestamo/fechaTransaccion)') as varchar)
						SET @pr_tipoPrestamo = cast(@p_prestamo.query('data(CENPrestamo/tipoPrestamo)') as varchar)
						SET @pr_estado = cast(@p_prestamo.query('data(CENPrestamo/estado)') as varchar)
						
						INSERT INTO tblPrestamo (codVenta, importeTotal, interesTotal, plazo, nroCuotas, fechaTransaccion, tipoPrestamo,estado,usuario, ip, mac)
						VALUES(@ntra,@pr_importeTotal,@pr_interesTotal,@pr_plazo,@pr_nroCuotas,@p_prFechaTrans,@pr_tipoPrestamo,@pr_estado,@p_usuario,@p_ip,@p_mac);
						
						SET @ntraPrestamo = (SELECT @@IDENTITY);
						
						-- Registro de cronograma
						
						IF(NOT @p_listaCronograma IS NULL)
						BEGIN
						
								DECLARE cur_detalle CURSOR LOCAL STATIC READ_ONLY FORWARD_ONLY FOR 
								SELECT cast(colx.query('data(fechaPago)') as varchar), cast(colx.query('data(nroCuota)') as varchar), 
								cast(colx.query('data(importe)') as varchar), cast(colx.query('data(estado)') as varchar) 
								FROM @p_listaCronograma.nodes('ArrayOfCENCronograma/CENCronograma') AS Tabx(Colx)              
								OPEN cur_detalle;  
								FETCH NEXT FROM cur_detalle INTO @cr_fechaPago, @cr_nroCuota, @cr_importe, @cr_estado;
								WHILE @@FETCH_STATUS = 0
									BEGIN
									
									
										INSERT INTO tblCronograma(codPrestamo, fechaPago, nroCuota, importe, estado, usuario, ip, mac)
										VALUES(@ntraPrestamo,@cr_fechaPago,@cr_nroCuota,@cr_importe,@cr_estado,@p_usuario,@p_ip,@p_mac)
										
										FETCH NEXT FROM cur_detalle INTO @cr_fechaPago, @cr_nroCuota, @cr_importe, @cr_estado;
		
									END
								CLOSE cur_detalle;  
								DEALLOCATE cur_detalle; 
						END
						
					END
				-- Actualizamos las series
				IF @p_tipoVenta = 1
					BEGIN
						UPDATE tblSerieVenta SET correlativoB = @p_nroDocumento WHERE codSucursal = @p_codSucursal AND marcaBaja = 0
					END
				IF @p_tipoVenta = 2
					BEGIN
						UPDATE tblSerieVenta SET correlativoF = @p_nroDocumento WHERE codSucursal = @p_codSucursal AND marcaBaja = 0
					END
					
				-- Registro pendiente de pago
				IF @p_est_reg_cue_cob = 1
					BEGIN
					
						SET @cu_fechaPago = cast(@p_cuentaCobro.query('data(CEN_CuentaCobro/fechaCobro)') as varchar)
						-- SET @cu_fechaTrans = GETDATE() -- cast(@p_cuentaCobro.query('data(CEN_CuentaCobro/fechaTransaccion)') as varchar)
						SET @cu_horaTrans = cast(@p_cuentaCobro.query('data(CEN_CuentaCobro/horaTransaccion)') as varchar)
						SET @cu_importe = cast(@p_cuentaCobro.query('data(CEN_CuentaCobro/importe)') as varchar)
						SET @cu_estado = cast(@p_cuentaCobro.query('data(CEN_CuentaCobro/estado)') as varchar)
						SET @cu_responsable = cast(@p_cuentaCobro.query('data(CEN_CuentaCobro/responsable)') as varchar)
	
						INSERT INTO tblCuentaCobro (codOperacion, codModulo, prefijo, correlativo, importe, fechaTransaccion, horaTransaccion, fechaCobro, estado, responsable, usuario, ip, mac)
						VALUES(@ntra,1,1,1,@cu_importe,@p_fechaTransaccion,@cu_horaTrans,@cu_fechaPago,@cu_estado,@cu_responsable,@p_usuario,@p_ip,@p_mac)
					END
					
				-- Cambiar estado de la preventa a facturada - estado 3
				UPDATE tblPreventa SET estado = 3 WHERE ntraPreventa = @p_codPreventa
				
				
				
			COMMIT TRANSACTION
		END
	
		SET @msje = CONCAT(@msje, '. Venta nro ', @ntra)
		SELECT @flag as flag , @msje as msje, @ntra as venta,@p_serie as serie,@p_nroDocumento as nroDocumento
	END TRY
	BEGIN CATCH
		IF (XACT_STATE()) <> 0 
		BEGIN
			ROLLBACK TRANSACTION
		END
		SET @ntra = 0;
		SET @flag = -1;
		SET @msje = 'Error en pa_registrar_venta ' + ERROR_MESSAGE();
		SELECT @flag as flag , @msje as msje, @ntra as venta,'' as serie,0 as nroDocumento
	END CATCH
END
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_validar_sesion_abierta_usuario' AND type = 'P')
	DROP PROCEDURE pa_validar_sesion_abierta_usuario
GO
----------------------------------------------------------------------------------
-- Author: Wilmer Sanchez IDE-SOLUTION
-- Created: 03/06/2019  
-- Sistema: ws_wa_DistribuidoraVDC
-- Modulo: General
-- Descripción: Validar sesion de usuario
-- Log Modificaciones: 
-- CODIGO    REQUERIMIENTO          NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_validar_sesion_abierta_usuario
(
	@p_codUsu INT			-- Usuario

)		
AS
	BEGIN
		DECLARE @mensaje VARCHAR(100); -- mensaje
		DECLARE @g_const_0 SMALLINT; -- Constante 0
		DECLARE @contador SMALLINT; -- Contador de sesiones
		

		SET @mensaje = '';
		SET @contador = 0;
		SET @g_const_0 = 0;
		
		SELECT @contador = COUNT(ntraLogueo) FROM tblLogueoUsu WHERE codUsuario = @p_codUsu AND FechaSalida IS NULL AND marcabaja = @g_const_0
		SET @mensaje = 'CONSULTA EXITOSA'

		SELECT @contador as 'contador', @mensaje as 'mensaje'
			

	END	
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_validar_sesion_usuario' AND type = 'P')
	DROP PROCEDURE pa_validar_sesion_usuario
GO
----------------------------------------------------------------------------------
-- Author: Wilmer Sanchez IDE-SOLUTION
-- Created: 18/02/2020  
-- Sistema: ws_wa_DistribuidoraVDC
-- Descripción: Validar sesion de usuario
-- Log Modificaciones: 
-- CODIGO    REQUERIMIENTO          NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_validar_sesion_usuario
(
	@p_usuario VARCHAR(20),			-- Usuario
	@p_contra VARCHAR(30),			-- Contraseña
	@p_sucursal INT,			-- Sucursal
	@p_keyLogin VARCHAR(30),			-- Clave
	@p_tipo SMALLINT, -- tipo de consulta (1: Login, 2: Estado, 3: ntraUsuario)
	@p_ntraUsuario INT
)		
AS
	BEGIN
		DECLARE @codigo INT -- Codigo 
		DECLARE @mensaje VARCHAR(100) -- mensaje
		DECLARE @estado SMALLINT -- estado
		DECLARE @g_const_0 SMALLINT -- valor 0
		DECLARE @g_const_1 SMALLINT -- valor 1
		DECLARE @g_const_2 SMALLINT -- valor 2
		DECLARE @g_const_3 SMALLINT -- valor 3
		DECLARE @g_const_2000 SMALLINT -- valor 2000
		DECLARE @g_const_1000 SMALLINT -- valor 1000
		DECLARE @g_const_3000 SMALLINT -- valor 3000
		
		DECLARE @pass_aux VARBINARY(8000) -- Contraseña 
		DECLARE @clave VARCHAR(200) -- clave
		DECLARE @pass_desc VARCHAR(200) -- clave desencriptada
		DECLARE @ntra INT -- Numero de transaccion
		DECLARE @desc_concepto VARCHAR(250) -- Descripcion de concepto
		
		BEGIN TRY		

			SET @codigo = 0;
			SET @estado = 0;
			SET @mensaje = '';
			SET @g_const_0 = 0;
			SET @g_const_1 = 1;
			SET @g_const_2 = 2;
			SET @g_const_3 = 3;
			SET @g_const_2000  = 2000;
			SET @g_const_1000  = 1000;
			SET @g_const_3000 = 3000;
			SET @pass_desc = '';
			SET @ntra = 0;
			SET @estado = 0;
			SET @desc_concepto = '';
			
			SET NOCOUNT ON;  
			
			IF @p_tipo = @g_const_3				
				BEGIN					
					SELECT @estado = estado , @ntra= ntraUsuario, @pass_aux = password FROM tblUsuario WHERE ntraUsuario = @p_ntraUsuario AND marcaBaja = @g_const_0
				END
			ELSE
				BEGIN
					SELECT @estado = estado , @ntra= ntraUsuario, @pass_aux = password FROM tblUsuario WHERE users = @p_usuario AND codSucursal = @p_sucursal AND marcaBaja = @g_const_0 			
				END
					
			IF @ntra > @g_const_0
				BEGIN
					SELECT @desc_concepto = descripcion FROM tblConcepto WHERE codConcepto = 14 AND correlativo = @estado AND marcaBaja = @g_const_0
				
					SET  @mensaje = 'USUARIO ' + @desc_concepto
					SET @codigo = @g_const_2000;
					
				END
			ELSE
				BEGIN
					SET @mensaje = 'VALIDACION DE USUARIO INCORRECTA'
					SET @codigo = @g_const_1000
					SET @estado = @g_const_1
				END
			
			IF @p_tipo = @g_const_1 AND @ntra > @g_const_0 AND @estado = @g_const_1
				BEGIN
					
					SELECT @estado = estado, @ntra= ntraUsuario, @pass_aux = password FROM tblUsuario WHERE users = @p_usuario AND codSucursal = @p_sucursal AND marcaBaja = @g_const_0 AND estado = @g_const_1

					SELECT @pass_desc = CAST(DECRYPTBYPASSPHRASE(@p_keyLogin,@pass_aux) AS VARCHAR(MAX))

					IF LTRIM(@pass_desc) = LTRIM(@p_contra) COLLATE SQL_Latin1_General_CP1_CS_AS
						BEGIN
							SET  @mensaje = 'VALIDACION DE USUARIO CORRECTA'
							SET @codigo = @g_const_2000
							SET @estado = @g_const_0;
							--SELECT @ntra AS 'ntraUsuario', @codigo as 'codigo', @mensaje as 'mensaje',@estado as 'estado'
						END
					ELSE
						BEGIN
							SET  @mensaje = 'VALIDACION DE USUARIO INCORRECTA'
							SET @codigo = @g_const_1000
							SET @estado = @g_const_1
							--SELECT @g_const_0 AS 'ntraUsuario', @codigo as 'codigo', @mensaje as 'mensaje',@estado as 'estado'
						END
				END
			
				
			SELECT @ntra AS 'ntraUsuario', @codigo as 'codigo', @mensaje as 'mensaje',@estado as 'estado'					
			
			

		END TRY
		BEGIN CATCH
		
			SET @codigo = @g_const_3000
			SET @estado = @g_const_1
			SET @mensaje = ERROR_MESSAGE()

			SELECT @g_const_0 AS 'ntraUsuario', @codigo as 'codigo', @mensaje as 'mensaje',@estado as 'estado'

		END CATCH

	END	
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_validar_usuario_activo' AND type = 'P')
	DROP PROCEDURE pa_validar_usuario_activo
GO
----------------------------------------------------------------------------------
-- Author: Wilmer Sanchez IDE-SOLUTION
-- Created: 13/01/2020  
-- Sistema: ws_wa_DistribuidoraVDC
-- Descripción: Validar usuario activo
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_validar_usuario_activo
(
	@p_codUsu INT			-- Usuario

)			
AS
	BEGIN
		DECLARE @g_const_0 SMALLINT -- valor 0
		DECLARE @g_const_1 SMALLINT -- valor 1
		DECLARE @cont SMALLINT -- Contador de usuario activo
		
		SET @g_const_0 = 0
		SET @g_const_1 = 1
		
		SET NOCOUNT ON;  
		SELECT @cont = COUNT(ntraUsuario) FROM tblUsuario WHERE ntraUsuario = @p_codUsu AND estado = @g_const_1 AND marcaBaja = @g_const_0
		SELECT @cont AS contador

	END	
GO
IF EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_registrar_meta' AND type = 'P')
DROP PROCEDURE pa_registrar_meta
GO
----------------------------------------------------------------------------------
-- Author: Dany Gelacio -IDE SOLUTION
-- Created: 30/03/2020
-- Sistema: web virgen del Carmen
-- Descripcion: registro de metas
-- Log Modificaciones:
-- CODIGO NOMBRE FECHA MOTIVO
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE pa_registrar_meta
(
	@p_descripcion VARCHAR(250), -- descripcion
	@p_fechInicio date,		     -- fecha inicio
	@p_fechFin date,		     --fecha fin
	@p_usuario varchar(10),		 --usuario
	@resultado int OUTPUT
)
AS
BEGIN
	SET NOCOUNT ON;	
		DECLARE @Proceso int;				    -- codigo proceso, en mejora de este pa
	
BEGIN TRY
	INSERT INTO tblMeta(descripcion, fechaInicio, fechaFin, usuario) values
					(@p_descripcion,@p_fechInicio,@p_fechFin,@p_usuario);		
	SELECT @resultado = 0
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


GO

IF EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_actualizar_meta' AND type = 'P')
DROP PROCEDURE pa_actualizar_meta
GO
----------------------------------------------------------------------------------
-- Author: Dany Gelacio -IDE SOLUTION
-- Created: 30/03/2020
-- Sistema: web virgen del Carmen
-- Descripcion: actualizacion de metas
-- Log Modificaciones:
-- CODIGO NOMBRE FECHA MOTIVO
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[pa_actualizar_meta]
(
	@p_descripcion VARCHAR(250), -- descripcion
	@p_fechInicio date,		     -- fecha inicio
	@p_fechFin date,		     --fecha fin
	@p_codMeta int,				 -- codigo de meta
	@resultado int OUTPUT
)
AS
BEGIN TRY
		
		UPDATE tblMeta SET descripcion=@p_descripcion,fechaInicio=@p_fechInicio,fechaFin=@p_fechFin
			WHERE codMeta = @p_codMeta;		
	SELECT @resultado = 0
END TRY
	BEGIN CATCH
		SELECT @resultado = 1
		IF (XACT_STATE()) <> 0 
		BEGIN
			ROLLBACK TRANSACTION
		END
		SELECT ERROR_NUMBER() as error, ERROR_MESSAGE() as MEN
END CATCH


GO
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
GO


IF EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_actualizar_producto' AND type = 'P')
DROP PROCEDURE pa_actualizar_producto
GO
---------------------------------------------------------------------------------
-- Author: Dany Gelacio -IDE SOLUTION
-- Created: 30/03/2020
-- Sistema: web virgen del Carmen
-- Descripcion: 
-- Log Modificaciones:
-- CODIGO NOMBRE FECHA MOTIVO
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[pa_actualizar_producto]
(	
	@p_descripcion VARCHAR(200), -- descripcion
	@p_codUndBaseVenta int,		 -- unidad base de venta
	@p_codCategoria int,		 -- codigo de categoria
	@p_codSubCat int,			 -- codigo de subcategoria
	@p_tipoProduc int,			 -- tipo de producto
	@p_flagVent smallint,		 -- flag de venta
	@p_codFabricante int,		 -- codigo de fabricante
	@p_proveedor int,			 --codigo de proveedor
	@p_codProd VARCHAR(10),		 -- codigo de producto
	@resultado INT OUTPUT
	
)
AS
BEGIN TRY	
		UPDATE tblProducto SET descripcion = @p_descripcion,codUnidadBaseventa=@p_codUndBaseVenta,
			codCategoria=@p_codCategoria,codSubcategoria= @p_codSubCat,tipoProducto=@p_tipoProduc,
			flagVenta=@p_flagVent, codFabricante=@p_codFabricante WHERE codProducto = @p_codProd
		
		UPDATE tblAbastecimento SET codProveedor=@p_proveedor WHERE codProducto=@p_codProd				
		SELECT @resultado=0;

END TRY
BEGIN CATCH
		SELECT @resultado=1
		SELECT  
			ERROR_NUMBER() AS NumeroDeError   
            ,ERROR_STATE() AS NumeroDeEstado    
            ,ERROR_LINE() AS  NumeroDeLinea  
            ,ERROR_MESSAGE() AS MensajeDeError;  
			
END CATCH


GO
IF EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_listar_producto_xdetalle' AND type = 'P')
DROP PROCEDURE pa_listar_producto_xdetalle   
GO
----------------------------------------------------------------------------
-- Author: Dany Gelacio IDE-SOLUTION
-- Created: 31/03/2020  
-- Sistema: web virgen del carmen
-- Descripción: Listar producto con detalle
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE pa_listar_producto_xdetalle   
    @codProducto varchar(10)	
AS   
BEGIN
    
	SELECT d.codProducto, d.codPresentancion, c.descripcion  , d.cantidadUnidadBase from tblDetallePresentacion d
	INNER JOIN tblConcepto c on c.correlativo = d.codPresentancion
	WHERE (d.codProducto = @codProducto) AND (d.marcaBaja = 0) and (c.codConcepto=12);

END
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_descuento_activar_desactivar' AND type = 'P')
	DROP PROCEDURE pa_descuento_activar_desactivar
GO
----------------------------------------------------------------------------------
-- Author: Diego Sanchez IDE-SOLUTION
-- Created: 30/03/2020  
-- Sistema: Sistema Distribuidora Virgen del Carmen.
-- Descripción: Cambiar estado del descuento
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[pa_descuento_activar_desactivar]
@idDescuento int,
@estado int
AS
BEGIN
	DECLARE @msj VARCHAR(150)
	DECLARE @ntraDescu int
	DECLARE @flag int

	set @ntraDescu = @idDescuento;

	BEGIN TRY
		BEGIN TRANSACTION
			UPDATE tblDescuentos SET estado = @estado WHERE ntraDescuento = @idDescuento;
			SET @msj = 'Se actualizo el estado del descuento';
			SET @flag = 0;
		COMMIT TRANSACTION
		SELECT @flag as flag, @msj as mensaje, @ntraDescu as ntraDescuento
	END TRY
	BEGIN CATCH
		IF (XACT_STATE()) <> 0 
		BEGIN
			ROLLBACK TRANSACTION
		END
		SET @flag = ERROR_NUMBER();
		SET @msj = 'Error en pa_registrar_modificar_preventa ' + ERROR_MESSAGE();
		SELECT @flag as flag , @msj as mensaje, @ntraDescu as ntraDescuento
	END CATCH
END
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_descuento_listar_filtros' AND type = 'P')
	DROP PROCEDURE pa_descuento_listar_filtros
GO
----------------------------------------------------------------------------------
-- Author: Diego Sanchez IDE-SOLUTION
-- Created: 28/03/2020  
-- Sistema: Sistema Distribuidora Virgen del Carmen.
-- Descripción: Obtener la lista de descuentos segun el filtro seleccionado
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[pa_descuento_listar_filtros]
@codProducto VARCHAR(10),
@codVendedor int,
@codCliente int,
@codEstado int,
@codfechaI date,
@codfechaF date
AS
BEGIN
	DECLARE @csql NVARCHAR(1500) --consulta sql

	SET @csql = 'select df.ntraDescuento, df.descripcion, df.flag1 as codProd, df.desProducto as desProd, df.codUnidad, df.desUnidad, df.fechaInicial,df.fechaFin, '+
				'df.horaInicial,df.horaFin,df.desestado as desEstado, df.estado as codEstado, flag2 as cant,flag2_2 as tipoCant,flag3 as descuento,flag3_2 tipodesc,isnull(flag4,0) as codVen, '+
				'CONCAT(per2.nombres,'+ '''  ''' +', per2.apellidoPaterno,' + '''  ''' + ', per2.apellidoMaterno) as vendedor, isnull(flag5,0) as codCli, '+ 
				'CASE 
					when per.tipoPersona = 1 THEN  CONCAT(per.nombres, ' + '''  ''' + ', per.apellidoPaterno,' + '''  ''' + ', per.apellidoMaterno)
					WHEN per.tipoPersona = 2 THEN  per.razonSocial 
				END as cliente, isnull(flag6,0) as vecesDes, isnull(flag7,0) as vecesVen, isnull(flag8,0) as vecesCli
				from v_descuentos_filtros df
				left join tblPersona per on per.codPersona = flag5
				left join tblUsuario usr on usr.ntraUsuario = flag4 
				left join tblPersona per2 on per2.codPersona = usr.codPersona
				where 1=1 '

	if @codProducto != ''
		set @csql = @csql + ' and flag1 = ''' + convert(varchar, @codProducto)+''''
	if @codVendedor != 0
		set @csql = @csql + ' and flag4 = ' + convert(varchar, @codVendedor)
	if @codCliente != 0
		set @csql = @csql + ' and flag5 = ' + convert(varchar, @codCliente)
	if @codEstado != 0
		set @csql = @csql + ' and df.estado = ' + convert(varchar, @codEstado)
	if @codfechaI != '' and @codfechaF != ''
		set @csql = @csql+' and df.fechaInicial >= ''' + convert(varchar, @codfechaI)+''''+' and df.fechaFin <= '''+convert(varchar, @codfechaF)+''''
	
	EXEC (@csql)
	--select @csql;
END
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_descuento_registrar_modificar' AND type = 'P')
	DROP PROCEDURE pa_descuento_registrar_modificar
GO
----------------------------------------------------------------------------------
-- Author: Diego Sanchez IDE-SOLUTION
-- Created: 28/03/2020  
-- Sistema: Sistema Distribuidora Virgen del Carmen.
-- Descripción: Registrar y modificar descuento
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[pa_descuento_registrar_modificar]
@proceso int,	-- 1 = Registrar ; 2 = Modificar

@fechaVigenciaI DATE,
@fechaVigenciaF DATE,
@horaI TIME(0),
@horaF TIME(0),
@estado int,

@codTipo_venta int,
@codProducto varchar(10),
@codUnidadBase int,
@codCantidad int,
@tipoCant int,
@codMonto decimal,
@codTipoMonto int,

@codVendedorReg int,
@codCliente_reg int,
@cod_veces_dec int,
@cod_veces_vend int,
@cod_veces_clie int,
@descripcion varchar(250),

@ntraDescuento int

AS
BEGIN
	
	DECLARE @msj VARCHAR(150)
	DECLARE @ntraDescu int
	DECLARE @flag9 int
	DECLARE @flag int
	SET @flag9 = 0
	
	BEGIN TRY
		IF (@proceso = 1)		--REGISTRAR
		BEGIN
			BEGIN TRANSACTION
				--CABECERA DE DESCUENTOS
				BEGIN
					INSERT INTO tblDescuentos(descripcion, fechaInicial, fechaFin, horaInicial, horaFin, tipoDescuento, estado, usuario)
					VALUES(@descripcion, @fechaVigenciaI,@fechaVigenciaF,@horaI,@horaF, 1, @estado,'EAY');
				END
				BEGIN
					SET @ntraDescu = (SELECT @@IDENTITY);
				END

				--Flag 1
				BEGIN
					INSERT INTO tblDetalleDescuentos(ntraDescuento, flag, descripcion, valorInicial, valorFinal, detalle, estado, usuario)
					VALUES(@ntraDescu, 1,'PRODUCTO CON DESCUENTO', @codProducto, '', 0, 1,'EAY');
				END

				--Flag 2
				BEGIN
					INSERT INTO tblDetalleDescuentos(ntraDescuento, flag, descripcion, valorInicial, valorFinal, detalle, estado, usuario)
					VALUES(@ntraDescu, 2,'CANTIDAD O IMPORTE DEL PRODUCTO CON DESCUENTO', CONVERT(VARCHAR,@codCantidad), CONVERT(VARCHAR,@tipoCant), 0, 1,'EAY');
				END

				--Flag 3
				BEGIN
					INSERT INTO tblDetalleDescuentos(ntraDescuento, flag, descripcion, valorInicial, valorFinal, detalle, estado, usuario)
					VALUES(@ntraDescu, 3,'VALOR A DESCONTAR', CONVERT(VARCHAR,@codMonto), CONVERT(VARCHAR,@codTipoMonto), 0, 1,'EAY');
				END

				--Flag 4
				IF @codVendedorReg != 0
				BEGIN
					INSERT INTO tblDetalleDescuentos(ntraDescuento, flag, descripcion, valorInicial, valorFinal, detalle, estado, usuario)
					VALUES(@ntraDescu, 4,'VENDEDOR APLICA A DESCUENTO', CONVERT(VARCHAR,@codVendedorReg), '', 0, 1,'EAY'); 
				END

				--Flag 5
				IF @codCliente_reg != 0
				BEGIN
					INSERT INTO tblDetalleDescuentos(ntraDescuento, flag, descripcion, valorInicial, valorFinal, detalle, estado, usuario)
					VALUES(@ntraDescu, 5,'CLIENTE APLICA A DESCUENTO', CONVERT(VARCHAR,@codCliente_reg), '', 0, 1,'EAY'); 
				END

				--Flag 6
				IF @cod_veces_dec != 0
				BEGIN
					INSERT INTO tblDetalleDescuentos(ntraDescuento, flag, descripcion, valorInicial, valorFinal, detalle, estado, usuario)
					VALUES(@ntraDescu, 6,'VECES QUE SE PUEDE USAR EL DESCUENTO', CONVERT(VARCHAR,@cod_veces_dec), '', 0, 1,'EAY'); 
				END

				--Flag 7
				IF @cod_veces_vend != 0
				BEGIN
					INSERT INTO tblDetalleDescuentos(ntraDescuento, flag, descripcion, valorInicial, valorFinal, detalle, estado, usuario)
					VALUES(@ntraDescu, 7,'VECES QUE VENDEDOR PUEDE USAR EL DESCUENTO', CONVERT(VARCHAR,@cod_veces_vend), '', 0, 1,'EAY'); 
				END

				--Flag 8
				IF @cod_veces_clie != 0
				BEGIN
					INSERT INTO tblDetalleDescuentos(ntraDescuento, flag, descripcion, valorInicial, valorFinal, detalle, estado, usuario)
					VALUES(@ntraDescu, 8,'VECES QUE CLIENTE PUEDE USAR EL DESCUENTO', CONVERT(VARCHAR,@cod_veces_clie), '', 0, 1,'EAY'); 
				END

				--Flag 9
				IF @flag9 != 0
				BEGIN
					INSERT INTO tblDetalleDescuentos(ntraDescuento, flag, descripcion, valorInicial, valorFinal, detalle, estado, usuario)
					VALUES(@ntraDescu, 9,'IMPORTE MINIMO PARA OBTENER DESCUENTO', '', '', 0, 1,'EAY');
				END

				--Flag 10
				IF @codTipo_venta != 0
				BEGIN
					INSERT INTO tblDetalleDescuentos(ntraDescuento, flag, descripcion, valorInicial, valorFinal, detalle, estado, usuario)
					VALUES(@ntraDescu, 10,'DESCUENTO PARA VENTA AL CONTADO O CREDITO', CONVERT(VARCHAR,@codTipo_venta), '', 0, 1,'EAY'); 
				END

				SET @msj = 'Se registro correctamente';
				SET @flag = 0;
			COMMIT TRANSACTION

			SELECT @flag as flag, @msj as mensaje, @ntraDescu as ntraDescuento

		END
		
		IF (@proceso = 2)		--Actualizar
		BEGIN
			BEGIN TRANSACTION
				SET @ntraDescu = @ntraDescuento;
					BEGIN
				--Actualizar el descuento
				update tblDescuentos set descripcion = @descripcion, fechaInicial = @fechaVigenciaI, fechaFin = @fechaVigenciaF, 
				horaInicial=@horaI, horaFin=@horaF, tipoDescuento=1,estado = @estado, usuario = 'EAY'
				where ntraDescuento = @ntraDescu;
					END
					BEGIN
				--Dar de baja al detalle de un descuento
				DELETE FROM tblDetalleDescuentos WHERE ntraDescuento = @ntraDescu AND marcaBaja = 0;
					END
				--Insertar el nuevo detalle del descuento
				--Flag 1
				BEGIN
					INSERT INTO tblDetalleDescuentos(ntraDescuento, flag, descripcion, valorInicial, valorFinal, detalle, estado, usuario)
					VALUES(@ntraDescu, 1,'PRODUCTO CON DESCUENTO', @codProducto, '', 0, 1,'EAY');
				END

				--Flag 2
				BEGIN
					INSERT INTO tblDetalleDescuentos(ntraDescuento, flag, descripcion, valorInicial, valorFinal, detalle, estado, usuario)
					VALUES(@ntraDescu, 2,'CANTIDAD O IMPORTE DEL PRODUCTO CON DESCUENTO', CONVERT(VARCHAR,@codCantidad), CONVERT(VARCHAR,@tipoCant), 0, 1,'EAY');
				END

				--Flag 3
				BEGIN
					INSERT INTO tblDetalleDescuentos(ntraDescuento, flag, descripcion, valorInicial, valorFinal, detalle, estado, usuario)
					VALUES(@ntraDescu, 3,'VALOR A DESCONTAR', CONVERT(VARCHAR,@codMonto), CONVERT(VARCHAR,@codTipoMonto), 0, 1,'EAY');
				END

				--Flag 4
				IF @codVendedorReg != 0
				BEGIN
					INSERT INTO tblDetalleDescuentos(ntraDescuento, flag, descripcion, valorInicial, valorFinal, detalle, estado, usuario)
					VALUES(@ntraDescu, 4,'VENDEDOR APLICA A DESCUENTO', CONVERT(VARCHAR,@codVendedorReg), '', 0, 1,'EAY'); 
				END

				--Flag 5
				IF @codCliente_reg != 0
				BEGIN
					INSERT INTO tblDetalleDescuentos(ntraDescuento, flag, descripcion, valorInicial, valorFinal, detalle, estado, usuario)
					VALUES(@ntraDescu, 5,'CLIENTE APLICA A DESCUENTO', CONVERT(VARCHAR,@codCliente_reg), '', 0, 1,'EAY'); 
				END

				--Flag 6
				IF @cod_veces_dec != 0
				BEGIN
					INSERT INTO tblDetalleDescuentos(ntraDescuento, flag, descripcion, valorInicial, valorFinal, detalle, estado, usuario)
					VALUES(@ntraDescu, 6,'VECES QUE SE PUEDE USAR EL DESCUENTO', CONVERT(VARCHAR,@cod_veces_dec), '', 0, 1,'EAY'); 
				END

				--Flag 7
				IF @cod_veces_vend != 0
				BEGIN
					INSERT INTO tblDetalleDescuentos(ntraDescuento, flag, descripcion, valorInicial, valorFinal, detalle, estado, usuario)
					VALUES(@ntraDescu, 7,'VECES QUE VENDEDOR PUEDE USAR EL DESCUENTO', CONVERT(VARCHAR,@cod_veces_vend), '', 0, 1,'EAY'); 
				END

				--Flag 8
				IF @cod_veces_clie != 0
				BEGIN
					INSERT INTO tblDetalleDescuentos(ntraDescuento, flag, descripcion, valorInicial, valorFinal, detalle, estado, usuario)
					VALUES(@ntraDescu, 8,'VECES QUE CLIENTE PUEDE USAR EL DESCUENTO', CONVERT(VARCHAR,@cod_veces_clie), '', 0, 1,'EAY'); 
				END

				--Flag 9
				IF @flag9 != 0
				BEGIN
					INSERT INTO tblDetalleDescuentos(ntraDescuento, flag, descripcion, valorInicial, valorFinal, detalle, estado, usuario)
					VALUES(@ntraDescu, 9,'IMPORTE MINIMO PARA OBTENER DESCUENTO', '', '', 0, 1,'EAY');
				END

				--Flag 10
				IF @codTipo_venta != 0
				BEGIN
					INSERT INTO tblDetalleDescuentos(ntraDescuento, flag, descripcion, valorInicial, valorFinal, detalle, estado, usuario)
					VALUES(@ntraDescu, 10,'DESCUENTO PARA VENTA AL CONTADO O CREDITO', CONVERT(VARCHAR,@codTipo_venta), '', 0, 1,'EAY'); 
				END

				SET @msj = 'Se actualizo correctamente ';
				SET @flag = 1
			COMMIT TRANSACTION
			SELECT @flag as flag, @msj as mensaje, @ntraDescu as ntraDescuento
		END
		
	END TRY

	BEGIN CATCH
		IF (XACT_STATE()) <> 0 
		BEGIN
			ROLLBACK TRANSACTION
		END
		SET @flag = ERROR_NUMBER();
		SET @msj = 'Error en pa_registrar_modificar_preventa ' + ERROR_MESSAGE();
		SELECT @flag as flag , @msj as mensaje, @ntraDescu as ntraDescuento
	END CATCH
END
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_obtener_preventa' AND type = 'P')
	DROP PROCEDURE pa_obtener_preventa
GO
----------------------------------------------------------------------------------
-- Author: Diego Sanchez IDE-SOLUTION
-- Created: 25/03/2020  
-- Sistema: Sistema Distribuidora Virgen del Carmen.
-- Descripción: Obtener datos de una preventa
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[pa_obtener_preventa]
@npre int
as
begin
	select distinct ntraPreventa,codUsuario, codCliente, tipoVenta, tipoDocumentoVenta, fechaEntrega, horaEntrega,  
	codPuntoEntrega, cliente, identificacion,direccion, tipoListaPrecio, flagRecargo
	from v_preventa_filtros_web where ntraPreventa = @npre;
end
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_listar_producto_tipo' AND type = 'P')
	DROP PROCEDURE pa_listar_producto_tipo
GO
----------------------------------------------------------------------------------
-- Author: Diego Sanchez IDE-SOLUTION
-- Created: 27/03/2020  
-- Sistema: Sistema Distribuidora Virgen del Carmen.
-- Descripción: Registrar descuento
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[pa_listar_producto_tipo]
	@p_cadena VARCHAR(50),	--cadena
	@p_tipo int -- tipo de producto
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN TRY
		SELECT codProducto, descripcion
		FROM v_listar_productos
		WHERE tipoProducto = @p_tipo and flagVenta = 1 and concatenado LIKE '%'+ RTRIM(LTRIM(@p_cadena)) + '%'
	
	END TRY

	BEGIN CATCH
		SELECT ERROR_NUMBER() as 'codProducto', 'Error en buscar_producto ' + ERROR_MESSAGE() as 'descripcion'
	END CATCH
END
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_producto_obtener_unidadbase' AND type = 'P')
	DROP PROCEDURE pa_producto_obtener_unidadbase
GO
----------------------------------------------------------------------------------
-- Author: Diego Sanchez IDE-SOLUTION
-- Created: 28/03/2020  
-- Sistema: Sistema Distribuidora Virgen del Carmen.
-- Descripción: Obtener la unidad base de un producto
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[pa_producto_obtener_unidadbase]
@codProducto VARCHAR(10)
AS
BEGIN

	SELECT prod.codProducto, codUnidadBaseventa, prePro.descripcion FROM tblProducto prod
	INNER JOIN (select correlativo, descripcion from tblConcepto where codConcepto = 12 and marcaBaja = 0) 
	AS prePro ON prePro.correlativo = prod.codUnidadBaseventa
	WHERE prod.codProducto = @codProducto;

END
GO

IF EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_listar_promocion_filtros' AND type = 'P')
	DROP PROCEDURE pa_listar_promocion_filtros
GO
----------------------------------------------------------------------------------
-- Author: KVASQUEZ IDE-SOLUTION
-- Created: 18/03/2020  
-- Sistema: ws_wa_DistribuidoraVDC
-- Descripción: Traer lista de preventa por filtros
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[pa_listar_promocion_filtros]
@codfechaI date,			--fecha inicial
@codfechaF date,			--fecha final
@codProveedor int,			--cod Proveedor
@codTipoVenta int,			--cod Tipo de venta
@codProducto varchar(10),	--sku del producto
@codVendedor int,			--codigo del vendedor
@codCliente int,			--codigo del cliente
@estado int					--estado de la promocion
AS
BEGIN
	declare @csql nvarchar(1000)	--consulta sql


	set @csql = 'select distinct ntraPromocion,nombrePromo,fechaInicial,fechaFin,estado,estadoPromo,ISNULL(codPersona,0)codPersona,cliente,ISNULL(codVendedor,0)codVendedor,vendedor,codProducto,producto,ISNULL(codTipoVenta,0)codTipoVenta,ISNULL(tipoVenta,0)tipoVenta,ISNULL(codProveedor,0)codProveedor,proveedor ' +
				' proveedor,descImporte, tipoImporte,codProdPromoionado,prodPromocionado,ISNULL(cantVecesUsarProm,0)cantVecesUsarProm,ISNULL(vecesUsarXvendedor,0)vecesUsarXvendedor,ISNULL(cantVecesUsarXvendedor,0)cantVecesUsarXvendedor,ISNULL(vecesUsarXcliente,0)vecesUsarXcliente,ISNULL(cantVecesUsarXcliente,0)cantVecesUsarXcliente,horaInicial,horaFin,cantImporte ' +
				' from v_promocionesfiltrosweb where 1=1 '


	if @codfechaI != '' and @codfechaF != ''
		set @csql = @csql+' and fechaInicial BETWEEN ''' + convert(varchar, @codfechaI)+''''+' and '''+convert(varchar, @codfechaF)+''''
	if @codProveedor != 0
		set @csql = @csql + ' and codProveedor = ' + convert(varchar, @codProveedor)
	if @codTipoVenta != 0
		set @csql = @csql + ' and codTipoVenta = ' + convert(varchar, @codTipoVenta)
	if @codProducto != ''
		set @csql = @csql + ' and codProducto = ''' + convert(varchar, @codProducto)+ ''''
	if @codVendedor != 0
		set @csql = @csql + ' and codVendedor = ' + convert(varchar, @codVendedor)
	if @codCliente != 0
		set @csql = @csql + ' and codPersona = ' + convert(varchar, @codCliente)
	if @estado != 0
		set @csql = @csql + ' and estado = ' + convert(varchar, @estado)
	EXEC (@csql)
	--select @csql

END 

GO

IF EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_busqueda_tipo_venta_pago' AND type = 'P')
DROP PROCEDURE pa_busqueda_tipo_venta_pago
GO
----------------------------------------------------------------------------------
-- Author: WilSON IDE-SOLUTION
-- Created: 24/03/2020  
-- Sistema: Web VirgenCarmenMantenedor
-- Descripción: buscar la venta segun su tipo
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[pa_busqueda_tipo_venta_pago]   
(

--@p_codVendedor INTEGER,
@p_flagFiltro SMALLINT,
@p_ntraVenta INT
)			
AS   
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		IF @p_flagFiltro = 1
		BEGIN
			select ntra, codOperacion ,importe, fechaCobro , c.estado as estado,  v.tipoCambio as tipoCambiov from tblCuentaCobro c
			INNER JOIN tblVenta v on c.codOperacion = v.ntraVenta
			where codModulo = 1 and prefijo = 1 and codOperacion = @p_ntraVenta  and c.estado = 1
		END

		/*IF @p_flagFiltro = 2
		BEGIN
			select ntraVenta as ntra , ntraVenta as codOperacion ,importeTotal as importe, fechaPago as fechaCobro , estado, tipoCambio as tipoCambiov from tblVenta 
			where ntraVenta =  @p_ntraVenta  and estado = 1
		END*/
	END TRY
	BEGIN CATCH
			SELECT ERROR_NUMBER() as 'codOperacion', 'pa_busqueda_tipo_venta_pago' + 
			ERROR_MESSAGE() as 'codOperacion', '' as 'importe', '' as 'fechaCobro', '' as 'estado'
	END CATCH
END
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_obtener_parametros_x_flag_sucursal' AND type = 'P')
	DROP PROCEDURE pa_obtener_parametros_x_flag_sucursal
GO
----------------------------------------------------------------------------------
-- Author: WILSON IDE-SOLUTION
-- Created: 02/04/2020  
-- Sistema: ws_wa_DistribuidoraVDC
-- Descripción: obtner parametros por flag y codigo de sucursal
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_obtener_parametros_x_flag_sucursal
(
	@p_flag INT,
	@p_codSucursal INT
)
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		IF @p_flag = 1
		BEGIN
			SELECT  tipoCambio  FROM tblParametrosGenerales
			WHERE codSucursal = @p_codSucursal AND marcaBaja = 0;
		END

		IF (@p_flag = 2)
		BEGIN
			SELECT  igv FROM tblParametrosGenerales
			WHERE codSucursal = @p_codSucursal AND marcaBaja = 0;
		END
	
	END TRY

	BEGIN CATCH
		SELECT ERROR_NUMBER(), 'Error en pa_obtener_parametros_x_flag_sucursal ' + ERROR_MESSAGE() 
	END CATCH
END
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_registrar_modificar_transaccion_pago' AND type = 'P')
	DROP PROCEDURE pa_registrar_modificar_transaccion_pago
GO
----------------------------------------------------------------------------------
	-- Author: Wilson  Vasquez IDE-SOLUTION
	-- Created: 30/03/2020
	-- Sistema: ws_wa_DistribuidoraVDC
	-- Descripción: Registrar y modificar transaccion de pago
	-- Log Modificaciones:
	-- CODIGO NOMBRE FECHA MOTIVO
	-----------------------------------------------------------------------------------
	-----------------------------------------------------------------------------------
	CREATE PROCEDURE [dbo].[pa_registrar_modificar_transaccion_pago]
	(
		@p_flag TINYINT,					--proceso 1:registro 2:modificacion
		@p_codPrestamo INTEGER = NULL,		--codigo del prestamo
		@p_nroCuota INTEGER = NULL,			--numero de cuota
		@p_codVenta INTEGER,				--codigo de venta 
		@p_ntraMedioPago TINYINT,			--mediode pago
		@p_tipoCambio MONEY,				--tipo de cambio
		@p_tipoMoneda TINYINT,				--tipo  de moneda
		@p_igv MONEY,						--igv 
		@p_estado TINYINT,					--estado de transaccion
		@p_importe MONEY,					-- importe pagado
		@p_vuelto MONEY = NULL,					-- vuelto de lo pagado pagado
		@p_nroTransferencia VARCHAR(50) = NULL,     -- numero de transferencia.
		@p_cuentaTransferencia VARCHAR(100) = NULL, -- cuenta de transferencia
        @p_banco VARCHAR(100) = NULL,				-- banco
        @p_fechaTransferencia DATE = NULL,		-- fecha de transferencia
		@resultado INT OUTPUT				--resultado de la transaccion (codVenta)


	)
	AS
	BEGIN
		SET NOCOUNT ON;
		DECLARE @flag INT;			--flag de proceso
		DECLARE @msje VARCHAR(250);		--mensaje de error
		DECLARE @codVenta INT;		--codigo de persona
		DECLARE @ntraTP INT ;        --ntra de transaccion de pago
		DECLARE @count INT ;        --contador de estados de cuotas

		SET @flag = 0;
		SET @msje = 'Exito';
		SET @codVenta = 0;
		SET @ntraTP = 0;

	

			BEGIN TRY
			IF(@p_flag = 1)		--proceso registro
			BEGIN
				BEGIN TRANSACTION
					INSERT INTO tblTranssaccionesPago(codVenta, ntraMedioPago, 
					tipoCambio, tipoMoneda, IGV,estado,fechaTransaccion,horaTransaccion, usuario,ip, mac) 
					VALUES(@p_codVenta, @p_ntraMedioPago,
					@p_tipoCambio, @p_tipoMoneda, @p_igv,1,GETDATE(),SYSDATETIME(),'','','');

					SELECT TOP 1  @ntraTP = ntraTransaccionPago FROM tblTranssaccionesPago
					ORDER BY ntraTransaccionPago DESC;					 
	
					IF (@p_ntraMedioPago = 1)
					BEGIN
					INSERT INTO tblPagoEfectivo(ntraTransaccionPago,importe,vuelto,tipoMoneda,estado,usuario,ip,mac)
					VALUES(@ntraTP,@p_importe,@p_vuelto,@p_tipoMoneda,1,'','','')

					UPDATE tblCuentaCobro SET estado = @p_estado WHERE codOperacion = @p_codVenta and estado = 1

					--UPDATE tblVenta SET estado = @p_estado WHERE ntraVenta = @p_codVenta
					SELECT @resultado = @p_estado;
					END
					IF (@p_ntraMedioPago = 2)
					BEGIN
					INSERT INTO tblPagoTransferencia(ntraTransaccionPago,nroTransferencia,cuentaTransferencia,banco,importe,tipoMoneda,
					fechaTransferencia,estado,usuario,ip,mac)
					VALUES(@ntraTP,@p_nroTransferencia,@p_cuentaTransferencia,@p_banco,@p_importe,@p_tipoMoneda,
					@p_fechaTransferencia,1,'','','')

					UPDATE tblCuentaCobro SET estado = @p_estado WHERE codOperacion = @p_codVenta and estado = 1

					--UPDATE tblVenta SET estado = @p_estado WHERE ntraVenta = @p_codVenta

					SELECT @resultado = @p_estado;
					END
				COMMIT TRANSACTION
			END
			IF(@p_flag = 2)		--proceso registro
			BEGIN
				BEGIN TRANSACTION
				 	
					INSERT INTO tblTranssaccionesPago(codPrestamo,nroCuota,codVenta, ntraMedioPago, 
					tipoCambio, tipoMoneda, IGV,estado,fechaTransaccion,horaTransaccion, usuario,ip, mac) 
					VALUES(@p_codPrestamo,@p_nroCuota,@p_codVenta, @p_ntraMedioPago,
					@p_tipoCambio, @p_tipoMoneda, @p_igv,1,GETDATE(),SYSDATETIME(),'','','');

					SELECT TOP 1  @ntraTP = ntraTransaccionPago FROM tblTranssaccionesPago
					ORDER BY ntraTransaccionPago DESC;					 
	
					IF (@p_ntraMedioPago = 1)
					BEGIN
						INSERT INTO tblPagoEfectivo(ntraTransaccionPago,importe,vuelto,tipoMoneda,estado,usuario,ip,mac)
						VALUES(@ntraTP,@p_importe,@p_vuelto,@p_tipoMoneda,1,'','','')

						UPDATE tblCronograma SET estado = 2 WHERE codPrestamo = @p_codPrestamo and nroCuota = @p_nroCuota
						
						SELECT @count = COUNT(estado) FROM tblCronograma WHERE estado = 1 AND codPrestamo = @p_codPrestamo

						IF (@count = 0)
						BEGIN
							UPDATE tblPrestamo SET estado = 2 WHERE ntraPrestamo = @p_codPrestamo
							SELECT @resultado = @p_estado;
						END	
						ELSE
						BEGIN
							SELECT @resultado = 1;
						END
					END
					IF (@p_ntraMedioPago = 2)
					BEGIN
						INSERT INTO tblPagoTransferencia(ntraTransaccionPago,nroTransferencia,cuentaTransferencia,banco,importe,tipoMoneda,
						fechaTransferencia,estado,usuario,ip,mac)
						VALUES(@ntraTP,@p_nroTransferencia,@p_cuentaTransferencia,@p_banco,@p_importe,@p_tipoMoneda,
						@p_fechaTransferencia,1,'','','')

						UPDATE tblCronograma SET estado = 2 WHERE codPrestamo = @p_codPrestamo and nroCuota = @p_nroCuota
						
						SELECT @count = COUNT(estado) FROM tblCronograma WHERE estado = 1 AND codPrestamo = @p_codPrestamo

						IF (@count = 0)
						BEGIN
							UPDATE tblPrestamo SET estado = 2 WHERE ntraPrestamo = @p_codPrestamo
							SELECT @resultado = @p_estado;
						END	
						ELSE
						BEGIN
							SELECT @resultado = 1;
						END
					END
				COMMIT TRANSACTION
			END
			
		END TRY
		BEGIN CATCH
			IF (XACT_STATE()) <> 0 
			BEGIN
				ROLLBACK TRANSACTION
			END
			SET @flag = ERROR_NUMBER();
			SET @msje = 'Error en pa_registrar_modificar_transaccion_pago ' + ERROR_MESSAGE();
			SET @codVenta = 0;
			SELECT @flag as flag , @msje as msje, @codVenta as codVenta
		END CATCH
	END

GO

IF EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_notacredito_registrar_nc_total' AND type = 'P')
DROP PROCEDURE pa_notacredito_registrar_nc_total
GO
----------------------------------------------------------------------------------
-- Author: Alex Llamo IDE-SOLUTION
-- Created: 23/03/2020
-- Sistema: VirgenDelCarmenMantenedor
-- Descripcion: registrar datos nota de credito total
-- Log Modificaciones:
-- CODIGO NOMBRE FECHA MOTIVO
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_notacredito_registrar_nc_total
(
	@p_flagReversion TINYINT,	--flag de reversion en NC total
	@p_codVenta INT,			--codigo venta
	@p_codVentaNega INT,		--codigo venta con importes negativos
	@p_codMotivo CHAR(2),		--codigo motivo nc
	@p_fecha DATE,				--fecha
	@p_tipo SMALLINT,			--tipo nc
	@p_importe MONEY,			--importe nc
	@p_usuario VARCHAR(20),		--usuario
	@p_ip VARCHAR(20),						--direccion ip
	@p_mac VARCHAR(20),						--mac
	@p_codSucursal INT,			--codigo de sucursal
	@p_codUsuario INT
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @serie varchar(20); -- SERIE
	DECLARE @numero INT; --Numero de documento para la venta
	DECLARE @tipoVenta INT; --tipo de venta 
	DECLARE @flagCxC INT; --flag de cuenta por cobrar
	DECLARE @flagPagos INT; --flag existe transaccion pago
	DECLARE @ntraNC int; --transaccion de NC
	DECLARE @tipoCambio MONEY; --tipo cambio
	DECLARE @codProducto VARCHAR(20);--codigo de producto
	DECLARE @cantidadUnidadBase SMALLINT; --cantidad productos
	DECLARE @flag INT;
	DECLARE @msje VARCHAR(200);

	DECLARE @contador INT;
	DECLARE @entero INT;
	DECLARE @entero2 INT;
	DECLARE @importe MONEY;

	SET @flag = 0;
	SET @msje = 'EXITO';
	SET @contador = 0;
	SET @entero = 0;
	SET @entero2 = 0;
	SET @importe = @p_importe * -1;
	BEGIN TRY
		BEGIN TRANSACTION

		--ACTUALIZAR VENTA A ESTADO REVERTIDO x NC
		UPDATE tblVenta SET estado = 4
		WHERE ntraVenta = @p_codVenta AND marcaBaja = 0;

		--NOTA CREDITO
		SELECT @tipoCambio = tipoCambio FROM tblParametrosGenerales WHERE codSucursal = @p_codSucursal AND marcaBaja = 0;

		SET @ntraNC = 0;
		SELECT @numero = correlativoNC, @serie = serieNC FROM tblSerieVenta where codSucursal = @p_codSucursal AND marcaBaja = 0
		SET @numero = @numero + 1;
		INSERT INTO tblNotaCredito (serie, numero, codVenta, codVentaNega, codMotivo, fecha, tipo, importe, tipoCambio, usuario,
		estado, codSucursal, ip, mac, codUsuario)
		VALUES (@serie, @numero, @p_codVenta, @p_codVentaNega, @p_codMotivo, @p_fecha, @p_tipo, @p_importe, @tipoCambio, @p_usuario,
		1, @p_codSucursal, @p_ip, @p_mac, @p_codUsuario);
		SET @ntraNC = @@IDENTITY;

		UPDATE tblSerieVenta SET correlativoNC = @numero WHERE codSucursal = @p_codSucursal AND marcaBaja = 0;

		--TIPO VENTA 1 CONTADO - 2 CREDITO
		SET @tipoVenta = 0;
		SELECT @tipoVenta = tipoVenta
		FROM tblVenta
		WHERE ntraVenta = @p_codVenta AND marcaBaja = 0;
		
		SET @flagCxC = 0;
		SET @flagPagos = 0;

		IF(@tipoVenta = 1) --CONTADO
		BEGIN
			-- VERIFICAR EXISTENCIA CUENTA POR COBRAR CxC
			SET @entero = 0;
			SELECT @entero = COUNT(codOperacion)
			FROM tblCuentaCobro
			WHERE codOperacion = @p_codVenta AND marcaBaja = 0;
			IF(@entero > 0)
				SET @flagCxC = 1;
		END
		ELSE --CREDITO
		BEGIN
			
			--PRESTAMO - CRONOGRAMA
			UPDATE tblPrestamo SET estado = 3 --REVERTIDO POR NC
			WHERE codVenta = @p_codVenta AND marcaBaja = 0;
			--CRONOGRAMA
			SET @entero = 0;
			SELECT @entero = ntraPrestamo FROM tblPrestamo WHERE codVenta = @p_codVenta AND marcaBaja = 0;
			UPDATE tblCronograma SET estado = 3 --REVERTIDO POR NC
			WHERE codPrestamo = @entero AND marcaBaja = 0;
		END
		
		IF(@tipoVenta = 2 OR (@tipoVenta = 1 AND @flagCxC = 1) )
		BEGIN
			SET @contador = 0;
			SELECT @contador = COUNT(codVenta) FROM tblTranssaccionesPago 
			WHERE codVenta = @p_codVenta AND marcaBaja = 0;
			IF(@contador > 0)
				SET @flagPagos = 1;
		END

		--(CONTADO Y NO EXISTE CUENTA POR COBRAR) OR 
		--(CONTADO Y EXISTE CxC Y EXISTE TRANSACCION PAGO) OR 
		-- (CREDITO Y EXISTE TRANSACCION PAGO)
		IF((@tipoVenta = 1 AND @flagCxC = 0) OR (@tipoVenta = 1 AND @flagCxC = 1 AND @flagPagos = 1) OR (@tipoVenta = 2 AND @flagPagos = 1))
		BEGIN
			--REGISTRAR CUENTA CORRIENTE
			--obtener codigo cliente
			SET @entero = 0;
			SELECT @entero = codCliente
			FROM tblVenta
			WHERE ntraVenta = @p_codVenta AND marcaBaja = 0;
			--verificar existencia de cc
			SET @contador = 0;
			SELECT @contador = COUNT(codPersona)
			FROM tblCuentaCorriente 
			WHERE codPersona = @entero AND marcaBaja = 0;
			IF(@contador = 0)
			BEGIN
				INSERT INTO tblCuentaCorriente (codPersona, saldoTotal, usuario, ip, mac)
				VALUES (@entero, @p_importe, @p_usuario, @p_ip, @p_mac);
				SET @entero = @@IDENTITY;
				INSERT INTO tblDetalleCuentaCorriente (codCuentaCorriente, codOperacion, codModulo, prefijo, correlativo, importe, 
				usuario, ip, mac)
				VALUES (@entero, @ntraNC, 1, 1, 1, @p_importe, @p_usuario, @p_ip, @p_mac);
			END
			ELSE
			BEGIN
				SET @entero2 = 0;
				SELECT @entero2 = ntraCuentaCorriente
				FROM tblCuentaCorriente
				WHERE codPersona = @entero AND marcaBaja = 0;

				INSERT INTO tblDetalleCuentaCorriente (codCuentaCorriente, codOperacion, codModulo, prefijo, correlativo, importe, 
				usuario, ip, mac)
				VALUES (@entero2, @ntraNC, 1, 1, 1, @p_importe, @p_usuario, @p_ip, @p_mac);

				UPDATE tblCuentaCorriente SET saldoTotal = saldoTotal + @p_importe
				WHERE codPersona = @entero AND marcaBaja = 0;
			END

			--ACTUALIZAR ESTADO DE PAGO
			--
			--no hay estados en tablas efectivo, transaferencia
			UPDATE tblTranssaccionesPago SET estado = 2 --REVERTIDO POR NC
			WHERE codVenta = @p_codVenta AND marcaBaja = 0;

			UPDATE tblPagoEfectivo SET estado = 2 --REVERTIDO POR NC 
			WHERE ntraTransaccionPago IN (SELECT ntraTransaccionPago FROM tblTranssaccionesPago WHERE codVenta = @p_codVenta AND marcaBaja = 0)
			AND marcaBaja = 0;

			UPDATE tblPagoTransferencia SET estado = 2 --REVERTIDO POR NC 
			WHERE ntraTransaccionPago IN (SELECT ntraTransaccionPago FROM tblTranssaccionesPago WHERE codVenta = @p_codVenta AND marcaBaja = 0)
			AND marcaBaja = 0;
			--
		END

		IF(@tipoVenta = 1 AND @flagCxC = 1)
		BEGIN
			-- actualizar estado a revertido x nc
			UPDATE tblCuentaCobro SET estado = 3 --REVERTIDO POR NC
			WHERE codOperacion = @p_codVenta AND marcaBaja = 0;
		END

		--REVERSION DE PREVENTA
		IF (@p_flagReversion = 1)
		BEGIN
		SET @entero = 0;
			SELECT @entero = codPreventa FROM tblVenta WHERE ntraVenta = @p_codVenta AND marcaBaja = 0;
			--REVERTIR PREVENTA
			UPDATE tblPreventa SET estado = 4 WHERE ntraPreventa = @entero AND marcaBaja = 0;

			--ENVIAR STOCK A ALMACEN DE PRODUCTOS DEVUELTOS
			DECLARE cur_stock CURSOR LOCAL STATIC READ_ONLY FORWARD_ONLY FOR 
			SELECT cantidadUnidadBase, codProducto
			FROM tblDetalleVenta WHERE codVenta = @p_codVentaNega AND marcaBaja = 0;
			OPEN cur_stock;  
			FETCH NEXT FROM cur_stock INTO @cantidadUnidadBase, @codProducto
			WHILE @@FETCH_STATUS = 0
				BEGIN
					SET @entero = 0;
					SELECT @entero = COUNT(codProducto) FROM tblInventario 
					WHERE codAlmacen = 2 AND codProducto = @codProducto AND marcaBaja = 0;

					IF(@entero = 0)
					BEGIN
						INSERT INTO tblInventario (codAlmacen, codProducto, stock, usuario, ip, mac)
						VALUES (2, @codProducto, @cantidadUnidadBase, 'MASTER', @p_ip, @p_mac);
					END
					ELSE
					BEGIN
						UPDATE tblInventario SET stock = stock + @cantidadUnidadBase 
						WHERE codAlmacen = 2 AND codProducto = @codProducto AND marcaBaja = 0;
					END	
					FETCH NEXT FROM cur_stock INTO @cantidadUnidadBase, @codProducto;
				END
			CLOSE cur_stock;
			DEALLOCATE cur_stock;


			--
		END
		
		SELECT @flag as flag, @ntraNC AS ntraNC, @msje as msje
		COMMIT TRANSACTION
	
	END TRY

	BEGIN CATCH
		IF (XACT_STATE()) <> 0 
		BEGIN
			ROLLBACK TRANSACTION
		END
		SET @flag = ERROR_NUMBER();
		SET @msje = 'Error en pa_notacredito_registrar_nc_total ' + ERROR_MESSAGE();
		SELECT @flag as flag, 0 AS ntraNC, @msje as msje
	END CATCH
END
GO


IF EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_notacredito_registrar_nc_parcial' AND type = 'P')
DROP PROCEDURE pa_notacredito_registrar_nc_parcial
GO
----------------------------------------------------------------------------------
-- Author: Alex Llamo IDE-SOLUTION
-- Created: 23/03/2020
-- Sistema: VirgenDelCarmenMantenedor
-- Descripcion: registrar datos nota de credito parcial
-- Log Modificaciones:
-- CODIGO NOMBRE FECHA MOTIVO
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_notacredito_registrar_nc_parcial
(
	@p_codVenta INT,			--codigo venta
	@p_codVentaNega INT,		--codigo venta con importes negativos
	@p_codMotivo CHAR(2),		--codigo motivo nc
	@p_fecha DATE,				--fecha
	@p_tipo SMALLINT,			--tipo nc
	@p_importe MONEY,			--importe nc
	@p_usuario VARCHAR(20),		--usuario
	@p_ip VARCHAR(20),			--direccion ip
	@p_mac VARCHAR(20),			--mac
	@p_codSucursal INT,			--codigo de sucursal
	@p_codUsuario INT
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @serie varchar(20); -- SERIE
	DECLARE @numero INT; --Numero de documento para la venta
	DECLARE @tipoVenta INT; --tipo de venta 
	DECLARE @flagCxC INT; --flag de cuenta por cobrar
	DECLARE @flagPagos INT; --flag existe transaccion pago
	DECLARE @ntraNC int; --transaccion de NC
	DECLARE @codProducto VARCHAR(20);--codigo de producto
	DECLARE @cantidadUnidadBase SMALLINT; --cantidad productos
	DECLARE @tipoCambio MONEY; --tipo cambio
	DECLARE @flag INT;
	DECLARE @msje VARCHAR(200);

	DECLARE @contador INT;
	DECLARE @entero INT;
	DECLARE @entero2 INT;
	DECLARE @importe MONEY;
	DECLARE @importe2 MONEY;

	DECLARE @codOpe INT;
	DECLARE @codMod SMALLINT;
	DECLARE @prefij INT;
	DECLARE @correl INT;
	DECLARE @import MONEY;
	DECLARE @fechaT DATE;
	DECLARE @horaTr TIME(0);
	DECLARE @fechaC DATE;
	DECLARE @respon VARCHAR(250);
	DECLARE @hora TIME;

	SET @flag = 0;
	SET @msje = 'EXITO';
	SET @contador = 0;
	SET @entero = 0;
	SET @entero2 = 0;
	SET @importe = @p_importe * -1;
	SET @importe2 = 0;

	SET @hora = (select convert(char(8), getdate(), 108) as [hh:mm:ss])
	BEGIN TRY
		BEGIN TRANSACTION

		--NOTA CREDITO
		SELECT @tipoCambio = tipoCambio FROM tblParametrosGenerales WHERE codSucursal = @p_codSucursal AND marcaBaja = 0;

		SET @ntraNC = 0;
		SELECT @numero = correlativoNC, @serie = serieNC FROM tblSerieVenta where codSucursal = @p_codSucursal AND marcaBaja = 0
		SET @numero = @numero + 1;
		INSERT INTO tblNotaCredito (serie, numero, codVenta, codVentaNega, codMotivo, fecha, tipo, importe, tipoCambio, usuario,
		estado, codSucursal, ip, mac, codUsuario)
		VALUES (@serie, @numero, @p_codVenta, @p_codVentaNega, @p_codMotivo, @p_fecha, @p_tipo, @p_importe, @tipoCambio, @p_usuario,
		1, @p_codSucursal, @p_ip, @p_mac, @p_codUsuario);
		SET @ntraNC = @@IDENTITY;

		UPDATE tblSerieVenta SET correlativoNC = @numero WHERE codSucursal = @p_codSucursal AND marcaBaja = 0;

		--TIPO VENTA 1 CONTADO - 2 CREDITO
		SET @tipoVenta = 0;
		SELECT @tipoVenta = tipoVenta
		FROM tblVenta
		WHERE ntraVenta = @p_codVenta AND marcaBaja = 0;
		
		SET @flagCxC = 0;
		SET @flagPagos = 0;

		IF(@tipoVenta = 1) --CONTADO
		BEGIN
			-- VERIFICAR EXISTENCIA CUENTA POR COBRAR CxC
			SET @entero = 0;
			SELECT @entero = COUNT(codOperacion)
			FROM tblCuentaCobro
			WHERE codOperacion = @p_codVenta AND marcaBaja = 0;
			IF(@entero > 0)
				SET @flagCxC = 1;
		END
		ELSE --CREDITO
		BEGIN
			UPDATE tblPrestamo SET importeTotal = importeTotal - @p_importe --, interesTotal = x
			WHERE codVenta = @p_codVenta AND marcaBaja = 0;
			
			SET @entero = 0;
			SELECT @entero = ntraPrestamo FROM tblPrestamo WHERE codVenta = @p_codVenta AND marcaBaja = 0;
			UPDATE tblCronograma SET importe = importe - @p_importe
			WHERE codPrestamo = @entero AND marcaBaja = 0;
		END
		
		IF(@tipoVenta = 2 OR (@tipoVenta = 1 AND @flagCxC = 1) )
		BEGIN
			SET @contador = 0;
			SELECT @contador = COUNT(codVenta) FROM tblTranssaccionesPago 
			WHERE codVenta = @p_codVenta AND marcaBaja = 0;
			IF(@contador > 0)
				SET @flagPagos = 1;
		END

		--(CONTADO Y EXISTE CxC Y EXISTE TRANSACCION PAGO) OR
		--(CONTADO Y NO EXISTE CxC) OR
		--(CREDITO Y EXISTE TRANSACCION PAGO)
		IF((@tipoVenta = 1 AND @flagCxC = 1 AND @flagPagos = 1) OR (@tipoVenta = 1 AND @flagCxC = 0) OR (@tipoVenta = 2 AND @flagPagos = 1))
		BEGIN
			--REGISTRAR CUENTA CORRIENTE
			--obtener codigo cliente
			SET @entero = 0;
			SELECT @entero = codCliente
			FROM tblVenta
			WHERE ntraVenta = @p_codVenta AND marcaBaja = 0;
			--verificar existencia de cc
			SET @contador = 0;
			SELECT @contador = COUNT(codPersona)
			FROM tblCuentaCorriente 
			WHERE codPersona = @entero AND marcaBaja = 0;
			IF(@contador = 0)
			BEGIN
				INSERT INTO tblCuentaCorriente (codPersona, saldoTotal, usuario, ip, mac)
				VALUES (@entero, @p_importe, @p_usuario, @p_ip, @p_mac);
				SET @entero = @@IDENTITY;
				INSERT INTO tblDetalleCuentaCorriente (codCuentaCorriente, codOperacion, codModulo, prefijo, correlativo, importe, 
				usuario, ip, mac)
				VALUES (@entero, @ntraNC, 1, 1, 1, @p_importe, @p_usuario, @p_ip, @p_mac);
			END
			ELSE
			BEGIN
				SET @entero2 = 0;
				SELECT @entero2 = ntraCuentaCorriente
				FROM tblCuentaCorriente
				WHERE codPersona = @entero AND marcaBaja = 0;

				INSERT INTO tblDetalleCuentaCorriente (codCuentaCorriente, codOperacion, codModulo, prefijo, correlativo, importe, 
				usuario, ip, mac)
				VALUES (@entero2, @ntraNC, 1, 1, 1, @p_importe, @p_usuario, @p_ip, @p_mac);

				UPDATE tblCuentaCorriente SET saldoTotal = saldoTotal + @p_importe
				WHERE codPersona = @entero AND marcaBaja = 0;
			END

			--REGISTRAR PAGO NEGATIVO -- FALTA ESTADO EN PAGO EFECTIVO?
			INSERT INTO tblTranssaccionesPago (nroCuota, codVenta, ntraMedioPago, tipoCambio, tipoMoneda, IGV, fechaTransaccion, 
			horaTransaccion ,usuario, estado, ip, mac)
			VALUES (1, @p_codVentaNega, 1, @tipoCambio, 1, 0, @p_fecha, @hora , @p_usuario, 1, @p_ip, @p_mac);
			SET @entero = @@IDENTITY;
			INSERT INTO tblPagoEfectivo (ntraTransaccionPago, importe, vuelto, tipoMoneda, estado, usuario, ip, mac)
			VALUES (@entero, @importe, 0, 1, 1, @p_usuario, @p_ip, @p_mac);

		END

		IF(@tipoVenta = 1 AND @flagCxC = 1)
		BEGIN
			IF(@flagPagos = 1)
			BEGIN
				UPDATE tblCuentaCobro SET importe = importe - @p_importe
				WHERE codOperacion = @p_codVenta AND marcaBaja = 0;
			END
			ELSE
			BEGIN
				IF(@flagPagos = 0)
				BEGIN
					UPDATE tblCuentaCobro SET estado = 3 -- REVERTIDO X NC
					WHERE codOperacion = @p_codVenta AND marcaBaja = 0;
		
					SELECT @codOpe = codOperacion, @codMod = codModulo, @prefij = prefijo, @correl = correlativo,
					@import = importe, @fechaT = fechaTransaccion, @horaTr = horaTransaccion, @fechaC = fechaCobro,
					@respon = responsable
					FROM tblCuentaCobro 
					WHERE codOperacion = @p_codVenta AND marcaBaja = 0;

					SET @import = @import - @p_importe

					INSERT INTO tblCuentaCobro (codOperacion, codModulo, prefijo, correlativo, importe, 
					fechaTransaccion, horaTransaccion, fechaCobro, estado, responsable, usuario, ip, mac)
					VALUES (@codOpe, @codMod, @prefij, @correl, @import, @fechaT, @horaTr, @fechaC, 1, @respon, @p_usuario, @p_ip, @p_mac);
				END
			END
		END

		--ENVIAR STOCK A ALMACEN DE PRODUCTOS DEVUELTOS
		DECLARE cur_stock CURSOR LOCAL STATIC READ_ONLY FORWARD_ONLY FOR 
		SELECT cantidadUnidadBase, codProducto
		FROM tblDetalleVenta WHERE codVenta = @p_codVentaNega AND marcaBaja = 0;
		OPEN cur_stock;  
		FETCH NEXT FROM cur_stock INTO @cantidadUnidadBase, @codProducto
		WHILE @@FETCH_STATUS = 0
			BEGIN
				SET @entero = 0;
				SELECT @entero = COUNT(codProducto) FROM tblInventario 
				WHERE codAlmacen = 2 AND codProducto = @codProducto AND marcaBaja = 0;

				IF(@entero = 0)
				BEGIN
					INSERT INTO tblInventario (codAlmacen, codProducto, stock, usuario, ip, mac, fechaProceso, horaProceso)
					VALUES (2, @codProducto, @cantidadUnidadBase, 'MASTER', @p_ip, @p_mac, (SELECT CONVERT (date, GETDATE(), 5) ), (select convert(char(8), getdate(), 108) as [hh:mm:ss]));
				END
				ELSE
				BEGIN
					UPDATE tblInventario SET stock = stock + @cantidadUnidadBase 
					WHERE codAlmacen = 2 AND codProducto = @codProducto AND marcaBaja = 0;
				END	
				FETCH NEXT FROM cur_stock INTO @cantidadUnidadBase, @codProducto;
			END
		CLOSE cur_stock;
		DEALLOCATE cur_stock;

		SELECT @flag as flag, @ntraNC AS ntraNC, @msje as msje
		COMMIT TRANSACTION
	
	END TRY

	BEGIN CATCH
		IF (XACT_STATE()) <> 0 
		BEGIN
			ROLLBACK TRANSACTION
		END
		SET @flag = ERROR_NUMBER();
		SET @msje = 'Error en pa_notacredito_registrar_nc_parcial ' + ERROR_MESSAGE();
		SELECT @flag as flag, 0 AS ntraNC, @msje as msje
	END CATCH
END
GO

IF EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_notacredito_registrar_venta_negativo' AND type = 'P')
DROP PROCEDURE pa_notacredito_registrar_venta_negativo
GO
----------------------------------------------------------------------------------
-- Author: Alex Llamo IDE-SOLUTION
-- Created: 23/03/2020
-- Sistema: VirgenDelCarmenMantenedor
-- Descripcion: registrar venta en negativo para nota de credito
-- Log Modificaciones:
-- CODIGO NOMBRE FECHA MOTIVO
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_notacredito_registrar_venta_negativo
(
	@p_codigo INT,				--codigo de venta
	@p_listaDetalles XML,		--lista de detalle venta
	@p_importe MONEY,			--importe
	@p_usuario VARCHAR(20),					--usuario
	@p_ip VARCHAR(20),						--direccion ip
	@p_mac VARCHAR(20)						--mac
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @ntraVN INT;

	--VENTA
	DECLARE @serie varchar(20);
	DECLARE @nroDocumento INT;
	DECLARE @tipoPago SMALLINT;
	DECLARE @codPreventa INT;
	DECLARE @codCliente INT;
	DECLARE @codVendedor INT;
	DECLARE @fechaTransaccion DATE;
	DECLARE @tipoMoneda SMALLINT;
	DECLARE @tipoCambio MONEY;
	DECLARE @estado SMALLINT;
	DECLARE @importeTotal MONEY;
	DECLARE @importeRecargo MONEY;
	DECLARE @tipoVenta SMALLINT;
	DECLARE @codSucursal INT;
	DECLARE @IGV MONEY;
	DECLARE @fechaPago DATE;
	DECLARE @tipoDocVenta tinyint;
	DECLARE @codPuntoEntrega INT;

	--DETALLE
	DECLARE @itemVenta TINYINT; 
	DECLARE @codProducto VARCHAR(10); 
	DECLARE @cantidad INT; 
	DECLARE @cantidad_ub INT; 
	DECLARE @flag_des INT;
	DECLARE @codPresentacion INT;
	DECLARE @codAlmacen INT;
	DECLARE @precioVenta MONEY;
	DECLARE @tipoProducto TINYINT;

	--DESCUENTO
	DECLARE @codDescuento INT;
	DECLARE @importe MONEY;

	--PROMOCION
	DECLARE @flag_pro INT;
	DECLARE @codPromocion INT;
	DECLARE @itemVO TINYINT;

	--PARAMETROS
	DECLARE @por_igv MONEY;
	

	SET @ntraVN = 0;
	SET @itemVenta = 0; 
	SET @codProducto = ''; 
	SET @cantidad = 0; 
	SET @cantidad_ub = 0; 
	SET @flag_des = 0;
	SET @codPresentacion = 0;
	SET @codAlmacen = 0;
	SET @precioVenta = 0;
	SET @tipoProducto = 0;
	SET @codDescuento = 0;
	SET @importe = 0;
	SET @flag_pro = 0;
	SET @codPromocion = 0;
	SET @itemVO = 0;
	SET @por_igv = 0;
	SET @serie = 0;
	SET @nroDocumento = 0;
	SET @tipoPago = 0;
	SET @codPreventa = 0;
	SET @codCliente = 0;
	SET @codVendedor = 0;
	SET @fechaTransaccion = NULL;
	SET @tipoMoneda = 0;
	SET @tipoCambio = 0;
	SET @estado = 0;
	SET @importeTotal = 0;
	SET @importeRecargo = 0;
	SET @tipoVenta = 0;
	SET @codSucursal = 0;
	SET @IGV = 0;
	SET @fechaPago = NULL;
	SET @tipoDocVenta = 0;
	SET @codPuntoEntrega = 0;

	BEGIN TRY
	BEGIN TRANSACTION
		--VENTA
		SELECT @serie = serie, @nroDocumento = nroDocumento, @tipoPago = tipoPago, @codPreventa = codPreventa, 
		@codCliente = codCliente, @codVendedor = codVendedor, @fechaTransaccion = fechaTransaccion, @tipoMoneda = tipoMoneda,
		@tipoCambio = tipoCambio, 
		--@estado = estado, 
		--@importeTotal = importeTotal, 
		--@importeRecargo = importeRecargo, 
		@tipoVenta = tipoVenta, @codSucursal = codSucursal, 
		--@IGV = IGV, 
		@fechaPago = fechaPago, 
		@tipoDocVenta = tipoDocumentoVenta, @codPuntoEntrega = codPuntoEntrega
		FROM tblVenta
		WHERE ntraVenta = @p_codigo AND marcaBaja = 0;

		--PARAMETROS 
		SELECT @por_igv = igv
		FROM tblParametrosGenerales
		WHERE codSucursal = @codSucursal AND marcaBaja = 0;

		SET @importeTotal = @p_importe;
		SET @IGV = ROUND((@importeTotal - (@importeTotal/(@por_igv))),2);
		SET @importeTotal = @importeTotal * -1;
		SET @IGV = @IGV * -1;
		SET @importeRecargo = 0;
		SET @estado = 5 -- VENTA POR REVERSION NC

		INSERT INTO tblVenta(serie, nroDocumento, tipoPago, codPreventa, codCliente, codVendedor, fechaTransaccion, tipoMoneda,
		tipoCambio, estado, importeTotal, importeRecargo, tipoVenta, codSucursal, IGV, fechaPago, tipoDocumentoVenta, 
		codPuntoEntrega, usuario, ip, mac)
		VALUES (@serie, @nroDocumento, @tipoPago, @codPreventa, @codCliente, @codVendedor, @fechaTransaccion, @tipoMoneda,
		@tipoCambio, @estado, @importeTotal, @importeRecargo, @tipoVenta, @codSucursal, @IGV, @fechaPago, @tipoDocVenta,
		@codPuntoEntrega, @p_usuario, @p_ip, @p_mac);

		SET @ntraVN = @@IDENTITY;

		DECLARE cur_detalle CURSOR LOCAL STATIC READ_ONLY FORWARD_ONLY FOR 
		SELECT cast(colx.query('data(itemVenta)') as varchar), cast(colx.query('data(codProducto)') as varchar), 
		cast(colx.query('data(cantidad)') as varchar), cast(colx.query('data(cantidad_ub)') as varchar), 
		cast(colx.query('data(flag_des)') as varchar), cast(colx.query('data(flag_pro)') as varchar)
		FROM @p_listaDetalles.nodes('ArrayOfCENListaDevueltos/CENListaDevueltos') AS Tabx(Colx)              
		OPEN cur_detalle;  
		FETCH NEXT FROM cur_detalle INTO @itemVenta, @codProducto, @cantidad, @cantidad_ub, @flag_des, @flag_pro;
		WHILE @@FETCH_STATUS = 0
			BEGIN
				
				--SET @cantidad = @cantidad * -1;
				--SET @cantidad_ub = @cantidad_ub * -1;

				SELECT @codPresentacion = codPresentacion, @codAlmacen = codAlmacen, 
				@precioVenta = precioVenta, @tipoProducto = TipoProducto
				FROM tblDetalleVenta
				WHERE codVenta = @p_codigo AND itemVenta = @itemVenta AND codProducto = @codProducto AND marcaBaja = 0;
				
				SET @precioVenta = @precioVenta * -1;
				
				INSERT INTO tblDetalleVenta( codVenta, itemVenta, codPresentacion, codProducto, codAlmacen,
				cantidadPresentacion, cantidadUnidadBase, precioVenta, TipoProducto, usuario, ip, mac)
				VALUES( @ntraVN, @itemVenta, @codPresentacion, @codProducto, @codAlmacen, 
				@cantidad, @cantidad_ub, @precioVenta, @tipoProducto, @p_usuario, @p_ip, @p_mac);

				UPDATE tblDetalleVenta SET cantDevNC = cantDevNC + @cantidad
				WHERE codVenta = @p_codigo AND codProducto = @codProducto AND marcaBaja = 0;

				IF(@flag_des = 1)
				BEGIN
					SELECT @codDescuento = codDescuento, @importe = importe
					FROM tblVentaDescuento
					WHERE codVenta = @p_codigo AND itemVenta = @itemVenta AND marcaBaja = 0;

					SET @importe = @importe * -1;

					INSERT INTO tblVentaDescuento (codVenta, codDescuento, itemVenta, importe, usuario, ip, mac)
					VALUES (@ntraVN, @codDescuento, @itemVenta, @importe, @p_usuario, @p_ip, @p_mac);
				END

				IF(@flag_pro = 1)
				BEGIN
					SELECT @codPromocion = codPromocion, @itemVO = itemVenta
					FROM tblVentaPromocion
					WHERE codVenta = @p_codigo AND itemPromocionado = @itemVenta AND marcaBaja = 0;

					INSERT INTO tblVentaPromocion(codVenta, codPromocion, itemVenta, itemPromocionado, usuario, ip, mac)
					VALUES( @ntraVN, @codPromocion, @itemVO, @itemVenta, @p_usuario, @p_ip, @p_mac);
				END
				
				FETCH NEXT FROM cur_detalle INTO @itemVenta, @codProducto, @cantidad, @cantidad_ub, @flag_des, @flag_pro;
			END
		CLOSE cur_detalle;  
		DEALLOCATE cur_detalle;

		SELECT @ntraVN as ntraVN
	COMMIT TRANSACTION
	END TRY

	BEGIN CATCH
		IF (XACT_STATE()) <> 0 
		BEGIN
			ROLLBACK TRANSACTION
		END
		SELECT ERROR_NUMBER() as ntraVN
	END CATCH
END
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_fecha_anulacion_venta' AND type = 'P')
	DROP PROCEDURE pa_fecha_anulacion_venta
GO
----------------------------------------------------------------------------------
-- Author: Wilmer Sanchez IDE-SOLUTION
-- Created: 01/04/2020  
-- Sistema: VirgenCarmenMantenedor
-- Descripción: Traer fecha de anulacion de venta
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_fecha_anulacion_venta
(
	@p_codVenta INT -- Codigo de venta
)
AS
	BEGIN
		DECLARE @g_const_0 SMALLINT -- valor 0
			
		SET @g_const_0 = 0;

		SET NOCOUNT ON;
		SELECT ntraVentaAnulada,fecha FROM tblVentasAnuladas WHERE codVenta = @p_codVenta AND marcaBaja = @g_const_0 
		
	END	
GO


IF EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_eliminar_promociones' AND type = 'P')
DROP PROCEDURE pa_eliminar_promociones
GO
----------------------------------------------------------------------------------
-- Author: Kevin V - IDE-SOLUTION
-- Created: 24/03/2020  
-- Sistema: ws_wa_DistribuidoraVDC
-- Descripción: Eliminar Promociones
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[pa_eliminar_promociones]
(
	@codProm INT,				--codigo de la promocion
	@resultado INT OUTPUT		--mensaje
)

AS
	BEGIN
		BEGIN TRY
			UPDATE tblPromociones SET estado = 2  WHERE ntraPromocion = @codProm	

			UPDATE tblDetallePromociones set estado = 2 where ntraPromocion = @codProm	
			SELECT @resultado = @codProm
		END TRY
		BEGIN CATCH
				SELECT  
					ERROR_NUMBER() AS NumeroDeError   
				   ,ERROR_STATE() AS NumeroDeEstado    
				   ,ERROR_LINE() AS  NumeroDeLinea  
				   ,ERROR_MESSAGE() AS MensajeDeError;  
		END CATCH
END

GO

IF EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_notacredito_impresion_cabecera_venta_nc' AND type = 'P')
DROP PROCEDURE pa_notacredito_impresion_cabecera_venta_nc
GO
----------------------------------------------------------------------------------
-- Author: Alex Llamo IDE-SOLUTION
-- Created: 23/03/2020
-- Sistema: VirgenDelCarmenMantenedor
-- Descripcion: obtener datos venta negativo
-- Log Modificaciones:
-- CODIGO NOMBRE FECHA MOTIVO
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_notacredito_impresion_cabecera_venta_nc
(
	@p_codNotaCredito INT	--codigo nota credito
)
AS
BEGIN
	SET NOCOUNT ON;
	--DATOS NC
	DECLARE @serie VARCHAR(20);
	DECLARE @numero INT;
	DECLARE @tipoCambio MONEY;
	DECLARE @fecha DATE;
	DECLARE @tipoNC VARCHAR(50);
	DECLARE @motivoNC VARCHAR(100);
	DECLARE @importe MONEY;
	DECLARE @codVentaNega INT;

	--DATOS VENTA
	DECLARE @serieV VARCHAR(20);
	DECLARE @numeroV INT;
	DECLARE @codCliente INT;
	DECLARE @importeTotalV MONEY;
	DECLARE @importeIgvV MONEY;
	DECLARE @importeSubTotalV MONEY;

	--DATOS CLIENTE
	DECLARE @nombreC VARCHAR(200);
	DECLARE @nroDocumentoC VARCHAR(15);

	SET @serie = '';
	SET @numero = 0;
	SET @tipoCambio = 0;
	SET @fecha = NULL;
	SET @tipoNC = '';
	SET @motivoNC = '';
	SET @importe = 0;
	SET @codVentaNega = 0;
	SET @serieV = '';
	SET @numeroV = 0;
	SET @codCliente = 0;
	SET @importeTotalV = 0;
	SET @importeIgvV = 0;
	SET @importeSubTotalV = 0;
	SET @nombreC = '';
	SET @nroDocumentoC = '';

	BEGIN TRY
		--DATOS NC:
		SELECT @serie = nc.serie, @numero = nc.numero, @tipoCambio = nc.tipoCambio, @fecha = nc.fecha,
		@tipoNC = con.descripcion, @motivoNC = mnc.descripcion, @importe = nc.importe, @codVentaNega = nc.codVentaNega
		FROM tblNotaCredito nc INNER JOIN tblMotivoNotaCredito mnc ON nc.codMotivo = mnc.codigoMotivo
		INNER JOIN tblConcepto con ON con.correlativo = nc.tipo
		WHERE nc.ntraNotaCredito = @p_codNotaCredito AND con.codConcepto = 37 AND nc.marcaBaja = 0 AND mnc.marcaBaja = 0

		--DATOS VENTA
		SELECT @serieV = serie, @numeroV = nroDocumento, @codCliente = codCliente, @importeTotalV = (importeTotal*-1),
		@importeIgvV = (IGV*-1)
		FROM tblVenta 
		WHERE ntraVenta = @codVentaNega AND marcaBaja = 0;
		--SET @importeTotalV = @importeTotalV * -1;
		SET @importeSubTotalV = ROUND((@importeTotalV - @importeIgvV),2);

		--DATOS CLIENTE
		SELECT @nombreC = (CASE WHEN (tipoPersona) = 2 THEN UPPER(razonSocial) ELSE UPPER(apellidoPaterno + ' ' + apellidoMaterno + ' ' + nombres) END),
		@nroDocumentoC = (CASE WHEN (tipoPersona) = 2 THEN UPPER(ruc) ELSE UPPER(numeroDocumento) END)
		FROM tblPersona
		WHERE codPersona = @codCliente AND marcaBaja = 0;

		--DATOS NC
		SELECT @serie as serieNC, @numero as numeroNC, @tipoCambio as tipoCambioNC, @fecha as fechaNC,
		@tipoNC as tipoNC, @motivoNC as motivoNC,
		--DATOS VENTA
		@serieV as serieV, @numeroV as numeroV, @importeTotalV as importeTotalV, @importeIgvV as importeIgvV,
		@importeSubTotalV as importeSubTotalV,
		--DATOS CLIENTE
		@nombreC as nombreC, @nroDocumentoC as nroDocumentoC
	
	END TRY

	BEGIN CATCH
		SELECT '' as serieNC, ERROR_NUMBER() as numeroNC, 0 as tipoCambioNC, '' as fechaNC,
		'' as tipoNC, '' as motivoNC,
		--DATOS VENTA
		'' as serieV, 0 as numeroV, 0 as importeTotalV, 0 as importeIgvV,
		0 as importeSubTotalV,
		--DATOS CLIENTE
		'Error en pa_notacredito_impresion_cabecera_venta_nc ' + ERROR_MESSAGE() as nombreC, '' as nroDocumentoC
	END CATCH
END
GO

IF EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_notacredito_impresion_detalle_venta_nc' AND type = 'P')
DROP PROCEDURE pa_notacredito_impresion_detalle_venta_nc
GO
----------------------------------------------------------------------------------
-- Author: Alex Llamo IDE-SOLUTION
-- Created: 23/03/2020
-- Sistema: VirgenDelCarmenMantenedor
-- Descripcion: obtener datos de detalle venta negativo
-- Log Modificaciones:
-- CODIGO NOMBRE FECHA MOTIVO
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_notacredito_impresion_detalle_venta_nc
(
	@p_codNotaCredito INT	--codigo nota credito
)
AS
BEGIN
	SET NOCOUNT ON;
	--DATOS VENTA
	DECLARE @codVentaNega INT;

	--DATOS DETALLE VENTA:
	DECLARE @itemVenta INT;
	DECLARE @codProducto VARCHAR(20);
	DECLARE @descProducto VARCHAR(150);
	DECLARE @cantidad INT;
	DECLARE @descUnidad VARCHAR(100);
	DECLARE @precioVenta MONEY;
	DECLARE @tipoProducto INT;
	DECLARE @descTipoProducto VARCHAR(100);
	DECLARE @subTotal MONEY;

	CREATE TABLE #temporal
	(itemVenta INT,
	codProducto VARCHAR(20),
	descProducto VARCHAR(150),
	cantidad INT,
	descUnidad VARCHAR(100),
	precioVenta MONEY,
	descTipoProducto VARCHAR(100),
	subTotal MONEY);

	SET @codVentaNega = 0;
	SET @itemVenta = 0;
	SET @codProducto = '';
	SET @descProducto = '';
	SET @cantidad = 0;
	SET @descUnidad= '';
	SET @precioVenta = 0;
	SET @tipoProducto = 0;
	SET @descTipoProducto = '';
	SET @subTotal = 0;


	BEGIN TRY
		--DATOS VENTA:
		SELECT @codVentaNega = codVentaNega
		FROM tblNotaCredito 
		WHERE ntraNotaCredito = @p_codNotaCredito AND marcaBaja = 0;

		--DATOS DETALLE VENTA:
		DECLARE cur_stock CURSOR LOCAL STATIC READ_ONLY FORWARD_ONLY FOR 
		SELECT dv.itemVenta, dv.codProducto, p.descripcion, dv.cantidadPresentacion, c.descripcion, 
		(dv.precioVenta * -1), dv.TipoProducto, (dv.cantidadUnidadBase * dv.precioVenta * -1)
		FROM tblDetalleVenta dv INNER JOIN tblProducto p ON p.codProducto = dv.codProducto
		INNER JOIN tblConcepto c ON c.correlativo = dv.codPresentacion
		WHERE dv.codVenta = @codVentaNega AND c.codConcepto = 12
		ORDER BY dv.itemVenta ASC;

		OPEN cur_stock;  
		FETCH NEXT FROM cur_stock INTO @itemVenta, @codProducto, @descProducto, @cantidad, @descUnidad, @precioVenta, 
		@tipoProducto, @subTotal
		WHILE @@FETCH_STATUS = 0
			BEGIN
				SELECT  @descTipoProducto = descripcion FROM tblConcepto 
				WHERE codConcepto = 22 AND correlativo = @tipoProducto AND marcaBaja = 0;

				INSERT INTO #temporal
				SELECT @itemVenta as itemVenta, @codProducto as codProducto, @descProducto as descProducto, 
				@cantidad as cantidad, @descUnidad as descUnidad, @precioVenta as precioVenta, 
				@descTipoProducto as descTipoProducto, @subTotal as subTotal
				
				FETCH NEXT FROM cur_stock INTO 
				@itemVenta, @codProducto, @descProducto, @cantidad, @descUnidad, @precioVenta, 
				@tipoProducto, @subTotal
			END
		CLOSE cur_stock;
		DEALLOCATE cur_stock;

		SELECT * FROM #temporal;

	END TRY

	BEGIN CATCH
		SELECT ERROR_NUMBER() as itemVenta, '' as codProducto, 'Error en pa_notacredito_impresion_detalle_venta_nc ' + ERROR_MESSAGE() as descProducto, 
		0 as cantidad, '' as descUnidad, 0 as precioVenta, 
		'' as descTipoProducto, 0 as subTotal

	END CATCH
END
GO

IF EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_eliminar_presentacion_producto' AND type = 'P')
DROP PROCEDURE pa_eliminar_presentacion_producto
GO
-----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
-- Autor: Dany Gelacio IDE-SOLUTION
-- Created: 13/04/2020  
-- Sistema: Sistema Distribuidora Virgen del Carmen
-- Modulo: General
-- Descripción: Eliminar detalle presentacion producto
-----------------------------------------------------------------------------------
create procedure pa_eliminar_presentacion_producto	
(
	@codProducto VARCHAR(10),   --Codigo de producto
	@resultado INT OUTPUT
)

AS
	BEGIN
		BEGIN TRY					
			UPDATE tblDetallePresentacion SET marcaBaja = 9 WHERE codProducto = @codProducto AND marcaBaja = 0
				SELECT @resultado = 0		
		END TRY
			BEGIN CATCH
				SELECT  
				   ERROR_NUMBER() AS NumeroDeError   
				   ,ERROR_STATE() AS NumeroDeEstado    
				   ,ERROR_LINE() AS  NumeroDeLinea  
				   ,ERROR_MESSAGE() AS MensajeDeError; 

		END CATCH

END
GO



IF EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_insertar_promociones' AND type = 'P')
DROP PROCEDURE pa_insertar_promociones
GO

----------------------------------------------------------------------------------
-- Author: KVASQUEZ IDE-SOLUTION
-- Created: 03/04/2020  
-- Sistema: ws_wa_DistribuidoraVDC
-- Descripción: Insertar Promociones
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[pa_insertar_promociones]
(
	@descripcion VARCHAR(100),
	@fechaInicial DATE,
	@fechaFin DATE,
	@horaInicial TIME(7),
	@horaFin TIME(7),
	@estado INT,

	@descripcion1 VARCHAR(100),
	@valorInicial1 VARCHAR(200),
	--@valorFinal1 VARCHAR(200),
	--@detalle1 TINYINT,
	--@estado1 TINYINT,

	@descripcion2 VARCHAR(100),
	@valorInicial2 VARCHAR(200),
	@valorFinal2 VARCHAR(200),
	--@detalle2 TINYINT,
	--@estado2 TINYINT,

	--@descripcion3 VARCHAR(100),
	--@valorInicial3 VARCHAR(200),
	--@valorFinal3 VARCHAR(200),
	--@detalle3 TINYINT,
	--@estado3 TINYINT,

	@descripcion4 VARCHAR(100),
	@valorInicial4 VARCHAR(200),
	--@valorFinal4 VARCHAR(200),
	--@detalle4 TINYINT,
	--@estado4 TINYINT,

	@descripcion5 VARCHAR(100),
	@valorInicial5 VARCHAR(200),
	--@valorFinal5 VARCHAR(200),
	--@detalle5 TINYINT,
	--@estado5 TINYINT,

	--@descripcion6 VARCHAR(100),
	@valorInicial6 VARCHAR(200),
	--@valorFinal6 VARCHAR(200),
	--@detalle6 TINYINT,
	--@estado6 TINYINT,

	--@descripcion7 VARCHAR(100),
	@valorInicial7 VARCHAR(200),
	--@valorFinal7 VARCHAR(200),
	--@detalle7 TINYINT,
	--@estado7 TINYINT,

	--@descripcion8 VARCHAR(100),
	@valorInicial8 VARCHAR(200),
	--@valorFinal8 VARCHAR(200),
	--@detalle8 TINYINT,
	--@estado8 TINYINT,

	@descripcion9 VARCHAR(100),
	@valorInicial9 VARCHAR(200),
	--@valorFinal9 VARCHAR(200),
	--@detalle9 TINYINT,
	--@estado9 TINYINT,

	@resultado INT OUTPUT
)

AS
	BEGIN
	DECLARE @ntraPromocion INT
	--DECLARE @descripcion2 VARCHAR(100)
	DECLARE @descripcion3 VARCHAR(100)
	DECLARE @descripcion6 VARCHAR(100) 
	DECLARE @descripcion7 VARCHAR(100)
	DECLARE @descripcion8 VARCHAR(100)

BEGIN TRY
	SET @ntraPromocion = 0
	--SET @descripcion2 = 'CANTIDAD O IMPORTE DEL PRODUCTO CON PROMOCION'
	SET @descripcion3 = 'PRODUCTO PROMOCIONADO'
	SET @descripcion6 = 'VECES VALIDAS PARA USAR LA PROMOCION'
	SET @descripcion7 = 'VECES VALIDAS QUE UN VENDEDOR PUEDE USAR LA PROMOCION'
	SET @descripcion8 = 'VECES VALIDAS QUE UN CLIENTE PUEDE USAR LA PROMOCION'


		BEGIN
			INSERT INTO tblPromociones
			(descripcion,fechaInicial,fechaFin,horaInicial,horaFin,estado,usuario)
			VALUES (@descripcion,@fechaInicial,@fechaFin,@horaInicial,@horaFin,@estado,'EAY');

			SELECT @ntraPromocion =  IDENT_CURRENT ('tblPromociones');
			
			INSERT INTO tblDetallePromociones
			(ntraPromocion,flag,descripcion, valorInicial, valorFinal, detalle, estado, usuario)
			VALUES (@ntraPromocion,1,@descripcion1,@valorInicial1,'',0,1,'EAY');

			INSERT INTO tblDetallePromociones
			(ntraPromocion,flag,descripcion, valorInicial, valorFinal, detalle, estado, usuario)
			VALUES (@ntraPromocion,2,@descripcion2,@valorInicial2,@valorFinal2,0,1,'EAY');

			INSERT INTO tblDetallePromociones
			(ntraPromocion,flag,descripcion, valorInicial, valorFinal, detalle, estado, usuario)
			VALUES (@ntraPromocion,3,@descripcion3,'','',1,1,'EAY');

			IF @valorInicial4 <> ''
				INSERT INTO tblDetallePromociones
				(ntraPromocion,flag,descripcion, valorInicial, valorFinal, detalle, estado, usuario)
				VALUES (@ntraPromocion,4,@descripcion4,@valorInicial4,'',0,1,'EAY');

			IF @valorInicial5 <> ''
				INSERT INTO tblDetallePromociones
				(ntraPromocion,flag,descripcion, valorInicial, valorFinal, detalle, estado, usuario)
				VALUES (@ntraPromocion,5,@descripcion5,@valorInicial5,'',0,1,'EAY');

			IF @valorInicial6 <> ''
				INSERT INTO tblDetallePromociones
				(ntraPromocion,flag,descripcion, valorInicial, valorFinal, detalle, estado, usuario)
				VALUES (@ntraPromocion,6,@descripcion6,@valorInicial6,'',0,1,'EAY');

			IF @valorInicial7 <> ''
				INSERT INTO tblDetallePromociones
				(ntraPromocion,flag,descripcion, valorInicial, valorFinal, detalle, estado, usuario)
				VALUES (@ntraPromocion,7,@descripcion7,@valorInicial7,'',0,1,'EAY');

			IF @valorInicial8 <> ''
				INSERT INTO tblDetallePromociones
				(ntraPromocion,flag,descripcion, valorInicial, valorFinal, detalle, estado, usuario)
				VALUES (@ntraPromocion,8,@descripcion8,@valorInicial8,'',0,1,'EAY');

			IF @valorInicial9 <> ''
				INSERT INTO tblDetallePromociones
				(ntraPromocion,flag,descripcion, valorInicial, valorFinal, detalle, estado, usuario)
				VALUES (@ntraPromocion,9,@descripcion9,@valorInicial9,'',0,1,'EAY');
			
			SELECT @resultado =  @ntraPromocion
		
		END
END TRY
BEGIN CATCH

		SELECT  
			ERROR_NUMBER() AS NumeroDeError   
            ,ERROR_STATE() AS NumeroDeEstado    
            ,ERROR_LINE() AS  NumeroDeLinea  
            ,ERROR_MESSAGE() AS MensajeDeError;  
END CATCH

END;

GO



IF EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_insertar_detalleflagpromocion' AND type = 'P')
DROP PROCEDURE pa_insertar_detalleflagpromocion
GO


----------------------------------------------------------------------------------
-- Author: KVASQUEZ IDE-SOLUTION
-- Created: 03/04/2020  
-- Sistema: ws_wa_DistribuidoraVDC
-- Descripción: Insertar Promociones
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[pa_insertar_detalleflagpromocion]
(

	--@flag INT,
	@descripcionDet VARCHAR(100),	--DESCRIPCION DEL PRODUCTO
	@valorEntero1Det INT,			--CANTIDAD DEL PRODUCTO
	--@valorEntero2Det INT,
	@valorMoneda1Det MONEY,			--PRECIO DEL PRODUCTO
	@valorCadena1Det VARCHAR(200),	--COD DEL PRODUCTO
	@valorCadena2Det VARCHAR(200),	--COD UNIDAD BASE DEDL PROD
	@resultado INT OUTPUT
)

AS
	BEGIN
		DECLARE @ntraPromocion INT

BEGIN TRY
		BEGIN

		SELECT @ntraPromocion =  IDENT_CURRENT ('tblPromociones');

			INSERT INTO tblDetalleFlagPromocion
			(ntraPromocion,flag,descripcion, valorEntero1,valorEntero2, valorMoneda1, valorCadena1,valorCadena2,usuario)
			VALUES (@ntraPromocion,3,@descripcionDet,@valorEntero1Det,1,@valorMoneda1Det,@valorCadena1Det,@valorCadena2Det,'EAY');

			SELECT  @resultado = 0
		END
END TRY
BEGIN CATCH
		--UPDATE tblPromociones set marcaBaja = 9 where ntraPromocion = @ntraPromocion;
		SELECT  
			ERROR_NUMBER() AS NumeroDeError   
            ,ERROR_STATE() AS NumeroDeEstado    
            ,ERROR_LINE() AS  NumeroDeLinea  
            ,ERROR_MESSAGE() AS MensajeDeError;  
END CATCH

END
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_registrar_tipo_mov_caja' AND type = 'P')
	DROP PROCEDURE pa_registrar_tipo_mov_caja
GO
----------------------------------------------------------------------------------
-- Author: PEDRO YACILA IDE-SOLUTION
-- Created: 15/04/2020  
-- Sistema: ws_wa_DistribuidoraVDC
-- Descripcion: Registrar tipo movimiento en caja
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[pa_registrar_tipo_mov_caja]
(
	@descripcion varchar(250),		--Descripcion del Tipo de Movimiento
	@tipoRegistro TINYINT		--Código Tipo de Registro (1 - Entrada/ 2 - Salida)
)

AS
	BEGIN 

BEGIN TRY
			BEGIN
			INSERT INTO tblTipoMovimiento
			(descripcion,tipoRegistro,usuario,ip,mac)
			VALUES (@descripcion,@tipoRegistro,'pyacila','172.18.1.184','00:1B:44:11:3A:B7');
				
		END
END TRY
BEGIN CATCH

		SELECT  
			ERROR_NUMBER() AS NumeroDeError   
            ,ERROR_STATE() AS NumeroDeEstado    
            ,ERROR_LINE() AS  NumeroDeLinea  
            ,ERROR_MESSAGE() AS MensajeDeError;  
END CATCH

END
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_actualizar_tipo_mov_caja' AND type = 'P')
	DROP PROCEDURE pa_actualizar_tipo_mov_caja
GO
----------------------------------------------------------------------------------
-- Author: PEDRO YACILA IDE-SOLUTION
-- Created: 15/04/2020   
-- Sistema: ws_wa_DistribuidoraVDC
-- Descripcion: Actualizar tipo movimiento en caja
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[pa_actualizar_tipo_mov_caja]
(
	@descripcion varchar(250),		--Descripcion del Tipo de Movimiento
	@tipoRegistro TINYINT,		    --Código Tipo de Registro (1 - Entrada/ 2 - Salida)
	@ntraTipoMovimiento int				--Codigo del tipo de movimiento
)
AS
BEGIN TRY
		BEGIN
		UPDATE tblTipoMovimiento SET descripcion = @descripcion, tipoRegistro = @tipoRegistro WHERE ntraTipoMovimiento = @ntraTipoMovimiento
		END
END TRY
BEGIN CATCH
		SELECT  
			ERROR_NUMBER() AS NumeroDeError   
            ,ERROR_STATE() AS NumeroDeEstado    
            ,ERROR_LINE() AS  NumeroDeLinea  
            ,ERROR_MESSAGE() AS MensajeDeError;  
			
END CATCH
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_listar_tipos_mov_caja' AND type = 'P')
	DROP PROCEDURE pa_listar_tipos_mov_caja
GO
----------------------------------------------------------------------------------
-- Author: PEDRO YACILA IDE-SOLUTION
-- Created: 15/04/2020   
-- Sistema: ws_wa_DistribuidoraVDC
-- Descripción: Traer lista de tipos de movimientos
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[pa_listar_tipos_mov_caja]   
( 
@flag int   
)
AS   
BEGIN

	declare @csql nvarchar(1000)	--consulta sql


	set @csql = 'SELECT tm.ntraTipoMovimiento,tm.descripcion,tm.tipoRegistro as codTipoRegistro,
		c.descripcion as tipoRegistro, tm.marcaBaja
		FROM tblTipoMovimiento tm
		INNER JOIN tblConcepto c ON tm.tipoRegistro = c.correlativo
		WHERE c.codConcepto = 39'

		IF @flag = 0
			set @csql = @csql + 'AND tm.marcaBaja = 0'

			EXEC (@csql)
END
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_alta_baja_tipo_mov_caja' AND type = 'P')
	DROP PROCEDURE pa_alta_baja_tipo_mov_caja
GO
----------------------------------------------------------------------------------
-- Author: PEDRO YACILA IDE-SOLUTION
-- Created: 15/04/2020  
-- Sistema: ws_wa_DistribuidoraVDC
-- Descripcion: Alta/Baja tipo de movimiento
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[pa_alta_baja_tipo_mov_caja]
(
	@ntraTipoMovimiento int,	--Codigo del tipo de movimiento
	@flag int -- 0 - alta/ 9 - baja
)

AS
	BEGIN
		BEGIN TRY
			UPDATE tblTipoMovimiento SET marcaBaja = @flag  WHERE ntraTipoMovimiento = @ntraTipoMovimiento
		END TRY
		BEGIN CATCH
				SELECT  
					ERROR_NUMBER() AS NumeroDeError   
				   ,ERROR_STATE() AS NumeroDeEstado    
				   ,ERROR_LINE() AS  NumeroDeLinea  
				   ,ERROR_MESSAGE() AS MensajeDeError;  
		END CATCH
END
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_buscar_datos_perfil' AND type = 'P')
	DROP PROCEDURE pa_buscar_datos_perfil
GO
----------------------------------------------------------------------------------
-- Author: JEFFREY GARCIA IDE-SOLUTION
-- Created: 17/04/2020  
-- Sistema: WEB/PERFIL
-- Modulo: General
-- Descripci�n: buscar datos de perfil
-- Log Modificaciones: 
-- CODIGO    REQUERIMIENTO          NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_buscar_datos_perfil
(
	@p_codUsuario INT,			-- codigo de Usuario
	@p_codPersona INT          -- codigo de persona

)		
AS
BEGIN  
    DECLARE @keyLogin VARCHAR(50)                   -- CLAVE DE ENCRIPTACION    
	
    SET NOCOUNT ON;   
	BEGIN TRY	

	SET  @keyLogin = 'IdeSolution2020'

		BEGIN
			
                select  u.users as 'usuario',p.nombres as 'nombres' ,p.apellidoPaterno as 'apellidoPaterno',
                p.apellidoMaterno as 'apellidoMaterno',p.correo as 'correo',p.telefono as 'telefono',
                CAST(DECRYPTBYPASSPHRASE(@keyLogin,u.password) AS VARCHAR(MAX)) as 'password' 
                from tblPersona as p
                inner join tblUsuario as u  on u.codPersona = p.codPersona
                where p.codPersona = @p_codPersona and u.ntraUsuario = @p_codUsuario
                   
	    END
	END TRY
	BEGIN CATCH        
	   SELECT ERROR_NUMBER() as 'respuesta' , 'Error en pa_buscar_datos_perfil ' + ERROR_MESSAGE() as 'mensaje'
	END CATCH
END
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_buscar_credenciales_usuario' AND type = 'P')
	DROP PROCEDURE pa_buscar_credenciales_usuario
GO
----------------------------------------------------------------------------------
-- Author: Jeffrey Garcia
-- Created: 21/04/2020
-- Sistema: WEB/LOGIN
-- Descripcion: buscar credenciales de usuario
-- Log Modificaciones:
-- 
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[pa_buscar_credenciales_usuario]
(
	@p_usuario		VARCHAR(20),            -- nombre de usuario
	@p_password		VARCHAR(50) = NULL,     -- password
    @p_intentos     TINYINT = NULL,         -- Numero de intento de ingreso 
    @p_flag         TINYINT,				-- tipo de operacion (1: login , 2: recuperacion contraseña)
    @p_sucursal     INTEGER 				-- Codigo de sucursal
	                 
)
AS
CREATE TABLE  #tmpUser  ( 
    codusuario INTEGER,
    usuario varchar(20),                    
    [password] VARCHAR(MAX),
    codpersona INTEGER ,
    perfil VARCHAR(20),
	nombreCompleto VARCHAR(80) ,
    estadoUsuario VARCHAR(30),
    estadoPersona TINYINT,
    correo VARCHAR(30),
    sucursal INTEGER,
	telefono VARCHAR(15) )

    DECLARE @count smallint

    DECLARE  @codUsuario INTEGER                -- CODIGO DE USUARIO
    DECLARE @usuario varchar(20)            -- NOMBRE DE USUARIO    
    DECLARE @password VARCHAR(MAX)          -- PASSWORD
    DECLARE @codpersona INTEGER             -- CODIGO DE PERSONA
    DECLARE @perfil VARCHAR(20)             -- PERFIL DEL USUARIO
	DECLARE @nombreCompleto VARCHAR(80)     -- NOMBRES COMPLETOS 
    DECLARE @estadoUsuario VARCHAR(30)      -- ESTADO DE USUARIO
    DECLARE @estadoPersona TINYINT          -- ESTADO DE LA PERSONA    
    DECLARE @correo VARCHAR(30)             -- CORREO   
    DECLARE @sucursal INTEGER                   -- SUCURSAL
    DECLARE @telefono VARCHAR(15)			-- TELEFONO
	DECLARE @ip VARCHAR(20)                 -- IP 
	DECLARE @MAC VARCHAR(20)                -- MAC
	DECLARE @fecha DATETIME                 -- FECHA DE PROCESO
    DECLARE @keyLogin VARCHAR(50)           -- CLAVE DE ENCRIPTACION    

    --CODIGO DE MENSAJES
    DECLARE @g_cont_500 SMALLINT            -- CONSTANTE 500    
    DECLARE @g_cont_501 SMALLINT            -- CONSTANTE 501             
    DECLARE @g_cont_502 SMALLINT            -- CONSTANTE 502
    DECLARE @g_cont_503 SMALLINT            -- CONSTANTE 503
    DECLARE @g_cont_504 SMALLINT            -- CONSTANTE 504
    DECLARE @g_cont_505 SMALLINT            -- CONSTANTE 505
    DECLARE @g_cont_506 SMALLINT            -- CONSTANTE 506
    DECLARE @g_cont_507 SMALLINT            -- CONSTANTE 507

    --DESCRIPCION DE CODIGO DE MENSAJES
    DECLARE @g_cont_M500 VARCHAR(70)        -- DESCRIPCION DE MENSAJE 500
    DECLARE @g_cont_M501 VARCHAR(70)        -- DESCRIPCION DE MENSAJE 501
    DECLARE @g_cont_M502 VARCHAR(70)        -- DESCRIPCION DE MENSAJE 502
    DECLARE @g_cont_M503 VARCHAR(70)        -- DESCRIPCION DE MENSAJE 503
    DECLARE @g_cont_M504  varchar(70)       -- DESCRIPCION DE MENSAJE 504
    DECLARE @g_cont_M506  varchar(70)       -- DESCRIPCION DE MENSAJE 506
    DECLARE @g_cont_M507  varchar(70)       -- DESCRIPCION DE MENSAJE 507
    DECLARE @g_const_0 TINYINT              -- CONSTANTE 0
BEGIN 
	SET NOCOUNT ON;
   
	BEGIN TRY
	--CODIGO DE MENSAJES
    SET @g_cont_500 = 500
    SET @g_cont_501 = 501
    SET @g_cont_502 = 502 
    SET @g_cont_503 = 503
    SET @g_cont_504 = 504
    SET @g_cont_505 = 505
    SET @g_cont_506 = 506
	SET @g_cont_507 = 507
    SET @g_const_0 = 0  
    SET @g_cont_M500 = 'USUARIO NO ENCONTRADO '
    SET @g_cont_M501 = 'LIMITE MAXIMO DE INTENTOS ALCANZADOS'
    SET @g_cont_M502 = 'CONTRASEÑA INCORRECTA ' 
    SET @g_cont_M503 = 'USUARIO NO PUEDE ACCEDER POR ESTAR CON ESTADO: '
    SET @g_cont_M504 = 'LA PERSONA NO PUEDE ACCEDER POR ESTAR CON ESTADO: '
	SET @g_cont_M506 = 'EL USUARIO YA CUENTA CON UNA SESION ACTIVA '
	SET @g_cont_M507 = 'EL USUARIO NO ESTA REGISTRADO EN ESTA SUCURSAL '

	SET  @codUsuario = 0
	SET @usuario = NULL
	SET @password = NULL
	SET @codpersona = 0
	SET @perfil = NULL
	SET @nombreCompleto = NULL
	SET @estadoUsuario = NULL
	SET @estadoPersona = 0
    SET @correo = NULL
    SET @sucursal = 0
	SET @telefono = NULL
	SET @ip =  (SELECT client_net_address FROM sys.dm_exec_connections WHERE session_id = @@SPID); -- ip 
	SET @MAC = (SELECT substring(net_address,1,2)+':'+substring(net_address,3,2)+':'+substring(net_address,5,2)+':'+
				substring(net_address,7,2)+':'+substring(net_address,9,2)+':'+substring(net_address,11,2)	
				from sysprocesses where spid = @@SPID)

	SET  @fecha = (Select CONVERT(datetime,GETDATE(),9) as [MMM DD YYYY hh:mm:ss:mmm(AM/PM)]) 
	SET @keyLogin = 'IdeSolution2020'
	
		BEGIN
			
			INSERT into #tmpUser 
			SELECT * from v_listar_usuario_login where usuario = @p_usuario AND sucural = @p_sucursal

            SET @count =(SELECT count(*) FROM #tmpUser);

            IF @count = 0 
                BEGIN
				    DROP TABLE #tmpUser	
                    select @g_cont_507 as 'respuesta', @g_cont_M507 as 'nombres';
                END
							
			ELSE
                BEGIN
                    
                    IF @p_flag = 1
                        BEGIN                  
                            IF @p_intentos > 3 -- numero de intentos 
                                BEGIN
                                -- se cambia el estado de usuario a bloqueado                                   
                                
                                    UPDATE tblUsuario
                                    SET estado = 3
                                    WHERE users = @p_usuario

                                    INSERT INTO tblLoginFallido(codUsuario, cantFallido, FechaRegistro, usuario,ip,mac)
                                    VALUES(@codUsuario,@p_intentos,@fecha,@codUsuario,@ip,@mac)
            
                                    DROP TABLE #tmpUser
                                    SELECT @g_cont_501 as 'respuesta', @g_cont_M501 as 'nombres';
                        
                                END
                        ELSE
                            BEGIN
                            --VALIDAMOS QUE LA CONTRASEÑA INGRESADA SEA LA CORRECTA

                             SET @count = (SELECT COUNT(*) from #tmpUser 
                             where CAST(DECRYPTBYPASSPHRASE(@keyLogin,[password]) AS VARCHAR(MAX)) = @p_password and sucursal = @p_sucursal);

                                IF @count = 0                                                                      
                                    BEGIN
                                            DROP TABLE #tmpUser
                                            SELECT @g_cont_502 as 'respuesta', @g_cont_M502 as 'nombres';   
                                    END
                                ELSE
                                    BEGIN
                                        
                                        SELECT @codUsuario =codusuario ,@usuario =usuario , 
                                        @password = [password],@codpersona = codpersona,@perfil = perfil,
                                        @nombreCompleto = nombreCompleto, @estadoUsuario = estadoUsuario, 
                                        @estadoPersona = estadoPersona ,@correo = correo, @sucursal = sucursal, @telefono = telefono        
                                        from #tmpUser where CAST(DECRYPTBYPASSPHRASE(@keyLogin,[password]) AS VARCHAR(MAX)) = @p_password

                                        --validamos que le usuario no tenga una sesion activa

                                        SELECT @count = COUNT(ntraLogueo) FROM tblLogueoUsu 
                                        WHERE codUsuario = @codUsuario AND FechaSalida IS NULL AND marcabaja = @g_const_0
                                        
                                        IF @count = 0  -- usuario no tiene sesion activa
                                            BEGIN
                                             IF @estadoUsuario = 'ACTIVO'  -- USUARIO ACTIVO
                                            BEGIN             
                                                IF @estadoPersona = 0     -- PERSONA ACTIVA  
                                                    BEGIN
                                                    
                                                        INSERT INTO tblLogueoUsu(codUsuario, FechaIngreso, FechaSalida, tipoLogueo, usuario)
                                                        VALUES(@codUsuario,@fecha,NULL,1,@codUsuario)
                                                        
                                                        DROP TABLE #tmpUser
                                                        select  @g_cont_505 as 'respuesta',@codUsuario as 'codUsuario',@perfil as 'perfil',@nombreCompleto as 'nombres', @sucursal as 'sucursal',@telefono as'telefono',@codpersona AS 'codPersona';
                                                    END

                                                ELSE                                    
                                                    BEGIN 
                                                        
                                                        INSERT INTO tblLoginFallido(codUsuario, cantFallido, FechaRegistro, usuario,ip,mac)
                                                        VALUES(@codUsuario,@p_intentos,@fecha,@codUsuario,@ip,@mac)

                                                        DROP TABLE #tmpUser
                                                        select @g_cont_504 as 'respuesta', CONCAT(@g_cont_M504,@estadoPersona) as 'nombres';
                                                    END
                                            
                                            END
                                        ELSE
                                            BEGIN
                                                DROP TABLE #tmpUser
                                                INSERT INTO tblLoginFallido(codUsuario, cantFallido, FechaRegistro, usuario,ip,mac)
                                                VALUES(@codUsuario,@p_intentos,@fecha,@codUsuario,@ip,@mac)
                                                
                                                select @g_cont_503 as 'respuesta', CONCAT(@g_cont_M503,@estadoUsuario) as 'nombres';
                                            END    
                                            END
                                        ELSE
                                            BEGIN
                                                SELECT @g_cont_506 as 'respuesta',@g_cont_M506 as 'nombres'
                                            END                                       
                                    END    
                            END

                        END
                    else IF @p_flag = 2
                        BEGIN 
                            SELECT @codUsuario =codusuario ,@usuario =usuario , 
                                    @password = [password],@codpersona = codpersona,@perfil = perfil,
                                    @nombreCompleto = nombreCompleto, @estadoUsuario = estadoUsuario, 
                                    @estadoPersona = estadoPersona ,@correo = correo, @sucursal = sucursal,@telefono = telefono          
                                from #tmpUser where usuario= @p_usuario   

                            IF @correo = null OR @usuario = null   
                                BEGIN 
                                    DROP TABLE #tmpUser
                                    select @g_cont_500 as 'respuesta',@g_cont_M500 as 'nombres';
                                END
                            ELSE
                            BEGIN    
                                IF @estadoUsuario = 'ACTIVO'  -- USUARIO ACTIVO
                                            BEGIN             
                                                IF @estadoPersona = 0     -- PERSONA ACTIVA  
                                                BEGIN
                                                
                                                    INSERT INTO tblLogueoUsu(codUsuario, FechaIngreso, FechaSalida, tipoLogueo, usuario)
                                                    VALUES(@codUsuario,@fecha,NULL,1,@codUsuario)
                                                    
                                                    DROP TABLE #tmpUser
                                                    select  @g_cont_505 as 'respuesta',@correo as 'correo',CAST(DECRYPTBYPASSPHRASE(@keyLogin,@password)AS VARCHAR(MAX)) as 'password', @telefono  as 'telefono' 
                                                END

                                                ELSE                                    
                                                BEGIN 
                                                    
                                                    INSERT INTO tblLoginFallido(codUsuario, cantFallido, FechaRegistro, usuario,ip,mac)
                                                    VALUES(@codUsuario,@p_intentos,@fecha,@codUsuario,@ip,@mac)

                                                    DROP TABLE #tmpUser
                                                    select @g_cont_504 as 'respuesta', CONCAT(@g_cont_M504,@estadoPersona) as 'nombres';
                                                END
                                            
                                            END
                                ELSE
                                        BEGIN
                                            DROP TABLE #tmpUser
                                            INSERT INTO tblLoginFallido(codUsuario, cantFallido, FechaRegistro, usuario,ip,mac)
		                                    VALUES(@codUsuario,@p_intentos,@fecha,@codUsuario,@ip,@mac)
                                            
                                            select @g_cont_503 as 'respuesta', CONCAT(@g_cont_M503,@estadoUsuario) as 'nombres';
                                        END      
                            END                         
                        END
                    END
	    END
	END TRY
	BEGIN CATCH        
	   DROP TABLE #tmpUser
	   SELECT ERROR_NUMBER() as 'respuesta' , 'Error en pa_buscar_credenciales_usuario' + ERROR_MESSAGE() as 'nombres'
	END CATCH
	
END 
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_actualizar_perfil' AND type = 'P')
	DROP PROCEDURE pa_actualizar_perfil
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
----------------------------------------------------------------------------------
-- Author: Jeffrey Garcia
-- Created: 17/04/2020
-- Sistema: VirgenDelCarmenMantenedor
-- Descripcion: Actualizar datos de perfil
-- Log Modificaciones:
-- 
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[pa_actualizar_perfil]
(
	@p_nombre		        VARCHAR(20),            -- nombre 
    @p_apellidoPaterno		VARCHAR(20),            -- apellido paterno
    @p_apellidoMaterno		VARCHAR(20),            -- apellio materno
    @p_telefono		        VARCHAR(20),            -- telefono
    @p_correo		        VARCHAR(20),            -- correo
	@p_password		        VARCHAR(30),            -- password
    @p_codPersona           INT   ,                 -- codUPersona
    @p_codUsuario           INT                     -- codUsuario

)
AS
BEGIN
    --CODIGO DE MENSAJES
    DECLARE @g_const_505 SMALLINT                    -- CONSTANTE 500    
    --DESCRIPCION DE CODIGO DE MENSAJES
    DECLARE @g_const_M505 VARCHAR(70)                -- DESCRIPCION DE MENSAJE 500
    
    DECLARE @ip VARCHAR(20)                         -- IP 
	DECLARE @MAC VARCHAR(20)                        -- MAC
	DECLARE @fecha date                             -- FECHA DE PROCESO
    DECLARE @keyLogin VARCHAR(50)                   -- CLAVE DE ENCRIPTACION    
	DECLARE @hora time                              -- hora de proceso
    SET NOCOUNT ON;
   
	BEGIN TRY
	--CODIGO DE MENSAJES
    SET @g_const_505 = 505      
    SET @g_const_M505 = 'DATOS ACTUALIZADOS CORRECTAMENTE'

	SET @ip =  (SELECT client_net_address FROM sys.dm_exec_connections WHERE session_id = @@SPID); -- ip 
	SET @MAC = (SELECT substring(net_address,1,2)+':'+substring(net_address,3,2)+':'+substring(net_address,5,2)+':'+
				substring(net_address,7,2)+':'+substring(net_address,9,2)+':'+substring(net_address,11,2)	
				from sysprocesses where spid = @@SPID)

	SET  @fecha = (Select CONVERT (date, GETDATE())) 
    SET  @hora =   (select CONVERT (time, GETDATE()))
	SET  @keyLogin = 'IdeSolution2020'
	
		BEGIN
			BEGIN TRANSACTION
                UPDATE tblPersona
                SET nombres = @p_nombre, apellidoPaterno = @p_apellidoPaterno,
                apellidoMaterno = @p_apellidoMaterno, telefono = @p_telefono,
                correo=@p_correo,horaProceso = @hora ,fechaProceso = @fecha,ip = @ip,
                mac = @MAC 
                where codPersona = @P_codPersona


                UPDATE tblUsuario
                SET [password] =  CAST(ENCRYPTBYPASSPHRASE(@keyLogin,@p_password) AS VARBINARY(8000)),
                ip = @ip,mac =@MAC,fechaProceso = @fecha,horaProceso = @hora
                WHERE ntraUsuario = @p_codUsuario 

                select @g_const_505  as 'respuesta', @g_const_M505 as 'mensaje'
            COMMIT TRANSACTION        
	    END
	END TRY
	BEGIN CATCH        
       ROLLBACK TRANSACTION
	   SELECT ERROR_NUMBER() as 'respuesta' , 'Error en pa_buscar_credenciales_usuario' + ERROR_MESSAGE() as 'mensaje'
	END CATCH
	
END 
GO

IF EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_busqueda_cronograma_prestamo' AND type = 'P')
DROP PROCEDURE pa_busqueda_cronograma_prestamo
GO
----------------------------------------------------------------------------------
-- Author: WilSON IDE-SOLUTION
-- Created: 16/04/2020  
-- Sistema: Web VirgenCarmenMantenedor
-- Descripción: buscar el cronograma de un prestamo
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[pa_busqueda_cronograma_prestamo]   
(

--@p_codVendedor INTEGER,
@p_flagFiltro SMALLINT,			   -- flag de accion
@p_ntraVenta INT				    --codigo de venta
)			
AS   
BEGIN
	SET NOCOUNT ON;

	
	DECLARE @ntraPrestamo INT;
	BEGIN TRY
		IF @p_flagFiltro = 1
		BEGIN
			
			SELECT @ntraPrestamo = ntraPrestamo FROM tblPrestamo 
			WHERE codVenta = @p_ntraVenta;

			SELECT cr.codPrestamo as codPrestamo  ,cr.fechaPago as fechaPago,cr.nroCuota as nroCuota,cr.importe as importe,
			cr.estado as estado, c.descripcion	 as descestado FROM tblCronograma cr
			INNER JOIN tblConcepto c on c.correlativo = cr.estado 
			WHERE codPrestamo = @ntraPrestamo and c.codConcepto = 32 and c.correlativo != 0
			ORDER BY cr.nroCuota ASC
		END
	END TRY	
	BEGIN CATCH
			SELECT ERROR_NUMBER() as 'codOperacion', 'pa_busqueda_cronograma_prestamo' + 
			ERROR_MESSAGE() as 'codOperacion', '' as 'fechaPago', '' as 'nroCuota', '' as 'importe', ''  as 'estado','' 
	END CATCH
END
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_listar_tipos_precio_paramatrizado' AND type = 'P')
	DROP PROCEDURE pa_listar_tipos_precio_paramatrizado
GO
----------------------------------------------------------------------------------
-- Author: Luis Llatas IDE-SOLUTION
-- Created: 10/02/2020  
-- Sistema: WEB / Mantenedor Precio
-- Descripción: Listar Tipos Precio Parametrizado 
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE pa_listar_tipos_precio_paramatrizado
AS

BEGIN
SET NOCOUNT ON

DECLARE @const_0 TINYINT 
DECLARE @const_1 TINYINT 
DECLARE @const_7 TINYINT 
DECLARE @const_200 TINYINT 
DECLARE @g_const_3000 INT
DECLARE @g_const_n999 INT
DECLARE @codRespuesta INT
DECLARE @mensaje VARCHAR(100)

SET @const_0  = 0
SET @const_1  = 1
SET @const_7 = 7
SET @const_200 = 200
SET @g_const_3000 = 3000
SET @g_const_n999 = -999

BEGIN TRY

  SELECT @const_200 AS codRespuesta , correlativo, descripcion,
   ( CASE WHEN (SELECT valorEntero1 FROM tblDetalleParametro WHERE tblDetalleParametro.tipo = fu_buscar_conceptos_generales.correlativo) IS NULL
       THEN @const_0
       ELSE (SELECT valorEntero1 FROM tblDetalleParametro WHERE tblDetalleParametro.tipo = fu_buscar_conceptos_generales.correlativo) END )
       AS factor 
  FROM fu_buscar_conceptos_generales (@const_7) 
  LEFT JOIN tblDetalleParametro
  ON fu_buscar_conceptos_generales.correlativo = tblDetalleParametro.tipo  
  WHERE fu_buscar_conceptos_generales.correlativo > @const_1 
  AND (tblDetalleParametro.marcaBaja = @const_0 OR tblDetalleParametro.marcaBaja IS NULL) 
  
END TRY

BEGIN CATCH
		
				SELECT @g_const_n999 AS codRespuesta, ERROR_NUMBER() AS correlativo, ERROR_MESSAGE() AS descripcion
END CATCH


END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_registrar_modificar_factor_distribucion_precios' AND type = 'P')
	DROP PROCEDURE pa_registrar_modificar_factor_distribucion_precios
GO
----------------------------------------------------------------------------------
-- Author: Luis Llatas IDE-SOLUTION
-- Created: 10/02/2020  
-- Sistema: WEB / Mantenedor Precio
-- Descripción: Registrar y/o Modificar Factor de Distribucion de Precios
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE pa_registrar_modificar_factor_distribucion_precios
(@tipoPrecio TINYINT,
 @factor     TINYINT
)
AS
BEGIN
SET NOCOUNT ON

DECLARE @const_0 TINYINT 
DECLARE @codParametro TINYINT
DECLARE @cantidad INT
DECLARE @g_const_3000 INT
DECLARE @codRespuesta INT
DECLARE @mensaje VARCHAR(100)

SET @const_0 = 0
SET @cantidad = 0
SET @codParametro = 11
SET @g_const_3000 = 3000

BEGIN TRY

SELECT @cantidad = COUNT(ntraDetParametro)  
FROM tblDetalleParametro WHERE codParametro = @codParametro 
AND tipo = @tipoPrecio AND marcabaja = @const_0

 IF @cantidad > 0 
	BEGIN
	 UPDATE tblDetalleParametro SET valorEntero1 = @factor WHERE codParametro = @codParametro 
	 AND tipo = @tipoPrecio AND marcaBaja = @const_0
	END 
 ELSE
   BEGIN
     IF @cantidad = 0 
       BEGIN
        INSERT INTO tblDetalleParametro (codParametro,tipo,valorEntero1,marcaBaja,usuario,ip,mac) VALUES (@codParametro,@tipoPrecio,@factor,@const_0,'','','')
       END 
        
   END 	

END TRY

BEGIN CATCH
		
			SET @codRespuesta = @g_const_3000
			SET @mensaje = ERROR_MESSAGE()

			SELECT @codRespuesta AS 'codRespuesta', @mensaje as 'mensaje'

END CATCH

END

GO

IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_registrar_trabajador' AND type = 'P')
	DROP PROCEDURE pa_registrar_trabajador
GO
-----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
-- Autor: Alexis Maldonado Vasquez IDE-SOLUTION
-- Created: 21/04/2020  
-- Sistema: Sistema Distribuidora Virgen del Carmen
-- Modulo: General
-- Descripcion:  actualizar usuario
-- CODIGO NOMBRE FECHA MOTIVO
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[pa_registrar_trabajador]
(
		@p_codigo INTEGER,
		@p_tipoPersona TINYINT,
		@p_tipoDocumento TINYINT,
		@p_numDocumento VARCHAR(15),
		@p_ruc VARCHAR(15),
		@p_nombres		VARCHAR(30),				
		@p_apePaterno	VARCHAR(20),			
		@p_apeMaterno	 VARCHAR(20),
		@p_fechaNac		date,
	    @p_estadoCivil  smallint,	
		@p_direccion	 VARCHAR(100),			
		@p_correo		VARCHAR(60),				
		@p_telefono		VARCHAR(15),
		@p_celular		CHAR(9),
		-----------------------------------------------
		@p_usuario VARCHAR(20),	
		-----------------------------------------------
		@p_asignacionFamilia smallint,
		@p_area smallint,
		@p_estadoTrabajador smallint,
		@p_tipoTrabajador smallint,
		@p_cargo smallint,
		@p_formaPago smallint,
		@p_numeroCuenta VARCHAR(16),
		@p_tipoRegimen smallint,
		@p_regimenPensionario smallint,
		@p_incioRegimen date,
		@p_bancoRemuneracion smallint,
		@p_estadoPlanilla smallint,
		@p_modalidadContrato smallint,
		@p_periodicidad smallint,
		@p_inicioContrato date,
		@p_finContrato date,
		@p_fechaIngreso date,
		@p_sueldo money
		
)   
AS
BEGIN
	SET NOCOUNT ON;    
	BEGIN TRY
        DECLARE @flag INT;			    --flag de proceso
        DECLARE @msje VARCHAR(250);		--mensaje de error
        DECLARE @codPersona INT;		--codigo de persona
        DECLARE @codigo VARCHAR(10);	--codigo generado
        DECLARE @Upper INT;				--valor maximo para numero aleatorio
        DECLARE @Lower INT;				--valor minimo para numero aleatorio
        DECLARE @cont INT;				--contador
        DECLARE @bandera INT;			--bandera de proceso
        DECLARE @fechaProceso date;
		DECLARE @horaProceso time
        DECLARE @ip VARCHAR(20);
		DECLARE @mac VARCHAR(20);
		DECLARE @fecha date;
		DECLARE @hora time;

        SET @flag = 1;
        SET @msje = 'Exito';
        SET @codPersona = 0;
        SET @codigo = null;
        SET @Upper = 0;
        SET @Lower = 0;
        SET @cont = 0;
		SET @bandera = 0;
		SET @ip =  (SELECT client_net_address FROM sys.dm_exec_connections WHERE session_id = @@SPID); -- ip 
		SET @mac = (SELECT substring(net_address,1,2)+':'+substring(net_address,3,2)+':'+substring(net_address,5,2)+':'+
						substring(net_address,7,2)+':'+substring(net_address,9,2)+':'+substring(net_address,11,2)	
						from sysprocesses where spid = @@SPID)

		SET  @fecha = (Select CONVERT(date,GETDATE(),9)) 
		SET  @hora = (Select CONVERT(TIME,GETDATE(),7)) 
		BEGIN
		 

            IF(@p_tipoPersona = 1 and @p_tipoDocumento = 1)		--validaciond e tipo de doc
                BEGIN
                    SET @codPersona = @p_numDocumento;
                END
            ELSE
                BEGIN
				
                    SET @bandera = 0
					
                        WHILE(@bandera = 0)
                            BEGIN
                                SET @cont = 0
                                --numero aleatorio del 0 al 999999
                                SET @Lower = 0
                                SET @Upper = 999999 
                                SET @codigo = ROUND(((@Upper - @Lower -1) * RAND() + @Lower), 0)
                                --completando para tener un numero con 6 digitos
                                SET @codigo = SUBSTRING(REPLICATE('0', 6),1,6 - LEN(@codigo)) + @codigo
                                --concatenamos 99 al numero generado
                                SET @codigo = '99' + LTRIM(RTRIM(@codigo));
                                --almacenamos el codigo en un entero para agilizar la busqueda
                                SET @codPersona = @codigo
                                --verificamos la existencia del codigo generado
                                SELECT @cont = COUNT(codPersona) FROM tblPersona WHERE codPersona = @codPersona
                                IF (@cont = 0) --codigo disponible
                                    BEGIN 
                                        SET @bandera = 1
                                    END	
                            END	                
                    END

					BEGIN TRANSACTION

                        INSERT INTO tblPersona (codPersona, tipoPersona, tipoDocumento, numeroDocumento, ruc, nombres, apellidoPaterno, 
                        apellidoMaterno, fechaNacimiento, estadoCivil, direccion, correo, telefono, celular, marcaBaja, usuario, ip, mac) 
                        VALUES(@codPersona, @p_tipoPersona, @p_tipoDocumento, @p_numDocumento, @p_ruc, @p_nombres, @p_apePaterno, @p_apeMaterno, 
                        @p_fechaNac, @p_estadoCivil, @p_direccion, @p_correo, @p_telefono, @p_celular, 0, 'amaladonado', @ip, @mac);
                        
                        INSERT INTO tblTrabajador (codPersona, asignacionFamilia, area, estadoTrabajador, tipoTrabajador, cargo, formaPago, numeroCuenta, tipoRegimen,
                        regimenPensionario, incioRegimen, bancoRemuneracion, estadoPlanilla, modalidadContrato, periodicidad, inicioContrato,
                        finContrato, fechaIngreso, sueldo, marcaBaja, usuario, ip, mac)
                        VALUES (@codPersona, @p_asignacionFamilia, @p_area, @p_estadoTrabajador, @p_tipoTrabajador, @p_cargo, @p_formaPago, @p_numeroCuenta, @p_tipoRegimen,
                        @p_regimenPensionario, @p_incioRegimen, @p_bancoRemuneracion, @p_estadoPlanilla, @p_modalidadContrato, @p_periodicidad, @p_inicioContrato,
                        @p_finContrato, @p_fechaIngreso, @p_sueldo, 0, 'amaladonado', @ip, @mac)

					COMMIT TRANSACTION	
					 
            END  
        SELECT  @flag AS mensaje, 'Registro Exitoso' as texto 
	END TRY
	

    BEGIN CATCH
		SET @flag = ERROR_NUMBER();
        SELECT @flag as mensaje , 'Error en pa_insertar_trabajador ' + ERROR_MESSAGE() as texto
    END CATCH
END	
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_registrar_caja' AND type = 'P')
	DROP PROCEDURE pa_registrar_caja
GO
----------------------------------------------------------------------------------
-- Author: PEDRO YACILA IDE-SOLUTION
-- Created: 16/04/2020  
-- Sistema: ws_wa_DistribuidoraVDC
-- Descripcion: Registrar caja
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[pa_registrar_caja]
(
	@descripcion varchar(100),		--Descripcion del Tipo de Movimiento
	@ntraUsuario INT,		-- Codigo del encargado de caja
	@ntraSucursal INT,    -- Codigo de sucursal
	@listaTipoMov XML			--lista tipo movimientos
)

AS
	BEGIN 
	
	DECLARE @ntraCaja INT; -- codigo de caja
	DECLARE @ntraTipoMovimiento INT;		-- Codigo Tipo de Movimiento
	DECLARE @estado TINYINT; -- Flag de estado / 0 - Habilitado, 9 - Inhabilitado

BEGIN TRY
			BEGIN
			INSERT INTO tblCaja
			(descripcion,ntraUsuario,ntraSucursal,usuario,ip,mac)
			VALUES (@descripcion,@ntraUsuario,@ntraSucursal,'pyacila','172.18.1.184','00:1B:44:11:3A:B7');
			
			SELECT @ntraCaja =  (SELECT @@IDENTITY);
			
			-- Registro de tipos de movimientos de caja
			
			
						BEGIN
						
								DECLARE cur CURSOR LOCAL STATIC READ_ONLY FORWARD_ONLY FOR 
								SELECT cast(colx.query('data(ntraTipoMovimiento)') as varchar), cast(colx.query('data(marcaBaja)') as varchar)
								FROM @listaTipoMov.nodes('ArrayOfCENTipoMovimiento/CENTipoMovimiento') AS Tabx(Colx)              
								OPEN cur;  
								FETCH NEXT FROM cur INTO @ntraTipoMovimiento, @estado;
								WHILE @@FETCH_STATUS = 0
									BEGIN
									
									
										INSERT INTO tblTipoMovimientoCaja (ntraCaja,ntraTipoMovimiento,marcaBaja,usuario,ip,mac)
										VALUES (@ntraCaja,@ntraTipoMovimiento,@estado,'pyacila','172.18.1.184','00:1B:44:11:3A:B7');
										
										FETCH NEXT FROM cur INTO @ntraTipoMovimiento, @estado;
		
									END
								CLOSE cur;  
								DEALLOCATE cur; 
						END
				
		END
END TRY
BEGIN CATCH

		SELECT  
			ERROR_NUMBER() AS NumeroDeError   
            ,ERROR_STATE() AS NumeroDeEstado    
            ,ERROR_LINE() AS  NumeroDeLinea  
            ,ERROR_MESSAGE() AS MensajeDeError;  
END CATCH

END
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_actualizar_caja' AND type = 'P')
	DROP PROCEDURE pa_actualizar_caja
GO
----------------------------------------------------------------------------------
-- Author: PEDRO YACILA IDE-SOLUTION
-- Created: 16/04/2020   
-- Sistema: ws_wa_DistribuidoraVDC
-- Descripcion: Actualizar caja
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[pa_actualizar_caja]
(
  @ntraCaja INT,		-- Codigo del encargado de caja
	@descripcion varchar(100),		--Descripcion del Tipo de Movimiento
	@ntraUsuario INT,		-- Codigo del encargado de caja
	@listaTipoMov XML			--lista tipo movimientos
)
AS
BEGIN 

	DECLARE @ntraTipoMovimiento INT;		-- Codigo Tipo de Movimiento
	DECLARE @estado TINYINT; -- Flag de estado / 0 - Habilitado, 9 - Inhabilitado
	DECLARE @flag INT = NULL; -- Flag de verificacion
BEGIN TRY
		BEGIN
		UPDATE tblCaja SET descripcion = @descripcion, ntraUsuario = @ntraUsuario WHERE ntraCaja = @ntraCaja
		
		-- Actualización de tipos de movimientos de caja
		
						BEGIN
						
								DECLARE cur CURSOR LOCAL STATIC READ_ONLY FORWARD_ONLY FOR 
								SELECT cast(colx.query('data(ntraTipoMovimiento)') as varchar), cast(colx.query('data(marcaBaja)') as varchar)
								FROM @listaTipoMov.nodes('ArrayOfCENTipoMovimiento/CENTipoMovimiento') AS Tabx(Colx)              
								OPEN cur;  
								FETCH NEXT FROM cur INTO @ntraTipoMovimiento, @estado;
								WHILE @@FETCH_STATUS = 0
									BEGIN
									
										SET @flag = NULL;
										SELECT @flag = ntraTipoMovimiento FROM tblTipoMovimientoCaja WHERE ntraCaja = @ntraCaja AND ntraTipoMovimiento = @ntraTipoMovimiento;
									
										IF @flag IS NOT NULL
											UPDATE tblTipoMovimientoCaja SET marcaBaja = @estado
											WHERE ntraCaja = @ntraCaja AND ntraTipoMovimiento = @ntraTipoMovimiento
										ELSE
											INSERT INTO tblTipoMovimientoCaja (ntraCaja,ntraTipoMovimiento,marcaBaja,usuario,ip,mac)
											VALUES (@ntraCaja,@ntraTipoMovimiento,@estado,'pyacila','172.18.1.184','00:1B:44:11:3A:B7');
										
										FETCH NEXT FROM cur INTO @ntraTipoMovimiento, @estado;
		
									END
								CLOSE cur;  
								DEALLOCATE cur; 
						END
		END
END TRY
BEGIN CATCH
		SELECT  
			ERROR_NUMBER() AS NumeroDeError   
            ,ERROR_STATE() AS NumeroDeEstado    
            ,ERROR_LINE() AS  NumeroDeLinea  
            ,ERROR_MESSAGE() AS MensajeDeError;  
			
END CATCH
END
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_listar_cajas' AND type = 'P')
	DROP PROCEDURE pa_listar_cajas
GO
----------------------------------------------------------------------------------
-- Author: PEDRO YACILA IDE-SOLUTION
-- Created: 15/04/2020   
-- Sistema: ws_wa_DistribuidoraVDC
-- Descripción: Traer lista de cajas
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[pa_listar_cajas] 
(
@p_ntraCaja INT = NULL, -- Código de Caja
@p_estadoCaja TINYINT =  NULL, -- Código de Estado de Caja
@p_ntraUsuario INT =  NULL, -- Código de Usuario
@p_ntraSucursal INT =  NULL, -- Código de Sucursal
@p_fechaInicial DATE =  NULL, -- Fecha Inicial Filtro
@p_fechaFinal DATE =  NULL -- Fecha Final Filtro
)
AS   
BEGIN

	SELECT c.ntraCaja,c.descripcion,s.descripcion as sucursal, c.estado as codestado, cp.descripcion as estado, c.fechaCreacion,  
		c.horaCreacion, c.ntraUsuario,u.users, p.apellidoPaterno + ' ' + p.apellidoMaterno + ', ' + p.nombres as nombreCompleto
		FROM tblCaja c 
		INNER JOIN tblSucursal s ON s.ntraSucursal = c.ntraSucursal
		INNER JOIN tblUsuario u ON u.ntraUsuario = c.ntraUsuario
		INNER JOIN tblPersona p ON p.codPersona = u.codPersona
		INNER JOIN tblConcepto cp ON c.estado = cp.correlativo
		WHERE c.marcaBaja = 0
		AND cp.codConcepto = 41
		AND (@p_ntraCaja = 0 OR @p_ntraCaja = c.ntraCaja)
		AND (@p_estadoCaja = 0 OR @p_estadoCaja = c.estado)
		AND (@p_ntraUsuario = 0 OR @p_ntraUsuario = u.ntraUsuario)
		AND (@p_ntraSucursal = 0 OR @p_ntraSucursal = c.ntraSucursal)
		AND (@p_fechaInicial IS NULL OR c.fechaCreacion >= @p_fechaInicial)
		AND (@p_fechaFinal IS NULL OR c.fechaCreacion <= @p_fechaFinal)

END
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_listar_tipos_mov_asig_caja' AND type = 'P')
	DROP PROCEDURE pa_listar_tipos_mov_asig_caja
GO
----------------------------------------------------------------------------------
-- Author: PEDRO YACILA IDE-SOLUTION
-- Created: 15/04/2020   
-- Sistema: ws_wa_DistribuidoraVDC
-- Descripción: Traer lista de cajas
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[pa_listar_tipos_mov_asig_caja] 
( 
@ntraCaja int   -- Código de caja
)  
AS   
BEGIN

	SELECT tmc.ntraTipoMovimiento, tm.descripcion,tm.tipoRegistro as codTipoRegistro,
		c.descripcion as tipoRegistro
		FROM tblTipoMovimientoCaja  tmc
		INNER JOIN tblTipoMovimiento tm ON tmc.ntraTipoMovimiento = tm.ntraTipoMovimiento
		INNER JOIN tblConcepto c ON tm.tipoRegistro = c.correlativo
		WHERE tmc.marcaBaja = 0 AND tmc.ntraCaja = @ntraCaja AND c.codConcepto = 39

END
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_listar_cajeros_sucursal' AND type = 'P')
	DROP PROCEDURE pa_listar_cajeros_sucursal
GO
----------------------------------------------------------------------------------
-- Author: PEDRO YACILA IDE-SOLUTION
-- Created: 15/04/2020   
-- Sistema: ws_wa_DistribuidoraVDC
-- Descripción: Traer lista de cajeros por sucursal
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[pa_listar_cajeros_sucursal] 
( 
@ntraSucursal int  -- Código de sucursal
)  
AS   
BEGIN

	SELECT u.ntraUsuario as correlativo, 
		CONCAT(u.users, ' - ', p.nombres,' ', p.apellidoPaterno,' ',p.apellidoMaterno) as descripcion 
		FROM tblUsuario u
		INNER JOIN tblPersona p on u.codPersona = p.codPersona
		INNER JOIN tblPerfil pe on u.codPerfil = pe.codigo
		WHERE p.marcaBaja = 0 AND u.marcaBaja = 0 and u.codPerfil = 7 and u.codSucursal = @ntraSucursal

END
GO

------ APERTURA DE CAJA

IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_registrar_apertura_caja' AND type = 'P')
	DROP PROCEDURE pa_registrar_apertura_caja
GO
----------------------------------------------------------------------------------
-- Author: PEDRO YACILA IDE-SOLUTION
-- Created: 16/04/2020  
-- Sistema: ws_wa_DistribuidoraVDC
-- Descripcion: Registrar Apertura de Caja
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[pa_registrar_apertura_caja]
(
	@ntraCaja INT,		-- Número de Caja
	@saldoSoles MONEY,		-- Saldo Inicial en Soles
	@saldoDolares MONEY    -- Saldo Inicial en Dólares
)

AS
	BEGIN 
	DECLARE @flag INT = NULL; -- Flag de verificacion
BEGIN TRY
			BEGIN
			
			SELECT @flag = ntraCierreCaja FROM tblCierreCaja 
			WHERE ntraCaja = @ntraCaja AND marcaBaja = 0;
									
			IF @flag IS NOT NULL
				UPDATE tblCierreCaja SET marcaBaja = 9
				WHERE ntraCierreCaja = @flag
			
			INSERT INTO tblAperturaCaja
			(ntraCaja,saldoSoles,saldoDolares,usuario,ip,mac)
			VALUES (@ntraCaja,@saldoSoles,@saldoDolares,'pyacila','172.18.1.184','00:1B:44:11:3A:B7');
				
			UPDATE tblCaja SET estado = 1 WHERE ntraCaja = @ntraCaja
			
		END
END TRY
BEGIN CATCH

		SELECT  
			ERROR_NUMBER() AS NumeroDeError   
            ,ERROR_STATE() AS NumeroDeEstado    
            ,ERROR_LINE() AS  NumeroDeLinea  
            ,ERROR_MESSAGE() AS MensajeDeError;  
END CATCH
END
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_actualizar_apertura_caja' AND type = 'P')
	DROP PROCEDURE pa_actualizar_apertura_caja
GO
----------------------------------------------------------------------------------
-- Author: PEDRO YACILA IDE-SOLUTION
-- Created: 16/04/2020   
-- Sistema: ws_wa_DistribuidoraVDC
-- Descripcion: Actualizar Apertura de caja
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[pa_actualizar_apertura_caja]
(
	@ntraAperturaCaja INT, -- Número de Apertura de Caja
  @saldoSoles MONEY,		-- Saldo Inicial en Soles
	@saldoDolares MONEY    -- Saldo Inicial en Dólares
)
AS
BEGIN 

BEGIN TRY
		BEGIN
		UPDATE tblAperturaCaja SET saldoSoles = @saldoSoles, saldoDolares = @saldoDolares WHERE ntraAperturaCaja = @ntraAperturaCaja
		END
END TRY
BEGIN CATCH
		SELECT  
			ERROR_NUMBER() AS NumeroDeError   
            ,ERROR_STATE() AS NumeroDeEstado    
            ,ERROR_LINE() AS  NumeroDeLinea  
            ,ERROR_MESSAGE() AS MensajeDeError;  
			
END CATCH
END
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_listar_cajas_aperturadas' AND type = 'P')
	DROP PROCEDURE pa_listar_cajas_aperturadas
GO
----------------------------------------------------------------------------------
-- Author: PEDRO YACILA IDE-SOLUTION
-- Created: 15/04/2020   
-- Sistema: ws_wa_DistribuidoraVDC
-- Descripción: Traer lista de cajas aperturadas
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[pa_listar_cajas_aperturadas]   
( 
@p_ntraSucursal INT = NULL, -- Código de Sucursal
@p_ntraCaja INT = NULL, -- Número de Caja
@p_flag INT = NULL  -- Flag
)
AS   
BEGIN
	
	declare @csql nvarchar(1000)	--consulta sql
	
	set @csql = 'SELECT ac.ntraAperturaCaja, ac.ntraCaja, c.descripcion as caja, ac.fecha, ac.hora,  
		ac.saldoSoles, ac.saldoDolares, ac.estado as codEstado, cp.descripcion as estado, ac.marcaBaja 
		FROM tblAperturaCaja ac 
		INNER JOIN tblCaja c ON ac.ntraCaja = c.ntraCaja
		INNER JOIN tblConcepto cp ON ac.estado = cp.correlativo
		WHERE c.marcaBaja = 0
		AND cp.codConcepto = 58
		AND (' + convert(varchar, @p_ntraSucursal)  + ' = 0 OR ' + convert(varchar, @p_ntraSucursal) + ' = c.ntraSucursal)
		AND (' + convert(varchar, @p_ntraCaja)  + ' = 0 OR ' + convert(varchar, @p_ntraCaja) + ' = c.ntraCaja)'
		
	IF @p_flag = 0
		set @csql = @csql + 'AND ac.marcaBaja = 0 AND c.estado = 1'

	EXEC (@csql)
END
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_listar_cajas_cerradas' AND type = 'P')
	DROP PROCEDURE pa_listar_cajas_cerradas
GO
----------------------------------------------------------------------------------
-- Author: PEDRO YACILA IDE-SOLUTION
-- Created: 15/04/2020   
-- Sistema: ws_wa_DistribuidoraVDC
-- Descripción: Traer lista de cajas cerradas
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[pa_listar_cajas_cerradas]   
( 
@p_ntraSucursal INT = NULL, -- Código de Sucursal
@p_ntraCaja INT = NULL, -- Número de Caja
@p_flag INT = NULL   -- Flag
)
AS   
BEGIN
	
	declare @csql nvarchar(1000)	--consulta sql
	
	set @csql = 'SELECT cc.ntraCierreCaja, cc.ntraCaja, c.descripcion as caja, cc.fecha, cc.hora,  
		cc.saldoSoles, cc.saldoDolares, cc.saldoSolesCierre, cc.saldoDolaresCierre,
		cc.difSaldoSoles, cc.difSaldoDolares, cc.marcaBaja 
		FROM tblCierreCaja cc 
		INNER JOIN tblCaja c ON cc.ntraCaja = c.ntraCaja
		WHERE c.marcaBaja = 0
		AND (' + convert(varchar, @p_ntraSucursal)  + ' = 0 OR ' + convert(varchar, @p_ntraSucursal) + ' = c.ntraSucursal)
		AND (' + convert(varchar, @p_ntraCaja)  + ' = 0 OR ' + convert(varchar, @p_ntraCaja) + ' = c.ntraCaja)'
		
	IF @p_flag = 0
		set @csql = @csql + 'AND cc.marcaBaja = 0 AND c.estado = 2'

	EXEC (@csql)
END
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_listar_transacciones_caja' AND type = 'P')
	DROP PROCEDURE pa_listar_transacciones_caja
GO
----------------------------------------------------------------------------------
-- Author: PEDRO YACILA IDE-SOLUTION
-- Created: 15/04/2020   
-- Sistema: ws_wa_DistribuidoraVDC
-- Descripción: Traer lista de transacciones de cajas
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[pa_listar_transacciones_caja]   
( 
@p_ntraSucursal INT = NULL, -- Código de Sucursal
@p_ntraCaja INT = NULL, -- Número de Caja
@p_fechaTransaccion DATE = NULL, -- Fecha filtro transacciones de caja
@p_flag INT = NULL   -- Flag
)
AS   
BEGIN
	
	declare @csql nvarchar(2000)	--consulta sql
	
	set @csql = 'SELECT tc.ntraTransaccionCaja, tc.ntraCaja, c.descripcion as caja, 
		tc.ntraTipoMovimiento, tm.descripcion as tipoMovimieno, tc.fechaTransaccion, tc.horaTransaccion,
		tc.codVenta, tc.tipoTransaccion as codTipoTransaccion, c1.descripcion as tipoTransaccion,
		tc.modoPago as codModoPago, c2.descripcion as modoPago, tc.tipoMoneda as codTipoMoneda,
		c3.descripcion as tipoMoneda, tc.importe, tc.marcaBaja, tm.tipoRegistro as codTipoRegistro,
		c4.descripcion as tipoRegistro
		FROM tblTransaccionCaja tc 
		INNER JOIN tblCaja c ON tc.ntraCaja = c.ntraCaja
		INNER JOIN tblTipoMovimiento tm ON tc.ntraTipoMovimiento = tm.ntraTipoMovimiento
		INNER JOIN tblConcepto c1 ON tc.tipoTransaccion = c1.correlativo
		INNER JOIN tblConcepto c2 ON tc.modoPago = c2.correlativo
		INNER JOIN tblConcepto c3 ON tc.tipoMoneda = c3.correlativo
		INNER JOIN tblConcepto c4 ON tm.tipoRegistro = c4.correlativo
		WHERE c.marcaBaja = 0
		AND c1.codConcepto = 59
		AND c2.codConcepto = 48
		AND c3.codConcepto = 21
		AND c4.codConcepto = 39
		AND (' + convert(varchar, @p_ntraSucursal)  + ' = 0 OR ' + convert(varchar, @p_ntraSucursal) + ' = c.ntraSucursal)
		AND (' + convert(varchar, @p_ntraCaja)  + ' = 0 OR ' + convert(varchar, @p_ntraCaja) + ' = c.ntraCaja)'
	
	IF @p_fechaTransaccion IS NOT NULL
		set @csql = @csql + 'AND tc.fechaTransaccion = ' +CHAR(39) + convert(varchar(10), @p_fechaTransaccion) +CHAR(39)
		
	IF @p_flag = 0
		set @csql = @csql + 'AND tc.marcaBaja = 0'

	EXEC (@csql)
END
GO

IF EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_listar_filtro_metas' AND type = 'P')
	DROP PROCEDURE pa_listar_filtro_metas
GO
----------------------------------------------------------------------------------
-- Author: Giancarlos Sanginez IDE-SOLUTION
-- Created: 14/04/2020  
-- Sistema: web virgen del Carmen
-- Descripción: Consultar metas por filtros
-- Log Modificaciones: 
-- CODIGO    REQUERIMIENTO          NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[pa_listar_filtro_metas]
(
 @codProveedor INT ,
 @codEstado INT ,
 @fechaInicio DATE = NULL,
 @fechaFin DATE = NULL
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
	DECLARE @g_codMeta INT -- Codigo de Meta
	DECLARE @g_codProveedor INT --Codigo de Proveedor
	DECLARE @g_codEstado INT -- 0: EN PROCESO, 1: EN PAUSA, 2: ANULADO
	DECLARE @g_fechaInicio DATE   -- Fecha de inicio de la meta
	DECLARE @g_fechaFin DATE  -- Fecha final de la meta
	DECLARE @g_descProveedor    VARCHAR(200) -- descripcion del proveedor
	DECLARE @g_descripcion    VARCHAR(200) --Descripcion de meta
	CREATE TABLE #listMeta 
		(codMeta INT, codProveedor INT,codEstado INT,fechaInicio DATE,fechaFin DATE,descProveedor VARCHAR(200),descripcion VARCHAR(200),
		 codigo INT,estado SMALLINT,mensaje VARCHAR(100)); --tabla temporal
BEGIN TRY
	SET @g_const_0 = 0;
	SET @g_const_1 = 1;
	SET @g_const_9 = 9;
	SET @g_const_12 = 12;
	SET @g_const_2000 = 2000;
	SET @g_const_3000 = 3000;
	SET @g_caracter = ''
	SET @mensaje = 'EXITO';
	SET @estado = 0;

	SET @g_codMeta = 0;
	SET @g_codProveedor = 0; 
	SET @g_codEstado = 0;
	SET @g_fechaInicio  = NULL;
	SET @g_fechaFin = NULL;
	SET @g_descProveedor = NULL;
	SET @g_descripcion = NULL;

	DECLARE qcur_metas CURSOR LOCAL STATIC READ_ONLY FORWARD_ONLY FOR 
		SELECT tblMeta.codMeta AS CodMeta, tblMeta.descripcion AS Descripcion, tblMeta.fechaInicio AS CodFechaini,
		tblMeta.fechaFin AS CodFechaFin
		FROM tblMeta 
		WHERE tblMeta.marcaBaja = 0 ;
	OPEN qcur_metas;
		FETCH NEXT FROM qcur_metas
		INTO @g_codMeta,@g_descripcion,@g_fechaInicio,@g_fechaFin; 
		WHILE @@FETCH_STATUS = @g_const_0
		BEGIN
			SELECT @g_descProveedor = descripcion FROM tblProveedor WHERE ntraProveedor = @g_codProveedor AND marcaBaja = @g_const_0;
			INSERT INTO #listMeta

			SELECT @g_codMeta,@g_codProveedor,@g_codEstado,@g_fechaInicio,@g_fechaFin,@g_descProveedor,@g_descripcion,@g_const_2000,@g_const_0,@mensaje
			SET @g_codMeta = NULL;

			FETCH NEXT FROM qcur_metas 
			INTO @g_codMeta,@g_descripcion,@g_fechaInicio,@g_fechaFin;   
		 END
	CLOSE qcur_metas;
	DEALLOCATE qcur_metas;	
	IF  @codProveedor = @g_const_0 AND @codEstado = @g_const_0 AND @fechaInicio IS NULL AND @fechaFin IS NULL
		BEGIN 
			SELECT codMeta,codProveedor,fechaInicio,fechaFin,descProveedor,descripcion,codigo,estado,mensaje
			FROM #listMeta ORDER BY codMeta DESC;		 
		END
	IF @codProveedor = @g_const_0 AND @codEstado = @g_const_0 AND @fechaInicio IS NOT NULL AND @fechaFin IS NOT NULL
		BEGIN 
			SELECT codMeta,codProveedor,fechaInicio,fechaFin,descProveedor,descripcion,codigo,estado,mensaje
			FROM #listMeta WHERE fechaInicio = @fechaInicio AND fechaFin = @fechaFin;
		END	
END TRY
BEGIN CATCH
	SET @codigo = @g_const_3000;
	SET @estado = @g_const_1;
	SET @mensaje = ERROR_MESSAGE();
	SELECT '' AS codmeta,@g_const_0 as codproveedor,@g_const_0 as codEstado,'' as descproveedor,'' as descripcion,
	@codigo as codigo, @estado as estado,@mensaje as mensaje
END CATCH
END
GO

IF EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_registrar_objetivo' AND type = 'P')
DROP PROCEDURE pa_registrar_objetivo
GO
----------------------------------------------------------------------------------
-- Author: Giancarlos Sanginez -IDE SOLUTION
-- Created: 24/04/2020
-- Sistema: web virgen del Carmen
-- Descripcion: registro de objetivos
-- Log Modificaciones:
-- CODIGO NOMBRE FECHA MOTIVO
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE pa_registrar_objetivo
(
	@p_descripcion VARCHAR(250), -- descripcion
	@p_codTipoIndicador smallint,		 -- Tipo de indicador
	@p_codIndicador smallint,		     --Indicador
	@p_valorIndicador decimal(10,2),		--Valor del indicador
	@p_codPerfil smallint,				--Perfil de trabjador
	@p_codTrabajador int,				--Trabajador
	@p_usuario varchar(10),		 --usuario
	@resultado int OUTPUT
)
AS
BEGIN
	SET NOCOUNT ON;	
		DECLARE @Proceso int;				    -- codigo proceso, en mejora de este pa
	
BEGIN TRY
	INSERT INTO tblObjetivo(descripcion, tipoIndicador, indicador, valorIndicador, perfil, trabajador, usuario) values
					(@p_descripcion,@p_codTipoIndicador,@p_codIndicador,@p_valorIndicador,@p_codPerfil,@p_codTrabajador,@p_usuario);		
	SELECT @resultado = 0
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
GO

IF EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_listar_filtro_objetivos' AND type = 'P')
	DROP PROCEDURE pa_listar_filtro_objetivos
GO
----------------------------------------------------------------------------------
-- Author: Giancarlos Sanginez IDE-SOLUTION
-- Created: 25/04/2020  
-- Sistema: web virgen del Carmen
-- Descripción: Consultar objetivos por filtros
-- Log Modificaciones: 
-- CODIGO    REQUERIMIENTO          NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[pa_listar_filtro_objetivos]
(
 @codTipoIndicador INT ,
 @codIndicador INT ,
 @codPerfil INT,
 @codTrabajador INT,
 @fechaInicio DATE = NULL,
 @fechaFin DATE = NULL
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

	DECLARE @g_codObjetivo INT -- Codigo de Objetivo
	DECLARE @g_descripcion VARCHAR(50) --Descripcion de objetivo
	DECLARE @g_codTipoIndicador INT --Codigo de Tipo de Indicador
	DECLARE @g_descTipoIndicador VARCHAR(50) -- Descripcion del Tipo de Indicador
	DECLARE @g_codIndicador INT -- Codigo de indicador
	DECLARE @g_descIndicador VARCHAR(50) -- Descripcion del Indicador
	DECLARE @g_valorIndicador DECIMAL -- Valor del indicador	
	DECLARE @g_codPerfil INT -- Codigo de Perfil
	DECLARE @g_descPerfil VARCHAR(50) -- Descripcion de Perfil
	DECLARE @g_codTrabajador INT -- Codigo de Trabajador
	DECLARE @g_descTrabajador VARCHAR(50) -- Descripcion de Perfil
	DECLARE @g_fechaRegistro DATE   -- Fecha de registro del Objetivo
		
	CREATE TABLE #listObjetivo 
		(codObjetivo INT, descripcion VARCHAR(50), codTipoIndicador INT, descTipoIndicador VARCHAR(50), codIndicador INT, descIndicador VARCHAR(50), 
		valorIndicador DECIMAL, codPerfil INT, descPerfil VARCHAR(50), codTrabajador INT, descTrabajador VARCHAR(50),fechaRegistro DATE,
		 codigo INT,estado SMALLINT,mensaje VARCHAR(100)); --tabla temporal
BEGIN TRY
	SET @g_const_0 = 0;
	SET @g_const_1 = 1;
	SET @g_const_9 = 9;
	SET @g_const_12 = 12;
	SET @g_const_2000 = 2000;
	SET @g_const_3000 = 3000;
	SET @g_caracter = ''
	SET @mensaje = 'EXITO';
	SET @estado = 0;

	SET @g_codObjetivo = 0;
	SET @g_descripcion = NULL;
	SET @g_codTipoIndicador = 0;
	SET @g_descTipoIndicador = NULL;
	SET @g_codIndicador = 0;
	SET @g_descIndicador = NULL;
	SET @g_valorIndicador = 0.0;	
	SET @g_codPerfil = 0;
	SET @g_descPerfil = NULL;
	SET @g_codTrabajador = 0;
	SET @g_descTrabajador = NULL;
	SET @g_fechaRegistro = NULL;

	DECLARE qcur_objetivos CURSOR LOCAL STATIC READ_ONLY FORWARD_ONLY FOR 
		SELECT tblObjetivo.codObjetivo AS CodOjetivo, 
		tblObjetivo.descripcion AS Descripcion, 
		tblObjetivo.tipoIndicador AS CodTipoIndicador,
		tblObjetivo.indicador AS CodIndicador, 
		tblObjetivo.valorIndicador AS ValorIndicador,
		tblObjetivo.perfil AS CodPerfil, 
		tblObjetivo.trabajador AS CodTrabajador,
		tblObjetivo.fechaProceso AS FechaRegistro
		FROM tblObjetivo
		WHERE tblObjetivo.marcaBaja = 0 ;
	OPEN qcur_objetivos;
		FETCH NEXT FROM qcur_objetivos
		INTO @g_codObjetivo,@g_descripcion,@g_codTipoIndicador,@g_codIndicador,@g_valorIndicador,@g_codPerfil,@g_codTrabajador,@g_fechaRegistro; 
		WHILE @@FETCH_STATUS = @g_const_0
		BEGIN
			SELECT @g_descTipoIndicador = descripcion FROM tblConcepto WHERE codConcepto = 35 AND correlativo = @g_codTipoIndicador AND marcaBaja = 0
			IF @g_codTipoIndicador = @g_const_1
				BEGIN
					SELECT @g_descIndicador = descripcion FROM tblConcepto WHERE codConcepto = 21 AND correlativo = @g_codIndicador AND marcaBaja = 0;
				END
			ELSE
				BEGIN
					SELECT @g_descIndicador = descripcion FROM tblConcepto WHERE codConcepto = 12 AND correlativo = @g_codIndicador AND marcaBaja = 0;
				END
			SELECT @g_descPerfil = descripcion FROM tblPerfil WHERE codigo = @g_codPerfil AND marcaBaja = 0
			SELECT @g_descTrabajador = CONCAT(p.nombres,' ', p.apellidoPaterno,' ',p.apellidoMaterno) FROM tblTrabajador t
			INNER JOIN tblPersona p on t.codPersona = p.codPersona WHERE p.marcaBaja = 0 AND t.marcaBaja = 0 and p.codPersona = @g_codTrabajador

			INSERT INTO #listObjetivo 
			SELECT  @g_codObjetivo,@g_descripcion,@g_codTipoIndicador,@g_descTipoIndicador,@g_codIndicador,@g_descIndicador,@g_valorIndicador,
			@g_codPerfil,@g_descPerfil,@g_codTrabajador,@g_descTrabajador,@g_fechaRegistro,@g_const_2000,@g_const_0,@mensaje
			SET @g_codObjetivo = NULL;

			FETCH NEXT FROM qcur_objetivos 
			INTO @g_codObjetivo,@g_descripcion,@g_codTipoIndicador,@g_codIndicador,@g_valorIndicador,@g_codPerfil,@g_codTrabajador,@g_fechaRegistro;  
		 END
	CLOSE qcur_objetivos;
	DEALLOCATE qcur_objetivos;	
	IF  @codTipoIndicador = @g_const_0 AND @codIndicador = @g_const_0 AND @codPerfil = @g_const_0 AND @codTrabajador = @g_const_0 AND @fechaInicio IS NULL AND @fechaFin IS NULL
		BEGIN 
			SELECT codObjetivo,descripcion,codTipoIndicador,descTipoIndicador,codIndicador,descIndicador,valorIndicador,codPerfil,descPerfil,codTrabajador,descTrabajador,fechaRegistro,codigo,estado,mensaje
			FROM #listObjetivo ORDER BY codObjetivo DESC;		 
		END
END TRY
BEGIN CATCH
	SET @codigo = @g_const_3000;
	SET @estado = @g_const_1;
	SET @mensaje = ERROR_MESSAGE();
	SELECT '' AS codObjetivo,@g_const_0 as codproveedor,@g_const_0 as codEstado,'' as descproveedor,'' as descripcion,
	@codigo as codigo, @estado as estado,@mensaje as mensaje
END CATCH
END
GO

IF EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_listar_trabajador_x_perfil' AND type = 'P')
	DROP PROCEDURE pa_listar_trabajador_x_perfil
GO
----------------------------------------------------------------------------------
-- Author: Giancarlos Sanginez IDE-SOLUTION
-- Created: 24/04/2020  
-- Sistema: web virgen del Carmen
-- Modulo: RRHH
-- Descripción: Listar trabajador segun perfil
-- Log Modificaciones: 
-- CODIGO    REQUERIMIENTO          NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_listar_trabajador_x_perfil	
(
@codPerfil INT
)
AS
SET NOCOUNT ON

BEGIN
        DECLARE @g_const_0 INT -- valor 0	

BEGIN TRY      
           SET @g_const_0 = 0;
   BEGIN
	 SELECT t.codPersona, CONCAT(p.nombres,' ', p.apellidoPaterno,' ',p.apellidoMaterno) as Trabajador, pe.descripcion as Cargo	
	 FROM tblTrabajador t INNER JOIN tblPersona p on p.codPersona = t.codPersona
	 INNER JOIN tblPerfil pe on pe.codigo = t.cargo
	 WHERE pe.codigo = @codPerfil
   END
END TRY
BEGIN CATCH
           SELECT   
	        ERROR_NUMBER() AS ErrorNumber  
	       ,ERROR_MESSAGE() AS ErrorMessage;
END CATCH
END

GO

IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_buscar_mantenedores_nombre' AND type = 'P')
	DROP PROCEDURE pa_buscar_mantenedores_nombre
GO
/****** Object:  StoredProcedure [dbo].[pa_buscar_mantenedores_nombre]    Script Date: 27/04/2020 10:56:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
----------------------------------------------------------------------------------
-- Author: Jeffrey Garcia
-- Created: 25/04/2020  
-- Sistema: ws_wa_DistribuidoraVDC
-- Modulo: Permisos
-- Descripci�n: Buscar mantenedores por nombre
-- Log Modificaciones: 
-- CODIGO    REQUERIMIENTO          NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[pa_buscar_mantenedores_nombre]
(
	@p_mant  varchar(150) -- nombre del mantenedor
)		
AS
	BEGIN
		
		SELECT modu.codModulo as 'codModulo' ,modu.descripcion as 'nomModulo',
                men.codMenu as 'codMenu',men.descripcion as 'nomMantenedor'
                FROM tblModulo as modu 
                INNER JOIN tblMenu as men on modu.codModulo = men.codModulo
                WHERE men.marcaBaja = 0 and modu.marcaBaja = 0
                and men.estado = 1 AND modu.estado = 1 and 	men.descripcion LIKE '%'+ @p_mant +'%'			
                ORDER BY modu.orden,men.orden

	END	
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_buscar_menus' AND type = 'P')
	DROP PROCEDURE pa_buscar_menus
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
----------------------------------------------------------------------------------
-- Author: Jeffrey Garcia IDE-SOLUTION
-- Created: 24/04/2020
-- Sistema: VirgenDelCarmenMantenedor
-- Descripcion: listado de menus
-- Log Modificaciones:
-- CODIGO NOMBRE FECHA MOTIVO
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[pa_buscar_menus]
AS
BEGIN 
	SET NOCOUNT ON;  
	BEGIN TRY
        BEGIN   
            	SELECT modu.codModulo as 'codModulo' ,modu.descripcion as 'nomModulo',
                men.codMenu as 'codMenu',men.descripcion as 'nomMantenedor'
                FROM tblModulo as modu 
                INNER JOIN tblMenu as men on modu.codModulo = men.codModulo
                WHERE men.marcaBaja = 0 and modu.marcaBaja = 0
                and men.estado = 1 AND modu.estado = 1				
                ORDER BY modu.orden,men.orden
        END
    END TRY
    BEGIN CATCH
        SELECT ERROR_NUMBER() as 'codError' , 'Error en pa_buscar_menus' + ERROR_MESSAGE() as 'mensaje'
    END CATCH
END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_buscar_modulos' AND type = 'P')
	DROP PROCEDURE pa_buscar_modulos
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
----------------------------------------------------------------------------------
-- Author: Jeffrey Garcia IDE-SOLUTION
-- Created: 22/04/2020
-- Sistema: VirgenDelCarmenMantenedor
-- Descripcion: buscar detalle de modulos
-- Log Modificaciones:
-- CODIGO NOMBRE FECHA MOTIVO
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[pa_buscar_modulos]
(
    @p_codUser INT ,      -- codigo de usuario
    @p_flag INT           -- tipo de opearcion(1:listar por perfil, 2:listar todos)

)
AS
BEGIN 
	SET NOCOUNT ON;  
	BEGIN TRY
        BEGIN   
            DECLARE @codPerfil INT;
            IF @p_flag = 1 
               BEGIN
                    SET @codPerfil = (SELECT codPerfil from tblUsuario WHERE ntraUsuario = @p_codUser)

                    SELECT * FROM v_modulos_detalle where responsable = @codPerfil
                    order by codModulo,codMenu
               END
            ELSE IF @p_flag = 2   
                BEGIN
                    SELECT * FROM v_modulos_detalle where responsable = @p_codUser
                    order by codModulo,codMenu
                END 
        END
    END TRY
    BEGIN CATCH
        SELECT ERROR_NUMBER() as 'codError' , 'Error en pa_buscar_modulos' + ERROR_MESSAGE() as 'mensaje'
    END CATCH
END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_insertar_modificar_permiso' AND type = 'P')
	DROP PROCEDURE pa_insertar_modificar_permiso
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
----------------------------------------------------------------------------------
-- Author: Jeffrey Garcia
-- Created: 24/04/2020
-- Sistema: WEB/PERMISOS DE USAURIO
-- Descripcion: insertar y modificar los permisos pro perfil
-- Log Modificaciones:
-- 
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[pa_insertar_modificar_permiso]
(
	@p_list             XML,               -- XML DE PEMISOS
    @p_flag            TINYINT             -- tipo de operacion (1: insertar , 2: modificar )
)
AS
  
    DECLARE @codResponsable INT
	DECLARE @codPermiOpera INT
    DECLARE @opcion     INT
    DECLARE @codMenu   INT
    DECLARE @codigo  TINYINT               -- CODIGO DE VALIDACION
    DECLARE @ip      VARCHAR(20)    
    DECLARE @mac     VARCHAR(20)
    DECLARE @fecha    DATE
    DECLARE @hora     TIME   
    --CODIGO DE MENSAJES
    DECLARE @g_const_500 SMALLINT          -- CONSTANTE 500   
    DECLARE @g_const_505 SMALLINT          -- CONSTANTE 505
    --DESCRIPCION DE CODIGO DE MENSAJES  

BEGIN 
	SET NOCOUNT ON;
   
	BEGIN TRY
    SET @codResponsable = 0
    SET @opcion       = 0
    SET @codMenu       = 0         
	SET @codPermiOpera = 0
    SET @codigo = 0
	--CODIGO DE MENSAJES
    SET @g_const_500 = 500
    SET @g_const_505 = 505
          
	
	SET @ip =  (SELECT client_net_address FROM sys.dm_exec_connections WHERE session_id = @@SPID); -- ip 
	SET @mac = (SELECT substring(net_address,1,2)+':'+substring(net_address,3,2)+':'+substring(net_address,5,2)+':'+
				substring(net_address,7,2)+':'+substring(net_address,9,2)+':'+substring(net_address,11,2)	
				from sysprocesses where spid = @@SPID)

	SET  @fecha = (Select CONVERT(date,GETDATE(),9)) 
    SET  @hora = (Select CONVERT(TIME,GETDATE(),7)) 
	
		BEGIN
			IF @p_flag = 1
                BEGIN
                        DECLARE cur CURSOR LOCAL STATIC READ_ONLY FORWARD_ONLY FOR 
								SELECT cast(colx.query('data(codPermiso)') as VARCHAR), cast(colx.query('data(codResponsable)') as VARCHAR)
                                ,cast(colx.query('data(opcion)') as VARCHAR)
								FROM @p_list.nodes('ArrayOfCENPermiso/CENPermiso') AS Tabx(Colx)              
								OPEN cur;  
								FETCH NEXT FROM cur INTO @codMenu, @codResponsable,@opcion
								WHILE @@FETCH_STATUS = 0
									BEGIN
									
                                        SET  @codigo = (SELECT COUNT(codPermiOpera) from tblPermiOpera 
                                        where codResponsable = @codResponsable 
                                        AND opcion=@opcion 
                                        AND codMenu = @codMenu
                                        AND marcaBaja = 0)

										 --paso 1: validar que dicho permiso no este registrado
                                        IF @codigo > 0
                                            BEGIN
                                                SELECT @g_const_500 as 'codigo'
                                            END
                                        ELSE
                                            BEGIN     
                                        -- paso 2: insertar el nuevo permiso si no esta registrado                    
                                                INSERT INTO tblPermiOpera
                                                (codResponsable,opcion,codMenu,marcaBaja,fechaProceso,horaProceso,usuario,ip,mac)
                                                VALUES (@codResponsable,@opcion,@codMenu,0,@fecha,@hora,'EAY',@ip,@mac)
                                                

                                                select @g_const_505 as'codigo'
                                            END
										
										FETCH NEXT FROM cur INTO @codMenu, @codResponsable,@opcion
		
									END
								CLOSE cur;  
								DEALLOCATE cur; 
                END
            ELSE IF @p_flag = 2
                BEGIN               
					DECLARE cur CURSOR LOCAL STATIC READ_ONLY FORWARD_ONLY FOR 
					SELECT cast(colx.query('data(codPermiso)') as VARCHAR)
					FROM @p_list.nodes('ArrayOfCENPermiso/CENPermiso') AS Tabx(Colx)              
					OPEN cur;  
					FETCH NEXT FROM cur INTO @codPermiOpera
					WHILE @@FETCH_STATUS = 0
                    BEGIN
                        UPDATE tblPermiOpera
                        SET     fechaProceso = @fecha,
                                horaProceso=@hora,
                                ip=@ip,
                                mac=@mac,
								marcaBaja = 9 
                        WHERE codPermiOpera = @codPermiOpera
						FETCH NEXT FROM cur INTO @codPermiOpera
                    
                  END
								CLOSE cur;  
								DEALLOCATE cur; 
                    select @g_const_505 as'codigo'    
                END        
        END
	END TRY
	BEGIN CATCH        
	   SELECT ERROR_NUMBER() as 'codigo' 
	END CATCH
	
END 


IF EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_notacredito_obtener_datos_sunat' AND type = 'P')
DROP PROCEDURE pa_notacredito_obtener_datos_sunat
GO
----------------------------------------------------------------------------------
-- Author: Alex Llamo IDE-SOLUTION
-- Created: 23/03/2020
-- Sistema: VirgenDelCarmenMantenedor
-- Descripcion: obtener datos para envio de tramas a sunat
-- Log Modificaciones:
-- CODIGO NOMBRE FECHA MOTIVO
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_notacredito_obtener_datos_sunat
(
	@p_codVenta INT,		--codigo de venta
	@p_codNC INT			--codigo nota credito
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @serieV VARCHAR(20);
	DECLARE @numeroV INT;
	DECLARE @tipoDocV INT;
	DECLARE @tipoDocTriSunat_afec VARCHAR(5);
	DECLARE @totalV MONEY;
	DECLARE @igvV MONEY;
	DECLARE @codCliente INT;
	DECLARE @codPuntoEntrega INT;
	DECLARE @moneda_afec INT;

	DECLARE @nombres VARCHAR(200);
	DECLARE @numDocumento VARCHAR(15);
	DECLARE @tipoDocC INT;
	DECLARE @tipoDocIdeSunat INT;
	DECLARE @direccionC VARCHAR(200);
	DECLARE @total_afec MONEY;
	DECLARE @igv_afec MONEY;
	DECLARE @fecha_afec VARCHAR(50);
	DECLARE @codSucursal  INT;

	--DATOS NC
	DECLARE @codMotivo CHAR(2);
	DECLARE @desMotivo VARCHAR(200);
	DECLARE @serieNC VARCHAR(10);
	DECLARE @correlativo VARCHAR(10);
	DECLARE @fecha VARCHAR(50);
	DECLARE @codVentaN INT;

	--DATOS GENERALES
	DECLARE @tipoDocTriSunat VARCHAR(5);
	DECLARE @tipoMoneda VARCHAR(10);
	DECLARE @ublVersion VARCHAR(10);
	DECLARE @tipAfeIgv VARCHAR(10);
	
		--PRODUCTOS
	DECLARE @mtoBaseIgv MONEY;
	DECLARE @porcentajeIgv MONEY;
	DECLARE @unidad VARCHAR(20);
	DECLARE @cal_igv MONEY;
	DECLARE @igv MONEY;

	DECLARE @rucE VARCHAR(12);
	DECLARE @razonSocialE VARCHAR(200);
	DECLARE @direccionE VARCHAR(200);
	
	
	BEGIN TRY
		--datos de venta afectada
		SELECT @serieV = serie, @numeroV = nroDocumento, @tipoDocV = tipoDocumentoVenta, @codCliente = codCliente,
		@codPuntoEntrega = codPuntoEntrega, @total_afec = importeTotal, @igv_afec = IGV, @fecha_afec = fechaTransaccion,
		@codSucursal = codSucursal, @moneda_afec = tipoMoneda
		FROM tblVenta
		WHERE ntraVenta = @p_codVenta AND marcaBaja = 0;
		SET @fecha_afec = @fecha_afec + 'T00:00:00-05:00'

		--obtener el equivalente del tipo documento venta afectado
		SELECT @tipoDocTriSunat_afec = valorCaneda1
		FROM tblDetalleParametro
		WHERE codParametro = 9 AND valorEntero1 = @tipoDocV AND marcaBaja = 0;

		--obtener datos de cliente
		IF (@tipoDocV = 1)
		BEGIN
			SELECT @nombres = UPPER(apellidoPaterno + ' ' + apellidoMaterno + ' ' + nombres), @numDocumento = numeroDocumento,
			@tipoDocC = tipoDocumento
			FROM tblPersona
			WHERE codPersona = @codCliente AND marcaBaja = 0;

			--obtener equivalente de tipo documento identidad cliente
			SELECT @tipoDocIdeSunat = valorEntero2
			FROM tblDetalleParametro
			WHERE codParametro = 10 AND valorEntero1 = @tipoDocC AND marcaBaja = 0;
		END
		ELSE
		BEGIN
			SELECT @nombres = UPPER(razonSocial), @numDocumento = ruc,
			@tipoDocC = tipoDocumento
			FROM tblPersona
			WHERE codPersona = @codCliente AND marcaBaja = 0;

			--obtener equivalente de tipo documento identidad cliente
			SELECT @tipoDocIdeSunat = valorEntero2
			FROM tblDetalleParametro
			WHERE codParametro = 10 AND valorEntero1 = 3 AND marcaBaja = 0;
		END

		--SELECT @tipoDocC = tipoDocumento
		--FROM tblPersona
		--WHERE codPersona = @codCliente AND marcaBaja = 0;

		--obtener moneda
		SELECT @tipoMoneda = valorCaneda1
		FROM tblDetalleParametro
		WHERE codParametro = 12 AND valorEntero1 = @moneda_afec AND marcaBaja = 0;

		--obtener equivalente de tipo documento identidad cliente
		--SELECT @tipoDocIdeSunat = valorEntero2
		--FROM tblDetalleParametro
		--WHERE codParametro = 10 AND valorEntero1 = @tipoDocC AND marcaBaja = 0;

		-- obtener datos de punto entrega
		SELECT @direccionC = direccion 
		FROM tblPuntoEntrega
		WHERE codPersona = @codCliente AND ntraPuntoEntrega = @codPuntoEntrega AND marcaBaja = 0;

		--datos NC
		IF (@p_codNC != 0)
		BEGIN
			SELECT @codMotivo = codMotivo, @serieNC = serie, @correlativo = numero, @fecha = fecha,
			@codVentaN = codVentaNega
			FROM tblNotaCredito
			WHERE ntraNotaCredito = @p_codNC AND marcaBaja = 0;
			SET @fecha = @fecha + 'T00:00:00-05:00'

			SELECT @desMotivo = descripcion
			FROM tblMotivoNotaCredito
			WHERE codigoMotivo = @codMotivo AND marcaBaja = 0;
		
			SELECT @tipoDocTriSunat = valorCaneda1
			FROM tblDetalleParametro
			WHERE codParametro = 9 AND valorEntero1 = 3 AND marcaBaja = 0;

			SELECT @totalV = (importeTotal*-1), @igvV = (IGV*-1)
			FROM tblVenta
			WHERE ntraVenta = @codVentaN AND marcaBaja = 0;
		END
		ELSE
		BEGIN
			SET @codMotivo = '';
			SET @serieNC = '';
			SET @correlativo = 0;
			SET @fecha = '';
			SET @codVentaN = 0;
			SET @desMotivo = '';
			SET @tipoDocTriSunat = '';
			SET @totalV = 0;
			SET @igvV = 0;
		END

		--DATOS GENERALES:
		SELECT @cal_igv = igv
		FROM tblParametrosGenerales
		WHERE codSucursal = @codSucursal AND marcaBaja = 0;

		SET @tipAfeIgv = '10';
		--SET @tipoMoneda = 'PEN';
		--SET @ublVersion = '2.1';

		SELECT @ublVersion = valorCaneda1
		FROM tblDetalleParametro
		WHERE codParametro = 14 AND valorEntero1 = 1 AND marcaBaja = 0

		--SET @mtoBaseIgv = 100;
		--SET @porcentajeIgv = 18;
		--SET @igv = 18;
		SELECT @igv = valorMoneda1, @mtoBaseIgv = valorMoneda2, @porcentajeIgv = valorFloat1
		FROM tblDetalleParametro
		WHERE codParametro = 15 AND tipo = 1 AND marcaBaja = 0

		--SET @unidad = 'NIU';
		SELECT @unidad = valorCaneda1
		FROM tblDetalleParametro
		WHERE codParametro = 13 AND valorEntero1 = 1 AND marcaBaja = 0

		--SET @rucE = '22166585139';
		--SET @razonSocialE = 'EMPRESA DE EJEMPLO IDE';
		--SET @direccionE = 'SALVAERY 123, AL FRENTE DE SOLIDRIDAD, CHICLAYO';
		SELECT @razonSocialE = razonSocial, @rucE = ruc, @direccionE = direccion
		FROM tblEmpresa 
		WHERE marcaBaja = 0;


		SELECT @tipoDocTriSunat_afec as tipDocAfec, @serieV as serieDocAfec, @numeroV as numeroDocAfec, 
		@total_afec as totalVentaAfec, @igv_afec as igvAfec, @fecha_afec as fechaAfec,

		@codMotivo as codMotivoNC, @desMotivo as desMotivoNC, @tipoDocTriSunat as tipoDocNC, @serieNC as serieNC, 
		@correlativo as correlativoNC, @fecha as fechaEmisionNC,
		@totalV as mtoImpVentaNC, @igvV as mtoIGVNC,

		@tipoDocIdeSunat as tipoDocClient, @numDocumento as numDocCliente, @nombres as rznSocialClient, 
		@direccionC as direccionClient,

		@rucE as rucCompany, @razonSocialE as razonSocialCompany, @direccionE as direccionCompany,

		@tipoMoneda as tipoMoneda, @ublVersion as ublVersion, @mtoBaseIgv as mtoBaseIgv, @porcentajeIgv as porcentajeIgv,
		@unidad as unidad, @cal_igv as cal_igv, @tipAfeIgv as tipAfeIgv, @igv as igv

	END TRY

	BEGIN CATCH
		SELECT ERROR_NUMBER() as flag, 'Error en pa_notacredito_obtener_datos_sunat ' + ERROR_MESSAGE() as msje
	END CATCH
END
GO

IF EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_notacredito_validar_venta' AND type = 'P')
DROP PROCEDURE pa_notacredito_validar_venta
GO
----------------------------------------------------------------------------------
-- Author: Alex Llamo IDE-SOLUTION
-- Created: 23/03/2020
-- Sistema: VirgenDelCarmenMantenedor
-- Descripcion: validar si venta puede aplicar a NC
-- Log Modificaciones:
-- CODIGO NOMBRE FECHA MOTIVO
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_notacredito_validar_venta
(
	@p_codigo INT				--codigo de venta
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @fecha DATETIME;		--fecha de transaccion venta
	DECLARE @fecha_cad VARCHAR(20);	--fecha de transaccion venta cadena
	DECLARE @param_uno SMALLINT;	--parametro 1
	DECLARE @param_dos SMALLINT;	--parametro 2
	DECLARE @msje VARCHAR(200);		--mensaje
	DECLARE @flag SMALLINT;			--flag
	DECLARE @can_dias INT;			--cantidad de dias

	SET @fecha = NULL;
	SET @param_uno = 0;
	SET @param_dos = 0;
	SET @msje = '';
	SET @flag = 0;
	SET @can_dias = 0;
	SET @fecha_cad = '';

	BEGIN TRY
		--fecha de venta
		SELECT @fecha = fechaTransaccion, @fecha_cad = (SELECT CONVERT (VARCHAR(15), fechaTransaccion, 3) as [DD/MM/YY])
		FROM tblVenta
		WHERE ntraVenta = @p_codigo AND marcaBaja = 0;

		--parametros
		SELECT @param_uno = valorEntero1, @param_dos = valorEntero2
		FROM tblDetalleParametro
		WHERE codParametro = 8 AND marcaBaja = 0;

		--cantidad de dias
		SET @can_dias = DATEDIFF(DAY, @fecha, CONVERT(DATE, GETDATE()));

		IF ((SELECT MONTH(GETDATE())) = MONTH(@fecha))
		BEGIN
			IF(@can_dias <= @param_uno)
			BEGIN
				SET @flag = 1;
				SET @msje = 'EXITO';
			END
			ELSE
			BEGIN
				SET @msje = 'FECHA DE VENTA ('+@fecha_cad+') EXCEDE A LOS ' + CONVERT(VARCHAR(15), @param_uno) + ' DIAS PERMITIDOS';
			END
		END
		ELSE
		BEGIN
			IF(@can_dias <= @param_uno)
			BEGIN
				IF( (SELECT DAY(GETDATE())) <= @param_dos )
				BEGIN
					SET @flag = 1;
					SET @msje = 'EXITO';
				END
				ELSE
				BEGIN
					SET @msje = 'FECHA DE VENTA ('+@fecha_cad+') EXCEDE A LOS ' + CONVERT(VARCHAR(15), @param_dos) + ' DIAS PERMITIDOS DE OTRO MES';
				END
			END
			ELSE
			BEGIN
				SET @msje = 'FECHA DE VENTA ('+@fecha_cad+') EXCEDE A LOS ' + CONVERT(VARCHAR(15), @param_uno) + ' DIAS PERMITIDOS';
			END
		END

		SELECT @flag as flag, @msje as msje
	END TRY

	BEGIN CATCH
		SELECT ERROR_NUMBER() as flag, 'Error en pa_notacredito_validar_venta ' + ERROR_MESSAGE() as msje
	END CATCH
END
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_lista_comprob_fallidos' AND type = 'P')
	DROP PROCEDURE pa_lista_comprob_fallidos
GO
----------------------------------------------------------------------------------
-- Author: Wilmer Sanchez IDE-SOLUTION
-- Created: 28/04/2020
-- Sistema: Distribuidora Virgende del carmen
-- Descripcion: Lista de comprobantes fallidos enviados a la sunat
-- Log Modificaciones:
-- CODIGO NOMBRE FECHA MOTIVO
-----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[pa_lista_comprob_fallidos]	
AS
	BEGIN
		SET NOCOUNT ON
		
		SELECT ntraComprob,codTransaccion,codModulo,tipDocSunat,tipDocVenta,tramEntrada 
		FROM tblComprobSunat WHERE estado = 2 and marcaBaja = 0


END
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_registrar_comprobante_sunat' AND type = 'P')
	DROP PROCEDURE pa_registrar_comprobante_sunat
GO
----------------------------------------------------------------------------------
-- Author: Wilmer Sanchez IDE-SOLUTION
-- Created: 20/02/2020  
-- Sistema: DistribuidoraVDC
-- Descripción: Registro de comprobante sunat 
-- Log Modificaciones: 
-- CODIGO    REQUERIMIENTO          NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_registrar_comprobante_sunat
(
	@p_codTransaccion INT,			-- Codigo de transaccion
	@p_codModulo SMALLINT,			-- Codigo de modulo 
	@p_tipDocSunat SMALLINT,			-- ipo de documento de sunat (Ventas, NC)
	@p_tipDocVenta SMALLINT,			-- Documento de venta (boleta/factura/Parcial/Total)
	@p_tramEntrada VARCHAR(MAX), -- trama de entrada
	@p_estado SMALLINT,			-- estado
	@p_usuario VARCHAR(20), -- usuario
	@p_ip VARCHAR(20), -- ip
	@p_mac VARCHAR(20) -- MAC

)		
AS
	BEGIN
		DECLARE @ntra INT;						--numero de transaccion

		SET @ntra = 0;
		
		INSERT INTO tblComprobSunat(codTransaccion, codModulo, tipDocSunat, tipDocVenta, tramEntrada, estado,usuario, ip, mac)
		VALUES(@p_codTransaccion,@p_codModulo,@p_tipDocSunat,@p_tipDocVenta,@p_tramEntrada,@p_estado,@p_usuario,@p_ip,@p_mac)
		
		SET @ntra = (SELECT @@IDENTITY);
		
		SELECT @ntra as 'codigo'
			

	END	
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_existe_ruc_cliente' AND type = 'P')
	DROP PROCEDURE pa_existe_ruc_cliente
GO
----------------------------------------------------------------------------------
-- Author: Wilmer Sanchez IDE-SOLUTION
-- Created: 30/01/2020
-- Sistema: Distribuidora Virgende del carmen
-- Descripcion: Verificar si existe cliente por RUC
-- Log Modificaciones:
-- CODIGO NOMBRE FECHA MOTIVO
-----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[pa_existe_ruc_cliente]	
(
	@p_ruc VARCHAR(11)		-- ruc del cliente
)

AS
	BEGIN
	SET NOCOUNT ON
		DECLARE @val TINYINT		-- Valor de existencia
		DECLARE @flag INT;			-- flag de proceso
		DECLARE @msje VARCHAR(250);	-- mensaje de error
		

		SET @flag = 0;
		SET @msje = 'Exito';
		SET @val = 0;
		
		SELECT @val = COUNT(*) FROM tblCliente INNER JOIN tblPersona ON tblCliente.codPersona = tblPersona.codUbigeo
		WHERE tblPersona.ruc = @p_ruc and tblCliente.marcaBaja = 0

		SELECT @flag as flag , @msje as msje, @val as val


END
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_actualizar_comprobante_sunat' AND type = 'P')
	DROP PROCEDURE pa_actualizar_comprobante_sunat
GO
----------------------------------------------------------------------------------
-- Author: Wilmer Sanchez IDE-SOLUTION
-- Created: 20/02/2020  
-- Sistema: DistribuidoraVDC
-- Descripción: Actualizacion de comprobante sunat 
-- Log Modificaciones: 
-- CODIGO    REQUERIMIENTO          NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_actualizar_comprobante_sunat
(
	@p_codTransaccion INT,			-- Codigo de transaccion
	@p_tramSalida VARCHAR(MAX), -- trama de salida
	@p_estado SMALLINT			-- estado
)		
AS
	BEGIN
		DECLARE @ntra INT;						--numero de transaccion

		SET @ntra = 0;
		
		UPDATE tblComprobSunat SET tramSalida = @p_tramSalida, estado = @p_estado WHERE ntraComprob = @p_codTransaccion
			

	END	
GO






