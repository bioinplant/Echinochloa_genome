#! /usr/bin/perl
use warnings;

my $fasta=shift || die "USAGE: perl $0 Fasta RE(GATC..)! \n";
my $RE=shift || die "USAGE: perl $0 Fasta RE(GATC..)! \n";

open IN,"$fasta";
open OUT,">$fasta\_$RE.counts";
print OUT "#Contig\tRECounts\tLength\n";

while (<IN>){
	chomp;
	if (/^>/){
		s/\>//;
		my $id=$_;
		print OUT $id."\t";
	}
	else {
		$seq=$_;
		my $len=length($seq);
		my $count = $seq =~ s/$RE//g;
		my $recount=$count+1;
		print OUT $recount."\t".$len."\n";
	}

}
