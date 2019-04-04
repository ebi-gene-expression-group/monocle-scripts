# monocle-scripts
Command line scripts wrapping functions in monocle3

## 1. Install

### 1.1 Install Monocle3

#### a. Manually
Create and activate a conda environment with r-base and python, then follow [monocle3 installation guide](http://cole-trapnell-lab.github.io/monocle-release/monocle3/#installing-monocle-3).

#### b. With help of Conda
Use provided [install_monocle3.sh](https://github.com/ebi-gene-expression-group/monocle-scripts/blob/develop/install_monocle3.sh) which uses **conda** to install most of the dependencies.

### 1.2 Install monocle-scripts
```
$ conda activate <name-of-conda-environment-with-monocle3-installed>
$ Rscript -e 'devtools::install_github("ebi-gene-expression-group/monocle-scripts")'
```

### 1.3 Test installation
This test requires [bats](https://github.com/bats-core/bats-core) available in the same conda environment as monocle-scripts. Run:
```
$ wget 'https://github.com/ebi-gene-expression-group/monocle-scripts/raw/develop/monocle-scripts-post-install-tests.bats'
$ chmod +x monocle-scripts-post-install-tests.bats
$ ./monocle-scripts-post-install-tests.bats
```
