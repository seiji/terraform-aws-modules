FROM nginx:1.17.9-alpine

COPY ./nginx.conf.template /etc/nginx/
COPY ./conf.d/ /etc/nginx/conf.d/

RUN touch /var/run/nginx.pid \
  && chown -R nginx:nginx /var/run/nginx.pid \
  && chown -R nginx:nginx /etc/nginx \
  && chown -R nginx:nginx /var/cache/nginx

USER nginx
