#!/bin/bash

restore_from_checkpoint() {
	umount -R /proc
	mount -t proc proc /proc
	criu restore --tcp-established -j -v4 -o ${CR_LOG_DIR}/${RESTORE_LOG_FILE}
}

if [ -f ${CR_LOG_DIR}/${DUMP_LOG_FILE} ]; then
	# checkpointing is already done, restore the app from the checkpoint
	echo "INFO: Found checkpoint, restoring the app from the checkpoint"
	restore_from_checkpoint
else
	/opt/app/app.sh
fi
