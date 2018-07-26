# Angular ng-cli container

Angular client, known as [angular-cli](https://github.com/angular/angular-cli) and providing "ng" command to prepare, develop and serve Angular application.

**Important** Angular is not AngularJS !

## Versions

- `6.0.8` `latest` → [latest](/latest/Dockerfile)

## Details

- Exposed port: 4200
- Volume and working directory: `/app`

The container will check if `package.json` is present, if it's found so `npm install` is called, either a project is created.

## Environment

- `APPNAME` is the name of the generated application, default is "hero", it's only used at generation time.
- `GENERATE` is default to "true", if other value is specified so the container will **not** generate project in case of `package.json` is not found. It is useful when you want to generate application yourself providing others options.

## Usage

Note for SELinux users, you'll need to use "privileged" option or make your application directory usable by Docker with that command:

```
$ mkdir myapp
$ chcon -Rt svirt_sandbox_file_t ./myapp 
```

Prepare an application:

```
$ mkdir myapp

# generate application named "superhero"
# use "user" option to keep you own uid:gid and be able
# to write in directory.
$ docker run --rm -it \
    -user $(id -u):$(id -g)
    -e APPNAME=superhero \
    -v $PWD/myapp:/app

```

Serve:

```
$ docker run --rm -it \
    -user $(id -u):$(id -g) \
    -v $PWD/myapp:/app \
    -p 4200:4200
```

To generate a distribution release:

```
$ docker run --rm -it \
    -user $(id -u):$(id -g) \
    -v $PWD/myapp:/app \
    -p 4200:4200 \
    ng build --prod
```
