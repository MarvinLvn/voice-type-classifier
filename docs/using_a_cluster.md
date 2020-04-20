# Applying the model on oberon, the LSCP cluster

Here's a short guide on "How to apply the model" on oberon, the LSCP cluster
Tokens <USERNAME> are supposed to be replaced by your username in the commands below

### Connect to oberon

To connect to oberon, you'll first have to connect to habilis :

```bash
ssh <USERNAME>@129.199.81.135 
```

Then you can connect to oberon :

```bash
ssh <USERNAME>@129.199.81.30
```

### Installing the code (only once !)

You can first go to your own personal space on **scratch2** by typing :

```bash
cd /scratch2/<USERNAME>
```

Then, you can clone the **voice_type_classifier** git repository :

```bash
git clone https://github.com/MarvinLvn/voice-type-classifier.git
```

### Running the model

Each time you'll want to apply the model, you'll have to follow these steps :

```bash
cd /scratch2/<USERNAME>/voice_type_classifier # Move the voice_type_classifier folder
conda activate pyannote_vtc                   # Activate the shared conda environment kindly created by Julien Karadayi
```

Then you can run the model on CPU by typing :

```bash
sbatch --mem=64G --time=20:00:00 --cpus-per-task=8 --ntasks=1 -o vtc_namibia_log.txt ./apply.sh /path/to/my/namibia_recordings --device=cpu
```

Or on GPU by typing :

```bash
sbatch --partition=gpu2 --gres=gpu:1 --mem=30G --time=20:00:00 -o vtc_namibia_log.txt ./apply.sh /path/to/my/namibia_recordings --device=gpu
```

You can notice in these 2 calls to `sbatch`, that the arguments straight after `sbatch` are slurm parameters asking for specific computational resources.
Whereas, the arguments straight after `apply.sh` are arguments of the bash script (the path to the folder containing wav files, the batch size, and whether or not to run the code on GPU)

The `-o` parameter of `sbatch` consists of telling to slurm where to store the output of the run. This will create a file called `vtc_namibia_log.txt` showing you what your call to `apply.sh` is producing.

# How to check that my job is running ? 

## Check my job has started running

You can type :

```bash
sacct
```

which will displays :

```bash
       JobID    JobName  Partition    Account  AllocCPUS      State ExitCode 
------------ ---------- ---------- ---------- ---------- ---------- -------- 
11252        apply.sh       main                     2    RUNNING      0:0
```

or something like :

```bash
       JobID    JobName  Partition    Account  AllocCPUS      State ExitCode 
------------ ---------- ---------- ---------- ---------- ---------- -------- 
11252        apply.sh       main                     2    PENDING      0:0
```

If your job is PENDING, that means that the cluster is already busy processing jobs of other people. But your job will patiently wait its turn in the queue :) No need to resubmit a job !

## Check the progress

To check the progress of a run, you can display the log file you specified during the call to `sbatch`, by typing :

```bash
cat vtc_namibia_log.txt
```

You'll have something like 

```bash
Test set: 326it [10:01,  1.00s/it]
```

meaning that `apply.sh` has already processed 326 files :)

# Cancelling a job

If you made a mistake and wants to cancel one the job you submitted to slurm, you can first display all the jobs that are currently running by typing:

```bash
sacct
```

which will return something like 

```bash
       JobID    JobName  Partition    Account  AllocCPUS      State ExitCode 
------------ ---------- ---------- ---------- ---------- ---------- -------- 
11254        apply.sh       main                     2    RUNNING      0:0
11255        apply.sh       main                     2    RUNNING      0:0
```

You can cancel a job by looking at its job number and type : 

```bash
scancel 11254
```

If you want to cancel all the jobs associated to your user account, you can type :

```bash
scancel -u <USERNAME>
```


# FAQ

### What if my audio files are in a complicated folder structure, each recording being at a different depth ?

The `apply.sh` script will look for all the files that are immediately present in a given folder.


If your folder structure is something like :

```bash
/path/to/my/namibia_recordings/my_audio1.wav
/path/to/my/namibia_recordings/deeper/my_audio2.wav
/path/to/my/namibia_recordings/even/deeper/my_audio3.wav
```

Then you'll need to do a bit of processing before being able to run the script !
One smart way to solve this problem is to create symbolic links : those are links that tell your computer how to access the file you're interested in.
To do so, you can type :

```bash
cd /scratch2/<USERNAME>             # Move to your working space
mkdir namibia_recordings_flatten    # Create a new folder called "namibia_recordings_flatten"

for my_audio in $(find /path/to/my/namibia_recordings/ -name '*.wav'); do
    ln -s $my_audio namibia_recordings_flatten/$(basename $my_audio)
done;
```

These few lines will loop through all the .wav files recursively in `/path/to/namibia_recordings`.
Each time it will find a .wav file, it will create a symbolic link in the newly created `namibia_recordings_flatten` folder.

Then, you'll have a more flat structure like :

```bash
/scratch2/<USERNAME>/namibia_recordings_flatten/my_audio1.wav
/scratch2/<USERNAME>/namibia_recordings_flatten/my_audio2.wav
/scratch2/<USERNAME>/namibia_recordings_flatten/my_audio3.wav
``` 

You can now submit your run to slurm with the `/scratch2/<USERNAME>/namibia_recordings_flatten` folder.
