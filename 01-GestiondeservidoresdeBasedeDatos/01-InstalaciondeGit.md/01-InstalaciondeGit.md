# Procedimiento de Instalacion Git
# Evidencia de Trabajo con Git y GitHub

**Estudiante:** Irais Yamile Yañez Lopez  
**Materia:** Base de Datos para Negocios Digitales  
**Fecha:** 22/01/2026  

---
## Paso 1: Preparación del Entorno (VS Code)

Se inició personalizando el editor **Visual Studio Code** mediante la instalación de extensiones útiles para la productividad, como:

- *Icons* de Mhammed Talhaouy  
- *Activitus Bar*

Estas extensiones permitieron mejorar la visualización del explorador de archivos.

Posteriormente, se creó la estructura de carpetas en la unidad local: C:\Basededatosnegociosdigitales

Organizando el contenido en subcarpetas temáticas como:

- `01-GestiondeservidoresdeBasedeDatos`
- `02-ManipulacionAvanzada`

Además, se añadió un archivo **README.md** con el objetivo de aprendizaje y la descripción de las unidades.

---

## Paso 2: Configuración de Identidad en Git

A través de la consola de **Git Bash**, se verificó la versión instalada mediante el comando: git --version


Posteriormente, se configuraron las credenciales globales del usuario, asignando:

- **Nombre de usuario:** Irais Yañez  
- **Correo electrónico:** correo correspondiente  

Esto permitió firmar correctamente los cambios realizados en el repositorio.

---

## Paso 3: Inicialización del Repositorio Local

Navegando hacia la carpeta del proyecto mediante el comando: cd

Se inicializó el repositorio con: git init


Para seguir las buenas prácticas actuales, se renombró la rama principal de `master` a `main` utilizando el comando: git branch -m master main


---

## Paso 4: Gestión de Cambios (Commit)

Al verificar el estado del repositorio con: git status


Se observaron las carpetas y archivos como **untracked** (no rastreados).

Se procedió a prepararlos todos con: git add .


Posteriormente, se realizó el primer *commit* con el mensaje: git commit -m "Inicio de Repositorio de bd para negocios Digitales"


El historial de cambios se verificó correctamente mediante: gir log


---

## Paso 5: Creación y Vinculación con GitHub

Se creó una cuenta en **GitHub** con el usuario:

- `iraisyamile22-cell`

Posteriormente, se generó un nuevo repositorio público llamado:

- `bdnegociosdigitales`

Durante el proceso de vinculación se presentaron algunos problemas de conexión, tales como:

- *Could not resolve host*
- Problemas al reconocer el remoto `origin`

Estos inconvenientes se solucionaron verificando la conexión a internet mediante: ping github.com


Finalmente, se añadió el repositorio remoto con el alias **irais**.

---

## Paso 6: Sincronización Final (Push)

Una vez establecida la conexión y autenticada la cuenta vía navegador, se ejecutó exitosamente el comando: git push -u irais main


Con esto, se subieron todos los archivos y objetos al repositorio en la nube de GitHub.













