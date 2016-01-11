use DBI; 
use strict; 
use warnings;
use Getopt::Std;

#Author Reazur Rahman 2014

my $USAGE = "load_gDNAdata.pl -t tablename -d datafile_location\n";
my %option;
getopts( 't:d:h', \%option );
my ($tablename, $matrixfile);
if ( $option{t} &&  $option{d} ) {
    $tablename = $option{t};
    $matrixfile = $option{d};
} else {
    die "proper parameters not passed\n$USAGE";
}

#my $tablename = "mm_gDNA";
#my $matrixfile = "/data/sequence2/reazur/mammaledit/chr1/chr1_gDNA.txt";
#my $matrixfile = "smatrix.txt";
my $host = "localhost";
my $database = "dmseq";
my $user = "root";
my $password = "password_database_for_root";

my $dsn = "DBI:mysql:$database:$host"; 

#my $dsn = 'DBI:mysql:test:thr.genomics.purdue.edu:3306'; 
#my $user = "gribskov";
#my $password = "mysql"; 
my $dbh = DBI->connect( $dsn, $user, $password, {RaiseError=>1, PrintError=>0} ) or die $DBI::errstr; 

my ($sth);
#create the table
eval {
    $sth = $dbh->prepare("CREATE TABLE $tablename (experiment VARCHAR(20), time INT NOT NULL, chr varchar(10), coord INT NOT NULL, Acount INT NOT NULL, Tcount INT NOT NULL, Ccount INT NOT NULL, Gcount INT NOT NULL, Ncount INT NOT NULL, totalcount INT NOT NULL, primary key(experiment,time,chr,coord))");
    $sth->execute; 
};

if ($@) {
    print "Error in database creation: $@";
}

#load the table
eval {
    $sth = $dbh->prepare("LOAD DATA LOCAL INFILE '$matrixfile' INTO TABLE $tablename (experiment,time,chr,coord,Acount,Tcount,Ccount,Gcount,Ncount,totalcount)"); 
    $sth->execute;
};

if ($@) {
    print "Error in loading data: $@";
}

#show table data
#$sth = $dbh->prepare( "show tables" ); 
#$sth->execute; 
#while ( my @result = $sth->fetchrow_array ) { 
#	print "@result\n"; 
#} 



$sth->finish; 
$dbh->disconnect;
