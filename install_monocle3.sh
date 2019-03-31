#!/bin/bash

env_name="${1:-$TEST_ENV}"
env_name="${env_name:-monocle3}"

monocle_version="${2:-$MONOCLE_VERSION}"
monocle_version="${monocle_version:-monocle3_alpha}"

python_version="${3:-$TRAVIS_PYTHON_VERSION}"
python_version="${python_version:-3.6}"

conda config --add channels defaults
conda config --add channels bioconda
conda config --add channels conda-forge

conda config --set always_yes yes --set changeps1 no --set channel_priority strict

conda create -q -n $env_name python=$python_version \
    bioconductor-monocle=2.10.0 bioconductor-delayedmatrixstats bioconductor-iranges louvain umap-learn \
    r-class r-classint r-dbi r-devtools r-doparallel r-e1071 r-future r-ggridges r-glmnet r-globals \
    r-htmltools r-htmlwidgets r-listenv r-lpsolveapi r-pbapply r-plotly r-reticulate r-rgl r-spdep \
    r-tidyr r-units libgdal udunits2

conda remove -q -n $env_name r-ddrtree bioconductor-monocle

source activate $env_name

Rscript -e 'Sys.setenv(TAR="/bin/tar", R_GZIPCMD="/bin/gzip", R_BZIPCMD="/bin/bzip2")' \
        -e 'install.packages("pbmcapply", repos="https://cran.ma.imperial.ac.uk")' \
        -e 'devtools::install_github("cole-trapnell-lab/DDRTree", ref="simple-ppt-like", upgrade="never")' \
        -e 'devtools::install_github("cole-trapnell-lab/L1-graph", upgrade="never")' \
        -e 'devtools::install_github("cole-trapnell-lab/monocle-release", ref="'$monocle_version'", upgrade="never")'
