# Evaluations

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



| Class | Held-out Error |
| -----:|:-----:|
| SPEECH | 51.1 |
| FEM | 70 |
| KCHI | 73 |
| MAL | 89.1 |
| CHI | 100 |

With little surprise, and since no particular strategy has been applied to handle the domain-shift problem, we have a strong performance discrepancy (waiting for the [domain-adversarial](https://arxiv.org/abs/1910.10655) version of this model !)

