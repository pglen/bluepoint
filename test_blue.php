<?PHP

	include "bluepoint.php";

	$argv =  $_SERVER[argv];

	$orig = "abcdefghijklmnpqrstuvxyz";
	$pass = "1234";

	if($argv[1] != "")
		{
		$orig = $argv[1];
		}
	if($argv[2] != "")
		{
		$pass = $argv[2];
		}

	print "org=$orig  pas=$pass\n";
	#print "ORG: "; dumpdec($orig); print "\n";
	$str1 = bluepoint_encrypt($orig, $pass);
	print "ENC: " .  dumpdec($str1) .  "\n";
	$str2 = bluepoint_decrypt($str1, $pass);
	print "dec:  $str2\n";
	#print "DEC: "; dumpdec($str2); print  "\n";

// -------------------------------------------------------------------------

function dumpdec($s)

{
    $len   = strlen($s);
    $res = "";

    for ($loop = 0; $loop < $len; $loop++)
        {
        $aa = substr($s, $loop, 1);
        $res .=  "-" . ord($aa);
        }
    //print $res;
    return($res);
}




?>

