#!/usr/bin/perl
#
#sum spin up/dn bndspectrum.dat to a total bndspectrum.dat


# bndspectrum.dat

use Scalar::Util qw(looks_like_number);

$num_args = $#ARGV + 1;
if ( $num_args > 1 ) {
    $fnin_up=$ARGV[0];
    $fnin_dn=$ARGV[1];
} else {
    printf(STDERR "Usage: $0 bndspectrum_up.dat bndspectrum_dn.dat\n");
    #printf(STDERR "Num arg = %d\n", $num_args);
    exit;
}

open(FILE_up, $fnin_up);
open(FILE_dn, $fnin_dn);

# Assuming the up and dn bndspectrum file have same format

open(FILE_out, ">bndspectrum.dat");
while($_=<FILE_up>){
    @tmp1=split;
    $_=<FILE_dn>;
    @tmp2=split;
    if( ! looks_like_number($tmp2[0]) ){
        printf(FILE_out "$_");
    } else {
        printf(FILE_out "%8.5f %7.3f %12.9f\n",$tmp1[0],$tmp1[1],$tmp1[2]+$tmp2[2] );
    }
}

close(FILE_up);
close(FILE_dn);
close(FILE_out);
