IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'v_lista_ventas' AND type = 'V')
	DROP VIEW v_lista_ventas
GO
----------------------------------------------------------------------------------
-- Author: Wilmer Sanchez. IDE-SOLUTION
-- Created:  26/03/2020  
-- Sistema: Sistema Distribuidora Virgen del Carmen.
-- Modulo : Mantenedor de ventas.
-- Descripción: Vista listar de ventas
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

CREATE VIEW v_lista_ventas
AS

select pre.ntraVenta,pre.serie,pre.nroDocumento,  pre.codVendedor, pre.codCliente, pre.codPuntoEntrega, pre.tipoVenta, 
pre.tipoDocumentoVenta, pre.estado, rut.ntraRutas, pre.tipoMoneda,
CONCAT(per2.nombres,' ', per2.apellidoPaterno,' ', per2.apellidoMaterno) as vendedor, per.tipoPersona,
CASE 
	when per.tipoPersona = 1 THEN CONCAT(per.nombres, ' ' , per.apellidoPaterno,' ', per.apellidoMaterno)
	WHEN per.tipoPersona = 2 THEN per.razonSocial
END as cliente,
CASE 
	when per.tipoPersona = 1 THEN per.numeroDocumento
	WHEN per.tipoPersona = 2 THEN per.ruc
END as identificacion,
rut.descripcion as ruta, pe.direccion, pre.fechaPago, pre.fechaTransaccion, tmo.descripcion as  moneda, tve.descripcion as tVenta, 
tdo.descripcion as tDoc, est.descripcion as estPre, pre.importeRecargo, pre.IGV, pre.importeTotal, suc.ntraSucursal,
suc.descripcion as sucursal,per.codUbigeo, cli.tipoListaPrecio
from tblVenta pre
inner join tblSucursal suc on suc.ntraSucursal = pre.codSucursal
inner join tblCliente cli on pre.codCliente = cli.codPersona
inner join tblRutas rut on rut.ntraRutas = cli.codRuta
inner join tblUsuario usr on pre.codVendedor = usr.ntraUsuario
inner join tblPersona per on per.codPersona = cli.codPersona
inner join tblPersona per2 on per2.codPersona = usr.codPersona
inner join tblPuntoEntrega pe on pre.codPuntoEntrega = pe.ntraPuntoEntrega
inner join (select correlativo, descripcion from tblConcepto where codConcepto = 28) as est on pre.estado = est.correlativo
inner join (select correlativo, descripcion from tblConcepto where codConcepto = 19) as tve on pre.tipoVenta = tve.correlativo
inner join (select correlativo, descripcion from tblConcepto where codConcepto = 20) as tdo on pre.tipoDocumentoVenta = tdo.correlativo
inner join (select correlativo, descripcion from tblConcepto where codConcepto = 21) as tmo on pre.tipoMoneda = tmo.correlativo
where pre.marcaBaja = 0;

GO

-- select * from v_lista_ventas