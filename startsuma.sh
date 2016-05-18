#!/usr/bin/env bash

export specFile=${HOME}/standard/suma_mni/N27_both.spec
export t1image=${HOME}/standard/mni_icbm152_nlin_asym_09c/mni_icbm152_t1_tal_nlin_asym_09c_brain.nii
export t1image23=${HOME}/standard/mni_icbm152_nlin_asym_09c/mni_icbm152_t1_tal_nlin_asym_09c_brain_2.3mm.nii

# check all these files
for f in  specFile t1image23 t1image; do
 [ ! -r "${!f}" ]  && echo "missing $f: ${!f}! copy from /opt/ni_tools/standard_templates/" >&2 && exit 1
done

afni -niml -yesplugouts -com "SET_UNDERLAY $t1image" -dset $t1image $t1image23 &
suma -niml -spec $specFile -sv $t1image &
sleep 30

DriveSuma -com  viewer_cont \
     -key ctrl+left\
     -key F3 \
     -key F6 \
     -key:r:7 period \
     -key:r:3 z   \
     -key:r:3 t
