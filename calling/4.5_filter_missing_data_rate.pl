#!/usr/bin/perl 

if(@ARGV < 2){
	die "Usage: perl $0 <table> <samples_num>";
}else{
  ($table,$samples) = @ARGV;	
}

open IN, $table or die;
open OUT, ">$table.miss1percent";

while(<IN>){
  chomp;
  $line++;
  @tmp = split/\t/;
  if($line == 1){
    print OUT "$_\n";	
  }else{
    @miss = grep /\-/,@tmp;
    if(scalar @miss/$samples < 0.1){ 
      print OUT "$_\n";	
    }	
  }	
}
