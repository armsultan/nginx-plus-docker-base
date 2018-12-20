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
    └── nginx.conf .................Main NGINX configuration file with global settings
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

 1. Copy and paste your `nginx-repo.crt` and `nginx-repo.key` into `etx/ssl/nginx` directory first

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



## URL Rewrite Rules demo instructions:

Test out the demos by following the instructions below using two terminal windows:

 1. One terminal, on a client machine to run `curl` commands with the `-L` flag will follow redirects. If you are not using docker locally, replace `localhost` with the Nginx hostname or IP address Substitute `[original_uri]` with the test request URI to be rewritten - see table below for demo URIs to test:
    ```bash
    # Follow redirects
    curl -L http://localhost/[original_uri]
    # Don't follow redirects
    curl -L http://localhost/[original_uri]
    ```
 2. Another terminal view the `rewrite_log` messages live from the Ngin error logs using `tail`:
    ```bash
    # When using Docker (from the Docker host)
    docker logs -f [CONTAINER ID]

    # Non-Docker deployment (from the Nginx host)
    tail -f 10 /var/log/nginx/error.log
    ```

| Orginal URL                                  | Rewritten URL                          |
| ---------------------------------------      |:---------------------------------------|
| [/old-url](http://localhost/old-url)         | /new-url                               |
| [/old](http://localhost/old)                 | /new                                   |
| [/nginx](http://localhost/nginx)             | https://www.nginx.com/                 |
| [/en/docs/](http://localhost/en/docs/)       | http://nginx.org/en/docs/              |
| [/media/cdn-west/text/file1](http://localhost/media/cdn-west/text/file1)   | /media/cdn-west/txt/file1.txt    |
| [/media/cdn-west/music/file1](http://localhost/media/cdn-west/music/file1) | /media/cdn-west/mp3/file1.mp3 -> /media/cdn-west/ra/file1.ra      |


#### For Example:

From your client terminal run the curl command:

```bash
$ curl -L http://localhost/media/cdn-west/music/file1

Status code: 200
Server address: 127.0.0.1:8096
Server name: nginx99
Date: 21/Aug/2018:11:46:27 -0700
User-Agent: curl/7.54.1
Cookie:
URI: /media/cdn-west/ra/file1.ra
Request ID: 8511f59a46dce9b96883ceeb42d7e0db
```

In another terminal windows, `tail` logs and `grep "\[notice\]"`:

`docker logs -f [container_id] | grep "\[notice\]"`        

As seen in the `error.logs`:
```
2018/08/21 12:00:59 [notice] 43326#43326: *277 "^(/media/.*)/text/(\w+)\.?.*$" does not match "/media/cdn-west/music/file1", client: 192.168.112.1, server: localhost, request: "GET /media/cdn-west/music/file1 HTTP/1.1", host: "192.168.112.99"
2018/08/21 12:00:59 [notice] 43326#43326: *277 "^(/media/.*)/music/(\w+)\.?.*$" matches "/media/cdn-west/music/file1", client: 192.168.112.1, server: localhost, request: "GET /media/cdn-west/music/file1 HTTP/1.1", host: "192.168.112.99"
2018/08/21 12:00:59 [notice] 43326#43326: *277 rewritten data: "/media/cdn-west/mp3/file1.mp3", args: "", client: 192.168.112.1, server: localhost, request: "GET /media/cdn-west/music/file1 HTTP/1.1", host: "192.168.112.99"
2018/08/21 12:00:59 [notice] 43326#43326: *277 "^(/media/.*)/mp3/(\w+)\.?.*$" matches "/media/cdn-west/mp3/file1.mp3", client: 192.168.112.1, server: localhost, request: "GET /media/cdn-west/music/file1 HTTP/1.1", host: "192.168.112.99"
2018/08/21 12:00:59 [notice] 43326#43326: *277 rewritten data: "/media/cdn-west/ra/file1.ra", args: "", client: 192.168.112.1, server: localhost, request: "GET /media/cdn-west/music/file1 HTTP/1.1", host: "192.168.112.99"
2018/08/21 12:00:59 [info] 43326#43326: *277 client 192.168.112.1 closed keepalive connection
2018/08/21 12:01:43 [notice] 43326#43326: *280 "^(/media/.*)/text/(\w+)\.?.*$" does not match "/media/cdn-west/music/file1", client: 192.168.112.1, server: localhost, request: "GET /media/cdn-west/music/file1 HTTP/1.1", host: "192.168.112.99"
2018/08/21 12:01:43 [notice] 43326#43326: *280 "^(/media/.*)/music/(\w+)\.?.*$" matches "/media/cdn-west/music/file1", client: 192.168.112.1, server: localhost, request: "GET /media/cdn-west/music/file1 HTTP/1.1", host: "192.168.112.99"
2018/08/21 12:01:43 [notice] 43326#43326: *280 rewritten data: "/media/cdn-west/mp3/file1.mp3", args: "", client: 192.168.112.1, server: localhost, request: "GET /media/cdn-west/music/file1 HTTP/1.1", host: "192.168.112.99"
2018/08/21 12:01:43 [notice] 43326#43326: *280 "^(/media/.*)/mp3/(\w+)\.?.*$" matches "/media/cdn-west/mp3/file1.mp3", client: 192.168.112.1, server: localhost, request: "GET /media/cdn-west/music/file1 HTTP/1.1", host: "192.168.112.99"
```