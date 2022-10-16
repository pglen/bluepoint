# -------------------------------------------------------------------------
# Bluepoint encryption routines.
#
#   How it works:
#
#     Strings are walked chr by char with the loop:
#         {
#         $aa = ord(substr($_[0], $loop, 1));
#         do something with $aa
#         substr($_[0], $loop, 1) = pack("c", $aa);
#         }
#
#   Flow:
#         generate vector
#         generate pass
#         walk forward with password cycling loop
#         walk backwards with feedback encryption
#         walk forward with feedback encryption
#
#  The process guarantees that a single bit change in the original text
#  will change every byte in the resulting block.
#
#  The bit propagation is such a high quality, that it beats current
#  industrial strength encryptions.
#
#  Please see bit distribution study.
#
# -------------------------------------------------------------------------

package bluepoint;

# -------------------------------------------------------------------------
# These vars can be set to make a custom encryption:

$vector     = "crypt";              # influence encryption algorythm
$passlim    = 32;                   # maximum key length (bytes)

$forward    = 0x55;                 # Constant propagated on forward pass
$backward   = 0x5a;                 # Constant propagated on backward pass
$addend     = 17;                   # Constant used adding to encrypted values

# -------------------------------------------------------------------------
# Use: encrypt($str, $password);

sub encrypt

{
    my ($pass, $vec2, $out);

    if(length($_[1]) == 0) { return; }

    #print "encrypt() INP[0]: "; dumpdec($_[0]); print "INP[1]: "; dumpdec($_[1]);

    $pass = substr($_[1] x ($passlim/length($_[1]) + 1), 0, $passlim);
    print "e PAS1: ";  print($pass); print "\n";

    $vec2 = pl_crypt($vector, $vector);
    print "e VEC: ";  dumpdec($vec2); print "\n";

    $passwd = pl_crypt($pass, $vec2);
    print "e PAS2: ";  dumpdec($passwd); print "\n";

    $out = pl_crypt($_[0], $passwd);
    return $out;
}

# -------------------------------------------------------------------------
# use: decrypt($str, $password);

sub decrypt

{
    my ($pass, $vec, $out);

    if(length($_[1]) == 0) { return; }

    #print "decrypt() INP[0]: "; dumpdec($_[0]); print "INP[1]: "; dumpdec($_[1]);

    $pass =  substr($_[1] x ($passlim/length($_[1]) + 1), 0, $passlim);
    $vec2 = pl_crypt($vector, $vector); $pass = pl_crypt($pass, $vec2);

    #print "d PAS2: ";  dumpdec($pass); print "\n";

    $out = pl_decrypt($_[0], $pass);
    return $out;
}

# -------------------------------------------------------------------------
# Make checksum
# use: sum = chksum($str)

sub chksum

{
    my($len, $aa, $sum, $loop);

    $len  = length($_[0]);
    for ($loop = 0; $loop < $len; $loop++)
        {
        $aa = ord(substr($_[0], $loop, 1));
        $sum = $sum  + $aa;
        }
    return $sum;
}

# -------------------------------------------------------------------------
# Hash:
# use: hashvalue = hash($str)

sub hash

{
    my($len, $aa, $bb, $sum, $loop);

    $len  = length($_[0]);
    for ($loop = 0; $loop < $len; $loop++)
        {
        $aa = ord(substr($_[0], $loop, 1));
        $aa = $aa * 0x8000 + (($aa / 0x8000) % 0x8000);
        $sum = $sum  ^ $aa + $bb;
        $bb = $aa;
        }
    return $sum;
}

# -------------------------------------------------------------------------
# Crypt and hash:
# use: crypthash = chash($str, "pass")

sub chash

{
    my($str, $sum);

    $str = encrypt($_[0], $_[1]);
    $sum = hash($str);
    return($sum);
}

# -------------------------------------------------------------------------
# The following routines are internal to this module:

sub pl_crypt

{
    my ($aa, $bb, $cc, $loop, $loop2, $plen, $len, $out, $out2);

    $out = ""; $out2 = "";
    $len  = length($_[0]); $plen = length($_[1]);

    #print "pl_crypt(inp) str=$_[0] len=$len pass=$_[1] plen=$plen\n";

    # Pass loop  (encrypt)
    for ($loop = 0; $loop < $len; $loop++)
        {
        $aa = ord(substr($_[0], $loop, 1));
        $aa = $aa ^ ord(substr($_[1], $loop2, 1));
        $loop2++; if($loop2 >= $plen) {$loop2 = 0;}     #wrap over
        $out .= pack("c", $aa);
        }
    # Backward loop (encrypt)
    $bb = 0;
    for ($loop = $len-1; $loop >= 0; $loop--)
        {
        $aa = ord(substr($out, $loop, 1));
        $aa = (($aa ^ $backward) + $addend) + $bb;
        $bb = $aa;
        substr($out, $loop, 1) = pack("c", $aa);
        }
    # Forward loop  (encrypt)
    $bb = 0;
    for ($loop = 0; $loop < $len; $loop++)
        {
        $aa = ord(substr($out, $loop, 1));
        $aa = (($aa ^ $forward) + $addend) + $bb;
        $bb = $aa;
        $out2 .= pack("c", $aa);
        }
    #print "pl_crypt(out) out2=$out2\n";
    return($out2);
}

# -------------------------------------------------------------------------
# Internal to this module:

sub pl_decrypt

{
    my ($aa, $bb, $cc, $loop, $loop2, $len, $plen, $out, $out2);

    $len  = length($_[0]); $plen = length($_[1]);

    #print "pl_decrypt(inp) str=$_[0] len=$len pass=$_[1] plen=$plen\n";

    $out = ""; $out2 = "";

    # Forward loop (decrypt)
    $cc = 0;
    for ($loop = 0; $loop < $len; $loop++)
        {
        $bb = $cc;
        $aa = ord(substr($_[0], $loop, 1));
        $cc = $aa;
        $aa = (($aa - $bb) - $addend) ^ $forward;
        $out .= pack("c", $aa);
        }
    # Backward loop  (decrypt)
    $cc = 0;
    for ($loop = $len-1; $loop >= 0; $loop--)
        {
        $bb = $cc;
        $aa = ord(substr($out, $loop, 1));
        $cc = $aa;
        $aa = (($aa - $bb) - $addend)  ^ $backward;
        substr($out, $loop, 1) = pack("c", $aa);
        }
    # Pass loop   (decrypt)
    for ($loop = 0; $loop < $len; $loop++)
        {
        $aa = ord(substr($out, $loop, 1));
        $aa = $aa ^ ord(substr($_[1], $loop2, 1));
        $loop2++; if($loop2 >= $plen) {$loop2 = 0;}     #wrap over
        $out2 .= pack("c", $aa);
        }
    #print "pl_decrypt(out) out2=$out2\n";
    return($out2);
}

# -------------------------------------------------------------------------
# use: dumpdec($str)
# Dump decimal sequence

sub dumpdec()

{
    $len  = length($_[0]);

    for ($loop = 0; $loop < $len; $loop++)
        {
        $aa = ord(substr($_[0], $loop, 1));
        print "-" . $aa;
        }
    print "\n";
}

1;

