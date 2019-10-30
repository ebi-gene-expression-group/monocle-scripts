#!/bin/bash

env_name="${1:-$CONDA_DEFAULT_ENV}"
env_name="${env_name:-monocle3}"

monocle_version="${2:-$MONOCLE_VERSION}"
monocle_version="${monocle_version:-master}"

python_version="${3:-$TRAVIS_PYTHON_VERSION}"
python_version="${python_version:-3}"

if [[ $(conda env list | grep -v '#' | awk -v env=$env_name '$1==env') ]]; then
    cmd=install
else
    cmd=create
fi

conda config --add channels defaults
conda config --add channels bioconda
conda config --add channels conda-forge

conda config --set always_yes yes --set changeps1 no --set channel_priority strict

conda $cmd -q -n $env_name python=$python_version louvain umap-learn \
    r-assertthat r-matrix r-matrix.utils r-ggplot2 r-ggrepel r-viridis r-dplyr r-tidyr r-stringr r-reshape2 \
    r-plotly r-pryr r-base64enc r-hexbin r-crosstalk r-data.table r-codetools r-optparse \
    r-devtools r-grr r-htmlwidgets r-pbapply r-pbmcapply r-irlba r-igraph r-rhpcblasctl r-rtsne r-lmtest \
    r-pheatmap r-proxy r-pscl r-purrr r-rann r-reticulate r-shiny r-slam r-spdep r-speedglm r-uwot r-vgam \
    bioconductor-limma bioconductor-singlecellexperiment bioconductor-delayedarray bioconductor-delayedmatrixstats

source activate $env_name

export TAR=$(which tar)
export R_GZIPCMD=$(which gzip)
export R_BZIPCMD=$(which bzip2)

Rscript -e 'devtools::install_github("cole-trapnell-lab/monocle3", ref="'$monocle_version'", upgrade="never")'
