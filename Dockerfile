###############################################
# docker-eval                                 #
# https://github.com/SebastiaanYN/docker-eval #
###############################################

FROM ubuntu:18.04

RUN apt update
RUN apt upgrade -y
RUN apt install -y gnupg curl wget software-properties-common

#####################
# Install compilers #
#####################

# C/C++
RUN apt install -y gcc g++

# Node
RUN curl -sL https://deb.nodesource.com/setup_11.x | bash -
RUN apt install -y nodejs

# OpenJDK 11
RUN wget -q -O - https://download.java.net/java/GA/jdk11/9/GPL/openjdk-11.0.2_linux-x64_bin.tar.gz | tar -xzv
ENV PATH="/jdk-11.0.1/bin:${PATH}"

# Python
RUN apt install -y python python3.6

# Dart
RUN apt install apt-transport-https
RUN sh -c 'curl https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -'
RUN sh -c 'curl https://storage.googleapis.com/download.dartlang.org/linux/debian/dart_stable.list > /etc/apt/sources.list.d/dart_stable.list'
RUN apt update
RUN apt install dart

# Go
RUN apt install -y golang-go

# Ruby
RUN apt install -y ruby

# Haskell
RUN apt install -y haskell-platform

# C#
RUN wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb
RUN dpkg -i packages-microsoft-prod.deb
RUN add-apt-repository universe
RUN apt install -y apt-transport-https
RUN apt update
RUN apt install -y dotnet-sdk-2.2
RUN dotnet new console -o /var/eval/cs

# Kotlin
RUN wget https://github.com/JetBrains/kotlin/releases/download/v1.3.11/kotlin-compiler-1.3.11.zip && unzip kotlin-compiler-1.3.11.zip
ENV PATH="/kotlinc/bin:${PATH}"

# Scala
RUN apt install -y scala

# TypeScript
RUN npm install -g typescript

# Rust
RUN mkdir -p /opt/rust
RUN curl https://sh.rustup.rs -sSf | HOME=/opt/rust sh -s -- --no-modify-path -y
RUN chmod -R 777 /opt/rust

# Clojure
RUN curl -O https://download.clojure.org/install/linux-install-1.10.0.411.sh
RUN chmod +x linux-install-1.10.0.411.sh
RUN ./linux-install-1.10.0.411.sh
RUN clojure -e '(println "Installed")'

#####################
# Setup environment #
#####################

WORKDIR /var/eval
COPY evaluate.js .
COPY compilers.json .
ENV DOCKER=true

CMD ["node", "evaluate.js"]
