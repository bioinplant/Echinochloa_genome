#/usr/bin/perl 

use strict;

my $ref_genome = '/public3/wudy/246/Reference_V2/EO.fasta';

my ($Kmer_fasta,$sample_prefix);
if(@ARGV < 2){
	die "Usage: perl $0 <Kmer_fasta> <sample_prefix(YG02)>";	
}
else{
	($Kmer_fasta,$sample_prefix) = @ARGV;	
}

mkdir $sample_prefix;

my $genome_prefix = $1 if $ref_genome =~ /(.+)\.fasta/;

##### bowtie2 mapping ########

system(qq(bowtie2 -p 10 -x $genome_prefix -f -U $Kmer_fasta --rg-id $sample_prefix  --rg "SM:$sample_prefix" -S $sample_prefix/$sample_prefix.sam));
system(qq(samtools view -bS $sample_prefix/$sample_prefix.sam > $sample_prefix/$sample_prefix.bam));
system(qq(samtools sort $sample_prefix/$sample_prefix.bam  -o $sample_prefix/$sample_prefix.sorted.bam ));

my $sortedbam = $sample_prefix.'.sorted.bam';
system(qq(samtools index $sample_prefix/$sortedbam));
system(qq(samtools flagstat $sample_prefix/$sortedbam > $sample_prefix/$sample_prefix.flagstat));

my $statdepth = &statdepth($sample_prefix,$sortedbam);

open DEPTH, ">$sample_prefix/$sortedbam.depthstat";
print DEPTH "$statdepth\n";

&remove_file($sample_prefix,$sample_prefix);


sub statdepth {
  my ($dir,$sortbamfile) = @_;
  system(qq(samtools depth $dir/$sortbamfile > $dir/$sortbamfile.depth));	
  open IN, "$dir/$sortbamfile.depth" or die;
  my $depth = '';
  my $count = '';
  while(<IN>){
    chomp;
    $count++;
    $depth += $2 if /(.+)\t(.+)/;	
  }
  return($sortbamfile."\t".$count."\t".$depth);
  
}

sub remove_file {
  my ($sample_prefix,$prefixname) = @_;
  if(-f "$sample_prefix/$prefixname.sorted.bam"){
    system(qq(rm -rf $sample_prefix/$prefixname.sam));	
    system(qq(rm -rf $sample_prefix/$prefixname.bam));
  }	
}
