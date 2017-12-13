#!/usr/bin/perl 

use warnings;
use strict;

my @sequences=("Backbone_56095",
"Backbone_15364",
"Backbone_118669",
"Backbone_32036",
"Backbone_73307",
);
my $fasta_file = "/work/cauretc/2017_Mellotropicalis/pseudomolecules/backbone_raw.fasta";
my $output_name = "/work/cauretc/2017_Mellotropicalis/pseudomolecules/filter/blast_find_SDregion/potential_backbones_SC";

my $commandline;
my $status;

foreach my $sequence_name (@sequences) {

$commandline = "awk -v seq=\"".$sequence_name."\" -v RS=\'>\' \'\$1 == seq {print RS \$0}\' ".$fasta_file." >>".$output_name.".fa";
$status = system($commandline);
}

