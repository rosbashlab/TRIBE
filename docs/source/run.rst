Run
===

TRIBE identifies RNA editing sites (A to G change) by comparing RNA sequence from transcriptome with genomic DNA sequence (gDNA) from the same strain. There are major steps in the pipeline:
- 1. Trim low quality bases from reads in gDNA and RNA libraries, and align to reference genome

- 2. Load the alignments into mysql tables for ease of comparison at single nucleotide resolution   

- 3. Find RNA editing sites by comparing the gDNA and RNA sequence in mysql tables


Trim and Align libraries - Step 1
---------------------------------
Trim low quality bases from reads in genomic DNA and RNA libraries (fastq files), and then align to reference transcriptome or reference genome.

A. RNA Libraries
::

    nohup /location_from_root/TRIBE/CODE/trim_and_align.sh seq.fastq &


B. gDNA Libraries (this has to be done only once per strain)
::

    nohup /location_from_root/TRIBE/CODE/trim_and_align_gDNA.sh seq.fastq &


For both cases, parameter for trimmomatics needs to adjusted based on the length of the library. Default parameters are for 50 base reads, trimming 6 bases from either end of reads. If you have a library with high quality reads, then minimal trimming might be required


Load Alignments to MySQL - Step2
--------------------------------
Converts the sam alignment file to a matrix format, where base composition from aligned reads at each position is recorded. Then, this is uploaded to a mysql table based on the arguments provided.
Usage
::
    
    nohup /location_from_root/TRIBE/CODE/load_table.sh samfile mysql_tablename expt tp &
    #1. samfile name
    #2. mysql tablename
    #3. expt name (unique identifier for the experiment, include alphabets and digits)
    #4. replicate or timepoint: This is has to be an integer

Example for RNA library
::
    
    nohup /location_from_root/TRIBE/CODE/load_table.sh 1_AM09.sam testRNA am09 1 &

Example for gDNA library
::

    nohup /data/theia/reazur/editing/github/TRIBE/CODE/load_table.sh gDNA.sam s2_gDNA s2_gDNA 25 &

To be clear, the expt name and mysql tablename does not have to be the same. For replicate or time point of gDNA I prefer using 25, to keep it separately from RNA entries. 

**It important to keep track of the arguments used in this step, because you will need it for the next step**


Find RNA edit sites - Step 3
----------------------------
Finally, we find RNA editing sites by comparing the gDNA and RNA sequence in mysql tables. For each position in the genome, the base composition is looked up using the tablename, expt name and replicate/timepoint integer. 

Copy rnaedit_gDNA_RNA.sh to your working directory, and make the necessary changes
::

    cd /directory_of_choice/
    cp /location_from_root/TRIBE/CODE/rnaedit_gDNA_RNA.sh .
    #open and edit the following variables in the script
    annotationfile="/location_from_root/TRIBE/annotation/exon_dm3_refflat_20141030.txt"
    RNAtablename="testRNA"
    RNAexp="am09"
    gDNAtablename="s2_gDNA"
    gDNAexp="s2_gDNA"
    gDNAtp="25"
    timepoint=( 1 )
    #the timepoint array allows you run multiple libraries one after another, if desired

Now, run the updated shell script from current directory
::

    ./rnaedit_gDNA_RNA.sh

The minimum coverage of reads in gDNA table is hardcoded to be 9 bases in the perl script (find_rnaeditsites.pl). 

Congratulations!!! You have managed to run the computational pipeline of TIDAL, hope you get exciting results!


Outputs
-------
There are two output files *A2G_rnaedit.txt* and  *A2G_rnaedit.txt.threshold* (the last python script imposes a 20 read threshold for RNA).

The output files have self explanatory headers. 