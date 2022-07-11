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


