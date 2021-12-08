# Snapt Aria Sandbox

A Sandbox for testing [Snapt Aria](https://www.snapt.net/) 

See documentation for [Snapt Aria on Docker](https://docs.snapt.net/article/docker/)

### Start the Demo stack:

Run `docker-compose` in the foreground so we can see real-time log output to the
terminal:

```bash
$ docker-compose up -d
```

Or, if you made changes to any of the Docker containers or NGINX configurations,
run:

```bash
# Recreate containers and start demo
$ docker-compose up --force-recreate -d
```

**Confirm** the containers are running. You should see three containers running:

```
$ docker ps

CONTAINER ID   IMAGE                            COMMAND                  CREATED          STATUS         PORTS                                                                                                     NAMES
90c5b8c1388a   snaptadc/snapt:latest            "/bin/sh -c './usr/l…"   6 seconds ago    Up 4 seconds   0.0.0.0:80-100->80-100/tcp, :::80-100->80-100/tcp, 0.0.0.0:8080->8080/tcp, :::8080->8080/tcp, 29987/tcp   snapt-aria-demo-base_aria1_1
2d1b8fee4d35   armsultan/test-page:html         "/docker-entrypoint.…"   35 seconds ago   Up 5 seconds   80/tcp                                                                                                    snapt-aria-demo-base_web-simple_1
f15c205b0fd7   armsultan/test-page:plain-text   "/docker-entrypoint.…"   35 seconds ago   Up 5 seconds   80/tcp                                                                                                    snapt-aria-demo-base_web-plain-text_1
4b84944ca99c   armsultan/test-page:snapt        "/docker-entrypoint.…"   35 seconds ago   Up 5 seconds   80/tcp                                                                                                    snapt-aria-demo-base_web-snapt_1
df1ef4ed2aaf   armsultan/test-page:json         "/docker-entrypoint.…"   35 seconds ago   Up 5 seconds   80/tcp                                                                                                    snapt-aria-demo-base_web-json_1
4178135fbe09   armsultan/test-page:green        "/docker-entrypoint.…"   35 seconds ago   Up 5 seconds   80/tcp                                                                                                    snapt-aria-demo-base_web-html-green_1
d44e087c3ed7   armsultan/test-page:planets      "/docker-entrypoint.…"   35 seconds ago   Up 5 seconds   80/tcp                                                                                                    snapt-aria-demo-base_web-html-planets_1
d106e8e1a785   armsultan/test-page:blue         "/docker-entrypoint.…"   35 seconds ago   Up 5 seconds   80/tcp                                                                                                    snapt-aria-demo-base_web-html-blue_1
```

### Configure Snapt Aria

Open `http://localhost:8080/` and login using the registered username and passed
registed on https://shop.snapt.net. All communication is encrypted.


### Demo Environment Topology

```
                                                ┌──────────────┐
                                                │              ├─┐
                                      ┌─────────► web-snapt   │ │
                                      │         │              │ │
                                      │         └─┬────────────┘ │
                                      │ . . . . ►└──────────────┘ x x x
                                      │
                                      │
                                      │         ┌──────────────┐
                                      │         │              ├─┐
                                      ├─────────► web-planets │ │
                                      │         │              │ │
                                      │         └─┬────────────┘ │
                                      │ . . . . ►└──────────────┘ x x x
                                      │
                                      │
                                      │         ┌────────────────┐
                                      │         │                ├─┐
                                      ├─────────►web-plain-text │ │
                                      │         │                │ │
                                      │         └─┬──────────────┘ │
                                      │ . . . . ►└────────────────┘ x x x
                                      │
 ┌──────────────────────────┐         │
 │                          │         │         ┌──────────────┐
 │                          │         │         │              ├─┐
 │   SNAPT ARIA ADC         |─────────├─────────► web-json    │ │
 │                          │         │         │              │ │
 │                          │         │         └─┬────────────┘ │
 └──────────────────────────┘         │ . . . . ►└──────────────┘ x x x
                                      │
                                      │
                                      │         ┌──────────────┐
                                      │         │              ├─┐
                                      ├─────────► web-html    │ │
                                      │         │              │ │
                                      │         └─┬────────────┘ │
                                      │ . . . . ►└──────────────┘ x x x
                                      │
                                      │
                                      │         ┌──────────────┐
                                      │         │              ├─┐
                                      ├─────────► web-blue    │ │
                                      │         │              │ │ 
                                      │         └─┬────────────┘ │
                                      │ . . . . ►└──────────────┘ x x x
                                      │
                                      │
                                      │         ┌──────────────┐
                                      │         │              ├─┐
                                      ├─────────► web-green   │ │
                                      │         │              │ │ 
                                      │         └─┬────────────┘ │
                                      └ . . . . ►└──────────────┘ x x x
```