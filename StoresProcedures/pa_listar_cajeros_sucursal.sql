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