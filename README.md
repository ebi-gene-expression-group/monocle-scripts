# monocle-scripts
Command line scripts wrapping functions in [Monocle3](https://cole-trapnell-lab.github.io/monocle3/)

## 1. Installation

### 1.1. Install Monocle3

#### a. Manually
Create and activate a conda environment with r-base and python, then follow [monocle3 installation guide](https://cole-trapnell-lab.github.io/monocle3/monocle3_docs/#installing-monocle-3).

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

Currently only covers steps introduced in [Monocle3 documentation: Constructing single-cell trajectories](https://cole-trapnell-lab.github.io/monocle3/monocle3_docs/#constructing-single-cell-trajectories)

```
Usage: monocle3 [-h] <command> ...

Commands:
  create            Creation of Monocle 3 object from expression and metadata.
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

### 2.1. Create CDS object

```
Usage: monocle3 create [options] <output_object>

<output_object>:
		Output object, can be SingleCellExperiment(sce), Seurat object(seurat), or CellDataSet V3(cds3). Only cds3 is supported currently.

Options:
	-F STR, --output-object-format=STR
		Format of output object. [Default: cds3]

	-I, --introspective
		Print introspective information of the output object.

	--expression-matrix=STR
		Expression matrix, genes as rows, cells as columns. Required input. Provide as TSV, CSV or RDS.

	--cell-metadata=STR
		Per-cell annotation, optional. Row names must match the column names of the expression matrix. Provide as TSV, CSV or RDS.

	--gene-annotation=STR
		Per-gene annotation, optional. Row names must match the row names of the expression matrix. Provide as TSV, CSV or RDS.

	-v, --verbose
		Emit verbose output.

	-h, --help
		Show this help message and exit
```

### 2.2. Preprocess

```
Usage: monocle3 preprocess [options] <input_object> <output_object>

<input_object>:
		Input object, can be SingleCellExperiment(sce), Seurat object(seurat), CellDataSet V2(cds2) or V3(cds3). Only cds3 is supported currently.

<output_object>:
		Output object, can be SingleCellExperiment(sce), Seurat object(seurat), or CellDataSet V3(cds3). Only cds3 is supported currently.

Options:
	-f STR, --input-object-format=STR
		Format of input object. [Default: cds3]

	-F STR, --output-object-format=STR
		Format of output object. [Default: cds3]

	-I, --introspective
		Print introspective information of the output object.

	--method=STR
		The initial dimension method to use, choose from {PCA, LSI}. [Default: PCA]

	--num-dim=INT
		The dimensionality of the reduced space. [Default: 50]

	--norm-method=STR
		Determines how to transform expression values prior to reducing dimensionality, choose from {log, size_only}. [Default: log]

	--use-genes=STR
		Manually subset the gene pool to these genes for dimensionality reduction, NULL to skip. [Default: NULL]

	--residual-model-formula-str=STR
		A string model formula specifying effects to subtract from the data, NULL to skip. [Default: NULL]

	--pseudo-count=FLOAT
		Amount to increase expression values before dimensionality reduction. [Default: 1]

	--no-scaling
		When this option is NOT set, scale each gene before running trajectory reconstruction.

	-v, --verbose
		Emit verbose output.

	-h, --help
		Show this help message and exit
```

### 2.3. Reduce dimensionality

```
Usage: monocle3 reduceDim [options] <input_object> <output_object>

<input_object>:
		Input object, can be SingleCellExperiment(sce), Seurat object(seurat), CellDataSet V2(cds2) or V3(cds3). Only cds3 is supported currently.

<output_object>:
		Output object, can be SingleCellExperiment(sce), Seurat object(seurat), or CellDataSet V3(cds3). Only cds3 is supported currently.

Options:
	-f STR, --input-object-format=STR
		Format of input object. [Default: cds3]

	-F STR, --output-object-format=STR
		Format of output object. [Default: cds3]

	-I, --introspective
		Print introspective information of the output object.

	--max-components=INT
		The dimensionality of the reduced space. [Default 2]

	--reduction-method=STR
		The algorithm to use for dimensionality reduction, choose from {UMAP, tSNE, PCA, LSI}. [Default: UMAP]

	--preprocess-method=STR
		The preprocessing method used on the data, choose from {PCA, LSI}. [Default: PCA]

	--cores=CORES
		The number of cores to be used for dimensionality reduction. [Default: 1]

	-v, --verbose
		Emit verbose output.

	-h, --help
		Show this help message and exit
```

### 2.4. Partition cells

```
Usage: monocle3 partition [options] <input_object> <output_object>

<input_object>:
		Input object, can be SingleCellExperiment(sce), Seurat object(seurat), CellDataSet V2(cds2) or V3(cds3). Only cds3 is supported currently.

<output_object>:
		Output object, can be SingleCellExperiment(sce), Seurat object(seurat), or CellDataSet V3(cds3). Only cds3 is supported currently.

Options:
	-f STR, --input-object-format=STR
		Format of input object. [Default: cds3]

	-F STR, --output-object-format=STR
		Format of output object. [Default: cds3]

	-I, --introspective
		Print introspective information of the output object.

	--reduction-method=STR
		The dimensionality reduction to base the clustering on, choose from {UMAP, tSNE, PCA, LSI}. [Default: UMAP]

	--knn=INT
		Number of nearest neighbours used for Louvain clustering. [Default: 20]

	--weight
		When this option is set, calculate the weight for each edge in the kNN graph.

	--louvain-iter=INT
		The number of iteration for Louvain clustering. [Default: 1]

	--resolution=FLOAT
		Resolution of clustering result, specifying the granularity of clusters. Not used by default and the standard igraph louvain clustering algorithm will be used.

	--partition-qval=FLOAT
		The q-value threshold used to determine the partition of cells. [Default: 0.05]

	-v, --verbose
		Emit verbose output.

	-h, --help
		Show this help message and exit
```

### 2.5. Learn graph

```
Usage: monocle3 learnGraph [options] <input_object> <output_object>

<input_object>:
		Input object, can be SingleCellExperiment(sce), Seurat object(seurat), CellDataSet V2(cds2) or V3(cds3). Only cds3 is supported currently.

<output_object>:
		Output object, can be SingleCellExperiment(sce), Seurat object(seurat), or CellDataSet V3(cds3). Only cds3 is supported currently.

Options:
	-f STR, --input-object-format=STR
		Format of input object. [Default: cds3]

	-F STR, --output-object-format=STR
		Format of output object. [Default: cds3]

	-I, --introspective
		Print introspective information of the output object.

	--no-partition
		When this option is set, learn a single tree structure for all the partitions. If not set, use the partitions calculated when clustering and identify disjoint graphs in each.

	--no-close-loop
		When this option is set, skip the additional run of loop closing after computing the principal graphs to identify potential loop structure in the data space.

	--euclidean-distance-ratio=FLOAT
		The maximal ratio between the euclidean distance of two tip nodes in the spanning tree inferred from SimplePPT algorithm and that of the maximum distance between any connecting points on the spanning tree allowed to be connected during the loop closure procedure. [Default: 1]

	--geodesic-distance-ratio=FLOAT
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

### 2.6. Order cells along trajectories

```
Usage: monocle3 orderCells [options] <input_object> <output_object>

<input_object>:
		Input object, can be SingleCellExperiment(sce), Seurat object(seurat), CellDataSet V2(cds2) or V3(cds3). Only cds3 is supported currently.

<output_object>:
		Output object, can be SingleCellExperiment(sce), Seurat object(seurat), or CellDataSet V3(cds3). Only cds3 is supported currently.

Options:
	-f STR, --input-object-format=STR
		Format of input object. [Default: cds3]

	-F STR, --output-object-format=STR
		Format of output object. [Default: cds3]

	-I, --introspective
		Print introspective information of the output object.

	--root-pr-nodes=STR
		The starting principal points. We learn a principal graph that passes
		through the middle of the data points and use it to represent the
		developmental process. Exclusive with --root-cells.

	--root-cells=STR
		The starting cells. Each cell corresponds to a principal point and multiple cells can correspond to the same principal point. Exclusive with --root-pr-nodes.

	--cell-phenotype=STR
		The cell phenotype (column in pdata) used to identify root principal nodes.

	--root-type=STR
		The value of the phenotype specified by "--cell-pheontype" that defines cells root principal nodes.

	--reduction-method=STR
		The dimensionality reduction that was used for clustering, choose from {UMAP, tSNE, PCA, LSI}. [Default: UMAP]

	-v, --verbose
		Emit verbose output.

	-h, --help
		Show this help message and exit
```

### 2.7. Test of differential expression over a trajectory

```
Usage: monocle3 diffExp [options] <input_object> <output_table>

<input_object>:
		Input object, can be SingleCellExperiment(sce), Seurat object(seurat), CellDataSet V2(cds2) or V3(cds3). Only cds3 is supported currently.

<output_table>:
		Output table file name.

Options:
	-f STR, --input-object-format=STR
		Format of input object. [Default: cds3]

	-F STR, --output-table-format=STR
		Format of output table, choose from {tsv, csv}. [Default: tsv]

	-I, --introspective
		Print introspective information of the output table.

	--neighbor-graph=STR
		What neighbor graph to use, "principal_graph" recommended for trajectory analysis, choose from {principal_graph, knn}. [Default: knn]

	--reduction-method=STR
		The dimensionality reduction to base the clustering on, choose from {UMAP}. [Default: UMAP]

	--knn=KNN
		Number of nearest neighbors used for building the kNN graph which is passed to knn2nb function during the Moran's I (Geary's C) test procedure.

	--method=METHOD
		A character string specifying the method for detecting significant genes showing correlated expression along the principal graph embedded in the low dimensional space, choose from {Moran_I}. [Default: Moran_I]

	--alternative=ALTERNATIVE
		A character string specifying the alternative hypothesis, choose from {greater, less, two.sided}. [Default: greater]

	--cores=CORES
		The number of cores to be used while testing each gene for differential expression. [Default: 1]

	-v, --verbose
		Emit verbose output.

	-h, --help
		Show this help message and exit
```

### 2.7. Plot trajectories

```
Usage: monocle3 plotCells [options] <input_object> <output_plot>

<input_object>:
		Input object, can be SingleCellExperiment(sce), Seurat object(seurat), CellDataSet V2(cds2) or V3(cds3). Only cds3 is supported currently.

<output_plot>:
		Output plot file name.

Options:
	-f STR, --input-object-format=STR
		Format of input object. [Default: cds3]

	-F STR, --output-plot-format=STR
		Format of output plot, choose from {png, pdf}. [Default: png]

	--xdim=XDIM
		The column of reducedDimS(cds) to plot on the horizontal axis. [Default: 1]

	--ydim=YDIM
		The column of reducedDimS(cds) to plot on the vertical axis. [Default: 2]

	--reduction-method=STR
		The dimensionality reduction for plotting, choose from {UMAP, tSNE, PCA, LSI}. [Default: UMAP]

	--color-cells-by=COLOR-CELLS-BY
		The cell attribute (e.g. the column of pData(cds)) to map to each cell's color, or one of {clusters, partitions, pseudotime}. [Default: pseudotime]

	--genes=STR
		A list of gene IDs/short names to plot, one per panel.

	--norm-method=STR
		Determines how to transform expression values for plotting, choose from {log, size_only}. [Default: log]

	--cell-size=CELL-SIZE
		The size of the point for each cell. [Default: 1.5]

	--alpha=ALPHA
		The alpha aesthetics for the original cell points, useful to highlight the learned principal graph.

	--label-cell-groups
		If set, display the cell group names directly on the plot. Otherwise include a color legend on the side of the plot.

	--no-trajectory-graph
		When this option is set, skip displaying the trajectory graph inferred by learn_graph().

	--label-groups-by-cluster
		If set, and setting --color-cells-by to something other than cluster, label the cells of each cluster independently. Can result in duplicate labels being present in the manifold.

	--label-leaves
		If set, label the leaves of the principal graph.

	--label-roots
		If set, label the roots of the principal graph.

	--label-branch-points
		If set, label the branch points of the principal graph.

	-v, --verbose
		Emit verbose output.

	-h, --help
		Show this help message and exit
```

## 3. Limitation and known issues

  1. Only support reading/writing CDS version3 object
