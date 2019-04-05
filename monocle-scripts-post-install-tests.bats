#!/usr/bin/env bats

setup() {
    monocle="$CONDA_PREFIX/lib/R/library/MonocleScripts/exec/monocle3"
    test_dir="post_install_tests"
    data_dir="${test_dir}/data"
    output_dir="${test_dir}/outputs"
    input_url='http://trapnell-lab.gs.washington.edu/public_share/valid_subset_GSE72857_cds2.RDS'
    input_rds="${data_dir}/input.rds"
    preprocess_opt="-f cds2 --method PCA --num-dim 50 --norm-method log --pseudo-expr 1"
    preprocess_rds="${output_dir}/preprocess.rds"
    reduceDim_opt="--max-components 2 --reduction-method UMAP"
    reduceDim_rds="${output_dir}/reduceDim.rds"
    partition_opt="--knn 20 --louvain-iter 1"
    partition_rds="${output_dir}/partition.rds"
    learnGraph_opt="--max-components 2 --rge-method SimplePPT --partition-group louvain_component --euclidean-distance-ratio 1 --geodestic-distance-ratio 0.333 --minimal-branch-len 10"
    learnGraph_rds="${output_dir}/learnGraph.rds"
    orderCells_opt="--cell-phenotype cell_type2 --root-type MP/EP"
    orderCells_rds="${output_dir}/orderCells.rds"
    diffExp_opt="-F tsv --knn 25 --method Moran_I --alternative greater --cores 2"
    diffExp_tbl="${output_dir}/diffExp.tsv"
    plotCells_opt="-F png --xdim 2 --ydim 1 --color-by Pseudotime --backbone-color grey --cell-size 1 --alpha 0.2"
    plotCells_plt="${output_dir}/plotCells.png"

    if [ ! -e "$output_dir" ]; then
        mkdir -p $output_dir
    fi
}

# Download data

@test "Download example data" {
    if [ -f "$input_rds" ]; then
        skip "$input_rds already exists"
    fi

    run mkdir -p $data_dir && wget $input_url -O $input_rds

    [ "$status" -eq 0 ]
    [ -f "$input_rds" ]
}

# Preprocess data

@test "Preprocess" {
    if [ "$resume" = 'true' ] && [ -f "$preprocess_rds" ]; then
        skip "$preprocess_rds exists and resume is set to 'true'"
    fi

    echo "$monocle preprocess $preprocess_opt $input_rds $preprocess_rds"
    run $monocle preprocess $preprocess_opt $input_rds $preprocess_rds

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
