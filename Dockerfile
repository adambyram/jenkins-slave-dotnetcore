# This Dockerfile is used to build an image containing a .NET Core Jenkins slave

FROM ubuntu:18.04
MAINTAINER Adam Byram <abyram@gmail.com>

# Get curl
RUN apt-get update 
RUN apt-get install -y curl gpg

# Add Microsoft's key
# RUN curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
# RUN mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg

# Add Microsoft's Ubuntu package feed
RUN apt-get install wget
RUN wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
RUN dpkg -i packages-microsoft-prod.deb

# Install .NET Core SDK
RUN apt-get install software-properties-common -y
RUN add-apt-repository universe
RUN apt-get install -y apt-transport-https
RUN apt-get update
RUN apt-get install -y dotnet-sdk-3.0

# Upgrade and Install packages for Jenkins/SSH
RUN apt-get update && apt-get -y upgrade && apt-get install -y git openssh-server && apt-get install -y openjdk-8-jdk

# Prepare container for ssh
RUN useradd -ms /bin/bash jenkins
RUN mkdir /var/run/sshd && echo "jenkins:jenkins" | chpasswd

ENV CI=true
EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
