# 🍽️ Menú del Día

Aplicación web estática para registrar y consultar menús de restaurantes.  
Sin dependencias de servidor ni base de datos externa — funciona completamente en el navegador del usuario mediante **LocalStorage**.

---

## 📋 Tabla de contenidos

1. [Descripción general](#descripción-general)
2. [Stack tecnológico](#stack-tecnológico)
3. [Estructura del proyecto](#estructura-del-proyecto)
4. [Requisitos del sistema](#requisitos-del-sistema)
5. [Ejecución en local](#ejecución-en-local)
6. [Despliegue en VPS / Cloud](#despliegue-en-vps--cloud)
7. [Funcionalidades](#funcionalidades)
8. [Almacenamiento de datos](#almacenamiento-de-datos)
9. [Compatibilidad de navegadores](#compatibilidad-de-navegadores)
10. [Autora](#autora)

---

## Descripción general

**Menú del Día** es una aplicación web de una sola página (*Single Page Application*) desarrollada en HTML5, CSS3 y JavaScript Vanilla. No requiere instalación de entornos de ejecución (Node.js, Python, PHP, etc.) ni conexión a internet en producción.

---

## Stack tecnológico

| Capa | Tecnología | Versión mínima requerida |
|------|-----------|--------------------------|
| Marcado | HTML5 | — (estándar W3C) |
| Estilos | CSS3 | — (estándar W3C) |
| Lógica | JavaScript (ES6+) | ECMAScript 2015 o superior |
| Persistencia | Web Storage API – `localStorage` | Disponible en todos los navegadores modernos |
| Servidor web (opcional) | Cualquier servidor estático | Nginx ≥ 1.18 / Apache ≥ 2.4 / http-server (npm) |

> **Sin frameworks ni librerías externas.** No se utiliza npm, webpack, Babel, ni ningún bundler.

---

## Estructura del proyecto

```
menu-del-dia/
├── index.html   # Estructura HTML y puntos de entrada de la UI
├── style.css    # Estilos visuales (paleta verde, tarjetas, botones)
└── app.js       # Lógica de la aplicación (CRUD sobre localStorage)
```

---

## Requisitos del sistema

### Para ejecutar en local (sin servidor)

| Requisito | Detalle |
|-----------|---------|
| Sistema operativo | Windows 10/11, macOS 10.15+, Ubuntu 20.04+ (o cualquier OS con navegador moderno) |
| Navegador | Chrome ≥ 80, Firefox ≥ 75, Edge ≥ 80, Safari ≥ 13 |
| Software adicional | **Ninguno** — no se requiere instalar Node.js, Python ni ningún runtime |
| Conexión a internet | **No requerida** en tiempo de ejecución |

### Para despliegue en servidor (opcional)

| Requisito | Detalle |
|-----------|---------|
| Servidor web | Nginx ≥ 1.18 **o** Apache HTTP Server ≥ 2.4 |
| Sistema operativo servidor | Ubuntu Server 20.04 LTS o superior (recomendado) |
| Puertos | 80 (HTTP) y/o 443 (HTTPS) abiertos en el firewall |
| SSL/TLS (recomendado) | Certbot + Let's Encrypt (gratuito) |

---

## Ejecución en local

### Opción A — Apertura directa (más simple)

1. Descarga o clona los tres archivos en una misma carpeta.
2. Haz doble clic en `index.html`.
3. El archivo se abrirá en tu navegador predeterminado. ✅

> ⚠️ **Nota:** algunos navegadores bloquean `localStorage` cuando el archivo se abre con el protocolo `file://`. Si la app no guarda datos, usa la Opción B.

### Opción B — Servidor local con `http-server` (Node.js)

**Prerrequisito:** Node.js ≥ 14.x instalado ([nodejs.org](https://nodejs.org))

```bash
# Instalar http-server globalmente (solo la primera vez)
npm install -g http-server

# Pararse en la carpeta del proyecto
cd menu-del-dia/

# Levantar el servidor
http-server -p 8080

# Abrir en el navegador
# http://localhost:8080
```

### Opción C — Servidor local con Python

**Prerrequisito:** Python 3.x instalado

```bash
cd menu-del-dia/
python -m http.server 8080
# Abrir: http://localhost:8080
```

---

## Despliegue en VPS / Cloud

### Ejemplo con Nginx en Ubuntu Server (Azure, AWS, DigitalOcean, etc.)

#### 1. Conectarse al servidor

```bash
ssh usuario@<IP_DEL_SERVIDOR>
```

#### 2. Instalar Nginx

```bash
sudo apt update
sudo apt install nginx -y
sudo systemctl enable nginx
sudo systemctl start nginx
```

#### 3. Copiar los archivos al servidor

Desde tu máquina local:

```bash
scp index.html style.css app.js usuario@<IP_DEL_SERVIDOR>:/var/www/html/
```

O bien clonar desde un repositorio Git:

```bash
# En el servidor
cd /var/www/html/
sudo git clone https://github.com/<tu-usuario>/menu-del-dia.git .
```

#### 4. Configurar Nginx (configuración mínima)

```nginx
# /etc/nginx/sites-available/menu-del-dia
server {
    listen 80;
    server_name <TU_DOMINIO_O_IP>;

    root /var/www/html;
    index index.html;

    location / {
        try_files $uri $uri/ =404;
    }
}
```

```bash
sudo ln -s /etc/nginx/sites-available/menu-del-dia /etc/nginx/sites-enabled/
sudo nginx -t          # verificar configuración
sudo systemctl reload nginx
```

#### 5. (Recomendado) Habilitar HTTPS con Let's Encrypt

```bash
sudo apt install certbot python3-certbot-nginx -y
sudo certbot --nginx -d <TU_DOMINIO>
```

#### 6. Verificar

Abre `http://<TU_IP_O_DOMINIO>` en el navegador. La aplicación debe cargar correctamente.

---

## Funcionalidades

| Función | Descripción |
|---------|-------------|
| **Registrar restaurante** | Agrega nombre, menú del día y precio a la lista |
| **Ver restaurantes** | Muestra todas las entradas guardadas como tarjetas |
| **Eliminar restaurante** | Borra un registro individual de forma permanente |
| **Persistencia automática** | Los datos se conservan al cerrar y reabrir el navegador |
| **Validación de campos** | Alerta si algún campo del formulario está vacío |

---

## Almacenamiento de datos

La aplicación usa la **Web Storage API** del navegador (`localStorage`):

- **Clave:** `restaurantes`  
- **Valor:** Array de objetos JSON serializado con `JSON.stringify()`
- **Estructura de cada objeto:**

```json
{
  "nombre": "La Fogata",
  "menu":   "Bandeja paisa",
  "precio": "15000"
}
```

> ⚠️ **Importante para implementadores:**  
> Los datos viven únicamente en el navegador del usuario final. No existe sincronización entre dispositivos ni respaldo en servidor. Si el usuario borra el historial/caché del navegador, los datos se pierden.

---

## Compatibilidad de navegadores

| Navegador | Versión mínima | Estado |
|-----------|---------------|--------|
| Google Chrome | 80+ | ✅ Totalmente compatible |
| Mozilla Firefox | 75+ | ✅ Totalmente compatible |
| Microsoft Edge | 80+ | ✅ Totalmente compatible |
| Safari | 13+ | ✅ Totalmente compatible |
| Internet Explorer | Cualquiera | ❌ No compatible (sin soporte ES6) |

---

## Autora

**Anamaria Hernandez Vasquez**  
Proyecto académico — 2026
