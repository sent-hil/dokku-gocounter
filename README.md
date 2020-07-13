# dokku-gocounter

This repo contains Dockerfile and instructions for setup and running [gocounter](https://github.com/zgoat/goatcounter) as a [dokku](http://dokku.viewdocs.io/dokku/) app.

Assume all commands are run from the instance where dokku is running with exception of `Create app (from local)` code block.

If you don't want Postgres as database, you can ignore the steps, but note each time you deploy a new version, all data will be lost. I personally have a small Postgres instance running in AWS RDS for all my storage needs.

### Setup postgres

```
psql '<connection string>'
CREATE DATABASE counter;
CREATE USER counter WITH PASSWORD '<password>';
```

### Import schema to postgres

```
git clone -b release-1.3 https://github.com/zgoat/goatcounter.git
psql '<connection string>' -c '\i goatcounter/db/schema.pgsql'
```

### Create app (from local)

```
git remote add dokku dokku@<dokku host>:<app name>

# this'll fail b/c $GOATCOUNTER_DB is not set, but it will still create the app
git push dokku master
```

### Setup config

```
dokku config:set <app name>GOATCOUNTER_DB='<connection string>'
dokku ps:restart <app name>
```

### Create domain

```
sudo docker exec <app name>.web.1 ./goatcounter create -domain <domain> -email <email> -password <password> -db '<connection string>'
```

### Setup letencrypt (optional)

```
dokku plugin:install https://github.com/dokku/dokku-letsencrypt.git
dokku config:set --no-restart <app name> DOKKU_LETSENCRYPT_EMAIL=<email>
dokku lets encrypt <app name>
```

Visit <domain> in a browser you and it should all just work.

Checkout [sent-hil.com](https://sent-hil.com) to see it in action.
