#!perl -T

use Test::More tests => 1;

BEGIN {
	use_ok( 'Path::Lite' );
}

diag( "Testing Path::Lite $Path::Lite::VERSION, Perl $], $^X" );
