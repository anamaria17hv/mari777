-- =====================================================
-- BASE DE DATOS: Buscador de Menú del Día
-- Autora: Anamaria Hernandez Vasquez
-- Materia: Ingeniería de Software I
-- =====================================================

CREATE DATABASE IF NOT EXISTS menu_del_dia
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE menu_del_dia;

-- ─────────────────────────────────────────
-- TABLA: USUARIO
-- Almacena los usuarios del sistema.
-- Puede ser cliente (busca restaurantes)
-- o propietario (registra restaurante).
-- ─────────────────────────────────────────
CREATE TABLE USUARIO (
  id         INT          NOT NULL AUTO_INCREMENT,
  nombre     VARCHAR(100) NOT NULL,
  email      VARCHAR(150) NOT NULL UNIQUE,
  contrasena VARCHAR(255) NOT NULL,
  tipo       ENUM('cliente','restaurante') NOT NULL DEFAULT 'cliente',
  CONSTRAINT pk_usuario PRIMARY KEY (id)
);

-- ─────────────────────────────────────────
-- TABLA: RESTAURANTE
-- Cada restaurante está ligado a un usuario
-- de tipo 'restaurante'.
-- ─────────────────────────────────────────
CREATE TABLE RESTAURANTE (
  id          INT          NOT NULL AUTO_INCREMENT,
  usuario_id  INT          NOT NULL,
  nombre      VARCHAR(150) NOT NULL,
  direccion   VARCHAR(200) NOT NULL,
  telefono    VARCHAR(20),
  tipo_cocina VARCHAR(80),
  horario     VARCHAR(100),
  CONSTRAINT pk_restaurante  PRIMARY KEY (id),
  CONSTRAINT fk_rest_usuario FOREIGN KEY (usuario_id)
    REFERENCES USUARIO(id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

-- ─────────────────────────────────────────
-- TABLA: MENU_DEL_DIA
-- Un restaurante publica su menú cada día.
-- ─────────────────────────────────────────
CREATE TABLE MENU_DEL_DIA (
  id              INT            NOT NULL AUTO_INCREMENT,
  restaurante_id  INT            NOT NULL,
  fecha           DATE           NOT NULL,
  plato_principal VARCHAR(150)   NOT NULL,
  precio          DECIMAL(10,2)  NOT NULL,
  descripcion     TEXT,
  CONSTRAINT pk_menu       PRIMARY KEY (id),
  CONSTRAINT fk_menu_rest  FOREIGN KEY (restaurante_id)
    REFERENCES RESTAURANTE(id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

-- ─────────────────────────────────────────
-- TABLA: BUSQUEDA
-- Guarda cada búsqueda que hace un usuario.
-- ─────────────────────────────────────────
CREATE TABLE BUSQUEDA (
  id          INT            NOT NULL AUTO_INCREMENT,
  usuario_id  INT            NOT NULL,
  ubicacion   VARCHAR(200),
  tipo_comida VARCHAR(80),
  precio_max  DECIMAL(10,2),
  fecha_hora  DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT pk_busqueda      PRIMARY KEY (id),
  CONSTRAINT fk_busq_usuario  FOREIGN KEY (usuario_id)
    REFERENCES USUARIO(id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

-- ─────────────────────────────────────────
-- TABLA: RESULTADO
-- Relaciona una búsqueda con los
-- restaurantes que devuelve el sistema.
-- ─────────────────────────────────────────
CREATE TABLE RESULTADO (
  id              INT           NOT NULL AUTO_INCREMENT,
  busqueda_id     INT           NOT NULL,
  restaurante_id  INT           NOT NULL,
  distancia_km    DECIMAL(5,2),
  CONSTRAINT pk_resultado      PRIMARY KEY (id),
  CONSTRAINT fk_res_busqueda   FOREIGN KEY (busqueda_id)
    REFERENCES BUSQUEDA(id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT fk_res_restaurante FOREIGN KEY (restaurante_id)
    REFERENCES RESTAURANTE(id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

-- =====================================================
-- DATOS DE PRUEBA
-- =====================================================

INSERT INTO USUARIO (nombre, email, contrasena, tipo) VALUES
  ('Anamaria Hernandez', 'ana@correo.com', '1234', 'cliente'),
  ('Carlos Dueño',       'carlos@lacasita.com', '1234', 'restaurante'),
  ('Maria Lopez',        'maria@buensabor.com', '1234', 'restaurante');

INSERT INTO RESTAURANTE (usuario_id, nombre, direccion, telefono, tipo_cocina, horario) VALUES
  (2, 'Restaurante La Casita',    'Calle 45 #12-30, Chapinero', '+57 310 555 0011', 'Comida casera colombiana', 'Lunes a viernes 11:00am - 3:00pm'),
  (3, 'Restaurante El Buen Sabor','Carrera 7 #72-41, Chapinero','+57 311 444 0022', 'Comida casera colombiana', 'Lunes a viernes 11:00am - 3:00pm'),
  (2, 'Desayunos El Madrugador',  'Calle 72 #10-34, Chapinero', '+57 312 333 0033', 'Desayunos',                 'Lunes a viernes 6:00am - 11:00am');

INSERT INTO MENU_DEL_DIA (restaurante_id, fecha, plato_principal, precio, descripcion) VALUES
  (1, CURDATE(), 'Arroz con pollo',  12000.00, 'Sopa del día, arroz con pollo, ensalada fresca, jugo natural y postre'),
  (1, CURDATE(), 'Carne asada',      13500.00, 'Sopa del día, carne asada con papas criollas, ensalada, jugo y postre'),
  (2, CURDATE(), 'Bandeja paisa',    14000.00, 'Sopa, bandeja paisa completa, jugo y postre'),
  (3, CURDATE(), 'Desayuno completo', 7000.00, 'Huevos al gusto, arepa, chocolate caliente y fruta');

INSERT INTO BUSQUEDA (usuario_id, ubicacion, tipo_comida, precio_max) VALUES
  (1, 'Chapinero, Bogotá', 'Comida casera colombiana', 15000.00),
  (1, 'Chapinero, Bogotá', 'Desayunos', 10000.00);

INSERT INTO RESULTADO (busqueda_id, restaurante_id, distancia_km) VALUES
  (1, 1, 0.5),
  (1, 2, 0.8),
  (2, 3, 0.3);
