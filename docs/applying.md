# Applying

First, let's activate the conda environment 

```bash
conda activate pyannote # or source activate pyannote, depending on your config
```

The code consists mainly of a wrapper of pyannote-audio's code responsible for applying a model.
If you want to go further by retraining the model, you should go around [here](https://github.com/pyannote/pyannote-audio) and [there](https://github.com/jsalt-coml/pyannote-audio/tree/bredin-pr).

That being said, you can apply our pre-trained model by typing :

```bash
./apply.sh /absolute/path/to/my_recordings/
```

where **/absolute/path/to/my_recordings/** is a folder containing audio recordings in the .wav format (16kHz). 
This will actually apply 5 models (each for one of the class), which can take some time.


If you just need to consider one class, you can type

```bash
./apply.sh /absolute/path/to/my_recordings/ SPEECH
```

And this will apply the model in charge of predicting the **SPEECH** class.

