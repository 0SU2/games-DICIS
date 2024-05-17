# Created by: Alvarez Vazquez Luis Angel 
# Castillo Quintanilla Marco Antonio
# Cobian Ayala Mario Geovani
# Rosas Zavalas Oscar Ricardo 
# Date: 12-06-2023
# Definition: crear un sistema para controlar la información de un videojuego en 
# el cual hay usuarios que pueden seleccionar varios personajes, para los cuales pueden 
# comprar armas/accesorios para usar durante el juego


# -- Creacion de Base de Datos --- #
CREATE DATABASE IF NOT EXISTS games_db;

# --- Uso de Base de Datos --- #
USE games_db;


# --------- Tabla Independiente --------- #
# --- Tabla Independiente 1 --- # 
CREATE TABLE IF NOT EXISTS usuario
(
	# Declaracion de llave primaria natural 
    usu_username VARCHAR(60) NOT NULL, 
    usu_email VARCHAR(60) NOT NULL,
    usu_password VARCHAR(30) NOT NULL,
    usu_birthday DATE NOT NULL,
    usu_region ENUM ('Norte-America', 'Europa', 'Asia', 'Sur-America', 'Oceania', 'Centro-America', 'Medio-Oriente') NOT NULL,
    
    #Declaracion de llave primaria natural 
    PRIMARY KEY(usu_username), # Llave primaria natural, es una llave primaria porque es un nombre de usuario unico
								# ningun otro usuario puede tener el mismo username, con lo cual no hay 
								# redundancia de informacion.
                                
    # Creacion de atributos UNIQUE E INDEX 
    UNIQUE uni_email (usu_email),
    INDEX idx_reg (usu_region)
);

# --- Tabla Independiente 2 --- # 
CREATE TABLE IF NOT EXISTS arma
(
	# Declaracion de llave primaria natural 
    arm_name VARCHAR(30) NOT NULL,
    
    arm_type ENUM('Subfusil', 'Francotirador','Fusiles', 'Escopetas', 'Arma Pesada', 'Pistolas', 'Cuerpo a cuerpo') NOT NULL,
    arm_price INT NOT NULL,
    arm_speed INT NOT NULL,
    arm_cadences INT NOT NULL,
    arm_damage INT NOT NULL,
    arm_mags INT NOT NULL,
    
    # Declaracion de llave primaria natural 
    PRIMARY KEY(arm_name), # LLave primaria natural, es una llave primaria porque el nombre para cada arma es unico,
							# no pueden existir dos armas con el mismo nombre, por lo cual no hay redundancia de informacion
							# y caracteristicas del arma
    
    # Creacion de atributos UNIQUE E INDEX 
    INDEX idx_type (arm_type),
    INDEX idx_name_type (arm_name,arm_type),
    INDEX idx_type_speed_cadences_damage (arm_type,arm_speed, arm_cadences, arm_damage)
);

# --- Tabla Independiente 3 --- # 
CREATE TABLE IF NOT EXISTS accesorio
(
	# Declaracion de llave primaria natural
    acc_name VARCHAR(50) NOT NULL,
    
    acc_defenses DECIMAL(5,2) NOT NULL ,
    acc_body_part ENUM ('Cabeza','Torso','Pies', 'Piernas') NOT NULL,
    acc_price INT NOT NULL,
    
    # Declaracion de llave primaria natural
    PRIMARY KEY(acc_name), # Llave primaria natural, es una llave primaria porque el nombre de cada accesorio es unico 
							# no pueden existir dos accesorios con el mismo nombre, por lo cual no hay redundancia de informacion
    
    # Creacion de atributos UNIQUE E INDEX 
    INDEX idx_body (acc_body_part)
);

# --- Tabla Independiente 4 --- # 
CREATE TABLE IF NOT EXISTS personaje
(
	# Declaracion de llave primaria natural 
	per_name VARCHAR(60),
    
    # Atributos de la tabla 
    per_class ENUM('Controlador', 'Soporte', 'Tanque','Ataque','Medico') NOT NULL,
    per_health INT NOT NULL,
    per_armor INT NOT NULL,
    
    # Declaracion de llave primaria natural 
    PRIMARY KEY(per_name), # Llave primaria natural,es una llave primaria porque el nombre de cada personaje es unico y diferente 
							# no pueden existir dos personajes con el mismo nombre, por lo cual no hay redundancia de informacion
    
    # Creacion de atributos UNIQUE E INDEX 
    INDEX idx_class (per_class)
);

