## Using `backbone` assembly from DBG2OLC

Using perl version `5.24.0` and specifying the necessary libraries
```
/usr/local/perl5.24/perl-5.24.0/perl -I /usr/local/perl5.24/perl-5.24.0/lib -I /home/caroline/programs/lib_perl5/List-MoreUtils-master/lib -I /home/caroline/programs/lib_perl5/p5-exporter-tiny-master/lib 1st_part_mellotrop.pl
```
Issues:
- Not a lot of SNP. Changing parameters for GATK, samtools 

GATK - default (was not clear to me what exactly was the default parameters on the website since depending on where you look, the default parameters are not the same)
```
INFO  07:05:08,702 MicroScheduler -   -> 279048 reads (60.50% of total) failing HCMappingQualityFilter
```
When used `-stand_call_conf 20 -stand_emit_conf 20 -mmq 10`, was ~30-40% failing `HCMappingQualityFilter`. 

Similar issues but with RNAseq [here](http://gatkforums.broadinstitute.org/gatk/discussion/4402/loss-of-reads-in-hcmappingqualityfilter)

- `1st_part_mellotrop.pl`: not a lot of sites and XY and ZW because of the threshold used for the error rate and match to multiple chromosomes. If we increase the threshold, nothing left.
- Need to see if it is because of undercall with GATK/samtools or a wrong identification of males/females? -> need to ask Ben if the sex was determined by surgery.
In paticular, need to check for 4175_girl and 4173_boy. The girl has much less data than the other individual (fq file much smaller) but not the boy. Confirmed the sex with BenF. 
- More sites that can be considered sex-linked if we considered threshold of 20% (compared with Hymenochirus and Pipa). 

Some of the most promissing sites.
```
  #CHROM	                            POS	      REF       3799    3800   3810     4169   4170    4171    4172    4173    4174    4175    4176    4177    4178     4179    4180    4181   4182    4183     4184    4185
                                                                 dad    mom     boy     girl   girl    boy      boy    boy     boy      girl    boy     girl    girl     boy     girl    boy   girl     girl    girl     girl
Heterozygous_sons_dad_XY supercontig_1	71824629	G	G/T	G/G	G/T	G/G	G/G	G/T	G/T	G/G	G/T	G/T	G/T	G/G	G/G	G/T	G/G	G/T	G/G	G/G	G/G	G/G
Heterozygous_sons_dad_XY supercontig_6	18685228	C	C/T	C/C	C/T	C/C	C/C	C/T	C/T	C/C	C/T	C/T	C/T	C/C	C/C	C/T	C/C	C/T	C/C	C/C	C/C	C/C
Heterozygous_sons_dad_XY supercontig_6	18685245	C	C/T	C/C	C/T	C/C	C/C	C/T	C/T	C/C	C/T	C/T	C/T	C/C	C/C	C/T	C/C	C/T	C/C	C/C	C/C	C/C
Heterozygous_sons_dad_XY supercontig_6	18685246	A	A/G	A/A	A/G	A/A	A/A	A/G	A/G	A/A	A/G	A/G	A/G	A/A	A/A	A/G	A/A	A/G	A/A	A/A	A/A	A/A
Heterozygous_sons_dad_XY supercontig_6	18685256	T	T/C	C/C	T/C	C/C	C/C	T/C	T/C	C/C	T/C	T/C	T/C	C/C	C/C	T/C	C/C	T/C	C/C	C/C	C/C	C/C
Heterozygous_sons_dad_XY supercontig_6	18685264	G	G/T	T/T	G/T	T/T	T/T	G/T	G/T	T/T	G/T	G/T	G/T	T/T	T/T	G/T	T/T	G/T	T/T	T/T	T/T	T/T
Heterozygous_sons_dad_XY supercontig_6	18685266	T	T/A	A/A	T/A	A/A	A/A	T/A	T/A	A/A	T/A	T/A	T/A	A/A	A/A	T/A	A/A	T/A	A/A	A/A	A/A	A/A
Heterozygous_sons_dad_XY supercontig_8	95841414	A	A/G	A/A	A/G	A/A	A/A	A/G	A/G	A/A	A/G	A/G	A/G	A/A	A/A	A/G	A/A	A/G	A/A	A/A	A/A	A/A
Heterozygous_sons_dad_XY supercontig_13	111628748	G	G/A	A/A	G/A	A/A	A/A	G/A	G/A	A/A	G/A	G/A	G/A	A/A	A/A	G/A	A/A	G/A	A/A	A/A	A/A	A/A
Heterozygous_sons_dad_XY supercontig_13	111628749	G	G/A	A/A	G/A	A/A	A/A	G/A	G/A	A/A	G/A	G/A	G/A	A/A	A/A	G/A	A/A	G/A	A/A	A/A	A/A	A/A
Heterozygous_sons_dad_XY supercontig_14	165601016	A	A/G	G/G	A/G	G/G	G/G	A/G	A/G	G/G	A/G	A/G	A/G	G/G	G/G	A/G	G/G	A/G	G/G	G/G	G/G	G/G

```
`Backbone_64488`(corresponds to the sites `18685228-18685266`) seems particularly interesting, let's blast it 1st.
```
awk -v seq="Backbone_64488" -v RS='>' '$1 == seq {print RS $0}' /4/caroline/Xmellotropicalis/GBS/samtools_genotypes/Sex_linked/Mellotrop_putative_sex_linked_polym1ratio0_HF.fa >/4/caroline/Xmellotropicalis/GBS/samtools_genotypes/Sex_linked/Mellotrop_putative_sex_linked_Backbone_64488.fa
```
```
blastn -evalue 1e-20 -query /4/caroline/Xmellotropicalis/GBS/samtools_genotypes/Sex_linked/Mellotrop_putative_sex_linked_Backbone_64488.fa -db /4/caroline/tropicalis_genome/Xtropicalis_v9_repeatMasked_HARD_MASK_blastable -out /4/caroline/Xmellotropicalis/GBS/samtools_genotypes/Sex_linked/Mellotrop_Backbone_64488_tropv9 -outfmt 6 -max_target_seqs 1
#Chr6
```
```
grep "95841414" /4/caroline/Xmellotropicalis/GBS/samtools_genotypes/Sex_linked/positions_HF.txt 
8	95841414	Backbone_95410	3014
grep "Backbone_95410" /4/caroline/Xmellotropicalis/GBS/samtools_genotypes/Sex_linked/Mellotrop_potential_sex_linked_MASKED_tropv9
#Chr8 but very small alignments

grep "111628748" /4/caroline/Xmellotropicalis/GBS/samtools_genotypes/Sex_linked/positions_HF.txt 
13	111628748	Backbone_162619	3388
grep "Backbone_162619" /4/caroline/Xmellotropicalis/GBS/samtools_genotypes/Sex_linked/Mellotrop_potential_sex_linked_MASKED_tropv9
#Chr01, alignments~100-200bp

grep "71824629" /4/caroline/Xmellotropicalis/GBS/samtools_genotypes/Sex_linked/positions_HF.txt 
1	71824629	Backbone_4464	19269
grep "Backbone_4464" /4/caroline/Xmellotropicalis/GBS/samtools_genotypes/Sex_linked/Mellotrop_potential_sex_linked_MASKED_tropv9
#Chr08 - some large alignement

grep "165601016" /4/caroline/Xmellotropicalis/GBS/samtools_genotypes/Sex_linked/positions_HF.txt 
14	165601016	Backbone_179970	7256
grep "Backbone_179970" /4/caroline/Xmellotropicalis/GBS/samtools_genotypes/Sex_linked/Mellotrop_potential_sex_linked_MASKED_tropv9
#	Chr03
```
```
#CHROM	POS	REF	3799_dad	3800_mom	3810_boy	4169_girl	4170_girl	4171_boy	4172_boy	4173_boy	4174_boy	4175_girl	4176_boy	4177_girl	4178_girl	4179_boy	4180_girl	4181_boy	4182_girl	4183_girl	4184_girl	4185_girl

Only_sons_XY supercontig_2	116058578	G	A/A	./.	A/A	./.	./.	A/A	A/A	./.	A/A	A/A	A/A	./.	./.	A/A	./.	A/A	./.	./.	./.	./.
Only_sons_XY supercontig_3	80956048	C	T/T	./.	T/T	./.	./.	T/T	T/T	./.	T/T	T/T	T/T	./.	./.	T/T	./.	T/T	./.	./.	./.	./.
Only_sons_XY supercontig_3	80956052	T	G/G	./.	G/G	./.	./.	G/G	G/G	./.	G/G	G/G	G/G	./.	./.	G/G	./.	G/G	./.	./.	./.	./.
Only_sons_XY supercontig_3	80956057	A	T/T	./.	T/T	./.	./.	T/T	T/T	./.	T/T	T/T	T/T	./.	./.	T/T	./.	T/T	./.	./.	./.	./.
Only_sons_XY supercontig_3	80956058	A	G/G	./.	G/G	./.	./.	G/G	G/G	./.	G/G	G/G	G/G	./.	./.	G/G	./.	G/G	./.	./.	./.	./.
Only_sons_XY supercontig_4	57177119	T	G/G	./.	G/G	./.	./.	G/G	G/G	./.	G/G	G/G	G/G	./.	./.	G/G	./.	G/G	./.	./.	./.	./.
Only_sons_XY supercontig_4	57177124	T	A/A	./.	A/A	./.	./.	A/A	A/A	./.	A/A	A/A	A/A	./.	./.	A/A	./.	A/A	./.	./.	./.	./.
Only_sons_XY supercontig_4	57177149	C	T/T	./.	T/T	./.	./.	T/T	T/T	./.	T/T	T/T	T/T	./.	./.	T/T	./.	T/T	./.	./.	./.	./.
Only_sons_XY supercontig_5	63387286	GG	GGTG/GGTG	./.	GGTG/GGTG	./.	./.	GGTG/GGTG	GGTG/GGTG	./.	GGTG/GGTG	GGTG/GGTG	GGTG/GGTG	./.	./.	GGTG/GGTG	./.	GGTG/GGTG	./.	./.	./.	./.
Only_sons_XY supercontig_5	63387338	GT	G/G	./.	G/G	./.	./.	G/G	G/G	./.	G/G	G/G	G/G	./.	./.	G/G	./.	G/G	./.	./.	./.	./.
Only_sons_XY supercontig_6	47875203	AT	A/A	./.	A/A	./.	./.	A/A	A/A	./.	A/A	A/A	A/A	./.	./.	A/A	./.	A/A	./.	./.	./.	./.
Only_sons_XY supercontig_7	37245480	C	CA/CA	./.	CA/CA	./.	./.	CA/CA	CA/CA	./.	CA/CA	CA/CA	CA/CA	./.	./.	CA/CA	./.	CA/CA	./.	./.	./.	./.
Only_sons_XY supercontig_8	42068642	C	T/T	./.	T/T	./.	./.	T/T	T/T	./.	T/T	T/T	T/T	./.	./.	T/T	./.	T/T	./.	./.	./.	./.
Only_sons_XY supercontig_8	42068680	T	C/C	./.	C/C	./.	./.	C/C	C/C	./.	C/C	C/C	C/C	./.	./.	C/C	./.	C/C	./.	./.	./.	./.
Only_sons_XY supercontig_8	42068683	C	A/A	./.	A/A	./.	./.	A/A	A/A	./.	A/A	A/A	A/A	./.	./.	A/A	./.	A/A	./.	./.	./.	./.
Only_sons_XY supercontig_8	42068684	C	T/T	./.	T/T	./.	./.	T/T	T/T	./.	T/T	T/T	T/T	./.	./.	T/T	./.	T/T	./.	./.	./.	./.
Only_sons_XY supercontig_8	42068696	C	T/T	./.	T/T	./.	./.	T/T	T/T	./.	T/T	T/T	T/T	./.	./.	T/T	./.	T/T	./.	./.	./.	./.
Only_sons_XY supercontig_8	42068703	G	A/A	./.	A/A	./.	./.	A/A	A/A	./.	A/A	A/A	A/A	./.	./.	A/A	./.	A/A	./.	./.	./.	./.
Only_sons_XY supercontig_8	42068738	G	A/A	./.	A/A	./.	./.	A/A	A/A	./.	A/A	A/A	A/A	./.	./.	A/A	./.	A/A	./.	./.	./.	./.
Only_sons_XY supercontig_9	26845977	CA	CAAA/CAAA	./.	CAAA/CAAA	./.	./.	CAAA/CAAA	CAAA/CAAA	./.	CAAA/CAAA	CAAA/CAAA	CAAA/CAAA	./.	./.	CAAA/CAAA	./.	CAAA/CAAA	./.	./.	./.	./.
Only_sons_XY supercontig_12	152338628	C	A/A	./.	A/A	./.	./.	A/A	A/A	./.	A/A	A/A	A/A	./.	./.	A/A	./.	A/A	./.	./.	./.	./.
Only_sons_XY supercontig_12	152338629	G	T/T	./.	T/T	./.	./.	T/T	T/T	./.	T/T	T/T	T/T	./.	./.	T/T	./.	T/T	./.	./.	./.	./.
Only_sons_XY supercontig_12	152338635	A	T/T	./.	T/T	./.	./.	T/T	T/T	./.	T/T	T/T	T/T	./.	./.	T/T	./.	T/T	./.	./.	./.	./.
Only_sons_XY supercontig_12	152338650	T	G/G	./.	G/G	./.	./.	G/G	G/G	./.	G/G	G/G	G/G	./.	./.	G/G	./.	G/G	./.	./.	./.	./.
Only_sons_XY supercontig_12	152338683	G	A/A	./.	A/A	./.	./.	A/A	A/A	./.	A/A	A/A	A/A	./.	./.	A/A	./.	A/A	./.	./.	./.	./.
Only_sons_XY supercontig_12	152338684	A	G/G	./.	G/G	./.	./.	G/G	G/G	./.	G/G	G/G	G/G	./.	./.	G/G	./.	G/G	./.	./.	./.	./.
Only_sons_XY supercontig_15	91084353	A	C/C	./.	C/C	./.	./.	C/C	C/C	./.	C/C	C/C	C/C	./.	./.	C/C	./.	C/C	./.	./.	./.	./.
Only_sons_XY supercontig_15	91084388	GTTT	GTTTT/GTTTT	./.	GTTTT/GTTTT	./.	./.	GTTTT/GTTTT	GTTTT/GTTTT	./.	GTTTT/GTTTT	GTTTT/GTTTT	GTTTT/GTTTT	./.	./.	GTTTT/GTTTT	./.	GTTTT/GTTTT	./.	./.	./.	./.
Only_sons_XY supercontig_15	91084421	G	A/A	./.	A/A	./.	./.	A/A	A/A	./.	A/A	A/A	A/A	./.	./.	A/A	./.	A/A	./.	./.	./.	./.
Only_sons_XY supercontig_15	142658261	A	C/C	./.	C/C	./.	./.	C/C	C/C	./.	C/C	C/C	C/C	./.	./.	C/C	./.	C/C	./.	./.	./.	./.
Only_sons_XY supercontig_15	142659233	A	C/C	./.	C/C	./.	./.	C/C	C/C	./.	C/C	C/C	C/C	./.	./.	C/C	./.	C/C	./.	./.	./.	./.
```
```
/usr/local/RepeatMasker/RepeatMasker -dir /4/caroline/Pipa_parva/Rad_seq/samtools_genotypes/Sex_linked/SOAP_chim_assembly/no_filtered/ -species "xenopus genus" -pa 4 -a /4/caroline/Xmellotropicalis/GBS/samtools_genotypes/Sex_linked/Mellotrop_putative_sex_linked_polym1ratio0_HF.fa
```
```
blastn -evalue 1e-20 -query /4/caroline/Xmellotropicalis/GBS/samtools_genotypes/Sex_linked/Mellotrop_putative_sex_linked_polym1ratio0_HF.fa.masked -db /4/caroline/tropicalis_genome/Xtropicalis_v9_repeatMasked_HARD_MASK_blastable -out /4/caroline/Xmellotropicalis/GBS/samtools_genotypes/Sex_linked/Mellotrop_potential_sex_linked_MASKED_tropv9 -outfmt 6 -max_target_seqs 1
```
```
42068642-42068738:Backbone_91904:Chr08
152338628-152338684:Backbone_151827:Chr01
80956048-80956058:Backbone_30066:Chr02
57177119-57177149:Backbone_41237:Chr08
91084353-91084421:Backbone_188583:Chr08
142658261-142659233:Backbone_191959:Chr02
26845977:Backbone_103905:Chr05
116058578:Backbone_19743:Chr05
63387286-63387338:Backbone_54377:Chr08
47875203:Backbone_66386:Chr06
37245480:Backbone_78609:Chr08

```
### Notes

**To do**:
Need to improve the part 1 to find the sex-linked sites. Because of the 20% errors allowed, a lot of sites showing up, when are manually checked are most likely not sex-linked. If increase the threshold, nothing show up. The best sites that actually look sex-linked are the ones mentioned before (Heterozygous_sons_dad_XY matching against trop 6)

**For discussion with BE on Nov. 22:**

- Should not use the DBG2OLC assembly yet (need to run the last step of correction). Inter-chromosomal chimerical errors?

- Should probably do it again using the Allpaths assembly to map the reads. + samtools

- Maybe easier to have 1st a better assembly than trying to include *X. mellotropicalis* in the same paper as *Hymenochirus* and *Pipa*.

- For now 2 chromosomes seem maybe interesting chr. 08 (XY) and chr. 07 (ZW)

**Other notes**

- Also run using the `.tab` produced by BE. Got similar results. 

## Using the assembly from Allpaths
### Why it can be better:

*Compared to DBG2OLC assembly:*

I am worried about the chimerical issues that our `DBG2OLC` assembly could have right now (in theory should be pretty low see computational methods of [Zimin et al. 2016](https://www.biorxiv.org/content/biorxiv/early/2016/07/26/066100.full.pdf)). And gap creating because of low quality of long reads. Using the `Allpaths` assembly should increase the confidence. The `Allpaths` assembly is more fragmented but in theory more accurate.

*Compared to directly mapping the reads onto X. tropicalis*

Considering we have a tetraploid, mapping the reads onto a diploid can caused various issues that should be reduced using the own assembly from the same species.

### Results
Ok so it is not better. Obtained both incomplete "XY" and "ZW" sex-inherited sites... Still the same individuals that show up different as the others from the same sex... Can be some sort of mix up, recombination on sex-chr. or autosomes...

BE expect chr. 07 to be the sex-chr. with a ZW system but right now I don't have more evidence for that than a potential sex-determination involving Chr. 08 and XY system... The other issue being the fact that I don't really trust the genotypes obtained with Samtools (even when I played with different flags with GATK, there was not enough SNP to be able to see any signal... so went with playing with Samtools...). 

## Other options
### Bewick's primers
At that point there are some stuff that I would try (need to see with BE):

- focusing on sites that are only present in 1 sex that might have more information, confirming the faint "signal"

- If it is actually a similar sex-determining system as *X. tropicalis* then maybe we should try amplyfing some regions that had SNPs displaying a sex inheritance pattern. in *X. tropicalis*. Problem if the region has a similar region on the other subgenome but can blast and see how many times it shows up using Allpaths or DBG2OLC genomes... If the sub-genomes are diverged enough we should be able to amplify specifically sites from 1 of the subgenome.

Most interesting region from [Bewick et al. 2013](https://academic.oup.com/gbe/article/5/6/1087/616594#supplementary-data) from the supplements (names of the primers): 

- sc7v7-10128301-f/sc7v7-10129920-r: highly polymorphic in females

- scaf2_149790591_f/scaf2_149791341_r: female specific indels

- scaf2_149954039_f/scaf2_149954800_r: 1 female specific SNP

- scaf2_150071042_f/scaf2_150071793_r: 1 female specific SNP 

### Roco and Olmstead primers
We should probably used the same sex-linked markers as [Roco et al. 2015](http://www.pnas.org/content/112/34/E4752.full) which were used in other studies: 5′-GCCCAAGCAATATAAGGGCTTGTT-3′ forward and 5′-TGTCCTGCCCTATTGCTCCCGTAA-3′reverse. See also [Olmstead et al. 2010](http://www.sciencedirect.com/science/article/pii/S0166445X1000024X), especially the [supplements](https://ars.els-cdn.com/content/image/1-s2.0-S0166445X1000024X-mmc1.pdf).

To do:

Using the primers from Roco et al. 2015, locus 095F08: ACTGTCTGGCTTTTGATTGG/ACACATTTTCTTGGTCCTGG. Need to blast them against Allpaths assembly. Find the scaffold(s) that contain both primers if possible, then map the scaffold against the Allpaths assembly. Then look if we have SNPs from GBS on this region.
And primers focusing on amplifying regions near sex locus
```
makeblastdb -in /4/caroline/Xmellotropicalis/Allpaths/final.assembly.fasta -dbtype nucl -title sexmarkerstrop -out /4/caroline/Xmellotropicalis/Allpaths/final.assembly_blastable

blastn -evalue 1e-5 -query /4/caroline/Xmellotropicalis/primerstrop/095F08.fa -db /4/caroline/Xmellotropicalis/Allpaths/final.assembly_blastable -out /4/caroline/Xmellotropicalis/primerstrop/Mellotrop_095F08trop_e5 -outfmt 6

blastn -evalue 1e-1 -query /4/caroline/Xmellotropicalis/primerstrop/095F08.fa -db /4/caroline/Xmellotropicalis/Allpaths/final.assembly_blastable -out /4/caroline/Xmellotropicalis/primerstrop/Mellotrop_095F08trop_e1 -outfmt 6
blastn -evalue 1e-1 -query /4/caroline/Xmellotropicalis/primerstrop/genotypying_for.fa -db /4/caroline/Xmellotropicalis/Allpaths/final.assembly_blastable -out /4/caroline/Xmellotropicalis/primerstrop/Mellotrop_genofortrop_e1 -outfmt 6
blastn -evalue 1e-1 -query /4/caroline/Xmellotropicalis/primerstrop/genotypying_rev.fa -db /4/caroline/Xmellotropicalis/Allpaths/final.assembly_blastable -out /4/caroline/Xmellotropicalis/primerstrop/Mellotrop_genorevtrop_e1 -outfmt 6
blastn -evalue 1e-5 -query /4/caroline/Xmellotropicalis/primerstrop/095F08_fusion.fa -db /4/caroline/Xmellotropicalis/Allpaths/final.assembly_blastable -out /4/caroline/Xmellotropicalis/primerstrop/Mellotrop_095F08fusiontrop_e5 -outfmt 6
blastn -evalue 1e-1 -query /4/caroline/Xmellotropicalis/primerstrop/095F08_fusion.fa -db /4/caroline/Xmellotropicalis/Allpaths/final.assembly_blastable -out /4/caroline/Xmellotropicalis/primerstrop/Mellotrop_095F08fusiontrop_e1 -outfmt 6
blastn -evalue 1e-1 -query /4/caroline/Xmellotropicalis/primerstrop/Olmstead_primers.fa -db /4/caroline/Xmellotropicalis/Allpaths/final.assembly_blastable -out /4/caroline/Xmellotropicalis/primerstrop/Mellotrop_Olmsteadprimers_e1 -outfmt 6

gunzip -c /4/caroline/Xmellotropicalis/backbone_raw.fasta.gz | makeblastdb -in - -dbtype nucl -title sexmarkerstrop -out /4/caroline/Xmellotropicalis/backbone_raw_blastable
blastn -evalue 1e-1 -query /4/caroline/Xmellotropicalis/primerstrop/095F08.fa -db /4/caroline/Xmellotropicalis/backbone_raw_blastable -out /4/caroline/Xmellotropicalis/primerstrop/Mellotrop_dbg2olc_095F08trop_e1 -outfmt 6
blastn -evalue 1e-1 -query /4/caroline/Xmellotropicalis/primerstrop/Olmstead_primers.fa -db /4/caroline/Xmellotropicalis/backbone_raw_blastable -out /4/caroline/Xmellotropicalis/primerstrop/Mellotrop_dbg2olc_Olmsteadprimers_e1 -outfmt 6

gunzip -c /4/caroline/Xmellotropicalis/backbone_raw_supercontigs_upper_only.fasta.gz | makeblastdb -in - -dbtype nucl -title sexmarkerstrop -out /4/caroline/Xmellotropicalis/backbone_raw_suppercontig_upper_blastable
blastn -evalue 1e-1 -query /4/caroline/Xmellotropicalis/primerstrop/Olmstead_primers.fa -db /4/caroline/Xmellotropicalis/backbone_raw_suppercontig_upper_blastable -out /4/caroline/Xmellotropicalis/primerstrop/Mellotrop_dbg2olc_suppercontig_upper_Olmsteadprimers_e1 -outfmt 6
```
Sooooooooo not working.  

OK so need to use `-task blastn-short`.
```
blastn -evalue 1e-1 -query /4/caroline/Xmellotropicalis/primerstrop/Olmstead_primers.fa -db /4/caroline/Xmellotropicalis/backbone_raw_blastable -out /4/caroline/Xmellotropicalis/primerstrop/Mellotrop_dbg2olc_Olmsteadprimers_e1 -outfmt 6 -max_target_seqs 1 -task blastn-short
blastn -evalue 1e-1 -query /4/caroline/Xmellotropicalis/primerstrop/Olmstead_primers.fa -db /4/caroline/Xmellotropicalis/backbone_raw_blastable -out /4/caroline/Xmellotropicalis/primerstrop/Mellotrop_dbg2olc_Olmsteadprimers_e1_nomaxtarget -outfmt 6 -task blastn-short


blastn -evalue 1e-1 -query /4/caroline/Xmellotropicalis/primerstrop/095F08.fa -db /4/caroline/Xmellotropicalis/backbone_raw_blastable -out /4/caroline/Xmellotropicalis/primerstrop/Mellotrop_dbg2olc_095F08_e1 -outfmt 6 -max_target_seqs 1 -task blastn-short

blastn -evalue 1e-1 -query /work/cauretc/2017_Mellotropicalis/pseudomolecules/filter/blast_find_SDregion/010E04.fa -db /work/cauretc/2017_Mellotropicalis/pseudomolecules/backbone_raw_blastable -out /work/cauretc/2017_Mellotropicalis/pseudomolecules/filter/blast_find_SDregion/010E04_backbone_e1_nomaxtarget -outfmt 6 -task blastn-short

#Backbone_27162
```
The following was mainly because I thought the primers did not match which is not the case.

Maybe blasting the get the scaffolds from the mellotrop assembly that map to chr.07 then check if some SNPs that can be interesting...but should not really help... Hum sooooooooo need BE.

```
awk 'BEGIN {RS=">"} /Chr07/ {print ">"$0}' pseudomolecules_nucmer_qfilter_dbg2olc.fasta >pseudomoleculesChr7.fa

module load blast/2.2.28+
blastn -evalue 1e-1 -query /work/cauretc/2017_Mellotropicalis/pseudomolecules/filter/blast_find_SDregion/pseudomoleculesChr7.fa -db /work/ben/2016_Hymenochirus/xenTro9/xenTro9_genome_HARDmasked_blastable -out /work/cauretc/2017_Mellotropicalis/pseudomolecules/filter/blast_find_SDregion/pseudomoleculesChr7mello_trop.out -outfmt 6 -max_target_seqs 1
blastn -evalue 1e-1 -query /work/cauretc/2017_Mellotropicalis/pseudomolecules/filter/blast_find_SDregion/Olmstead_primers.fa -db /work/ben/2016_Hymenochirus/xenTro9/xenTro9_genome_HARDmasked_blastable -out /work/cauretc/2017_Mellotropicalis/pseudomolecules/filter/blast_find_SDregion/Olmstead_primers_trop.out -outfmt 6 -max_target_seqs 1 -task blastn-short
```
```
grep "Chr07" /work/cauretc/2017_Mellotropicalis/pseudomolecules/filter/blast_find_SDregion/Olmstead_primers_trop.out
For605:116800-117215	Chr07	100.00	24	0	0	1	24	2190623	2190646	3e-05	48.1
Rev605:116800-117215	Chr07	100.00	24	0	0	1	24	2191038	2191015	3e-05	48.1
For379:86947-87483	Chr07	100.00	22	0	0	1	22	61365097	61365076	4e-04	44.1
Rev379:86947-87483	Chr07	100.00	24	0	0	1	24	61364561	61364584	3e-05	48.1
For379:366617-367293	Chr07	100.00	27	0	0	1	27	61080524	61080498	8e-07	54.0
Rev379:366617-367293	Chr07	100.00	24	0	0	1	24	61079848	61079871	3e-05	48.1
For379:501771-502446	Chr07	100.00	24	0	0	1	24	60948763	60948740	3e-05	48.1
Rev379:501771-502446	Chr07	100.00	25	0	0	1	25	60948088	60948112	1e-05	50.1
For379:553147-553603	Chr07	100.00	26	0	0	1	26	60895922	60895897	3e-06	52.0
Rev379:553147-553603	Chr07	100.00	24	0	0	1	24	60895466	60895489	3e-05	48.1
For379:777598-777997	Chr07	100.00	25	0	0	1	25	60685369	60685345	1e-05	50.1
```
Should be the backbone scaffolds corresponding to Chr.07.
```
less /4/caroline/Xmellotropicalis/primerstrop/Mellotrop_dbg2olc_Olmsteadprimers_e1

For379:366617-367293    Backbone_56095  100.000 25      0       0       1       25      2130    2154    2.31e-05        50.1
Rev379:366617-367293    Backbone_15364  100.000 24      0       0       1       24      16847   16870   7.10e-05        48.1
Rev379:501771-502446    Backbone_118669 100.000 19      0       0       7       25      3952    3934    0.078   38.2
Rev379:501771-502446    Backbone_118669 100.000 19      0       0       7       25      5056    5038    0.078   38.2
Rev379:501771-502446    Backbone_118669 100.000 19      0       0       7       25      4232    4250    0.078   38.2
Rev379:501771-502446    Backbone_118669 100.000 19      0       0       7       25      5333    5351    0.078   38.2
For379:553147-553603    Backbone_32036  95.652  23      1       0       2       24      20762   20740   0.078   38.2
For379:777598-777997    Backbone_73307  100.000 19      0       0       4       22      14156   14174   0.078   38.2
``` 
`+` region only have one match. Should get the corresponding backbone scaffolds and map against the assembly and get the 2 best hits and observe if there is any differences in the scaffolds
```
less /4/caroline/Xmellotropicalis/primerstrop/Mellotrop_dbg2olc_Olmsteadprimers_e1_nomaxtarget

For605:495419-496318    Backbone_174891 100.000 24      0       0       1       24      19891   19914   7.10e-05        48.1
For605:495419-496318    Backbone_174891 100.000 21      0       0       4       24      16865   16885   0.004   42.1
For605:495419-496318    Backbone_3197   100.000 24      0       0       1       24      11261   11238   7.10e-05        48.1
For605:495419-496318    Backbone_3197   100.000 21      0       0       4       24      19656   19676   0.004   42.1
For605:Multiple Backbone_155692 100.000 19      0       0       1       19      3854    3872    0.068   38.2
Rev494:27541-27902      Backbone_140871 100.000 20      0       0       9       28      18458   18477   0.027   40.1
For494:31633-32115      Backbone_33734  100.000 19      0       0       3       21      5643    5625    0.068   38.2
Rev494:31633-32115      Backbone_48367  95.652  23      1       0       2       24      9002    8980    0.068   38.2
Rev494:600198-600743    Backbone_196656 100.000 19      0       0       3       21      2347    2329    0.068   38.2
Rev494:600198-600743    Backbone_194603 100.000 19      0       0       6       24      12266   12284   0.068   38.2
Rev494:600198-600743    Backbone_107232 100.000 19      0       0       6       24      7025    7043    0.068   38.2
Rev494:600198-600743    Backbone_97231  100.000 19      0       0       6       24      15384   15402   0.068   38.2
Rev494:600198-600743    Backbone_14805  95.652  23      1       0       2       24      1744    1722    0.068   38.2
For494:751791-752290    Backbone_26123  100.000 19      0       0       7       25      2777    2759    0.078   38.2
For379:1050241-1050778  Backbone_184331 100.000 19      0       0       1       19      4787    4769    0.068   38.2
+ For379:366617-367293    Backbone_56095  100.000 25      0       0       1       25      2130    2154    2.31e-05        50.1
+ Rev379:366617-367293    Backbone_15364  100.000 24      0       0       1       24      16847   16870   7.10e-05        48.1
+ Rev379:501771-502446    Backbone_118669 100.000 19      0       0       7       25      3952    3934    0.078   38.2
+ Rev379:501771-502446    Backbone_118669 100.000 19      0       0       7       25      5056    5038    0.078   38.2
+ Rev379:501771-502446    Backbone_118669 100.000 19      0       0       7       25      4232    4250    0.078   38.2
+ Rev379:501771-502446    Backbone_118669 100.000 19      0       0       7       25      5333    5351    0.078   38.2
+ For379:553147-553603    Backbone_32036  95.652  23      1       0       2       24      20762   20740   0.078   38.2
+ For379:777598-777997    Backbone_73307  100.000 19      0       0       4       22      14156   14174   0.078   38.2
Rev1151:25266-25765     Backbone_39627  100.000 19      0       0       4       22      11202   11220   0.068   38.2
Rev810:46889-47640      Backbone_185320 100.000 20      0       0       3       22      4462    4443    0.017   40.1
Rev810:46889-47640      Backbone_185320 100.000 20      0       0       3       22      8740    8721    0.017   40.1
Rev810:46889-47640      Backbone_66388  95.652  23      1       0       1       23      12298   12320   0.068   38.2
Rev810:46889-47640      Backbone_33362  95.652  23      1       0       1       23      326     304     0.068   38.2
Rev810:46889-47640      Backbone_33362  95.652  23      1       0       1       23      8704    8682    0.068   38.2
Rev810:46889-47640      Backbone_4277   95.652  23      1       0       1       23      13497   13475   0.068   38.2
For810:52523-53007      Backbone_66637  100.000 19      0       0       5       23      13617   13635   0.068   38.2
For810:261995-262744    Backbone_108910 100.000 22      0       0       1       22      9920    9899    0.001   44.1
For810:261995-262744    Backbone_131420 100.000 20      0       0       5       24      15918   15937   0.017   40.1
For810:261995-262744    Backbone_93603  100.000 20      0       0       5       24      11371   11390   0.017   40.1
For810:261995-262744    Backbone_81421  100.000 20      0       0       5       24      1310    1329    0.017   40.1
For810:261995-262744    Backbone_81421  100.000 20      0       0       5       24      2707    2726    0.017   40.1
For810:261995-262744    Backbone_81421  100.000 20      0       0       5       24      3065    3084    0.017   40.1
For810:261995-262744    Backbone_81421  100.000 20      0       0       5       24      2190    2171    0.017   40.1
For810:261995-262744    Backbone_81421  100.000 20      0       0       5       24      6372    6353    0.017   40.1
For810:261995-262744    Backbone_81421  100.000 19      0       0       6       24      616     634     0.068   38.2
For810:261995-262744    Backbone_81421  100.000 19      0       0       5       23      1129    1111    0.068   38.2
For810:261995-262744    Backbone_170074 100.000 20      0       0       5       24      129     110     0.017   40.1
For810:261995-262744    Backbone_170074 100.000 20      0       0       5       24      4833    4814    0.017   40.1
For810:261995-262744    Backbone_31165  100.000 20      0       0       5       24      10573   10554   0.017   40.1
For810:261995-262744    Backbone_156401 100.000 19      0       0       3       21      4596    4614    0.068   38.2
For1151:54144-54736     Backbone_24868  100.000 24      0       0       1       24      4860    4883    7.10e-05        48.1
Rev158:2187705-2188478  Backbone_71099  100.000 19      0       0       3       21      13985   13967   0.068   38.2

```

Very early backbones assembly into Chr07_pseudoomolecules after filtering
```
#Reminder
../../programs/MUMmer3.23/delta-filter -q Nucmer_mello_dbg2olc_xentrop9.delta >Nucmer_mello_dbg2olc_xentrop9_qfiler.delta

../../programs/MUMmer3.23/show-coords -r -c -l Nucmer_mello_dbg2olc_xentrop9_qfiler.delta> Nucmer_mello_dbg2olc_xentrop9_qfiler.coord

module load python/intel/3.4.2
python3 pseudomolecules_scaffolds.py Nucmer_mello_dbg2olc_xentrop9_qfiler.coord 500 15 backbone_raw.fasta filter/pseudomolecules_scaff_nucmer_qfilter_dbg2olc.fasta filter/pseudomolecules_scaff_nucmer_qfilter_dbg2olc_index.txt >filter/pseudomolecules_scaff_nucmer_qfilter_dbg2olc.out

#Matching Chr07
grep "Chr07" ../pseudomolecules_scaff_nucmer_qfilter_dbg2olc_index.txt
species1	Chr07	1	3511	Backbone_137426	3511
species1	Chr07	3592	14689	Backbone_184827	11098
species2	Chr07	1	8205	Backbone_167138	8205
species2	Chr07	8286	15197	Backbone_170121	6912
```

```
module load blast/2.2.28+
makeblastdb -in /work/cauretc/2017_Mellotropicalis/pseudomolecules/backbone_raw.fasta -dbtype nucl -title backbone_mello -out /work/cauretc/2017_Mellotropicalis/pseudomolecules/backbone_raw_blastable 
blastn -evalue 1e-1 -query /work/cauretc/2017_Mellotropicalis/pseudomolecules/filter/blast_find_SDregion/potential_backbones_SC.fa -db /work/cauretc/2017_Mellotropicalis/pseudomolecules/backbone_raw_blastable -out /work/cauretc/2017_Mellotropicalis/pseudomolecules/filter/blast_find_SDregion/potential_backbones_SC_DBG2OLC_e1_nomaxtarget -outfmt 6

/usr/local/RepeatMasker/RepeatMasker -dir /4/caroline/Xmellotropicalis/primerstrop/ -species "xenopus genus" -pa 4 -a potential_backbones_SC.fa
blastn -evalue 1e-1 -query /work/cauretc/2017_Mellotropicalis/pseudomolecules/filter/blast_find_SDregion/potential_backbones_SC.fa.masked -db /work/cauretc/2017_Mellotropicalis/pseudomolecules/backbone_raw_blastable -out /work/cauretc/2017_Mellotropicalis/pseudomolecules/filter/blast_find_SDregion/potential_backbones_SC_masked_DBG2OLC_e1_nomaxtarget -outfmt 6
```
`Backbone_118669` and `Backbone_32036` (in particular the 2nd) do not match especially well against another scaffold. When blasting on xenbase, chr.07 not best match.

```
blastn -evalue 1e-1 -query /work/cauretc/2017_Mellotropicalis/pseudomolecules/filter/blast_find_SDregion/Backbone_27162.fa -db /work/ben/2016_Hymenochirus/xenTro9/xenTro9_genome_HARDmasked_blastable -out /work/cauretc/2017_Mellotropicalis/pseudomolecules/filter/blast_find_SDregion/Backbone_27162_trop_nomaxtarget.out -outfmt 6 
blastn -evalue 1e-1 -query /work/cauretc/2017_Mellotropicalis/pseudomolecules/filter/blast_find_SDregion/Backbone_27162.fa.masked -db /work/ben/2016_Hymenochirus/xenTro9/xenTro9_genome_HARDmasked_blastable -out /work/cauretc/2017_Mellotropicalis/pseudomolecules/filter/blast_find_SDregion/Backbone_27162_masked_trop_nomaxtarget.out -outfmt 6
[cauretc@iqaluk blast_find_SDregion]$ less Backbone_27162_masked_trop_nomaxtarget.out
#Chr04
``` 
#### Conclusion
Didn't work. Makes some sense. Primers can map against different regions: not specific in our species (but did not blast everywhere), can be a translocated region to another chromosome, bad assembly with chimeras (probably yeah even if it is supposed to be rare), the real region of interest is not in the assembly (possible, considering also that repeat sequences tend to be higher on sex-chr. and so sex-chr. are harder to assemble), "bad" job of blast (possible too but using no max target should give hopefully the main maching regions and scaffolds repeatmasked to blast them against trop or back to the assembly).

Mainly did not help at all but wanted to try to see how conserved the genomes seem to be. I am pretty sure I'll forget the DBG2OLC assembly considering how little I trust him (used it here because in theory has better statistics). Also to extract multiple sequences from fasta file, used script `perl_script_extracting_seq.pl` that I put [here](https://github.com/caro46/Tetraploid_project/blob/master/some_scripts/perl_script_extracting_seq.pl). 
