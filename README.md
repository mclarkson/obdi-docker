# obdi-docker

Run [obdi](https://github.com/mclarkson/obdi) in a docker container.

Two containers are created here, mclarkson/obdi-master and mclarkson/obdi-worker.

## Installation

Start the obdi-master container:

```
docker run -d -p 4443:443 --name obdi-master mclarkson/obdi-master
```

To start an obdi-worker container:

```
docker run -d --name obdi-worker-1 mclarkson/obdi-worker
```

## Helloworld Example

In this section instructions are provided to set up a fully working Obdi
installation with 5 plugins.

**Requirements**

Docker and a Unix-like system such as: Linux, Mac, or Windows with
Git-for-Windows.

**The setup**

Users: admin, nomen.nescio, sduser, and worker.

Data Centres: main

Environments: testenv

Plugins: helloworld, helloworld-localdb, helloworld-minimal,
helloworld-runscript, and systemjobs.

**How to do it**

Run the following commands:

```
docker run -d -p 4443:443 --name obdi-master mclarkson/obdi-master

masterip=$(docker inspect obdi-master | \
  sed -n '/"Networks":/,/}/{s/.*IPAddress[^0-9]*\([0-9.]*\).*/\1/p}' )

wget https://raw.githubusercontent.com/mclarkson/obdi-docker/master/examples/setupobdi.sh
wget https://raw.githubusercontent.com/mclarkson/obdi-docker/master/examples/setupdefworker.sh

bash setupobdi.sh $masterip

docker run -d --name obdi-worker-1 --env-file envfile mclarkson/obdi-worker

workerip=$(docker inspect obdi-worker-1 | \
  sed -n '/"Networks":/,/}/{s/.*IPAddress[^0-9]*\([0-9.]*\).*/\1/p}')

bash setupdefworker.sh $masterip $workerip
```

With the above setup:

* Obdi admin interface is at https://localhost:4443/manager/admin and<br>
  The default admin password is, admin.<br>
* Obdi run interface is at https://localhost:4443/manager/run<br>
  The nomen.nescio password is, nomen.

## Environment Variables

The following environment variables are available:

For Master file /etc/obdi/obdi.conf:

| Environment Variable  | Default |
| ------------- | ------------- |
| `OBDICONF_DATABASE_PATH`        | `/var/lib/obdi/manager.db` |
| `OBDICONF_PLUGIN_DATABASE_PATH` | `/var/lib/obdi/plugins/` |
| `OBDICONF_GO_PLUGIN_DIR`        | `/usr/lib/obdi/plugins` |
| `OBDICONF_STATIC_CONTENT`       | `/usr/share/obdi/static/` |

For Worker file /etc/obdi-worker/obdi-worker.conf:

| Environment Variable  | default |
| ------------- | ------------- |
| `OBDICONF_KEY`        | `lOcAlH0St` |
| `OBDICONF_MAN_URLPREFIX` | `https://127.0.0.1` |
| `OBDICONF_MAN_USER`        | `worker1` |
| `OBDICONF_MAN_PASSWORD`        | `pAsSwOrD` |

## Build

To build, recompiling obdi from github mclarkson/obdi and remaking
obdi-master and obdi-worker images, use:

```
bash build.sh
```

Or, to rebuild completely from scratch (ignoring docker caches):

```
bash build.sh --no-cache
```