# --- Tabla dependiente 1 --- #
# La tabla asignacion depende de 
# la tabla usuario y personaje 
CREATE TABLE IF NOT EXISTS asignacion
(
	# Declaracion de llave primaria artificial
    asi_id INT NOT NULL AUTO_INCREMENT,
    
	# Llaves foraneas 
    asi_usu_username VARCHAR(60) NOT NULL,
    asi_per_name VARCHAR(60) NOT NULL, 
    
    # Atributos de la tabla
    asi_date_created DATE NOT NULL,
    asi_time_created TIME NOT NULL,
    
    # Declaracion de llave primaria artificial 
    PRIMARY KEY (asi_id), # Esta llave primaria permite llevar el conteo de cada vez que un usuario selecciona 
							# un personaje en especifico. Esto servira para asignar un armamento a cada personaje
                            # de un usuario 
    # Creacion de atributos UNIQUE E INDEX 
    INDEX idx_date (asi_date_created),
    # Permite que cada usuario tenga un personaje unico 
    UNIQUE uni_per_name_usu_username(asi_per_name,asi_usu_username),
    
    # Declaracion de llaves foraneas 
    
    # LLave foranea de tabla usuario
    # Esta llave foranea permite compartir informacion con la tabla usuario
    # Permite asignar uno o mas personajes al usuario
    CONSTRAINT fk_usuarios_asignacion
		FOREIGN KEY (asi_usu_username)
        REFERENCES usuario(usu_username)
        ON DELETE RESTRICT # Es de tipo RESTRICT, debido a que un usuario no puede ser eliminado de la base de datos 
        ON UPDATE RESTRICT, # si tiene personajes asignados, primero debe eliminar todos los personajes asociados con el
							# usuario
        
	# Llave foranea de tabla personaje
    # Esta llave foranea permite compartir informacion con la tabla personaje
    CONSTRAINT fk_personajes_asignacion
		FOREIGN KEY (asi_per_name)
        REFERENCES personaje(per_name)
		ON DELETE CASCADE # Es de tipo CASCADE, permitiendo eliminar los personajes asiciados con cada usuario
        ON UPDATE CASCADE # ademas de permitir eliminar el arsenal que tiene asociado 
);

# --- Tabla Dependiente 2 --- #
# La tabla billetera depende de la usuario 
CREATE TABLE IF NOT EXISTS billetera
(
	# Declaracion de llave primaria artificial 
    bil_id INT NOT NULL AUTO_INCREMENT,
    # Declaracion de llave foranea
    bil_usu_username VARCHAR(60) NOT NULL,
    
	# Atributos de la tabla 
    bil_amount DECIMAL(6,2) NOT NULL,
    
    # Declaracion de llave primaria artificial 
    PRIMARY KEY(bil_id), # Esta llave permite tener un conteo de todos los arsenales creados y asignados para 
						 # el usuario, permitiendo no tener arsenales duplicados.
    
    # LLave foranea de tabla usuario 
    # Esta llave foranea permite compartir datos con la tabla usuario 
    # para identificar que billetera esta asocida con cada usuario 
    CONSTRAINT fk_usuarios_billetera
		FOREIGN KEY (bil_usu_username)
        REFERENCES usuario(usu_username)
        ON DELETE CASCADE # Es de tipo CASCADE, permite eliminar la billetera del usuario 
        ON UPDATE CASCADE # si este es eliminado de la base de datos para evitar la sobrecarga de informacion.
);

