#!/bin/bash

# Scripts that run the command: sct_label_utils -i <input file> -create-viewer integer1,integer2,integerN
# Makes sure that <input file> and integer1,integer2,integerN are provided in the input ports

set -e

INFO="INFO: [$(basename "$0")] "

while [ ! -f ${DY_SIDECAR_PATH_INPUTS}/input_1/input_image.nii.gz ]
    do 
    sleep 1
    echo "$INFO: Waiting for image file in first input port"
    done

while [ ! -f ${DY_SIDECAR_PATH_INPUTS}/input_2/labels.txt ]
    do 
    sleep 1
    echo "$INFO: Waiting for input labels txt file in second input port"
    done

LABELS=$(cat "${DY_SIDECAR_PATH_INPUTS}/input_2/labels.txt")

echo "$INFO: Starting sct_label_utils with input file ${DY_SIDECAR_PATH_INPUTS}/input_1/input_image.nii.gz and labels ${LABEL}"
sct_label_utils -v 1 -i ${DY_SIDECAR_PATH_INPUTS}/input_1/input_image.nii.gz -o ${DY_SIDECAR_PATH_OUTPUTS}/output_1/labels.nii.gz -create-viewer $LABELS  


