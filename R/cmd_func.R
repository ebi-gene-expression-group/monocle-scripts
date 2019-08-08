#' Read data
#' 
#' @importFrom monocle importCDS updateCDS
monocle_read_obj <- function(input_object, input_object_format = 'cds3') {
    rds <- readRDS(input_object)
    if (input_object_format %in% c('sce', 'seurat')) {
        cds <- importCDS(rds)
    } else if (input_object_format == 'cds2') {
        cds <- updateCDS(rds)
    } else {
        cds <- rds
    }

    cds
}

#' Write data
#' 
#' @importFrom monocle exportCDS
monocle_write_obj <- function(
    cds, output_object, output_object_format = 'cds3', introspective = FALSE
) {
    if (introspective) print(cds)
    
    if (output_object_format == 'sce') {
        rds <- exportCDS(cds, export_to = 'Scater', export_all = TRUE)
    } else if (output_object_format == 'seurat') {
        rds <- exportCDS(cds, export_to = 'Seurat', export_all = TRUE)
    } else {
        rds <- cds
    }
    
    saveRDS(rds, file = output_object)
}

#' Write table
#' 
monocle_write_table <- function(
    tbl, output_table, output_table_format = 'tsv', introspective = FALSE
) {
    sep <- ifelse(output_table_format == 'tsv', '\t', ',')

    if (introspective) print(str(tbl))

    write.table(tbl, output_table, sep = sep, quote = F, row.names = FALSE)
}

#' Write plot
#' 
monocle_write_plot <- function(p, output_plot, output_plot_format = 'png') {
    do.call(output_plot_format, list(file = output_plot))
    print(p)
    dev.off()
}

#' Get root principal nodes
#'
#' Turning the monocle3 tutorial (08.08.19) function into something more general,
#' matching what was originally here
get_root_principal_nodes <- function(cds, cell_phenotype, root_type, reduction_method) {
    cell_ids <- which(pData(cds)[, cell_phenotype] == root_type)

    # `pr_graph_cell_proj_closest_vertex` is a matrix with a single column that
    # stores for each cell, the ID of the principal graph node it's closest to
    closest_vertex <-
        cds@principal_graph_aux[[reduction_method]]$pr_graph_cell_proj_closest_vertex
    closest_vertex <- as.matrix(closest_vertex[colnames(cds), ])
    root_pr_nodes <- igraph::V(principal_graph(cds)[[reduction_method]])$name[as.numeric(names
      (which.max(table(closest_vertex[cell_ids,]))))]
    root_pr_nodes
}
