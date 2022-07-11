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