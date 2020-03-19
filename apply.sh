#!/usr/bin/env bash
THISDIR="$( cd "$( dirname "$0" )" && pwd )"

declare -a classes=(KCHI CHI MAL FEM SPEECH)

declare -a folders=(
"KCHI:model/train/X.SpeakerDiarization.BBT2_LeaveOneDomainOut_paido.train/validate_KCHI/X.SpeakerDiarization.BBT2_LeaveOneDomainOut_paido.development/apply/0100"
"CHI:model/train/X.SpeakerDiarization.BBT2_LeaveOneDomainOut_paido.train/validate_CHI/X.SpeakerDiarization.BBT2_LeaveOneDomainOut_paido.development/apply/0100"
"MAL:model/train/X.SpeakerDiarization.BBT2_LeaveOneDomainOut_paido.train/validate_MAL/X.SpeakerDiarization.BBT2_LeaveOneDomainOut_paido.development/apply/0100"
"FEM:model/train/X.SpeakerDiarization.BBT2_LeaveOneDomainOut_paido.train/validate_FEM/X.SpeakerDiarization.BBT2_LeaveOneDomainOut_paido.development/apply/0100"
"SPEECH:model/train/X.SpeakerDiarization.BBT2_LeaveOneDomainOut_paido.train/validate_SPEECH/X.SpeakerDiarization.BBT2_LeaveOneDomainOut_paido.development/apply/0100")


# ./apply.sh my_folder KCHI
if [ $# -ge 2 ]; then
    declare -a classes=($2) # get the classes provided by the user
fi;

# ./apply.sh my_folder KCHI --gpu
if [ $# -eq 3 ]; then
    GPU=$3;
fi;

# ./apply.sh my_folder KCHI --gpu
if [ $# -ge 4 ]; then
    echo "Wrong call. Must provide 3 arguments at most."
    echo "Example 1 :"
    echo "./apply.sh /path/to/my/folder (--gpu)"
    echo "Example 2:"
    echo "./apply.sh /path/to/my/folder/ \"CHI MAL\" (--gpu)"
    exit
fi;



if [ "$(ls -A $1/*.wav)" ]; then
    echo "Found wav files."

    bn=$(basename $1)
    echo "Creating config for pyannote."
    # Create pyannote_tmp_config containing all the necessary files
    rm -rf $THISDIR/pyannote_tmp_config
    mkdir $THISDIR/pyannote_tmp_config

    # Create database.yml
    echo "Databases:
    $bn: $1/{uri}.wav

Protocols:
  $bn:
    SpeakerDiarization:
      All:
        test:
          annotated: $THISDIR/pyannote_tmp_config/$bn.uem" > $THISDIR/pyannote_tmp_config/database.yml

    # Create .uem file
    for audio in $1/*.wav; do
        duration=$(soxi -D $audio)
        echo "$(basename ${audio/.wav/}) 1 0.0 $duration"
    done > $THISDIR/pyannote_tmp_config/$bn.uem
    echo "Done creating config for pyannote."

    export PYANNOTE_DATABASE_CONFIG=$THISDIR/pyannote_tmp_config/database.yml

    OUTPUT=output_voice_type_classifier/$bn/
    mkdir -p output_voice_type_classifier/$bn/

    for couple in ${folders[*]}; do
        class="${couple%%:*}"
        class_model_path="${couple##*:}"

        # Check current class is in classes (provided by the user or by default the KCHI CHI MAL FEM SPEECH)
        if [[ ${classes[*]} =~ (^|[[:space:]])${class}($|[[:space:]]) ]]; then
            echo "Extracting $class"
            pyannote-multilabel apply $GPU --subset=test $THISDIR/model/train/X.SpeakerDiarization.BBT2_LeaveOneDomainOut_paido.train/validate_$class/X.SpeakerDiarization.BBT2_LeaveOneDomainOut_paido.development $bn.SpeakerDiarization.All
            awk -F' ' -v var="$class" 'BEGIN{OFS = "\t"}{print $1,$2,$3,$4,$5,$6,$7,var,$9,$10}' $THISDIR/${class_model_path}/$bn.SpeakerDiarization.All.test.rttm \
                > $OUTPUT/$class.rttm
        fi;
    done;

    # Clean up
    rm -rf $THISDIR/${class_model_path}
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