use Data::Dumper;

my $refGFF = $ARGV[0];
my $windows = $ARGV[1];

system(qq(cat $refGFF | grep -v "#" | grep "gene" > $refGFF\_temp));

open IN0, "$refGFF\_temp";
open OUT0,">$refGFF\_$windows";
while (<IN0>){
	chomp;
	@array = split(/\t/,$_);
	$chr=$array[0];
	$start=$array[3];
	open IN00,"$windows";
	while (<IN00>){
		chomp;
		($id, $chr2, $s, $e) = split(/\t/,$_);
		if ($chr eq $chr2 && $start >= $s && $start <= $e){
			print OUT0 $id."\t".$array[3]."\t".$array[4]."\t".$array[8]."\n";
			last;
		}
	}
	close IN00;
}

close IN0;
close OUT0;

system(qq(rm -f $refGFF\_temp));

open IN,"$refGFF\_$windows";
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
			if ($com_len/$min > 0.20){
				print $g1."\t".$gene_num{$g1}."\t".$g2."\t".$gene_num{$g2}."\t".$com_len."\n";
				print $g2."\t".$gene_num{$g2}."\t".$g1."\t".$gene_num{$g1}."\t".$com_len."\n";
			}
		}	
	}
}

