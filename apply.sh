#!/usr/bin/env bash

start=`date +%s`

# check if script is started via SLURM or bash
# if with SLURM: there variable '$SLURM_JOB_ID' will exist
# `if [ -n $SLURM_JOB_ID ]` checks if $SLURM_JOB_ID is not an empty string
if [[ -n $SLURM_JOB_ID ]]; then
    # check the original location through scontrol and $SLURM_JOB_ID
    THISDIR=$(scontrol show job $SLURM_JOBID | awk -F= '/Command=/{print $2}' | sed -e 's/\s.*$//')
    THISDIR=$(dirname $THISDIR)
else
    # otherwise: started with bash. Get the real location.
    THISDIR="$( cd "$( dirname "$0" )" && pwd )"
fi

if [[ -n $CUDA_VISIBLE_DEVICES ]]; then
    CUDA_VISIBLE_DEVICES=1
fi;


# Check sox has been installed
sox_installed=$(sox --version)
sox_installed=${sox_installed:0:3}
if [ $sox_installed != "sox" ]; then
    echo "Sox can't be found. Please intall sox before running this script"
    exit
fi;

# Check pyannote-audio has been installed
pyannote_installed=$(pyannote-audio --version)
pyannote_installed=${pyannote_installed:0:14}
if [ $pyannote_installed != "pyannote-audio" ]; then
    echo "pyannote-audio can't be found."
    echo "Check that you activated your conda environment and than you installed pyannote-audio."
    exit
fi;

if [ $# -ge 4 ]; then
    echo "Wrong call. Must provide 2 arguments at most."
    echo "Example :"
    echo "./apply.sh /path/to/my/folder (--device=gpu) (--batch=128)"
    exit
fi;


# Parsing arguments such as provided by the user
DEVICE="cpu"
BATCH="32"
for i in {2..3}; do
    ARG=${!i}
    if [ "${ARG%=*}" == "--device" ]; then
        DEVICE=${ARG#*device=}
    elif [ "${ARG%=*}" == "--batch" ]; then
        BATCH=${ARG#*batch=}
    fi
done

TARGET_PATH=$(echo "$(cd "$(dirname "$1")"; pwd)/$(basename "$1")")
if [[ "${TARGET_PATH}" == *.wav ]]; then
    # We want to apply the model on a single wav
    EXT=""
else
    # We want to apply the model on a folder containing wav files
    EXT="/*.wav"
fi

if [[ "$(ls -A ${TARGET_PATH}$EXT)" ]]; then

    bn=$(basename ${TARGET_PATH})

    if [[ "${TARGET_PATH}" == *.wav ]]; then
        bn=${bn/.wav/}
        DB_PATH="$(dirname ${TARGET_PATH})/{uri}.wav"
    else
        DB_PATH="${TARGET_PATH}/{uri}.wav"
    fi;


    echo "Creating config for pyannote."
    # Create pyannote_tmp_config containing all the necessary files
    rm -rf $THISDIR/pyannote_tmp_config/$bn
    mkdir -p $THISDIR/pyannote_tmp_config/$bn

    # Create database.yml
    echo "Databases:
    $bn: ${DB_PATH}

Protocols:
  $bn:
    SpeakerDiarization:
      All:
        test:
          annotated: $THISDIR/pyannote_tmp_config/$bn/$bn.uem" > $THISDIR/pyannote_tmp_config/$bn/database.yml

    # Create .uem file
    for audio in $(ls -A ${TARGET_PATH}$EXT); do
        duration=$(soxi -D $audio)
        echo "$(basename ${audio/.wav/}) 1 0.0 $duration"
    done > $THISDIR/pyannote_tmp_config/$bn/$bn.uem

    echo "Done creating config for pyannote."

    export PYANNOTE_DATABASE_CONFIG=$THISDIR/pyannote_tmp_config/$bn/database.yml

    OUTPUT=output_voice_type_classifier/$bn/
    mkdir -p output_voice_type_classifier/$bn/

    # Commenting these 2 lines as grep can't be problematic on MAC distrib.
    #BEST_EPOCH=$(cat model/train/X.SpeakerDiarization.BBT2_LeaveOneDomainOut_paido.train/validate_average_detection_fscore/X.SpeakerDiarization.BBT2_LeaveOneDomainOut_paido.development/params.yml | grep -oP "(?<=epoch: )\d+")
    #BEST_EPOCH=$(printf %04d $BEST_EPOCH)
    BEST_EPOCH=0100

    VAL_DIR=$THISDIR/model/train/X.SpeakerDiarization.BBT2_LeaveOneDomainOut_paido.train/validate_average_detection_fscore/X.SpeakerDiarization.BBT2_LeaveOneDomainOut_paido.development

    # Check current class is in classes (provided by the user or by default the KCHI CHI MAL FEM SPEECH)
    pyannote-audio mlt apply --$DEVICE --batch=$BATCH --subset=test --parallel=8 $VAL_DIR $bn.SpeakerDiarization.All

    if [ $? -ne 0 ]; then
        echo "Something went wrong when applying the model"
        echo "Aborting."
        exit
    fi

    classes=(KCHI CHI MAL FEM SPEECH)
    for class in ${classes[*]}; do
        mv ${VAL_DIR}/apply/${BEST_EPOCH}/$bn.SpeakerDiarization.All.test.$class.rttm $OUTPUT/$class.rttm
    done

    # Clean up
    rm -rf ${VAL_DIR}/apply/apply/${BEST_EPOCH}/$bn
    rm -f $OUTPUT/all.rttm
    cat $OUTPUT/*.rttm > $OUTPUT/all.rttm

    # Super powerful sorting bash command :D !
    # Sort alphabetically to the second column, and numerically to the fourth one.
    sort -b -k2,2 -k4,4n $OUTPUT/all.rttm > $OUTPUT/all.tmp.rttm
    rm $OUTPUT/all.rttm
    mv $OUTPUT/all.tmp.rttm $OUTPUT/all.rttm
else
    echo "The folder you provided doesn't contain any wav files."
fi;

end=`date +%s`
runtime=$((end-start))
echo "Took $runtime sec on $bn."
