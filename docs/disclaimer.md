# /!\ DISCLAIMER /!\

In this repository, you'll find all the necessary code for applying a pre-trained model that, given an audio recording, classifies each frame into **[SPEECH, KCHI, CHI, MAL, FEM]**.
- FEM stands for female speech
- MAL stands for male speech
- KCHI stands for key-child speech
- CHI stands for other child speech
- SPEECH stands for speech :)

Note that there are no partial order relations between the different sets of classes: 
- If a frame is classified as being SPEECH, this frame might not be classified as being KCHI, CHI, MAL or FEM. This case can arise when the model thinks there's speech without being able to identify the voice type.
- If a frame is classified as being FEM, this frame might not be classified as being SPEECH (however, this case should not occur very often).

The model has been trained during 100 epochs (equivalent to 2 400 hours of audio) on the BabyTrain corpora, whose Paido domain has been removed.
BabyTrain is an aggregation of multiple corpus of child-centered recordings, covering a wide range of noises and recording conditions.
These recordings cover also multiple languages.

Before applying the model, you should just have a look at the [Evaluation](./evaluations.md) part to get an idea of the performances you can expect !
