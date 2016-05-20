Example Run
===========

Some sample data is provided to test part of TRIBE. It can used to load data into mysql table and identify RNA editing sites. This assumes that load_matrix_data.pl and find_rnaeditsites.pl has been setup properly. 
::

    #location of the examples files
    cd /location_from_root/TRIBE/examples/
    #unzip the compressed files
    gunzip *.gz

Open the files *upload_matrix_file_to_database.sh* and *rnaedit_gDNA_RNA.sh* to update the TRIBE_DIR variable
::

    #location of TRIBE code
    TRIBE_DIR="/location_from_root/TRIBE/CODE"

Now, run the shell scripts
::
    #upload data to mysql tables, one for RNA and one gDNA
    #the first argument is the mysql tablename
    ./upload_matrix_file_to_database.sh rr_test_RNA chr2L_RNA.matrix
    ./upload_matrix_file_to_database.sh rr_test_gDNA chr2L_gDNA.matrix
    #check to see if all the variables are correct. the rnaexp and gexp variable name does not have to the same
    ./rnaedit_gDNA_RNA.sh

This should produce an output file called *yw_wt_1_A2G_rnaedit.txt*, where 38 RNA editing sites are identified (the file has 39 lines). You can also log into mysql to see how the files, chr2L_gDNA.matrix & chr2L_gDNA.matrix, have populated the mysql tables.