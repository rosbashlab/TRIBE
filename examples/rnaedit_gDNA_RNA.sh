#!/bin/sh
#location of TRIBE CODE
TRIBE_DIR="/data/theia/reazur/editing/github/TRIBE/CODE"

# The combination of tablename, expt name and tp value is used to extract the base composition at a given location of the genome for each experimental condition. the find_rnaeditsites.pl script uses these variables to extract and compare the base composition between the rna library and gDNA library to call the edit sites
#---------------------------
# edit the following varibales as need
annotationfile="/data/theia/reazur/editing/github/TRIBE/annotation/exon_dm3_refflat_20141030.txt"
rnatablename="rr_test_RNA"
rnaexp="yw_wt"
gDNAtablename="rr_test_gDNA"
gexp="yw_wt"
gDNAtp="2"


#edit the timepoint array as needed
timepoint=( 1 )
# timepoint=( 1 2 )
# one or more samples can be run by altering this array. 
#---------------

for tp in ${timepoint[@]}
do
  file=$rnaexp"_"$tp"_A2G_rnaedit.txt"
  perl $TRIBE_DIR/find_rnaeditsites.pl -a $annotationfile -t $rnatablename -e $rnaexp -c $tp -o $file -g $gDNAtablename -j $gexp -k $gDNAtp  

#  python $TRIBE_DIR/Threshold_RNA04_out_AM.py $file
#  fileout=$file".threshold"

done
