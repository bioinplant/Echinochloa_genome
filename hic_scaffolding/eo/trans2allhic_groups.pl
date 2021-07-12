#! /usr/bin/perl

use warnings;

my $grouping=shift || die "USAGE: perl $0 grouping REcounts ! \n";
my $REcount=shift || die "USAGE: perl $0 grouping REcounts ! \n";

open IN,"$grouping";
while (<IN>){
	chomp;
	($ctg, $grp)=split(/\t/,$_);
	$hash{$grp}.=$ctg."\t";
}

open IN2,"$REcount";
while (<IN2>){
	chomp;
	($ctg0, $rec, $len)=split(/\t/,$_);
	$hash1{$ctg0}=$rec;
	$hash2{$ctg0}=$len;
}

@g=(sort keys %hash);
foreach $i (1..@g){
	open OUT,">group$i.txt";
	print OUT "#Contig\tREcounts\tLength\n";
	@array=split(/\t/,$hash{$g[$i-1]});
	foreach $j (@array){
		print OUT $j."\t".$hash1{$j}."\t".$hash2{$j}."\n";
	}
	close OUT;
}
