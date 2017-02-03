FROM phusion/baseimage:0.9.19
MAINTAINER fish2

# Set correct environment variables
ARG password
ENV JAVA_HOME /usr/StorMan/jre
ENV DEBIAN_FRONTEND="noninteractive"

# Install Packages and Upgrade as baseimage 0.9.19
RUN apt-get update && apt-get upgrade -y -o Dpkg::Options::="--force-confold" && apt-get install -y unzip net-tools

# Disable SSH
RUN rm -rf /etc/service/sshd /etc/my_init.d/00_regen_ssh_host_keys.sh

# Set Root Password Build With --build-arg password={put your password here}
RUN sh -c "echo root:${password:-docker} |chpasswd"

# Download StorMan Packages
RUN curl -o /tmp/msm_linux.tgz http://download.adaptec.com/raid/storage_manager/msm_linux_x64_v2_03_22476.tgz && tar -xzvf /tmp/msm_linux.tgz -C /tmp

# Install StorMan
RUN dpkg -i /tmp/manager/StorMan-2.03-22476_amd64.deb

# Clean Up
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Ports, Entry Points and Volumes
EXPOSE 8443
ENTRYPOINT /etc/init.d/stor_agent start && /etc/init.d/stor_cimserver start && /usr/StorMan/apache-tomcat/bin/catalina.sh run