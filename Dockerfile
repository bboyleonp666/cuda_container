# v22.06 uses CUDA v11.7 which supports most of our packages
ARG NVIDIA_PYTORCH_VERSION=22.06

FROM nvcr.io/nvidia/pytorch:${NVIDIA_PYTORCH_VERSION}-py3

LABEL maintainer='bboyleonp666 <https://github.com/bboyleonp666/cuda_container/tree/pytorch-lightning>'

WORKDIR /workspace

# Pytorch built in the original image was a special version, 
# which does not work well with torch-geometric
# So we have to install the compatible version instead
RUN pip install torch==1.13.1 torchvision torchaudio && \
    # package: pytorch-lightning, pytorch-nlp
    pip install pytorch-lightning==1.8.6 pytorch-nlp==0.5.0 && \
    # package: torch-geometric
    pip install pyg-lib torch-scatter torch-sparse -f https://data.pyg.org/whl/torch-1.13.0+cu117.html && \
    pip install torch-geometric==2.2.0 && \
    # package: jupyterlab
    pip install jupyterlab[all] -U && \
    # package: seaborn, angr, mlflow
    pip install ipywidgets seaborn mlflow angr==9.2.32

RUN pip list | grep torch && \
    python -c 'import torch, pytorch_lightning as pl; print(torch.__version__); print(pl.__version__)' && \
    python -c 'import torch_geometric as pyg; print(pyg.__version__)'

CMD ["jupyter", "lab", "--port=8888", "--no-browser", "--ip=0.0.0.0", "--allow-root"]