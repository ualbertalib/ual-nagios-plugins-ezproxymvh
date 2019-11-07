#!/usr/bin/perl -w
# Feed some random, English-like text into the search interface, see if that crashes!
use strict;
use Test::More;
use Storable;

my $DEBUG = 0; $DEBUG = $ENV{"DEBUG"} if defined $ENV{"DEBUG"};
my $testCount=1;
my $return_value=1;
my $text; 

# setup
$ENV{DEBUG} = 1;   # this enables the check_MV.pl script to use data files in the local directory
`/usr/bin/cp -f config.txt.critical config.txt` ;
#`cp -f ezproxy.hst.warning ezproxy.hst`;

# The Test
`../check_MV.pl`; 
$return_value = $? >> 8;
ok ($return_value == 2, "script should return a two, when the situation is critical: $return_value");
done_testing $testCount;

