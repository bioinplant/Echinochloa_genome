#! /usr/bin/perl

#use warnings;

my $file = shift || die "USAGE: perl $0 contig.fasta cluster_info! \n";
my $cluster = shift || die "USAGE: perl $0 contig.fasta cluster_info! \n";

open IN, "$cluster";
while (<IN>){
	chomp;
	($ctg, $clus)=split(/\t/,$_);
	$hash{$ctg}=$clus;
}
close IN;

open IN2,"$file";
open OUT1,">cluster1.fasta";
open OUT2,">cluster2.fasta";
open OUT3,">uncluster.fasta";

while (<IN2>){
	chomp;
	if (/^\>/){
		$name=$_;
		@array=split(/\>/,$name);
		if ($hash{$array[1]} eq "cluster1"){
			print OUT1 $name."\n";
			$i=1;
		}
		if ($hash{$array[1]} eq "cluster2" ){
			print OUT2 $name."\n";
			$i=2;
		}
		if ($hash{$array[1]} eq "uncluster" ){
			print OUT3 $name."\n";
			$i=3;
		}
	}
	else {
		if ($i==1){print OUT1 $_."\n";}
		if ($i==2){print OUT2 $_."\n";}
		if ($i==3){print OUT3 $_."\n";}
	}
}
close IN2;
close OUT1;
close OUT2;
close OUT3;
