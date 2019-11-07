#!/usr/bin/perl -w
# Run the plugin, with DEBUG enabled, against some sample config + data files
use strict;
use Test::More;

my $DEBUG = 0; $DEBUG = $ENV{"DEBUG"} if defined $ENV{"DEBUG"};
my $testCount=1;
my $return_value=1;

# setup
$ENV{DEBUG} = 1;   # this enables the check_MV.pl script to use data files in the local directory
`/usr/bin/cp -f config.txt.critical config.txt` ;

# The Test
`../check_MV.pl`; 
$return_value = $? >> 8;
ok ($return_value == 2, "script should return a two, when the situation is critical: $return_value");
done_testing $testCount;

