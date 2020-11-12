#!/bin/bash



if [ ${1} = "1" ]
then
	$CONDA_DIR/bin/conda install numpy pyyaml scipy ipython mkl mkl-include ninja cython typing && \
	     $CONDA_DIR/bin/conda install  -c pytorch magma-cuda${MAGMA_VERSION}
elif [ ${1} = "2" ]
then
	git clone --recursive https://github.com/pytorch/pytorch
	cd /home/user/pytorch
	git submodule sync && git submodule update --init --recursive
	TORCH_CUDA_ARCH_LIST=${TORCH_CUDA_ARCH_STRING} \
		TORCH_NVCC_FLAGS="-Xfatbin -compress-all" \
		USE_CUDA=1 \
    		CMAKE_PREFIX_PATH="$(dirname $(which conda))/../" \
    		pip install -v .
fi
