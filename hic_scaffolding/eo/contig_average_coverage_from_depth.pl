#! /usr/bin/perl

#use warnings;

my $length_file = shift || die "USAGE: perl $0 length_file depth_file! ";
my $depth=shift || die "USAGE: perl $0 length_file depth_file! ";

open IN,"$depth";
open OUT,">$depth.contig_stat";

open IN2,"$length_file";
while (<IN2>){
	chomp;
	($contig, $len)=split(/\t/,$_);
	$hash{$contig}=$len;
}

while (<IN>){
	chomp;
	($ctg, $pos, $depth)=split(/\t/,$_);
	$hash2{$ctg}+=$depth;
}

foreach $i (sort keys %hash2){
	$ratio=$hash2{$i}/$hash{$i};
	print OUT $i."\t".$hash2{$i}."\t".$hash{$i}."\t".$ratio."\n";
}

