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

ts=$(date "+%Y%m%d%H%M%S")
BUILD_LOG="build-${ts}.log"

function cleanup() {
	docker container prune -f
	docker image prune -f

	docker rmi $(docker images | grep watsonex-springboot | awk '{ print $3 }')
	echo
}

function timediff() {
	ssec=`date --utc --date "$1" +%s`
	esec=`date --utc --date "$2" +%s`

	diffsec=$(($esec-$ssec))
	echo $diffsec
}

function getdate() {
	date "+%Y-%m-%d %H:%M:%S"
}

function log() {
	echo $@ 2>&1 | tee -a ${BUILD_LOG}
}

function docker_build() {
	image_name=$1
	file_name=$2

	sdate=$(getdate)
	log -n "${image_name}: Building docker image..."
	docker build --pull -t ${image_name} -f ${file_name} . 2>>${BUILD_LOG} >>${BUILD_LOG}
	edate=$(getdate)
	tdiff=$(timediff "$sdate" "$edate")
	log "done"
	log "${image_name}: Build took $((tdiff/60)) mins and $((tdiff%60)) secs"
	log "============================================================================="
}

cleanup

# Build all the variants

# Build the alpine glibc base image first
docker_build myalpine:3.10-glibc Dockerfile.alpine.glibc

# OpenJ9 Builds
docker_build watsonex-springboot:openj9-v8.slim Dockerfile.openj9.v8.slim
docker_build watsonex-springboot:openj9-v8 Dockerfile.openj9.v8
docker_build watsonex-springboot:openj9-v11.slim Dockerfile.openj9.v11.slim
docker_build watsonex-springboot:openj9-v11 Dockerfile.openj9.v11
docker_build watsonex-springboot:openj9-v11.jlink Dockerfile.openj9.v11.jlink
docker_build watsonex-springboot:openj9-v11.jlink.scc Dockerfile.openj9.v11.jlink.scc


# Hotspot builds
docker_build watsonex-springboot:hotspot-v8.slim Dockerfile.hotspot.v8.slim
docker_build watsonex-springboot:hotspot-v8 Dockerfile.hotspot.v8
docker_build watsonex-springboot:hotspot-v11.slim Dockerfile.hotspot.v11.slim
docker_build watsonex-springboot:hotspot-v11 Dockerfile.hotspot.v11
docker_build watsonex-springboot:hotspot-v11.jlink Dockerfile.hotspot.v11.jlink

log
log
docker images | grep -e "TAG" -e "watsonex" | sort --key=7 | tee -a ${BUILD_LOG}
