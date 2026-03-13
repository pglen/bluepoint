# -------------------------------------------------------------------------
# MIME compliant encoding/ecoding
#

package mime;

my ($inited);

$inited = 0;
$debug  = 0;

# -------------------------------------------------------------------------
# use: outstring = mime::encode($str)
#

sub encode

{
    my ($out, $nn);

    if(!$inited) { init(); $inited = 1; }

    $len  = int(length($_[0]) / 3);
    $len1 = int(length($_[0]) % 3);

    if($debug)
        {
        #print "STR: " . $_[0] . " LEN: " . $len  . "\r\n";
        }

    # 12345678  12345678  12345678  12345678
    # ********  ********  ********  ********
    #  _|    _____|  _______|    _____|
    # |     |      __|       ___|
    # |     |      |        |
    # 12345678  12345678  12345678
    # ********  ********  ********

    for ($xx = 0; $xx < $len; $xx++)
        {
        $a1 = ord(substr($_[0], $nn + 0, 1));
        $a2 = ord(substr($_[0], $nn + 1, 1));
        $a3 = ord(substr($_[0], $nn + 2, 1));

        $b1 = $a1 / 4;
        $b2 = (($a1 % 4) * 16) + (($a2 / 16) % 16);
        $b3 = (($a2 % 16) * 4) + (($a3 / 64) % 4);
        $b4 = ($a3 % 64);

        $out = $out . pack("c", $mime_table[$b1])
                    . pack("c", $mime_table[$b2])
                    . pack("c", $mime_table[$b3])
                    . pack("c", $mime_table[$b4]);

        $nn = $nn + 3
        }

    if($len1 == 1)
        {
        $a1 = ord(substr($_[0], $nn + 0, 1));
        $a2 = 0; $a3 = 0; $a4 = 0;

        $b1 = $a1 / 4;
        $b2 = (($a1 % 4) * 16) + (($a2 / 16) % 16);

        $out = $out . pack("c", $mime_table[$b1])
                    . pack("c", $mime_table[$b2])
                    . "=" . "=";
        }

    if($len1 == 2)
        {
        $a1 = ord(substr($_[0], $nn + 0, 1));
        $a2 = ord(substr($_[0], $nn + 1, 1));
        $a3 = 0; $a4 = 0;

        $b1 = $a1 / 4;
        $b2 = (($a1 % 4) * 16) + (($a2 / 16) % 16);
        $b3 = (($a2 % 16) * 4) + (($a3 / 64) % 4);

        $out = $out . pack("c", $mime_table[$b1])
                    . pack("c", $mime_table[$b2])
                    . pack("c", $mime_table[$b3])
                    . "=";
        }
    return ($out);
}


# -------------------------------------------------------------------------
# use: outstring = mime::decode($str)
#

sub decode

{
    my ($out, $nn);

    if(!$inited) { init(); $inited = 1; }

    $len = int(length($_[0])/4);

    if($debug)
        {
        #print "STR: " . $_[0] . " LEN: " . $len  . "\r\n";
        }

    # 12345678  12345678  12345678  12345678
    # ********  ********  ********  ********
    #  _|    _____|  _______|    _____|
    # |     |      __|       ___|
    # |     |      |        |
    # 12345678  12345678  12345678
    # ********  ********  ********

    for ($xx = 0; $xx < $len; $xx++)
        {
        $c1 = ord(substr($_[0], $nn + 0, 1));
        $c2 = ord(substr($_[0], $nn + 1, 1));
        $c3 = ord(substr($_[0], $nn + 2, 1));
        $c4 = ord(substr($_[0], $nn + 3, 1));

        $a1 = delookup($c1);
        $a2 = delookup($c2);
        $a3 = delookup($c3);
        $a4 = delookup($c4);

        $b1 = ($a1 * 4) + (($a2 / 16) % 4);
        $b2 = (($a2 % 16) * 16) + (($a3 / 4) % 16);
        $b3 = (($a3 % 4) * 64) + ($a4 % 64);

        if ($c3 == ord("="))
            {
            $out = $out . pack("c", $b1);
            }
        elsif ($c4 == ord("="))
            {
            $out = $out . pack("c", $b1) . pack("c", $b2);
            }
        else
            {
            $out = $out . pack("c", $b1) . pack("c", $b2) . pack("c", $b3);
            }
        $nn = $nn + 4;
        }
    return($out);
}

#--------------------------------------------------------------------------
# Init MIME lookup tables:

sub init

