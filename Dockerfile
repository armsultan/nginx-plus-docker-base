FROM ubuntu:16.04

LABEL maintainer="armand@nginx.com"

# Install prerequisite packages:
RUN apt-get update && apt-get install -y sudo && rm -rf /var/lib/apt/lists/*
RUN apt-get update
RUN apt-get install -y apt-transport-https lsb-release ca-certificates wget dnsutils curl
RUN apt-get install -y vim # vi for config file editing

## Install Nginx Plus

# Download certificate and key from the customer portal https://cs.nginx.com
# and copy to the build context
RUN mkdir -p /etc/ssl/nginx
COPY etc/ssl/nginx/nginx-repo.crt /etc/ssl/nginx/nginx-repo.crt
COPY etc/ssl/nginx/nginx-repo.key /etc/ssl/nginx/nginx-repo.key
RUN chmod 644 /etc/ssl/nginx/*

# Install method A. Install NGINX Plus from repo
# Get other files required for installation
RUN wget http://nginx.org/keys/nginx_signing.key && apt-key add nginx_signing.key
RUN printf "deb https://plus-pkgs.nginx.com/ubuntu `lsb_release -cs` nginx-plus\n" | sudo tee /etc/apt/sources.list.d/nginx-plus.list
RUN wget -P /etc/apt/apt.conf.d https://cs.nginx.com/static/files/90nginx
RUN apt-get update
RUN apt-get -y install nginx-plus

## Optional: Install NGINX Plus Modules from repo
#RUN apt-get install -y nginx-plus-module-modsecurity
#RUN apt-get install -y nginx-plus-module-geoip
#RUN apt‑get install -y nginx-plus-module-njs

# COPY over any of your SSL certs for HTTPS servers
# COPY etc/ssl/certs/example.com.key /etc/ssl/certs/example.com.crt

# Optional: Create cache folder and set permissions for proxy caching
#CMD mkdir -p /var/cache/nginx
#CMD chown -R nginx /var/cache/nginx

# Forward request logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stderr /var/log/nginx/error.log

# COPY /etc/nginx (Nginx configuration) directory and other directories as
# necessary, for example, /usr/share/nginx/html for static files
# COPY etc/nginx /etc/nginx
#COPY usr/share/nginx/html /usr/share/nginx/html # Optional

# EXPOSE ports, HTTP 80, HTTPS 443 and, Nginx status page 8080
EXPOSE 80 8080 443
CMD ["nginx", "-g", "daemon off;"]