IF DB_NAME() = 'BD_virgendelcarmen'
	set noexec on
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'v_auto_nom_listar_usuario' AND type = 'V')
	DROP VIEW v_auto_nom_listar_usuario
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

----------------------------------------------------------------------------------
-- Author: Joseph Guivar Rimapa IDE-SOLUTION
-- Sistema: Sistema DistribuidoraVDC
-- Descripcion: Buscar usuario por nombre
-- Log Modificaciones:
-- CODIGO NOMBRE FECHA MOTIVO
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE VIEW [dbo].[v_auto_nom_listar_usuario]
AS
SELECT  
	CONCAT(	(CASE WHEN (p.tipoPersona) = 1 THEN UPPER(p.apellidoPaterno ) ELSE UPPER(p.apellidoPaterno + ' ' + p.apellidoMaterno + ' ' + p.nombres) END), ' ',
			(CASE WHEN (p.tipoPersona) = 1 THEN UPPER(p.apellidoMaterno ) ELSE UPPER(p.apellidoPaterno + ' ' + p.apellidoMaterno + ' ' + p.nombres) END), ' ',
			(CASE WHEN (p.tipoPersona) = 1 THEN UPPER( p.nombres ) ELSE UPPER(p.apellidoPaterno + ' ' + p.apellidoMaterno + ' ' + p.nombres) END) , ' - ',
			(CASE WHEN (p.tipoPersona) = 1 THEN  UPPER (u.users)  ELSE  (p.apellidoPaterno + ' ' + p.apellidoMaterno + ' ' + p.nombres) END)) AS 'concatenado',
			

		--    (CASE WHEN (p.tipoPersona) = 1 THEN  UPPER (u.users)  ELSE  (p.apellidoPaterno + ' ' + p.apellidoMaterno + ' ' + p.nombres) END ) AS 'userConcatenado',

	CONCAT(	(CASE WHEN (p.tipoPersona) = 1 THEN UPPER(p.apellidoPaterno ) ELSE UPPER(p.apellidoPaterno + ' ' + p.apellidoMaterno + ' ' + p.nombres) END), ' ',
			(CASE WHEN (p.tipoPersona) = 1 THEN UPPER(p.apellidoMaterno ) ELSE UPPER(p.apellidoPaterno + ' ' + p.apellidoMaterno + ' ' + p.nombres) END), ' ',
			(CASE WHEN (p.tipoPersona) = 1 THEN UPPER( p.nombres ) ELSE UPPER(p.apellidoPaterno + ' ' + p.apellidoMaterno + ' ' + p.nombres) END)) AS 'nombres',

				p.codPersona		as 'codPersona',
				p.numeroDocumento	as	'numDoc'
			--	u.users				as	'userName'


