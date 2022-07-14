# sct_label_utils

Spinal Cord Toolbox simple GUI utility to label spinal cord images

## Basic concept

An osparc-ui module consists of two services, a web proxy ```web``` and the actual application ```app```.  The ```web``` service acts only as a proxy for integration into the osparc platform. The ```app``` service consists of the X11 based GUI application that should be accessible via the osparc iframe and some additional supporting programs:
- [supervisord](http://supervisord.org/): to control the processes in the container
- [xtigervnc](https://tigervnc.org/): VNC client/server application with embedded X-server
- [novnc](https://novnc.com/info.html): opensource javascript vnc client
- [openbox](http://openbox.org/wiki/Main_Page): Minimal window manager

## Usage


Build the module:
```console
$ make build
```
To run locally at and visit http://127.0.0.1:28080
```console
make run-local
```
To publish in local throw-away registry:
```console
make publish-local
```

## Workflow

1. The application should be installed via modification of the ```Dockerfile``` in ```sct_label_utils/app```
2. The  ```[program:app]``` section in ```supervisord.conf``` in ```sct_label_utils/app/config```  needs to be modified to accomodate to the correct command line for the program.

## Versioning
Service version is updated with ``make version-*``

## CI/CD Integration
A template ci config file is created in```.github/.yml```)

### Github

The required CI is already packaged.
To build and push to the internal registry you must add it to the [oSparc/docker-publisher-osparc-services](https://git.speag.com/oSparc/docker-publisher-osparc-services) repository.