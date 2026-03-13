//# ----------------------------------------------------------------
//# Encryption routines for data communication.
//#
//#   How it works:
//#
//#     Strings are walked chr by char with the loop:
//#         {
//#         aa = ord(functionstr(_[0], loop, 1));
//#
//#         do something with aa
//#
//#         functionstr(_[0], loop, 1) = pack("c", aa);
//#         }
//#
//#   Flow:
//#         generate vector
//#         generate pass
//#         walk forward with password cycling loop
//#         walk backwards with feedback encryption
//#         walk forward with feedback encryption
//#
//#  The process guarantees that a single bit change in the original text
//#  will change every byte in the block.
//#
//#  The process also guarantees that a single bit change in the key will change
//#  every byte in the block.
//#
//#  The bit propagation is such a high quality, that it beats current
//#  industrial strength encryptions such as IDEA, DES, BLOWFISH ....
//#
//#  Please see Bit/Byte distribution study for proof.
//#
//# History:
//#     Original in PERL and 'C'
//#     ported to Javascript
//#
//# ----------------------------------------------------------------

//# ----------------------------------------------------------------
//# these vars can be set to make a custom encryption:

var forward, backward, addend, vector, passlim, stock_pass;

vector     = "crypt";               //# influence encryption algorythm
passlim    = 32;                    //# maximum key length (bytes)

forward    = 0x55;
backward   = 0x5a;
addend     = 17;

stock_pass  = "1234";               //# The stock pass, when no pass is given

//# ----------------------------------------------------------------
//# use: result = bluepoint_encrypt(str, password);

function bluepoint_encrypt(buff, pass)

{
    var passx = "", vec = "", full = "";

    //alert ("Encr:  " + buff + " Pass: " + pass );

    if(buff == "")
        {
        alert("null buffer");
        return "";
        }

    if(pass.length == 0)
        {
        alert("Empty Password");
        return buff;
        }

    passx = pass;

    // Formulate password
    vec  = vector;
    full =  do_mulstring(passx, passlim/pass.length + 1);
    passx = full.substr(0, passlim);

    //alert("passx1: " + passx);

    // Doit
    vec = do_encrypt(vec, vector);
    passx = do_encrypt(passx, vec);
    str = do_encrypt(buff, passx);

    return str;
}

//# -----------------------------------------------------------------------
//# use: result = bluepoint_decrypt(str, password);

function bluepoint_decrypt(buff, pass)

{
    var str, passx, vec, full;

    //alert ("Decr:  " + buff + " Pass: " + pass );

    if(buff == "")
        {
        alert("null buff");
        return "";
        }

    if(pass.length == 0)
        {
        alert("Empty Password");
        //return buff;
        passx = stock_pass;
        }
    else
        {
        passx = pass;
        }

    // Formulate password
    vec  = vector;
    full =  do_mulstring(passx, passlim/pass.length + 1);
    passx = full.substr(0, passlim);

    vec = do_encrypt(vec, vector);
    passx = do_encrypt(passx, vec);
    str = do_decrypt(buff, passx);

    return str;
}

//# -----------------------------------------------------------------------
//# use: val = rotate_right(nnn, rrr)

function rotate_right(nnn, rrr)

{
    return  (nnn >>> rrr)  | (nnn << (32 - rrr));
}


function rotate8_right(nnn, rrr)

{
    return  ((nnn >>> rrr) & 0xff) | ((nnn << (8 - rrr)) & 0xff);
}


function rotate8_left(nnn, rrr)

{
    return  ((nnn << rrr) & 0xff) | ((nnn >>> (8 - rrr) ) & 0xff);
}



//# -----------------------------------------------------------------------
//# Hash:
//# use: hashvalue = hash(str)

function bluepoint_hash(ss)

{
    var len, aa = 0, bb, sum = 0, loop3;

    //alert("hash: " + ss);

    len  = ss.length;
    for (loop3 = 0; loop3 < len; loop3++)
        {
        aa = ss.charCodeAt(loop3);
        sum ^= aa;
        sum = rotate_right(sum, 10);
        }

    return sum;
}

//# -----------------------------------------------------------------------
//# Crypt and hash:
//# use: result = bluepoint_crypthash = chash(buffer, pass)

function bluepoint_crypthash(buff, pass)

{
    var str, sum;

    str = bluepoint_encrypt(buff, pass);
    sum = bluepoint_hash(str);
    return(sum);
}

//# -----------------------------------------------------------------------
//#
//# Below this, everything is internal to this module:
//#
//# -----------------------------------------------------------------------

///////////////////////////////////////////////////////////////////////////
// Character arithmetic, do 'C' CHAR type overflow handling
///////////////////////////////////////////////////////////////////////////

function char_add(ch1, ch2)

{
    var res = ch1 + ch2;

    //if(res > 0xff)
    //    res &= 0xff;

    if (res < 0)
        res += 0x100;

    return res & 0xff;
}

///////////////////////////////////////////////////////////////////////////
// Character arithmetic, do 'C' CHAR type overflow handling
///////////////////////////////////////////////////////////////////////////

function char_sub(ch1, ch2)

{
    var res = ch1 - ch2;

    //if(res > 0xff)
    //    res -= 0xff;

    if (res < 0)
        res += 0x100;

    return  res & 0xff;
}

// ------------------------------------------------------------------------
// Multiply string bb concating it nn times
// use:  do_mulstring (string, num_of_times)
//

