#!/usr/bin/perl

die("Usage: perl $0 <fasta file> <Kmer_length>\n") if @ARGV != 2;

open IN, "<$ARGV[0]";
open OUT, ">$ARGV[0]_$ARGV[1].kmer";

while(<IN>){
	chomp;
	if(/^>/){
		s/^>//;
		$seq_num = $_;
		while(<IN>){
			chomp;
			$seq = $_;
			$num = length($seq)-100;
			foreach $i (0..$num){
				print OUT ">".$seq_num."_".$i."\n";
				print OUT substr($seq,$i,$ARGV[1])."\n";
			}
		last;
		}
	}
}
