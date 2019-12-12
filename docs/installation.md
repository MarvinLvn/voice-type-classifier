# Installing

The code relies on [pyannote-audio](https://github.com/pyannote/pyannote-audio), a python package 
for speaker diarization: speech activity detection, speaker change detection, speaker embedding.
Sox, the Swiss Army knife of audio manipulation must also be installed.

```bash
# Step 1:  install from source
$ git clone --recurse-submodules https://github.com/MarvinLvn/voice_type_classifier.git
$ cd voice_type_classifier

# Step 2: This creates a conda environment with python 3.6
$ conda env create -f pyannote/pyannote-audio/environment.yml
$ conda activate pyannote # or source activate pyannote, depending on your config
$ pip install pyannote/pyannote-audio

# Step 3: Install sox
# On Ubuntu
$ sudo apt-get install sox
# On MacOS (if brew installed)
$ brew install sox
```

Once everything has been installed, you can apply the model by following [these instructions](../docs/applying.md).