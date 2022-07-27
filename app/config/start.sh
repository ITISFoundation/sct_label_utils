#!/bin/bash

# Scripts that run the command: sct_label_utils -i <input file> -create-viewer integer1,integer2,integerN
# Makes sure that <input file> and integer1,integer2,integerN, which are required, are provided in the input ports
# It displays different dialogs to the user, depending if it's the first time the command is launched or not

set -e

INFO="INFO: [$(basename "$0")] "

# If output is not present -> first run
if [ ! -f ${DY_SIDECAR_PATH_OUTPUTS}/output_1/labels.nii.gz ]; then
    echo "$INFO: First time running the app: checking if required inputs are available"
    python3 -u check_inputs.py
else # Asks the user if the labelling task should be re-launched
    echo "$INFO: Re-running app"
    python3 -u check_inputs.py --re_run
fi

LABELS=$(cat "${DY_SIDECAR_PATH_INPUTS}/input_2/labels.txt")

echo "$INFO: Starting sct_label_utils with input file ${DY_SIDECAR_PATH_INPUTS}/input_1/input_image.nii.gz and labels ${LABELS}"
sct_label_utils -v 1 -i ${DY_SIDECAR_PATH_INPUTS}/input_1/input_image.nii.gz -o ${DY_SIDECAR_PATH_OUTPUTS}/output_1/labels.nii.gz -create-viewer $LABELS  

exit 8 # Return an unexpected exit code, so supervisord restarts the app