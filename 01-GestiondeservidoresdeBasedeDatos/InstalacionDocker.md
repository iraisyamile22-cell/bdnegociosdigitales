# Instalaciones Docker

# Reporte de Práctica: Instalación de Docker y Despliegue de Contenedores de Base de Datos

**Estudiante:** Irais Yamile Yañez Lopez  
**Materia:** Base de Datos para Negocios Digitales  
**Fecha:** 22/01/2026  

---

## 3. Procedimiento y Desarrollo

### Paso 1: Instalación y Actualización de WSL

Se procedió a instalar **Docker Desktop**. Durante el inicio, el sistema detectó que la versión de **WSL** era antigua, mostrando el mensaje: WSL needs updating

Para solucionar este problema, se ejecutó el siguiente comando en la terminal: wsl --update


Este comando descargó e instaló la versión más reciente del Subsistema de Windows para Linux (versión 2.6.3), permitiendo que Docker Desktop iniciara correctamente.

---

### Paso 2: Descarga de Imagen de SQL Server

Consultando la documentación oficial en **Microsoft Learn** y **Docker Hub**, se identificó la imagen necesaria para **SQL Server 2019**.

Se utilizó el siguiente comando en **Git Bash** para descargar la imagen a la máquina local: docker pull mcr.microsoft.com/mssql/server:2019-latest


---

### Paso 3: Descarga de Otras Imágenes (MySQL y Tutorial)

Para complementar el entorno, se buscó la imagen oficial de **MySQL** en Docker Hub y se descargó utilizando el comando: docker pull mysql:latest

Adicionalmente, se descargó la imagen: docker pull docker/getting-started


La cual se utilizó para realizar pruebas de funcionamiento iniciales.

---

### Paso 4: Ejecución de Contenedores de Prueba

Se verificó la lista de imágenes descargadas mediante el comando: docker images


Posteriormente, se ejecutó el contenedor del tutorial en segundo plano (`-d`), asignándole un nombre personalizado con el comando: docker run --name tlacoyo -d [IMAGE_ID]


Esto confirmó que el motor de Docker estaba operando correctamente.

---

### Paso 5: Despliegue del Contenedor SQL Server

Se documentó el comando de ejecución en un archivo Markdown llamado **instalacionSGBDDocker.md** dentro de **Visual Studio Code**, con el fin de asegurar la correcta configuración de las variables de entorno.

El comando incluyó los siguientes parámetros:

- **Variables de entorno:**
  - Aceptación de la licencia EULA (`ACCEPT_EULA=Y`)
  - Configuración de la contraseña (`MSSQL_SA_PASSWORD`)

- **Puertos:**
  - Mapeo del puerto `1435` del contenedor al puerto `1433` del host

- **Nombre del contenedor:**
  - `servidorqlserver`

El comando final se ejecutó exitosamente, devolviendo el **ID del contenedor creado**.


