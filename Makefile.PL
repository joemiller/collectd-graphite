use 5.006;
use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'Collectd::Plugins::Graphite',
    AUTHOR              => q{Joe Miller <joeym@joeym.net>},
    VERSION_FROM        => 'lib/Collectd/Plugins/Graphite.pm',
    ABSTRACT_FROM       => 'lib/Collectd/Plugins/Graphite.pm',
    ($ExtUtils::MakeMaker::VERSION >= 6.3002
      ? ('LICENSE'=> 'bsd')
      : ()),
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Collectd-Plugins-Graphite-*' },
);
