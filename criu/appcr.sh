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
# Wrapper script that is set as the Docker entry-point.
# In the checkpoint docker image, it just call the app
# In the restore docker image, it helps restore from the stored checkpoint.

restore_from_checkpoint() {
	start_us=$(($(date +%s%N)/1000))
	sudo umount -R /proc 
	sudo mount -t proc proc /proc
	pre_criu_us=$(($(date +%s%N)/1000))
	diff_us=$((${pre_criu_us}-${start_us}))
	echo
	echo "PRE CRIU Setup Time: ${diff_us} us"
	echo
	sudo criu restore --tcp-established -j -v4 -o ${CR_LOG_DIR}/${RESTORE_LOG_FILE}
}

if [ -f ${CR_LOG_DIR}/${DUMP_LOG_FILE} ]; then
	# checkpointing is already done, restore the app from the checkpoint
	echo "INFO: Found checkpoint, restoring the app from the checkpoint"
	restore_from_checkpoint
else
	/opt/app/app.sh
fi
