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
    preprocess_opt="-f cds3 --method PCA --num-dim 50 --norm-method log --pseudo-count 1"
    preprocess_rds="${output_dir}/preprocess.rds"
    reduceDim_opt="--max-components 2 --reduction-method UMAP --preprocess-method PCA"
    reduceDim_rds="${output_dir}/reduceDim.rds"
    partition_opt="--knn 20 --louvain-iter 1"
    partition_rds="${output_dir}/partition.rds"
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

@test "Create .csv input" {
    if [ "$resume" = 'true' ] && [ -f "$csv_file" ]; then
        skip "$csv_file exists and resume is set to 'true'"
    fi
    
    echo "echo -e [...] > $csv_file"
    run echo "genes,MGH100-P5-A01,MGH100-P5-A03" > $csv_file && echo "A1BG,4.13,2.17" >> $csv_file && echo "A1BG-AS1,0,5.57" >> $csv_file
    
    [ "$status" -eq 0 ]
    [ -f "$csv_file" ]
}

@test "Create .tsv input" {
    if [ "$resume" = 'true' ] && [ -f "$tsv_file" ]; then
        skip "$tsv_file exists and resume is set to 'true'"
    fi
    
    echo "sed 's/,/\t/g' $csv_file > $tsv_file"
    run sed 's/,/\t/g' $csv_file > $tsv_file
    
    [ "$status" -eq 0 ]
    [ -f "$tsv_file" ]
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
    
    echo `wc -l $csv_file`
    run $monocle create $csv_rds $csv_opt
    
    [ "$status" -eq 0 ]
    [ -f "$csv_rds" ]
}

@test "Create from .tsv" {
    if [ "$resume" = 'true' ] && [ -f "$tsv_rds" ]; then
        skip "$tsv_rds exists and resume is set to 'true'"
    fi
    
    echo `wc -l $tsv_file`
    run $monocle create $tsv_rds $tsv_opt
    
    [ "$status" -eq 0 ]
    [ -f "$tsv_rds" ]
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
