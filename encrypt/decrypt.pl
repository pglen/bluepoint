#!/usr/bin/perl
#--------------------------------------------------------------------------

require "xcrypt.pl";
require "mime.pl";

if($ARGV[0] eq "" || ($ARGV[0] ne "d" && $ARGV[0] ne "e") )
	{
	print "Usage: decrypt.pl [e|d] pass file_in file_out\n"; exit;
	}
if(!open(FP, $ARGV[2]))
	{
	die "Cannot open infile: $!\n";
	}

if(!open(FP2, ">$ARGV[3]"))
	{
	die "Cannot open outfile: $!\n";
	}

binmode FP; binmode FP2;

while(1)
	{
	$ret = read(FP, $buff, 1000);

	if($ARGV[0] eq "d")
		{
		$str2 = xcrypt::bluepoint_decrypt($buff, @ARGV[2]);
	    }
	if($ARGV[0] eq "e")
		{
		$str2 = xcrypt::bluepoint_encrypt($buff, @ARGV[2]);
		}
    print FP2 $str2;

    $len += length($str2);

	# End of file
	if($ret < 1000) { last; }
	}

print "Encrypted: $len bytes\n";