# --- Tabla dependiente 3 --- #
# La tabla arsenal depende de la tabla 
# asignacion, arma y accesorio 
CREATE TABLE IF NOT EXISTS arsenal
(
	# Declaracion de llave primaria artificial 
    ars_id INT NOT NULL AUTO_INCREMENT,
    
	# Declaracion de llaves foraneas 
    ars_asi_id INT NOT NULL,
    ars_arm_name VARCHAR(30) NOT NULL,
    ars_acc_name VARCHAR(50),
    
    # Atributos de la tabla 
    ars_date_created  DATETIME NOT NULL,
    ars_buy DECIMAL(6,2) NOT NULL,
    
    # Creacion de atributos UNIQUE E INDEX 
    INDEX idx_date (ars_date_created),
    UNIQUE uni_asi_id_arm_name_acc_name(ars_asi_id,ars_arm_name,ars_acc_name),
    
    # Declaracion de llave primaria artificial 
    PRIMARY KEY(ars_id), # Esta llave primaria artifical permite llevar un conteo de cada arsenal creado 
						# incluyendo a que usuario, que accesorios y armas fueron asignadas al personaje.

    # Llave forenea de tabla asignacion 
    # Esta llave foranea permite compartir datos con la tabla asignacion 
    # para identificar a que usuario y personaje seran asignados los datos 
    CONSTRAINT fk_asignacion_arsenal
		FOREIGN KEY (ars_asi_id)
        REFERENCES asignacion(asi_id)
        ON DELETE CASCADE # Es de tipo CASCADE, si una asignacion se elimina tambien el arsenal asociado
        ON UPDATE CASCADE, # con ese usuario o personaje 
        
	# LLave foranea de tabla arma 
    # Esta llave foranea permite compartir datos con la tabla arma
    # para identificar que armas seran asociadas con cada arsenal 
	CONSTRAINT fk_armas_arsenal
		FOREIGN KEY (ars_arm_name)
		REFERENCES arma(arm_name)
        ON DELETE CASCADE # Es de tipo CASCADE, si se elimina un arma, se eliminan tambien los arsenales
        ON UPDATE CASCADE, # asociados con esa arma en particular 
        
	# Llave foranea de tabla accesorio
    # Esta llave foranea permite compartir datos con la tabla accesorio
    # para identificar que accesorios seran asociados con cada arsenal 
    CONSTRAINT fk_accesorios_arsenal
		FOREIGN KEY (ars_acc_name)
        REFERENCES accesorio(acc_name)
        ON DELETE CASCADE # Es de tipo CASCADE, si se elimina un accesorio, se elimina tambien de los arsenales 
        ON UPDATE CASCADE # asociados con ese accesorio, sin embargo, el registro del arsenal continua
);

# --- Tabla Dependiente 5 --- #
# La tabla transaccion depende de la tabla 
# arsenal y billetera 

# Esta tabla tiene como objetivo llevar un control para las compras
# que realice el usuario y poder devolver o descontar el dinero 
CREATE TABLE IF NOT EXISTS transaccion
(
    # Declaracion de llaves foraneas y primarias 
    tra_ars_id INT NOT NULL,
    tra_bil_id INT NOT NULL,
    
    # Atributos de la tabla 
    tra_buy_date DATE NOT NULL,
    
    # Creacion de atributos UNIQUE E INDEX 
    INDEX idx_buy_date (tra_buy_date),
    
    # Declaracion de llaves primarias compuestas 
    PRIMARY KEY(tra_ars_id,tra_bil_id), # Se implementan las mismas llaves foraneas como primarias, debido a que 
										# la tabla transaccion solo sirve para compartir datos entre dos tablas 
    
    # LLave foranea de tabla transaccion 
    # Esta llave foranea permite compartir informacion con la tabla billetera
    # para identificar que billetera de usuario esta asociada 
    CONSTRAINT fk_billetera_transaccion
		FOREIGN KEY (tra_ars_id)
        REFERENCES billetera(bil_id)
        ON DELETE CASCADE # Es de tipo CASCADE, si se elimina la billetera del usuario 
        ON UPDATE CASCADE, # se elimina el registro de transaccion, permitiendo la sobrecarga de informacion
							# para una billetera que ya no existe 
        
	# Llave foranea de tabla arsenal 
    # Esta llave foranea permite compartir informacion con la tabla arsenal 
    # para identificar que arsenal y precio total del usuario tiene asociada 
    CONSTRAINT fk_ars_transaccion
		FOREIGN KEY (tra_ars_id)
        REFERENCES arsenal(ars_id)
        ON DELETE CASCADE # Es de tipo CASCADE, si se elimina el arsenal del usuario para un personaje 
        ON UPDATE CASCADE # esto permite regresar el dinero y eliminar el registro de la transaccion 
							# para no tener sobrecarga de informacion
);

												# --- Insercion de Datos -- #
