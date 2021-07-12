#! /usr/bin/perl
#use warnings;

my $sam = shift || die "perl $0 sam 2rd_cluster_info ACTG_INFO! ";
### FORMAT: SAM
my $cluster = shift;
### FORMAT: contig depth 1st_cluster 2nd_cluster 2nd_note. [flexible]
my $actg=shift;
### Filter out links between allelic contigs
### FORMAT: CTG1 LOC_NUM CTG2 LOC_NUM SHARED_LOC_NUM

%actg_info;
open IN00,"$actg";
while (<IN00>){
	chomp;
	($ctg1, $num1, $ctg2, $num2, $comn)=split(/\t/,$_);
	$ccc=$ctg1."-".$ctg2;
	$actg_info{$ccc}=1;
}
close IN00;

open IN0,"$cluster";
while (<IN0>){
	chomp;
	($ctg,$depth,$clus1, $clus2, $clus2Note) = split(/\t/,$_);
	$hash{$ctg}=$clus2;
	$conf{$ctg}=$clus2Note;
}
close IN0;

my %hashc1;
my %hashc2;
my %hashc3;

open IN,"$sam";
while (<IN>){
	chomp;
	($read, $a1,$chr1,$pos1,$a1,$a3,$chr2,)=split(/\t/,$_);
	$noactg=$chr1."-".$chr2;
	### stat links number between contigs and CLUSTERs and remove links between allelic contigs
	if ($chr2 ne "="  && not exists $actg_info{$noactg}){
		$clus1=$hash{$chr1};
		$clus2=$hash{$chr2};
		if ($hash{$chr1} eq "cluster1" && $hash{$chr2} eq "cluster1"){
			### only stat PASS contigs in STEP2
			if ($conf{$chr2} eq "pass"){$hashc1{$chr1}+=1;}
			if ($conf{$chr1} eq "pass"){$hashc1{$chr2}+=1;}
		}
		if ($hash{$chr1} eq "cluster2" && $hash{$chr2} eq "cluster2"){
			if ($conf{$chr2} eq "pass"){$hashc2{$chr1}+=1;}
			if ($conf{$chr1} eq "pass"){$hashc2{$chr2}+=1;}
		}
		if ($hash{$chr1} eq "cluster3" && $hash{$chr2} eq "cluster3"){
			if ($conf{$chr2} eq "pass"){$hashc3{$chr1}+=1;}
			if ($conf{$chr2} eq "pass"){$hashc3{$chr2}+=1;}
		}
		if ($hash{$chr1} eq "cluster1" && $hash{$chr2} eq "cluster2"){
			if ($conf{$chr2} eq "pass"){$hashc2{$chr1}+=1;}
			if ($conf{$chr1} eq "pass"){$hashc1{$chr2}+=1;}
		}
		if ($hash{$chr1} eq "cluster2" && $hash{$chr2} eq "cluster1"){
			if ($conf{$chr2} eq "pass"){$hashc1{$chr1}+=1;}
			if ($conf{$chr1} eq "pass"){$hashc2{$chr2}+=1;}
		}
		if ($hash{$chr1} eq "cluster1" && $hash{$chr2} eq "cluster3"){
                        if ($conf{$chr2} eq "pass"){$hashc3{$chr1}+=1;}
                        if ($conf{$chr1} eq "pass"){$hashc1{$chr2}+=1;}
                }
		if ($hash{$chr1} eq "cluster3" && $hash{$chr2} eq "cluster1"){
                        if ($conf{$chr2} eq "pass"){$hashc1{$chr1}+=1;}
                        if ($conf{$chr1} eq "pass"){$hashc3{$chr2}+=1;}
                }
		if ($hash{$chr1} eq "cluster2" && $hash{$chr2} eq "cluster3"){
                        if ($conf{$chr2} eq "pass"){$hashc3{$chr1}+=1;}
                        if ($conf{$chr1} eq "pass"){$hashc2{$chr2}+=1;}
                }
		if ($hash{$chr1} eq "cluster3" && $hash{$chr2} eq "cluster2"){
                        if ($conf{$chr2} eq "pass"){$hashc2{$chr1}+=1;}
                        if ($conf{$chr1} eq "pass"){$hashc3{$chr2}+=1;}
                }
		###stat UNCLUSTER contigs linkage
		if ($hash{$chr1} eq "uncluster" && $hash{$chr2} eq "cluster1"){
			if ($conf{$chr2} eq "pass"){$hashc1{$chr1}+=1;}
		}
		if ($hash{$chr1} eq "uncluster" && $hash{$chr2} eq "cluster2"){
			if ($conf{$chr2} eq "pass"){$hashc2{$chr1}+=1;}
		}
		if ($hash{$chr1} eq "uncluster" && $hash{$chr2} eq "cluster3"){
                        if ($conf{$chr2} eq "pass"){$hashc3{$chr1}+=1;}
                }
		if ($hash{$chr1} eq "cluster1" && $hash{$chr2} eq "uncluster"){
			if ($conf{$chr1} eq "pass"){$hashc1{$chr2}+=1;}
		}
		if ($hash{$chr1} eq "cluster2" && $hash{$chr2} eq "uncluster"){
			if ($conf{$chr1} eq "pass"){$hashc2{$chr2}+=1;}
		}
		if ($hash{$chr1} eq "cluster3" && $hash{$chr2} eq "uncluster"){
                        if ($conf{$chr1} eq "pass"){$hashc3{$chr2}+=1;}
                }
}
}
close IN;

open IN1,"$cluster";
open OUT1,">$cluster\.links";
#open OUT2,">3rd.cluster";


### stat general linkage among CLUSTERs
while (<IN1>){
	chomp;
	($i, $depth,$c1st, $c2nd, $c2note)=split(/\t/,$_);
	if ($c2note eq "pass" && $c2nd eq "cluster1"){$c1L1+=$hashc1{$i};$c1L2+=$hashc2{$i};$c1L3+=$hashc3{$i};}
	if ($c2note eq "pass" && $c2nd eq "cluster2"){$c2L1+=$hashc1{$i};$c2L2+=$hashc2{$i};$c2L3+=$hashc3{$i};}
	if ($c2note eq "pass" && $c2nd eq "cluster3"){$c3L1+=$hashc1{$i};$c3L2+=$hashc2{$i};$c3L3+=$hashc3{$i};}
}
close IN1;

$c1rateL21 = $c1L2/$c1L1;
$c1rateL31 = $c1L3/$c1L1;
$c2rateL12 = $c2L1/$c2L2;
$c2rateL32 = $c2L3/$c2L2;
$c3rateL13 = $c3L1/$c3L3;
$c3rateL23 = $c3L2/$c3L3;

open IN2,"$cluster";
while (<IN2>){
	chomp;
	($i, $depth, $c1st, $c2nd, $c2note)=split(/\t/,$_);
	print OUT1 $i."\t$depth"."\t".$c1st."\t".$c2nd."\t".$c2note."\t".$hashc1{$i}."\t".$hashc2{$i}."\t".$hashc3{$i}."\n";
#	print OUT2 $i."\t".$c."\n";
}

open OUTT,">Cluster.links";
print OUTT $c1L1."\t".$c1L2."\t".$c1L3."\t".$c1rateL21."\t".$c1rateL31."\n";
print OUTT $c2L2."\t".$c2L1."\t".$c2L3."\t".$c2rateL12."\t".$c2rateL32."\n";
print OUTT $c3L3."\t".$c3L1."\t".$c3L2."\t".$c3rateL13."\t".$c3rateL23."\n";

close OUT1;
#close OUT2;
