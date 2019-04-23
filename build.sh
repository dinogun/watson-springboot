#!/bin/bash

# Build all the variants

# OpenJ9 Builds
docker build -t watson-springboot:openj9-v8.slim -f Dockerfile.openj9.v8.slim .
docker build -t watson-springboot:openj9-v8 -f Dockerfile.openj9.v8 .

docker build -t watson-springboot:openj9-v11.slim -f Dockerfile.openj9.v11.slim .
docker build -t watson-springboot:openj9-v11 -f Dockerfile.openj9.v11 .
docker build -t watson-springboot:openj9-v11.jlink -f Dockerfile.openj9.v11.jlink .


# Hotspot builds
docker build -t watson-springboot:hotspot-v8.slim -f Dockerfile.hotspot.v8.slim .
docker build -t watson-springboot:hotspot-v8 -f Dockerfile.hotspot.v8 .

docker build -t watson-springboot:hotspot-v11.slim -f Dockerfile.hotspot.v11.slim .
docker build -t watson-springboot:hotspot-v11 -f Dockerfile.hotspot.v11 .
