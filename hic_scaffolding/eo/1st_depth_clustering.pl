#! /usr/bin/perl

my $stat_file = shift || die "<USAGE> perl $0 stat_file p1_value p2_value range1 range2!\n";
my $p1 = shift || die "<USAGE> perl $0 stat_file p1_value p2_value range1 range2!\n";
my $p2 = shift || die "<USAGE> perl $0 stat_file p1_value p2_value range1 range2!\n";
my $range1 = shift || die "<USAGE> perl $0 stat_file p1_value p2_value range1 range2 !\n";
my $range2 = shift || die "<USAGE> perl $0 stat_file p1_value p2_value range1 range2 !\n";

$p_diff=$p2-$p1;
$limit_1=$p1+$p_diff*$range1;
$limit_2=$p2-$p_diff*$range2;

print "Peak1: ".$p1."\t\t"."Peak2: ".$p2."\n";
print "cluster1: <".$limit_1." ($p1\+$p_diff\*$range1)\t\t";
print "cluster2: >".$limit_2." ($p2\-$p_diff\*$range2)\n\n";

open IN,"$stat_file";
open OUT,">1st.cluster";
while (<IN>){
	chomp;
	@array=split(/\t/,$_);
	$depth=$array[3];
	if ($depth>$limit_2){print OUT $array[0]."\tcluster2\n";}
	elsif ($depth<$limit_1){print OUT $array[0]."\tcluster1\n";}
	else {print OUT $array[0]."\tuncluster\n";}
}

