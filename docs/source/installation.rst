Installation
============

Installation of TRIBE's computational pipeline involves installing a set of softwares, downloading a set of annotation files, and updating the shells scripts to provide their locations.


Software Dependencies (tested version)
--------------------------------------
- Trimmomatics (v. 0.30)
- Bowtie (v. 1.0.0) and Bowtie2 (v. 2.1.0)
- Tophat2 (v2.0.10)
- bedtools suite (v. 2.16.2)
- Perl (5.8.8, 5.12.5, 5.22.1) 
- Perl modules DBI.pm (1.631, 1.636) 
- MySQL database
- Python (2.7.2, other versions should work) 

TRIBE should work with other version of the software/packages mentioned above. Operating systems: RHEL 5.11 and RHEL 7.2.

Source Code
-----------
Download the source code from github.
::

    cd directory_of_your_choice
    git clone https://github.com/rosbashlab/TRIBE

Resolving Perl and mysql Dependencies
-------------------------------------
Here is some code that can be use to set up the Perl dependencies.If a system admin can help you, then you can try other ways of installation.
::

    #install DBI.pm
    cpanm DBI


Set up the mysql username, here is the mysql code once you log on
::

    #create user 'username' without password. username should match with the person setting it up.
    CREATE USER 'username@'localhost' IDENTIFIED BY '';
    GRANT ALL PRIVILEGES ON * . * TO 'username'@'localhost';
    FLUSH PRIVILEGES;
    

Check your env variable:
::

    which env
    /bin/env
    #on RHEL 7, i believe it is /usr/bin/env

Now, update the first line of the four perl scripts in source code if your operating system is RHEL 7, so that the correct version of perl is used for analysis
::

    #update to rhel 7 if needed 
    #!/usr/bin/env perl
    
**Also, provide the password for mysql (if any) in *load_matrix_data.pl* and *find_rnaeditsites.pl*. If the mysql database is hosted on a different machine then update the host variable (localhost) to reflect the ip address. This is needed to ensure that the two perl scripts are able to connect to mysql database.**

Finally, *load_matrix_data.pl* and *find_rnaeditsites.pl* assumes that a mysql database called "dmseq" has already been created
::

    #after login to mysql, create mysql database
    CREATE DATABASE dmseq;

Annotation Files
----------------
The `annotation files <https://github.com/laulabbrandeis/TIDAL/blob/master/annotation.tar.gz>`_ are automatically downloaded when the source code is cloned. Uncompress the annotation files, which creates a directory with all the annotation files.
::

    cd /location_from_root/TRIBE
    #uncompress the genes.gtf
    gunzip genes.gtf.gz

TRIBE need these two annotation files at different step of the pipeline. These files can updated by the user based on their organism and genome build of interest:

- exon_dm3_refflat_20141030.txt: RefSeq annotation from UCSC genome browser (table browser, track: Refseq Genes, table: refFlat, output format: all fields from table).

- genes.gtf: This is refseq annotation in GTF format for dm3 (`link <https://support.illumina.com/sequencing/sequencing_software/igenome.html>`_).  

Finally, create bowtie and bowtie2 indices for your organism's genome. You need to provide the location of these indices during alignment with tophat2
::

    cd /location_of_genome/ 
    #set up the required bowtie indices, this is a sample code
    bowtie-build genome.fa genome
    bowtie2-build genome.fa genome

Update Shell Scripts
--------------------
Update the following shell scripts with the location of the TRIBE code, annotation files and Bowtie indices.

**trim_and_align.sh**
::

    #location of TRIBE from root
    TRIBE_DIR="/location_from_root/TRIBE/CODE"
    gtf_file="/location_from_root/TRIBE/annotation/genes.gtf"
    #location of bowtie and bowtie2 indices
    bowtie_indexes="/location_from_root/genome"
    TRIMMOMATIC_DIR="/location_from_root"

If you want to use a different trimmer or aligner, feel free to change the code

**trim_and_align_gDNA.sh**
::

    #location of TRIBE from root
    TRIBE_DIR="/location_from_root/TRIBE/CODE"
    #location of bowtie and bowtie2 indices
    bowtie_indexes="/location_from_root/genome"
    TRIMMOMATIC_DIR="/location_from_root"

**load_table.sh**
::

    #location of TRIBE code
    TRIBE_DIR="/location_from_root/TRIBE/CODE"


**Congratulations!!! Now, you are ready to run TRIBE.**



