# Evaluations

## Running time

The running times have been computed on Nvidia® Tesla V100 GPUs with 32 GB of memory and  Intel® Xeon® Gold 6230 CPUs.
The following table shows real time factors you can expect from the model.


| batch_size | GPU | CPU |
| :-----:|:-----:|:-----:|
| 32 | 1/35 | 0.27 |
| 64 | 1/45 |0.26 |
| 128 | OOM | 0.25 |
| 256 | OOM | 0.24 |

It takes roughly 1/35 of the audio duration to run the model with a batch of size 32 on GPU.
Similarly, it takes approximatively 1/4 of the audio duration to run the model on CPU.

## Within-domain performances

Here are the results computed on the development set and the test set of BabyTrain (whose Paido domain has been removed).
All the results are given in terms of ***fscore*** between ***precision*** and ***recall*** such as computed in [pyannote-metrics](https://github.com/pyannote/pyannote-metrics).


Performances on the development set :

| Class | Precision | Recall | Fscore |
| -----:|:-----:|:-----:|:-----:|
| KCHI | 0.82 | 0.80 | 80.65 |
| CHI | 0.22 | 0.50 | 30.63 |
| FEM | 0.84 | 0.84 | 84.21 |
| MAL | 0.43 | 0.44 | 43.73 |
| SPEECH | 0.89 | 0.91 | 90.33 |
| AVE | 0.71 | 0.69 | 65.91 | 

Performances on the test set :

| Class | Precision | Recall | Fscore |
| -----:|:-----:|:-----:|:-----:|
| KCHI | 0.82 | 0.73 | 77.37 | 
| CHI | 0.19 | 0.40 | 25.65 | 
| FEM | 0.78 | 0.87 | 82.40 | 
| MAL | 0.38 | 0.48 | 42.25 | 
| SPEECH | 0.86 | 0.92 | 88.45 |
| AVE |0.60 | 0.68 | 63.22 |

The tresholds that decide whether each class is activated or not have been computed on the development set.
If you have some annotations, you can fine-tune these tresholds on your own dataset. 

Depending on your application, you might also want to optimize more the precision than the recall (or vice-versa).
With pyannote-audio, you can optimize these tresholds on the recall while fixing the precision.

By doing so, you can end up with a model having a high precision/low recall or low precision/high recall, which might be useful for some applications.
For instance, we might have some data that we'd like to annotate, but we'd like to focus the annotation campaign on the key-child to study how much the latter is vocalizing.
In that case, it'd be useful to run a model that has a high precision but low recall on the dataset. That way, we can extract moments when we are almost sure that the key-child (accepting that we miss some of these moments) is vocalizing and we can provide these moments to the human annotators.


For illustrative purposes, here's the precision/recall (computed on the development set) curves for each of the class : 

![](figures/precall.png)


## Performances on the held-out set 

We can compute the performances of our model on data that have never been seen during the training.

Here are the held-out performances for our model :

| Class | Precision | Recall | Fscore |
| -----:|:-----:|:-----:|:-----:|
| KCHI | 0.62 | 0.77 | 68.78 |
| CHI |0.47 | 0.26 | 33.24 |
| FEM | 0.70 | 0.58 | 63.48 |
| MAL | 0.40 | 0.47 | 42.91 |
| SPEECH | 0.77 | 0.80 | 78.43 |
| AVE |0.59 | 0.57 | 57.37 |

On this held-out set, and since it hasn't never been seen during the training by neither our model or LENA's model, we can
compare these two. Here are the performances of LENA on the same held-out set :

| Class | Precision | Recall | Fscore |
| -----:|:-----:|:-----:|:-----:|
| KCHI | 60.91 | 50.07 | 54.96 |
| CHI |27.34 | 29.97 | 28.59 |
| FEM | 63.87 | 31.96 | 42.60 |
| MAL | 43.57 | 32.5 | 37.23 |
| SPEECH | 65.04 | 76.35 | 70.24 |
| AVE | 52.15 | 44.17 | 46.73 |

## Confusion matrices

To better understand which kind of errors, our model and LENA's model are doing, we can have a look
at the confusion matrices.

### Confusion matrices for LENA

There are multiple ways to draw confusion matrices looking at either the SPEECH vs NON-SPEECH frames, or looking at the confusion matrix showing the voice types.
Since our held-out set has been annotated for electronical noise (in the ELE class), we can also have a look at how well LENA is doing on this class.

#### Speech / Non Speech

As LENA does not return a SPEECH class, we aggregated the voice types [KCHI, OCH, MAL, FEM] into one single SPEECH class.

LENA precision            |  LENA recall
:-------------------------:|:-------------------------:
![](figures/confusion_matrices/lena/speech_vs_sil_precision_lena.png) | ![](figures/confusion_matrices/lena/speech_vs_sil_recall_lena.png)

#### Voice types


LENA precision            |  LENA recall
:-------------------------:|:-------------------------:
![](figures/confusion_matrices/lena/full_precision_lena.png) | ![](figures/confusion_matrices/lena/full_recall_lena.png)

### Confusion matrices for our model
