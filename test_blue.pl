#!/usr/local/bin/perl

require "bluepoint.pl";

$orig = "abcdefghijklmnpqrstuvxyz";
$pass = "1234";

if(@ARGV[0] ne "")
	{
	$orig = @ARGV[0];
	}

if(@ARGV[1] ne "")
	{
	$pass = @ARGV[1];
	}

print "org=$orig  pas=$pass\n";

#print "ORG: "; dumpdec($orig); print "\n";

$str = bluepoint::encrypt($orig, $pass);

#print "enc:  $str\n";
print "ENC: "; dumpdec($str); print "\n";

$str2 = bluepoint::decrypt($str, $pass);
print "dec:  $str2\n";
#print "DEC: "; dumpdec($str2); print  "\n";

# -------------------------------------------------------------------------

sub dumpdec()

{
    $len  = length($_[0]);

    for ($loop = 0; $loop < $len; $loop++)
        {
        $aa = ord(substr($_[0], $loop, 1));
		print "-" . $aa;
		}
    #print "\n";
}

1;

