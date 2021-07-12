#! /usr/bin/perl

#use warnings;

my $file = shift || die "USAGE: perl $0 merged_nodups.txt cluster_info! \n";
my $cluster = shift || die "USAGE: perl $0 merged_nodups.txt cluster_info! \n";

open IN, "$cluster";
while (<IN>){
	chomp;
	($ctg, $clus)=split(/\t/,$_);
	$hash{$ctg}=$clus;
}
close IN;

open IN2,"$file";
open OUT1,">cluster1_nodups.txt";
open OUT2,">cluster2_nodups.txt";
while (<IN2>){
	chomp;
	$seq = $_;
	@array = split(/ /,$seq);
#	print $array[1]."\t".$array[5]."\n";
	if ($hash{$array[1]} eq "cluster1" && $hash{$array[5]} eq "cluster1"){
		print OUT1 $seq."\n";
	}
	if ($hash{$array[1]} eq "cluster2" && $hash{$array[5]} eq "cluster2"){
		print OUT2 $seq."\n";
	}
}
close IN2;
close OUT1;
close OUT2;
