# Installing

The code relies on [pyannote-audio](https://github.com/pyannote/pyannote-audio), a python package 
for speaker diarization: speech activity detection, speaker change detection, speaker embedding.

```bash
# Step 1:  install from source
$ git clone https://github.com/MarvinLvn/voice_type_classifier.git
$ cd voice_type_classifier
$ git clone https://github.com/MarvinLvn/pyannote-audio.git
$ cd pyannote-audio
$ git checkout voice_type_classifier

# Step 2: This creates a conda environment with python 3.6
$ conda create --name pyannote python==3.7
$ conda activate pyannote # or source activate pyannote, depending on your config
$ pip install .
$ pip install torch
```

Once everything has been installed, you can apply the model by following [these instructions](../docs/applying.md).