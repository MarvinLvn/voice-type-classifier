#!/bin/bash
fwav="False"
fdir="False"
# check presence of wav and sub dirs

if ls data/*.wav 1> /dev/null 2>&1
then
    fwav="True"
fi
if [ $(ls -l data/| grep "^d" | wc -l ) -ne 0 ]
then
    fdir="True"
fi
#if any wav and sub dir exit
if [ $fwav = "False" ] && [ $fdir = "False" ]
then
    echo "no data to analyse"
    exit 1
fi
# if wav and subdir exit
if [ $fwav = "True" ] && [ $fdir = "True" ]
then
    echo "please, have a root directory with wav files or subdirectory with wav files, not the two"
    exit 1
fi

# if only wav files, run vtc
if [ $fwav = "True" ]
then
    voice_type_classifier/apply.sh data --device=${1} --batch=${2}
    mv output_voice_type_classifier/data/all.rttm data/
    exit 0
fi

# if only sub dir, one batch per subdir
for subdir in $(ls data/)
do
    dir=data/${subdir}
    if [ $(ls -l ${dir}/| grep "^d" | wc -l ) -ne 0 ]
    then
        echo ${dir} contain subdirectory, pass
        continue
    fi
    # check the presence of wav file in subdir
    if ls ${dir}/*.wav 1> /dev/null 2>&1
    then
        voice_type_classifier/apply.sh ${dir} --device=${1} --batch=${2}
        mv output_voice_type_classifier/${subdir}/all.rttm ${dir}
    else
        echo ${dir} does not contain any wavs files
    fi
done