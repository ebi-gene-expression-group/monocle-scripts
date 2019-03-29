#!/usr/bin/env bats

setup() {
    test_dir=post_install_tests
    data_dir="${test_dir}/data"
    output_dir="${test_dir}/outputs"
    input_url='http://trapnell-lab.gs.washington.edu/public_share/valid_subset_GSE72857_cds2.RDS'
    input_rds="${data_dir}/input.rds"
}

# Download data

@test "Download example data" {
    if [ "$use_existing_outputs" = 'true' ] && [ -f "$input_rds" ]; then
        skip "$input_rds exists and use_existing_outputs is set to 'true'"
    fi

    run mkdir -p $data_dir && wget $input_url -O $input_rds

    [ "$status" -eq 0 ]
    [ -f "$input_rds" ]
}


# Local Variables:
# mode: sh
# End:
