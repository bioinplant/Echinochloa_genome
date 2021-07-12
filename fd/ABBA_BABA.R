# This is a version of /data/kristyna/hedgehog/results_2018/2018-03-27b/ABBA_BABA_whole_genome_hedgehogs.R,
# which I think was originally borrowed from Simon Martin.
#
# =====================================================
#  USAGE
# =====================================================
#
# R [options] <abba_baba.R >outfile --args <freq_table> <chromosome_map> [<P1> <P2> <P3>] [<block_size>]
#
#    options: --save, --no-save or --vanilla. One required.
#
#    freq_table  Tab-separated values of derived allele frequencies in populations P1, P2 and P3
#                It must have a header with the population names. Populations P1, P2, and P3
#                are asumed to correspond to columns 3, 4, and 6, after 'scaffold' and 'position'.
#
#    chromosome_map  Tab-separated file with chromosome or contig lengths. Required.
#
#    P1 P2 P3    If the population names are given as additional arguments, the order in which
#                they are specified will define which columns in freq_table correspond to P1, P2
#                and P3, as long as they coincide with the names in the header of freq_table.
#
#    block_size  Size of chomosome blocks for jackknife analysis. Default: 1e6.
#
# =====================================================
#  READING ARGUMENTS
# =====================================================
#
# The reason to use the syntax described above and commandArgs(), below, is to be able to
# use the same script for any set of populations, so that we don't need to edit the script
# every time we change the table of frequencies or the names of populations.

arguments <- commandArgs(trailingOnly=TRUE)

if ((length(arguments) == 2) || (length(arguments) == 3)) {
   freq_table <- read.table(arguments[1], header=TRUE, as.is=TRUE)
   chromosome_map <- arguments[2]
   if (dim(freq_table)[2] >= 5) {
      P1 <- names(freq_table)[3]
      P2 <- names(freq_table)[4]
      P3 <- names(freq_table)[5]
   } else {
      print("Bad format of freq_table. Scaffold and position required.")
      q(save="no", status=1)
   }
   if (length(arguments) == 3) block_size <- as.numeric(arguments[3]) else block_size <- 1e6
} else {
   if ((length(arguments) == 5) || (length(arguments) == 6)){
      freq_table <- read.table(arguments[1], header=TRUE, as.is=TRUE)
      chromosome_map <- arguments[2]
      if (is.element(arguments[3], names(freq_table))) P1 <- arguments[3] else {paste(arguments[3], "not found in header."); q(save="no", status=1)}
      if (is.element(arguments[4], names(freq_table))) P2 <- arguments[4] else {paste(arguments[4], "not found in header."); q(save="no", status=1)}
      if (is.element(arguments[5], names(freq_table))) P3 <- arguments[5] else {paste(arguments[5], "not found in header."); q(save="no", status=1)}
      if (length(arguments) == 6) block_size <- as.numeric(arguments[6]) else block_size <- 1e6
   } else {
      print("There should be either 2, 3, 5 or 6 arguments after --args")
      q(save="no", status=1)
   }
}

# =====================================================
#  FUNCTIONS
# =====================================================

abba <- function(p1, p2, p3) (1 - p1) * p2 * p3

baba <- function(p1, p2, p3) p1 * (1 - p2) * p3

D.stat <- function(dataframe) (sum(dataframe$ABBA) - sum(dataframe$BABA)) / (sum(dataframe$ABBA) + sum(dataframe$BABA))

get_genome_blocks <- function(block_size, chrom_lengths) {
   block_starts <- sapply(chrom_lengths, function(l) seq(1, l, block_size))
   data.frame(start = unlist(block_starts),
              end = unlist(block_starts) + block_size - 1,
              chrom = rep(names(block_starts), sapply(block_starts, length)))
}

get_genome_jackknife_indices <- function(chromosome, position, block_info){
   lapply(1:nrow(block_info), function(x) !(chromosome == block_info$chrom[x] &
                                            position >= block_info$start[x] &
                                            position <= block_info$end[x]))
}


get_jackknife_sd <- function(FUN, input_dataframe, jackknife_indices){
   n_blocks <- length(jackknife_indices)
   overall_mean <- FUN(input_dataframe)
   sd(sapply(1:n_blocks, function(i) overall_mean*n_blocks - FUN(input_dataframe[jackknife_indices[[i]],])*(n_blocks-1)))
}

# =====================================================
#  MAIN
# =====================================================

ABBA <- abba(freq_table[,P1], freq_table[,P2], freq_table[,P3])
BABA <- baba(freq_table[,P1], freq_table[,P2], freq_table[,P3])
ABBA_BABA_df <- as.data.frame(cbind(ABBA,BABA))
D <- D.stat(ABBA_BABA_df)

chrom_table <- read.table(chromosome_map)
chrom_lengths <- chrom_table[,2]
names(chrom_lengths) <- chrom_table[,1]

blocks <- get_genome_blocks(block_size=block_size, chrom_lengths=chrom_lengths)
n_blocks = nrow(blocks)
 
indices <- get_genome_jackknife_indices(chromosome=freq_table$scaffold,
                                 position=freq_table$position,
                                 block_info=blocks) 
 
D_sd <- get_jackknife_sd(FUN=D.stat, input_dataframe=as.data.frame(cbind(ABBA,BABA)),
                          jackknife_indices=indices)

D_err <- D_sd/sqrt(n_blocks)

D_Z <- D / D_err

D_p <- 2*pnorm(-abs(D_Z))

write.table(list(P1=P1, P2=P2, P3=P3, D=D, D_err=D_err, D_p=D_p, N=length(freq_table[,1])), append=TRUE, col.names=FALSE, row.names=FALSE, quote=FALSE, sep="\t")

rm(freq_table, chrom_table, chrom_lengths, blocks)
