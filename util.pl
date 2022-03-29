#!/usr/bin/perl
# Util -- 2022-3-29 spoNge369

use Mojo::Base qw( -strict -signatures );
use Mojo::Util qw( url_escape url_unescape getopt xor_encode );

binmode STDOUT, ':utf8';

BEGIN {

	my $help = qq{
Usage: $0 [options ...]

   -u, --url
   -d, --decode
   -e, --encode

Examples:

   $0 -u "'ping -c1 192.168.1.1'"         -e               #%27ping%20-c1%20192.168.1.1%27
   $0 -u "%27ping%20-c1%20192.168.1.1%27" -d               #ping -c1 192.168.1.1  

	};

	@ARGV <= 1 and print $help and exit 0;
	
}


my $url = '';
my $filename = '';
my $key = '';
my $decode = '';
my $encode = '';

getopt
	'url|u=s'      => \$url,
	'encode|e'     => \$encode,
	'decode|d'     => \$decode,
	'filename|f=s' => \$filename,
	'key|k=s'      => \$key;
	

#XOR cipher
if ( $filename ne '' and $key ne '' ) {

	open my $fh, '<:raw', $filename or die;
	my $content = do { local $/; <$fh> };

	$key=~s/([a-fA-F0-9][a-fA-F0-9])/pack("C",hex($1))/eg;
	my $xd = xor_encode $content, $key;
	print $xd;
	exit 0;

}


# url encode
if ( $url ne '' and $encode ) {
   
   my $encoded = url_escape $url;
   print $encoded;
   exit 0;

}


#url decode
if ( $url ne '' and $decode ) {

	my $decoded = url_unescape $url;
    print $decoded;
	exit 0;

}
