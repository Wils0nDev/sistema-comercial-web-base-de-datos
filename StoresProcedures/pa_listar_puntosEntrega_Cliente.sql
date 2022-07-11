IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_listar_puntosEntrega_Cliente' AND type = 'P')
	DROP PROCEDURE pa_listar_puntosEntrega_Cliente
GO
----------------------------------------------------------------------------------
-- Author: Jonathan Macalupu S. IDE-SOLUTION
-- Created: 06/01/2020  
-- Sistema: Sistema Distribuidora Virgen del Carmen
-- Modulo: General
-- Descripción: Listar puntos de entrega del cliente 
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