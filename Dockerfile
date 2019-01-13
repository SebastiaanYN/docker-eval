###############################################
# docker-eval                                 #
# https://github.com/SebastiaanYN/docker-eval #
###############################################

FROM ubuntu:18.04

RUN apt-get update
RUN apt-get upgrade -y

RUN apt-get install -y gnupg
RUN apt-get install -y curl
RUN apt-get install -y wget
RUN apt-get install -y software-properties-common

#####################
# Install compilers #
#####################

# C/C++
RUN apt-get install -y gcc
RUN apt-get install -y g++

# Node
RUN curl -sL https://deb.nodesource.com/setup_11.x | bash -
RUN apt-get install -y nodejs

# OpenJDK 11
RUN wget -q -O - https://download.java.net/java/GA/jdk11/13/GPL/openjdk-11.0.1_linux-x64_bin.tar.gz | tar -xzv
ENV PATH="/jdk-11.0.1/bin:${PATH}"

# Python
RUN apt-get install -y python
RUN apt-get install -y python3.6

# Dart
RUN apt-get install apt-transport-https
RUN sh -c 'curl https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -'
RUN sh -c 'curl https://storage.googleapis.com/download.dartlang.org/linux/debian/dart_stable.list > /etc/apt/sources.list.d/dart_stable.list'
RUN apt-get update
RUN apt-get install dart

# Go
RUN apt-get install -y golang-go

# Ruby
RUN apt-get install -y ruby

# Haskell
RUN apt-get install -y haskell-platform

# C#
RUN wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb
RUN dpkg -i packages-microsoft-prod.deb
RUN add-apt-repository universe
RUN apt-get install apt-transport-https
RUN apt-get update
RUN apt-get install -y dotnet-sdk-2.2

# Install additional languages and libraries
RUN npm install -g typescript

#####################
# Setup environment #
#####################

WORKDIR /var/eval
COPY evaluate.js /var/eval
COPY compilers.json /var/eval
ENV DOCKER=true

CMD ["node", "/var/eval/evaluate.js"]
