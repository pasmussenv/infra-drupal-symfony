#  Infraestructura DevOps Symfony + Drupal

Proyecto que integra Symfony 7, Drupal 11, MySQL 8 y Nginx 1.25, todo orquestado con Docker Compose.

---


## 📁 Estructura del Proyecto

```plaintext
proyecto-drupal-symfony/
├── drupal/                      # Drupal 11
│   ├── composer.json            # Composer para Drupal
│   ├── .env.example             # Variables de entorno de desarrollo
│   ├── .env.prod                # Variables de entorno de producción
│   └── web/                     # Carpeta pública de Drupal
│       └── sites/default/
│           ├── settings.php
│           ├── services.yml
│           └── files/           # Carpeta para archivos subidos
├── symfony/                     # Symfony 7 (estructura habitual)
│   ├── .env                     # Variables de entorno de desarrollo
│   ├── .env.prod                # Variables de entorno de producción
│   └── src/
│       └── Controller/
│           └── DefaultController.php
├── php/
│   ├── drupal/
│   │   ├── Dockerfile           # Dockerfile para desarrollo
│   │   ├── Dockerfile.prod      # Dockerfile para producción
│   │   └── opcache.ini          # Configuración de OPCache
│   └── symfony/
│       ├── Dockerfile           # Dockerfile para desarrollo
│       ├── Dockerfile.prod      # Dockerfile para producción
│       └── opcache.ini          # Configuración de OPCache
├── mysql-init/
│   └── init-database.sql        # Script de inicialización de MySQL
├── nginx/
│   ├── default.conf             # Configuración de Nginx para dev
│   ├── default.prod.conf        # Configuración de Nginx para prod
│   └── certs/                   # Certificados SSL (vacía por defecto)
├── .env.example                 # Ejemplo variables de entorno
├── .env.prod                    # Variables de entorno generales (prod)
├── .env                         # Variables de entorno generales (dev)
├── .gitignore
├── docker-compose.yml           # Composición de servicios (dev)
└── docker-compose.prod.yml      # Composición de servicios (prod)
```
---

## 🚀 Cómo levantar el proyecto en desarrollo

### 1. Clonar el repositorio

```bash
git clone git@github.com:pasmussenv/infra-drupal-symfony.git
```

### 2. Crear archivos `.env` con las variables de entorno

El proyecto viene con archivos `.env.example` que debes copiar para crear los archivos reales de configuración. Esto es importante para que Docker, Symfony y Drupal funcionen correctamente.

📄 Copiar los archivos de ejemplo:

```bash
cp .env.example .env
cp symfony/.env.example symfony/.env
```

Esto genera los archivos `.env` reales, donde Docker y las aplicaciones leerán las variables necesarias.

#### 📌 ¿Qué contienen los `.env.example`?

##### `.env.example` (raíz del proyecto):

```env
# Variables MySQL para Docker
MYSQL_ROOT_PASSWORD=ducks
MYSQL_USER=ducks
MYSQL_PASSWORD=ducks

# Variables Drupal
DB_HOST=mysql
DB_NAME=drupal_db
DB_USER=ducks
DB_PASSWORD=ducks
```

##### `symfony/.env.example`:

```env
APP_ENV=prod
APP_DEBUG=0
APP_SECRET=123456789abcdefgh
DATABASE_URL="mysql://ducks:ducks@mysql:3306/symfony_db"
```

> ⚠️ **Importante:** NO edites directamente los `.env.example`.  
> Crea los archivos `.env` como se explicó arriba y personalízalos si es necesario.

---

### 3. Instalación de dependencias si se instala Drupal por primera vez

Instala estas extensiones PHP necesarias:

```bash
sudo apt update
sudo apt install curl php-cli unzip -y
sudo apt install php8.3-xml php8.3-gd php8.3-mbstring php8.3-zip php8.3-curl php8.3-mysql -y
```

### 4. Instalar Composer si aún no lo tienes

```bash
cd ~
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer
```

---

### 🧩 ¿Tengo que instalar Drupal?

