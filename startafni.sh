#!/usr/bin/env bash

export t1image=${HOME}/standard/mni_icbm152_nlin_asym_09c/mni_icbm152_t1_tal_nlin_asym_09c_brain.nii
export t1image23=${HOME}/standard/mni_icbm152_nlin_asym_09c/mni_icbm152_t1_tal_nlin_asym_09c_brain_2.3mm.nii

[ ! -r $t1image ] && echo "missing t1: $t1image! consider cp -r /opt/ni_tools/standard_templates/ ~/standard" >&2
[ ! -r $t1image23 ] && echo "missing t1: $t1image23! consider cp -r /opt/ni_tools/standard_templates/ ~/standard" >&2

afni -yesplugouts -com "SET_UNDERLAY $t1image" -dset $t1image $t1image23 $1 &
