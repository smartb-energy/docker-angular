[![Build Status](https://travis-ci.org/smartb-energy/docker-template.svg?branch=master)](https://travis-ci.org/smartb-energy/docker-template)
#### Conventions
##### Files For Your Docker Image
Store files used by the `ADD` or `COPY` directives in your `Dockerfile` in `files` directory of this repository.  The `files` directory functions as the relative root of your container's filesystem.  An example `Dockerfile` configuration would look like this:
```
COPY files/etc/foo.conf /etc/foo.conf
```

#### Setup
```
docker-machine start default &
sudo gem install bundler
bundle
```

#### Automated Tests
```
bundle exec rspec
```

#### Build
```
docker build -t smartb/<image name>:<tag> .
```

#### Interactive Testing
```
docker run -it smartb/<image name>:<tag> /bin/bash
cat /some/file
ls /some/directory
```

#### Push
DANGER! DANGER! DANGER!
*Before* you push, check the [smartB Docker registry](https://hub.docker.com/u/smartb/dashboard) to make sure you aren't about to overwrite an existing tag for this image. If you've assigned an existing tag to your new Docker image and then do a `docker push` you *will* overwrite the exiting image in the Docker registry.  This action is *destructive* and can't be undone.
```
docker login
docker push smartb/<image name>:<tag>
```

#### Deploy
If you don't already have access to the Triton Docker hosting service, ask an administrator for access. Set up your Triton access by `export`ing the variables below or by adding the lines below to `~/.bash_profile`:
```
export DOCKER_CERT_PATH=$HOME/.sdc/docker/smartb
export DOCKER_HOST=tcp://eu-ams-1.docker.joyent.com:2376
export DOCKER_CLIENT_TIMEOUT=300
export DOCKER_TLS_VERIFY=1
```
Now download and run the Triton setup script for Docker:
```
curl -O https://raw.githubusercontent.com/joyent/sdc-docker/master/tools/sdc-docker-setup.sh

bash sdc-docker-setup.sh https://eu-ams-1.api.joyent.com smartb $HOME/.ssh/id_rsa
```
Deploy your container using the appropriate image from the Docker Hub's smartB repo:
```
docker login
docker run --memory=128m --restart="always" -t smartb/<image name>:<tag>
```

#### Cleanup
This step is important to keep from paying for unused/stopped containers:
```
docker rm $(docker ps -q -f status=exited -f status=created)
```
