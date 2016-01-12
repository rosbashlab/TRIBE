
#!/bin/sh

#----- Update the following varibles
gtf_file="/data/theia/reazur/editing/github/TRIBE/annotation/genes.gtf"
#dm3 both bowtie and bowtie2 indices
bowtie_indexes="/data/theia/analysis/dm3/Sequence/bowtie_indexes/genome"
TRIMMOMATIC_DIR="/home/reazur/SOFTWARE"
TRIBE_DIR="/data/theia/reazur/editing/github/TRIBE/CODE"

#---------------------

#filelist=`ls *.fastq`#
#for file in ${filelist[@]}
#do

file=$1
prefix=${file%.fastq*}
trim_input=$file
trim_outfile=$prefix.trim.fastq 
avgquality="30"

#trim the library as needed, here we are trimming the first 6 and last six base of reads that that 50 base long. The parameter for Trimmomatics needs to be adjusted based on the quality of the reads and length of the library
java -jar $TRIMMOMATIC_DIR/Trimmomatic-0.30/trimmomatic-0.30.jar SE -phred33 $trim_input $trim_outfile CROP:45 HEADCROP:6 LEADING:25 TRAILING:25 AVGQUAL:$avgquality MINLEN:19


input=$trim_outfile
outputdir=$prefix".tophat.out"

#tophat2 for dm3 (assumes that bowtie and bowtie2 are setup correctly)
tophat2 -m 1 -N 3 --read-edit-dist 3 -p 5 -g 2 -I 50000 --microexon-search --no-coverage-search -G $gtf_file -o $outputdir $bowtie_indexes $input
#tophat2 -m 1 -p 5 -g 2 -I 50000 --microexon-search --no-coverage-search -G $gtf_file -o $outputdir $bowtie_indexes $input

samtools view -h $outputdir/accepted_hits.bam > $prefix"_g2.sam"

perl $TRIBE_DIR/create_unique_mapped_sam.pl $prefix"_g2.sam" > $prefix".sam"
rm $prefix"_g2.sam"

samtools view -bSh  $prefix".sam" >  $prefix".bam"

#------------
echo "Done with tophat (uniquely mapped)"
echo "created sam file: $prefix.sam"
#-------------
#done

