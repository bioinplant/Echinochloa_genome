#! /usr/bin/perl
#use warnings;

my $cluster = shift || die "USAGE: perl $0 cluster actg_info! OUT_file!\n";
my $actg = shift || die "USAGE: perl $0 cluster actg_info! OUT_file!\n";
my $output = shift || die "USAGE: perl $0 cluster actg_info OUT_file!\n";

####cluster FORMAT : contig   actg_info\n

open IN,"$cluster";
while (<IN>){
	chomp;
	($id, $ass)=split(/\t/,$_);
	$hash{$id}=$ass;
}

open IN2, "$actg";
while (<IN2>){
	chomp;
	($id1, $num1, $id2, $num2, $com_num)=split(/\t/,$_);
	$hash2{$id1} .= $id2." ";
	$temp=$id1."_".$id2;
	$hash3{$temp}=$com_num;
}

open IN3,"$cluster";
open OUT,">$output";
while (<IN3>){
	chomp;
	$sm1=0; $sm2=0; $sn=0; $sp=0; $sq=0;
	($id, $assign)=split(/\t/,$_);
	if ( $assign ne "uncluster") {
		print OUT $id."\t"."$assign"."\n";
	}
	elsif ($assign eq "uncluster" && exists $hash2{$id}){
		$actgs_id=$hash2{$id};
		@actgs=split(/ /, $actgs_id);
		foreach $i (@actgs){
			$temp2=$id."_".$i;
			if ($hash{$i} eq "cluster1"){$sn+=$hash3{$temp2};}
			if ($hash{$i} eq "cluster2"){$sp+=$hash3{$temp2};}
			if ($hash{$i} eq "uncluster"){$sq+=$hash3{$temp2};}
		}
		if ($sn > $sp && $sn > $sq){print OUT $id."\t"."cluster2"."\n";}
		elsif ($sp > $sn && $sp > $sq){print OUT $id."\t"."cluster1"."\n";}
		else {print OUT $id."\t"."uncluster\t"."\n";}
	}
	else {print OUT $id."\t"."$assign\t"."\n";}
}
