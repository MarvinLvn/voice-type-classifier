# Evaluations

## In-domain error 
Here are the results computed on the development set and the test set of BabyTrain.
All the results are given in terms of ***detection error rate*** such as computed in [pyannote-metrics](https://github.com/pyannote/pyannote-metrics).

| Class | Dev. Error | Test Error |
| -----:|:-----:|:-----:|
| SPEECH | 18.4 | 16.8 |
| FEM | 29.7 | 40.1 |
| KCHI | 42.2 | 40.6 |
| MAL | 87.8 |  88.4 |
| CHI | 98.7 | 119.5 |

We can compute the performances on a held-out dataset, that means data that have not been seen during the training.
As a held-out dataset, we chose databrary_ACLEW, made of child-centered recordings acquired in a wide range of conditions, which is supposed to be drawn from a related (but different !) distribution from our training set:

## Out-of-domain error 

| Class | Held-out Error |
| -----:|:-----:|
| SPEECH | 51.1 |
| FEM | 70 |
| KCHI | 73 |
| MAL | 89.1 |
| CHI | 100 |

With little surprise, and since no particular strategy has been applied to handle the domain-shift problem, we have a strong performance discrepancy (waiting for the [domain-adversarial](https://arxiv.org/abs/1910.10655) version of this model !)

## Confusion matrices

Detection Error Rate might not be the best metric in our case, since some of the recordings contain absolutely no speech, in which case the denominator is equal to 0 ...
When the audio contains little speech, the denominator is still close to 0 and can lead to a really high detection error rate.
Here, we propose to have a look at the confusion matrices

|| | | | voice_type_classifier  | | |
|:---| -----:|:-----:|:-----:|:-----:|:-----:|:-----:|
| | | SIL  |  KCHI | CHI  |   FEM  | MAL |
| | SIL  | 3333203 | 127031 |  43 | 119878 | 12473 |
| | KCHI  | 171122 | 398290 | 383 |  26344 | 2123 |
|gold| CHI  | 169287 | 73966 | 335  | 28379 |  1183 |
| | FEM | 447222 | 77517 | 303 | 466477 | 17534 |
| | MAL  | 151170  | 14283   | 0 |  31444 | 56321 |