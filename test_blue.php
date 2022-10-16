<?PHP

	error_reporting(E_ERROR | E_WARNING | E_PARSE);

	include "bluepoint.php";

	$argv =  $_SERVER[argv];

	$orig = "abcdefghijklmnopqrstuvwxyz";
	$pass = "1234";

	if($argv[1] != "")
		{
		$orig = $argv[1];
		}
	if($argv[2] != "")
		{
		$pass = $argv[2];
		}

	print "org='$orig'  pas='$pass'\n";
	$str1 = bluepoint_encrypt($orig, $pass);

	print "ENCRYPTED: \n";
	dumphex($str1);
	print "\nEND ENCRYPTED\n";

	$str2 = bluepoint_decrypt($str1, $pass);
	print "decrypted='$str2'\n";

	print "HASH: \n";
	$str2 = bluepoint_hash($orig, $pass);
    $cc = sprintf("%08x", $str2);
    print $str2 . " - 0x"  . $cc . "\n";

	print "CRYPTHASH: \n";
	$str2 = bluepoint_crypthash($orig, $pass);
    $cc = sprintf("%08x", $str2);
    print $str2 . " - 0x"  . $cc;

// -------------------------------------------------------------------------

function dumphex($s)

{
    $len   = strlen($s);
    $res = "";

    for ($loop = 0; $loop < $len; $loop++)
        {
        $aa = substr($s, $loop, 1);
        $cc = sprintf("-%02x", ord($aa));
        $res .=  $cc;
        }
    print $res;
    return($res);
}

?>