{

# Forward table:

    $mime_table[0]  = ord("A");
    $mime_table[1]  = ord("B");
    $mime_table[2]  = ord("C");
    $mime_table[3]  = ord("D");
    $mime_table[4]  = ord("E");
    $mime_table[5]  = ord("F");
    $mime_table[6]  = ord("G");
    $mime_table[7]  = ord("H");
    $mime_table[8]  = ord("I");
    $mime_table[9]  = ord("J");
    $mime_table[10] = ord("K");
    $mime_table[11] = ord("L");
    $mime_table[12] = ord("M");
    $mime_table[13] = ord("N");
    $mime_table[14] = ord("O");
    $mime_table[15] = ord("P");
    $mime_table[16] = ord("Q");
    $mime_table[17] = ord("R");
    $mime_table[18] = ord("S");
    $mime_table[19] = ord("T");
    $mime_table[20] = ord("U");
    $mime_table[21] = ord("V");
    $mime_table[22] = ord("W");
    $mime_table[23] = ord("X");
    $mime_table[24] = ord("Y");
    $mime_table[25] = ord("Z");
    $mime_table[26] = ord("a");
    $mime_table[27] = ord("b");
    $mime_table[28] = ord("c");
    $mime_table[29] = ord("d");
    $mime_table[30] = ord("e");
    $mime_table[31] = ord("f");
    $mime_table[32] = ord("g");
    $mime_table[33] = ord("h");
    $mime_table[34] = ord("i");
    $mime_table[35] = ord("j");
    $mime_table[36] = ord("k");
    $mime_table[37] = ord("l");
    $mime_table[38] = ord("m");
    $mime_table[39] = ord("n");
    $mime_table[40] = ord("o");
    $mime_table[41] = ord("p");
    $mime_table[42] = ord("q");
    $mime_table[43] = ord("r");
    $mime_table[44] = ord("s");
    $mime_table[45] = ord("t");
    $mime_table[46] = ord("u");
    $mime_table[47] = ord("v");
    $mime_table[48] = ord("w");
    $mime_table[49] = ord("x");
    $mime_table[50] = ord("y");
    $mime_table[51] = ord("z");
    $mime_table[52] = ord("0");
    $mime_table[53] = ord("1");
    $mime_table[54] = ord("2");
    $mime_table[55] = ord("3");
    $mime_table[56] = ord("4");
    $mime_table[57] = ord("5");
    $mime_table[58] = ord("6");
    $mime_table[59] = ord("7");
    $mime_table[60] = ord("8");
    $mime_table[61] = ord("9");
    $mime_table[62] = ord("+");
    $mime_table[63] = ord("/");

# Reverse table:

    $mime_rtable[ord("A")] = 0 ;
    $mime_rtable[ord("B")] = 1 ;
    $mime_rtable[ord("C")] = 2 ;
    $mime_rtable[ord("D")] = 3 ;
    $mime_rtable[ord("E")] = 4 ;
    $mime_rtable[ord("F")] = 5 ;
    $mime_rtable[ord("G")] = 6 ;
    $mime_rtable[ord("H")] = 7 ;
    $mime_rtable[ord("I")] = 8 ;
    $mime_rtable[ord("J")] = 9 ;
    $mime_rtable[ord("K")] = 10;
    $mime_rtable[ord("L")] = 11;
    $mime_rtable[ord("M")] = 12;
    $mime_rtable[ord("N")] = 13;
    $mime_rtable[ord("O")] = 14;
    $mime_rtable[ord("P")] = 15;
    $mime_rtable[ord("Q")] = 16;
    $mime_rtable[ord("R")] = 17;
    $mime_rtable[ord("S")] = 18;
    $mime_rtable[ord("T")] = 19;
    $mime_rtable[ord("U")] = 20;
    $mime_rtable[ord("V")] = 21;
    $mime_rtable[ord("W")] = 22;
    $mime_rtable[ord("X")] = 23;
    $mime_rtable[ord("Y")] = 24;
    $mime_rtable[ord("Z")] = 25;
    $mime_rtable[ord("a")] = 26;
    $mime_rtable[ord("b")] = 27;
    $mime_rtable[ord("c")] = 28;
    $mime_rtable[ord("d")] = 29;
    $mime_rtable[ord("e")] = 30;
    $mime_rtable[ord("f")] = 31;
    $mime_rtable[ord("g")] = 32;
    $mime_rtable[ord("h")] = 33;
    $mime_rtable[ord("i")] = 34;
    $mime_rtable[ord("j")] = 35;
    $mime_rtable[ord("k")] = 36;
    $mime_rtable[ord("l")] = 37;
    $mime_rtable[ord("m")] = 38;
    $mime_rtable[ord("n")] = 39;
    $mime_rtable[ord("o")] = 40;
    $mime_rtable[ord("p")] = 41;
    $mime_rtable[ord("q")] = 42;
    $mime_rtable[ord("r")] = 43;
    $mime_rtable[ord("s")] = 44;
    $mime_rtable[ord("t")] = 45;
    $mime_rtable[ord("u")] = 46;
    $mime_rtable[ord("v")] = 47;
    $mime_rtable[ord("w")] = 48;
    $mime_rtable[ord("x")] = 49;
    $mime_rtable[ord("y")] = 50;
    $mime_rtable[ord("z")] = 51;
    $mime_rtable[ord("0")] = 52;
    $mime_rtable[ord("1")] = 53;
    $mime_rtable[ord("2")] = 54;
    $mime_rtable[ord("3")] = 55;
    $mime_rtable[ord("4")] = 56;
    $mime_rtable[ord("5")] = 57;
    $mime_rtable[ord("6")] = 58;
    $mime_rtable[ord("7")] = 59;
    $mime_rtable[ord("8")] = 60;
    $mime_rtable[ord("9")] = 61;
    $mime_rtable[ord("+")] = 62;
    $mime_rtable[ord("/")] = 63;
}

