FROM phusion/baseimage:0.10.0

# set maintainer label
LABEL maintainer="fish2"

# Set correct environment variables
ARG password
ENV JAVA_HOME=/usr/StorMan/jre

# Install Update and Install Packages
RUN apt-get update && apt-get remove --purge -y openssh-client openssh-server openssh-sftp-server && DEBIAN_FRONTEND=noninteractive apt-get upgrade -y -o Dpkg::Options::="--force-confold" && DEBIAN_FRONTEND=noninteractive apt-get install -y net-tools unzip && \

# Disable SSH
rm -rf /etc/service/sshd /etc/my_init.d/00_regen_ssh_host_keys.sh && \

# Set Root Password Build With --build-arg password={put your password here}
sh -c "echo root:${password:-docker} |chpasswd" && \

# Download StorMan Packages
curl -o /tmp/msm_linux.tgz http://download.adaptec.com/raid/storage_manager/msm_linux_x64_v2_05_22932.tgz && \

tar -xf /tmp/msm_linux.tgz -C /tmp && \

# Install StorMan
DEBIAN_FRONTEND=noninteractive dpkg -i /tmp/manager/StorMan-2.05-22932_amd64.deb && \

# Clean Up
apt-get remove --purge -y curl && apt-get autoremove -y && apt-get clean && \

rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Ports, Entry Points and Volumes
EXPOSE 8443
ENTRYPOINT /etc/init.d/stor_agent start && /etc/init.d/stor_cimserver start && /usr/StorMan/apache-tomcat/bin/catalina.sh run
