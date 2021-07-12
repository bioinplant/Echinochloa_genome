#! /usr/bin/perl

#use warnings;

my $depth=shift || die "perl $0 DepthFile";

open IN,"$depth";
open OUT,">$depth\_stat";

open IN2,"/public3/bio_database/HiC/ec/EC_reference/split/EC_cv2.fasta_length";
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

