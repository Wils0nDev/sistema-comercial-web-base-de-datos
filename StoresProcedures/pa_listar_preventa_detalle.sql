IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_listar_preventa_detalle' AND type = 'P')
	DROP PROCEDURE pa_listar_preventa_detalle
GO
----------------------------------------------------------------------------------
-- Author: Diego Sanchez IDE-SOLUTION
-- Created: 15/03/2020  
-- Sistema: Sistema Distribuidora Virgen del Carmen.
-- Descripción: Traer lista de detale de la preventa
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[pa_listar_preventa_detalle]
@npreventa int
as
begin
select  dpre.itemPreventa as item, dpre.codProducto,pro.descripcion, dpre.cantidadPresentacion as cantidad,dpre.cantidadUnidadBase,
alm.descripcion as descAlmacen, dpre.codAlmacen, unb.descripcion as um, dpre.codPresentacion as codUnidad, 
tpr.descripcion as tipo, dpre.TipoProducto as codTipo, dpre.precioVenta as precio, ISNULL(dpd.importe,0) as descuento, 
ISNULL(dpd.codDescuento,0) as codDec, ISNULL(dpp.codPromocion,0) as codPro,  ISNULL(dto.descripcion,'') as descrDesc,
ISNULL(pmo.descripcion,'') as descrPro, ISNULL(detpro.valorInicial,'') as codProdPrincipal, 
ISNULL(dpp.itemPreventa,0) as itempreventa
from tblDetallePreventa dpre
inner join tblProducto pro on pro.codProducto = dpre.codProducto
left join tblPreventaDescuento dpd on dpd.codPreventa = dpre.codPreventa and dpd.itemPreventa = dpre.itemPreventa
left join tblDescuentos dto on dto.ntraDescuento = dpd.codDescuento
left join tblPreventaPromocion dpp on dpp.codPreventa = dpre.codPreventa and dpp.itemPromocionado = dpre.itemPreventa
left join tblPromociones pmo on pmo.ntraPromocion = dpp.codPromocion
left join tblDetallePromociones detpro on detpro.ntraPromocion = pmo.ntraPromocion and detpro.flag=1
inner join tblAlmacen alm on dpre.codAlmacen=alm.ntraAlmacen
inner join (select correlativo, descripcion from tblConcepto where codConcepto = 12 and marcaBaja = 0)
as unb on dpre.codPresentacion = unb.correlativo
inner join (select correlativo, descripcion from tblConcepto where codConcepto = 22 and marcaBaja = 0)
as tpr on dpre.TipoProducto = tpr.correlativo
where dpre.codPreventa = @npreventa  and dpre.marcaBaja = 0
order by dpre.itemPreventa;
end

