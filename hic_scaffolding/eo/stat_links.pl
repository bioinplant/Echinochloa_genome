#! /usr/bin/perl
#use warnings;

my $sam = shift || die "perl $0 sam_file ctg_length pre_assignment OUT_file!\n";
my $length=shift || die"perl $0 sam_file ctg_length pre_assignment OUT_file!\n";
my $pre_assign=shift || die "perl $0 sam_file ctg_length pre_assignment OUT_file!\n";
my $out = shift || die "perl $0 sam_file ctg_length pre_assignment OUT_file!\n" ;

open IN0,"$length";
while (<IN0>){
	chomp;
	my($ctg, $len)=split(/\t/,$_);
	$ctg_length{$ctg}=$len;
}

open IN00,"$pre_assign";
while (<IN00>){
	chomp;
	my ($ctg, $assign)=split(/\t/,$_);
	$pre_ass{$ctg}=$assign;
}

open IN,"$sam";
while (<IN>){
	chomp;
	@array=split(/\t/,$_);
	$chr1=$array[2];
	$chr2=$array[6];
	if ($chr2 eq "="){
#		$id=$chr1."__".$chr1;
#		$hash{$id}+=1;
	}
	else {
		$id1=$chr1."__".$chr2;
		$id2=$chr2."__".$chr1;
		$hash{$id1}+=1;
		$hash{$id2}+=1;
	}
}
close IN;

open OUT,">$out";
foreach $i (keys %hash){
	($c1, $c2)=split(/\_\_/,$i);
	$hash1{$c1}+=$hash{$i};
}

foreach $j (keys %hash){
	($c1, $c2)=split(/\_\_/,$j);
	$rate=$hash{$j}/$hash1{$c1};
	$r=sprintf "%.3f", $rate;
	$int=$hash{$j}/$ctg_length{$c2}*1000000;
	$intensity=sprintf "%.1f", $int;
	$len2=sprintf "%.2f",$ctg_length{$c2}/1000000;
	if (exists $pre_ass{$c1}){$c1_ass=$pre_ass{$c1};}
	else {$c1_ass="na";}
	if (exists $pre_ass{$c2}){$c2_ass=$pre_ass{$c2};}
	else {$c2_ass="na";}
	print OUT $c1."\t".$c2."\t".$len2."\t".$hash{$j}."\t".$intensity."\t".$r."\t".$c1_ass."\t".$c2_ass."\n";
}
