package SelSweepRegion::FindGene;

use 5.006;
use strict;
use warnings;

=head1 NAME

SelSweepRegion::FindGene - The great new SelSweepRegion::FindGene help 
find genes in the selective sweep regions!

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';


=head1 SYNOPSIS

Find genes which are located in the selective sweep regions.

use SelSweepRegion::FindGene;

$find = SelSweepRegion::FindGene->new();

$find -> add_selsweep_regions(-region_file=>"");

$find -> add_genes(-gene_file=>"");

$find -> add_outfile(-out_file=>"");

$find -> find_gene();

=cut

use IO::File;
use vars qw(%fields);

# Define the fields to be used as identifiers.
%fields = (
	regions => undef,
	genes => undef,
	out_file => undef,
);

=head1 SUBROUTINES/METHODS

=head2 new

	$find = SelSweepRegion::FindGene -> new();
			Creat a new object.
=cut

sub new {
	my $class = shift;
	my $self = {
		%fields,
	};

	bless ($self, $class);
	return $self;
}

=head2 add_selsweep_regions

	$find -> add_selsweep_regions(-region_file=>"");

			Input a file contains the selective sweep regions.

=cut

sub add_selsweep_regions {
	my $self = shift;
	my %parameters = @_;
	for (keys %parameters) {
		if($_=~/^-region_files$/){
			$self->{regions}=$parameters{$_};
		}
		else{
			die "Unacceptable parameters in the method <add_selsweep_regions>, please read README!\n";
		}
	}
}


=head2 add_genes

	$find -> add_genes(-gene_file=>"");

			Input a file contains the genes and their locations.
=cut

sub add_genes {
	my $self = shift;
	my %parameters= @_;
	for (keys %parameters) {
		if($_=~/^-gene_file$/){
			$self->{genes}=$parameters{$_};
		}
		else{
			die "Unacceptable parameters in the method <add_genes>, please read README!\n";
		}
	}
}


=head2 add_outfile

	$find -> add_outfile(-out_file=>"");

			Output the result into the out file.
=cut

sub add_outfile {
	my $self = shift;
	my %parameters= @_;
	for (keys %parameters) {
		if($_=~/^-out_file$/){
			$self->{out_file}=$parameters{$_};
		}
		else{
			die "Unacceptable parameters in the method <add_outfile>, please read README!\n";
		}
	}
}


=head2 find_gene

	$find -> find_gene();

			Find genes located in the selective sweep regions and output the result into the 
			output file user provides.
=cut

sub find_gene {
	my $self = shift;
	my $region_file=$self->{regions};
	my $gene_file=$self->{genes};
	my $out_file=$self->{out_file};
	if($region_file){
		print "The selective regions file user provides is:\t", $region_file,"\n";
	}else{
		die "No selective regions file provided!\n";
	}
	if($gene_file){
		print "The genes file user provides is:\t", $gene_file,"\n";
	}else{
		die "No genes file provided!\n";
	}
	if($out_file){
		print "The output file user provides is:\t", $out_file,"\n";
	}else{
		die "No output file provided!\n";
	}
	
	my $region_fh=IO::File->new("$region_file",'r');
	my $gene_fh=IO::File->new("$gene_file",'r');
	my $out_fh=IO::File->new(">$out_file");

	$out_fh->print("GeneID\tChrom\tStart\tEnd\tGeneName\tStatistic\tP-value\n");

	my %sr;
	my $line_count1=0;
	while(<$region_fh>){
		chomp;
		my $line=$_;
		$line_count1++;
		if($line_count1>1){
			my ($chr,$left,$right,$flk,$pvalue)=split /\t/, $line;
			$sr{$chr}{$line_count1}{left}=$left;
			$sr{$chr}{$line_count1}{right}=$right;
			$sr{$chr}{$line_count1}{flk}=$flk;
			$sr{$chr}{$line_count1}{pvalue}=$pvalue;
		}
	}

	my $line_count2=0;
	while(<$gene_fh>){
		chomp;
		my $line=$_;
		$line_count2++;
		if($line_count2>1){
			my ($name,$chr,$start,$end,$name2)=split /\t/, $line;
			my $stat0="NA";
			my $pvalue0="NA";
			if($sr{$chr}){
				for my $count (keys %{$sr{$chr}}){
					my $left=$sr{$chr}{$count}{left};
					my $right=$sr{$chr}{$count}{right};
					my $stat=$sr{$chr}{$count}{flk};
					my $pvalue=$sr{$chr}{$count}{pvalue};
					if($start>=$left && $start <=$right || $end >= $left && $end <=$right || $start<=$left && $end >=$right){
						if($stat0 eq "NA"){
							$stat0=$stat;
							$pvalue0=$pvalue;
						}else{
							if($stat>$stat0){
								$stat0=$stat;
								$pvalue0=$pvalue;
							}	
						}
					}
				}
			}
			$out_fh->print("$line\t$stat0\t$pvalue0\n");
		}
	}
}




=head1 AUTHOR

Jinpeng Wang, C<< <wangjinpeng0225 at 163.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-selsweepregion-findgene at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=SelSweepRegion-FindGene>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc SelSweepRegion::FindGene


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=SelSweepRegion-FindGene>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/SelSweepRegion-FindGene>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/SelSweepRegion-FindGene>

=item * Search CPAN

L<http://search.cpan.org/dist/SelSweepRegion-FindGene/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 LICENSE AND COPYRIGHT

Copyright 2016 Jinpeng Wang.

This program is free software; you can redistribute it and/or modify it
under the terms of the the Artistic License (2.0). You may obtain a
copy of the full license at:

L<http://www.perlfoundation.org/artistic_license_2_0>

Any use, modification, and distribution of the Standard or Modified
Versions is governed by this Artistic License. By using, modifying or
distributing the Package, you accept this license. Do not use, modify,
or distribute the Package, if you do not accept this license.

If your Modified Version has been derived from a Modified Version made
by someone other than you, you are nevertheless required to ensure that
your Modified Version complies with the requirements of this license.

This license does not grant you the right to use any trademark, service
mark, tradename, or logo of the Copyright Holder.

This license includes the non-exclusive, worldwide, free-of-charge
patent license to make, have made, use, offer to sell, sell, import and
otherwise transfer the Package with respect to any patent claims
licensable by the Copyright Holder that are necessarily infringed by the
Package. If you institute patent litigation (including a cross-claim or
counterclaim) against any party alleging that the Package constitutes
direct or contributory patent infringement, then this Artistic License
to you shall terminate on the date that such litigation is filed.

Disclaimer of Warranty: THE PACKAGE IS PROVIDED BY THE COPYRIGHT HOLDER
AND CONTRIBUTORS "AS IS' AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES.
THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
PURPOSE, OR NON-INFRINGEMENT ARE DISCLAIMED TO THE EXTENT PERMITTED BY
YOUR LOCAL LAW. UNLESS REQUIRED BY LAW, NO COPYRIGHT HOLDER OR
CONTRIBUTOR WILL BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, OR
CONSEQUENTIAL DAMAGES ARISING IN ANY WAY OUT OF THE USE OF THE PACKAGE,
EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


=cut

1; # End of SelSweepRegion::FindGene
