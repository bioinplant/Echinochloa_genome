#! /usr/bin/perl
#use warnings;

my $stat_read = shift || die "perl $0 PEread_info cluster_info! ";
###stat_read format: reads chr1 position1 chr2 position2
my $cluster = shift || die "perl $0 PEread_info cluster_info!";
###cluster format: contig  1st_cluster 2nd_cluster 2nd_note

open IN0,"$cluster";
while (<IN0>){
	chomp;
	($ctg, $clus1, $clus2, $clus2Note) = split(/\t/,$_);
	$hash{$ctg}=$clus2;
	$conf{$ctg}=$clus2Note;
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
			if ($conf{$chr2} eq "pass"){$hashc1{$chr1}+=1;}
			if ($conf{$chr1} eq "pass"){$hashc1{$chr2}+=1;}
		}
		if ($hash{$chr1} eq "cluster2" && $hash{$chr2} eq "cluster2"){
			if ($conf{$chr2} eq "pass"){$hashc2{$chr1}+=1;}
			if ($conf{$chr1} eq "pass"){$hashc2{$chr2}+=1;}
		}
		if ($hash{$chr1} eq "cluster1" && $hash{$chr2} eq "cluster2"){
			if ($conf{$chr2} eq "pass"){$hashc2{$chr1}+=1;}
			if ($conf{$chr1} eq "pass"){$hashc1{$chr2}+=1;}
		}
		if ($hash{$chr1} eq "cluster2" && $hash{$chr2} eq "cluster1"){
			if ($conf{$chr2} eq "pass"){$hashc1{$chr1}+=1;}
			if ($conf{$chr1} eq "pass"){$hashc2{$chr2}+=1;}
		}
		if ($hash{$chr1} eq "uncluster" && $hash{$chr2} eq "cluster1"){
			if ($conf{$chr2} eq "pass"){$hashc1{$chr1}+=1;}
		}
		if ($hash{$chr1} eq "uncluster" && $hash{$chr2} eq "cluster2"){
			if ($conf{$chr2} eq "pass"){$hashc2{$chr1}+=1;}
		}
		if ($hash{$chr1} eq "cluster1" && $hash{$chr2} eq "uncluster"){
			if ($conf{$chr1} eq "pass"){$hashc1{$chr2}+=1;}
		}
		if ($hash{$chr1} eq "cluster2" && $hash{$chr2} eq "uncluster"){
			if ($conf{$chr1} eq "pass"){$hashc2{$chr2}+=1;}
		}
	}
}
close IN;

open IN1,"$cluster";
open OUT1,">$cluster\.links";
open OUT2,">3rd.cluster";

while (<IN1>){
	chomp;
	($i, $c1st, $c2nd, $c2note)=split(/\t/,$_);
	if ($c2note eq "pass" && $c2nd eq "cluster1"){$c1L1+=$hashc1{$i};$c1L2+=$hashc2{$i};}
	if ($c2note eq "pass" && $c2nd eq "cluster2"){$c2L1+=$hashc1{$i};$c2L2+=$hashc2{$i};}
}
close IN1;

$c1rateL21 = $c1L2/$c1L1;
$c2rateL21 = $c2L2/$c2L1;
$d=$c2rateL21-$c1rateL21;
$th1=$c1rateL21+0.1*$d;
$th2=$c2rateL21-0.1*$d;

open IN2,"$cluster";
while (<IN2>){
	chomp;
	($i, $c1st, $c2nd, $c2note)=split(/\t/,$_);
	$rate=$hashc2{$i}/$hashc1{$i};
	if ($c2note eq "pass"){$c = $c2nd;}
	else {
		if ($rate < $th1){$c="cluster1";}
		elsif ($rate > $th2){$c = "cluster2";}
		else {$c = "uncluster";}
	}
	print OUT1 $i."\t".$c1st."\t".$c2nd."\t".$c2note."\t".$hashc1{$i}."\t".$hashc2{$i}."\t".$rate."\t".$c1rateL21."\t".$c2rateL21."\t".$c."\n";
	print OUT2 $i."\t".$c."\n";
}

close OUT1;
close OUT2;
