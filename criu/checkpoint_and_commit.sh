#!/bin/bash

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
prep_image_id=$(docker run --cap-add AUDIT_CONTROL --cap-add CHOWN --cap-add DAC_OVERRIDE --cap-add DAC_READ_SEARCH --cap-add FOWNER --cap-add FSETID --cap-add KILL --cap-add NET_ADMIN --cap-add SETGID --cap-add SETUID --cap-add SETPCAP --cap-add SYS_ADMIN --cap-add SYS_CHROOT --cap-add SYS_PTRACE --cap-add SYS_RESOURCE --security-opt apparmor=unconfined --security-opt seccomp=unconfined -d watson-springboot:openj9-v8.criu-prep)
echo

# Wait for the app to come up
echo "#################### Waiting for App to come up #####################"
sleep 10
echo

# Now checkpoint the app
echo "#################### Check-Pointing the App #####################"
docker exec -it ${prep_image_id} criu dump -t 9 --tcp-established -j --leave-running -v4 -o /root/appcr/cr_logs/dump.log
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
test_cont=$(docker run --cap-add AUDIT_CONTROL --cap-add CHOWN --cap-add DAC_OVERRIDE --cap-add DAC_READ_SEARCH --cap-add FOWNER --cap-add FSETID --cap-add KILL --cap-add NET_ADMIN --cap-add SETGID --cap-add SETUID --cap-add SETPCAP --cap-add SYS_ADMIN --cap-add SYS_CHROOT --cap-add SYS_PTRACE --cap-add SYS_RESOURCE --security-opt apparmor=unconfined --security-opt seccomp=unconfined -d -p 8080:8080 watson-springboot:openj9-v8.criu-checkpoint)
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
