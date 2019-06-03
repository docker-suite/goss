# ![](https://github.com/docker-suite/artwork/raw/master/logo/png/logo_32.png) Goss
![License: MIT](https://img.shields.io/github/license/docker-suite/goss.svg?color=green&style=flat-square)

> [Goss](https://github.com/aelsabbahy/goss/) is a YAML based [serverspec](http://serverspec.org/) alternative tool for validating a server’s configuration. It eases the process of writing tests by allowing the user to generate tests from the current system state. Once the test suite is written they can be executed, waited-on, or served as a health endpoint.

## ![](https://github.com/docker-suite/artwork/raw/master/various/pin/png/pin_16.png) Usage:

#### Setup:

```bash
# cd into the directory with your Dockerfile and build your image.
docker build -t MyApp .
```

#### Create tests:

```bash
# This is an example for a docker image named MyApp:
docker run --rm -it \
    -v "$(pwd)":/goss \
    -v /var/run/docker.sock:/var/run/docker.sock \
    dsuite/goss edit MyApp

goss a process MyApp
goss a user root
goss a user user2
goss a file /dir
goss a file /dir/file
goss a http http://localhost:8080
exit

# this will generate a goss.yaml file in your current folder.
```
>See the [Goss manual](https://github.com/aelsabbahy/goss/blob/master/docs/manual.md#add-a---add-system-resource-to-test-suite) for more details

#### Run tests:

```bash
docker run --rm -it \
    -v "$(pwd)":/src \
    -v /var/run/docker.sock:/var/run/docker.sock \
iorubs/dgoss run app
```

## ![](https://github.com/docker-suite/artwork/raw/master/various/pin/png/pin_16.png) More examples:

Whant to see goss in action, visit [goss-examples](https://github.com/docker-suite/goss-examples)