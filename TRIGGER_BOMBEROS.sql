/*TRIGGER QUE NO PERMITA DAR UN NUEVO MANTENIMIENTO SI SE REALIZO UNO HACE 10 DIAS*/
CREATE OR REPLACE FUNCTION MANTENIMIENTO() RETURNS TRIGGER
AS 
$$ 
BEGIN
if(
	(SELECT 	
	MAX(MANTENIMIENTO.FECHA_MANTENIMIENTO)
	FROM MANTENIMIENTO
	INNER JOIN VEHICULO ON MANTENIMIENTO.ID_VEHICULO=VEHICULO.ID_VEHICULO
	WHERE VEHICULO.ID_VEHICULO=NEW.ID_VEHICULO
)-NEW.FECHA_MANTENIMIENTO <10) then
	DELETE FROM MANTENIMIENTO WHERE MANTENIMIENTO.ID_MANTENIMIENTO=NEW.ID_MANTENIMIENTO;
	RAISE NOTICE 'ESTE VEHICULO YA RECIBIO MANTENIMIENTO HACE MENOS DE 10 DIAS, NO SE REALIZA MANTENIMIENTO';
	END IF;
	RETURN NULL;
END;
$$
LANGUAGE 'plpgsql'

/*ASIGNAMOS EL PROCESO AL TRIGGER*/
CREATE TRIGGER INSERTAR_MANTENIMIENTO AFTER INSERT ON MANTENIMIENTO
FOR EACH ROW
EXECUTE PROCEDURE MANTENIMIENTO()

/*PROBAMOS EL TRIGGER*/
insert into MANTENIMIENTO values(6,1,1,1,'10/09/2020','Se realiza cambio de ruedas al vehiculo',500);

	