FROM tblPersona p INNER JOIN tblUsuario u
ON p.codPersona = u.codPersona 
WHERE u.marcaBaja = 0 and p.marcaBaja = 0

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'v_descuentos_filtros' AND type = 'V')
	DROP VIEW v_descuentos_filtros
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
----------------------------------------------------------------------------------
-- Author: Diego Sanchez S. IDE-SOLUTION
-- Created:  28/03/2020  
-- Sistema: Sistema Distribuidora Virgen del Carmen.
-- Modulo : Mantenedor de descuento.
-- Descripción: v_descuentos_filtros
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE view [dbo].[v_descuentos_filtros]
as
	SELECT t.ntraDescuento,d.descripcion,d.estado, d.fechaInicial, d.fechaFin, d.horaInicial,d.horaFin,
	estd.descripcion as desEstado, pro.descripcion as desProducto, pro.codUnidadBaseventa as codUnidad,unib.descripcion as desUnidad,
	flag1 = STUFF((SELECT '-' + CONVERT(VARCHAR(12), valorInicial)
	FROM tblDetalleDescuentos
	WHERE ntraDescuento = t.ntraDescuento and flag in(1)
	FOR XML PATH(''), TYPE).value('.[1]','nvarchar(max)'),1,1,''),
	flag2 = STUFF((SELECT '-' + CONVERT(VARCHAR(12), valorInicial)
	FROM tblDetalleDescuentos
	WHERE ntraDescuento = t.ntraDescuento and flag in(2)
	FOR XML PATH(''), TYPE).value('.[1]','nvarchar(max)'),1,1,''),
	flag2_2 = STUFF((SELECT '-' + CONVERT(VARCHAR(12), valorFinal)
	FROM tblDetalleDescuentos
	WHERE ntraDescuento = t.ntraDescuento and flag in(2)
	FOR XML PATH(''), TYPE).value('.[1]','nvarchar(max)'),1,1,''),
	flag3 = STUFF((SELECT '-' + CONVERT(VARCHAR(12), valorInicial)
	FROM tblDetalleDescuentos
	WHERE ntraDescuento = t.ntraDescuento and flag in(3)
	FOR XML PATH(''), TYPE).value('.[1]','nvarchar(max)'),1,1,''),
	flag3_2 = STUFF((SELECT '-' + CONVERT(VARCHAR(12), valorFinal)
	FROM tblDetalleDescuentos
	WHERE ntraDescuento = t.ntraDescuento and flag in(3)
	FOR XML PATH(''), TYPE).value('.[1]','nvarchar(max)'),1,1,''),
	flag4 = STUFF((SELECT '-' + CONVERT(VARCHAR(12), valorInicial)
	FROM tblDetalleDescuentos
	WHERE ntraDescuento = t.ntraDescuento and flag in(4)
	FOR XML PATH(''), TYPE).value('.[1]','nvarchar(max)'),1,1,''),
	flag5 = STUFF((SELECT '-' + CONVERT(VARCHAR(12), valorInicial)
	FROM tblDetalleDescuentos
	WHERE ntraDescuento = t.ntraDescuento and flag in(5)
	FOR XML PATH(''), TYPE).value('.[1]','nvarchar(max)'),1,1,''),
	flag6 = STUFF((SELECT '-' + CONVERT(VARCHAR(12), valorInicial)
	FROM tblDetalleDescuentos
	WHERE ntraDescuento = t.ntraDescuento and flag in(6)
	FOR XML PATH(''), TYPE).value('.[1]','nvarchar(max)'),1,1,''),
	flag7 = STUFF((SELECT '-' + CONVERT(VARCHAR(12), valorInicial)
	FROM tblDetalleDescuentos
	WHERE ntraDescuento = t.ntraDescuento and flag in(7)
	FOR XML PATH(''), TYPE).value('.[1]','nvarchar(max)'),1,1,''),
	flag8 = STUFF((SELECT '-' + CONVERT(VARCHAR(12), valorInicial)
	FROM tblDetalleDescuentos
	WHERE ntraDescuento = t.ntraDescuento and flag in(8)
	FOR XML PATH(''), TYPE).value('.[1]','nvarchar(max)'),1,1,'')

	FROM tblDescuentos d 
	INNER JOIN tblDetalleDescuentos AS t on d.ntraDescuento = t.ntraDescuento
	INNER JOIN tblProducto pro on t.flag=1 and pro.codProducto = t.valorInicial
	INNER JOIN (select correlativo, descripcion from tblConcepto where codConcepto = 30 and marcaBaja = 0) as estd on d.estado = estd.correlativo
	INNER JOIN (select correlativo, descripcion from tblConcepto where codConcepto = 12 and marcaBaja = 0) as unib on pro.codUnidadBaseventa = unib.correlativo
	where t.flag in(1,4,5) and d.marcaBaja = 0
	group by unib.descripcion,pro.codUnidadBaseventa,pro.descripcion,d.descripcion, d.estado,d.fechaInicial,d.fechaFin,d.horaInicial,d.horaFin,estd.descripcion,t.ntraDescuento;

GO

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


