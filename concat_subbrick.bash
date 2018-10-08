#!/usr/bin/env bash
set -euo pipefail
trap 'e=$?; [ $e -ne 0 ] && echo "$0 exited in error"' EXIT

# wrap around 3dbucket and 3drefit
# extract a subbrick from a list of nifti 
# label with luna ids

# input:
#   1) prefix
#   2) a glob. eg /Volumes/Zeus/preproc/pet_frog/MHTask_pet/*/contrasts/Frogger/hashContrasts_FM_GAM_stats2+tlrc.HEAD
#   3) [optional] sub brick (0 if not provided)

[ $# -lt 2 ] && echo "USAGE: $0 prefix 'gl*ob' [subbrik]" >&2 && exit 1

prefix="$1"; shift
glob="$1"; shift
[ $# -ne 0 ] && subbrik="$1" || subbrik=0

[ -z "$(ls $patt)" ] && echo "bad pattern provided ($patt). consider .HEAD?" >&2 && exit 1

ids="$(ls $patt | perl -lne 'print $& if m/\d{5}_\d{8}/')"
[ -z "$ids" ] && echo "could not find lunaid_date in provided pattern" >&2 && exit 1

if [ -r "$prefix" ]; then
   echo "3dbucket: combine"
   3dbucket -prefix "$prefix" $(ls $patt | sed "s/$/[$subrick]/")
   echo "3drefit: relabel"
   3drefit -relabel_all_str "$ids" "$prefix"
else 
   echo "rm $prefix # to regenerate; skipping 3dbucket and 3drefit"
fi

afni "$prefix" -com 'OPEN axialgraph'

