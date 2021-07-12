#!/usr/bin/perl

die("Usage: perl $0 <SAM file>") if @ARGV != 1;

open FH_IN, "$ARGV[0]";
open FH_OUT, ">$ARGV[0]_contig.map";

my(%chr, %infor);

while(<FH_IN>){
	chomp;
	my @tmp = split/\t/;
	if($tmp[2] ne '*' and !$chr{$tmp[0]}){
		$chr{$tmp[0]} = $tmp[2];
		$infor{$tmp[0]} = "$tmp[3]";
	}elsif($tmp[2] ne '*' and $chr{$tmp[0]} ne $tmp[2]){
		print FH_OUT "$tmp[0]\t$tmp[2]\t$tmp[3]\t$chr{$tmp[0]}\t$infor{$tmp[0]}\n";
	}
}
