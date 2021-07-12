#! /usr/bin/perl

#use warnings;

my $clustering = shift || die "USAGE: perl $0 links_clustering_file! \n";

my %hash1; 
my $hash2;
my $hash3;
my $hash4;

open IN,"$clustering";
while (<IN>){
	chomp;
	my ($ctg1, $ctg2, $pre_ctg2_ass, $ctg2_ass)=split(/\t/,$_);
	$hash1{$ctg1}=$ctg2_ass;
	$hash2{$ctg2}.=$ctg2_ass."\t";
}

foreach $i (keys %hash2){
	@array=split(/\t/,$hash2{$i});
	$count=@array;
	my $max;
	my $max_key;
	my %count;
	foreach $j (@array){
		$count{$j}+=1;
		if ($count{$j}>$max){
			$max=$count{$j};
			$max_key=$j;
		}
	}
	$per=sprintf "%.2f",$max/$count;
	$hash3{$i}=$max_key;
	$hash4{$i}=$per;
}

open OUT,">$clustering\.grouping";

foreach $m (sort keys %hash1){
	if (not exists $hash3{$m}){
		print $m."\t".$hash1{$m}."\t"."na"."\t"."na"."\t".$hash1{$m}."\n";
		print OUT $m."\t".$hash1{$m}."\n";
	}
	else {
		if ($hash1{$m} eq $hash3{$m}){
			print $m."\t".$hash1{$m}."\t".$hash3{$m}."\t".$hash4{$m}."\t".$hash1{$m}."\n";
			print OUT $m."\t".$hash1{$m}."\n";
		}
		elsif ($hash4{$m} > 0.6){
			print $m."\t".$hash1{$m}."\t".$hash3{$m}."\t".$hash4{$m}."\t".$hash3{$m}."**\n";
			print OUT $m."\t".$hash3{$m}."\n";
		}
		else {
			print $m."\t".$hash1{$m}."\t".$hash3{$m}."\t".$hash4{$m}."\t"."discortant"."*****\n";
		}
	}
}
