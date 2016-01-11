#!/bin/sh
TRIBE_DIR="/data/theia/reazur/editing/github/TRIBE/CODE"
DIR="/data/theia/reazur/editing"

#ensure that tp and infile has the correct value for each step 
#modify the dnaexpt and rna expt variable as well
#------------------------
#dnaexpt=$1
#rnaexpt=$2

#create dna matrix file
#dnaexpt="RR_DNA"
#tp="25"
#outfile="DNA_"$tp".matrix"
#infile="KA_SEQ_68.sam"

#echo "perl samto_matrix_wsj_20110707.pl $infile $dnaexpt $tp"
#perl samto_matrix_wsj_20110707.pl $infile $dnaexpt $tp 
#mv $infile".matrix.wig" $outfile


#create the RNA matrix files
rnaexpt="AM17v2"
timepoint=( 20 21 22 23 )

for tp in ${timepoint[@]}
do
  infile=$tp"_AMLib17.sam"
  outfile=$tp"_AMLib17.matrix"
  echo "perl samto_matrix_wsj_20110707.pl $infile $rnaexpt $tp"
  perl $TRIBE_DIR/samto_matrix_wsj_20110707.pl $infile $rnaexpt $tp 
  mv $infile".matrix.wig" $outfile  
done

#rnaexpt="adar0"
#timepoint=( 1 2)
#
#for tp in ${timepoint[@]}
#do
#  infile="ADAR0_R"$tp".sam"
#  outfile="ADAR0_R"$tp".matrix"
#  echo "perl samto_matrix_wsj_20110707.pl $infile $rnaexpt $tp"
#  perl $DIR/samto_matrix_wsj_20110707.pl $infile $rnaexpt $tp 
#  mv $infile".matrix.wig" $outfile  
#done



exit

