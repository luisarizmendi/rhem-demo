FROM nginx:alpine

COPY . /usr/share/nginx/html
COPY nginx.conf /etc/nginx/nginx.conf

RUN mkdir -p /tmp/nginx_temp/client_body /tmp/nginx_temp/proxy /tmp/nginx_temp/fastcgi /tmp/nginx_temp/uwsgi /tmp/nginx_temp/scgi

EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]




