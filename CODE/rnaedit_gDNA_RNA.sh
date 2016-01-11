#!/bin/sh
#DIR="/data/theia/reazur/editing"
TRIBE_DIR="/data/theia/reazur/editing/github/TRIBE/CODE"

# The combination of tablename, expt name and tp value is used to extract the base composition at a given location of the genome for each experimental condition. the find_rnaeditsites.pl script uses these variables to extract and compare the base composition between the rna library and gDNA library to call the edit sites
#---------------------------
# edit the following varibales as need
annotationfile="/data/theia/reazur/editing/github/TRIBE/annotation/exon_dm3_refflat_20141030.txt"
RNAtablename="testRNA"
RNAexp="am09"
gDNAtablename="s2_gDNA"
gDNAexp="s2_gDNA"
gDNAtp="25"


#edit the timepoint array as needed
timepoint=( 1 )
# timepoint=( 1 2 )
# one or more samples can be run by altering this array. 
#---------------

for tp in ${timepoint[@]}
do
  file=$RNAexp"_"$tp"_A2G_rnaedit.txt"
  perl $TRIBE_DIR/find_rnaeditsites.pl -a $annotationfile -t $RNAtablename -e $RNAexp -c $tp -o $file -g $gDNAtablename -j $gDNAexp -k $gDNAtp  
# filter editsites based on cut off 10 reads, the python script should to edited to change the threshold,
# change the value in the python script TotalCountThreshold = 10
#
  python $TRIBE_DIR/Threshold_editsites_20reads.py $file
#  fileout=$file".threshold"

done
