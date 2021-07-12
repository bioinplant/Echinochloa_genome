#R_fisher.test(2*2)
# USAGE: Rscript $0 Arg1 Arg2 Arg3 Arg4 

args<-commandArgs(T);

args1<-as.numeric(args[1]);
args2<-as.numeric(args[2]);
args3<-as.numeric(args[3]);
args4<-as.numeric(args[4]);
data<-matrix(c(args1,args2,args3,args4),nr=2)
data;
result<-fisher.test(data);
pvalue<-result$p.value;
pvalue;
#data;
