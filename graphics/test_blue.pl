#!/usr/local/bin/perl

	require "bluepoint.pl";

	$orig = "abcdefghijklmnopqrstuvwxyz";
	$pass = "1234";

	if(@ARGV[0] ne "")
		{
		$orig = @ARGV[0];
		}

	if(@ARGV[1] ne "")
		{
		$pass = @ARGV[1];
		}

	print "original='$orig'  pass='$pass'\n";

	#print "ORG: "; dumpdec($orig); print "\n";

	$str = bluepoint::encrypt($orig, $pass);

	#print "enc:  $str\n";
	print "ENCRYPTED: \n";
	#dumpdec($str);
	bluepoint::dumphex($str);
	print "\nEND ENCRYPTED\n";

	$str2 = bluepoint::decrypt($str, $pass);
	print "decrypted='$str2'\n";

	#print "DEC: "; dumpdec($str2); print  "\n";

	print "HASH: \n";
	$str2 = bluepoint::hash($orig);

    $cc = sprintf("%d  0x%08x", $str2, $str2);
    print $cc . "\n";

	print "CryptHASH: \n";
	$str2 = bluepoint::crypthash($orig, $pass);
    $cc = sprintf("%d  0x%08x", $str2, $str2);
    print $cc . "\n";

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

