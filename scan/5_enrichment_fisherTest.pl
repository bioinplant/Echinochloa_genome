#!/usr/bin/perl
## USAGE: perl $0 T_GENE_no S_GENE_no T_ANNO_COUNT S_ANNO_COUNT

#use warnings;

my $T_no= shift || die "USAGE: perl $0 T_GENE_no S_GENE_no T_ANNO_COUNT S_ANNO_COUNT! \n";
my $S_no= shift;
my $T_anno = shift;
my $S_anno = shift;

$A_rate=$S_no/$T_no;

open IN,$T_anno;
open OUT,">$count.fisher";
while (<IN>){
	chomp;
	my ($num, $item)=split(/\t/,$_);
	$hash{$item}=$num;
}
close IN;

#system(qq(rm -f temp));
#system(qq(rm -f raw.log));

open IN1,"$S_anno";
open OUT1,">temp";
while (<IN1>){
	chomp;
	($num,$item)=split(/\t/,$_);
	system(qq(Rscript /public4/wudy/Echinochloa_reseq/script/fisher_test.R $T_no $hash{$item} $S_no $num >> raw.log ));
	$rate=$num/$hash{$item};
	$type="_";
	if ($rate>$A_rate){
		$type="+";
	}
	print OUT1 $item."\t".$T_no."\t".$hash{$item}."\t".$S_no."\t".$num."\t".$type."\n";
}

close OUT1;
close IN1;

system(qq(cat raw.log | grep -v "," | cut -f2 -d" " > raw.pvalue));
system(qq(rm -f raw.log));
system(qq(paste temp raw.pvalue > $S_anno.fisher ));
system(qq(rm -f raw.pvalue));
system(qq(rm -f temp));
