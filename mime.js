///////////////////////////////////////////////////////////////////////////
// Declare working variables needed for MIME decoding

var mime_table = new Array()
var mime_rtable = new Array()
var inited = 0;

///////////////////////////////////////////////////////////////////////////
// Init MIME lookup tables:

function mime_init()

{
// Forward table:

mime_table[0] = 65; //ord("A");
mime_table[1] = 66; //ord("B");
mime_table[2] = 67; //ord("C");
mime_table[3] = 68; //ord("D");
mime_table[4] = 69; //ord("E");
mime_table[5] = 70; //ord("F");
mime_table[6] = 71; //ord("G");
mime_table[7] = 72; //ord("H");
mime_table[8] = 73; //ord("I");
mime_table[9] = 74; //ord("J");
mime_table[10] = 75; //ord("K");
mime_table[11] = 76; //ord("L");
mime_table[12] = 77; //ord("M");
mime_table[13] = 78; //ord("N");
mime_table[14] = 79; //ord("O");
mime_table[15] = 80; //ord("P");
mime_table[16] = 81; //ord("Q");
mime_table[17] = 82; //ord("R");
mime_table[18] = 83; //ord("S");
mime_table[19] = 84; //ord("T");
mime_table[20] = 85; //ord("U");
mime_table[21] = 86; //ord("V");
mime_table[22] = 87; //ord("W");
mime_table[23] = 88; //ord("X");
mime_table[24] = 89; //ord("Y");
mime_table[25] = 90; //ord("Z");
mime_table[26] = 97; //ord("a");
mime_table[27] = 98; //ord("b");
mime_table[28] = 99; //ord("c");
mime_table[29] = 100; //ord("d");
mime_table[30] = 101; //ord("e");
mime_table[31] = 102; //ord("f");
mime_table[32] = 103; //ord("g");
mime_table[33] = 104; //ord("h");
mime_table[34] = 105; //ord("i");
mime_table[35] = 106; //ord("j");
mime_table[36] = 107; //ord("k");
mime_table[37] = 108; //ord("l");
mime_table[38] = 109; //ord("m");
mime_table[39] = 110; //ord("n");
mime_table[40] = 111; //ord("o");
mime_table[41] = 112; //ord("p");
mime_table[42] = 113; //ord("q");
mime_table[43] = 114; //ord("r");
mime_table[44] = 115; //ord("s");
mime_table[45] = 116; //ord("t");
mime_table[46] = 117; //ord("u");
mime_table[47] = 118; //ord("v");
mime_table[48] = 119; //ord("w");
mime_table[49] = 120; //ord("x");
mime_table[50] = 121; //ord("y");
mime_table[51] = 122; //ord("z");
mime_table[52] = 48; //ord("0");
mime_table[53] = 49; //ord("1");
mime_table[54] = 50; //ord("2");
mime_table[55] = 51; //ord("3");
mime_table[56] = 52; //ord("4");
mime_table[57] = 53; //ord("5");
mime_table[58] = 54; //ord("6");
mime_table[59] = 55; //ord("7");
mime_table[60] = 56; //ord("8");
mime_table[61] = 57; //ord("9");
mime_table[62] = 43; //ord("+");
mime_table[63] = 47; //ord("/");

// Reverse table:

mime_rtable[65] = 0 ; //ord("A")
mime_rtable[66] = 1 ; //ord("B")
mime_rtable[67] = 2 ; //ord("C")
mime_rtable[68] = 3 ; //ord("D")
mime_rtable[69] = 4 ; //ord("E")
mime_rtable[70] = 5 ; //ord("F")
mime_rtable[71] = 6 ; //ord("G")
mime_rtable[72] = 7 ; //ord("H")
mime_rtable[73] = 8 ; //ord("I")
mime_rtable[74] = 9 ; //ord("J")
mime_rtable[75] = 10; //ord("K")
mime_rtable[76] = 11; //ord("L")
mime_rtable[77] = 12; //ord("M")
mime_rtable[78] = 13; //ord("N")
mime_rtable[79] = 14; //ord("O")
mime_rtable[80] = 15; //ord("P")
mime_rtable[81] = 16; //ord("Q")
mime_rtable[82] = 17; //ord("R")
mime_rtable[83] = 18; //ord("S")
mime_rtable[84] = 19; //ord("T")
mime_rtable[85] = 20; //ord("U")
mime_rtable[86] = 21; //ord("V")
mime_rtable[87] = 22; //ord("W")
mime_rtable[88] = 23; //ord("X")
mime_rtable[89] = 24; //ord("Y")
mime_rtable[90] = 25; //ord("Z")
mime_rtable[97] = 26; //ord("a")
mime_rtable[98] = 27; //ord("b")
mime_rtable[99] = 28; //ord("c")
mime_rtable[100] = 29; //ord("d")
mime_rtable[101] = 30; //ord("e")
mime_rtable[102] = 31; //ord("f")
mime_rtable[103] = 32; //ord("g")
mime_rtable[104] = 33; //ord("h")
mime_rtable[105] = 34; //ord("i")
mime_rtable[106] = 35; //ord("j")
mime_rtable[107] = 36; //ord("k")
mime_rtable[108] = 37; //ord("l")
mime_rtable[109] = 38; //ord("m")
mime_rtable[110] = 39; //ord("n")
mime_rtable[111] = 40; //ord("o")
mime_rtable[112] = 41; //ord("p")
mime_rtable[113] = 42; //ord("q")
mime_rtable[114] = 43; //ord("r")
mime_rtable[115] = 44; //ord("s")
mime_rtable[116] = 45; //ord("t")
mime_rtable[117] = 46; //ord("u")
mime_rtable[118] = 47; //ord("v")
mime_rtable[119] = 48; //ord("w")
mime_rtable[120] = 49; //ord("x")
mime_rtable[121] = 50; //ord("y")
mime_rtable[122] = 51; //ord("z")
mime_rtable[48] = 52; //ord("0")
mime_rtable[49] = 53; //ord("1")
mime_rtable[50] = 54; //ord("2")
mime_rtable[51] = 55; //ord("3")
mime_rtable[52] = 56; //ord("4")
mime_rtable[53] = 57; //ord("5")
mime_rtable[54] = 58; //ord("6")
mime_rtable[55] = 59; //ord("7")
mime_rtable[56] = 60; //ord("8")
mime_rtable[57] = 61; //ord("9")
mime_rtable[43] = 62; //ord("+")
mime_rtable[47] = 63; //ord("/")
}

