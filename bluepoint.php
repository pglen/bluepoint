<?PHP

// ----------------------------------------------------------------
// Encryption routines for data communication.
//
//   How it works:
//
//     Strings are walked chr by char with the loop:
//         {
//         aa = ord(functionstr(_[0], loop, 1));
//
//         do something with aa
//
//         functionstr(_[0], loop, 1) = pack("c", aa);
//         }
//
//   Flow:
//         generate $vector
//         generate pass
//         walk $forward with password cycling loop
//         walk $backwards with feedback encryption
//         walk $forward with feedback encryption
//
//  The process guarantees that a single bit change in the original text
//  will change every byte in the block.
//
//  The process also guarantees that a single bit change in the key will change
//  every byte in the block.
//
//  The bit propagation is such a high quality, that it beats current
//  industrial strength encryptions such as IDEA, DES, BLOWFISH ....
//
//  Please see Bit/Byte distribution study for proof.
//
// History:
//     Original in PERL
//     ported to 'C'
//     ported to Javascript
//     ported to PHP
//
// ----------------------------------------------------------------
//
// ----------------------------------------------------------------
// these vars can be set to make a custom encryption:

$vector   = "crypt";              // influence encryption algorythm
$passlim  = 32;                   // maximum key length (bytes)

$forward  = 0x55;                 // Constant propagated on forward pass
$backward = 0x5a;                 // Constant propagated on backward pass
$addend   = 17;                   // Constant used adding to encrypted values

// ----------------------------------------------------------------
// use: result = bluepoint_encrypt(str, password);

function bluepoint_encrypt($buff, $pass)

{
    global $forward, $backward, $addend, $vector, $passlim;

    if(strlen($pass) == 0) { return buff; }

    // Formulate password
    $full =  do_mulstring($pass, $passlim/strlen($pass) + 1);
    $passwd = substr($full, 0, $passlim);
    $vec = do_crypt($vector, $vector);
    //print "e VEC:  " . dumpdec($vec) . "\n";
    $passwd = do_crypt($passwd, $vec);
    //print "e PAS:  " . dumpdec($passwd) . "\n";
    $str = do_crypt($buff, $passwd);
    return $str;
}

// -----------------------------------------------------------------------
// use: result = bluepoint_decrypt(str, password);

function bluepoint_decrypt($buff, $pass)

{
    global $forward, $backward, $addend, $vector, $passlim;

    if(strlen($pass) == 0) { return $buff; }

    // Formulate password
    $full =  do_mulstring($pass, $passlim/strlen($pass) + 1);
    $passwd = substr($full, 0, $passlim);
    $vec = do_crypt($vector, $vector);
    //print "d VEC:  " . dumpdec($vec) . "\n";
    $passwd = do_crypt($passwd, $vec);
    //print "d PAS:  " . dumpdec($passwd) . "\n";
    $str = do_decrypt($buff, $passwd);
    return $str;
}

// -----------------------------------------------------------------------
// Internal to this module:

function do_crypt($s, $p)

{
    global $forward, $backward, $addend;

    $p2   = ""; $p3    = ""; $res   = "";  $loop2 = 0;

    $len  = strlen($s);  $plen  = strlen($p);

    //print("Encrypt(inp): str=$s len=$len pass=$p plen=$plen\n");

    // Pass loop (encrypt)
    for ($loop = 0; $loop < $len; $loop++)
        {
        $aa = ord(substr($s, $loop, 1));
        $aa = $aa ^ ord(substr($p, $loop2, 1));
        $loop2++; if($loop2 >= $plen) {$loop2 = 0;}     // wrap over
        $p2  .= chr($aa);
        }
    // Backward loop (encrypt)
    $bb = 0;
    for ($loop = ($len-1); $loop >= 0; $loop--)
        {
        $aa = ord(substr($p2, $loop, 1));
        $aa = (($aa ^ $backward) + $addend) + $bb;
        $bb = $aa;
        $p3[$loop] = $aa;
        }
    // Forward loop (encrypt)
    $bb = 0;
    for ($loop = 0; $loop < $len; $loop++)
        {
        $aa = $p3[$loop];
        $aa = (($aa ^ $forward) + $addend) + $bb;
        $bb = $aa;
        $res .= chr($aa);
        }
    //print("Encrypt(out): out=$res\n");
    return $res;
}

// -----------------------------------------------------------------------
// Internal to this module:

function do_decrypt($s, $p)

{
    global $forward, $backward, $addend;

    $bb    = 0; $p2    = ""; $p3    = ""; $out   = "";  $loop2 = 0;
    $len   = strlen($s); $plen  = strlen($p);

    //print "Decrypt(inp): str=$s len=$len pass=$p plen=$plen\n";

    // Forward loop (decrypt)
    $cc = 0;
    for ($loop = 0; $loop < $len; $loop++)
        {
        $bb = $cc;
        $aa = ord(substr($s, $loop, 1));
        $cc = $aa;
        $aa = (($aa - $bb) - $addend) ^ $forward;
        $p2 .= chr($aa);
        }
    // Backward loop (decrypt)
    $cc = 0;
    for ($loop = ($len-1); $loop >= 0; $loop--)
        {
        $bb = $cc;
        $cc = $aa =  ord(substr($p2, $loop, 1));
        $aa = (($aa - $bb) - $addend) ^ $backward;
        $p3[$loop] = $aa;
        }
    // Pass loop  (decrypt)
    for ($loop = 0; $loop < $len; $loop++)
        {
        $aa = $p3[$loop];
        $aa = $aa ^ ord(substr($p, $loop2, 1));
        $loop2++; if($loop2 >= $plen) {$loop2 = 0;}     //wrap over
        $out .= chr($aa);
        }
    //print "Decrypt(out): out=$out\n";
    return($out);
}

// -----------------------------------------------------------------------
// Make checksum
// use: sum = chksum(str)

function bluepoint_chksum($s)

{
    $sum = 0;
    $len = s.length;

    for ($loop2 = 0; $loop2 < $len; $loop2++)
        {
        $sum += s.charCodeAt(loop2);
        }
    return $sum;
}

// -----------------------------------------------------------------------
// Hash:
// use: hashvalue = hash(str)

function bluepoint_hash($s)

{
    $bb = 0;
    $len = s.length;
    for ($loop3 = 0; $loop3 < $len; $loop3++)
        {
        $aa = s.charCodeAt($loop3);
        $aa = $aa * 0x8000 + (($aa / 0x8000) % 0x8000);

        $sum = $sum  ^ ($aa + $bb);
        $bb = $aa;
        }
    return sum;
}

// -----------------------------------------------------------------------
// Crypt and hash:
// use: result = bluepoint_crypthash = chash(buffer, pass)

function bluepoint_crypthash($buff, $pass)

{
    $str = bluepoint_encrypt($buff, $pass);
    $sum = bluepoint_hash($str);
    return($sum);
}

// ------------------------------------------------------------------------
// Multiply string bb concating it nn times
// use:  do_mulstring (string, num_of_times)
//

function do_mulstring($str, $nn)

{
    $res = "";
    for($xx = 0; $xx < $nn; $xx++)
        {
        $res .= $str;
        }
    return $res;
}

// ------------------------------------------------------------------------
//
//function dumpdec($s)
//
//{
//    $len   = strlen($s);
//    $res = "";
//
//    for ($loop = 0; $loop < $len; $loop++)
//        {
//        $aa = substr($s, $loop, 1);
//        $res .=  "-" . ord($aa);
//        }
//    return($res);
//}

// EOF
?>
