use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'Path::Lite',
    license             => 'perl',
    dist_author         => 'Robert Krimen <rkrimen@cpan.org>',
    dist_version_from   => 'lib/Path/Lite.pm',
    build_requires => {
        'Test::More' => 0,
        'Test::Lazy' => 0,
    	'Scalar::Util' => 0,
    },
    requires => {
    	'Scalar::Util' => 0,
	'Sub::Exporter' => 0,
    	'Carp' => 0,
    },
    optional => {
    	'Path::Class' => 0,
    },
    add_to_cleanup      => [ 'Path-Lite-*' ],
    create_makefile_pl => 'traditional',
);

warn <<_END_;

**********************************************************************
***                                                                ***
*** Path::Lite is deprecated, please switch to Path::Abstract ASAP ***
***                                                                ***
**********************************************************************


_END_

$builder->create_build_script();
