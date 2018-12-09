# Angular ng-cli container

Angular client, known as [angular-cli](https://github.com/angular/angular-cli) and providing "ng" command to prepare, develop and serve Angular application.

**Important** Angular is not AngularJS !

## Versions

See tag tab to see available versions
- `7.1.2`, `7.1`, `7`, `latest` → [latest](https://github.com/metal3d/docker-ng/tree/master/src)
- `7.1.1`
- `7.1.0`
- `7.0.7`, `7.0`
- `7.0.6`
- `7.0.5`
- `7.0.4`
- `7.0.3`
- `7.0.2`
- `7.0.1`

- `6.2.8`, `6.2`, `6`
- `6.2.7`
- `6.2.0`
- `6.2.1`
- `6.2.2`
- `6.2.3`
- `6.2.4`
- `6.2.5`
- `6.2.6`

- `6.1.5`, `6.1`
- `6.1.4`
- `6.1.3`
- `6.1.2`
- `6.1.1`
- `6.1.0`

- `6.0.8`, `6.0`
- `6.0.7`
- `6.0.5`
- `6.0.4`
- `6.0.3`
- `6.0.2`
- `6.0.1`
- `6.0.0`


## Details

- Exposed port: 4200
- Volume and working directory: `/app`

The container will check if `package.json` is present, if it's found so `npm install` is called, either a project is created.

**Important**

You will want to use that image to "develop", so you'll need to have write access on your working directory. That image can work with forced uid:gid, so follow below explanation to set "uid" and "gid". That is useful for Openshift users who want to startup application without to force service account.

You only need to pass "`--user $(id -u):$(id -g)`" option at startup.

## Environment

- `APPNAME` is the name of the generated application, default is "hero", it's only used at generation time.
- `GENERATE` is default to "true", if other value is specified so the container will **not** generate project in case of `package.json` is not found. It is useful when you want to generate application yourself providing others options.
- `ANGULAR_STYLESHEET_FORMAT`: used at install time, one of the supported stylesheet format css, scss, less, lass... (default: css)
- `ANGULAR_HOST_CHECK`: true or false, default is "true"
- `ANGULAR_ROUTING`: used at install time to activate routing or not, default "true"


## Usage

Note for SELinux users, you'll need to use "privileged" option or make your application directory usable by Docker with that command:

```bash
$ mkdir myapp
$ chcon -Rt svirt_sandbox_file_t ./myapp 
```

Prepare an application:

```bash
$ mkdir myapp

# generate application named "superhero"
# use "user" option to keep your own uid:gid and be able
# to write in directory.
$ docker run --rm -it \
    --user $(id -u):$(id -g)
    -e APPNAME=superhero \
    -v $PWD/myapp:/app \
    metal3d/ng

```

Serve with binding port 4200:

```bash
$ docker run --rm -it \
    --user $(id -u):$(id -g) \
    -v $PWD/myapp:/app \
    metal3d/ng \
    -p 4200:4200
```

To generate a distribution release:

```bash
$ docker run --rm -it \
    --user $(id -u):$(id -g) \
    -v $PWD/myapp:/app \
    metal3d/ng \
    ng build --prod
```

## Docker-compose example


```yaml
version: "3"
services:
    ngapp:
        image: metal3d/ng:6
        # use your own
        user: 1000:1000
        environment:
            APPNAME: my-super-app
        ports:
            - 4200:4200
```
