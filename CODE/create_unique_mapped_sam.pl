#!/bin/env perl
use strict;
use warnings;

#Created by Reazur Rahman, 3/1/2016

my $samfile=$ARGV[0];
    
open(my $SAM, "<", $samfile) 
    or die "unable to open ct file $samfile";

my $hash={};


while ( my $line = <$SAM> ) {    
    if ( $line =~ /^@/) {
	next;	
    }    
    my @arr = split("\t", $line);
    my $seq_header = $arr[0]; 
    my $match = $arr[2];
    if ($match eq '*') {
	# unmatched
	# print $UAL ">$seq_header\n$fa_hash->{$seq_header}";
    } else {
   	$hash->{$seq_header}++;
    }
}

close $SAM;



#print the uniquely mapped sam file
open(my $NEW_SAM, "<", $samfile) 
    or die "unable to open ct file $samfile";

while ( my $line = <$NEW_SAM> ) {    
    if ( $line =~ /^@/) {
	print "$line";
	next;
    }    
    my @arr = split("\t", $line);
    my $seq_header = $arr[0]; 
    my $match = $arr[2];
    if ($match eq '*') {
	# unmatched
	# print $UAL ">$seq_header\n$fa_hash->{$seq_header}";	
    } else {
	if ( $hash->{$seq_header}==1 ) {
	    print "$line";	    
	} 
    }
}

close $NEW_SAM;


exit;
