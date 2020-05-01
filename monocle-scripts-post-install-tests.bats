#!/usr/bin/env bats

setup() {
    monocle="monocle3"
    test_dir="post_install_tests"
    data_dir="${test_dir}/data"
    output_dir="${test_dir}/outputs"
    exprs_url="http://staff.washington.edu/hpliner/data/packer_embryo_expression.rds"
    exprs_rds="${data_dir}/exprs.rds"
    exprs_mtx="${data_dir}/exprs.mtx"
    obs_url="http://staff.washington.edu/hpliner/data/packer_embryo_colData.rds"
    obs_rds="${data_dir}/obs.rds"
    var_url="http://staff.washington.edu/hpliner/data/packer_embryo_rowData.rds"
    var_rds="${data_dir}/var.rds"
    create_opt="--expression-matrix $exprs_mtx --cell-metadata $obs_rds --gene-annotation $var_rds"
    create_rds="${output_dir}/create.rds"
    tsv_file="${test_dir}/matrix.tsv"
    tsv_opt="--expression-matrix $tsv_file"
    tsv_rds="${output_dir}/tsv.rds"
    csv_file="${test_dir}/matrix.csv"
    csv_opt="--expression-matrix $csv_file"
    csv_rds="${output_dir}/csv.rds"
    x10x_mtx="${test_dir}/matrix.mtx"
    x10x_cell="${test_dir}/barcodes.tsv"
    x10x_gene="${test_dir}/genes.tsv"
    x10x_opt="--expression-matrix $x10x_mtx --cell-metadata $x10x_cell --gene-annotation $x10x_gene"
    x10x_rds="${output_dir}/10x.rds"
    preprocess_opt="-f cds3 --method PCA --num-dim 50 --norm-method log --pseudo-count 1"
    preprocess_rds="${output_dir}/preprocess.rds"
    reduceDim_opt="--max-components 2 --reduction-method UMAP --preprocess-method PCA"
    reduceDim_rds="${output_dir}/reduceDim.rds"
    partition_opt="--knn 20 --louvain-iter 1"
    partition_rds="${output_dir}/partition.rds"
    topMarkers_tbl="${output_dir}/topMarkers_top.tsv"
    topMarkers_tbl_wcells="${output_dir}/topMarkers_top_wcells.tsv"
    topMarkers_png="${output_dir}/topMarkers_top.png"
    topMarkers_full_tbl="${output_dir}/topMarkers_full.tsv"
    topMarkers_opt="-f cds3 -F tsv --plot-top-markers $topMarkers_png --save-full-markers $topMarkers_full_tbl"
    topMarkers_opt_wcells="-f cds3 -F tsv --plot-top-markers $topMarkers_png --save-full-markers $topMarkers_full_tbl --reference-cells 'TGAGAGGAGTTCGCGC-500.2.2,TGTTCCGCACGGTGTC-500.2.2,AAATGCCAGGACAGAA-b01,ACTTGTTTCTTGAGAC-b01,CATCGAAGTCAACTGT-b01'"
    learnGraph_opt="--minimal-branch-len 15"
    learnGraph_rds="${output_dir}/learnGraph.rds"
    orderCells_opt="--cell-phenotype embryo.time.bin --root-type 130-170 --reduction-method UMAP"
    orderCells_rds="${output_dir}/orderCells.rds"
    diffExp_opt="-F tsv --knn 25 --method Moran_I --alternative greater --cores 2"
    diffExp_tbl="${output_dir}/diffExp.tsv"
    plotCells_opt="-F png --xdim 2 --ydim 1 --color-cells-by pseudotime --reduction-method UMAP --cell-size 1 --alpha 0.2"
    plotCells_plt="${output_dir}/plotCells.png"

    if [ ! -e "$output_dir" ]; then
        mkdir -p $output_dir
    fi
}

# Download data

