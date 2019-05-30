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
# Use this script to create a checkpointed docker image that is pushed to DockerHub.
#

# List of all docker capabilities needed by CRIU,
# AUDIT_CONTROL
# CHOWN (default)
# DAC_OVERRIDE (default)
# DAC_READ_SEARCH
# FOWNER (default)
# FSETID (default)
# KILL (default)
# NET_ADMIN
# SETGID (default)
# SETUID (default)
# SETPCAP (default)
# SYS_ADMIN
# SYS_CHROOT (default)
# SYS_PTRACE
# SYS_RESOURCE
# apparmor=unconfined
# seccomp=unconfined

# However some of these are on by default, so we use the pruned list below.
DOCKER_CAPABILITIES="--cap-add AUDIT_CONTROL \
                     --cap-add DAC_READ_SEARCH \
                     --cap-add NET_ADMIN \
                     --cap-add SYS_ADMIN \
                     --cap-add SYS_PTRACE \
                     --cap-add SYS_RESOURCE \
                     --security-opt apparmor=unconfined \
                     --security-opt seccomp=unconfined"

# Build the application docker image
echo
echo "#################### Building the App Docker Image #####################"
docker build -t watson-springboot:openj9-v8 -f Dockerfile.openj9.v8 .
echo

# Build a Docker image with the target application and CRIU libraries. 
echo "#################### Build the App+CRIU Docker Image #####################"
docker build -t watson-springboot:openj9-v8.criu-prep -f Dockerfile.criu.prep .
echo

# Now run the app to prep for checkpointing
echo "#################### Run the App #####################"
prep_image_id=$(docker run ${DOCKER_CAPABILITIES} -d watson-springboot:openj9-v8.criu-prep)
echo

# Wait for the app to come up
echo "#################### Waiting for App to come up #####################"
sleep 10
echo

# Now checkpoint the app
echo "#################### Check-Pointing the App #####################"
# PID no of the java process in the container above, it cannot be 1 (per CRIU), so we add a dummy shell script
# to switch to a higher PID. In this case it is always 9, so hard coding it.
JAVA_PID=9
docker exec -it ${prep_image_id} criu dump -t ${JAVA_PID} --tcp-established -j --leave-running -v4 -o /root/appcr/cr_logs/dump.log
echo

# Now commit the docker image with the checkpoint
echo "#################### Commiting the Check-Pointed App #####################"
docker commit ${prep_image_id} watson-springboot:openj9-v8.criu-checkpoint
echo

# Stop the running container
echo "#################### Stop the Running App #####################"
docker stop ${prep_image_id}
echo

# Test the commited check pointed app
echo "#################### Test the Check-Pointed App #####################"
test_cont=$(docker run ${DOCKER_CAPABILITIES} -d -p 8080:8080 watson-springboot:openj9-v8.criu-checkpoint)
errors=$(docker logs ${test_cont} 2>&1 | tee criu.log | grep -i "error")
rm -f criu.log
if [ ! -z "${errors}" ]; then
	echo "CRIU error: app did not start"
	exit -1
else
	echo "CRIU Success: Pushing app to DockerHub"
fi

# Stop the test container
echo "#################### Stop the test container #####################"
docker stop ${test_cont}
echo

# Now push the checkpointed image to DockerHub
echo
echo "#################### Push the Checkpointed App to DockerHub #####################"
docker tag watson-springboot:openj9-v8.criu-checkpoint dinogun/watson-springboot:openj9-v8.criu-checkpoint
docker push dinogun/watson-springboot:openj9-v8.criu-checkpoint
echo
