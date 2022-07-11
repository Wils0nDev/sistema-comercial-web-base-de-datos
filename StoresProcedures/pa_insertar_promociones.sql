IF EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_insertar_promociones' AND type = 'P')
DROP PROCEDURE pa_insertar_promociones
GO

----------------------------------------------------------------------------------
-- Author: KVASQUEZ IDE-SOLUTION
-- Created: 03/04/2020  
-- Sistema: ws_wa_DistribuidoraVDC
-- Descripción: Insertar Promociones
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[pa_insertar_promociones]
(
	@descripcion VARCHAR(100),
	@fechaInicial DATE,
	@fechaFin DATE,
	@horaInicial TIME(7),
	@horaFin TIME(7),
	@estado INT,

	@descripcion1 VARCHAR(100),
	@valorInicial1 VARCHAR(200),
	--@valorFinal1 VARCHAR(200),
	--@detalle1 TINYINT,
	--@estado1 TINYINT,

	@descripcion2 VARCHAR(100),
	@valorInicial2 VARCHAR(200),
	@valorFinal2 VARCHAR(200),
	--@detalle2 TINYINT,
	--@estado2 TINYINT,

	--@descripcion3 VARCHAR(100),
	--@valorInicial3 VARCHAR(200),
	--@valorFinal3 VARCHAR(200),
	--@detalle3 TINYINT,
	--@estado3 TINYINT,

	@descripcion4 VARCHAR(100),
	@valorInicial4 VARCHAR(200),
	--@valorFinal4 VARCHAR(200),
	--@detalle4 TINYINT,
	--@estado4 TINYINT,

	@descripcion5 VARCHAR(100),
	@valorInicial5 VARCHAR(200),
	--@valorFinal5 VARCHAR(200),
	--@detalle5 TINYINT,
	--@estado5 TINYINT,

	--@descripcion6 VARCHAR(100),
	@valorInicial6 VARCHAR(200),
	--@valorFinal6 VARCHAR(200),
	--@detalle6 TINYINT,
	--@estado6 TINYINT,

	--@descripcion7 VARCHAR(100),
	@valorInicial7 VARCHAR(200),
	--@valorFinal7 VARCHAR(200),
	--@detalle7 TINYINT,
	--@estado7 TINYINT,

	--@descripcion8 VARCHAR(100),
	@valorInicial8 VARCHAR(200),
	--@valorFinal8 VARCHAR(200),
	--@detalle8 TINYINT,
	--@estado8 TINYINT,

	@descripcion9 VARCHAR(100),
	@valorInicial9 VARCHAR(200),
	--@valorFinal9 VARCHAR(200),
	--@detalle9 TINYINT,
	--@estado9 TINYINT,

	@resultado INT OUTPUT
)

AS
	BEGIN
	DECLARE @ntraPromocion INT
	--DECLARE @descripcion2 VARCHAR(100)
	DECLARE @descripcion3 VARCHAR(100)
	DECLARE @descripcion6 VARCHAR(100) 
	DECLARE @descripcion7 VARCHAR(100)
	DECLARE @descripcion8 VARCHAR(100)

BEGIN TRY
	SET @ntraPromocion = 0
	--SET @descripcion2 = 'CANTIDAD O IMPORTE DEL PRODUCTO CON PROMOCION'
	SET @descripcion3 = 'PRODUCTO PROMOCIONADO'
	SET @descripcion6 = 'VECES VALIDAS PARA USAR LA PROMOCION'
	SET @descripcion7 = 'VECES VALIDAS QUE UN VENDEDOR PUEDE USAR LA PROMOCION'
	SET @descripcion8 = 'VECES VALIDAS QUE UN CLIENTE PUEDE USAR LA PROMOCION'


		BEGIN
			INSERT INTO tblPromociones
			(descripcion,fechaInicial,fechaFin,horaInicial,horaFin,estado,usuario)
			VALUES (@descripcion,@fechaInicial,@fechaFin,@horaInicial,@horaFin,@estado,'EAY');

			SELECT @ntraPromocion =  IDENT_CURRENT ('tblPromociones');
			
			INSERT INTO tblDetallePromociones
			(ntraPromocion,flag,descripcion, valorInicial, valorFinal, detalle, estado, usuario)
			VALUES (@ntraPromocion,1,@descripcion1,@valorInicial1,'',0,1,'EAY');

			INSERT INTO tblDetallePromociones
			(ntraPromocion,flag,descripcion, valorInicial, valorFinal, detalle, estado, usuario)
			VALUES (@ntraPromocion,2,@descripcion2,@valorInicial2,@valorFinal2,0,1,'EAY');

			INSERT INTO tblDetallePromociones
			(ntraPromocion,flag,descripcion, valorInicial, valorFinal, detalle, estado, usuario)
			VALUES (@ntraPromocion,3,@descripcion3,'','',1,1,'EAY');

			IF @valorInicial4 <> ''
				INSERT INTO tblDetallePromociones
				(ntraPromocion,flag,descripcion, valorInicial, valorFinal, detalle, estado, usuario)
				VALUES (@ntraPromocion,4,@descripcion4,@valorInicial4,'',0,1,'EAY');

			IF @valorInicial5 <> ''
				INSERT INTO tblDetallePromociones
				(ntraPromocion,flag,descripcion, valorInicial, valorFinal, detalle, estado, usuario)
				VALUES (@ntraPromocion,5,@descripcion5,@valorInicial5,'',0,1,'EAY');

			IF @valorInicial6 <> ''
				INSERT INTO tblDetallePromociones
				(ntraPromocion,flag,descripcion, valorInicial, valorFinal, detalle, estado, usuario)
				VALUES (@ntraPromocion,6,@descripcion6,@valorInicial6,'',0,1,'EAY');

			IF @valorInicial7 <> ''
				INSERT INTO tblDetallePromociones
				(ntraPromocion,flag,descripcion, valorInicial, valorFinal, detalle, estado, usuario)
				VALUES (@ntraPromocion,7,@descripcion7,@valorInicial7,'',0,1,'EAY');

			IF @valorInicial8 <> ''
				INSERT INTO tblDetallePromociones
				(ntraPromocion,flag,descripcion, valorInicial, valorFinal, detalle, estado, usuario)
				VALUES (@ntraPromocion,8,@descripcion8,@valorInicial8,'',0,1,'EAY');

			IF @valorInicial9 <> ''
				INSERT INTO tblDetallePromociones
				(ntraPromocion,flag,descripcion, valorInicial, valorFinal, detalle, estado, usuario)
				VALUES (@ntraPromocion,9,@descripcion9,@valorInicial9,'',0,1,'EAY');
			
			SELECT @resultado =  @ntraPromocion
		
		END
END TRY
BEGIN CATCH

		SELECT  
			ERROR_NUMBER() AS NumeroDeError   
            ,ERROR_STATE() AS NumeroDeEstado    
            ,ERROR_LINE() AS  NumeroDeLinea  
            ,ERROR_MESSAGE() AS MensajeDeError;  
END CATCH

END;



GO
