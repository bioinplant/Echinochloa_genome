library("ape")

argv<-commandArgs(TRUE)

lis=file(argv[1],"r")

line=readLines(lis,n=1)

while(length(line) != 0){

	print(line)

	tree=read.tree(line)
	x=root(tree,outgroup="PI463783",resolve.root = TRUE)
	newfile=paste(line,"_root",sep="")
	print(newfile)
	write.tree(x,file=newfile)

	line=readLines(lis,n=1)
}