#--------------------------------------------------------------------------
# Internal functions

sub lookup

{
    my ($out);

    if($_[0] >= 63)
        {
        if($debug)
            {
            print "Lo: Invalid Base64 character '$_[0]'\r\n";
            }
        $out = 0;
        }
    else
        {
        $out = $mime_table[$_[0]];
        }
    return($out);
}

#--------------------------------------------------------------------------
# Internal functions:

sub delookup

{
    my ($out);

    if(($_[0] < ord("0") or $_[0] > ord("z"))
            && ($_[0] != ord("+") && $_[0] != ord("/")))
        {
        if($debug)
            {
            print "De: Invalid Base64 character '$_[0]'\r\n";
            }
        $out = -1;
        }
    else
        {
        $out = $mime_rtable[$_[0]];
        }
    return($out);
}

#--------------------------------------------------------------------------
# Unescape character sequence.
#
# &32 -> SPACE
# &13 -> CR
# &10 -> LF
# etc ...
#
# use: unescaped = mime::unescape($str)

sub unescape

{
    my ($out, $aa, $bb, $cc, $dd, $loop, $len, $num);

    $len  = length($_[0]);

    for ($loop = 0; $loop < $len; $loop++)
        {
        $aa = ord(substr($_[0], $loop, 1));

        if($aa == ord("&"))
            {
            # Walk max 3 numbers:
            $num = $bb = $cc = $dd = 0;

            $bb = substr($_[0], $loop + 1, 1);

            if(ord($bb) >= ord("0") and ord($bb) <= ord("9"))
                {
                $num++; $cc = substr($_[0], $loop + 2, 1);
                if(ord($cc) >= ord("0") and ord($cc) <= ord("9"))
                    {
                    $num++; $dd = substr($_[0], $loop + 3, 1);
                    if(ord($dd) >= ord("0") and ord($dd) <= ord("9"))
                        {
                        $num++;
                        }
                    }
                }
            # Action is dependent on numbers:
            if ($num == 1) { $aa = $bb; }
            if ($num == 2) { $aa = 10 * $bb +  $cc; }
            if ($num == 3) { $aa = 100 * $bb + 10 * $cc + $dd; }

            if ($aa > 255)                  #adjust overflow, bach up one
               {
               $num--; $aa =  10 * $bb + $cc;
               }
            $loop += $num;                  #skip characters
            }
        $out = $out . pack("c", $aa);
        }
    return $out;
}

#--------------------------------------------------------------------------
# Escape character sequence.
#
# The following substitution occurs:
#
# &32 -> SPACE
# &13 -> CR
# &10 -> LF
#
# use: escaped = mime::escape($str)

sub escape

{
    my ($out, $aa, $bb, $cc, $dd, $loop, $len);

    $len  = length($_[0]);

    for ($loop = 0; $loop < $len; $loop++)
        {
        $aa = ord(substr($_[0], $loop, 1));

        if ($aa == 32)
            {
            $out = $out . "&32";
            }
        elsif ($aa == 13)
            {
            $out = $out . "&13";
            }
        elsif ($aa == 10)
            {
            $out = $out . "&10";
            }
        else
            {
            $out = $out . pack("c", $aa);
            }
        }
    return $out;
}

1;
