#!/usr/bin/perl

use warnings;
use strict;
use Data::Dumper;
use GD::Graph::lines;

my %stat = {
    id      => [],
    us      => [],
    time    => [],
};
my $time = 0;

while (<>) {
    chomp;
    if (/\s+(\d+)\s+(\d+)\s+\d+$/) {
        my $us = $1;
        my $id = $2;
#        my @values = split;
#        warn Dumper \@values;
        push @{$stat{id}}, $id;
        push @{$stat{us}}, $us;
        push @{$stat{time}}, $time++;
    } else {
        next;
    }
}

my $graph = GD::Graph::lines->new(scalar @{$stat{time}} * 10, 1024);
$graph->set(
    x_label           => 'Time, s',
    y_label           => 'CPU usage, %',
    title             => 'vmstat cpu usage',
    x_labels_vertical => 1,
    x_label_skip      => 10,
    line_width        => 7,
) or die $graph->error;
$graph->set_title_font('/usr/share/fonts/truetype/ubuntu-font-family/UbuntuMono-R.ttf', 24);
$graph->set_legend_font('/usr/share/fonts/truetype/ubuntu-font-family/UbuntuMono-R.ttf', 24);
$graph->set_legend("idle", "user");
my @data = ($stat{time}, $stat{id}, $stat{us});
my $gd = $graph->plot(\@data) or die $graph->error;
open IMG, '>vmstat_graph.gif' or die $!;
binmode IMG;
print IMG $gd->gif;
close IMG;

1;

# r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa
# 3  0 149892 122636 106028 310048    0    0     0     0   88  177  0  0 100  0

