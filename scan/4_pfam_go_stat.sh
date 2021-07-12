cat  $1\_pfam | cut -f5 | sort | uniq -c | perl -npe "s/^ +//" | perl -npe "s/ /\t/" > $1\_pfam_sum
cat  $1\_go | cut -f5 | sort | uniq -c | perl -npe "s/^ +//" | perl -npe "s/ /\t/" > $1\_go_sum
