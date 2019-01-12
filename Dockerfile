FROM node:10

# Install compilers
RUN apt-get update
RUN apt-get upgrade -y

# Install OpenJDK 11
RUN wget -q -O - https://download.java.net/java/GA/jdk11/13/GPL/openjdk-11.0.1_linux-x64_bin.tar.gz | tar -xzv
ENV PATH="/jdk-11.0.1/bin:${PATH}"

RUN apt-get install -y g++

# Setting up environment
WORKDIR /var/eval
COPY evaluate.js /var/eval
COPY compilers.json /var/eval
ENV DOCKER=true

CMD ["node", "/var/eval/evaluate.js"]
