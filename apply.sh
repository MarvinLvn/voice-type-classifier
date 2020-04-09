#!/usr/bin/env bash
THISDIR="$( cd "$( dirname "$0" )" && pwd )"


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

if [[ "$1" == *.wav ]]; then
    # We want to apply the model on a single wav
    EXT=""
else
    # We want to apply the model on a folder containing wav files
    EXT="/*.wav"
fi


if [[ "$(ls -A $1$EXT)" ]]; then

    bn=$(basename $1)

    if [[ "$1" == *.wav ]]; then
        bn=${bn/.wav/}
        DB_PATH="$(dirname $1)/{uri}.wav"
    else
        DB_PATH="$1/{uri}.wav"
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
    for audio in $(ls -A $1$EXT); do
        duration=$(soxi -D $audio)
        echo "$(basename ${audio/.wav/}) 1 0.0 $duration"
    done > $THISDIR/pyannote_tmp_config/$bn/$bn.uem

    echo "Done creating config for pyannote."

    export PYANNOTE_DATABASE_CONFIG=$THISDIR/pyannote_tmp_config/$bn/database.yml

    OUTPUT=output_voice_type_classifier/$bn/
    mkdir -p output_voice_type_classifier/$bn/

    BEST_EPOCH=$(cat model/train/X.SpeakerDiarization.BBT2_LeaveOneDomainOut_paido.train/validate_average_detection_fscore/X.SpeakerDiarization.BBT2_LeaveOneDomainOut_paido.development/params.yml | grep -oP "(?<=epoch: )\d+")
    BEST_EPOCH=$(printf %04d $BEST_EPOCH)

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