-- select * from v_lista_ventas

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'v_listar_clientes' AND type = 'V')
	DROP VIEW v_listar_clientes
GO
/****** Object:  View [dbo].[v_listar_clientes]    Script Date: 31/01/2020 10:00:00 ******/
----------------------------------------------------------------------------------
-- Author: Jonathan Macalupu S. IDE-SOLUTION
-- Created:  31/01/2020  
-- Sistema: Sistema Distribuidora Virgen del Carmen.
-- Modulo : Mantenedor de clientes.
-- Descripción: Vista listar clientes
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW v_listar_clientes
AS

SELECT p.codPersona AS codPersona, p.tipoPersona AS tipoPersona, p.tipoDocumento AS tipoDocumento, p.numeroDocumento AS numeroDocumento, p.ruc AS ruc, p.razonSocial AS razonSocial, 
p.nombres AS nombres, p.apellidoPaterno as apellidoPaterno, p.apellidoMaterno AS apellidoMaterno, p.nombres + ' ' + p.apellidoPaterno + ' ' + p.apellidoMaterno AS nombreCompleto , 
p.direccion AS direccion, p.correo AS correo, p.telefono AS telefono, p.celular AS celular,
c.perfilCliente AS perfilCliente, c.clasificacionCliente AS clasificacionCliente, c.frecuenciaCliente AS frecuenciaCliente, 
c.tipoListaPrecio AS tipoListaPrecio, c.codRuta AS codRuta, c.ordenAtencion AS ordenAtencion, p.codUbigeo AS codUbigeo,l.coordenadaX as coordenadaX , l.coordenadaY as coordenadaY
FROM tblPersona p INNER JOIN tblCliente c ON p.codPersona = c.codPersona
INNER JOIN tblLocalizacion l on c.codPersona = l.codPersona
WHERE p.marcaBaja = 0 AND c.marcaBaja = 0;


GO


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

IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'v_listar_detalle_xproducto' AND type = 'V')
	DROP VIEW v_listar_detalle_xproducto
GO
----------------------------------------------------------------------------------
-- Author: Dany Gelacio IDE-SOLUTION
-- Created: 31/03/2020 
-- Sistema: Mantenedor Producto
-- Descripción: Vista listar detalle de presentacion de producto
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE VIEW v_listar_detalle_xproducto
AS
	SELECT dp.codProducto, dp.codPresentancion, dp.cantidadUnidadBase
	FROM     dbo.tblDetallePresentacion AS dp INNER JOIN
                  dbo.tblConcepto AS cp ON cp.correlativo = dp.codPresentancion
	WHERE  (cp.codConcepto = 12) AND (cp.marcaBaja = 0)

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'v_listar_precios' AND type = 'V')
	DROP VIEW v_listar_precios
GO
/****** Object:  View [dbo].[v_listar_precios]    Script Date: 10/02/2020 10:00:00 ******/
----------------------------------------------------------------------------------
-- Author: Luis Llatas IDE-SOLUTION
-- Created: 10/02/2020  
-- Sistema: WEB / Mantenedor Precios
-- Descripción: Vista listar precios
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW v_listar_precios
AS

SELECT tblAbastecimento.codProveedor AS codProveedor,
       (SELECT descripcion from tblProveedor where ntraProveedor = tblAbastecimento.codProveedor AND tblProveedor.marcaBaja = 0) AS descProveedor,
       tblProducto.codFabricante AS codFabricante,
       tblFabricante.descripcion AS descFabricante,
       tblProducto.codCategoria AS codCategoria,
       tblCategoria.descripcion AS descCategoria,
       tblProducto.codSubcategoria AS codSubcategoria,
       tblSubcategoria.descripcion AS descSubcategoria,
       tblProducto.codProducto AS codProducto,
       tblProducto.descripcion AS descProducto,
       ( CASE WHEN (SELECT precioVenta FROM tblPrecio WHERE tblPrecio.codProducto = tblProducto.codProducto AND tblPrecio.tipoListaPrecio = 1 AND tblPrecio.marcaBaja = 0) IS NULL
       THEN ''
       ELSE (SELECT precioVenta FROM tblPrecio WHERE tblPrecio.codProducto = tblProducto.codProducto  AND tblPrecio.tipoListaPrecio = 1 AND tblPrecio.marcaBaja = 0) END )
       AS precioCosto
       
