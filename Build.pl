use strict;
use warnings;

use Module::Build;

my $b = Module::Build->subclass(
      class => "Module::Build::Custom",
      code => <<'SUBCLASS' );

    sub ACTION_test {
        my $self = shift;
        # YOUR CODE HERE
        $self->depends_on("manifest");
        unshift (@INC, './t', );
        $self->SUPER::ACTION_test;
    }
SUBCLASS


my $build = $b->new(
    dist_name           => 'vmstat_graph',
    dist_version_from   => 'scripts/vmstat_graph.pl',
    dist_abstract       => 'Graphs for linux vmstat',
    dist_author         => 'Nikita Posohin',
    license             => 'perl',
    requires => {
        'perl'                      => '5.14.2',
        'GD::Graph::lines'          => '1.15',
    },
    build_requires => {
        'Module::Build' => 0,
    },
    script_files => {
        'scripts/vmstat_graph.pl' => undef,
    },
    install_base         => '/usr/local/',
    recursive_test_files => 1,
);

$build->install_path(script => $build->install_base . "/scripts");
$build->create_build_script();
