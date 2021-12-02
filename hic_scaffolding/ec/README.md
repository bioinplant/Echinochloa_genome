# DipHiC pipeline used in scaffolding the genome of *E. crus-galli*
The initial assembly of *E. crus-galli* was produced in our previous study using Pacbio CLR sequencing  ([Ye et al., 2020](https://www.cell.com/molecular-plant/fulltext/S1674-2052(20)30214-8)).

## Contig Correction
Diploid genome *E. haploclada* and two subgenomes from tetraploid *E. oryzicola* were used to phase subgenomes of hexaploid *E. crus-galli*, by mapping 100-mers to *E. crus-galli* contigs. Two peaks could be observed in depth distribution for each subgenome, respectively. 

![](https://github.com/bioinplant/Echinochloa_genome/blob/main/hic_scaffolding/ec/ec_fig/%E5%9B%BE%E7%89%8712.png)
>Depth distribution when each ancestral subgenome (EH, *E. haploclada*; AT and BT, *E. oryzicola*) 100-mers were mapped to *E. crus-galli* contigs, respectively

For each contig, average depths were calculated for three ancestral subgenomes as d(CH), d(AH), d(BH) and summed as Sum(d). When max{d(CH),d(AH),d(BH)}/Sum(d) < 0.7, this contig was regarded as discordant, which was mainly caused by misjoin of two or more long genomic segments from different subgenomes. Putative break-points were scanned by 5-kb sliding window depth. 

![](https://github.com/bioinplant/Echinochloa_genome/blob/main/hic_scaffolding/ec/ec_fig/%E5%9B%BE%E7%89%8713.png)
>Diagram illustrating how to distinguish HE from misjoin. (top) Red lines represented effective links when 20-kb mate-paired library reads were mapped to the flanking regions. (middle) colors represented different ancestral subgenomes. (bottom) Hi-C interaction heat-map within this contig.

Considering the presence of homologous exchange (HE), Hi-C and 20-kb mate-paired reads were mapped to contigs and links were counted within flanking regions (here 40 kb leftward to 25 kb rightward) of putative break-points. Break-points with at least 50 links for 20 kb mate-paired library or 5 links for Hi-C library were considered as HE and the other break-points were junctions of misjoins and contigs were split there.

![](https://github.com/bioinplant/Echinochloa_genome/blob/main/hic_scaffolding/ec/ec_fig/%E5%9B%BE%E7%89%8714.png)
>Examples of contigs with misjoin or HE

## Subgenome Phasing

After contig correction, 100-mers from three ancestral subgenomes were mapped to modified contigs. Categories of contigs were determined by the average depths of three ancestral subgenome only when the maximum depth proportion was greater than 0.7. After this, contigs were assigned as AH, BH, CH and UC(un-clustered). To cluster UC, HiC links between contigs were calculated. Due to high similarities among three subgenomes, many noisy links was observed. Although it was hard to distinguish subgenomes just based on single contigs, subgenomes could be divided overall from target subgenome proportions. 

For one contig, links to other contigs could be counted and we would know subgenome proportion of links to this contig. Average linkage proportions for three target subgenomes were featured as center points (P1, P2, P3) by calculating the median proportions of contigs (length >0.1 Mb and links number to three subgenomes >10) labeled as each subgenome, respectively. `Euclidean distance` was calculated between proportions for each contig to three center points, respectively. Only when the minimum distance shorter than 2/3 of the median of the three distances, this contig was assigned as the cluster of the closest center point.

![](https://github.com/bioinplant/Echinochloa_genome/blob/main/hic_scaffolding/ec/ec_fig/%E5%9B%BE%E7%89%8715.png)
>Subgenome proportion of links to each contig. If there was contig1, categorized in cluster AH, then links between contig1 and other contigs were assigned as three parts, links between contig1 and AH, BH and CH contigs. As expected, the proportion of links between contig1 and contigs categorized in AH would be the largest, as red dots showed.


![](https://github.com/bioinplant/Echinochloa_genome/blob/main/hic_scaffolding/ec/ec_fig/%E5%9B%BE%E7%89%8716.png)
>Distance to three cluster centers was used to assigned uncluster contigs and correct clustered contig category. For example ,contig2 was unclustered, we calculated the proportion of links to other contigs, and euclidean distance was used to measure the possibility of cluster assignment. If the distance was significantly shorter to AH center point than those to BH and CH center points, contig2 would be probably categorized in AH cluster.

## Chromosome Building

Following the pipeline in *E. oryzicola* subgenome contig ordering and orientation, long contigs were firstly pre-assigned and linkage intensities among contigs were calculated. `AllHiC` was used to order and orientate contigs within each subgenome.

![](https://github.com/bioinplant/Echinochloa_genome/blob/main/hic_scaffolding/ec/ec_fig/%E5%9B%BE%E7%89%8718.png)
>HiC interaction


 
 
 

**See details at Supplementary Notes of *Echinochloa* genomes paper (Wu et al., 2021).**

**For any questions or details, contact Dongya Wu at [wudongya@zju.edu.cn]() or Chu-Yu Ye at [yecy@zju.edu.cn]()**.



### Reference
Wu et al., Genomic Insights into the Evolution of *Echinochloa* Species as a Weed and an Orphan Crop (2021), unpublished.
