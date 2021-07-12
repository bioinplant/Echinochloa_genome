#! /usr/bin/perl

my $genelist = shift || die "UASGE:perl $0 GENELIST!\n##Genelist format:ID CHR START END\n";

my $pfam_base= "/public4/wudy/Echinochloa_genome/function_anno/ec_v3_pfam.anno";
## FORMAT:ID\tPFAM\tDESCRIPTION\tSTART\tEND\tEVALUE

my $rice_2K_base = "/public4/wudy/Echinochloa_genome/function_anno/ec_v3_RFG_e5i50.anno";
## FORMAT:ID\tLOCUS\tNAME\tEVALUE

my $swiss_base_base = "/public4/wudy/Echinochloa_genome/function_anno/ec_v3_sp.anno";
## FORMAT: ID\tITEM\tIDEN\tEVALUE

my $go_base = "/public4/wudy/Echinochloa_genome/function_anno/ec_v3_GO.anno";
## FORMAT: ID\tGO\tEVALUE

open IN,$genelist;
while (<IN>){
	chomp;
	my ($gene,$chr,$sta,$end)=split /\t/,$_;
	$hash{$gene}=1;
	$chro{$gene}=$chr;
	$pos_sta{$gene}=$sta;
	$pos_end{$gene}=$end;
}

open IN1,$rice_2K_base;
open OUT1,">$genelist\_RFG";
while(<IN1>){
	chomp;
	my ($id,$loc,$name,$eval)=split /\t/,$_;
	if (exists $hash{$id}){
		print OUT1 $id."\t".$chro{$id}."\t".$pos_sta{$id}."\t".$pos_end{$id}."\t".$loc."\t".$name."\t".$eval."\n";
	}
}
close IN1;
close OUT1;

open IN2,$pfam_base;
open OUT2,">$genelist\_pfam";
while (<IN2>){
	chomp;
	my ($id,$pfam, $descp,$s, $e, $evalue)=split /\t/,$_;
	if (exists $hash{$id}){
		print OUT2 $id."\t".$chro{$id}."\t".$pos_sta{$id}."\t".$pos_end{$id}."\t".$pfam."\t".$descp."\t".$evalue."\n";
	}
}
close IN2;
close OUT2;

open IN3,$swiss_base_base;
open OUT3,">$genelist\_sp";
while (<IN3>){
	chomp;
	my ($id, $sp, $iden, $evalue) = split /\t/,$_;
	if (exists $hash{$id}){
		print OUT3 $id."\t".$chro{$id}."\t".$pos_sta{$id}."\t".$pos_end{$id}."\t".$sp."\t".$evalue."\n";
	}
}
close IN3;
close OUT3;

open IN4,"$go_base";
open OUT4,">$genelist\_go";
while (<IN4>){
	chomp;
	my ($id, $go, $evalue) = split /\t/,$_;
	if (exists $hash{$id}){
		print OUT4 $id."\t".$chro{$id}."\t".$pos_sta{$id}."\t".$pos_end{$id}."\t".$go."\t".$evalue."\n";
	}
}
close IN4;
close OUT4;
