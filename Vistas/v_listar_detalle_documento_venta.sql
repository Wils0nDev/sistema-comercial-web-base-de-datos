IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'v_listar_detalle_documento_venta' AND type = 'V')
	DROP VIEW v_listar_detalle_documento_venta
GO
----------------------------------------------------------------------------------
-- Author: Wilson Vasquez IDE-SOLUTION
-- Created: 24/03/2020  
-- Sistema: WEB / Mantenedor detalle de venta (factura,boleta,etc)
-- Descripción: Vista listar detalle documento venta
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE VIEW [dbo].[v_listar_detalle_documento_venta]
			AS
				SELECT v.ntraVenta, serie, CONCAT(p.nombres,' ',' ', p.apellidoPaterno,' ', p.apellidoMaterno) AS cliente, 
				p.razonSocial,CONCAT(pe.nombres,' ', ' ', pe.apellidoPaterno,' ', pe.apellidoMaterno) as vendedor,
				v.fechaTransaccion, v.importeTotal as importeTotal, co.descripcion as estado, v.estado as estadov, v.codCliente, V.codVendedor,nroDocumento,
				v.tipoDocumentoVenta as tipodocumento,con.descripcion as descdocumento, v.fechaPago  as fechaPago, v.tipoVenta as tipoVenta,
				coo.descripcion as descriptipoventa, v.IGV as igv, 
				v.tipoMoneda as tipoMoneda, cc.estado as estadoc,cc.importe as importecxc, pr.importeTotal as importeP, pr.estado as estadoP, cm.descripcion as moneda
				from tblVenta v	
				INNER JOIN tblCliente c on c.codPersona = v.codCliente
				INNER JOIN tblPersona p on c.codPersona = p.codPersona
				INNER JOIN tblUsuario u on u.ntraUsuario = v.codVendedor
				INNER JOIN tblPersona pe on u.codPersona = pe.codPersona
				INNER JOIN tblConcepto con on v.tipoDocumentoVenta  = con.correlativo
				INNER JOIN tblConcepto co on v.estado  = co.correlativo
				INNER JOIN tblConcepto coo on  v.tipoVenta  = coo.correlativo
				LEFT JOIN tblCuentaCobro cc on v.ntraVenta = cc.codOperacion
				LEFT JOIN tblPrestamo pr on v.ntraVenta = pr.codVenta
				INNER JOIN tblConcepto  cm on v.tipoMoneda = cm.correlativo
				WHERE co.codConcepto = 28 and co.correlativo != 0 and con.codConcepto = 20 and con.correlativo != 0
				and coo.codConcepto = 19 and coo.correlativo != 0 and v.marcaBaja = 0 and (pr.marcaBaja =  0 OR pr.marcaBaja is null ) 
				and (cc.marcaBaja = 0 OR cc.marcaBaja is null)
				and coo.codConcepto = 19 and coo.correlativo != 0 and	v.estado != 5 and v.estado != 4
				and cm.codConcepto = 21  and cm.correlativo !=0;
GO


