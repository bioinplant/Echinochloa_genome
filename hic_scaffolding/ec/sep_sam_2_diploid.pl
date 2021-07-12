#! /usr/bin/perl

#use warnings;

my $file = shift || die "USAGE: perl $0 merged.sam cluster_info! \n";
my $cluster = shift || die "USAGE: perl $0 merged.sam cluster_info! \n";

open IN, "$cluster";
while (<IN>){
	chomp;
	($ctg, $clus)=split(/\t/,$_);
	$hash{$ctg}=$clus;
}
close IN;

open IN2,"$file";
open OUT1,">eh.sam";
open OUT2,">c1.sam";
open OUT3,">c2.sam";

while (<IN2>){
	chomp;
	$seq = $_;
	@array = split(/\t/,$seq);
	if ($hash{$array[2]} eq "eh" && $array[6] eq "="){
		print OUT1 $seq."\n";
	}
	if ($hash{$array[2]} eq "eh" && $hash{$array[6]} eq "eh"){
		print OUT1 $seq."\n";
	}
	if ($hash{$array[2]} eq "c1" && $array[6] eq "="){
		print OUT2 $seq."\n";
	}
	if ($hash{$array[2]} eq "c1" && $hash{$array[6]} eq "c1"){
		print OUT2 $seq."\n";
	}
	if ($hash{$array[2]} eq "c2" && $array[6] eq "="){
		print OUT3 $seq."\n";
	}
	if ($hash{$array[2]} eq "c2" && $hash{$array[6]} eq "c2"){
		print OUT3 $seq."\n";
	}
}

close IN2;
close OUT1;
close OUT2;
close OUT3;
