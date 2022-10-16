#!/usr/bin/perl
#--------------------------------------------------------------------------
# perl

$str = "This is a test string.";

require "xcrypt.pl";
require "mime.pl";

$hhh = xcrypt::bluepoint_hash($str);
$ccc = xcrypt::bluepoint_crypthash($str, "123");

print "orig:           $str ($hhh) ($ccc)\n";

$str2 = xcrypt::bluepoint_encrypt($str, "123");
$str3 = mime::encode($str2);
print "encrypt/mime:   $str3\n";

$str4 = mime::decode($str3);
$str5 = xcrypt::bluepoint_decrypt($str4, "123");

$hhh = xcrypt::bluepoint_hash($str);
$ccc = xcrypt::bluepoint_crypthash($str, "123");

print "decrypt:demime: $str5 ($hhh) ($ccc)\n";


