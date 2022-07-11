
IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_buscar_vendedor_sinc' AND type = 'P')
	DROP PROCEDURE pa_buscar_vendedor_sinc
GO
----------------------------------------------------------------------------------
-- Author: Wilmer Sanchez IDE-SOLUTION
-- Created: 13/01/2020  
-- Sistema: ws_wa_DistribuidoraVDC
-- Descripción: Traer lista de clientes por ruta
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

--exec pa_buscar_vendedor_sinc 1


