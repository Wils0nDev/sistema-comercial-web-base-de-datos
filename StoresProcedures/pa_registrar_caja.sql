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