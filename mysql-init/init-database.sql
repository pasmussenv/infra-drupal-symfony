-- Crear base de datos de Symfony
CREATE DATABASE IF NOT EXISTS symfony_db;

-- Crear base de datos de Drupal
CREATE DATABASE IF NOT EXISTS drupal_db;

-- Crear usuario si no existe
CREATE USER IF NOT EXISTS 'ducks'@'%' IDENTIFIED BY 'ducks';

-- Dar permisos al usuario
GRANT ALL PRIVILEGES ON symfony_db.* TO 'ducks'@'%';
GRANT ALL PRIVILEGES ON drupal_db.* TO 'ducks'@'%';

-- Aplicar cambios
FLUSH PRIVILEGES;