FROM tblProducto 
 INNER JOIN tblCategoria  
   ON tblProducto.codCategoria = tblCategoria.ntraCategoria
 INNER JOIN tblSubcategoria
   ON tblProducto.codSubcategoria = tblSubcategoria.ntraSubcategoria
 INNER JOIN tblAbastecimento
   ON tblProducto.codProducto = tblAbastecimento.codProducto
 INNER JOIN tblFabricante
   ON tblProducto.codFabricante = tblFabricante.ntraFabricante 
 LEFT JOIN tblPrecio
   ON tblProducto.codProducto = tblPrecio.codProducto AND tblPrecio.tipoListaPrecio = 1 -- Tipo de Lista de Precio (Precio Costo => codConcepto = 7, correlativo = 1)
 WHERE tblProducto.marcaBaja       = 0 AND 
       tblCategoria.marcaBaja      = 0 AND
       tblSubcategoria.marcaBaja   = 0 AND 
       tblAbastecimento.marcaBaja  = 0 AND
       tblFabricante.marcaBaja     = 0 
         
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'v_listar_producto' AND type = 'V')
	DROP VIEW v_listar_producto
GO
----------------------------------------------------------------------------------
-- Author: Dany Gelacio - IDE-SOLUTION
-- Created:  31/03/2020  
-- Sistema: Sistema Distribuidora Virgen del Carmen.
-- Modulo : Mantenedor de producto
-- Descripción: Vista listar producto
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE VIEW v_listar_producto
AS
SELECT p.codProducto, c.descripcion AS categoria, s.descripcion as subcategoria, pr.descripcion AS proveedor, 
f.descripcion AS fabricante, p.descripcion, cp.descripcion as unidadBase, cpt.descripcion AS tipoProducto, CASE p.flagVenta WHEN 1 THEN 'VENTA' ELSE 'AGREGADO'
 END AS flagVenta
 from tblProducto p INNER JOIN tblCategoria c on p.codCategoria=c.ntraCategoria
INNER JOIN tblSubcategoria s on p.codSubcategoria=s.ntraSubcategoria
INNER JOIN tblAbastecimento ab on p.codProducto = ab.codProducto INNER JOIN
tblProveedor pr on pr.ntraProveedor=ab.codProveedor
INNER JOIN tblFabricante f on f.ntraFabricante= p.codFabricante
INNER JOIN tblConcepto cp on cp.correlativo = p.codUnidadBaseventa
INNER JOIN tblConcepto cpt on cpt.correlativo = p.tipoProducto
WHERE (cp.codConcepto = 12) AND (cp.correlativo <> 0)  AND (cpt.codConcepto=23) AND (cpt.correlativo <> 0) 
AND (p.marcaBaja = 0) AND (ab.marcaBaja=0) AND (c.marcaBaja=0) AND (s.marcaBaja=0)
 AND (pr.marcaBaja=0)


GO

IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'v_listar_productos' AND type = 'V')
	DROP VIEW v_listar_productos
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
----------------------------------------------------------------------------------
-- Author: Diego Sanchez IDE-SOLUTION
-- Created: 27/03/2020  
-- Sistema: Sistema Distribuidora Virgen del Carmen.
-- Descripción: Listar los productos para filtrar por tipo
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE view [dbo].[v_listar_productos]
as
SELECT DISTINCT CONCAT(pro.codProducto, ' - ', pro.descripcion ) AS 'concatenado', 
pro.codProducto AS 'codProducto', pro.descripcion AS 'descripcion', pro.tipoProducto, pro.flagVenta
FROM tblProducto pro
WHERE pro.marcaBaja = 0;

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'v_listar_rutas_asignadas_x_vendedor' AND type = 'V')
	DROP VIEW v_listar_rutas_asignadas_x_vendedor
