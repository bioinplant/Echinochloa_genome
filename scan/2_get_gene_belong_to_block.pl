#!/usr/bin/perl

die("Usage: perl $0 <block file>\n") if @ARGV != 1;

###GFF FORMAT
###CHR START END NAME

$annotation="/public4/wudy/Echinochloa_genome/ec_v3.gff3_sim";

open FH_IN1, "$annotation";
open FH_IN2, "$ARGV[0]";
open FH_OUT, ">$ARGV[0].gene";

while(<FH_IN1>){
	chomp;
	@tmp = split/\t/, $_;
	seek(FH_IN2, 0, 0);
	while(<FH_IN2>){
		chomp;
		my @tmp_block = split/\t/;
		if($tmp[0] eq $tmp_block[0] && $tmp[1] > $tmp_block[1] && $tmp[2] < $tmp_block[2]){
			print FH_OUT $tmp[3]."\t".$tmp[0]."\t".$tmp[1]."\t".$tmp[2]."\n";
			
			last;
		}
		else{
			next;
		}
	}
}
