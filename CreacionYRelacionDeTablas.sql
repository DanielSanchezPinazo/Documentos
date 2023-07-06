CREATE DATABASE cursoStoredProcedures;
USE cursoStoredProcedures;

CREATE TABLE persona(
    `id_persona` BIGINT(20) NOT NULL AUTO_INCREMENT,
    `nombre` VARCHAR(100) NOT NULL,
    `apellido` VARCHAR(100) NOT NULL,
    `telefono` BIGINT(20) NOT NULL,
    `email` VARCHAR(100) NOT NULL,
    `datecreated` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `status` VARCHAR(20) NOT NULL,
    PRIMARY KEY (`id_persona`)
) ENGINE = InnoDB;

CREATE TABLE tarea(
    `idtarea` BIGINT(20) NOT NULL AUTO_INCREMENT,
    `nombretarea` VARCHAR(100) NOT NULL,
    `descripcion` TEXT NOT NULL,
    `fecha_inicio` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, #Establece por defecto la fecha y hora actual
    `fecha_fin` DATETIME DEFAULT NULL,
    `personaid` BIGINT(20) NOT NULL,
    `status` VARCHAR(20) NOT NULL,
    PRIMARY KEY (`idtarea`)
    #FOREIGN KEY(`personaid`) REFERENCES persona(`id_persona`)
)ENGINE = InnoDB;

# Hacemos que si se borra el `id_persona` de alguna persona se borren todas sus tareas
ALTER TABLE tarea
ADD CONSTRAINT `tarea_persona_fk` FOREIGN KEY (`personaid`) REFERENCES `persona` (`id_persona`) ON DELETE CASCADE ON UPDATE CASCADE;

# Cambiamos el nombre de un campo pero debemos especificar el resto de datos tambien
ALTER TABLE tarea CHANGE `personaid` `persona_id` BIGINT(20) NOT NULL;

# Borra la realcion entre las tablas.
ALTER TABLE tarea DROP FOREIGN KEY tarea_persona_fk;

# Modificamos el campo `status` para que guarde una especia de booleano que es 0/1 para indicar si la persona esta eliminada/no
ALTER TABLE persona MODIFY COLUMN `status` INT(1);

# Modificamos el campo `status` para que guarde por defecto el valor 1, que equivaldrá a que la persona está activa
ALTER TABLE persona ALTER COLUMN `status` SET DEFAULT '1';

# Renombrar tabla
RENAME TABLE tarea TO actividad;
RENAME TABLE actividad TO tarea;

# Borrar tabla o Base de datos
DROP TABLE tarea;
DROP DATABASE cursostoredprocedures;

# Insertamos datros en los campos de las tablas
INSERT persona(nombre, apellido, telefono, email, datecreated, status) VALUES ('Abel','Osh', 645789624, 'infoabel@osh.com', '2023-05-29', 0);
INSERT persona(nombre, apellido, telefono, email) VALUES ('Daniel','Sanchez', 661448236, 'daniel@infosanchez.com');
INSERT persona(nombre, apellido, telefono, email) VALUES ('Alejandro','Gonzalez', 648215695, 'alejandro@info.com');
INSERT persona(nombre, apellido, telefono, email) VALUES ('Antonio','Fernandez', 648215625, 'antonio@info.com');
INSERT persona(nombre, apellido, telefono, email, datecreated, status) VALUES ('Sebastian','Sanchez', 689624531, 'sebastian@info.com', '2022-09-16', 1);

INSERT tarea(nombretarea, descripcion, fecha_inicio, fecha_fin, persona_id, status) VALUES('Diagrama Procesos','Crear diagrama de flujos de los procesos', '2023-04-20', '2023-08-25', 1, 'Finalizado');
INSERT tarea(nombretarea, descripcion, fecha_inicio, persona_id, status) VALUES('Maquetar Web','Maquetar con HTML y CSS', '2023-08-26', 2, 'Activo');

# Mostramos selecciones de tabla
SELECT * FROM persona;
SELECT id_persona, nomebre, apellido FROM persona;

-- WHERE
SELECT * FROM person WHERE id_persona = 1;
SELECT * FROM person WHERE apellido = 'Sanchez';

-- COUNT
SELECT COUNT(*) AS total FROM persona;
SELECT COUNT(*) AS total FROM persona WHERE apellido = 'Sanchez';

-- CONCAT
SELECT *, concat(nombre, apellido) AS nombre_completo
FROM persona;

-- CAST, ::
SELECT CAST(telefono AS VARCHAR) FROM persona;
SELECT CAST(telefono AS VARCHAR(9)) FROM persona; -- Hace lo mismo que el de arriba
SELECT telefono::VARCHAR(9)) FROM persona; -- Hace lo mismo que el de arriba en POSTGRESQL
SELECT CAST(telefono AS BIGINT(20)) FROM persona;
SELECT CAST('2017-08-25' AS datetime);

-- CONVERT (igual que CAST)
SELECT CONVERT(telefono, VARCHAR) FROM persona;

-- AGE (devuelve la diferencia entre 2 fechas - en POSTGRESQL)
SELECT AGE(fecha_fin, fecha_inicio) AS duracion
FROM tarea;

-- DATEDIFF (devuelve la diferencia entre 2 fechas, al contrario que en POSTGRESQL sí tiene en cuenta las fechas completas- en MSSMS)
SELECT *, DATEDIFF(YEAR, fecha_inicio, fecha_fin) AS duracion FROM tarea;
SELECT *, DATEDIFF(MONTH, fecha_inicio, fecha_fin) AS duracion FROM tarea;
SELECT *, DATEDIFF(DAY, fecha_inicio, fecha_fin) AS duracion FROM tarea;
    
