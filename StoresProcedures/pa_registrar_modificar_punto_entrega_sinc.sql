
IF EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_registrar_modificar_punto_entrega_sinc' AND type = 'P')
DROP PROCEDURE pa_registrar_modificar_punto_entrega_sinc
GO
----------------------------------------------------------------------------------
-- Author: Alex Llamo IDE-SOLUTION
-- Created: 30/01/2020
-- Sistema: ws_wa_DistribuidoraVDC
-- Descripción: Registrar y modificar punto de entrega
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