FROM stephenneal/nginx-flask:1.17-alpine as flask-server


FROM stephenneal/nginx-laravel:1.17-alpine-v3

# Copy flask webserver config from flask-server
COPY --from=flask-server /etc/nginx/conf.d/app.conf /etc/nginx/conf.d/app.conf