#!/bin/bash
#
# (C) Copyright IBM Corporation 2019, 2019
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Build all the variants

# OpenJ9 Builds
docker build -t watsonex-springboot:openj9-v8.slim -f Dockerfile.openj9.v8.slim .
docker build -t watsonex-springboot:openj9-v8 -f Dockerfile.openj9.v8 .

docker build -t watsonex-springboot:openj9-v11.slim -f Dockerfile.openj9.v11.slim .
docker build -t watsonex-springboot:openj9-v11 -f Dockerfile.openj9.v11 .
docker build -t watsonex-springboot:openj9-v11.jlink -f Dockerfile.openj9.v11.jlink .
docker build -t watsonex-springboot:openj9-v11.jlink.scc -f Dockerfile.openj9.v11.jlink.scc .


# Hotspot builds
docker build -t watsonex-springboot:hotspot-v8.slim -f Dockerfile.hotspot.v8.slim .
docker build -t watsonex-springboot:hotspot-v8 -f Dockerfile.hotspot.v8 .

docker build -t watsonex-springboot:hotspot-v11.slim -f Dockerfile.hotspot.v11.slim .
docker build -t watsonex-springboot:hotspot-v11 -f Dockerfile.hotspot.v11 .
