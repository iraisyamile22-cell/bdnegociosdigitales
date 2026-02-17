# Reporte de Práctica: Instalación y Configuración de SQL Server 2022

**Estudiante:** Irais Yamile Yañez Lopez  
**Materia:** Gestión de Bases de Datos  
**Fecha:** 22/01/2026  

---

## Procedimiento y Desarrollo

### Paso 1: Obtención y Ejecución del Instalador

Se accedió a la carpeta compartida en **Drive** proporcionada por el docente para descargar el ejecutable: SQL2022-SSEI-Dev.exe


Una vez en el equipo local, se localizó el archivo en la carpeta de descargas y, mediante el explorador de archivos, se procedió a ejecutar la aplicación **setup** con permisos de administrador para iniciar el asistente de instalación.

---

### Paso 2: Selección de Tipo de Instalación

Dentro del **SQL Server Installation Center**, se seleccionó la opción **Installation** y posteriormente la primera alternativa: New SQL Server standalone installation


Esto permitió crear una nueva instancia local. Para la edición del software, se especificó la versión gratuita **Developer**, aceptando los términos de licencia correspondientes para continuar con la carga de archivos de configuración.

---

### Paso 3: Selección de Características

Durante la configuración, se deshabilitó la opción: Azure extension for SQL Server


Debido a que no se requería conectividad con la nube para esta práctica.

En el apartado **Feature Selection**, se marcaron los siguientes componentes esenciales:

- **Database Engine Services** (Motor de base de datos)
- **SQL Server Replication**

---

### Paso 4: Configuración de la Instancia y Seguridad

Se mantuvo la configuración de instancia por defecto (**Default instance**), conservando el ID: MSSQLSERVER


En la etapa **Database Engine Configuration**, se estableció el modo de autenticación como: Mixed Mode (Windows and SQL Server Authentication)


Se definió una contraseña para el usuario administrador del sistema (**sa**) y se agregó el usuario actual de Windows como administrador mediante la opción **Add Current User**.

---

### Paso 5: Finalización del Motor de Base de Datos

Después de revisar el resumen de la instalación, se dio clic en el botón: Install


El proceso concluyó de manera exitosa, dejando el servicio de **SQL Server** correctamente instalado y operativo en el equipo.

---

### Paso 6: Instalación de Herramientas de Gestión (SSMS)

Para administrar la base de datos, se regresó al menú principal del instalador y se seleccionó la opción: Install SQL Server Management Tools


Esto redirigió al sitio oficial para descargar el instalador de **SSMS 2022**. Finalmente, se ejecutó el instalador, visualizado a través del entorno de **Visual Studio Installer**, completando así la integración del entorno gráfico de administración.



