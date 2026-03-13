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
#// How to use:
#//
#//     $cypher     = bluepoint::encrypt($orig, $pass);
#//     $orig       = bluepoint::decrypt($cypher, $pass);
#//     $hash       = bluepoint::hash($orig, $pass);
#//     $crypthash  = bluepoint::crypthash($orig, $pass);
#//

package bluepoint;

# -------------------------------------------------------------------------
# These vars can be set to make a custom encryption:

$vector     = "crypt";              # influence encryption algorythm
$passlim    = 32;                   # maximum key length (bytes)

$forward    = 0x55;                 # Constant propagated on forward pass
$backward   = 0x5a;                 # Constant propagated on backward pass
$addend     = 17;                   # Constant used adding to encrypted values

# -------------------------------------------------------------------------
# These vars can be set to see internal workings

$verbose = 0;                       # Specify this to show working details
$functrace = 0;                     # Specify this to show function args

# -------------------------------------------------------------------------
# Use: encrypt($str, $password);

sub encrypt

{
    my ($pass, $vec2, $out);

    if(length($_[1]) == 0) { return; }

    if($functrace >= 1)
        {
        print "encrypt() INP[0]: "; dumphex($_[0]); print "INP[1]: "; dumphex($_[1]);
        }

    $pass = prep_pass($_[1]);
    $out = pl_encrypt($_[0], $pass);
    return $out;
}

# -------------------------------------------------------------------------
# use: decrypt($str, $password);

sub decrypt

{
    my ($pass, $vec, $out);

    if(length($_[1]) == 0) { return; }

    if($functrace >= 1)
        {
        print "decrypt() INP[0]: "; dumphex($_[0]); print "INP[1]: "; dumphex($_[1]);
        }

    $pass = prep_pass($_[1]);
    $out = pl_decrypt($_[0], $pass);
    return $out;
}

# -------------------------------------------------------------------------
# use:  prep_pass($pass)

sub prep_pass

{
    my($uscore, $vec2);

    $uscore = $_[0] . "_";

    $pass = substr($uscore x ($passlim/length($_[0]) + 1), 0, $passlim);
    #print "PAS: ";  print($pass); print "\n";

    $vec2 = pl_encrypt($vector, $vector);
    #print "VEC: ";  dumphex($vec2); print "\n";

    $pass = pl_encrypt($pass, $vec2);
    #print "e PAS2: ";  dumphex($passwd); print "\n";

    return $pass;
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
#
# Implementing the following 'C' code
#
#   define     ROTATE_LONG_RIGHT(x, n) (((x) >> (n))  | ((x) << (32 - (n))))
#   ret_val ^= (unsigned long)*name;
#   ret_val  = ROTATE_LONG_RIGHT(ret_val, 10);          /* rotate right */sub hash
#

sub hash

{
    my($len, $aa, $bb, $sum, $loop);

    $len  = length($_[0]);
    for ($loop = 0; $loop < $len; $loop++)
        {
        $aa = ord(substr($_[0], $loop, 1));
        $sum ^= $aa;

        $sum = rotateR32($sum, 10);
        }
    return $sum;
}

# ------------------------------------------------------------------------

sub rotateR32

{
    my($sum, $rot, $out, $sum1);

    $sum1 = $sum = $_[0] + 0; $rot = $_[1] + 0;

    # Shift ONE --> Reset MSB --> Shift the rest
    if($sum1 & 0x80000000)
        {
        $sum1 >>= 1;
        $sum1 &= ~0x80000000;
        $sum1 >>= ($rot - 1);
        }
    else
        {
        $sum1 >>= $rot;
        }
    $out = $sum1 | ($sum << (32 - $rot));
    return $out;
}

# ------------------------------------------------------------------------

sub rotateR8

{
    my($sum, $rot);

    $sum = $_[0]; $rot = $_[1];
    $sum &= 0xff;

    $sum =  (($sum << (8 - $rot)) & 0xff) | (($sum >> $rot) & 0xff);
    return $sum;
}

sub rotateL8

{
    my($sum, $rot);

    $sum = $_[0]; $rot = $_[1];
    $sum &= 0xff;

    $sum =  (($sum >> (8 - $rot)) & 0xff) | ( ($sum << $rot) & 0xff);
    return $sum;
}


# -------------------------------------------------------------------------
# Crypt and hash:
# use: crypthash = chash($str, "pass")

sub crypthash

{
    my($str, $sum);

    $str = encrypt($_[0], $_[1]);
    $sum = hash($str);
    return($sum);
}

# -------------------------------------------------------------------------
# The following routines are internal to this module:

sub pl_encrypt

{
    my ($aa, $bb, $cc, $loop, $loop2, $plen, $len, $out, $out2);

    $out = ""; $out2 = "";
    $len  = length($_[0]); $plen = length($_[1]);

    if($functrace >= 2)
        {
        print "pl_encrypt(inp) str=$_[0] len=$len pass=$_[1] plen=$plen\n";
        }

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

        $aa = rotateR8($aa, 3);

        $bb = $aa;
        $out2 .= pack("c", $aa);
        }
    #print "pl_encrypt(out) out2=$out2\n";
    return($out2);
}

# -------------------------------------------------------------------------
# Internal to this module:

sub pl_decrypt

{
    my ($aa, $bb, $cc, $loop, $loop2, $len, $plen, $out, $out2);

    $len  = length($_[0]); $plen = length($_[1]);

    if($functrace >= 2)
        {
        print "pl_decrypt(inp) str=$_[0] len=$len pass=$_[1] plen=$plen\n";
        }

    $out = ""; $out2 = "";

    # Forward loop (decrypt)
    $cc = 0;
    for ($loop = 0; $loop < $len; $loop++)
        {
        $bb = $cc;
        $aa = ord(substr($_[0], $loop, 1));
        $cc = $aa;

        $aa = rotateL8($aa, 3);

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
# Use: dumphex($str)

sub dumphex()

{
    $len  = length($_[0]);

    for ($loop = 0; $loop < $len; $loop++)
        {
        $aa = ord(substr($_[0], $loop, 1));
        $cc = sprintf("-%02x", $aa);
        print $cc;
        }
}

1;

