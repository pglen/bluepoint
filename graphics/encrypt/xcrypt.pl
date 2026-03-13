# ----------------------------------------------------------------
# Encryption routines.
#
#   How it works:
#
#     Strings are walked chr by char with the loop:
#         {
#         $aa = ord(substr($_[0], $loop, 1));
#
#         do something with $aa
#
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
#  will change every byte in the block.
#
#  The process also guarantees that a single bit change in the key will
#  change every byte in the block.
#
#  The bit propagation is such a high quality, that it beats current
#  industrial strength encryptions.
#
#  Please see bit distribution study.
#
# ----------------------------------------------------------------

package xcrypt;

# ----------------------------------------------------------------
# these vars can be set to make a custom encryption:

my ($forward, $backward, $addend, $vector, $passlim);

$vector     = "crypt";              # influence encryption algorythm
$passlim    = 32;                   # maximum key length (bytes)

$forward    = 0x55;
$backward   = 0x5a;
$addend     = 17;

# ----------------------------------------------------------------
# use: encrypt($str, $password);

sub bluepoint_encrypt

{
    local($str, $pass, $vec);
    if(length($_[1]) == 0) { return $_[0]; }

    $vec  = $vector;
    $pass = substr($_[1] x ($passlim/length($_[1]) + 1), 0, $passlim);
    $str  = $_[0];
    if($debug) {
        print "pass: $pass\n";
        }
    do_crypt($vec, "");
    do_crypt($pass, $vec);
    do_crypt($str, $pass);

    if($debug) {
        #print "Encr:  " . $_[0] . " Pass: " . $_[1] . "\r\n";
        }
    return $str;
}

# ----------------------------------------------------------------
# use: decrypt($str, $password);

sub bluepoint_decrypt

{
    local($str, $pass, $vec);
    if(length($_[1]) == 0) { return $_[0]; }

    $vec = $vector;
    $pass =  substr($_[1] x ($passlim/length($_[1]) + 1), 0, $passlim);
    $str  = $_[0];
    if($debug) {
        print "pass: $pass\n";
        }
    do_crypt($vec, "");
    do_crypt($pass, $vec);
    do_decrypt($str, $pass);

    if($debug) {
        #print "Decr:  " . $_[0] . " Pass: " . $_[1] . "\r\n";
        }
    return $str;
}

# ----------------------------------------------------------------
# Make checksum
# use: sum = chksum($str)

sub bluepoint_chksum

{
    local($len, $aa, $sum, $loop);

    $len  = length($_[0]);
    for ($loop = 0; $loop < $len; $loop++)
        {
        $aa = ord(substr($_[0], $loop, 1));
        $sum = $sum  + $aa;
        }
    return $sum;
}

# ----------------------------------------------------------------
# Hash:
# use: hashvalue = hash($str)

sub bluepoint_hash

{
    local($len, $aa, $bb, $sum, $loop);

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

# ----------------------------------------------------------------
# Crypt and hash:
# use: crypthash = bluepoint_crypthash($str, "pass")

sub bluepoint_crypthash

{
    local($str, $sum);

    $str = bluepoint_encrypt($_[0], $_[1]);
    $sum = bluepoint_hash($str);
    return($sum);
}

# ----------------------------------------------------------------
# Internal to this module:

sub do_crypt

{
    my ($aa, $bb, $cc, $loop, $loop2, $plen, $len);

    $loop2 = 0;
    $len   = length($_[0]);
    $plen  = length($_[1]);

    # Pass loop
    for ($loop = 0; $loop < $len; $loop++)
        {
        $aa = ord(substr($_[0], $loop, 1));

        $aa = $aa ^ ord(substr($_[1], $loop2, 1));

        $loop2++; if($loop2 >= $plen) {$loop2 = 0;}     #wrap over

        substr($_[0], $loop, 1) = pack("c", $aa);
        }

    # Backward loop
    $bb = 0;
    for ($loop = $len-1; $loop >= 0; $loop--)
        {
        $aa = ord(substr($_[0], $loop, 1));

        $aa = (($aa ^ $backward) + $addend) + $bb;
        $bb = $aa;

        substr($_[0], $loop, 1) = pack("c", $aa);
        }

    # Forward loop
    $bb = 0;
    for ($loop = 0; $loop < $len; $loop++)
        {
        $aa = ord(substr($_[0], $loop, 1));

        $aa = (($aa ^ $forward) + $addend) ^ $bb;
        $bb = $aa;

        substr($_[0], $loop, 1) = pack("c", $aa);
        }
   $_[0];
}

# ----------------------------------------------------------------
# Internal to this module:

sub do_decrypt

{
    my ($aa, $bb, $cc, $loop, $loop2, $len, $plen);

    $loop2 = 0;
    $len  = length($_[0]);
    $plen = length($_[1]);

    # Forward loop
    $cc = 0;
    for ($loop = 0; $loop < $len; $loop++)
        {
        $bb = $cc;

        $cc = $aa = ord(substr($_[0], $loop, 1));
        $aa = (($aa ^ $bb) - $addend) ^ $forward;

        substr($_[0], $loop, 1) = pack("c", $aa);
        }

    $cc = 0;
    # Backward loop
    for ($loop = $len-1; $loop >= 0; $loop--)
        {
        $bb = $cc;

        $cc = $aa = ord(substr($_[0], $loop, 1));
        $aa = (($aa - $bb) - $addend) ^ $backward;

        substr($_[0], $loop, 1) = pack("c", $aa);
        }

    # Pass loop
    for ($loop = 0; $loop < $len; $loop++)
        {
        $aa = ord(substr($_[0], $loop, 1));

        $aa = $aa ^ ord(substr($_[1], $loop2, 1));

        $loop2++; if($loop2 >= $plen) {$loop2 = 0;}     #wrap over

        substr($_[0], $loop, 1) = pack("c", $aa);
        }
   $_[0];
}
1;