# --- usuario--- #                                                    
INSERT INTO usuario (usu_username, usu_email, usu_password, usu_birthday, usu_region)
	VALUES('TheKiller20', 'mataviejitas3000@hotmail.com', '1234', '2023-06-14', 'Europa'),
			('TheHereticBoy', 'five5atfreddy@hotmail.com', '1234', '2023-03-19', 'Oceania'),
            ('Faireh', 'megustaelzumo@hotmail.com', '8970', '2023-12-06', 'Medio-Oriente'),
            ('Monkey', 'paquitaDelBarrio@hotmail.com', '1234567','2023-02-05', 'Oceania');
            
# --- arma --- #
INSERT INTO arma(arm_name, arm_type, arm_price, arm_speed, arm_cadences, arm_damage, arm_mags)
	VALUES ('Vandal', 'Fusiles', 290, 70, 50, 90, 30),
			('Kar-98', 'Francotirador', 350, 50, 30, 200, 5),
            ('UZI', 'Subfusil', 190, 90, 100, 180, 20),
            ('M4', 'Fusiles', 250, 60, 80, 80, 30);

# --- accesorio --- #
INSERT INTO accesorio(acc_name, acc_defenses, acc_body_part, acc_price)
	VALUES ('Lentes de sol', 0, 'Cabeza', 140),
			('Cachucha', 0, 'Cabeza', 200),
            ('Chaleco III', 50, 'Torso', 400),
            ('Botas Rancheras', 5, 'Pies', 200);

# --- personaje --- #
INSERT INTO personaje(per_name, per_class, per_health, per_armor)
	VALUES ('Kick', 'Controlador', 150, 50),
			('Max', 'Soporte', 130, 40),
            ('Sage', 'Medico', 120, 50),
            ('Willy Wonka', 'Tanque', 160, 20);
            
# --- asignacion--- #
INSERT INTO asignacion(asi_usu_username, asi_per_name, asi_date_created,asi_time_created)
	VALUES ('TheKiller20', 'Kick', '2023-01-01','12:00:00'),
			('TheKiller20', 'Max', '2023-02-23','14:30:00'),
            ('TheHereticBoy', 'Willy Wonka', '2023-04-12','13:20:00'),
            ('TheHereticBoy', 'Max', '2023-08-30','15:00:00'),
            ('Monkey','Sage','2023-05-23','09:00:00'),
			('Monkey','Kick','2023-05-23','08:00:00');
            
# --- billetera --- #
INSERT INTO billetera(bil_usu_username, bil_amount)
	VALUES('TheKiller20', 1000.00),
			('TheHereticBoy', 1000.00),
            ('Monkey', 1000.00),
            ('Faireh', 1000.00);
            
# --- arsenal --- #
INSERT INTO arsenal (ars_asi_id, ars_arm_name, ars_acc_name, ars_date_created, ars_buy)
	VALUES	('1', 'Vandal', 'Lentes de sol', '2023-12-05 11:45:21', 430),
			('3', 'Kar-98', NULL ,'2023-04-07 15:30:28', 350),
            ('2', 'UZI', NULL, '2023-04-13 07:15:21', 190),
            ('1', 'M4', 'Chaleco III', '2023-02-16 19:40:00', 650);
            
# --- transaccion --- #
INSERT INTO transaccion (tra_ars_id, tra_bil_id, tra_buy_date)
	VALUES (1, 1, '2023-05-23'),
			(1, 2, '2023-08-13'),
            (2, 3, '2023-09-19'),
            (3, 4, '2023-10-15');




