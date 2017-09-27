# obdi-docker

Run [obdi](https://github.com/mclarkson/obdi) in a docker container.

Two containers are created here, mclarkson/obdi-master and mclarkson/obdi-worker.

## Installation

Start the obdi-master container:

```
docker run -d -p 4443:443 --name obdi-master mclarkson/obdi-master
```

With the above setup:

* Obdi is at http://localhost:4443/manager/admin and<br>
  http://localhost:4443/manager/run<br>
  The default admin password is, admin.

To start an obdi-worker container:

```
docker run -d --name obdi-worker-1 mclarkson/obdi-worker
```

## Helloworld Example

**The setup will consist of:**

Users: admin, nomen.nescio (password: nomen), sduser, and worker.

Data Centres: main

Environments: testenv

Plugins: helloworld, helloworld-localdb, helloworld-minimal,
helloworld-runscript, and systemjobs.

**How to do it**

Do the above installation steps then use the `examples/setupobdi.sh' script
to set up Obdi with the Helloworld example plugins, and systemjobs plugins.

```
masterip=$(docker inspect obdi-master | \
  sed -n '/"Networks":/,/}/{s/.*IPAddress[^0-9]*\([0-9.]*\).*/\1/p}' )

workerip=$(docker inspect obdi-worker-1 | \
  sed -n '/"Networks":/,/}/{s/.*IPAddress[^0-9]*\([0-9.]*\).*/\1/p}')

bash examples/setupobdi.sh $masterip $workerip
```

With the above setup:

* Obdi admin interface is at http://localhost:4443/manager/admin and<br>
  The default admin password is, admin.<br>
* Obdi run interface is at http://localhost:4443/manager/run<br>
  The nomen.nescio password is, nomen.

## Build

To build, recompiling obdi from github mclarkson/obdi and remaking
obdi-master and obdi-worker images, use:

```
bash build.sh
```

