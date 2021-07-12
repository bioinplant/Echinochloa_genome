#!/usr/bin/perl -w

use strict;

my ($cds1,$prot1,$cds2,$prot2,$orthpair);

if(@ARGV < 5){
  die "Usage: perl $0 <cds1> <prot1> <cds2> <prot2> <orthpair>";	
}else{
  ($cds1,$prot1,$cds2,$prot2,$orthpair) = @ARGV;	
}

open CDS1, $cds1;
my $tit;
my (%cds1,%cds2,%prot1,%prot2);
while(<CDS1>){
	chomp;
	if(/>(\S+)/){
	  $tit = $1;	
	}else{
	  $cds1{$tit} .= $_;	
	}
}

open CDS2, $cds2;
while(<CDS2>){
	chomp;
	if(/>(\S+)/){
	  $tit = $1;	
	}else{
	  $cds2{$tit} .= $_;	
	}
}


open PROT1, $prot1;
while(<PROT1>){
	chomp;
	if(/>(\S+)/){
	  $tit = $1;	
	}else{
	  $prot1{$tit} .= $_;	
	}
}

open PROT2, $prot2;
while(<PROT2>){
	chomp;
	if(/>(\S+)/){
	  $tit = $1;	
	}else{
	  $prot2{$tit} .= $_;	
	}
}

print "seqs read already!!\n";

system(qq(mkdir $orthpair.tmpdir));

#######1 Create tmp paired protein and CDS file ########    

open ORTH, $orthpair;
while(<ORTH>){
  chomp;
  my ($gene1,$gene2) = ($1,$2) if /(.+?)\t(.+)/;
  my $pair = $gene1.'.vs.'.$gene2;
#  print "$pair\n";
#######1 Create tmp paired protein and CDS file ######## 
  open TMPPEP, ">./$orthpair.tmpdir/$pair.pep";
  open TMPCDS, ">./$orthpair.tmpdir/$pair.cds";
  print TMPPEP ">$gene1\n$prot1{$gene1}\n>$gene2\n$prot2{$gene2}\n";
  print TMPCDS ">$gene1\n$cds1{$gene1}\n>$gene2\n$cds2{$gene2}\n";

#######2 Align paired protein file ########     
  system(qq(mafft --auto --quiet ./$orthpair.tmpdir/$pair.pep > ./$orthpair.tmpdir/$pair.pep.mafft));

#######3 pal2nal aligned protein to CDS ##### 
  system(qq(perl /public3/wudy/246/246_script/kaks/pal2nal.pl ./$orthpair.tmpdir/$pair.pep.mafft ./$orthpair.tmpdir/$pair.cds -nogap -output fasta > ./$orthpair.tmpdir/$pair.pal2CDS));
    
#######4 aligned CDS --> axt format
    system(qq(perl /public3/wudy/246/246_script/kaks/onefasta2axt.pl ./$orthpair.tmpdir/$pair.pal2CDS));

}

opendir DIR, "./$orthpair.tmpdir";
open OUT, ">$orthpair.pal2CDS.axt";
foreach (readdir DIR){
  if(/(.+?)\.pal2CDS\.axt$/){
      open AXT, "./$orthpair.tmpdir/$_" or die;
      while(<AXT>){
        chomp;
        print OUT "$_\n";
      }
      print OUT "\n";	
  }
}

#######5 calculate KaKs ########
system(qq(/public/home/chenmh/apps/KaKs_Calculator2.0/KaKs_Calculator -i $orthpair.pal2CDS.axt -o $orthpair.combined_tits.pal2CDS.axt.kaks -m NG));

#system(qq(rm -rf ./$orthpair.paired_files/));