///////////////////////////////////////////////////////////////////////////
// MIME encode string
//

function mime_encode(s)

{
	var out = "";
	var nn = 0, xx = 0;
	var len, len1;
	var a1, a2, a3, a4;
	var b1, b2, b3, b4;

	if(!inited) { mime_init(); inited = 1; }

	len = s.length / 3;
	len1 = s.length % 3;

	//# 12345678 12345678 12345678 12345678
	//# ******** ******** ******** ********
	//# _| _____| _______| _____|
	//# | | __| ___|
	//# | | | |
	//# 12345678 12345678 12345678
	//# ******** ******** ********

	for (xx = 0; xx < len; xx++)
		{
		a1 = s.charCodeAt(3 * xx);
		a2 = s.charCodeAt(3 * xx + 1);
		a3 = s.charCodeAt(3 * xx + 2);

		// There is a nicer way, but this stands up unmodified
		// in perl, c, javascript ...
		b1 = a1 >>> 2;
		b2 = ((a1 % 4) << 4) + ((a2 >>> 4) % 16);
		b3 = ((a2 % 16) << 2) + ((a3 >>> 6) % 4);
		b4 = (a3 % 64);

		var sss1 = String.fromCharCode(mime_table[b1]);
		var sss2 = String.fromCharCode(mime_table[b2]);
		var sss3 = String.fromCharCode(mime_table[b3]);
		var sss4 = String.fromCharCode(mime_table[b4]);
		out += sss1 + sss2 + sss3 + sss4;
		nn += 3;
		}

	if(len1 == 1)
		{
		a1 = s.charCodeAt(nn);
		a2 = 0; a3 = 0; a4 = 0;

		b1 = a1 >>> 2;
		b2 = ((a1 % 4) << 4) + ((a2 >>> 4) % 16);

		var sss1 = String.fromCharCode(mime_table[b1]);
		var sss2 = String.fromCharCode(mime_table[b2]);
		var sss3 = "=";
		var sss4 = "=";

		out += sss1 + sss2 + sss3 + sss4;
		}
	if(len1 == 2)
		{
		a1 = s.charCodeAt(nn);
		a2 = s.charCodeAt(nn+1);
		a3 = 0; a4 = 0;

		b1 = a1 >>> 2;
		b2 = ((a1 % 4) * 16) + ((a2 >>> 4) % 16);
		b3 = ((a2 % 16) * 4) + ((a3 >>> 6) % 4);

		var sss1 = String.fromCharCode(mime_table[b1]);
		var sss2 = String.fromCharCode(mime_table[b2]);
		var sss3 = String.fromCharCode(mime_table[b3]);
		var sss4 = "=";

		out += sss1 + sss2 + sss3 + sss4;
		}
	return out;
}

///////////////////////////////////////////////////////////////////////////
// MIME decode string
//

function mime_decode(s)

{
	var out = "", nn = 0, xx, len;
	var a1, a2, a3, a4;
	var b1, b2, b3, b4;
	var c1, c2, c3, c4;

	if(!inited) { mime_init(); inited = 1; }

	len = s.length/4;

	//# 12345678 12345678 12345678 12345678
	//# ******** ******** ******** ********
	//# _| _____| _______| _____|
	//# | | __| ___|
	//# | | | |
	//# 12345678 12345678 12345678
	//# ******** ******** ********

	for (xx = 0; xx < len; xx++)
		{
		c1 = s.charCodeAt(nn);
		c2 = s.charCodeAt(nn + 1);
		c3 = s.charCodeAt(nn + 2);
		c4 = s.charCodeAt(nn + 3);

		a1 = mime_rtable[c1];
		a2 = mime_rtable[c2];
		a3 = mime_rtable[c3];
		a4 = mime_rtable[c4];

		b1 = (a1 * 4) + ((a2 >>> 4) % 4);
		b2 = ((a2 % 16) * 16) + ((a3 >>> 2) % 16);
		b3 = ((a3 % 4) * 64) + (a4 % 64);

		var sss1 = String.fromCharCode(b1);
		var sss2 = String.fromCharCode(b2);
		var sss3 = String.fromCharCode(b3);

		if (c3 == 61)
			{
			out += sss1;
			}
		else if (c4 == 61)
			{
			out += sss1 + sss2;
			}
		else
			{
			out += sss1 + sss2 + sss3;
			}
		nn = nn + 4;
		}
	return out ;
}

///////////////////////////////////////////////////////////////////////////
// This function produces an escaped string

function mimeit(s)

{
	var ss = "";

	for(var i = 0; i < s.length; i++)
		{
		var c = s.charCodeAt(i);

		c += 32;
		if(c > 128)
			{
			c-= 128;
			}

		//if(c >= 97 && c <= 122)
		// {
		// c-= 32;
		// }

		var sss = String.fromCharCode(c);
		ss += sss;
		}
	return escape(ss);
}


