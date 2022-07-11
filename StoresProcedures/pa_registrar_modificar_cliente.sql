
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