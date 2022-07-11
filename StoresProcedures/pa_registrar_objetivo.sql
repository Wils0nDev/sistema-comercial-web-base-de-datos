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