# Applying

First, let's activate the conda environment 

```bash
conda activate pyannote
```

The code consists mainly of a wrapper of pyannote-audio's code responsible for applying a model.
If you want to go further by retraining the model, you should go around [here](https://github.com/pyannote/pyannote-audio) and [there](https://github.com/jsalt-coml/pyannote-audio/tree/bredin-pr).

That being said, you can apply our pre-trained model by typing :

```bash
./apply.sh my_recordings/
```

where **my_recordings/** is a folder containing audio recordings in the .wav format (16kHz). This path can be either relative or absolute.
This will actually apply 5 models (each for one of the class), which can take some time.


If you just need to consider one class, you can type

```bash
./apply.sh my_recordings/ SPEECH
```

And this will apply the model in charge of predicting the **SPEECH** class.

