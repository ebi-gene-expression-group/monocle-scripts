# monocle-scripts
Command line scripts wrapping functions in [Monocle3](http://cole-trapnell-lab.github.io/monocle-release/monocle3)

## 1. Installation

### 1.1. Install Monocle3

#### a. Manually
Create and activate a conda environment with r-base and python, then follow [monocle3 installation guide](http://cole-trapnell-lab.github.io/monocle-release/monocle3/#installing-monocle-3).

#### b. Conda-assisted
Use provided [install_monocle3.sh](install_monocle3.sh) which uses **conda** to install most of the dependencies.

### 1.2. Install monocle-scripts
```
$ conda activate <monocle3-env>
$ Rscript -e 'devtools::install_github("ebi-gene-expression-group/monocle-scripts")'
```
The installed executable script is at
```$CONDA_PREFIX/<monocle3-env>/lib/R/library/MonocleScripts/exec/monocle3```.


### 1.3. Test installation
This test requires [bats](https://github.com/bats-core/bats-core) available in the same conda environment as monocle-scripts. Run:
```
$ wget 'https://github.com/ebi-gene-expression-group/monocle-scripts/raw/develop/monocle-scripts-post-install-tests.bats'
$ chmod +x monocle-scripts-post-install-tests.bats
$ ./monocle-scripts-post-install-tests.bats
```

## 2. Usage

Currently only covers steps introduced in [Monocle3 tutorial 1: learning trajectories with Monocle3](http://cole-trapnell-lab.github.io/monocle-release/monocle3/#tutorial-1-learning-trajectories-with-monocle-3).

```
Usage: monocle3 [-h] <command> ...

Commands:
  preprocess        Normalisation, scaling, initial dimension reduction.
  reduceDim         Reduce dimensionality by UMAP.
  partition         Partition cells into groups.
  learnGraph        Learn trajectories.
  orderCells        Adjust the start of pseudo-time
  diffExp           Identify genes with varing expression along trajectories.
  plotCells         Visualise trajectories.

Options:
  -h, --help        Show this help message and exit
```

### 2.1. Preprocess

```
Usage: monocle3 preprocess [options] <input_object> <output_object>

<input_object>:
		Input object, can be SingleCellExperiment(sce), Seurat object(seurat), CellDataSet V2(cds2) or V3(cds3).

<output_object>:
		Output object, can be SingleCellExperiment(sce), Seurat object(seurat), or CellDataSet V3(cds3).

Options:
	-f STR, --input-object-format=STR
		Format of input object, choose from {sce, seurat, cds2, cds3}. [Default: cds3]

	-F STR, --output-object-format=STR
		Format of output object, choose from {sce, seurat, cds3}. [Default: cds3]

	-I, --introspective
		Print introspective information of the output object.

	--method=STR
		The initial dimension method to use, choose from {PCA, none}. [Default: PCA]

	--num-dim=INT
		The dimensionality of the reduced space. [Default: 50]

	--norm-method=STR
		Determines how to transform expression values prior to reducing dimensionality, choose from {log, vstExprs, none}. [Default: log]

	--pseudo-expr=FLOAT
		Amount to increase expression values before dimensionality reduction. [Default: 1]

	--no-relative-expr
		When this option is NOT set, convert the expression into a relative expression.

	--no-scaling
		When this option is NOT set, scale each gene before running trajectory reconstruction.

	-v, --verbose
		Emit verbose output.

	-h, --help
		Show this help message and exit
```

### 2.2. Reduce dimensionality

```
Usage: monocle3 reduceDim [options] <input_object> <output_object>

<input_object>:
		Input object, can be SingleCellExperiment(sce), Seurat object(seurat), CellDataSet V2(cds2) or V3(cds3). 

<output_object>:
		Output object, can be SingleCellExperiment(sce), Seurat object(seurat), or CellDataSet V3(cds3).

Options:
	-f STR, --input-object-format=STR
		Format of input object, choose from {sce, seurat, cds2, cds3}. [Default: cds3]

	-F STR, --output-object-format=STR
		Format of output object, choose from {sce, seurat, cds3}. [Default: cds3]

	-I, --introspective
		Print introspective information of the output object.

	--max-components=INT
		The dimensionality of the reduced space. [Default 2]

	--reduction-method=STR
		The algorithm to use for dimensionality reduction, choose from {UMAP, tSNE, DDRTree, ICA, none}. [Default: UMAP]

	--no-auto-param-selection
		When this option is NOT set, automatically calculation of the proper value for the parameter "ncenter" (number of centroids) which will be passed into DDRTree call.

	--no-scaling
		When this option is NOT set, scale each gene before running trajectory reconstruction.

	-v, --verbose
		Emit verbose output.

	-h, --help
		Show this help message and exit
```

### 2.3. Partition cells

```
Usage: monocle3 partition [options] <input_object> <output_object>

<input_object>:
		Input object, can be SingleCellExperiment(sce), Seurat object(seurat), CellDataSet V2(cds2) or V3(cds3).

<output_object>:
		Output object, can be SingleCellExperiment(sce), Seurat object(seurat), or CellDataSet V3(cds3).

Options:
	-f STR, --input-object-format=STR
		Format of input object, choose from {sce, seurat, cds2, cds3}. [Default: cds3]

	-F STR, --output-object-format=STR
		Format of output object, choose from {sce, seurat, cds3}. [Default: cds3]

	-I, --introspective
		Print introspective information of the output object.

	--partition-names=STR
		Which partition groups (column in pData) should be used to calculate the connectivity between partitions. [Default NULL]

	--use-pca
		When this option is set, cluster cells based on top PCA components.

	--knn=INT
		Number of nearest neighbours used for Louvain clustering. [Default: 20]

	--weight
		When this option is set, calculate the weight for each edge in the kNN graph.

	--louvain-iter=INT
		The number of iteration for Louvain clustering. [Default: 1]

	--resolution=FLOAT
		Resolution of clustering result, specifying the granularity of clusters. Not used by default and the standard igraph louvain clustering algorithm will be used.

	--louvain-qval=FLOAT
		The q-value threshold used to determine the partition of cells. [Default: 0.05]

	--return-all
		When this option is set, return all saved objects from compute_louvain_connected_components().

	-v, --verbose
		Emit verbose output.

	-h, --help
		Show this help message and exit
```

### 2.4. Learn graph

```
Usage: monocle3 learnGraph [options] <input_object> <output_object>

<input_object>:
		Input object, can be SingleCellExperiment(sce), Seurat object(seurat), CellDataSet V2(cds2) or V3(cds3).

<output_object>:
		Output object, can be SingleCellExperiment(sce), Seurat object(seurat), or CellDataSet V3(cds3).

Options:
	-f STR, --input-object-format=STR
		Format of input object, choose from {sce, seurat, cds2, cds3}. [Default: cds3]

	-F STR, --output-object-format=STR
		Format of output object, choose from {sce, seurat, cds3}. [Default: cds3]

	-I, --introspective
		Print introspective information of the output object.

	--max-components=INT
		The dimensionality of the reduced space. [Default 2]

	--rge-method=STR
		Determines how to transform expression values prior to reducing dimensionality. [Default: SimplePPT]

	--no-auto-param-selection
		When this option is NOT set, automatically calculation of the proper value for the parameter "ncenter" (number of centroids) which will be passed into DDRTree call.

	--partition-group=STR
		Which partition groups (column in pData) should be used when learning separate trees for each partition. [Default: louvain_component]

	--no-partition
		When this option is NOT set, learn a tree structure for each separate over-connected louvain component.

	--scale
		When this option is set, scale each gene before running trajectory reconstruction.

	--close-loop
		When this option is set, perform an additional run of loop closing after running DDRTree or SimplePPT to identify potential loop structure in the data space.

	--euclidean-distance-ratio=FLOAT
		The maximal ratio between the euclidean distance of two tip nodes in the spanning tree inferred from SimplePPT algorithm and that of the maximum distance between any connecting points on the spanning tree allowed to be connected during the loop closure procedure. [Default: 1]

	--geodestic-distance-ratio=FLOAT
		The minimal ratio between the geodestic distance of two tip nodes in the spanning tree inferred from SimplePPT algorithm and that of the length of the diameter path on the spanning tree allowed to be connected during the loop closure procedure. (Both euclidean_distance_ratio and geodestic_distance_ratio need to be satisfied to introduce the edge for loop closure.)

	--no-prune-graph
		When this option is set, perform an additional run of graph pruning to remove smaller insignificant branches.

	--minimal-branch-len=INT
		The minimal length of the diameter path for a branch to be preserved during graph pruning procedure. [Default: 10]

	--orthogonal-proj-tip
		When this option is set, perform orthogonal projection for cells corresponding to the tip principal points.

	-v, --verbose
		Emit verbose output.

	-h, --help
		Show this help message and exit
```

### 2.5. Order cells along trajectories

```
Usage: monocle3 orderCells [options] <input_object> <output_object>

<input_object>:
		Input object, can be SingleCellExperiment(sce), Seurat object(seurat), CellDataSet V2(cds2) or V3(cds3).

<output_object>:
		Output object, can be SingleCellExperiment(sce), Seurat object(seurat), or CellDataSet V3(cds3).

Options:
	-f STR, --input-object-format=STR
		Format of input object, choose from {sce, seurat, cds2, cds3}. [Default: cds3]

	-F STR, --output-object-format=STR
		Format of output object, choose from {sce, seurat, cds3}. [Default: cds3]

	-I, --introspective
		Print introspective information of the output object.

	--root-pr-nodes=STR
		The starting principal points. We learn a principal graph that passes
		through the middle of the data points and use it to represent the
		developmental process.

	--root-cells=STR
		The starting cells. Each cell corresponds to a principal point and multiple cells can correspond to the same principal point.

	--reverse
		When this option is set, reverse the direction of the trajectory.

	--orthogonal-proj-tip
		When this option is set, perform orthogonal projection for cells corresponding to the tip principal points.

	--cell-phenotype=STR
		The cell phenotype (column in pdata) used to identify root principal nodes.

	--root-type=STR
		The value of the phenotype specified by "--cell-pheontype" that defines cells root principal nodes.

	-v, --verbose
		Emit verbose output.

	-h, --help
		Show this help message and exit
```

### 2.6. Test of differential expression over a trajectory

```
Usage: monocle3 diffExp [options] <input_object> <output_table>

<input_object>:
		Input object, can be SingleCellExperiment(sce), Seurat object(seurat), CellDataSet V2(cds2) or V3(cds3).

<output_table>:
		Output table file name.

Options:
	-f STR, --input-object-format=STR
		Format of input object, choose from {sce, seurat, cds2, cds3}. [Default: cds3]

	-F STR, --output-table-format=STR
		Format of output table, choose from {tsv, csv}. [Default: tsv]

	-I, --introspective
		Print introspective information of the output table.

	--no-relative-expr
		When this option is NOT set, convert the expression into a relative expression.

	--knn=KNN
		Number of nearest neighbors used for building the kNN graph which is passed to knn2nb function during the Moran's I (Geary's C) test procedure.

	--method=METHOD
		A character string specifying the method for detecting significant genes showing correlated expression along the principal graph embedded in the low dimensional space, choose from {Moran_I, Geary_C}. [Default: Moran_I]

	--alternative=ALTERNATIVE
		A character string specifying the alternative hypothesis, choose from {greater, less, two.sided}. [Default: greater]

	--cores=CORES
		The number of cores to be used while testing each gene for differential expression. [Default: 1]

	--interactive
		When this option is set, allow user to choose a point or region in the scene, then to only identify genes spatially correlated for those selected cells.

	-v, --verbose
		Emit verbose output.

	-h, --help
		Show this help message and exit
```

### 2.7. Plot trajectories

```
Usage: monocle3 plotCells [options] <input_object> <output_plot>

<input_object>:
		Input object, can be SingleCellExperiment(sce), Seurat object(seurat), CellDataSet V2(cds2) or V3(cds3).

<output_plot>:
		Output plot file name.

Options:
	-f STR, --input-object-format=STR
		Format of input object, choose from {sce, seurat, cds2, cds3}. [Default: cds3]

	-F STR, --output-plot-format=STR
		Format of output plot, choose from {png, pdf}. [Default: png]

	--xdim=XDIM
		The column of reducedDimS(cds) to plot on the horizontal axis. [Default: 1]

	--ydim=YDIM
		The column of reducedDimS(cds) to plot on the vertical axis. [Default: 2]

	--color-by=COLOR-BY
		The cell attribute (e.g. the column of pData(cds)) to map to each cell's color. [Default: Pseudotime]

	--hide-backbone
		When this option is NOT set, show the diameter path of the MST used to order the cell.

	--backbone-color=BACKBONE-COLOR
		The color used to render the backbone. [Default: black]

	--markers=MARKERS
		A gene name or gene id to use for setting the size of each cell in the plot. [Default: NULL]

	--use-color-gradient
		When this option is set, use color gradient instead of cell size to show marker expression level.

	--markers-linear
		When this option is set, scale the markers linearly, otherwise scale them logarithimically.

	--show-cell-names
		When this option is set, draw the name of each cell in the plot.

	--show-state-number
		When this option is set, show state number

	--cell-size=CELL-SIZE
		The size of the point for each cell. [Default: 1.5]

	--cell-link-size=CELL-LINK-SIZE
		The size of the line segments connecting cells (when used with ICA) or the principal graph (when used with DDRTree. [Default: 0.75]

	--cell-name-size=CELL-NAME-SIZE
		The size of cell name label. [Default: 2]

	--state-number-size=STATE-NUMBER-SIZE
		The size of the state number. [Default: 2]

	--hide-branch-points
		When this option is NOT set, show icons for each branch point (only available after running assign_cell_states)

	--theta=THETA
		Degree to rotate the trajectory

	--alpha=ALPHA
		The alpha aesthetics for the original cell points, useful to highlight the learned principal graph.

	-v, --verbose
		Emit verbose output.

	-h, --help
		Show this help message and exit
```

## 3. Known issues
  1. Support for reading/writing SingleCellExperiment object is broken.
