Installation
============

Installation of TRIBE's computational pipeline involves installing a set of softwares, downloading a set of annotation files, and updating the shells scripts to provide their locations.


Software Dependencies
---------------------
- Trimmomatics (v. 0.30)
- Bowtie (v. 1.0.0) and Bowtie2 (v. 2.1.0)
- Tophat2 (v2.0.10)
- bedtools suite (v. 2.16.2)
- Perl (up to 5.12.5). 
- Perl modules DBI.pm (1.631) and `MySql.pm <http://search.cpan.org/~capttofu/DBD-mysql-3.0008/lib/Mysql.pm>`_. Mysql.pm is incompatible with versions beyond of perl 5.12.5.
- MySQL database
- Python (2.7.2, other versions should work) 

In future upgrades to the pipeline we will remove this version specific dependencies of Perl. Currently, he version specific dependency of Perl and perl modules are critical. All software version listed above show the version of tool specific dependencies.Operating system is RHEL 5.11.

Source Code
-----------
Download the source code from github.
::

    cd directory_of_your_choice
    git clone https://github.com/rosbashlab/TRIBE

Resolving Perl and mysql Dependencies
-------------------------------------
Here is some code that can be use to set up the Perl dependencies with `perlbrew <http://perlbrew.pl/>`_. If a system admin can help you, then you can try other ways of installation.
::

    #Install perlbrew
    wget -O - http://install.perlbrew.pl | bash
    #add the perlbrew bashrc to your current your bash
    source ~/perl5/perlbrew/etc/bashrc
    # install the specific version of perl, this will take some time    
    perlbrew  install perl-5.12.5
    perlbrew use perl-5.12.5
    #Check that you are using the correct version of perl (this shows a star next to the active version of perl)
    perlbrew list
    #install cpan for easy installation of modules
    perlbrew install-cpanm
    #install DBI.pm (1.631)
    cpanm TIMB/DBI-1.631.tar.gz

update bash shell so that you don't have to repeat some of the initialization step, open .bash_profile
::

    nano .bash_profile
    #add these two lines at the end of the file,  
    source ~/perl5/perlbrew/etc/bashrc
    perlbrew use 5.12.5
    #this makes perl 5.12.5 your default perl

Before installing the perl module Mysql.pm, we need to create user in mysql, here is the mysql code once you log on
::

    #create user 'username' without password. username should match with the person setting it up.
    CREATE USER 'username@'localhost' IDENTIFIED BY '';
    GRANT ALL PRIVILEGES ON * . * TO 'username'@'localhost';
    FLUSH PRIVILEGES;
    
Now, back to the shell to install Mysql.pm
::

    #install Mysql
    cpanm Mysq


Check you env variable:
::

    which env
    /bin/env
    #on RHEL 7, i believe it is /usr/bin/env

Now, update the first line of the four perl scripts in source code if your operating system is RHEL 7, so that the correct version of perl is used for analysis
::

    #update to rhel 7 if needed 
    #!/usr/bin/env perl
    
Also, provide the password for mysql in *load_matrix_data.pl* and *find_rnaeditsites.pl*. If the mysql database is hosted on a different machine then update the host variable to reflect the ip address. This is needed to ensure that the two perl scripts are able to connect to mysql database.

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



