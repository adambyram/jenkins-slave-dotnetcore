# This Dockerfile is used to build an image containing a .NET Core Jenkins slave

FROM ubuntu:17.10
MAINTAINER Adam Byram <abyram@gmail.com>

# Get curl
RUN apt-get update 
RUN apt-get install -y curl

# Add Microsoft's key
RUN curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
RUN mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg

# Add Microsoft's Ubuntu package feed
RUN sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/microsoft-ubuntu-artful-prod artful main" > /etc/apt/sources.list.d/dotnetdev.list'

# Install .NET Core SDK
RUN apt-get install -y apt-transport-https
RUN apt-get update
RUN apt-get install -y dotnet-sdk-2.1.4

# Upgrade and Install packages for Jenkins/SSH
RUN apt-get update && apt-get -y upgrade && apt-get install -y git openssh-server && apt-get install -y openjdk-8-jdk

# Prepare container for ssh
RUN useradd -ms /bin/bash jenkins
RUN mkdir /var/run/sshd && echo "jenkins:jenkins" | chpasswd

ENV CI=true
EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]