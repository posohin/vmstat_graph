#!/usr/bin/perl

use warnings;
use strict;
use Data::Dumper;
use GD::Graph::lines;

my $request_fields = ["id", "us", "sy", "wa"];

my $fields = {
    r       => 0,
    b       => 1,
    swpd    => 2,
    free    => 3,
    buff    => 4,
    cache   => 5,
    si      => 6,
    so      => 7,
    bi      => 8,
    bo      => 9,
    in      => 10,
    cs      => 11,
    us      => 12,
    sy      => 13,
    id      => 14,
    wa      => 15,
};

my %stat = ( time => [] );
my $time = 0;

my $statistic = $ARGV[0] || "&STDIN";
open( my $input_fh, "<$statistic" ) or die "Cannot open input: $!";

while ( <$input_fh> ) {
    next unless ( /^(\s+\d+)+$/ );
    my @values = split;
    foreach my $request_field ( @$request_fields ) {
        next unless exists $fields->{$request_field};
        push @{$stat{$request_field}}, $values[$fields->{$request_field}];
    }
    push $stat{time}, $time++;
}

my $graph = GD::Graph::lines->new(scalar @{$stat{time}} * 10, 512);
$graph->set(
    x_label           => 'Time, s',
    y_label           => 'CPU usage, %',
    title             => 'vmstat cpu usage',
    x_labels_vertical => 1,
    x_label_skip      => 5,
    line_width        => 4,
) or die $graph->error;
$graph->set_title_font('/usr/share/fonts/truetype/ubuntu-font-family/UbuntuMono-R.ttf', 24); #while testing
$graph->set_legend_font('/usr/share/fonts/truetype/ubuntu-font-family/UbuntuMono-R.ttf', 24); #while testing
$graph->set_legend(@$request_fields);
my @data = ();
push @data, $stat{time};
foreach my $request_field ( @$request_fields ) {
    push @data, $stat{$request_field};
}
my $gd = $graph->plot(\@data) or die $graph->error;
open IMG, '>vmstat_graph.gif' or die $!;
binmode IMG;
print IMG $gd->gif;
close IMG;

1;