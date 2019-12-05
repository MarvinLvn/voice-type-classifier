# SincNet and LSTM based Voice Type Classifier

![Architecture of our model](./docs/archi_sincnet.png)

In this repository, you'll find all the necessary code for applying a pre-trained model that, given an audio recording, classifies each frame into **[SPEECH, KCHI, CHI, MAL, FEM]**.
- FEM stands for female speech
- MAL stands for male speech
- KCHI stands for key-child speech
- CHI stands for other child speech
- SPEECH stands for speech :)

Our model has been developped in JSALT [1] and its architecture is based on SincNet [2].

### How to use ?

0) [Disclaimer /!\\](./docs/disclaimer.md)
1) [Installation](./docs/installation.md)
2) [Applying](./docs/applying.md)
3) [Evaluation](./docs/evaluation.md)


### References
[1] Paola Garcia et al., "Speaker detection in the wild: Lessons learned from JSALT 2019" [arXiV](https://arxiv.org/abs/1912.00938)

[2] Mirco Ravanelli, Yoshua Bengio, “Speaker Recognition from raw waveform with SincNet” [arXiV](https://arxiv.org/abs/1808.00158)