GO
/****** Object:  View [dbo].[v_listar_rutas_asignadas_x_vendedor]    Script Date: 12/02/2020 10:00:00 ******/
----------------------------------------------------------------------------------
-- Author: Wilson Vasquez IDE-SOLUTION
-- Created: 12/02/2020  
-- Sistema: WEB / Mantenedor Rutas Asignadas
-- Descripción: Vista listar rutas asignadas por vendedor
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW v_listar_rutas_asignadas_x_vendedor
AS
SELECT r.ntraRutas,u.ntraUsuario,c.correlativo, codOrden as ORDEN , r.pseudonimo as ABREVIATURA, CONCAT(p.nombres,' ', p.apellidoPaterno,' ',p.apellidoMaterno) as VENDEDOR ,
r.descripcion  AS RUTA, c.descripcion AS DIA , ra.estado
FROM tblRutasAsignadas ra 
INNER JOIN tblRutas r on ra.codRuta = r.ntraRutas 
INNER JOIN tblUsuario u on ra.codUsuario = u.ntraUsuario
INNER JOIN tblPersona p on u.codPersona = p.codPersona
INNER JOIN tblConcepto c on ra.diaSemana = c.correlativo
WHERE c.codConcepto = 8 AND r.marcaBaja = 0 and u.marcaBaja = 0 and c.marcaBaja = 0 and p.marcaBaja = 0 and ra.marcaBaja = 0


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'v_listar_usuario' AND type = 'V')
	DROP VIEW v_listar_usuario
GO
/****** Object:  View [dbo].[v_listar_usuario]    Script Date: 14/04/2020 00:00:00 ******/
----------------------------------------------------------------------------------
-- Author:  Joseph Guivar IDE-SOLUTION
-- Created: 14/04/2020  
-- Sistema: Sistema Distribuidora Virgen del Carmen.
-- Modulo : Mantenedor de Usuarios
-- Descripción: Vista listar Usuario
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[v_listar_usuario]
AS
SELECT        p.codPersona as codPersona, u.codPersona as ntraUsuario, p.numeroDocumento, u.users as Usuario,CONCAT(p.nombres,' ',' ', p.apellidoPaterno,' ', p.apellidoMaterno) AS usuarioPersona
,p.correo, p.celular,  f.descripcion AS perfil ,s.descripcion as sucursal, s.ntraSucursal AS codigoSucursal, 
f.codigo AS codigoPerfil , u.estado as codEstado ,c.descripcion as estadoDescp, p.telefono		
FROM			tblUsuario AS u 
INNER JOIN		tblPersona AS p ON u.codPersona = p.codPersona 
INNER JOIN		tblSucursal AS s ON u.codSucursal = s.ntraSucursal
INNER JOIN		tblPerfil AS f ON u.codPerfil = f.codigo
INNER JOIN		tblConcepto AS  c ON u.estado = c.correlativo
WHERE c.codConcepto = 14 AND u.marcaBaja = 0 AND p.marcaBaja = 0 AND s.marcaBaja = 0 AND f.marcaBaja = 0 AND c.marcaBaja = 0


GO

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


IF EXISTS (SELECT * FROM sys.objects WHERE name = 'v_preventa_listar_clientes' AND type = 'V')
	DROP VIEW v_preventa_listar_clientes
