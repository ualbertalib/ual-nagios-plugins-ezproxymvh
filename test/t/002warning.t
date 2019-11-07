#!/usr/bin/perl -w
# Using a different config.txt, mock EZproxy configuration in WARNING condition wrt MVH
use strict;
use Test::More;
#use Storable;

my $DEBUG = 0; $DEBUG = $ENV{"DEBUG"} if defined $ENV{"DEBUG"};
my $testCount=1;
my $return_value=1;
my $text; 

# setup
$ENV{DEBUG} = 1;   # this enables the check_MV.pl script to use data files in the local directory
`/usr/bin/cp -f config.txt.warning config.txt` ;
#`cp -f ezproxy.hst.warning ezproxy.hst`;

# The Test
`../check_MV.pl`; 
$return_value = $? >> 8;
ok ($return_value == 1, "script should return a one, when a warning is appropriate: $return_value");
done_testing $testCount;

