#!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok( 'Collectd::Plugins::Graphite' ) || print "Bail out!\n";
}

diag( "Testing Collectd::Plugins::Graphite $Collectd::Plugins::Graphite::VERSION, Perl $], $^X" );
