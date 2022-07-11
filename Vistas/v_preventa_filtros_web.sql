IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'v_preventa_filtros_web' AND type = 'V')
	DROP VIEW v_preventa_filtros_web
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
----------------------------------------------------------------------------------
-- Author: Diego Sanchez S. IDE-SOLUTION
-- Created:  09/03/2020  
-- Sistema: Sistema Distribuidora Virgen del Carmen.
-- Modulo : Mantenedor de preventa.
-- Descripción: v_preventa_filtros_web
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE view [dbo].[v_preventa_filtros_web]
as
select pre.ntraPreventa, dpre.codProducto,abt.codProveedor, pre.codUsuario, pre.codCliente, pre.codPuntoEntrega, pre.tipoVenta, 
pre.tipoDocumentoVenta, pre.estado, pre.origenVenta, rut.ntraRutas, pre.tipoMoneda,
CONCAT(per2.nombres,' ', per2.apellidoPaterno,' ', per2.apellidoMaterno) as vendedor, per.tipoPersona,
CASE 
	when per.tipoPersona = 1 THEN CONCAT(per.nombres, ' ' , per.apellidoPaterno,' ', per.apellidoMaterno)
	WHEN per.tipoPersona = 2 THEN per.razonSocial
END as cliente,
CASE 
	when per.tipoPersona = 1 THEN per.numeroDocumento
	WHEN per.tipoPersona = 2 THEN per.ruc
END as identificacion,
rut.descripcion as ruta, pe.direccion, pre.fecha, pre.fechaEntrega, tmo.descripcion as  moneda, tve.descripcion as tVenta, 
tdo.descripcion as tDoc, est.descripcion as estPre, ove.descripcion as oVenta, pre.recargo, pre.igv, pre.total, suc.ntraSucursal,
suc.descripcion as sucursal,per.codUbigeo, pre.horaEntrega, cli.tipoListaPrecio, pre.flagRecargo
from tblPreventa pre
inner join tblDetallePreventa dpre on dpre.codPreventa = pre.ntraPreventa
inner join tblSucursal suc on suc.ntraSucursal = pre.codSucursal
left join tblAbastecimento abt on abt.codProducto = dpre.codProducto
inner join tblCliente cli on pre.codCliente = cli.codPersona
inner join tblRutas rut on rut.ntraRutas = cli.codRuta
inner join tblUsuario usr on pre.codUsuario = usr.ntraUsuario
inner join tblPersona per on per.codPersona = cli.codPersona
inner join tblPersona per2 on per2.codPersona = usr.codPersona
inner join tblPuntoEntrega pe on pre.codPuntoEntrega = pe.ntraPuntoEntrega
inner join (select correlativo, descripcion from tblConcepto where codConcepto = 17) as est on pre.estado = est.correlativo
inner join (select correlativo, descripcion from tblConcepto where codConcepto = 18) as ove on pre.origenVenta = ove.correlativo
inner join (select correlativo, descripcion from tblConcepto where codConcepto = 19) as tve on pre.tipoVenta = tve.correlativo
inner join (select correlativo, descripcion from tblConcepto where codConcepto = 20) as tdo on pre.tipoDocumentoVenta = tdo.correlativo
inner join (select correlativo, descripcion from tblConcepto where codConcepto = 21) as tmo on pre.tipoMoneda = tmo.correlativo
where pre.marcaBaja = 0;
GO
