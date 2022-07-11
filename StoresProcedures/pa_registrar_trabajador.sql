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