GO
----------------------------------------------------------------------------------
-- Author: Alex Llamo IDE-SOLUTION
-- Created: 09/03/2020
-- Sistema: ws_wa_DistribuidoraVDC
-- Descripcion: Buscar cliente preventa
-- Log Modificaciones:
-- CODIGO NOMBRE FECHA MOTIVO
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE VIEW v_preventa_listar_clientes
AS
SELECT CONCAT((CASE WHEN (p.tipoPersona) = 2 THEN UPPER(p.razonSocial) ELSE UPPER(p.apellidoPaterno + ' ' + p.apellidoMaterno + ' ' + p.nombres) END),
' - ',(CASE WHEN (p.tipoPersona) = 2 THEN UPPER(p.ruc) ELSE UPPER(p.numeroDocumento) END)) AS 'concatenado', 
c.codPersona as 'codPersona',
(CASE WHEN (p.tipoPersona) = 2 THEN UPPER(p.ruc) ELSE UPPER(p.numeroDocumento) END) AS 'numDocumento',
(CASE WHEN (p.tipoPersona) = 2 THEN UPPER(p.razonSocial) ELSE UPPER(p.apellidoPaterno + ' ' + p.apellidoMaterno + ' ' + p.nombres) END) AS 'nombres',
c.tipoListaPrecio as 'tipoListaPrecio'

FROM tblPersona p INNER JOIN tblCliente c
ON p.codPersona = c.codPersona
WHERE c.marcaBaja = 0 and p.marcaBaja = 0


GO


IF EXISTS (SELECT * FROM sys.objects WHERE name = 'v_preventa_listar_productos' AND type = 'V')
	DROP VIEW v_preventa_listar_productos
GO
----------------------------------------------------------------------------------
-- Author: Alex Llamo IDE-SOLUTION
-- Created: 11/03/2020
-- Sistema: ws_wa_DistribuidoraVDC
-- Descripcion: Buscar productos preventa
-- Log Modificaciones:
-- CODIGO NOMBRE FECHA MOTIVO
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE VIEW v_preventa_listar_productos
AS
SELECT DISTINCT CONCAT(pro.codProducto, ' - ', pro.descripcion ) AS 'concatenado', 
pro.codProducto AS 'codProducto', pro.descripcion AS 'descripcion'
FROM tblProducto pro INNER JOIN tblInventario inv ON inv.codProducto = pro.codProducto
WHERE inv.stock > 0 and pro.marcaBaja = 0 and inv.marcaBaja = 0


GO

IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'v_promocionesfiltrosweb' AND type = 'V')
	DROP VIEW v_promocionesfiltrosweb
GO

/****** Object:  View [dbo].[v_promocionesfiltrosweb]    Script Date: 02/04/2020 10:29:05 ******/

----------------------------------------------------------------------------------
-- Author: KVASQUEZ. IDE-SOLUTION
-- Created:  09/03/2020  
-- Sistema: Sistema Distribuidora Virgen del Carmen.
-- Modulo : Mantenedor de Promociones.
-- Descripción: v_promocionesfiltrosweb
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

