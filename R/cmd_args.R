#' Command line arguments for input_object
input_options <- function() {
    list(
        input_object = list(
            name = '<input_object>',
            type = as.character,
            help = paste(
                'Input object, can be SingleCellExperiment(sce), Seurat',
                'object(seurat), CellDataSet V2(cds2) or V3(cds3).'
            )
        ),
        make_option(
            c('-f', '--input-object-format'),
            action = 'callback',
            type = 'character',
            default = 'cds3',
            metavar = 'STR',
            callback = check_choose_from(choices = c('sce', 'seurat', 'cds2', 'cds3')),
            help = 'Format of input object, choose from {sce, seurat, cds2, cds3}. [Default: %default]'
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
                'object(seurat), or CellDataSet V3(cds3).'
            )
        ),
        make_option(
            c('-F', '--output-object-format'),
            action = 'callback',
            type = 'character',
            default = 'cds3',
            metavar = 'STR',
            callback = check_choose_from(choices = c('sce', 'seurat', 'cds3')),
            help = 'Format of output object, choose from {sce, seurat, cds3}. [Default: %default]'
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
        #' Command line arguments for preprocessCDS
        preprocessCDS = list(
            make_option(
                c('--method'),
                action = 'callback',
                type = 'character',
                default = 'PCA',
                metavar = 'STR',
                callback = check_choose_from(choices = c('PCA', 'none')),
                help = 'The initial dimension method to use, choose from {PCA, none}. [Default: %default]'
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
                callback = check_choose_from(choices = c('log', 'vstExprs', 'none')),
                help = paste(
                    'Determines how to transform expression values prior to reducing dimensionality,',
                    'choose from {log, vstExprs, none}. [Default: %default]'
                )
            ),
            make_option(
                c('--pseudo-expr'),
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
                c('--no-relative-expr'),
                action = 'store_false',
                type = 'logical',
                dest = 'relative-expr',
                default = TRUE,
                help = paste(
                    'When this option is NOT set, convert the expression into a',
                    'relative expression.'
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
                callback = check_choose_from(choices = c('UMAP', 'tSNE', 'DDRTree', 'ICA', 'none')),
                help = paste(
                    'The algorithm to use for dimensionality reduction,',
                    'choose from {UMAP, tSNE, DDRTree, ICA, none}.',
                    '[Default: %default]'
                )
            ),
            make_option(
                c('--no-auto-param-selection'),
                action = 'store_false',
                type = 'logical',
                dest = 'auto-param-selection',
                default = TRUE,
                help = paste(
                    'When this option is NOT set, automatically calculation of',
                    'the proper value for the parameter "ncenter" (number of',
                    'centroids) which will be passed into DDRTree call.'
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

        #' Command line arguments for partitionCells
        partitionCells = list(
            make_option(
                c('--partition-names'),
                action = 'store',
                type = 'character',
                default = NULL,
                metavar = 'STR',
                help = paste(
                    'Which partition groups (column in pData) should be used',
                    'to calculate the connectivity between partitions.',
                    '[Default %default]'
                )
            ),
            make_option(
                c('--use-pca'),
                action = 'store_true',
                type = 'logical',
                default = FALSE,
                help = paste(
                    'When this option is set, cluster cells based on top PCA',
                    'components.'
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
                c('--louvain-qval'),
                action = 'store',
                type = 'numeric',
                default = 0.05,
                metavar = 'FLOAT',
                help = 'The q-value threshold used to determine the partition of cells. [Default: %default]'
            ),
            make_option(
                c('--return-all'),
                action = 'store_true',
                type = 'logical',
                default = FALSE,
                help = paste(
                    'When this option is set, return all saved objects from',
                    'compute_louvain_connected_components().'
                )
            )
        ),

        #' Command line arguments for learnGraph
        learnGraph = list(
            make_option(
                c('--max-components'),
                action = 'store',
                type = 'integer',
                default = 2,
                metavar = 'INT',
                help = 'The dimensionality of the reduced space. [Default %default]'
            ),
            make_option(
                c('--rge-method'),
                action = 'callback',
                type = 'character',
                default = 'SimplePPT',
                metavar = 'STR',
                callback = check_choose_from(c('SimplePPT', 'DDRTree')),
                help = paste(
                    'Determines how to transform expression values prior to reducing dimensionality.',
                    '[Default: %default]'
                )
            ),
            make_option(
                c('--no-auto-param-selection'),
                action = 'store_false',
                type = 'logical',
                dest = 'auto-param-selection',
                default = TRUE,
                help = paste(
                    'When this option is NOT set, automatically calculation of',
                    'the proper value for the parameter "ncenter" (number of',
                    'centroids) which will be passed into DDRTree call.'
                )
            ),
            make_option(
                c('--partition-group'),
                action = 'store',
                type = 'character',
                default = 'louvain_component',
                metavar = 'STR',
                help = paste(
                    'Which partition groups (column in pData) should be used',
                    'when learning separate trees for each partition. [Default: %default]'
                )
            ),
            make_option(
                c('--no-partition'),
                action = 'store_false',
                type = 'logical',
                dest = 'do-partition',
                default = TRUE,
                help = paste(
                    'When this option is NOT set, learn a tree structure for',
                    'each separate over-connected louvain component.'
                )
            ),
            make_option(
                c('--scale'),
                action = 'store_true',
                type = 'logical',
                default = FALSE,
                help = paste(
                    'When this option is set, scale each gene before running',
                    'trajectory reconstruction.'
                )
            ),
            make_option(
                c('--close-loop'),
                action = 'store_true',
                type = 'logical',
                default = FALSE,
                help = paste(
                    'When this option is set, perform an additional run of loop',
                    'closing after running DDRTree or SimplePPT to identify',
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
                c('--geodestic-distance-ratio'),
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
                    'it to represent the developmental process.'
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
                    'principal point.'
                )
            ),
            make_option(
                c('--reverse'),
                action = 'store_true',
                type = 'logical',
                default = FALSE,
                help = paste(
                    'When this option is set, reverse the direction of the',
                    'trajectory.'
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

        #' Command line arguments for principalGraphTest
        principalGraphTest = list(
            make_option(
                c('--no-relative-expr'),
                action = 'store_false',
                type = 'logical',
                dest = 'relative-expr',
                default = TRUE,
                help = paste(
                    'When this option is NOT set, convert the expression into a',
                    'relative expression.'
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
                callback = check_choose_from(c('Moran_I', 'Geary_C')),
                help = paste(
                    'A character string specifying the method for detecting',
                    'significant genes showing correlated expression along the',
                    'principal graph embedded in the low dimensional space,',
                    'choose from {Moran_I, Geary_C}. [Default: %default]'
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
            ),
            make_option(
                c('--interactive'),
                action = 'store_true',
                type = 'logical',
                default = FALSE,
                help = paste(
                    'When this option is set, allow user to choose a point or',
                    'region in the scene, then to only identify genes spatially',
                    'correlated for those selected cells.'
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
                c('--color-by'),
                action = 'store',
                type = 'character',
                default = 'Pseudotime',
                help = paste(
                    'The cell attribute (e.g. the column of pData(cds)) to map',
                    'to each cell\'s color. [Default: %default]'
                )
            ),
            make_option(
                c('--hide-backbone'),
                action = 'store_false',
                type = 'logical',
                dest = 'show-backbone',
                default = TRUE,
                help = paste(
                    'When this option is NOT set, show the diameter path of the',
                    'MST used to order the cell.'
                )
            ),
            make_option(
                c('--backbone-color'),
                action = 'store',
                type = 'character',
                default = 'black',
                help = paste(
                    'The color used to render the backbone. [Default: %default]'
                )
            ),
            make_option(
                c('--markers'),
                action = 'store',
                type = 'character',
                default = NULL,
                help = paste(
                    'A gene name or gene id to use for setting the size of each',
                    'cell in the plot. [Default: %default]'
                )
            ),
            make_option(
                c('--use-color-gradient'),
                action = 'store_true',
                type = 'logical',
                default = FALSE,
                help = paste(
                    'When this option is set, use color gradient instead of',
                    'cell size to show marker expression level.'
                )
            ),
            make_option(
                c('--markers-linear'),
                action = 'store_true',
                type = 'logical',
                default = FALSE,
                help = paste(
                    'When this option is set, scale the markers linearly,',
                    'otherwise scale them logarithimically.'
                )
            ),
            make_option(
                c('--show-cell-names'),
                action = 'store_true',
                type = 'logical',
                default = FALSE,
                help = paste(
                    'When this option is set, draw the name of each cell in',
                    'the plot.'
                )
            ),
            make_option(
                c('--show-state-number'),
                action = 'store_true',
                type = 'logical',
                default = FALSE,
                help = 'When this option is set, show state number'
            ),
            make_option(
                c('--cell-size'),
                action = 'store',
                type = 'numeric',
                default = 1.5,
                help = 'The size of the point for each cell. [Default: %default]'
            ),
            make_option(
                c('--cell-link-size'),
                action = 'store',
                type = 'numeric',
                default = 0.75,
                help = paste(
                    'The size of the line segments connecting cells (when used',
                    'with ICA) or the principal graph (when used with DDRTree.',
                    '[Default: %default]'
                )
            ),
            make_option(
                c('--cell-name-size'),
                action = 'store',
                type = 'numeric',
                default = 2,
                help = 'The size of cell name label. [Default: %default]'
            ),
            make_option(
                c('--state-number-size'),
                action = 'store',
                type = 'numeric',
                default = 2,
                help = 'The size of the state number. [Default: %default]'
            ),
            make_option(
                c('--hide-branch-points'),
                action = 'store_false',
                type = 'logical',
                dest = 'show-branch-points',
                default = TRUE,
                help = paste(
                    'When this option is NOT set, show icons for each branch',
                    'point (only available after running assign_cell_states)'
                )
            ),
            make_option(
                c('--theta'),
                action = 'store',
                type = 'numeric',
                default = 0,
                help = 'Degree to rotate the trajectory'
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
            )
        )
    )

    if (!is.null(func_names) && !is.na(func_names)) {
        func_options[func_names]
    } else {
        func_options
    }
}