function do_mulstring(str, nn)

{
    var res = "", xx;

    //alert (" str: " + str + " nn:  " + nn);

    for(xx = 0; xx < nn; xx++)
        {
        res += str + "_";
        }

    //alert("ret: " + res);

    return res;
}

// ------------------------------------------------------------------------
// Worker function: encrypt
//

function do_encrypt(s1, p1)

{
    var aa, bb, cc, loop, loop2, plen, len, s2, s3, s4, res;

    bb      = 0;
    s2      = "", s3   = ""; s4 = ""; res     = "";
    len     = s1.length,  plen    = p1.length;
    loop2   = 0;

    //alert ("do_encrypt: '" + s1 + "' - '" + p1 + "'");

    // eeeeeeeeee Add/sub loop -- for testing only
    //for (loop = 0; loop < len; loop++)
    //    {
    //    aa = s1.charCodeAt(loop);
    //    aa = char_add(aa, 190);
    //    //alert("encry: aa=" + aa);
    //
    //    var sss1 = String.fromCharCode(aa);
    //    s2 += sss1;
    //    }
    //return s2;

    //# Pass loop  (encrypt)
    for (loop = 0; loop < len; loop++)
        {
        aa = s1.charCodeAt(loop);

        aa = aa ^ p1.charCodeAt(loop2);

        loop2++; if(loop2 >= plen) {loop2 = 0;}     //# wrap over

        var sss1 = String.fromCharCode(aa);
        s2 += sss1;
        }

    //# Backward loop (encrypt)
    bb = 0;
    for (loop = len-1; loop >= 0; loop--)
        {
        aa = s2.charCodeAt(loop);

        aa ^= backward;
        aa  =   char_add(aa, addend)
        aa  =   char_add(aa,  bb);

        bb = aa;

        var sss1 = String.fromCharCode(aa);
        s3 += sss1;
        }

    //# Reverse after backward loop  (encrypt)
    for (loop = len-1; loop >= 0; loop--)
        {
        aa = s3.charCodeAt(loop);
        s4 += String.fromCharCode(aa);
        }

    //# Forward loop  (encrypt)
    bb = 0;
    for (loop = 0; loop < len; loop++)
        {
        aa = s4.charCodeAt(loop);

        aa ^= forward;
        aa = char_add(aa, addend);
        aa = char_add(aa, bb);

        aa = rotate8_right(aa, 3);

        bb = aa;

        var sss1 = String.fromCharCode(aa);
        res += sss1;
        }

    //alert("res: " +  res);
    return res;
}

//
//abcdefghijklmnopqrstuvwxyz
//

// ------------------------------------------------------------------------
// Worker function: decrypt
//
//   12345678901234567890
//   |         |
//
//

function do_decrypt(s1, p1)

{
    var aa, bb, cc, loop, loop2, s2, s3, s4, len, plen;

    s2      = "", s3      = ""; s4 = "";  res     = "";
    len     = s1.length;
    plen    = p1.length;
    loop2   = 0;

    //alert ("do_decrypt: '" + s1 + "' - '" + p1 + "'");

    // dddddddddd Add/sub loop -- for testing only
    //for (loop = 0; loop < len; loop++)
    //    {
    //    aa = s1.charCodeAt(loop);
    //    aa = char_sub(aa, 190);
    //    //alert("decry: aa=" + aa);
    //
    //    var sss1 = String.fromCharCode(aa);
    //    s2 += sss1;
    //    }
    //return s2;

    //# Forward loop (decrypt)
    bb = cc = 0;
    for (loop = 0; loop < len; loop++)
        {
        bb = cc;

        cc = aa = s1.charCodeAt(loop);

        aa = rotate8_left(aa, 3);

        aa = char_sub(aa, bb);
        aa = char_sub(aa, addend);
        aa ^= forward;


        var sss1 = String.fromCharCode(aa);
        s2 += sss1;
        }

    //# Backward loop  (decrypt)
    bb = cc = 0;
    for (loop = len-1; loop >= 0; loop--)
        {
        bb = cc;
        cc = aa = s2.charCodeAt(loop);

        aa = char_sub(aa, bb);
        aa = char_sub(aa, addend)
        aa ^=  backward;

        var sss2 = String.fromCharCode(aa);
        s3 += sss2;
        }

    //# Backward loop  reverse it (decrypt)
    for (loop = len-1; loop >= 0; loop--)
        {
        aa = s3.charCodeAt(loop);
        s4 += String.fromCharCode(aa);
        }

    //# Pass loop   (decrypt)
    for (loop = 0; loop < len; loop++)
        {
        aa = s4.charCodeAt(loop);

        aa = aa ^ p1.charCodeAt(loop2);

        loop2++; if(loop2 >= plen) {loop2 = 0;}     //# wrap over

        var sss3 = String.fromCharCode(aa);
        res += sss3;
        }

    return res;
}

// -------------------------------------------------------------------------
// Use: str = dumphex($str)

function dumphex(str)

{
    var str2 = "", pre, len  = str.length;

    for (loop = 0; loop < len; loop++)
        {
        var aa = str.charCodeAt(loop);

        // Expand to %02x
        if(aa < 16)
            pre =  "-0";
        else
            pre =  "-";

        str2 +=  pre  + aa.toString(16);
        }
    return str2;
}

// EOF

