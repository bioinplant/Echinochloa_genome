#! /usr/bin/perl

my $list=shift || die "USAGE: perl $0 LIST.\n";

open IN,"$list";

open OUT1,">$list.nex";
print OUT1 "#NEXUS\nbegin trees;\n";

$i=1;

while (<IN>){
	chomp;
	$sam=$_;
	
	open IN1,"$sam.nwk";
	print OUT1 "\ttree tree_${i} = [&R]\t";
	while (<IN1>){
		chomp;
		print OUT1 $_."\n";
	}
	close IN1;
	$i+=1;
}
print OUT1 "end;\n";
close IN;