@test "Download example data" {
    if [ -f "$exprs_rds" ]; then
        skip "$exprs_rds already exists"
    fi

    run mkdir -p $data_dir && wget $exprs_url -O $exprs_rds && wget $obs_url -O $obs_rds && wget $var_url -O $var_rds

    [ "$status" -eq 0 ]
    [ -f "$exprs_rds" ]

}

@test "Create .mtx input" {
     if [ -f "$exprs_mtx" ]; then
        skip "$exprs_mtx already exists"
    fi 

    run Rscript -e "mat=readRDS(commandArgs(TRUE)[1]);Matrix::writeMM(mat,commandArgs(TRUE)[2])" ${exprs_rds} ${exprs_mtx}
    [ "$status" -eq 0 ]
    [ -f "$exprs_mtx" ]
}

# Create object

@test "Create" {
    if [ "$resume" = 'true' ] && [ -f "$create_rds" ]; then
        skip "$create_rds exists and resume is set to 'true'"
    fi
    
    echo "$monocle create $create_rds $create_opt"
    run $monocle create $create_rds $create_opt
    
    [ "$status" -eq 0 ]
    [ -f "$create_rds" ]
}

@test "Create from .csv" {
    if [ "$resume" = 'true' ] && [ -f "$csv_rds" ]; then
        skip "$csv_rds exists and resume is set to 'true'"
    fi
    
    echo "$monocle create $csv_rds $csv_opt"
    run eval "printf 'genes,MGH100-P5-A01,MGH100-P5-A03\nA1BG,4.13,2.17\nA1BG-AS1,0,5.57\n' > $csv_file" && $monocle create $csv_rds $csv_opt
    
    [ "$status" -eq 0 ]
    [ -f "$csv_rds" ]
}

@test "Create from .tsv" {
    if [ "$resume" = 'true' ] && [ -f "$tsv_rds" ]; then
        skip "$tsv_rds exists and resume is set to 'true'"
    fi
    
    echo "$monocle create $tsv_rds $tsv_opt"
    run eval "printf 'genes\tMGH100-P5-A01\tMGH100-P5-A03\nA1BG\t4.13\t2.17\nA1BG-AS1\t0\t5.57\n' > $tsv_file" && $monocle create $tsv_rds $tsv_opt
    
    [ "$status" -eq 0 ]
    [ -f "$tsv_rds" ]
}

@test "Create from 10X .mtx/.tsv" {
    if [ "$resume" = 'true' ] && [ -f "$x10x_rds" ]; then
        skip "$x10x_rds exists and resume is set to 'true'"
    fi
    
    echo "$monocle create $x10x_rds $x10x_opt"
    run eval "printf '%%%%MatrixMarket matrix coordinate integer general\n%%\n2 2 4\n1 1 1\n2 1 1\n1 2 1\n2 2 1\n' > $x10x_mtx && printf 'AAACCTGAGATCCTGT-1\nAAACCTGCACCTCGGA-1\n' > $x10x_cell && printf 'ENSG00000243485\tRP11-34P13.3\nENSG00000237613\tFAM138A\n' > $x10x_gene" && $monocle create $x10x_rds $x10x_opt
    
    [ "$status" -eq 0 ]
    [ -f "$x10x_rds" ]
}

# Preprocess data

@test "Preprocess" {
    if [ "$resume" = 'true' ] && [ -f "$preprocess_rds" ]; then
        skip "$preprocess_rds exists and resume is set to 'true'"
    fi

    echo "$monocle preprocess $preprocess_opt $create_rds $preprocess_rds"
    run $monocle preprocess $preprocess_opt $create_rds $preprocess_rds

    [ "$status" -eq 0 ]
    [ -f "$preprocess_rds" ]
}

# Reduce dimensionality

@test "ReduceDim" {
    if [ "$resume" = 'true' ] && [ -f "$reduceDim_rds" ]; then
        skip "$reduceDim_rds exists and resume is set to 'true'"
    fi

    echo "$monocle reduceDim $reduceDim_opt $preprocess_rds $reduceDim_rds"
    run $monocle reduceDim $reduceDim_opt $preprocess_rds $reduceDim_rds

    [ "$status" -eq 0 ]
    [ -f "$reduceDim_rds" ]
}

