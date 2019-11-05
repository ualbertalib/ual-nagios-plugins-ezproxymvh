#!/usr/bin/perl -w 
# Author:		Neil MacGregor
# Date:			November, 2011
# Purpose: 		Nagios module for monitoring when the total number of proxied IP addresses threatens to hit the configured limit for MaxVirtualHosts
# 			(In response to OTRS TicketID=38707, and others lost in antiquity)
# Context:		This is run by cron, hourly, see /etc/cron.d/EZproxyAutomation
#
# Reference: 		https://helpdesk.library.ualberta.ca/otrs/index.pl?Action=AgentTicketZoom;TicketID=54400  # Finally get this code into revision control & an RPM
# Reference: 		file://///libroot/ITS_Share/Unix/Change/2011/Q4/CR00000204.html
# Reference: 		file://///libroot/ITS_Share/Unix/Ezproxy/MVexceeded.html
# Reference: 		https://ualgitlab.library.ualberta.ca/nmacgreg/ual-nagios-plugins-ezproxymvh/tree/master
#
# This problem is intermittent in the extreme, but when it bites, it bites HARD, basically performing a denial of service to users who haven't used it recently.
# 
# So, this is a new Nagios plugin, to detect & report when EZproxy flirts with the MV limit. 
# This takes a new approach, monitoring the number of entries in ezproxy.hst
#
# Background: as users visit EZproxy, it accumulates a list of hostnames it has proxied, in ezproxy.hst.  If you do nothing, 
# and your configuration is large, it *will* hit the MV limit sooner or later.  So, we must daily run Peter's script, hst_expire.pl, 
# to remove hostnames from ezproxy.hst that haven't been accessed in the last 7 days. And, that must be done while EZproxy is down.
use strict;

my $path="/usr/local/ezproxy";

sub unknown {
my $string = shift;
print "UNKNOWN $string\n"; 
exit 3;
}

sub critical {
my $string=shift;
my $value=shift;
my $warning=shift;
my $threshold=shift;
print "CRITICAL $string|proxied=$value;$warning;$threshold\n";
exit 2;
}

sub warning {
my $string=shift;
my $value=shift;
my $warning=shift;
my $threshold=shift;
print "WARNING $string|proxied=$value;$warning;$threshold\n";
exit 1;
}

sub ok {
my $value=shift;
my $warning=shift;
my $threshold=shift;
print "OK|proxied=$value;$warning;$threshold\n";
exit 0;
}

my $warning; my $threshold=-1;

# How many entries are there in ezproxy.hst? 
open CMD, "grep ^H $path/ezproxy.hst | wc -l |"  or unknown("Unable to count how many entries in ezproxy.hst: $!");
my $count = <CMD>;  chomp $count;
close CMD;
unknown("Cannot count the number of entries in ezproxy.hst") unless ($count =~ /\d+/); 


# What is MV (MaxVirtualHosts) set to, in config.txt?
open CMD, "grep ^MV $path/config.txt | awk '{ print \$2; }' |"  or unknown("Unable to retrieve MV from config.txt: $!");
my $mv = <CMD>;   chomp $mv;
close CMD;
unknown("Read a bad value for MV from config.txt") unless ($mv =~ /\d+/ && $mv > 1000);  # 

# Calibration
$warning = $mv / 2;
$threshold = $mv / 1.5;

# Comparison logic
critical("$count hostnames proxied, out of $mv",$count,$warning,$threshold) if  ($count > $threshold);   # does not return
warning("$count hostnames proxied, above $warning",$count,$warning,$threshold) if ($count > $threshold);  # does not return
ok($count,$warning,$threshold ) ; # does not return