CREATE view [dbo].[v_promocionesfiltrosweb]
as

	SELECT t.ntraPromocion,d.descripcion as nombrePromo,d.fechaInicial, d.fechaFin,d.horaInicial,d.horaFin,d.codSucursal,d.estado,estadoPromo,
	prove.ntraProveedor as codProveedor, prove.descripcion as proveedor ,

	codProducto = STUFF((SELECT '-' + CONVERT(VARCHAR(12), valorInicial)
	FROM tblDetallePromociones 
	WHERE ntraPromocion  = t.ntraPromocion  and flag in(1)
	FOR XML PATH(''), TYPE).value('.[1]','nvarchar(max)'),1,1,''),

	producto = STUFF((SELECT '-' + CONVERT(VARCHAR(50), descripcion)
	FROM tblDetallePromociones 
	WHERE ntraPromocion  = t.ntraPromocion  and flag in(1)
	FOR XML PATH(''), TYPE).value('.[1]','nvarchar(max)'),1,1,''),


	cantImporte = STUFF((SELECT '-' + CONVERT(VARCHAR(12), valorInicial)
	FROM tblDetallePromociones
	WHERE ntraPromocion = t.ntraPromocion and flag in(2)
	FOR XML PATH(''), TYPE).value('.[1]','nvarchar(max)'),1,1,''),

	tipoImporte = STUFF((SELECT '-' + CONVERT(VARCHAR(12), valorFinal)
	FROM tblDetallePromociones
	WHERE ntraPromocion = t.ntraPromocion and flag in(2)
	FOR XML PATH(''), TYPE).value('.[1]','nvarchar(max)'),1,1,''),

	descImporte = STUFF((SELECT '-' + CONVERT(VARCHAR(30), descripcion)
	FROM tblDetallePromociones
	WHERE ntraPromocion = t.ntraPromocion and flag in(2)
	FOR XML PATH(''), TYPE).value('.[1]','nvarchar(max)'),1,1,''),


	codProdPromoionado = STUFF((SELECT '-' + CONVERT(VARCHAR(12), valorInicial)
	FROM tblDetallePromociones
	WHERE ntraPromocion = t.ntraPromocion and flag in(3)
	FOR XML PATH(''), TYPE).value('.[1]','nvarchar(max)'),1,1,''),

	prodPromocionado = STUFF((SELECT '-' + CONVERT(VARCHAR(50), descripcion)
	FROM tblDetallePromociones
	WHERE ntraPromocion = t.ntraPromocion and flag in(3)
	FOR XML PATH(''), TYPE).value('.[1]','nvarchar(max)'),1,1,''),


	codVendedor = STUFF((SELECT '-' + CONVERT(VARCHAR(12), valorInicial)
	FROM tblDetallePromociones
	WHERE ntraPromocion = t.ntraPromocion and flag in(4)
	FOR XML PATH(''), TYPE).value('.[1]','nvarchar(max)'),1,1,''),

	vendedor = STUFF((SELECT '-' + CONVERT(VARCHAR(100), descripcion)
	FROM tblDetallePromociones
	WHERE ntraPromocion = t.ntraPromocion and flag in(4)
	FOR XML PATH(''), TYPE).value('.[1]','nvarchar(max)'),1,1,''),


	codPersona = STUFF((SELECT '-' + CONVERT(VARCHAR(12), valorInicial)
	FROM tblDetallePromociones
	WHERE ntraPromocion = t.ntraPromocion and flag in(5)
	FOR XML PATH(''), TYPE).value('.[1]','nvarchar(max)'),1,1,''),

	cliente = STUFF((SELECT '-' + CONVERT(VARCHAR(100), descripcion)
	FROM tblDetallePromociones
	WHERE ntraPromocion = t.ntraPromocion and flag in(5)
	FOR XML PATH(''), TYPE).value('.[1]','nvarchar(max)'),1,1,''),


	cantVecesUsarProm = STUFF((SELECT '-' + CONVERT(VARCHAR(12), valorInicial)
	FROM tblDetallePromociones
	WHERE ntraPromocion = t.ntraPromocion and flag in(6)
	FOR XML PATH(''), TYPE).value('.[1]','nvarchar(max)'),1,1,''),


	cantVecesUsarXvendedor = STUFF((SELECT '-' + CONVERT(VARCHAR(12), valorInicial)
	FROM tblDetallePromociones
	WHERE ntraPromocion = t.ntraPromocion and flag in(7)
	FOR XML PATH(''), TYPE).value('.[1]','nvarchar(max)'),1,1,''),

	vecesUsarXvendedor = STUFF((SELECT '-' + CONVERT(VARCHAR(20), descripcion)
	FROM tblDetallePromociones
	WHERE ntraPromocion = t.ntraPromocion and flag in(7)
	FOR XML PATH(''), TYPE).value('.[1]','nvarchar(max)'),1,1,''),


	cantVecesUsarXcliente = STUFF((SELECT '-' + CONVERT(VARCHAR(12), valorInicial)
	FROM tblDetallePromociones
	WHERE ntraPromocion = t.ntraPromocion and flag in(8)
	FOR XML PATH(''), TYPE).value('.[1]','nvarchar(max)'),1,1,''),

	vecesUsarXcliente = STUFF((SELECT '-' + CONVERT(VARCHAR(20), descripcion)
	FROM tblDetallePromociones
	WHERE ntraPromocion = t.ntraPromocion and flag in(8)
	FOR XML PATH(''), TYPE).value('.[1]','nvarchar(max)'),1,1,''),


	codTipoVenta = STUFF((SELECT '-' + CONVERT(VARCHAR(12), valorInicial)
	FROM tblDetallePromociones
	WHERE ntraPromocion = t.ntraPromocion and flag in(9)
	FOR XML PATH(''), TYPE).value('.[1]','nvarchar(max)'),1,1,''),

	TipoVenta = STUFF((SELECT '-' + CONVERT(VARCHAR(20), descripcion)
	FROM tblDetallePromociones
	WHERE ntraPromocion = t.ntraPromocion and flag in(9)
	FOR XML PATH(''), TYPE).value('.[1]','nvarchar(max)'),1,1,'')

	FROM tblPromociones  d 
	inner JOIN tblDetallePromociones AS t on d.ntraPromocion  = t.ntraPromocion
	INNER JOIN tblProducto pro on t.flag=1 and pro.codProducto = t.valorInicial
	inner join tblProveedor as prove on pro.codFabricante = prove.ntraProveedor

	inner join (select correlativo as estado, descripcion as estadoPromo  from tblConcepto where codConcepto = 24) as est on d.estado = est.estado

	where d.marcaBaja = 0


