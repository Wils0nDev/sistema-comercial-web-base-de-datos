IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_listar_preventa_filtros' AND type = 'P')
	DROP PROCEDURE pa_listar_preventa_filtros
GO
----------------------------------------------------------------------------------
-- Author: Diego Sanchez IDE-SOLUTION
-- Created: 10/03/2020  
-- Sistema: Sistema Distribuidora Virgen del Carmen.
-- Descripción: Traer lista de preventa por filtros
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[pa_listar_preventa_filtros]
@ntraPreventa int, --numero de preventa
@codUsuario int,	--codigo del vendedor
@codCliente int,	--codigo del cliente
@estado int,	--estado de la preventa
@codTipo_venta int,	--codigo tipo de venta
@codTipo_doc int,	--codigo tipo de venta
@codOrigen_venta int, --codigo origen de venta
@codRuta int, --codigo de ruta
@codProveedor int, --codigo del proveedor
@codProducto varchar(10),--sku del producto
@codfechaEntregaI date,	--fecha de entrega inicial
@codfechaEntregaF date,	--fecha de entrega final
@codfechaRegistroI date,	--fecha de registro inicial
@codfechaRegistroF date		--fecha de registro final

AS
BEGIN
	declare @csql nvarchar(1000) --consulta sql
	declare @diasMax int	--dias maximo
	declare @fecha1 date
	declare @fecha2 date
	set @fecha1 = @codfechaRegistroI
	set @fecha2 = @codfechaRegistroF
	select @diasMax = valorEntero1 from tblDetalleParametro where codParametro = 7;

	if @fecha1 = '' and @fecha2 = ''
	begin
		set @fecha2 = GETDATE()
		set @fecha1 = DATEADD(DAY,-@diasMax,@fecha2)
	end


	set @csql = 'select distinct ntraPreventa, vendedor, tipoPersona, cliente, identificacion, ruta, direccion, tVenta, tDoc, oVenta, estPre, fecha, fechaEntrega,'+
				' recargo, igv, moneda, total, estado, sucursal, codUbigeo, codUsuario, codCliente, codPuntoEntrega from v_preventa_filtros_web where 1=1 '

	if @ntraPreventa != 0
		set @csql = @csql + ' and ntraPreventa = ' + convert(varchar, @ntraPreventa)
	if @codUsuario != 0
		set @csql = @csql + ' and codUsuario = ' + convert(varchar, @codUsuario)
	if @codCliente != 0
		set @csql = @csql + ' and codCliente = ' + convert(varchar, @codCliente)
	if @estado != 0
		set @csql = @csql + ' and estado = ' + convert(varchar, @estado)
	if @codTipo_venta != 0
		set @csql = @csql + ' and tipoVenta = ' + convert(varchar, @codTipo_venta)
	if @codTipo_doc != 0
		set @csql = @csql + ' and tipoDocumentoVenta = ' + convert(varchar, @codTipo_doc)
	if @codOrigen_venta != 0
		set @csql = @csql + ' and origenVenta = ' + convert(varchar, @codOrigen_venta)
	if @codRuta != 0
		set @csql = @csql + ' and ntraRutas = ' + convert(varchar, @codRuta)
	if @codProveedor != 0
		set @csql = @csql + ' and codProveedor = ' + convert(varchar, @codProveedor)
	if @codProducto != ''
		set @csql = @csql + ' and codProducto = ''' + convert(varchar, @codProducto) + ''''
	if @fecha1 != '' and @fecha2 != ''
		set @csql = @csql+' and fecha BETWEEN ''' + convert(varchar, @fecha1)+''''+' and '''+convert(varchar, @fecha2)+''''
	if @codfechaEntregaI != '' and @codfechaEntregaF != ''
		set @csql = @csql+' and fechaEntrega BETWEEN ''' + convert(varchar, @codfechaEntregaI)+''''+' and '''+convert(varchar, @codfechaEntregaF)+''''
			
	EXEC (@csql)
	--select @csql

END
