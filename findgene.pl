#！/usr/bin/perl -w

use SelSweepRegion::FindGene;
use strict;

my $find=SelSweepRegion::FindGene->new();
$find->add_selsweep_regions(-region_files=>"altitude_flk_3%_sr.txt");
$find->add_genes(-gene_file=>"altitude_flk_3%_gene.txt");
$find->add_outfile(-out_file=>"result.txt");
$find->find_gene();
