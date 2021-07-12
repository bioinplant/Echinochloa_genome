#! /usr/bin/perl
#use warnings;

my $stat_read = shift || die "perl $0 Linkage_info cluster_info OUT_file!\n";
###stat_read format: reads chr1 position1 chr2 position2
my $cluster = shift || die "perl $0Linkage_info cluster_info OUT_file!\n";
###cluster format: contig  cluster
my $out = shift || die "perl $0 Linkage_info cluster_info OUT_file!\n" ;

open IN0,"$cluster";
while (<IN0>){
	chomp;
	($ctg, $clus) = split(/\t/,$_);
	$hash{$ctg}=$clus;
}
close IN0;

my %hashc1;
my $hashc2;

open IN,"$stat_read";
while (<IN>){
	chomp;
	($read, $chr1, $clus1, $chr2, $clus2)=split(/ /,$_);
	if ($chr1 ne $chr2){
		if ($hash{$chr1} eq "cluster1" && $hash{$chr2} eq "cluster1"){
			$hashc1{$chr1}+=1;
			$hashc1{$chr2}+=1;
		}
		if ($hash{$chr1} eq "cluster2" && $hash{$chr2} eq "cluster2"){
			$hashc2{$chr1}+=1;
			$hashc2{$chr2}+=1;
		}
		if ($hash{$chr1} eq "cluster1" && $hash{$chr2} eq "cluster2"){
			$hashc2{$chr1}+=1;
			$hashc1{$chr2}+=1;
		}
		if ($hash{$chr1} eq "cluster2" && $hash{$chr2} eq "cluster1"){
			$hashc1{$chr1}+=1;
			$hashc2{$chr2}+=1;
		}
		if ($hash{$chr1} eq "uncluster" && $hash{$chr2} eq "cluster1"){
			$hashc1{$chr1}+=1;
		}
		if ($hash{$chr1} eq "uncluster" && $hash{$chr2} eq "cluster2"){
			$hashc2{$chr1}+=1;
		}
		if ($hash{$chr1} eq "cluster1" && $hash{$chr2} eq "uncluster"){
			$hashc1{$chr2}+=1;
		}
		if ($hash{$chr1} eq "cluster2" && $hash{$chr2} eq "uncluster"){
			$hashc2{$chr2}+=1;
		}
	}
}
close IN;

open IN1,"$cluster";
open OUT1,">$out";
open OUT2,">$cluster\.links";
while (<IN1>){
	chomp;
	($i, $clus)=split(/\t/,$_);
	if ($clus eq "cluster1"){$c1L1+=$hashc1{$i};$c1L2+=$hashc2{$i};}
	if ($clus eq "cluster2"){$c2L1+=$hashc1{$i};$c2L2+=$hashc2{$i};}
}
close IN1;

$c1rateL21 = $c1L2/$c1L1;
$c2rateL21 = $c2L2/$c2L1;
$d=$c2rateL21-$c1rateL21;
$th1=$c1rateL21+0.2*$d;
$th2=$c2rateL21-0.2*$d;

open IN2,"$cluster";
while (<IN2>){
	chomp;
	($i, $clus)=split(/\t/,$_);
	$rate=$hashc2{$i}/$hashc1{$i};
	if ($clus ne "uncluster"){$c4 = $clus;}
	else {
		if ($rate < $th1){$c4 = "cluster1";}
		elsif ($rate > $th2){$c4 = "cluster2";}
		else {$c4 = "uncluster";}
	}
	print OUT1 $i."\t".$c4."\n";
	print OUT2 $i."\t".$hashc1{$i}."\t".$hashc2{$i}."\t".$rate."\t".$c1rateL21."\t".$c2rateL21."\t".$c4."\n";
}
close OUT1;
