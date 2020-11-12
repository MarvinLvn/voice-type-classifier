ARG image=ubuntu:20.04
FROM ${image}
SHELL ["/bin/bash", "--login", "-c"]
ARG username=user
ARG uid=1000
ARG gid=100
ARG magma_version=100
ARG python_version=3.7
ARG TORCH_CUDA_ARCH_STRING="3.5 5.2 6.0 6.1 7.0+PTX"
ARG source="False"
ARG vtc_version="HEAD"
ENV USER $username
ENV UID $uid
ENV GID $gid
ENV HOME /home/$USER
ENV BATCH=32
ENV DEVICE=cpu
ENV MAGMA_VERSION=${magma_version}
ENV PYTHON_VERSION=${python_version}
ENV SOURCE=${source}
ENV VTC_VERSION=${vtc_version}

RUN adduser --disabled-password \
	--gecos "Non-root user" \
	--uid $UID \
	--gid $GID \
	--home $HOME \
	$USER

RUN apt-get update -y \
    && apt-get install --no-install-recommends -y \
        git \
        sox  \
        curl \
        ca-certificates

RUN if [ ${SOURCE} = "True" ]; then DEBIAN_FRONTEND=noninteractive apt-get update -y \
    && apt-get install --no-install-recommends -y \
        build-essential \
        cmake \
        libjpeg-dev \
        libpng-dev \
        ; fi

USER $USER

ENV CONDA_DIR $HOME/miniconda3
WORKDIR /home/user/
RUN curl -o ~/miniconda.sh https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
     chmod +x ~/miniconda.sh && \
     ~/miniconda.sh -b -p $CONDA_DIR && \
    rm /home/user/miniconda.sh
RUN $CONDA_DIR/bin/conda install python=${PYTHON_VERSION}
COPY script_source_pytorch.sh .
RUN if [ ${SOURCE} = "True" ]; then bash script_source_pytorch.sh 1 ; fi

ENV PATH $CONDA_DIR/bin:$PATH
WORKDIR /home/user/
RUN if [ ${SOURCE} = "True" ]; then bash script_source_pytorch.sh 2 ;  fi
RUN git clone --recurse-submodules https://github.com/MarvinLvn/voice_type_classifier.git
WORKDIR /home/user/voice_type_classifier
RUN if [ "$VTC_VERSION" != "HEAD" ]; then git checkout  "$VTC_VERSION" ; fi
RUN cat vtc.yml | grep "    - " | sed 's/    - //g' > vtc-prepared.yml
RUN pip install -r vtc-prepared.yml
WORKDIR /home/user/
COPY ./script_run_vtc.sh .
CMD   /bin/bash --login -c "bash script_run_vtc.sh \
        ${DEVICE} \
        ${BATCH}"
