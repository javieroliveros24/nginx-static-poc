Proyecto de Infraestructura y Despliegue Web Estático con Docker y Nginx

AeroLogix Solutions S.L.

Introducción y Propósito del Proyecto

Este documento recoge el desarrollo y la implementación de la Prueba de Concepto diseñada para la empresa AeroLogix Solutions S.L., enfocada en el sector de la logística y el rastreo aeroespacial. El objetivo principal de la actividad ha sido desplegar un entorno de servidor web seguro, aislado y portátil utilizando tecnologías de contenedores con Docker y Nginx sobre Alpine Linux. A lo largo del proyecto se ha buscado cumplir con requisitos estrictos de diseño semántico en HTML5, estandarización de hojas de estilo CSS3 y la aplicación de directivas de seguridad en el servidor web basadas en recomendaciones de OWASP.

Arquitectura del Sitio Web y Estructura Semántica

La interfaz web proyectada para AeroLogix Solutions fue diseñada respetando fielmente la maqueta visual corporativa y asegurando una maquetación moderna sin recurrir al uso de etiquetas div genéricas. Se ha empleado una estructura totalmente semántica basada en elementos nativos de HTML5 como header, nav, main, section, article,aside y footer. Esta elección no solo mejora la accesibilidad web y el posicionamiento en buscadores, sino que garantiza un código limpio y mantenible.

Para la hoja de estilos se utilizó CSS3 aprovechando el modelo de caja de Grid y Flexbox, logrando una distribución responsiva y adaptativa. Los esquemas cromáticos se ajustaron a la identidad visual de la compañía, empleando degradados oscuros en la cabecera y el pie de página, complementados con tonos grises neutros para el fondo general y tarjetas blancas flotantes con bordes sutiles para destacar las distintas áreas de servicios y el estado del sistema.

Configuración del Servidor Web Nginx y Hardening

El motor del servicio web se apoya en Nginx versión 1.27 sobre Alpine Linux, elegido por su reducida huella de memoria y su bajo perfil de ataque. La configuración del servidor virtual se definió en el archivo default.conf, donde se aplicaron diversas medidas de hardening o endurecimiento para proteger la infraestructura contra vectores de ataque comunes.

Entre las directivas implementadas destaca la desactivación de las cabeceras de versión mediante la regla server_tokens off, lo que impide que el servidor exponga el número exacto de versión ante posibles escaneos de reconocimiento. Asimismo, se incorporaron cabeceras HTTP de seguridad esenciales: X-Frame-Options con valor SAMEORIGIN para evitar ataques de Clickjacking, X-Content-Type-Options en modo nosniff para prevenir el análisis malicioso de tipos MIME por parte del navegador, y X-XSS-Protection activado para mitigar inyecciones de código. Por último, los registros de acceso y de errores fueron canalizados hacia la salida y error estándar del sistema, permitiendo que la monitorización se integre de forma natural con los comandos nativos de Docker.

Contenerización y Orquestación con Docker Compose

La infraestructura se automatizó mediante un archivo Dockerfile y una plantilla de orquestación con Docker Compose. El Dockerfile parte de la imagen oficial de Nginx Alpine, copia la configuración personalizada del servidor virtual dentro del directorio de Nginx e incluye los archivos estáticos de la aplicación web en la ruta raíz de publicación.

Mediante Docker Compose se centralizó la ejecución del contenedor definiendo un servicio único. Para evitar conflictos de ocupación con otros servicios activos en el equipo host, el puerto interno 80 del contenedor se mapeó hacia el puerto externo 8085 de la máquina anfitriona. Además, se configuraron los volúmenes de datos montando la carpeta del código web y el archivo de configuración en modo de solo lectura. Esta práctica asegura que, incluso si un atacante lograra comprometer el proceso del servidor web, no podría alterar ni modificar los archivos estáticos ni las reglas del servidor guardadas en el disco del anfitrión.

Verificación de Servicios y Pruebas de Funcionamiento

Una vez levantado el entorno con los comandos de Docker Compose, se llevaron a cabo las pruebas de validación funcional y de seguridad. La primera comprobación se realizó mediante peticiones de cabecera en la terminal de comandos utilizando curl. La respuesta del servidor confirmó un estado exitoso con código 200 OK, demostrando que la firma del servidor mostraba únicamente el nombre genérico sin revelar la versión y que todas las cabeceras de seguridad requeridas estaban presentes en la respuesta HTTP.

Posteriormente se verificó la carga de la aplicación desde un navegador web accedido a través del puerto asignado. Mediante las herramientas de desarrollo del navegador se constató la recepción correcta del archivo HTML principal y de las hojas de estilo asociadas, alcanzando un código de estado 200 en la primera petición y un código 304 en cargas subsecuentes gracias a la gestión eficiente de la memoria caché. Finalmente, la inspección de los registros de Docker permitió observar en tiempo real la traza de las peticiones recibidas, confirmando el correcto funcionamiento del flujo de red y del montaje en solo lectura.

Resolución de Incidencias en Entornos de Producción

Durante el desarrollo del despliegue se contempló la gestión de incidencias comunes en servidores web estáticos. Ante errores de acceso denegado o recursos no encontrados al agregar nuevos contenidos, el procedimiento estándar establecido consiste en la revisión primaria de los logs del contenedor para identificar si se trata de un problema de permisos POSIX o de ruta de archivos.

Si la traza refleja fallos de lectura, la solución pasa por ajustar los permisos de los recursos en la máquina host asegurando permisos de lectura global. Si el fallo responde a una ruta no encontrada, se debe verificar que el nombre de las carpetas y archivos en el código conserve la coincidencia exacta de mayúsculas y minúsculas, dado que el sistema operativo Linux del contenedor diferencia estrictamente entre ambas. Estas pautas quedan integradas dentro del protocolo de mantenimiento para garantizar la continuidad operativa de la plataforma.
