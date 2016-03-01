# docker-ng

Angular 2 client, known as [angular-cli](https://github.com/angular/angular-cli) and providing "ng" command

# Details

Image provides exposed port: 4200 (app) and 49152 (livereload).

The default working directory is "/project", so you **should link you workspace to that directory** (see "How to use" section).

The entrypoint is "ng", so you may pass command without invoking "ng".

# How to use

You must "bootstrap" a project with "new" command. For example, create a project directory at "`~/testapp`":

```bash
mkdir ~/testapp
cd ~/testapp
docker run --rm -it     \
    -u $(id -u):$(id-g) \
    -v $(pwd):/project metal3d/ng \
    new myproject
```

Afterward you may launch the default server from command line or using docker-compose. Note that "ng" creates a "app" directory and **you must link that directory, and not the current workspace**.

Command line example:

```bash
docker run --rm -it -u $(id -u):$(id -g) \
    -v $(pwd)/app:/project      \
    -p 4200:4200 -p 49152:49152 \
    metal3d/ng serve
```

"`docker-compose.yml`" example file, see the "user" section and the "volumes" that bind "app" to "/project":

```yaml
version: '2':
services:
    myproject:
        image: metal3d/ng
        command: serve
        ports:
        - 4200:4200
        - 49152:49152
        user: 1000:1000
        volumes:
        - ./app:/project
```

# Generate files:

While your project evolves, you may need to generate other files. Use the docker command to call "g" or "generate" using **your workspace volume, not "app"**.

Example, create a new component:

```bash
docker run --rm -it 
    -v $(pwd):/project   \
    -u $(id -u):$(id -g) \
    metal3d/ng g component my-new-component
```

