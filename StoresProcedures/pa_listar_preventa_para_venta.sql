IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_listar_preventa_para_venta' AND type = 'P')
	DROP PROCEDURE pa_listar_preventa_para_venta
GO

----------------------------------------------------------------------------------
-- Author: Wilmer Sanchez IDE-SOLUTION
-- Created: 16/03/2020  
-- Sistema: ws_wa_DistribuidoraVDC
-- Descripción: Traer lista de preventa 
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE dbo.pa_listar_preventa_para_venta
@ntraPreventa int, --numero de preventa
@codUsuario int,	--codigo del vendedor
@codCliente int,	--codigo del cliente
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
	select @diasMax = valorEntero2 from tblDetalleParametro where codParametro = 7;

	IF @fecha1 = '' and @fecha2 = ''
		BEGIN
			set @fecha2 = GETDATE()
			set @fecha1 = DATEADD(DAY,-@diasMax,@fecha2)
		END


	set @csql = 'select distinct ntraPreventa, codUsuario,vendedor,codCliente, cliente,tipoVenta, tVenta, tDoc, oVenta, estPre, fecha, fechaEntrega, recargo, igv, total,tipoMoneda,moneda,ntraSucursal,tipoDocumentoVenta,codPuntoEntrega' +
				' from v_preventa_filtros_web where estado = 1 '

	if @ntraPreventa != 0
		set @csql = @csql + ' and ntraPreventa = ' + convert(varchar, @ntraPreventa)
	if @codUsuario != 0
		set @csql = @csql + ' and codUsuario = ' + convert(varchar, @codUsuario)
	if @codCliente != 0
		set @csql = @csql + ' and codCliente = ' + convert(varchar, @codCliente)
	
	
	set @csql = @csql+' and fecha BETWEEN ''' + convert(varchar, @fecha1)+''''+' and '''+convert(varchar, @fecha2)+''''
			
	EXEC (@csql)

END

--exec pa_listar_preventa_para_venta 3258,0,0,'',''



