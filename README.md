# Nginx Plus Base

A NGINX Plus base dockerfile and configuration for testing

## File Structure

```
etc/
└── nginx/
    ├── conf.d/
    │   ├── default.conf ...........Default Virtual Server configuration with example rewrite rules
    │   └── dummy_servers.conf  ....Dummy loopback web servers reponds with plain/text
    │   └── upstreams.conf..........Upstream configurations
    │   └── stub_status.conf .......NGINX Open Source basic status information available http://localhost/nginx_status only
    │   └── status_api.conf.........NGINX Plus Live Activity Monitoring available on port 8080
    ├── nginx.conf .................Main NGINX configuration file with global settings
    ├── includes/
    │   └── proxy_headers/
    │       └─── proxy_headers.conf .....Best practice headers to pass to backend proxied servers
    └──  ssl/
        ├── example.com.crt...........Self signed certificate for testing
        └── example.com.key...........Self generated private key for testing
└── ssl/
    └── nginx/
        ├── nginx-repo.crt...........NGINX Plus repository certificate file (Place your own license here)
        └── nginx-repo.key...........NGINX Plus repository key file (Place your own license here)
```

## Build Docker container

 1. Copy and paste your `nginx-repo.crt` and `nginx-repo.key` into `etc/ssl/nginx` directory first

 2. Build an image from your Dockerfile:
    ```bash
    # Run command from the folder containing the `Dockerfile`
    $ docker build -t nginx-plus .
    ```
 3. Start the Nginx Plus container, e.g.:
    ```bash
    # Start a new container and publish container ports 80, 443 and 8080 to the host
    $ docker run -d -p 80:80 -p 443:443 -p 8080:8080 nginx-plus
    ```

    **To mount local volume:**

    ```bash
    docker run -d -p 80:80 -p 443:443 -p 8080:8080 -v $PWD/etc/nginx:/etc/nginx nginx-plus
    ```

 4. To run commands in the docker container you first need to start a bash session inside the nginx container
    ```bash
    sudo docker exec -i -t [CONTAINER ID] /bin/bash
    ```
    
 5. To open logs
    ```bash
    sudo docker logs -f [CONTAINER ID]
    ```