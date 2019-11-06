#!/usr/bin/perl -w
# Feed some random, English-like text into the search interface, see if that crashes!
use strict;
use Test::More;
use Storable;

my $DEBUG = 0; $DEBUG = $ENV{"DEBUG"} if defined $ENV{"DEBUG"};
my $testCount=1;

# setup
$ENV{DEBUG} = 1;   # this enables the check_MV.pl script to use data files in the local directory
`cp -f config.txt.basic config.txt`;
`cp -f exproxy.hst.basic ezproxy.hst`;

# The Test

ok (`../check_MV.pl` && $? >> 8 == 0, "script should return a zero, where there are no problems");
done_testing $testCount;

exit;