> El proyecto **ya viene con Drupal instalado y configurado**, listo para funcionar en cuanto levantas los contenedores.

Solo necesitas instalar Drupal manualmente (paso 4) si vas a reutilizar esta infraestructura para otro proyecto diferente o estás creando un entorno nuevo desde cero y no tienes la carpeta `drupal/` ya preparada.

---

### 5. Instalar Drupal si no está instalado (opcional)

```bash
cd drupal
composer create-project drupal/recommended-project .
```

---

### 6. Configuración inicial de permisos en Drupal

```bash
cd drupal/web/sites/default
cp default.settings.php settings.php
cp default.services.yml services.yml
mkdir files
chmod -R 755 files
```

Esto permite que el instalador de Drupal escriba correctamente su configuración.

---

### 7. Levantar los contenedores

```bash
docker compose up -d
```

---

### 8. Acceder a las interfaces web

- Symfony → http://localhost/symfony  
- Drupal → http://localhost

---

## 🔐 Configuración de Drupal (tras levantar el contenedor)

Durante la instalación web de Drupal se te pedirá:

**1. Configuración de la base de datos**

Los mismos datos que aparecen en el .env de la raíz del proyecto

- DB_HOST=mysql
- DB_NAME=drupal_db
- DB_USER=ducks
- DB_PASSWORD=ducks

**2.Configuración para el sitio**

- Nombre del sitio: Web Cliente  
- Correo del sitio: cliente@ejemplo.com  
- Nombre de usuario: admin_cliente  
- Contraseña: admin1234  

### Archivos importantes:

- `settings.php`: configuración principal de Drupal  
- Aquí puedes cambiar el título del sitio o configurar rutas personalizadas

⚠️ Si necesitas editar `settings.php`, primero activa permisos:

```bash
chmod u+w settings.php   # Dar permisos de escritura temporal
# ...editar...
chmod u-w settings.php   # Quitar permisos por seguridad
```

---

## 🔒 HTTPS (comentado por defecto)

En `nginx/default.conf` hay un bloque preparado para certificados SSL. Para activarlo:

1. Quitar el comentario de esta línea en `docker-compose.yml`:

```yaml
# - "443:443"
```

2. Descomentar este bloque completo en `default.conf`:

```nginx
#server {
#    listen 443 ssl;
#    server_name localhost;
#    ssl_certificate /etc/nginx/certs/fullchain.pem;
#    ssl_certificate_key /etc/nginx/certs/privkey.pem;
#    # Rutas de Symfony y Drupal se mantienen
#}
```

3. También puedes activar la redirección automática de HTTP a HTTPS:

```nginx
# return 301 https://$host$request_uri;
```

---
## 🛠 Cómo levantar el proyecto en producción


1. **Crear los archivos de entorno**  
   - Crea un archivo `.env.prod` en la raíz del proyecto y añade dentro todo el contenido de las variables para MySQL y para Drupal.

   
   - Luego, crea dentro de la carpeta symfony el archivo `.env.prod`  y dentro añade el contenido real para las variables de ejemplo: 
    
     ```env
     # Symfony
     APP_ENV=prod
     APP_DEBUG=0
     APP_SECRET=123456789abcdefgh
     DATABASE_URL="mysql://ducks:ducks@mysql:3306/symfony_db"
     ```
     
2. **Configurar SSL**  
   - Crea y añade tus certificados en `nginx/certs/` (por ejemplo `cert.pem` y `key.pem`).  

   - Abre `nginx/default.prod.conf` y descomenta o ajusta las líneas de SSL para que apunten a esos archivos.  
   
   - Abre `docker-compose.prod.yml` y descomenta o ajusta el servicio de Nginx para habilitar el montaje de `nginx/certs/` y los puertos 443.

3. **Construir y levantar las imágenes Docker de producción**  
 
  ```bash
docker-compose -f docker-compose.prod.yml build --no-cache && \
docker-compose -f docker-compose.prod.yml up -d
```

---

Proyecto desarrollado por 🫆GAIA en prácticas CodeArts Solutions
