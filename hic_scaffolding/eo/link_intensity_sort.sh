cat $1 | awk '$4>10 && $5>10 {print $0}' | sort -k1,1 -k5,5nr > $1\_sorted
