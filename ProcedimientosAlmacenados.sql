#PROCEDIMIENTOS ALMACENADOS

DELIMITER $$ -- Tambien puede usarse // como limitador
	CREATE PROCEDURE select_persona()
		BEGIN
			SELECT * FROM persona;
		END; $$
DELIMITER ;

#Una vez creado se llama así
CALL select_persona();


# Pruebas

-- Muestra los ususarios activos
DELIMITER //
	CREATE PROCEDURE select_persona_activa()
		BEGIN
			SELECT id_persona, nombre, apellido, telefono, email FROM persona WHERE status != 0;
		END; //
DELIMITER ;

CALL select_persona_activa();

-- Buscamos usuario por ID
DELIMITER //
	CREATE PROCEDURE select_id( id BIGINT )
		BEGIN
			SELECT id_persona, nombre, apellido, telefono, email FROM persona WHERE id_persona = id;
		END; //
DELIMITER ;

CALL select_id(2);

-- Buscamos personas por contenido en cualquier campo que estén activas
DELIMITER //
	CREATE PROCEDURE busca_persona( busqueda VARCHAR(100) )
		BEGIN
			SELECT id_persona, nombre, apellido, telefono, email FROM persona
            WHERE ( nombre LIKE CONCAT('%', busqueda, '%%') OR
            apellido LIKE CONCAT('%', busqueda, '%%') OR 
            telefono LIKE CONCAT('%', busqueda, '%%') OR 
            email LIKE CONCAT('%', busqueda, '%%') ) 
            AND status != 0;
		END; //
DELIMITER ;

CALL busca_persona('Sanchez');
CALL busca_persona(64);
CALL busca_persona('@');

-- Insertar registros si no existe el email
DELIMITER //
	CREATE PROCEDURE insert_persona( nom VARCHAR(100), ape VARCHAR(100), tel BIGINT, emailp VARCHAR(100))
		BEGIN
			DECLARE existe_persona INT;
            DECLARE id INT;
            SET existe_persona = (SELECT COUNT(*) FROM persona WHERE email = emailp);
            IF existe_persona = 0 THEN 
				INSERT INTO persona(nombre, apellido, telefono, email) VALUES (nom, ape, tel, emailp);
                SET id = LAST_INSERT_ID();
			ELSE 
				SET id = 0;
            END IF;
            SELECT id;
		END; //
 DELIMITER ;

CALL insert_persona('Ruben', 'Castillo', 684316984, 'ruben@info.com');

-- Actualizar registro si email no está en uso
DELIMITER //
	CREATE PROCEDURE update_persona(idp BIGINT, nom VARCHAR(100), ape VARCHAR(100), tel BIGINT, emailp VARCHAR(100))
		BEGIN
			DECLARE existe_persona INT;
            DECLARE existe_email INT;
            DECLARE id INT;
            SET existe_persona = (SELECT COUNT(*) FROM persona WHERE id_persona = idp);
            IF existe_persona > 0 THEN 
				SET existe_email = (SELECT COUNT(*) FROM persona WHERE email = emailp AND id_persona != idp);
                IF existe_email = 0 THEN
					UPDATE persona SET nombre=nom, apellido=ape, telefono=tel, email=emailp WHERE id_persona = idp;
                    SET id = idp;
                ELSE 
					SET id = 0;
                END IF;
			ELSE 
				SET id = 0;
            END IF;
            SELECT id;
		END; //
DELIMITER ;

CALL update_persona(1, 'Angel', 'Osh', 645789624, 'angel@info.es');
CALL update_persona(2, 'ooo', 'eee', 69, 'angel@info.es');

-- Eliminar registro
DELIMITER //
	CREATE PROCEDURE delete_persona(personaid BIGINT)
		BEGIN
			DECLARE existe_persona INT;
            DECLARE id INT;
            SET existe_persona = (SELECT COUNT(*) FROM persona WHERE id_persona = personaid);
            IF existe_persona > 0 THEN 
				DELETE FROM persona WHERE id_persona = personaid;
				SET id = 1;
			ELSE 
				SET id = 0;
            END IF;
            SELECT id;
		END; //
DELIMITER ;

CALL delete_persona(12);
CALL delete_persona(20);
