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
ARG max_compile_job=6
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
ENV MAX_COMPILE_JOB=${max_compile_job}

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

RUN if [ ${SOURCE} = "True" ]; then apt-get update -y \
    && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
        build-essential \
        cmake \
        libjpeg-dev \
        libpng-dev \
        ; fi

USER $USER
COPY --chown=$UID:$GID . /home/user/voice_type_classifier/
ENV CONDA_DIR $HOME/miniconda3
WORKDIR /home/user/
RUN curl -o ~/miniconda.sh https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
     chmod +x ~/miniconda.sh && \
     ~/miniconda.sh -b -p $CONDA_DIR && \
    rm /home/user/miniconda.sh
RUN $CONDA_DIR/bin/conda install python=${PYTHON_VERSION}
RUN if [ ${SOURCE} = "True" ]; then bash voice_type_classifier/docker/script_source_pytorch.sh 1 ${MAX_COMPILE_JOB}; fi

ENV PATH $CONDA_DIR/bin:$PATH
WORKDIR /home/user/
RUN if [ ${SOURCE} = "True" ]; then bash voice_type_classifier/docker/script_source_pytorch.sh 2 ${MAX_COMPILE_JOB};  fi
WORKDIR /home/user/voice_type_classifier
RUN if [ "$VTC_VERSION" != "HEAD" ]; then git checkout  "$VTC_VERSION" ; fi
RUN cat vtc.yml | grep "    - " | sed 's/    - //g' | sed  's+pyannote-audio/+voice_type_classifier/pyannote-audio/+g' > ../vtc-prepared.yml
WORKDIR /home/user/
RUN pip install -r vtc-prepared.yml
CMD   /bin/bash --login -c ". /home/user/miniconda3/etc/profile.d/conda.sh && bash voice_type_classifier/docker/script_run_vtc.sh \
        ${DEVICE} \
        ${BATCH}"
