# Installing

The code relies on [pyannote-audio](https://github.com/pyannote/pyannote-audio), a python package 
for speaker diarization: speech activity detection, speaker change detection, speaker embedding.


```bash
# Step 1:  install from source
$ git clone --recurse-submodules https://github.com/MarvinLvn/voice_type_classifier.git
$ cd voice_type_classifier

# Step 2: This creates a conda environment with python 3.6
$ conda env create -f environment.yml
$ conda activate pyannote
$ pip install pyannote/pyannote-audio
```

Once everything has been installed, you can apply the model by following [these instructions](../docs/installation.md).