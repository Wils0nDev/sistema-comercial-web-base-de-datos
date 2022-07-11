
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

--exec pa_listar_clientes_ruta_sinc 1



 