#!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok( 'Flanelinha::Client' ) || print "Bail out!\n";
}

diag( "Testing Flanelinha::Client $Flanelinha::Client::VERSION, Perl $], $^X" );
