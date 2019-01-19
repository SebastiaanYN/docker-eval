#!/usr/bin/env bash

DOCKER_NAME="docker-evaluate"
CONTAINER_NAME="docker-evaluate-test"

# Build and start container
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
  # "HOME=/opt/rust /opt/rust/.cargo/bin/rustc -V" Rust doesn't quite work, need to look for a better install
  "clojure -h"
)

# Go through all compiler checks
for COMPILER in "${COMPILERS[@]}"
do
  echo ""
  echo "Running: $COMPILER"

  # Execute compiler check
  docker exec -t $CONTAINER_NAME $COMPILER

  # Check the status code
  if [ $? -eq 0 ]
  then
    echo "Passed"
  else
    FAIL_CODE=$?

    echo ""
    echo "'$COMPILER' failed with code $FAIL_CODE"
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
