#!/usr/bin/env bash

C_NONE="\033[0m"
C_RED="\033[1;31m"
C_GREEN="\033[1;32m"
C_PURPLE="\033[1;35m"

DOCKER_NAME="docker-evaluate"
CONTAINER_NAME="docker-evaluate-test"

# Start container
docker build -t $DOCKER_NAME .
docker run --name $CONTAINER_NAME --rm -i -d $DOCKER_NAME

# Define all compiler checks
declare -a COMPILERS=(
  "gcc --version"
  "g++ --version"
  "node -v"
  "npm -v"
  "java -version"
  "python -V"
  "python3 -V"
  "dart --version"
  "go version"
  "ruby --version"
  "ghc --version"
  "dotnet --version"
  "kotlinc -version"
  "scala -version"
  "tsc -v"
  "perl -v"
  # "HOME=/opt/rust /opt/rust/.cargo/bin/rustc -V" Rust doesn"t quite work, need to look for a better install
  "clojure -h"
)

# Go through all compiler checks
for COMPILER in "${COMPILERS[@]}"
do
  echo ""
  echo -e "${C_PURPLE}Running: $COMPILER${C_NONE}"

  # Execute compiler check
  docker exec -t $CONTAINER_NAME $COMPILER

  # Check the status code
  if [ $? -eq 0 ]
  then
    echo -e "${C_GREEN}Passed${C_NONE}"
  else
    FAIL_CODE=$?

    echo ""
    echo -e "${C_RED}'$COMPILER' failed with code $FAIL_CODE${C_NONE}"
    echo ""

    # Stop container and exit with the status of the compiler check
    docker stop $CONTAINER_NAME
    exit $FAIL_CODE
  fi
done

# Stop container
echo ""
docker stop $CONTAINER_NAME
exit
