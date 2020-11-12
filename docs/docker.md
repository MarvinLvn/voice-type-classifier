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

To check cuda compatibility between major version, minor version, GPU driver, please, read this [page](https://docs.nvidia.com/deploy/cuda-compatibility/index.html). For Cudnn version, read this [page](https://docs.nvidia.com/deeplearning/cudnn/support-matrix/index.html)

The dockerhub [nvidia/cuda](https://hub.docker.com/r/nvidia/cuda/) page show the base docker images it is possible to use.

## Usage

The docker compose is, for the moment, composed of four services, according to the CPU/GPU usage and the pytorch pre-compiled/compialtion from source.
The Dockerfile allow several arguments in order to build the image according to the hardware requirement:

        - source: If true, compile pytorch from source
        - image: docker base image, must be nvidia/cuda:${cuda_version}-cudnn${cudnn_version}-devel-${os}
        - magma_version: choose the version according to cuda version
        - torch_cuda_arch_string: list of minor version for GPU capability
        - python_version: ...
        - vtc_version: commithash

The usage of GPU needs the option ```runtime : nvidia```

When the time is coming to run VTC in container, it is necessary to choose the batch size, the device (CPU, GPU) and the location of the datas




```bash
docker-compose run vtc_cuda_gpu #to run vtc on GPU with torch pre-compiled with cuda image
docker-compose run vtc_cuda_cpu #to run vtc on CPU with torch pre-compiled with cuda image
docker-compose run vtc_ubuntu_gpu #to run vtc on GPU with torch pre-compiled
docker-compose run vtc_ubuntu_cpu #to run vtc on CPU with torch pre-compiled
docker-compose run vtc_source_gpu #to run vtc on GPU with torch compiled
docker-compose run vtc_source_cpu #to run vtc on CPU with torch compiled
```

## Format of data
```bash
data/
|__data1/*.wav
|__data2/*.wav
```
ou
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
ou

```bash
data/
|_*.wav
|_all.rttm # VTC output
```
