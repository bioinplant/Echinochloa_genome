use Data::Dumper;

die "Usage: perl $0 ref.gff3\n" if(!defined ($ARGV[0]));
my $refGFF = $ARGV[0];

open(IN, "grep 'gene' $refGFF |") or die"";
while(<IN>){
	chomp;
	my @data = split(/\s+/,$_);
	my $gene = $1 if(/Name=(\S+)/);
	$gene_name{$data[0]} .= $gene." ";
	$gene_num{$data[0]}+=1;
	}
close IN;

@array=keys(%gene_name);
$len=@array;

foreach $i (0..($len-1)) {
	$g1=$array[$i];
	@g_name1=split(/ /,$gene_name{$g1});
#	my %count1;
#	@g_name1_uniq = grep { ++$count1{ $_ } < 2; } @g_name1;
	$num1=@g_name1;
	$m=$i+1;
	$n=$len-1;
	foreach $j ($m..$n) {
		$g2=$array[$j];
		@g_name2=split(/ /,$gene_name{$g2});
#		my %count2;
#		@g_name2_uniq = grep { ++$count2{ $_ } < 2; } @g_name2;
		$num2=@g_name2;
		%hash_1 = map{$_=>1} @g_name1;
		%hash_2 = map{$_=>1} @g_name2;
		@common = grep {$hash_1{$_}} @g_name2;
		$com_len=@common;
		if ($num1<$num2){$min=$num1;}
		else {$min=$num2;}
		if ($com_len >= 5){
			if ($com_len/$min > 0.2){
				print $g1."\t".$gene_num{$g1}."\t".$g2."\t".$gene_num{$g2}."\t".$com_len."\n";
				print $g2."\t".$gene_num{$g2}."\t".$g1."\t".$gene_num{$g1}."\t".$com_len."\n";
			}
		}	
	}
}

