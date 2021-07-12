cat $1 | cut -f1,2,3,6,7 -d " " | sed "s/ /\t/g" > $1\_contig.map
