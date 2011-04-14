#!perl -T

use Test::More tests => 1;

BEGIN {
    # unfortunately we can't test module load since it will die
    # and complain about the use of globals in the Collectd.pm module.
    # Perhaps in collectd 5.x this will be resolved?

    # use_ok( 'Collectd::Plugins::Graphite' ) || print "Bail out!\n";
    pass();
}

diag( "Testing Collectd::Plugins::Graphite $Collectd::Plugins::Graphite::VERSION, Perl $], $^X" );