GO
IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'v_listar_usuario_login' AND type = 'V')
	DROP VIEW v_listar_usuario_login
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

----------------------------------------------------------------------------------
-- Author: Jeffrey Garcia
-- Created: 11/04/2020  
-- Sistema: WEB / LOGIN
-- DescripciÃ³n: Vista listar credenciales de usuario logueado
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[v_listar_usuario_login]
AS
	SELECT 	u.ntraUsuario as codusuario,u.users as usuario, u.[password] as [password],ps.codPersona as codpersona,p.descripcion as perfil,
			CONCAT(ps.nombres,' ',ps.apellidoPaterno,' ',ps.apellidoMaterno) as nombreCompleto ,
			c.descripcion as estadoUsuario,p.estado  as estadoPersona,ps.correo as correo,s.ntraSucursal as sucural,ps.telefono as telefono
			FROM tblUsuario as u
			inner join tblPerfil as p on u.codPerfil = p.codigo
			inner join tblPersona as ps on u.codPersona = ps.codPersona
			inner join tblConcepto as c on c.correlativo = u.estado
			inner join tblSucursal as s  on s.ntraSucursal = u.codSucursal
			WHERE	
				 u.marcaBaja = 0 and p.marcaBaja = 0
				and ps.marcaBaja = 0 and c.codConcepto = 14

GO
IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'v_modulos_detalle' AND type = 'V')
	DROP VIEW v_modulos_detalle
GO

----------------------------------------------------------------------------------
-- Author: Jeffrey Garcia
-- Created: 22/04/2020  
-- Sistema: WEB / BARRA DE NAVEGACION
-- Descripción: Vista listar modulos y detalle de modulos
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW v_modulos_detalle
AS
	SELECT modu.codModulo as 'codModulo' ,modu.descripcion as 'nomModulo',modu.orden as 'ordenModu',
		men.codMenu as 'codMenu',men.ruta as 'rutaMantenedor',men.descripcion as 'nomMantenedor', 
		men.orden as 'ordenMen',op.codResponsable as 'responsable',op.codPermiOpera as codPermiso,men.codModulo as codModuloM
		FROM tblModulo as modu 
		INNER JOIN tblMenu as men on modu.codModulo = men.codModulo
		INNER JOIN tblPermiOpera as op on op.codMenu = men.codMenu
		WHERE
		op.marcaBaja = 0 and men.marcaBaja = 0 and modu.marcaBaja = 0
		and men.estado = 1 AND modu.estado = 1; 


	GO


