-- DATE_PART / DATEPART (selecciona sólo una parte de la fecha)
SELECT *, DATE_PART('month', fecha_inicio) - DATE_PART('month', fecha_fin) AS meses_duracion FROM tarea;-- en POSTGRESQL
SELECT *, DATEPART('year', fecha_inicio) - DATEPART('year', fecha_fin) AS anos_duracion FROM tarea;-- en MSSMS

--TO_DATE
SELECT to_date(CAST(fecha_inicio AS VARCHAR), 'yyyy-mm-dd') FROM tarea; 
-- Esto realmente es absurdo porque transforma la fecha en VARCHAR para después devolverlo a fecha en POSTGRESQL

-- ORDER BY
SELECT * FROM persona ORDER BY id_persona;
SELECT * FROM persona ORDER BY nombre DESC; -- ASC
SELECT * FROM persona WHERE STATUS = 1 ORDER BY nombre, apellido;

-- != , > , < 
SELECT * FROM persona WHERE STATUS != 0;
SELECT * FROM persona WHERE datecreated > '2022-10-31';
SELECT * FROM persona WHERE datecreated < '2023-06-29' AND datecreated > '2023-05-29';

-- BETWEEN, LIKE, DAY, MONTH, YEAR, _
SELECT * FROM persona WHERE datecreated BETWEEN '2023-05-29' AND '2023-05-31';
SELECT * FROM persona WHERE datecreated LIKE '2023-05-30%';
SELECT * FROM persona WHERE telefono LIKE '6________'; -- Busca todos los teléfonos que empiezan por 6 y le siguen 8 carácteres
SELECT * FROM persona WHERE telefono LIKE '6%';
SELECT * FROM persona WHERE telefono LIKE '64%'; -- Busca de izqda a dcha
SELECT * FROM persona WHERE apellido LIKE '%ez'; -- Busca de dcha a izqda
SELECT * FROM persona WHERE apellido LIKE '%an%'; -- Busca por TODO el campo, donde hay "an" en cualquier parte, CENTRO, PRINCIPIO O FINAL
SELECT * FROM persona WHERE DAY(datecreated) = 30;
SELECT * FROM persona WHERE DAY(datecreated) = 30 AND MONTH(datecreated) = 05 AND YEAR(datecreated) = 2023;

-- OR / AND
SELECT * FROM persona WHERE apellido = 'Sanchez' OR telefono = 648215695;
SELECT * FROM persona WHERE apellido = 'Sanchez' AND telefono LIKE 66________;

-- UPPER Y LOWER (SQL es CASE SENSITIVE)
SELECT * FROM persona WHERE LOWER(apellido) = 'sanchez'; -- Transforma el valor de cada apellido en minúsculas para compararlo
SELECT * FROM persona WHERE UPPER(apellido) LIKE = 'SANC'; -- Transforma el valor de cada apellido en mayúsculas para compararlo

-- IS NULL / NOT  NULL
SELECT * FROM tarea WHERE fecha_fin IS NULL;
SELECT * FROM tarea WHERE fecha_fin IS NOT NULL;

-- IN (para buscar más de una cadena en un campo)
SELECT * FROM persona WHERE apellido IN('Sanchez', 'Gonzalez');
SELECT * FROM persona WHERE telefono IN(689624531, 648215625);

-- LIMIT (duvuelve la cantidad de resultados que le marcamos / siempre es la última sentencia)
SELECT * FROM persona LIMIT 3;
SELECT * FROM persona WHERE STATUS != 0 ORDER BY id_persona DESC LIMIT 2;
SELECT * FROM persona LIMIT 0,3; -- Muestra los 3 primeros registros a partir de la posición 0(incluida), que es el primer registro

-- LENGTH (muestra la longitud del campo que indiquemos)
SELECT nombre, length(nombre) FROM persona;

-- LEFT, RIGHT (muestra las tres primeras o últimas letras del nombre)
SELECT nombre, LEFT(nombre, 3) FROM persona;
SELECT nombre, RIGHT(nombre, 3) FROM persona;

-- REVERSE (muestra el campo invertido)
SELECT nombre, REVERSE(nombre) FROM persona; 

#Actualizar registros de una tabla
UPDATE persona SET nombre = 'Carlos' WHERE id_persona = 1;
UPDATE persona SET nombre = 'Abel' WHERE id_persona = 1;
UPDATE persona SET status = 0 WHERE id_persona IN(3, 4);
UPDATE persona SET status = 1 WHERE id_persona IN(3, 4);

#Borra el registro de la tabla "persona" cuyo id_persona es 1
DELETE FROM `persona` WHERE `persona`.`id_persona` = 1;
DELETE FROM persona WHERE persona.id_persona = 1;

-- INNER JOIN
SELECT pr.id_persona, pr.nombre, pr.apellido, pr.telefono, tr.idtarea, tr.nombretarea, tr.fecha_inicio, tr.fecha_fin, tr.status
FROM persona pr INNER JOIN tarea tr 
ON pr.id_persona = tr.persona_id
/* WHERE tr.status = 'Finalizado'*/;

-- LEFT JOIN
SELECT pr.id_persona, pr.nombre, pr.apellido, pr.telefono, tr.idtarea, tr.nombretarea, tr.fecha_inicio, tr.fecha_fin, tr.status
FROM persona pr LEFT JOIN tarea tr 
ON pr.id_persona = tr.persona_id
/* WHERE tr.status = 'Finalizado'*/;

-- RIGHT JOIN
SELECT pr.id_persona, pr.nombre, pr.apellido, pr.telefono, tr.idtarea, tr.nombretarea, tr.fecha_inicio, tr.fecha_fin, tr.status
FROM persona pr RIGHT JOIN tarea tr 
ON pr.id_persona = tr.persona_id
/* WHERE tr.status = 'Finalizado'*/;


