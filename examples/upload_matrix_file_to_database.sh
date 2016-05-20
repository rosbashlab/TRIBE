#!/bin/sh
#provide path to TRIBE CODE directory
TRIBE_DIR="/data/theia/reazur/editing/github/TRIBE/CODE"
tablename=$1
matrix_file=$2

perl $TRIBE_DIR/load_matrix_data.pl -t $tablename -d $matrix_file