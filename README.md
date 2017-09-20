# obdi-docker

Run [obdi](https://github.com/mclarkson/obdi) in a docker container.

Two containers are created here, mclarkson/obdi-master and mclarkson/obdi-worker.

## Installation

Start the obdi-master container:

```
docker run -d -p 4443:443 --name obdi mclarkson/obdi-master
```

With the above setup:

* Obdi is at http://localhost:4443/manager/admin and<br>
  http://localhost:4443/manager/run<br>
  The default admin password is, admin.

## Build

To build, recompiling obdi from github mclarkson/obdi and remaking
obdi-master and obdi-worker images, use:

```
bash build.sh
```

