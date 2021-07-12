#! /usr/bin/perl

#use warnings;

my $links = shift || die "UASGE: perl $0 Links_stat! \n";

###
open IN,"$links";
%hash1;
%hash2;
while (<IN>){
	chomp;
	($ctg1, $ctg2, $ctg2_len, $linkN, $linkInt, $per, $ctg1_pas, $ctg2_pas)=split(/\t/,$_);
	###filtering links: link number, link intensity
	if ($linkN > 10 && $linkInt > 10){
		$hash1{$ctg1} .=$ctg2."\t";
		$hash2{$ctg1} .=$ctg2_pas."\t";
	}
}

###for each contig

foreach $i (keys %hash1){
	my @array1 = split(/\t/,$hash1{$i});
	my @array2 = split(/\t/,$hash2{$i});
	my $len=@array2;
	my %count;
	my %count2;
	my @array2_nna = grep { $_ ne "na" } @array2; ###remove na
#	print @array2_nna."*\n";
	###stat number for each pre-assign chromosome
	foreach $q (@array2_nna){
		$count{$q}+=1;
	}
	@uniq_nna = (keys %count); ### pre_assign chromosome number
#	print @uniq_nna."****\n";

	### uniq pre_assign chromosome number <=2, no filtering and output directly;
	if (@uniq_nna < 3){
		### most-likely pre_assign chromosme
		my $max=0;
		my $max_key="na";
		foreach $nn (@uniq_nna){
			if ($count{$nn}>$max){
				$max=$count{$nn};
				$max_key=$nn;
			}
		}
		### output links
		foreach $mm (0..(@array1-1)){
			print $i."\t".$array1[$mm]."\t".$array2[$mm]."\t".$max_key."\n";
		}
	}
	### uniq pre_assign chromosome number >2, only one discortant pre_assign chromosome was allowed;
	else {
		### get the boundary and filter out others;
		my $end;
		my $max2_key="na";
		my $max2=0;
		my @tmp;
		foreach $j (0..($len-1)){
			push @tmp,$array2[$j];
			my @temp2=grep { $_ ne "na" } @tmp;
			foreach $m (@temp2){
				$count2{$m}+=1;
			}
			my @uniq = keys %count2;
			if (@uniq > 2) {
				$end=$j;
				foreach $n (@uniq){
					if ($count2{$n}>$max2){
						$max2=$count2{$n};
						$max2_key=$n;
					}
				}
				last;
			}
		}
		### output links
		foreach $p (0..($end-1)){
			print $i."\t".$array1[$p]."\t".$array2[$p]."\t".$max2_key."\n";
		}
	}
}
