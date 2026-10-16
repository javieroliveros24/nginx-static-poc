FROM nginx:1.27-alpine

# Copiar la configuración personalizada del Virtual Host
COPY conf/default.conf /etc/nginx/conf.d/default.conf

# Copiar el código fuente estático
COPY html/ /usr/share/nginx/html/

EXPOSE 80