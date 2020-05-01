#' Command line arguments for input_object
input_options <- function() {
    list(
        input_object = list(
            name = '<input_object>',
            type = as.character,
            help = paste(
                'Input object, can be SingleCellExperiment(sce), Seurat',
                'object(seurat), CellDataSet V2(cds2) or V3(cds3).',
                'Only cds3 is supported currently.'
            )
        ),
        make_option(
            c('-f', '--input-object-format'),
            action = 'callback',
            type = 'character',
            default = 'cds3',
            metavar = 'STR',
            callback = check_choose_from(choices = c('cds3')),
            help = 'Format of input object. [Default: %default]'
        )
    )
}

#' Command line arguments for output_object
output_object_options <- function() {
    list(
        output_object = list(
            name = '<output_object>',
            type = as.character,
            help = paste(
                'Output object, can be SingleCellExperiment(sce), Seurat',
                'object(seurat), or CellDataSet V3(cds3).',
                'Only cds3 is supported currently.'
            )
        ),
        make_option(
            c('-F', '--output-object-format'),
            action = 'callback',
            type = 'character',
            default = 'cds3',
            metavar = 'STR',
            callback = check_choose_from(choices = c('cds3')),
            help = 'Format of output object. [Default: %default]'
        ),
        make_option(
            c('-I', '--introspective'),
            action = 'store_true',
            type = 'logical',
            default = FALSE,
            help = 'Print introspective information of the output object.'
        )
    )
}

#' Command line arguments for output_plot
output_plot_options <- function() {
    list(
        output_plot = list(
            name = '<output_plot>',
            type = as.character,
            help = 'Output plot file name.'
        ),
        make_option(
            c('-F', '--output-plot-format'),
            action = 'callback',
            type = 'character',
            default = 'png',
            metavar = 'STR',
            callback = check_choose_from(choices = c('png', 'pdf')),
            help = 'Format of output plot, choose from {png, pdf}. [Default: %default]'
        )
    )
}

#' Command line arguments for output_table
output_table_options <- function() {
    list(
        output_table = list(
            name = '<output_table>',
            type = as.character,
            help = 'Output table file name.'
        ),
        make_option(
            c('-F', '--output-table-format'),
            action = 'callback',
            type = 'character',
            default = 'tsv',
            metavar = 'STR',
            callback = check_choose_from(choices = c('tsv', 'csv')),
            help = 'Format of output table, choose from {tsv, csv}. [Default: %default]'
        ),
        make_option(
            c('-I', '--introspective'),
            action = 'store_true',
            type = 'logical',
            default = FALSE,
            help = 'Print introspective information of the output table.'
        )
    )
}

common_options <- function() {
    list(
        make_option(
            c('-v', '--verbose'),
            action = 'store_true',
            type = 'logical',
            default = FALSE,
            help = 'Emit verbose output.'
        )
    )
}

