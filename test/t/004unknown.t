#!/usr/bin/perl -w
# When the code encounters error conditions, it should fail gracefully, returning UNKNOWN & appropriate text
use strict;
use Test::More;

my $DEBUG = 0; $DEBUG = $ENV{"DEBUG"} if defined $ENV{"DEBUG"};
my $testCount=1;
my $return_value=1;

# setup
$ENV{DEBUG} = 1;   # this enables the check_MV.pl script to use data files in the local directory
`/bin/rm config.txt` if (-e "config.txt");

# The Test
`../check_MV.pl`; 
$return_value = $? >> 8;
ok ($return_value == 3, "script should return a three, when it's unable to monitor the number of VirtualHosts: $return_value");
done_testing $testCount;

