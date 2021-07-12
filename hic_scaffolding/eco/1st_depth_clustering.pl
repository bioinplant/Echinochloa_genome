#! /usr/bin/perl

my $stat_file = shift || die "<USAGE> perl $0 stat_file p1_value p2_value range1 range2!\n";
my $p1 = shift || die "<USAGE> perl $0 stat_file p1_value p2_value range1 range2!\n";
my $p2 = shift || die "<USAGE> perl $0 stat_file p1_value p2_value range1 range2!\n";
my $p3 = shift;
my $range1 = shift || die "<USAGE> perl $0 stat_file p1_value p2_value range1 range2 !\n";
my $range2 = shift || die "<USAGE> perl $0 stat_file p1_value p2_value range1 range2 !\n";

$p_diff1=$p2-$p1;
$limit1_1=$p1+$p_diff1*$range1;
$limit1_2=$p2-$p_diff1*$range2;

$p_diff2=$p3-$p2;
$limit2_1=$p2+$p_diff2*$range1;
$limit2_2=$p3-$p_diff2*$range2;

print "Peak1: ".$p1."\t\t"."Peak2: ".$p2."\t"."Peak3: ".$p3."\n";
print "cluster1: <".$limit1_1."\t\t";
print "cluster2: >".$limit1_2." <$limit2_1\n\n";
print "cluster3: >".$limit2_2."\n";

open IN,"$stat_file";
open OUT,">1st.cluster";
while (<IN>){
	chomp;
	@array=split(/\t/,$_);
	$depth=sprintf("%.1f",$array[1]);
	if ($depth>=$limit2_2){print OUT $array[0]."\t$depth"."\tcluster3\n";}
	elsif ($depth<=$limit2_1 && $depth>=$limit1_2){print OUT $array[0]."\t$depth"."\tcluster2\n";}
	elsif ($depth<=$limit1_1){print OUT $array[0]."\t$depth"."\tcluster1\n";}
	else {print OUT $array[0]."\t$depth"."\tuncluster\n";}
}

