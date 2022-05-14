# DipHiC pipeline used in scaffolding the **hexaploid** genome of *E. colona*

*E. colona* is hexaploid with three subgenomes. Due to high sequence similarities among subgenomes, regular methods for Hi-C assisted scaffolding did not work well. Here we used DipHiC to scaffold contigs to chromosome with Hi-C data by two steps (`Subgenome Phasing` and `Chromosome Building`). The main workflows of DipHiC applied to *E. colona*, *E. oryzicola* and *E. crus-galli* are similar, here we mainly described the species-specific analysis in *E. colona* (for detailes of shared steps, please see in the scaffolding of *E. oryzicola*).

For example, the phasing processes of *E. colona*, *E. oryzicola* and *E. crus-galli* were different, because *E. colona* was hexaploid compared to tetraploid of *E. oryzicola* and the ancestral parental genomes could be used in phasing for *E. crus-galli*,while none for *E. colona*. In addition, the draft assembly of *E. crus-galli* (by Pacbio CLR) was fragmented while the contig N50 of *E. colona* was as long as the level of sub-chromosome (by  Pacbio CCS), which determined different steps to phase subgenomes in the two hexaploid species.

## Subgenome Phasing

![](https://github.com/bioinplant/Echinochloa_genome/blob/main/hic_scaffolding/eco/eco_fig/2.png)

>**Workflow of subgenome phasing** 
- 1, mapping and filtering as regular Hi-C data processing. 
- 2, allele info building based on contig allelism. 
- 3, splitting diploid genome into K-mer and mapping to polyploid draft assembly. 
- 4, counting the links or interactions among contigs. 
- 5, depth distribution. 
- 6, first round of clustering based on depth. 
- 7, second clustering based on allelic contig information. 
- 8, third round clustering based on interactions or linkages. 
- 9, more rounds of clustering based on linkages.

### Mapping by a diploid genome
A diploid assembly was used to build allelic contig information for hexaploid assembly and was mapped to *E. colona* contigs by splitting into 100-mers.

	perl 0_get_Kmer_from_fa.pl fasta K-mer_length

Mapping depth was calculated in windows of 1 Mb, 100 kb and10 kb by using `Bowtie2` and `samtools`. If more than one peak could be clearly observed, this diploid assembly has the potential to distinguish subgenomes, which represent different genetic distances from diploid to each subgenome. 

In this case, when 100-mer split from diploid *E. haploclada* were mapped to hexaploid *E. colona* contigs, three peaks were observed in mapping depth distribution, which meant *E. haploclada* could provide useful information to subgenome phasing.


![](https://github.com/bioinplant/Echinochloa_genome/blob/main/hic_scaffolding/eco/eco_fig/3.png)

>Mapping depth distribution when 100-mer split from diploid *E. haploclada* genome were mapped to *E. colona* contigs. The depth was calculated per 1 Mb (a), 100 Kb (b) and 10 Kb (c) along *E. colona* contigs. Three peaks were observed clearly in (a), due to hexaploidy of *E. colona*.


### Allelic contig (Actg) information construction
Subgenome synteny is informative in phasing subgenomes, in spite of possible homeologous exchanges. The second step is to obtain allelic contig information. Contigs were annotated by `gmap` with *E. haploclada* CDS sequences. Syntenic relationships among contigs were determined by counting shared gene number (e.g. greater than 50).

![](https://github.com/bioinplant/Echinochloa_genome/blob/main/hic_scaffolding/eco/eco_fig/4.png)

>Allelic contig information construction in hexaploid. (a) Mutually exclusive relationship inferred from large synteny. (b) Two contigs which were mutually exclusive with two exclusive contigs, were from a shared subgenome. (c) If one contig was exclusive with another contig, then it was exclusive with contigs from the subgenome another contig was from.

Firstly we got pairwise relationship of contigs (See figure at Supplementary Note in the paper). Syntenic contigs are mutually exclusive as illustrated in (a) (black lines with double arrows. e.g. contig1 to contig 2, contig6 to contig7) because they are not likely from the same subgenome. Fig. S7 shows the direct exclusive relationship among contigs based on synteny. Based on direct mutually exclusive relationships, indirect networks could be further expanded. Due to three subgenomes in the assembly, if contig1, contig2 and contig3 were mutually exclusive, we could infer that they belonged to three subgenomes, respectively. Here contig5 was exclusive with contig1 and contig2, it was reasonable to determine that contig3 and contig5 were from a shared subgenome ( illustrated as red lines in Figure S6b). Finally, contig4 and contig5 were mutually exclusive, because contig3 and contig4 were inter-subgenome and conig3 and contig5 were within one subgenome.

### Three rounds of clustering
According to the depth when 100-mers were mapped to the draft contigs, contigs were assigned into cluster1, cluster2, cluster3 and unknown cluster (uncluster). Based on the allelic contig information, the clustering was corrected and renamed. 

- For contig ptg000001l, in the first round it was categorized as uncluster, while its allelic contig information supported that it belonged to cluster3, thus this contig was assigned in cluster3. 

- For contig ptg000002l, the first clustering was in cluster1 and the allelism also supported the assignment, thus this contig was in cluster1 after two rounds clustering.

- For contig ptg00021l, although its first clustering was in cluster1, no allelic information further supported this clustering, and thus this contig was re-assigned in uncluster. 

![](https://github.com/bioinplant/Echinochloa_genome/blob/main/hic_scaffolding/eco/eco_fig/5.png)
>Examples illustrating three rounds of clustering in E. colona subgenome phasing.


The third round clustering was based on inter-contig interactions or linkages by Hi-C data or long-insert mate-paired reads. We counted the interactions among contigs, and according to the clustering in round two, calculated the interactions to three clusters or subgenomes of each contig and corrected the clustering based on interaction bias (column 6-8 in Figure). 

- For contig ptg000001l, this contig showed significantly more interactions to cluster3 and its clustering in 2-round was cluster3, thus we finally confirmed clustering3 as the assignment of this contig. For contig ptg000013l, no interaction bias was found to three clusters, thus finally clustering of this contig was not resolved. 

Finally, contigs were phased into three clusters or subgenomes.


## Chromosome Building

The same pipeline as that was implemented for *E. oryzicola* chromosome building.


 
 

**See details at Supplementary Notes of *Echinochloa* genomes paper (Wu et al., 2021).**

**For any questions or details, contact Dongya Wu at [wudongya@zju.edu.cn]() or Chu-Yu Ye at [yecy@zju.edu.cn]()**.



### Reference
Wu, D., Shen, E., Jiang, B. et al. Genomic insights into the evolution of Echinochloa species as weed and orphan crop. Nat Commun 13, 689 (2022). https://doi.org/10.1038/s41467-022-28359-9.

