#!/bin/bash

# Scripts that run the command: sct_label_utils -i <input file> -create-viewer integer1,integer2,integerN
# Makes sure that <input file> and integer1,integer2,integerN are provided in the input ports

set -e

INFO="INFO: [$(basename "$0")] "
echo "$INFO: Checking if required inputs are available"

python3 check_inputs.py


echo "$INFO: Starting sct_label_utils with input file ${DY_SIDECAR_PATH_INPUTS}/input_1/input_image.nii.gz and labels ${LABEL}"
sct_label_utils -v 1 -i ${DY_SIDECAR_PATH_INPUTS}/input_1/input_image.nii.gz -o ${DY_SIDECAR_PATH_OUTPUTS}/output_1/labels.nii.gz -create-viewer $LABELS  