# Partition cells

@test "Partition" {
    if [ "$resume" = 'true' ] && [ -f "$partition_rds" ]; then
        skip "$partition_rds exists and resume is set to 'true'"
    fi

    echo "$monocle partition $partition_opt $reduceDim_rds $partition_rds"
    run $monocle partition $partition_opt $reduceDim_rds $partition_rds

    [ "$status" -eq 0 ]
    [ -f "$partition_rds" ]
}

# Get top markers

@test "TopMarkers" {
    if [ "$resume" = 'true' ] && [ -f "$topMarkers_tbl" ] && [ -f "$topMarkers_png" ] && [ -f "$topMarkers_full_tbl" ]; then
        skip "$topMarkers_tbl exists and resume is set to 'true'"
    fi

    echo "$monocle topMarkers $topMarkers_opt $partition_rds $topMarkers_tbl"
    run $monocle topMarkers $topMarkers_opt $partition_rds $topMarkers_tbl

    [ "$status" -eq 0 ]
    [ -f "$topMarkers_tbl" ]
    [ -f "$topMarkers_png" ]
    [ -f "$topMarkers_full_tbl" ]
}

@test "TopMarkers with list of reference cells" {
    if [ "$resume" = 'true' ] && [ -f "$topMarkers_tbl_wcells" ] && [ -f "$topMarkers_png" ] && [ -f "$topMarkers_full_tbl" ]; then
        skip "$topMarkers_tbl exists and resume is set to 'true'"
    fi

    echo "$monocle topMarkers $topMarkers_opt_wcells $partition_rds $topMarkers_tbl_wcells"
    run $monocle topMarkers $topMarkers_opt_wcells $partition_rds $topMarkers_tbl_wcells

    [ "$status" -eq 0 ]
    [ -f "$topMarkers_tbl_wcells" ]
    [ -f "$topMarkers_png" ]
    [ -f "$topMarkers_full_tbl" ]
}

# Learn graph

@test "LearnGraph" {
    if [ "$resume" = 'true' ] && [ -f "$learnGraph_rds" ]; then
        skip "$learnGraph_rds exists and resume is set to 'true'"
    fi

    echo "$monocle learnGraph $learnGraph_opt $partition_rds $learnGraph_rds"
    run $monocle learnGraph $learnGraph_opt $partition_rds $learnGraph_rds

    [ "$status" -eq 0 ]
    [ -f "$learnGraph_rds" ]
}

# Order cells

@test "OrderCells" {
    if [ "$resume" = 'true' ] && [ -f "$orderCells_rds" ]; then
        skip "$orderCells_rds exists and resume is set to 'true'"
    fi

    echo "$monocle orderCells $orderCells_opt $learnGraph_rds $orderCells_rds"
    run $monocle orderCells $orderCells_opt $learnGraph_rds $orderCells_rds

    [ "$status" -eq 0 ]
    [ -f "$orderCells_rds" ]
}

# Differential expression

@test "DiffExp" {
    if [ "$resume" = 'true' ] && [ -f "$diffExp_tbl" ]; then
        skip "$diffExp_tbl exists and resume is set to 'true'"
    fi

    echo "$monocle diffExp $diffExp_opt $orderCells_rds $diffExp_tbl"
    run $monocle diffExp $diffExp_opt $orderCells_rds $diffExp_tbl

    [ "$status" -eq 0 ]
    [ -f "$diffExp_tbl" ]
}

# Plot trajectory

@test "PlotCells" {
    if [ "$resume" = 'true' ] && [ -f "$plotCells_plt" ]; then
        skip "$plotCells_plt exists and resume is set to 'true'"
    fi

    echo "$monocle plotCells $plotCells_opt $orderCells_rds $plotCells_plt"
    run $monocle plotCells $plotCells_opt $orderCells_rds $plotCells_plt

    [ "$status" -eq 0 ]
    [ -f "$plotCells_plt" ]
}

# Local Variables:
# mode: sh
# End:
