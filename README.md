# Angular ng-cli container

Angular client, known as [angular-cli](https://github.com/angular/angular-cli) and providing "ng" command to prepare, develop and serve Angular application.

This image creates easy to use development environment with auto compilation and live reload provided by "ng" command.
Check environment variables you can provide to adapt the Angular project initialisation, as stylesheet engine, application name, and so on...

Also, take a look at the bottom of this page to create and use this image in good conditions, with or without `docker-compose`.

**Important** Angular is not AngularJS !

This image is based on "node:10-alpine" image to limitate size and reduce dependencies.

## Versions

You can use that tags to get corresponding Angular version.

- 7 -> 7.3 -> 7.3.0 -> [latest](https://github.com/metal3d/docker-ng/blob/master/src/Dockerfile)

- 7.2 -> 7.2.4
- 7.2.3
- 7.2.2
- 7.2.1
- 7.2.0

- 7.1 -> 7.1.4
- 7.1.3
- 7.1.2
- 7.1.1
- 7.1.0

- 7.0 -> 7.0.7
- 7.0.6
- 7.0.5
- 7.0.4
- 7.0.3
- 7.0.2
- 7.0.1

- 6 -> 6.2 -> 6.2.9
- 6.2.8
- 6.2.7
- 6.2.6
- 6.2.5
- 6.2.4
- 6.2.3
- 6.2.2
- 6.2.1
- 6.2.0

- 6.1 -> 6.1.5
- 6.1.4
- 6.1.3
- 6.1.2
- 6.1.1
- 6.1.0

- 6.0 -> 6.0.8
- 6.0.7
- 6.0.5
- 6.0.4
- 6.0.3
- 6.0.2
- 6.0.1
- 6.0.0


## Details

- Exposed port: 4200
- Working directory: `/app`, you may mount your application path (empty or not) on that directory as volume.

The container will check if `package.json` is present, if it's found so `npm install` is called, either a project is created.

**Important**

You will want to use that image to "develop", so you'll need to have write access on your working directory. That image can work with forced uid:gid, so follow below explanation to set "uid" and "gid".

You only need to pass "`--user $(id -u):$(id -g)`" option at startup. We are using [Fixuid project](https://github.com/boxboat/fixuid) to make it possible to use local IDs inside container.

When container is started, correct rights are applied on certain directories **inside the container**. Then, the "ng" server is launched. To mount your local environment, please read the documentation til the end.

## Environment

You may change some options to set up application name, change stylesheet engine to `less` or `scss`, activate the routing... That options should be passed with `-e` option => `docker run -e OPTION_NAME=...`. You can also set them up inside your `docker-compose.yml` file in `environment` section or with an environment file.

- `APPNAME` is the name of the generated application, default is "hero", it's only used at generation time.
- `GENERATE` is default to "true", if other value is specified so the container will **not** generate project in case of `package.json` is not found. It is useful when you want to generate application yourself providing others options with "ng" command inside the container.
- `ANGULAR_STYLESHEET_FORMAT`: used at install time, one of the supported stylesheet format css, scss, less, lass... (default: css)
- `ANGULAR_HOST_CHECK`: true or false, default is "true"
- `ANGULAR_ROUTING`: used at install time to activate routing or not, default "true"

**Warning** application name, stylesheet engine, and several others options cannot be changed after the application generation. Changing that options after application create will not take effect.

## Usage

### Local directory usage

This docker image is intended to allow you to mount a local development directory inside the container. Auto compilation and live reload are activated.

You only need to mount the directory on `/app` directory.

**Your local working directory MUST exists BEFORE to mount**, if you don't do that, the local directory will be create by docker with "root" owner and the container will fail to install environment.

You can change the volume destination but you will also need to change "working directory" option. The recommendation is to leave the default one: `/app`

```bash
mkdir -p /path/to/my/app
docker run --rm -it -v /path/to/my/app:/app metal3d/ng
```

**On SELinux activated Linux environment as Fedora, CentOS...** You'll need either to use `:Z` flag on volume, or to label your working directory before to mount it.


**Recommended:** Use `:Z` as volume option:

```bash
$ mkdir myapp
$ docker run --rm -it -v $PWD/myapp:/app:Z metal3d/ng
```

Or, to label your workind directory, on you local host:

```bash
$ mkdir myapp
$ chcon -Rt svirt_sandbox_file_t ./myapp
```

### Complete example

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

### Docker-compose example


```yaml
version: "3"
services:
    ngapp:
        image: metal3d/ng:latest
        # use your own
        user: 1000:1000
        environment:
            APPNAME: my-super-app
        ports:
            - 4200:4200
        volumes:
            # be sure that ./myapp exists before to
            # use docker-compose up, and use :Z flag
            # on SELinux enabled distributions.
            - ./myapp:/app:Z
```

# Information about build

I deactivated auto-build on Docker Hub because I need to use a Makefile that automates image creation without the need to replicate Dockerfile. So, at this time, I push images as soon as I can in the environment.

I'm preparing an automated system to create latest images without the need to recompile them on my local machine.
