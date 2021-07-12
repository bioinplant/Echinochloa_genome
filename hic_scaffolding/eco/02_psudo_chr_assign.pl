#! /usr/bin/perl
#use warnings;

my $gano=shift || die "USAGE: PERL $0 SIM_GANNO! \n";

open IN,"$gano";
while(<IN>){
	chomp;
	($ctg, $S, $E, $dip_chr, $no)=split(/\t/,$_);
	if (not exists $hh{$ctg}){
		$hh{$ctg}=1;
		push @contig,$ctg;
	}
	%{$ctg};
	${$ctg}{$dip_chr}.=$no.",";
	$ctg_count=$ctg."_count";
	%{$ctg_count};
	${$ctg_count}{$dip_chr}+=1;
	$hash{$ctg}+=1;
}

foreach $i (@contig){
	$sum=$hash{$i};
	$tmp=$i."_count";
	$max=0;
	foreach $k (keys %{$tmp}){
		if (${$tmp}{$k}>$max){
			$max=${$tmp}{$k};
			$cc=$k;
		}
	}
	$rate1=$max/$sum;
	@tt=split(/,/,${$i}{$cc});
	$fir=$tt[0];
	$end=$tt[-2];
	$dir="+";
	$len=abs($fir-$end);
	if ($tt[0]>$tt[-2]){
		$fir=$tt[-2];
		$end=$tt[0];
		$dir="-";
	}
	$rr=$max/$len;
	print $i."\t".$sum."\t".$cc."\t".$max."\t".$fir."\t".$end."\t".$rr."\t".$dir."\n";
}
