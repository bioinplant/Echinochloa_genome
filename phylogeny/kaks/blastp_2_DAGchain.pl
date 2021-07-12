#! /usr/bin/perl

#use warnings;

my $blastp=shift || die "USAGE: perl $0 blastp_best_hit_file query_prot_gff reference_prot_gff";
my $q_gff=shift || die "USAGE: perl $0 blastp_best_hit_file query_prot_gff reference_prot_gff";
my $r_gff=shift || die "USAGE: perl $0 blastp_best_hit_file query_prot_gff reference_prot_gff";

open OUT,">$blastp\.dag";

open IN1,"$q_gff";
while (<IN1>){
	chomp;
	($q_prot,$q_cds,$q_gene,$q_chr, $q_s, $q_e)=split(/\t/,$_);
	$qchr{$q_prot}=$q_chr;
	$qs{$q_prot}=$q_s;
	$qe{$q_prot}=$q_e;
}

open IN2,"$r_gff";
while (<IN2>){
        chomp;
        ($r_prot,$r_cds,$r_gene,$r_chr, $r_s, $r_e)=split(/\t/,$_);
        $rchr{$r_prot}=$r_chr;
        $rs{$r_prot}=$r_s;
        $re{$r_prot}=$r_e;
}

open IN,"$blastp";
while (<IN>){
	chomp;
	@blast=split(/\t/,$_);
	if ($qs{$blast[0]} eq $temp){
		next;}
	else{
	$temp=$qs{$blast[0]};
	print OUT $qchr{$blast[0]}."\t".$blast[0]."\t".$qs{$blast[0]}."\t".$qe{$blast[0]}."\t".$rchr{$blast[1]}."\t".$blast[1]."\t".$rs{$blast[1]}."\t".$re{$blast[1]}."\t".$blast[10]."\n";}
}

