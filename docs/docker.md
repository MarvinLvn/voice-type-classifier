# docker-processing

Tools for data-processing with docker. The docker images contain [VTC](https://github.com/MarvinLvn/voice-type-classifier) tool and can be run with CPU or GPU

## Composition of repository

- Dockerfile is used to build docker images which run the voice_type_classifier with cpu and gpu.
- script_run_vtc.sh : script allowing to browse  inside a directory, run VTC on each sub directory and write the outputs inside the first directory. This script is copied inside the docker images.
- docker-compose.yml contain the script for executing of gpu or cpu docker images.

## Dependencies

First install [Docker](https://docs.docker.com/engine/install/) and [Docker-compose](https://docs.docker.com/compose/install/)

Then, for GPU usage, after checking which driver use on [NVIDIA](https://www.nvidia.com/fr-fr/) web site, install a driver, like this [example](https://www.cyberciti.biz/faq/ubuntu-linux-install-nvidia-driver-latest-proprietary-driver/) for ubuntu.
See these [instruction](https://docs.docker.com/engine/reference/commandline/run/#access-an-nvidia-gpu) in order to use docker with GPU

## On old GPU

If you need to run the container on an old GPU, you will need to build a docker image which install pytorch from sources.

For this purpose you will need several keys:
- a python version
- the cuda major and minor version compatibility with the driver and GPU
- a Cudnn version
- Choosing a specific image

To check cuda compatibility between major version, minor version, GPU driver, please, read this [page](https://docs.nvidia.com/deploy/cuda-compatibility/index.html). For Cudnn version, read this [page](https://docs.nvidia.com/deeplearning/cudnn/support-matrix/index.html)

The dockerhub [nvidia/cuda](https://hub.docker.com/r/nvidia/cuda/) page show the base docker images it is possible to use.

## Usage

The docker compose is, for the moment, composed of three services, according to the CPU/GPU usage and the pytorch pre-compiled/compialtion from source.
The Dockerfile allow several arguments in order to build the image according to the hardware requirement:

### Compilation from sources for GPU usage

Arguments :

- source: If true, compile pytorch from source
- image: docker base image, must be nvidia/cuda:${cuda_version}-cudnn${cudnn_version}-devel-${os}
- magma_version: choose the version according to cuda version (eg : magma 102 for Cuda 10.2)
- torch_cuda_arch_string: list of minor version for GPU capability (eg : 3.5 for sm_35)
- python_version: ...
- max_compile_job: the number of jobs requested for compilation

Example:
```bash
docker-compose build vtc_source_gpu
```

You may need to define $TMPDIR envrionment variable before usage

### Build GPU image:

Arguments : 

- source: "False"
- image: nvidia/cuda:${CUDA_VERSION}-base (example :nvidia/cuda:11.2.1-base)
- python_version: X.X

```bash
docker-compose run vtc_cuda_gpu
```


### Build a CPU image

Arguments : 

- source: "False"
- image: ubuntu:20.04
- python_version: X.X

```bash
docker-compose run vtc_unbutu_cpu
```

### Running job
When the time is coming to run VTC in container, it is necessary to choose the batch size (env. BATCH), the device (CPU, GPU) (env. DEVICE) and the location of the datas (Volume. source, target) in the docker-compose.yml




```bash
docker-compose run vtc_cuda_gpu 
docker-compose run vtc_ubuntu_cpu 
docker-compose run vtc_source_gpu 
```

## Format of data
```bash
data/
|__data1/*.wav
|__data2/*.wav
```
or

```bash
data/
|__*.wav
```

## Output

```bash
data/
|__data1/
   |_*.wav
   |_all.rttm # VTC output
|__data2/*.wav
```
or

```bash
data/
|_*.wav
|_all.rttm # VTC output
```