function_options <- function(func_names) {
    func_options <- list(
        #' Command line arguments for createCDS
        createCDS = list(
            make_option(
                c('--expression-matrix'),
                action = 'store',
                type = 'character',
                metavar = 'STR',
                help = paste(
                    'Expression matrix, genes as rows, cells as columns. Required input. ',
                    'Provide as TSV, CSV, RDS or MTX. In the case of MTX,',
                    'requires both --cell-metadata and --gene-annotation.'
                )
            ),
            make_option(
                c('--cell-metadata'),
                action = 'store',
                type = 'character',
                default = NULL,
                metavar = 'STR',
                help = paste(
                    'Per-cell annotation, optional unless expression as MTX.',
                    'Row names must match the column names of the expression matrix.',
                    'Provide as TSV, CSV or RDS.'
                )
            ),
            make_option(
                c('--gene-annotation'),
                action = 'store',
                type = 'character',
                default = NULL,
                metavar = 'STR',
                help = paste(
                    'Per-gene annotation, optional unless expression as MTX.',
                    'Row names must match the row names of the expression matrix. Provide as TSV, CSV or RDS.'
                )
            )
        ),
        
        #' Command line arguments for preprocessCDS
        preprocessCDS = list(
            make_option(
                c('--method'),
                action = 'callback',
                type = 'character',
                default = 'PCA',
                metavar = 'STR',
                callback = check_choose_from(choices = c('PCA', 'LSI')),
                help = 'The initial dimension method to use, choose from {PCA, LSI}. [Default: %default]'
            ),
            make_option(
                c('--num-dim'),
                action = 'store',
                type = 'integer',
                default = 50,
                metavar = 'INT',
                help = 'The dimensionality of the reduced space. [Default: %default]'
            ),
            make_option(
                c('--norm-method'),
                action = 'callback',
                type = 'character',
                default = 'log',
                metavar = 'STR',
                callback = check_choose_from(choices = c('log', 'size_only')),
                help = paste(
                    'Determines how to transform expression values prior to reducing dimensionality,',
                    'choose from {log, size_only}. [Default: %default]'
                )
            ),
            make_option(
                c('--use-genes'),
                action = 'store',
                type = 'character',
                default = NULL,
                metavar = 'STR',
                help = paste(
                    'Manually subset the gene pool to these genes for dimensionality reduction,',
                    'NULL to skip. [Default: %default]'
                )
            ),
            make_option(
                c('--residual-model-formula-str'),
                action = 'store',
                type = 'character',
                default = NULL,
                metavar = 'STR',
                help = paste(
                    'A string model formula specifying effects to subtract from the data,',
                    'NULL to skip. [Default: %default]'
                )
            ),
            make_option(
                c('--pseudo-count'),
                action = 'store',
                type = 'numeric',
                default = 1,
                metavar = 'FLOAT',
                help = paste(
                    'Amount to increase expression values before dimensionality',
                    'reduction. [Default: %default]'
                )
            ),
            make_option(
                c('--no-scaling'),
                action = 'store_false',
                type = 'logical',
                dest = 'scaling',
                default = TRUE,
                help = paste(
                    'When this option is NOT set, scale each gene before',
                    'running trajectory reconstruction.'
                )
            )
        ),

        #' Command line arguments for reduceDimension
        reduceDimension = list(
            make_option(
                c('--max-components'),
                action = 'store',
                type = 'integer',
                default = 2,
                metavar = 'INT',
                help = 'The dimensionality of the reduced space. [Default %default]'
            ),
            make_option(
                c('--reduction-method'),
                action = 'callback',
                type = 'character',
                default = 'UMAP',
                metavar = 'STR',
                callback = check_choose_from(choices = c('UMAP', 'tSNE', 'PCA', 'LSI')),
                help = paste(
                    'The algorithm to use for dimensionality reduction,',
                    'choose from {UMAP, tSNE, PCA, LSI}.',
                    '[Default: %default]'
                )
            ),
            make_option(
                c('--preprocess-method'),
                action = 'callback',
                type = 'character',
                default = 'PCA',
                metavar = 'STR',
                callback = check_choose_from(choices = c('PCA', 'LSI')),
                help = paste(
                    'The preprocessing method used on the data,',
                    'choose from {PCA, LSI}.',
                    '[Default: %default]'
                )
            ),
            make_option(
                c('--cores'),
                action = 'store',
                type = 'integer',
                default = 1,
                help = paste(
                    'The number of cores to be used for dimensionality reduction.',
                    '[Default: %default]'
                )
            )
        ),

        #' Command line arguments for partitionCells
        partitionCells = list(
            make_option(
                c('--reduction-method'),
                action = 'callback',
                type = 'character',
                default = 'UMAP',
                metavar = 'STR',
                callback = check_choose_from(choices = c('UMAP', 'tSNE', 'PCA', 'LSI')),
                help = paste(
                    'The dimensionality reduction to base the clustering on,',
                    'choose from {UMAP, tSNE, PCA, LSI}.',
                    '[Default: %default]'
                )
            ),
            make_option(
                c('--knn'),
                action = 'store',
                type = 'integer',
                dest = 'k',
                default = 20,
                metavar = 'INT',
                help = 'Number of nearest neighbours used for Louvain clustering. [Default: %default]'
            ),
            make_option(
                c('--weight'),
                action = 'store_true',
                type = 'logical',
                default = FALSE,
                help = paste(
                    'When this option is set, calculate the weight for each',
                    'edge in the kNN graph.'
                )
            ),
            make_option(
                c('--louvain-iter'),
                action = 'store',
                type = 'integer',
                default = 1,
                metavar = 'INT',
                help = 'The number of iteration for Louvain clustering. [Default: %default]'
            ),
            make_option(
                c('--resolution'),
                action = 'store',
                type = 'numeric',
                default = NULL,
                metavar = 'FLOAT',
                help = paste(
                    'Resolution of clustering result, specifying the granularity of clusters.',
                    'Not used by default and the standard igraph louvain clustering algorithm will be used.'
                )
            ),
            make_option(
                c('--partition-qval'),
                action = 'store',
                type = 'numeric',
                default = 0.05,
                metavar = 'FLOAT',
                help = 'The q-value threshold used to determine the partition of cells. [Default: %default]'
            )
        ),

        #' Command line arguments for learnGraph
        learnGraph = list(
            make_option(
                c('--no-partition'),
                action = 'store_false',
                type = 'logical',
                dest = 'use-partition',
                default = TRUE,
                help = paste(
                    'When this option is set, learn a single tree structure for',
                    'all the partitions. If not set, use the partitions calculated',
                    'when clustering and identify disjoint graphs in each.'
                )
            ),
            make_option(
                c('--no-close-loop'),
                action = 'store_false',
                type = 'logical',
                dest = 'close-loop',
                default = TRUE,
                help = paste(
                    'When this option is set, skip the additional run of loop',
                    'closing after computing the principal graphs to identify',
                    'potential loop structure in the data space.'
                )
            ),
            make_option(
                c('--euclidean-distance-ratio'),
                action = 'store',
                type = 'numeric',
                default = 1,
                metavar = 'FLOAT',
                help = paste(
                    'The maximal ratio between the euclidean distance of two tip',
                    'nodes in the spanning tree inferred from SimplePPT algorithm',
                    'and that of the maximum distance between any connecting',
                    'points on the spanning tree allowed to be connected during',
                    'the loop closure procedure. [Default: %default]'
                )
            ),
            make_option(
                c('--geodesic-distance-ratio'),
                action = 'store',
                type = 'numeric',
                default = 1/3,
                metavar = 'FLOAT',
                help = paste(
                    'The minimal ratio between the geodestic distance of two',
                    'tip nodes in the spanning tree inferred from SimplePPT',
                    'algorithm and that of the length of the diameter path on',
                    'the spanning tree allowed to be connected during the loop',
                    'closure procedure. (Both euclidean_distance_ratio and',
                    'geodestic_distance_ratio need to be satisfied to introduce',
                    'the edge for loop closure.)'
                )
            ),
            make_option(
                c('--no-prune-graph'),
                action = 'store_false',
                type = 'logical',
                dest = 'prune-graph',
                default = TRUE,
                help = paste(
                    'When this option is set, perform an additional run of',
                    'graph pruning to remove smaller insignificant branches.'
                )
            ),
            make_option(
                c('--minimal-branch-len'),
                action = 'store',
                type = 'integer',
                default = 10,
                metavar = 'INT',
                help = paste(
                    'The minimal length of the diameter path for a branch to be',
                    'preserved during graph pruning procedure.',
                    '[Default: %default]'
                )
            ),
            make_option(
                c('--orthogonal-proj-tip'),
                action = 'store_true',
                type = 'logical',
                default = FALSE,
                help = paste(
                    'When this option is set, perform orthogonal projection for',
                    'cells corresponding to the tip principal points.'
                )
            )
        ),

        #' Command line arguments for get_root_principal_nodes
        get_root_principal_nodes = list(
            make_option(
                c('--cell-phenotype'),
                action = 'store',
                type = 'character',
                default = NULL,
                metavar = 'STR',
                help = paste(
                    'The cell phenotype (column in pdata) used to identify root',
                    'principal nodes.'
                )
            ),
            make_option(
                c('--root-type'),
                action = 'store',
                type = 'character',
                default = NULL,
                metavar = 'STR',
                help = paste(
                    'The value of the phenotype specified by "--cell-pheontype"',
                    'that defines cells root principal nodes.'
                )
            ),
            make_option(
                c('--reduction-method'),
                action = 'callback',
                type = 'character',
                default = 'UMAP',
                metavar = 'STR',
                callback = check_choose_from(choices = c('UMAP', 'tSNE', 'PCA', 'LSI')),
                help = paste(
                    'The dimensionality reduction that was used for clustering,',
                    'choose from {UMAP, tSNE, PCA, LSI}.',
                    '[Default: %default]'
                )
            )
        ),

        #' Command line arguments for orderCells
        orderCells = list(
            make_option(
                c('--root-pr-nodes'),
                action = 'store',
                type = 'character',
                default = NULL,
                metavar = 'STR',
                help = paste(strwrap(paste(
                    'The starting principal points. We learn a principal graph',
                    'that passes through the middle of the data points and use',
                    'it to represent the developmental process. Exclusive with --root-cells.'
                ), initial = '', prefix = '\t\t'), collapse='\n')
            ),
            make_option(
                c('--root-cells'),
                action = 'store',
                type = 'character',
                default = NULL,
                metavar = 'STR',
                help = paste(
                    'The starting cells. Each cell corresponds to a principal',
                    'point and multiple cells can correspond to the same',
                    'principal point. Exclusive with --root-pr-nodes.'
                )
            )
        ),

        #' Command line arguments for principalGraphTest
        principalGraphTest = list(
            make_option(
                c('--neighbor-graph'),
                action = 'callback',
                type = 'character',
                default = 'knn',
                metavar = 'STR',
                callback = check_choose_from(choices = c('principal_graph','knn')),
                help = paste(
                    'What neighbor graph to use, "principal_graph" recommended for trajectory analysis,',
                    'choose from {principal_graph, knn}.',
                    '[Default: %default]'
                )
            ),
            make_option(
                c('--reduction-method'),
                action = 'callback',
                type = 'character',
                default = 'UMAP',
                metavar = 'STR',
                callback = check_choose_from(choices = c('UMAP')),
                help = paste(
                    'The dimensionality reduction to base the clustering on,',
                    'choose from {UMAP}.',
                    '[Default: %default]'
                )
            ),
            make_option(
                c('--knn'),
                action = 'store',
                type = 'integer',
                dest = 'k',
                default = 20,
                help = paste(
                    'Number of nearest neighbors used for building the kNN',
                    'graph which is passed to knn2nb function during the',
                    'Moran\'s I (Geary\'s C) test procedure.'
                )
            ),
            make_option(
                c('--method'),
                action = 'callback',
                type = 'character',
                default = 'Moran_I',
                callback = check_choose_from(c('Moran_I')),
                help = paste(
                    'A character string specifying the method for detecting',
                    'significant genes showing correlated expression along the',
                    'principal graph embedded in the low dimensional space,',
                    'choose from {Moran_I}. [Default: %default]'
                )
            ),
            make_option(
                c('--alternative'),
                action = 'callback',
                type = 'character',
                default = 'greater',
                callback = check_choose_from(c('greater', 'less', 'two.sided')),
                help = paste(
                    'A character string specifying the alternative hypothesis,',
                    'choose from {greater, less, two.sided}. [Default: %default]'
                )
            ),
            make_option(
                c('--cores'),
                action = 'store',
                type = 'integer',
                default = 1,
                help = paste(
                    'The number of cores to be used while testing each gene for',
                    'differential expression. [Default: %default]'
                )
            )
        ),

        #' Command line arguments for plot_cell_trajectory
        plot_cell_trajectory = list(
            make_option(
                c('--xdim'),
                action = 'store',
                type = 'integer',
                dest = 'x',
                default = 1,
                help = paste(
                    'The column of reducedDimS(cds) to plot on the horizontal',
                    'axis. [Default: %default]'
                )
            ),
            make_option(
                c('--ydim'),
                action = 'store',
                type = 'integer',
                dest = 'y',
                default = 2,
                help = paste(
                    'The column of reducedDimS(cds) to plot on the vertical',
                    'axis. [Default: %default]'
                )
            ),
            make_option(
                c('--reduction-method'),
                action = 'callback',
                type = 'character',
                default = 'UMAP',
                metavar = 'STR',
                callback = check_choose_from(choices = c('UMAP', 'tSNE', 'PCA', 'LSI')),
                help = paste(
                    'The dimensionality reduction for plotting,',
                    'choose from {UMAP, tSNE, PCA, LSI}.',
                    '[Default: %default]'
                )
            ),
            make_option(
                c('--color-cells-by'),
                action = 'store',
                type = 'character',
                default = 'pseudotime',
                help = paste(
                    'The cell attribute (e.g. the column of pData(cds)) to map',
                    'to each cell\'s color, or one of {clusters, partitions, pseudotime}.',
                    '[Default: %default]'
                )
            ),
            make_option(
                c('--genes'),
                action = 'store',
                type = 'character',
                default = NULL,
                metavar = 'STR',
                help = paste(
                    'A list of gene IDs/short names to plot, one per panel.'
                )
            ),
            make_option(
                c('--norm-method'),
                action = 'callback',
                type = 'character',
                default = 'log',
                metavar = 'STR',
                callback = check_choose_from(choices = c('log', 'size_only')),
                help = paste(
                    'Determines how to transform expression values for plotting,',
                    'choose from {log, size_only}. [Default: %default]'
                )
            ),
            make_option(
                c('--cell-size'),
                action = 'store',
                type = 'numeric',
                default = 1.5,
                help = 'The size of the point for each cell. [Default: %default]'
            ),
            make_option(
                c('--alpha'),
                action = 'store',
                type = 'numeric',
                default = 1,
                help = paste(
                    'The alpha aesthetics for the original cell points, useful',
                    'to highlight the learned principal graph.'
                )
            ),
            make_option(
                c('--label-cell-groups'),
                action = 'store_true',
                type = 'logical',
                default = FALSE,
                help = paste(
                    'If set, display the cell group names directly on the plot.',
                    'Otherwise include a color legend on the side of the plot.'
                )
            ),
            make_option(
                c('--no-trajectory-graph'),
                action = 'store_false',
                type = 'logical',
                dest = 'show-trajectory-graph',
                default = TRUE,
                help = paste(
                    'When this option is set, skip displaying the trajectory graph',
                    'inferred by learn_graph().'
                )
            ),
            make_option(
                c('--label-groups-by-cluster'),
                action = 'store_true',
                type = 'logical',
                default = FALSE,
                help = paste(
                    'If set, and setting --color-cells-by to something other than cluster,',
                    'label the cells of each cluster independently. Can result in duplicate',
                    'labels being present in the manifold.'
                )
            ),
            make_option(
                c('--label-leaves'),
                action = 'store_true',
                type = 'logical',
                default = FALSE,
                help = paste(
                    'If set, label the leaves of the principal graph.'
                )
            ),
            make_option(
                c('--label-roots'),
                action = 'store_true',
                type = 'logical',
                default = FALSE,
                help = paste(
                    'If set, label the roots of the principal graph.'
                )
            ),
            make_option(
                c('--label-branch-points'),
                action = 'store_true',
                type = 'logical',
                default = FALSE,
                help = paste(
                    'If set, label the branch points of the principal graph.'
                )
            )
        ),
        
        #' Command line arguments for monocle_top_markers
        topMarkers = list(
            make_option(
                c('--group-cells-by'),
                action = 'store',
                type = 'character',
                default = 'cluster',
                help = paste(
                    'Cell groups, choose from "cluster", "partition", or any categorical variable',
                    'in `colData(cds)`}. [Default: %default]'
                )
            ),
            make_option(
                c('--genes-to-test-per-group'),
                action = 'store',
                type = 'integer',
                default = 25,
                help = paste(
                    'Numeric, how many genes of the top ranked specific genes by Jenson-Shannon',
                    'to do the more expensive regression test on. [Default: %default]'
                )
            ),
            make_option(
                c('--marker-sig-test'),
                action = 'store_true',
                type = 'logical',
                default = FALSE,
                help = paste(
                    'A flag indicating whether to assess the discriminative power of each marker', 
                    'through logistic regression. Can be slow, consider disabling to speed up top_markers().',
                    '[Default: %default]'
                )
            ),
            make_option(
                c('--reference-cells'),
                action = 'store',
                type = 'character',
                default = NULL,
                help = paste(
                    'If provided, top_markers will perform the marker significance test against a',
                    '"reference set" of cells. Must be either a list of cell ids from colnames(cds)',
                    '(comma separated), or a positive integer. If the latter, top_markers() will',
                    'randomly select the specified number of reference cells.',
                    'Accelerates the marker significance test at some cost in sensitivity.'
                )
            ),
            make_option(
                c('--cores'),
                action = 'store',
                type = 'integer',
                default = 1,
                help = paste(
                    'The number of cores to be used for marker testing.',
                    '[Default: %default]'
                )
            ),
            make_option(
                c('--filter-fraction-expression'),
                action = 'store',
                type = 'numeric',
                default = 0.10,
                metavar = 'FLOAT',
                help = 'Filters the markers test result by this fraction of expression [Default: %default]'
            ),
            make_option(
                c('--top-n-markers'),
                action = 'store',
                type = 'integer',
                default = 5,
                help = paste(
                    'The number of top marker genes to report in plots and in top markers list.',
                    '[Default: %default]'
                )
            ),
            make_option(
                c('--plot-top-markers'),
                action = 'store',
                type = 'character',
                default = NULL,
                help = 'Save top marker by cell group plot to a file specified by this option.'
            ),
            make_option(
                c('--save-full-markers'),
                action = 'store',
                type = 'character',
                default = NULL,
                help = 'Save full marker table to a file specified by this option.'
            )
        )
    )

    if (!is.null(func_names) && !is.na(func_names)) {
        func_options[func_names]
    } else {
        func_options
    }
}
