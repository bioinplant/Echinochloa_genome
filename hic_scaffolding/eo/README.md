# DipHiC pipeline used in scaffolding the genome of *E. oryzicola*

The initial assembly of *E. oryzicola* was produced in our previous study using Pacbio CLR sequencing (Contig N50 = 1.87Mb) ([Ye et al., 2020](https://www.cell.com/molecular-plant/fulltext/S1674-2052(20)30214-8)). Analysis based on collinear homologous genes between two subgenome revealed the divergence event between subgenomes at 4.6 mya and merge at 1.9 mya.

## Subgenome Phasing
Previous study revealed that diploid *Echinohloa haploclada* is close genetically to one subgenome from *E. oryzicola*. Therefore chromosome-level assembly of diploid *E. haploclada* was selected due to its close phylogenic relationship and high-quality genome assembly.

### Depth Clustering
 
Firstly, whole genome sequences of *E. haploclada* were split into 100-mer short reads using `get_Kmer_from_fa.pl`, and these reads were mapped to the *E. oryzicola* contigs using `BWA` or `bowtie2`. The mapping depth was counted using `samtools`, and average depth for each contig was calculated (). To determine the thresholds to split, a sliding-window average depth file should be calculated with proper window size. In general, two peaks would be observed representing two subgenomes. In this case, we calculated depth distribution in per contig (`contig_average_coverage_from_depth.pl`), 1 mb, 500 kb, 200 kb, 100 kb and 50 kb. Caution: this strategy would be not efficient for draft genome with low contig N50 (See details in [Wu et al., 2021]()).

Finally, two peaks when depth equaled 13.35 and 36.26 were chosen as average mapping depth for two subgenomes.

R1 and R2 were used to limit the depth distribution boundaries of two subgenomes. Contigs with average depth less than (P1+R1\*∆P) were assigned into cluster1 and contigs with depth greater than (P2-R2\*∆P) were cluster2, where ∆P=P2-P1. For E. oryzicola, R1 was set as 0.10 and R2 was 0.50.

`perl 1st_depth_clustering.pl Depth_stat P1 P2 R1 R1`


### Allelism Clustering

To construct allelic contig information (allelism), contigs were annotated by diploid relative CDS annotation using `gmap`. Counting the shared loci annotated, allelic contigs table was built. Five columns represented: contig A, loci annotated in contig A, contig B, loci annotated in contig B and shared loci annotated in both contig A and B. Shared loci number and proportion in contig annotated loci could be used to filter the allelic information.


	##allelism information format with 5 columns
	B06_28	89	A09_47	196	18
	A02_14	130	B05_58	52	16
	A02_14	130	B05_57	21	11
	A09_12	169	B04_13	91	31

In first-round clustering, contigs were clustered into three clusters(cluster1, cluster2 and uncluster). Allelic contigs normally would not belong to the same cluster.
 
* a, contig1 was assigned into cluster1, and its allelic contig was contig10, a member in cluster2, thus the clustering of contig1 was supported by allelism (pass). 
* b, contig2 was in cluster2, its allelic contigs were contig9 and contig67, belonging to cluster2 and cluster1. Considering the shared loci number, contig9 was more likely to be allelic. While contig2 and contig9 both were in cluster2, the clustering was not supported (doubt). 
* c, contig3 was in uncluster, and its allelic contig contig8 was in cluster1, thus contig3 would be clustered into cluster2 (pass).
* d, contig4 was in cluster1, while no allelic contigs were identified, thus it would be moved to uncluster (noActg).

In this way, clustering of allelic contigs would be more reliable than first-round results, in spite of the loss of genome coverage.

	perl 2nd_actg_correct.pl 1st_clustering allelic_table

### Linkage Clustering

Third-round clustering was to rescue these segments or contigs, based on linkage information from mate-pair reads, Hi-C data or other long-distance interaction signals. Via `BWA` or `bowtie2` and regular scripts implemented in other tools (e.g. `PreprocessSAMs.pl`), clean reads were mapped to the segments, and after removing adapters and duplication, the links information was obtained and linkages among segments were counted.

For each segment, links were categorized as links to cluster1 (L1), cluster2 (L2) and uncluster and then bias index α was calculated as L2/L1 for each segment. Also average α for cluster1 and cluster2 were calculated (α1 and α2). Similar to first-round clustering, unclustered segments would be clustered by their bias indexes. If the index was less than (α1+R\*∆α) (where ∆α=α2-α1), the category was cluster1; if greater than (α2-R\*∆α), the category was cluster2; if either not, this segment still remained unclustered. 

	perl 3rd_stat_linkage.pl stat_read cluster_info

After third-round clustering, most unclustered segments would be categorized. To further rescue these unclustered segments, more iterations of third-round clustering could be carried by re-calculating linkages and re-clustering.

	perl 4th_linkage_clustering_iteration.pl stat_read cluster_info Output


Multi-round clustering: `1st depth clustering` → `2nd allelism clustering` → `3rd linkage clustering` → `4th linkage iteration` → `5th allelism clustering` → `6th linkage clustering` → `7th linkage iteration` → `8th linkage iteration` ( in 1st-round, P1=13.35, P2=36.26, R1=0.10, R2=0.50; in 2nd-round, E. haploclada cds annotation was used to build allelic contig table with shared loci number > 5 and shared proportion > 20%; in 3rd-round, R was set as 0.10).

Finally 97.9% size of *E. oryzicola* contigs (945.5 Mb) were categorized as cluster1 (505.8 Mb) and cluster2 (419.8 Mb), and 19.8 Mb contigs were not distinguished.


## Chromosome building

Till now, most contigs of tetraploid have been phased into two subgenomes. Draft genome and Hi-C mapping data then were split to two sets of subgenomes. For each subgenome, contigs could be further grouped, ordered and orientated

	perl sep_ref_fasta_2_diploid.pl contig_assembly cluster_info
	perl sep_sam_2_diploid.pl SAM cluster_info

- Directional interaction intensity was calculated for each contig. Links between source contig and other target contigs were counted, then interaction intensity equaled link number divided by length of the target contig.

    	perl inter_contig_linkage_map_from_sam.pl SAM
	
- Low-intensity and discordant inter-contig linkages were removed. Linkages with links less than 10 and intensity less than 10 (10 links per Mb) between contigs were filtered out. 

		perl links_filtering.pl Links_stat

- Based on previous annotation by E. haploclada CDS, long contigs (at least 10 loci could be annotated and 40% of loci belong to one chromosome in *E. haploclada*) were pre-assigned into groups. For each source contig, linkages were ranked by interaction intensity, considering chromosome rearrangements, two pre-assigned groups were allowed to be linked by the source contig. 

> In the following example, linkage between Contig11 and Contig15 to Contig19 was kept, while linkage to Contig12 was removed.

		# example of directional interaction filtering
		#source		target		length	links	intensity		pre-assignment	
		Contig11		Contig15		0.05		69		1518.3		na
		Contig11		Contig63		0.62		749		1201.0		Group4
		Contig11		Contig32		0.36		406		1140.6		Group4
		Contig11		Contig93		0.05		53		1011.3		na
		Contig11		Contig94		2.26		829		367.6		Group4
		Contig11		Contig96		0.65		181		279.7		Group5
		Contig11		Contig45		0.13		34		261.0		na
		Contig11		Contig19		1.62		391		240.6		Group4
		Contig11		Contig12		0.62		62		100.0		Group8
		# na, represents this target contig is not pre-assigned.


- A directional interaction network was constructed among contigs. In the diagram (see [Supplementary Notes]() in `Wu et al., 2021`), when contig 1 was regarded as a source, most of its target contigs were pre-assigned in group “red”, here contig 1 was categorized as “red” . Meanwhile, when contig 1 was a target, most of its source contigs were “red”, then contig 1 was “red”. Only the categories when a contig was a souce and a target, were consistent, the category was reliable. Contig 4 was pre-assigned as “green”, while the category when 4 was either a source or target, was “red”, finally contig 4 was grouped in “red”, which did not determined by its initial pre-assignment. In this way, contigs were assigned to different groups. 

- It was worth noting that *E. haploclada* showed same chromosome number with subgenome in *E. oryzicola*. The diploid relative should be close genetically to subgenomes. If a diploid with discordant chromosome number was used, how to group has not been explored.

Contigs within each chromosome were ordered and orientated by module optimize of `AllHiC`. Finally, 497.7 Mb of cluster1 (AT, total size of 505.8 Mb) and 407.0 Mb of cluster2 (BT, total size of 419.8 Mb) were anchored to 9 and 9 chromosomes in subgenomes A and B, respectively, totally representing 95.7% of whole genome sequences.


**See details at Supplementary Notes of *Echinochloa* genomes paper (Wu et al., 2021).**

**For any questions or details, contact Dongya Wu at [wudongya@zju.edu.cn]() or Chu-Yu Ye at [yecy@zju.edu.cn]()**.



### Reference
Wu et al., Genomic Insights into the Evolution of *Echinochloa* Species as a Weed and an Orphan Crop (2021), unpublished.

