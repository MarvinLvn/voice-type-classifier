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

The model has been trained during 500 epochs (equivalent to 12 000 hours of audio) on the BabyTrain corpora.
BabyTrain is an aggregation of multiple corpus of child-centered recordings, covering a wide range of noises and recording conditions.
These recordings cover also multiple languages.

Please be aware that the algorithm has been trained in a fully-supervised fashion, and that those methods are not well-known for their generalization abilities...
Moreover, no particular strategy has been applied for improving its robustness. Thus, one can not expect ground-breaking performances if the model is applied on data whose distribution is too far from our training distribution.

That being said, we plan for the future to retrain the model with a domain-adversarial branch, thus hoping to improve its performances on unseen domains (directly inspired from [this paper](https://arxiv.org/abs/1910.10655)).

Last but not least, our model did not exhibit good performances on the **MAL** (male speech) and the **CHI** (other child speech) classes. This probably comes from the fact that the BabyTrain corpora does not contain a lot of examples for these classes. One might expect to get better performances on the **MAL** class by retraining the model on BabyTrain augmented with male speech extracted from another dataset (such as VoxCeleb for instance).

You should just have a look at the [Evaluation](./evaluations.md) part before applying the model !
