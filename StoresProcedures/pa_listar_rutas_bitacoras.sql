
IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_listar_rutas_bitacoras' AND type = 'P')
	DROP PROCEDURE pa_listar_rutas_bitacoras
GO
----------------------------------------------------------------------------------
-- Author: WILSON IDE-SOLUTION
-- Created: 13/01/2020  
-- Sistema: ws_wa_DistribuidoraVDC
-- Descripción: Actualizar bitacoras de ruta
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