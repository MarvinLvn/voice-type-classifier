# Installing

The code relies on [pyannote-audio](https://github.com/pyannote/pyannote-audio), a python package 
for speaker diarization: speech activity detection, speaker change detection, speaker embedding.

```bash
# Step 1: git clone the voice type classifier repo as well as pyannote-audio dependency
$ git clone --recurse-submodules https://github.com/MarvinLvn/voice_type_classifier.git
$ cd voice_type_classifier
# Step 2 : create conda env
$ conda create --name pyannote python==3.7
$ conda activate pyannote # or source activate pyannote, depending on your config
$ pip install pyannote-audio
```

Once everything has been installed, you can apply the model by following [these instructions](../docs/applying.md).