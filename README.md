# fish2/docker-storman
[![](https://images.microbadger.com/badges/image/fish2/docker-storman.svg)](https://microbadger.com/images/fish2/docker-storman "Get your own image badge on microbadger.com")

**Purpose**
Create a container running the Adaptec Maxview Storage Manager application and the necessary daemons (cimserver and agent).

With this container, you can manage an Adaptec RAID adapter on the dockerhost. It is based on phusion/baseimage:0.11 and Adaptec MSM version V3.01-23531.

It should be run with --privileged, in order to have access to the hardware and insert the necessary kernel modules.

**Run Command**
Listening on port 8443 (user=root, password=docker):

	docker run -d --name storman --restart always --privileged --user root -e TZ=<timezone> -p 8443:8443 fish2/docker-storman


**Build with Custom Password**
Build first edditing the password arg

	docker build https://raw.githubusercontent.com/Fish2/docker-storman/master/Dockerfile -t fish2/docker-storman --build-arg password={your password here}

Then run

	docker run -d --name storman --restart always --privileged --user root -e TZ=<timezone> -p 8443:8443 fish2/docker-storman

**Credits**
fish2
