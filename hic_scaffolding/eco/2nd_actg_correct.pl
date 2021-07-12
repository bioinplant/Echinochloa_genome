#! /usr/bin/perl
#use warnings;

my $cluster = shift || die "USAGE: perl $0 1st_cluster actg_info! \n";
my $actg = shift || die "USAGE: perl $0 1st_cluster actg_info! \n";

open IN,"$cluster";
while (<IN>){
	chomp;
	($id, $depth,$ass)=split(/\t/,$_);
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
open OUT,">2nd.cluster";
while (<IN3>){
	chomp;
	$sm1=0; $sm2=0; $sn=0; $sp=0; $sq=0;$sm=0;
	($id,$depth, $assign)=split(/\t/,$_);
	if ( $assign ne "uncluster" && exists $hash2{$id}) {
		$actgs_id=$hash2{$id};
		@actgs=split(/ /, $actgs_id);
		foreach $i (@actgs){
			$temp1=$id."_".$i;
			if ($hash{$i} eq $assign) {$sm1+=$hash3{$temp1};}
			else {$sm2+=$hash3{$temp1};}
		}
		if ($sm1>$sm2){
			print OUT $id."\t$depth"."\t".$assign."\t"."uncluster\t"."doubt\n";
		}
		else {print OUT $id."\t$depth"."\t".$assign."\t".$assign."\t"."pass\n";}
	}
	elsif ($assign eq "uncluster" && exists $hash2{$id}){
		$actgs_id=$hash2{$id};
		@actgs=split(/ /, $actgs_id);
		foreach $i (@actgs){
			$temp2=$id."_".$i;
			if ($hash{$i} eq "cluster1"){$sn+=$hash3{$temp2};}
			if ($hash{$i} eq "cluster2"){$sp+=$hash3{$temp2};}
			if ($hash{$i} eq "cluster3"){$sm+=$hash3{$temp2};}
			if ($hash{$i} eq "uncluster"){$sq+=$hash3{$temp2};}
		}
		if ($sn < $sp && $sn < $sm  && $sn < $sq){print OUT $id."\t$depth"."\t".$assign."\t"."cluster1\t"."pass\n";}
		elsif ($sp < $sn && $sp < $sm  && $sp < $sq){print OUT $id."\t$depth"."\t".$assign."\t"."cluster2\t"."pass\n";}
		elsif ($sm < $sn && $sm < $sp  && $sm < $sq){print OUT $id."\t$depth"."\t".$assign."\t"."cluster3\t"."pass\n";}
		else {print OUT $id."\t$depth"."\t".$assign."\t"."uncluster\t"."uncluster\n";}
	}
	else {print OUT $id."\t"."$depth\t".$assign."\t"."uncluster\t"."noActg\n";}
}
