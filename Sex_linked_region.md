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

Using the file from BE, sites that map to `Chr.07`
```
grep "#\|Chr07" /4/caroline/Xmellotropicalis/GBS/samtools_genotypes/Sex_linked/correctedID/Mellotrop_trop_sex_linked_sites_1st_part.txt
#CHROM	POS	REF	3799_dad.fq	3800_mom.fq.fq	3810_boy.fq.fq	4169_girl.fq.fq	4170_girl.fq.fq	4171_boy.fq.fq	4172_boy.fq.fq	4173_boy.fq.fq	4174_boy.fq.fq	4175_girl.fq.fq	4176_boy.fq.fq	4177_girl.fq.fq	4178_girl.fq.fq	4179_boy.fq.fq	4180_girl.fq.fq	4181_boy.fq.fq	4182_girl.fq.fq	4183_girl.fq.fq	4184_girl.fq.fq	4185_girl.fq.fq
Heterozygous_daughters_mom_ZW Chr07	3650093	C	C/C	C/T	C/T	C/T	C/C	C/C	C/C	C/C	C/C	C/T	C/C	C/T	C/T	C/C	C/T	C/C	C/T	C/T	C/T	C/T
Heterozygous_sons_mom_ZW Chr07	4786712	G	G/G	G/A	G/G	G/G	G/A	G/A	G/A	G/A	G/A	G/G	G/A	G/G	G/G	G/A	G/G	G/A	G/G	G/G	G/G	G/G
Heterozygous_sons_mom_ZW Chr07	4786722	T	T/T	T/C	T/T	T/T	T/C	T/C	T/C	T/C	T/C	T/T	T/C	T/T	T/T	T/C	T/T	T/C	T/T	T/T	T/T	T/T
Heterozygous_sons_mom_ZW Chr07	4786729	T	T/T	T/G	T/T	T/T	T/G	T/G	T/G	T/G	T/G	T/T	T/G	T/T	T/T	T/G	T/T	T/G	T/T	T/T	T/T	T/T
Heterozygous_sons_mom_ZW Chr07	4786731	C	C/C	C/T	C/C	C/C	C/T	C/T	C/T	C/T	C/T	C/C	C/T	C/C	C/C	C/T	C/C	C/T	C/C	C/C	C/C	C/C
Heterozygous_sons_mom_ZW Chr07	4786759	G	G/G	G/A	G/G	G/G	G/A	G/A	G/A	G/A	G/A	G/G	G/A	G/G	G/G	G/A	G/G	G/A	G/G	G/G	G/G	G/G
Heterozygous_sons_mom_ZW Chr07	4786768	T	T/T	T/A	T/T	T/T	T/A	T/A	T/A	T/A	T/A	T/T	T/A	T/T	T/T	T/A	T/T	T/A	T/T	T/T	T/T	T/T
Heterozygous_sons_mom_ZW Chr07	4786785	T	C/C	T/C	C/C	C/C	T/C	T/C	T/C	T/C	T/C	C/C	T/C	C/C	C/C	T/C	C/C	T/C	C/C	C/C	C/C	C/C
```
`3810_boy` homoz and `4170_girl` heteroz for `4786712-4786785` that are different from expectations. (but more "XY" SNPs identified on Chr.08)

## Using the assembly from Allpaths
### Why it can be better:

*Compared to DBG2OLC assembly:*

I am worried about the chimerical issues that our `DBG2OLC` assembly could have right now (in theory should be pretty low see computational methods of [Zimin et al. 2016](https://www.biorxiv.org/content/biorxiv/early/2016/07/26/066100.full.pdf)). And gap creating because of low quality of long reads. Using the `Allpaths` assembly should increase the confidence. The `Allpaths` assembly is more fragmented but in theory more accurate.

*Compared to directly mapping the reads onto X. tropicalis*

Considering we have a tetraploid, mapping the reads onto a diploid can caused various issues that should be reduced using the own assembly from the same species.

### Results
Ok so it is not better. Obtained both incomplete "XY" and "ZW" sex-inherited sites... Still the same individuals that show up different as the others from the same sex... Can be some sort of mix up, recombination on sex-chr. or autosomes...

BE expect chr. 07 to be the sex-chr. with a ZW system but right now I don't have more evidence for that than a potential sex-determination involving Chr. 08 and XY system... The other issue being the fact that I don't really trust the genotypes obtained with Samtools (even when I played with different flags with GATK, there was not enough SNP to be able to see any signal... so went with playing with Samtools...). 

## Summary table

Need to make a table with as columns `scaffold_number \t sex_inheritance_pattern \t who_is_the_heterozygous_sex \t number_of_putative_sex_linked_SNPs \t number_of_other_genotypes* \t homologous_region_in_tropicalis`.

`*`: `number_of_other_genotypes` - say if 1/2/3 offspring that don't have the same genotypes as the others of the same sex. For example, if a few females are heterozygous but the others + all the males are homozygous, can still be interesting because can be a problem of undercalled heterozygous due to the coverage.

The `c++` script provides the main information except `number_of_other_genotypes` `homologous_region_in_tropicalis`. 


| scaffold_number  | sex_inheritance_pattern | heterozygous_sex | number_of_putative_sex_linked_SNPs | number_of_other_genotypes | homologous_region_in_tropicalis| coordinates Xtropicalis_v9 |
| ------------- | ------------- | ------------- | ------------- | ------------- | ------------- | ------------- |
| scaffold_60  | XY  | dad daughters | 1 |4175_girl homoz 4173_boy heteroz = 2|Chr08 | 45557934-45578206 |
| scaffold_1906  | XY  | dad sons | 2 | 3810_boy impossible genotype-proba undercalled heteroz 4173_boy homoz 4175_girl heteroz = 3 |Chr08 | 63039376-63061361 |
| scaffold_3978  | XY  | dad daughters | 1 | 4175_girl homoz 4173_boy heteroz = 2 |Chr08 | 93073402-93087859 |
| scaffold_4210  | XY  | dad sons | 1 | 4173_boy homoz 4175_girl heteroz = 2 | Chr08 | 77207901-77230678 |
| scaffold_4751  | XY  | dad sons | 4 | 4173_boy homoz 4175_girl heteroz = 2 | Chr08| 35037606-35051960 |
| scaffold_7061  | XY  | dad daughters | 1 | 4175_girl homoz 4173_boy heteroz = 2 | Chr08| 28377265-28387418 |
| scaffold_9128  | XY  | dad daughters | 3 | 4175_girl homoz 4173_boy heteroz = 2 | Chr08| 76077665-76080432 |
| scaffold_13700  | XY | dad daughter | 1 | everybody homoz except dad+1daughter  | Chr05||
| scaffold_27496  | XY  | dad sons | 1 | 4173_boy homoz 4175_girl heteroz = 2 | Chr08| 18799653-18802355 |
| scaffold_28871  | XY  | dad daughters | 1 | 4175_girl homoz 4173_boy heteroz = 2 | Chr08| 69930839-69932904 |
| scaffold_32115  | XY  | dad sons | 1 | 3810_boy impossible genotype-proba undercalled heteroz 4173_boy homoz 4175_girl heteroz = 3 | Chr08| 35729784-35732320 |
| scaffold_32872  | XY  | dad daughters | 1 | 4175_girl homoz 4173_boy heteroz = 2 | Chr08| 78116377-78119093 |
| scaffold_42889  | XY  | dad sons | 1 | 4173_boy homoz 4175_girl heteroz = 2 | Chr08| 70702319-70704453 |
| scaffold_46063  | XY  | dad sons | 1 | 3810_boy impossible genotype-proba undercalled heteroz 4173_boy homoz 4175_girl heteroz = 3 | Chr08| 29798778-29808304 |
| scaffold_56755  | XY  | dad daughters | 1 | 4175_girl homoz 4173_boy heteroz = 2 | Chr08| 98599194-98608013 |
| scaffold_59642  | XY  | dad daughters | 1 | 4175_girl homoz 4173_boy heteroz = 2 | Chr08| 78714870-78723236 |
| scaffold_60594  | XY  | dad sons | 3 | 4173_boy homoz 4175_girl heteroz = 2 | Chr08| 15528465-15533801 |
| scaffold_64418  | XY  | dad daughters | 1 | 3810_boy impossible genotype-proba undercalled heteroz 4175_girl homoz 4173_boy heteroz = 3 | Chr08| 22342457-22351932 |
| scaffold_70317  | XY  | dad daughters | 1 | 4175_girl homoz 4173_boy heteroz = 2 | Chr08| 34891286-34892976 |
| scaffold_72646  | XY  | dad sons | 1 | 4173_boy homoz 4175_girl heteroz = 2 | Chr08| 62863799-62865418 |
| scaffold_79065  | XY  | dad daughters | 1 | 4175_girl homoz 4173_boy heteroz = 2 | Chr08| 20623405-20622478 |
| scaffold_88544  | XY  | dad sons | 1 | 4173_boy homoz 4175_girl heteroz = 2 | Chr08| 67017737-67018683 |
| scaffold_88553  | XY  | dad sons | 1 | 3810_boy impossible genotype-proba undercalled heteroz 4173_boy homoz 4175_girl heteroz = 3 | scaffold_22| 939009-938801 |
| scaffold_110653  | XY  | dad sons | 2 | 4173_boy homoz 4175_girl heteroz = 2 | Chr08| 96852786-96853717 |
| scaffold_119447  | XY  | dad daughters | 2 | 4175_girl homoz 4173_boy heteroz = 2 | Chr08| 38139023-38140104 |
| scaffold_140250  | XY  | dad sons | 1 | | Chr08| 55403479-55404322 |
| scaffold_157504  | XY  | dad daughters | 2 | 4175_girl homoz 4173_boy heteroz = 2 | Chr08| 46331456-46332801 |
| scaffold_157943  | XY  | dad daughters | 2 | everybody homoz except dad + 1daughter | Chr10||
| scaffold_159723  | XY  | dad daughters | 1 | 4175_girl homoz 4173_boy heteroz = 2 | Chr08| 69664535-69665301 |
| scaffold_173610  | XY  | dad daughters | 1 | 4175_girl homoz 4173_boy heteroz = 2 | Chr08| 54421457-54422835 |
| scaffold_195783  | XY  | dad daughters | 1 | 4175_girl homoz 4173_boy heteroz = 2 | Chr08| 36431378-36432032 |
| scaffold_213657  | XY  | dad daughters | 1 | 4175_girl homoz 4173_boy heteroz = 2 | Chr05||
| scaffold_224968  | XY  | dad sons | 1 | 3810_boy impossible genotype-proba undercalled heteroz 4173_boy homoz 4175_girl heteroz = 3 | Chr08| 27526951-27527519 |
| scaffold_232003  | XY  | dad daughters | 1 | 4175_girl homoz 4173_boy heteroz = 2 | scaffold_4489| 870-2002 |
| scaffold_256524  | XY  | dad sons | 1 | 4173_boy homoz 4175_girl heteroz = 2 | scaffold_19| 970452-971506 |
| scaffold_267469  | XY  | dad sons | 1 | 4173_boy homoz 4175_girl heteroz = 2 | Chr08| 29897302-29898362 |
| scaffold_302760  | XY  | dad daughters | 1 | 4175_girl homoz 4173_boy heteroz = 2 | small alignment||
| scaffold_307179  | XY  | dad daughters | 1 | 4175_girl homoz 4173_boy impossible momoz - proba heteroz  = 2 | Chr08| 42338929-42339618 |
| scaffold_308711  | XY  | dad sons | 1 | 4173_boy homoz 4175_girl heteroz = 2 | Chr08| 16192146-16192863 |
| scaffold_159590  | ZW  | mom daughters | 1 | 3810_boy heteroz 4170_girl homoz = 2 | Chr07 | 3649572-3650020 |
| scaffold_262360  | ZW  | mom daughters | 1 | 4170_girl homoz = 1 | very small alignment |scaffold_622:38626-39157 Xenbase JBrowse tropicalis 9.0 |
| scaffold_269737  | ZW  | mom daughters | 1 | everybody homoz except mom + 1 daughter | Chr03 ||
| scaffold_317137  | ZW  | mom daughters | 1 | 4175_girl homoz 4173_boy heteroz = 2 | Chr08 | 19738134-22808689 |

```
perl ~/scripts/Sex_linked_regions/scaffolds_SL_seq.pl /4/caroline/Xmellotropicalis/GBS/samtools_genotypes/Sex_linked/correctedID/Allpaths/Mellotrop_trop_sex_linked_sites_1st_part.txt /4/caroline/Xmellotropicalis/Allpaths/final.assembly.fasta /4/caroline/Xmellotropicalis/GBS/samtools_genotypes/Sex_linked/correctedID/Allpaths/try_SL.fasta
```
**Notes:** 

- Need to use the script used for simulation of pipa and hymeno to make sure we have the good version of the script: some sites are wrongly identified as "incomplete sex-linked". On the table are the ones after manually checking. Issue can also be due to being less strangeant in every step because of poor coverage, not being able to use GATK as previously used, known issues with samtools -> but do not change the fact that various sites mapping to `Chr.08` have 1 individual/sex with an opposite genotype from the expectation (need to check the coverage but even when "playing" with parameters and a different assembly, same XY SNPs show up). Even if weird SNP showing up as potentially sex-linked but are not, the complete sex-linked if present in the data after filtering should have showed up anyways. 

- To sum up the table: most of the "XY" sites mapped to `Chr.08` and all have 4175_girl and 4173_boy with the opposite expected genotypes. The "best" sites `scaffold_262360` mapped to Chr.07 using xenbase server or when repeat masked.

- ***Main idea: the sites identified as incomplete potentially sex linked that map to chr.07 are ZW and on 7p. We recovered the same idea, which is good using the different method, either using mapping directly against trop or a de novo method...*** I do think the de novo assembly right now is not good enough due to small scaffolds. Even if there is a signal on the `Chr.07 7p`, `ZW`, as expected, using the GBS data we get a greater signal towards `XY Chr.08` which can be either true but most likely due to data/coverage/undercalled heteroz ... Still need to talk to BE boss. 

- The blasting where made without previously repeat masking but except if specified the alignment is at least > 200-300bp.

```
module load blast/2.2.28+
gunzip -c /work/cauretc/2017_Mellotropicalis/try_SL.fasta.gz | blastn -evalue 1e-1 -query - -db /work/ben/2016_Hymenochirus/xenTro9/xenTro9_genome_HARDmasked_blastable -out /work/cauretc/2017_Mellotropicalis/try_SL_trop_nomaxtarget.out -outfmt 6 

gunzip -c /work/cauretc/2017_Mellotropicalis/try_SL.fasta.gz | blastn -evalue 1e-5 -query - -db /work/cauretc/2017_Mellotropicalis/pseudomolecules/backbone_raw_blastable -out /work/cauretc/2017_Mellotropicalis/try_SL_DBG2OLC_e5_1maxtarget -outfmt 6 -max_target_seqs 1

/usr/local/RepeatMasker/RepeatMasker -dir /4/caroline/Xmellotropicalis/GBS/samtools_genotypes/Sex_linked/correctedID/Allpaths/ -species "xenopus genus" -pa 4 -a /4/caroline/Xmellotropicalis/GBS/samtools_genotypes/Sex_linked/correctedID/Allpaths/try_SL.fasta
gunzip -c /work/cauretc/2017_Mellotropicalis/try_SL.fasta.masked.gz | blastn -evalue 1e-1 -query - -db /work/ben/2016_Hymenochirus/xenTro9/xenTro9_genome_HARDmasked_blastable -out /work/cauretc/2017_Mellotropicalis/try_SL_masked_1maxtarget -outfmt 6 -max_target_seqs 1
gunzip -c /work/cauretc/2017_Mellotropicalis/try_SL.fasta.masked.gz | blastn -evalue 1e-5 -query - -db /work/cauretc/2017_Mellotropicalis/pseudomolecules/backbone_raw_blastable -out /work/cauretc/2017_Mellotropicalis/try_SL_masked_DBG2OLC_e5_1maxtarget -outfmt 6 -max_target_seqs 1
```

- (Jan11/2018) Looked at the `_sorted.bam` files using `IGV_2.3.81`. Maybe for `scaffold_262360 857ZW` undercalled heteroz for `BJE3810`. For `scaffold_4751`, `BJE4173` has 1 read with the other genotype. `Scaffold_7061` needs to be amplified: `4345` partially sex-linked sites and `4335` seems to be a SNP in mom which is not sex-linked.  

### Exploring some interesting snps

Best ZW site: `scaffold_262360` from `Allpaths` assembly. The 2 other sites I also put below are sites with a few genotypes in heterozygous in 1 sex but most likely under called of heterozygous.
```
grep "#\|scaffold_260445\|scaffold_262360\|269737" /4/caroline/Xmellotropicalis/GBS/samtools_genotypes/Sex_linked/correctedID/Allpaths/Mellotrop_trop_sex_linked_sites_1st_part.txt 
##CHROM	POS	REF	3799_dad	3800_mom	3810_boy	4169_girl	4170_girl	4171_boy	4172_boy	4173_boy	4174_boy	4175_girl	4176_boy	4177_girl	4178_girl	4179_boy	4180_girl	4181_boy	4182_girl	4183_girl	4184_girl	4185_girl
#Heterozygous_daughters_mom_ZW scaffold_260445	69	A	A/A	A/G	A/A	A/A	A/A	A/A	A/A	A/A	A/A	A/A	A/A	A/A	A/A	A/A	A/A	A/A	A/A	A/A	A/G	A/A
#Heterozygous_daughters_mom_ZW scaffold_262360	857	G	G/G	G/T	G/G	G/T	G/G	G/G	G/G	G/G	G/G	G/T	G/G	G/T	G/T	G/G	G/T	G/G	G/T	G/T	G/T	G/T
#Heterozygous_daughters_mom_ZW scaffold_269737	1066	G	G/G	G/A	G/G	G/G	G/G	G/G	G/G	G/G	G/G	G/G	G/G	G/G	G/G	G/G	G/G	G/G	G/G	G/G	G/A	G/G

awk -v seq="scaffold_262360" -v RS='>' '$1 == seq {print RS $0}' /4/caroline/Xmellotropicalis/Allpaths/final.assembly.fasta >/4/caroline/Xmellotropicalis/Allpaths/final.assembly_scaffold_262360.fasta
awk -v seq="scaffold_260445" -v RS='>' '$1 == seq {print RS $0}' /4/caroline/Xmellotropicalis/Allpaths/final.assembly.fasta >>/4/caroline/Xmellotropicalis/Allpaths/final.assembly_scaffold_262360.fasta
awk -v seq="scaffold_269737" -v RS='>' '$1 == seq {print RS $0}' /4/caroline/Xmellotropicalis/Allpaths/final.assembly.fasta >>/4/caroline/Xmellotropicalis/Allpaths/final.assembly_scaffold_262360.fasta
mv /4/caroline/Xmellotropicalis/Allpaths/final.assembly_scaffold_262360.fasta /4/caroline/Xmellotropicalis/Allpaths/final.assembly_scaffolds_262360_260445_269737.fasta

/usr/local/RepeatMasker/RepeatMasker -dir /4/caroline/Xmellotropicalis/Allpaths/ -species "xenopus genus" -pa 4 -a /4/caroline/Xmellotropicalis/Allpaths/final.assembly_scaffolds_262360_260445_269737.fasta

blastn -evalue 1e-10 -query /4/caroline/Xmellotropicalis/Allpaths/final.assembly_scaffolds_262360_260445_269737.fasta -db /4/caroline/Xmellotropicalis/backbone_raw_blastable -out /4/caroline/Xmellotropicalis/primerstrop/Mellotrop_alpaths_scaffolds_262360_260445_269737_dbg2olc_e10_1maxtarget -outfmt 6 -max_target_seqs 1
blastn -evalue 1e-10 -query /4/caroline/Xmellotropicalis/Allpaths/final.assembly_scaffolds_262360_260445_269737.fasta.masked -db /4/caroline/Xmellotropicalis/backbone_raw_blastable -out /4/caroline/Xmellotropicalis/primerstrop/Mellotrop_alpaths_scaffolds_262360_260445_269737_dbg2olc_e10_1maxtarget -outfmt 6 -max_target_seqs 1
#no matching for scaffold_262360
#also without max target
 
awk -v seq="scaffold_262360" -v RS='>' '$1 == seq {print RS $0}' /4/caroline/Xmellotropicalis/Allpaths/final.assembly_scaffolds_262360_260445_269737.fasta.masked >/4/caroline/Xmellotropicalis/Allpaths/final.assembly_scaffold262360.masked.fa
blastn -evalue 1e-1 -query /4/caroline/Xmellotropicalis/Allpaths/final.assembly_scaffold262360.masked.fa -db /4/caroline/Xmellotropicalis/backbone_raw_blastable -out /4/caroline/Xmellotropicalis/primerstrop/Mellotrop_alpaths_scaffolds_262360_dbg2olc_e1_nomaxtarget -outfmt 6
#no match
vcftools --gzvcf /4/caroline/Xmellotropicalis/GBS/samtools_genotypes/Allpaths/Mellotrop_allpaths_var_DP_AD.vcf.gz --chr "scaffold_262360" --recode  --recode-INFO-all --out /4/caroline/Xmellotropicalis/GBS/samtools_genotypes/Allpaths/Mellotrop_allpaths_var_DP_AD_scaffold262360
#After filtering, kept 23 out of a possible 633743 Sites
/usr/local/vcftools/src/perl/vcf-to-tab < /4/caroline/Xmellotropicalis/GBS/samtools_genotypes/Allpaths/Mellotrop_allpaths_var_DP_AD_scaffold262360.recode.vcf > /4/caroline/Xmellotropicalis/GBS/samtools_genotypes/Allpaths/Mellotrop_allpaths_var_DP_AD_scaffold262360.recode.tab

```
I blasted `scaffold_262360` directly on xenbase using the default parameter on `XL9_2_GCF_JGInames.fa` and `XT9_1_GCF_JGInames.fa` (= more recent versions of the assemblies). The scaffold matched to `scaffold_622`. See below for some statistics of the best match.

```
[Xenbase JBrowse tropicalis 9.0: scaffold_622:38626-39157]

High-scoring segment pair (HSP) group

HSP Information
Score = 426, E = 5e-117, Identities = 433/547 (79%), Length = 547, Query Strand = +, Hit Strand = +
```
On this scaffold we can find `LOC105945848` annotated as a gene. I used the `CDS` and also part of intron to blast against *X. laevis* genome. It matches to `chr. 07.L` short arm (not far away from `ephb6.L`, `prss1.L`). I blasted the `Allpaths` scaffolds onto the `DBG2OLC` assembly in order to try to obtain a longer scaffold and maybe get more genotypes data of a longer region. But for some reason no match of `scaffold_262360`. The easiest reason I am thinking about right now is that the region might have more repeat sequences (accumulation on sex-chromosomes?) and is harder to assemble and maybe caused chimerical sequences with Pacbio or some sort of conflict that might have caused a break of this region during `DBG2OLC` assembly... 

The snp of interest (position `857` of `scaffold_262360`) was obtained using this filtering option `$commandline = "bcftools filter -O z ".$path_to_output."Mellotrop_allpaths_var_DP_AD.vcf.gz -e '%QUAL<10 || FORMAT/DP<10 || FORMAT/DP>500 ||FORMAT/GQ = \".\" ' \> ".$path_to_output."Mellotrop_allpaths_var.fltQual_DP10.vcf.gz";` and of course were still there when I played with the parameters with less stringent parameters or with default. I looked at other sites near it, previous to filtering: positions `739`, `744` and `750` show heterozygous sites in mom and only sons (respectively `T/A`, `T/C` and `T/A`) and homozygous in the dad and in the daughters when the latter has genotypes called (a lot of missing data for these 3 sites). The 1st snp could correspond to a snp on the W, whereas the others look like more as a potential snp on the mom Z.

```
module load blast/2.2.28+
gunzip -c /work/cauretc/2017_Mellotropicalis/SOAP_assembly/SOAP_Mellotropicalis_BJE3652_genome_33_memory.scafSeq | makeblastdb -in - -dbtype nucl -title SOAPmellotrop_ref -out /work/cauretc/2017_Mellotropicalis/SOAP_assembly/SOAP_Mellotropicalis_BJE3652_genome_33_memory_scaf_blastable
blastn -evalue 1e-10 -query /work/cauretc/2017_Mellotropicalis/SOAP_assembly/final.assembly_scaffold262360.masked.fa -db /work/cauretc/2017_Mellotropicalis/SOAP_assembly/SOAP_Mellotropicalis_BJE3652_genome_33_memory_scaf_blastable -out /work/cauretc/2017_Mellotropicalis/SOAP_assembly/final.assembly_scaffold262360_masked_SOAP_e10_1maxtarget -outfmt 6 -max_target_seqs 1
#scaffold130294

blastn -evalue 1e-10 -query /work/cauretc/2017_Mellotropicalis/SOAP_assembly/final.assembly_scaffold262360.masked.fa -db /work/cauretc/2017_Mellotropicalis/SOAP_assembly/SOAP_Mellotropicalis_BJE3652_genome_33_memory_scaf_blastable -out /work/cauretc/2017_Mellotropicalis/SOAP_assembly/final.assembly_scaffold262360_masked_SOAP_e10_nomaxtarget -outfmt 6
#scaffold_262360 scaffold130294  97.68   475     3       2       86      552     24      498     0.0      815
#scaffold_262360 scaffold130294  94.87   312     5       1       651     951     629     940     1e-134   486
#scaffold_262360 scaffold130294  79.54   259     44      9       698     951     629     883     4e-41    176
#scaffold_262360 scaffold130294  100.00  44      0       0       587     630     551     594     8e-13   82.4
#scaffold_262360 C153519949      100.00  109     0       0       924     1032    1       109     6e-49    202
#scaffold_262360 C153519949      83.64   110     14      4       878     984     1       109     2e-18    100
#scaffold_262360 scaffold1000775 86.33   139     14      5       896     1032    10363   10498   3e-32    147
gunzip -c /work/cauretc/2017_Mellotropicalis/SOAP_assembly/SOAP_Mellotropicalis_BJE3652_genome_33_memory.scafSeq.gz | awk -v seq="scaffold130294" -v RS='>' '$1 == seq {print RS $0}' -
gunzip -c /work/cauretc/2017_Mellotropicalis/SOAP_assembly/SOAP_Mellotropicalis_BJE3652_genome_33_memory.scafSeq.gz | awk -v seq="C153519949" -v RS='>' '$1 == seq {print RS $0}' -
gunzip -c /work/cauretc/2017_Mellotropicalis/SOAP_assembly/SOAP_Mellotropicalis_BJE3652_genome_33_memory.scafSeq.gz | awk -v seq="scaffold1000775" -v RS='>' '$1 == seq {print RS $0}' -
#A lot of missing data!!!!
#Aligned SOAP scaffold130294 and Allpaths scaffold_262360 with MAFFT (v7.372) and seems to align pretty well outside the missing data region of SOAP. There is no missing data withing the Allpaths scaffold. The Alpaths one matches perfectly against `scaffold_622` while `scaffold130294` has a better result for chr. 10.
 
blastn -evalue 1e-1 -query /work/cauretc/2017_Mellotropicalis/SOAP_assembly/final.assembly_scaffold262360.masked.fa -db /work/cauretc/laevis_genome/Xla_v91_genome_HARDmasked_blastable -out /work/cauretc/2017_Mellotropicalis/SOAP_assembly/final.assembly_scaffold262360_masked_laevis91_e1_nomaxtarget -outfmt 6
gunzip -c /work/cauretc/laevis_genome/Xla_v91_repeatMasked.fa.gz | makeblastdb -in - -dbtype nucl -title laevis91_soft -out /work/cauretc/laevis_genome/Xla_v91_repeatMasked_soft_blastable
blastn -evalue 1e-1 -query /work/cauretc/2017_Mellotropicalis/SOAP_assembly/final.assembly_scaffold262360.masked.fa -db /work/cauretc/laevis_genome/Xla_v91_repeatMasked_soft_blastable -out /work/cauretc/2017_Mellotropicalis/SOAP_assembly/final.assembly_scaffold262360_masked_laevis91soft_e1_nomaxtarget -outfmt 6
#no match

gunzip -c /work/cauretc/2017_Mellotropicalis/pseudomolecules/allpaths/final.assembly.fasta.gz | makeblastdb -in - -dbtype nucl -title allpths_ref -out /work/cauretc/2017_Mellotropicalis/pseudomolecules/allpaths/final.assembly_blastable
blastn -evalue 1e-1 -query /work/cauretc/2017_Mellotropicalis/SOAP_assembly/final.assembly_scaffold262360.masked.fa -db /work/cauretc/2017_Mellotropicalis/pseudomolecules/allpaths/final.assembly_blastable -out /work/cauretc/2017_Mellotropicalis/pseudomolecules/allpaths/final.assembly_scaffold262360_allpaths_e1_nomaxtarget -outfmt 6
#only the same scaffold matches

gunzip -c /work/cauretc/tropicalis_v9/Xtropicalis_v9_repeatMasked.fa.gz | makeblastdb -in - -dbtype nucl -title trop_soft -out /work/cauretc/tropicalis_v9/Xtropicalis_v9_repeatMasked_soft_blastable
blastn -evalue 1e-1 -query /work/cauretc/2017_Mellotropicalis/SOAP_assembly/final.assembly_scaffold262360.masked.fa -db /work/cauretc/tropicalis_v9/Xtropicalis_v9_repeatMasked_soft_blastable -out /work/cauretc/2017_Mellotropicalis/SOAP_assembly/final.assembly_scaffold262360_masked_trop9soft_e1_nomaxtarget -outfmt 6
#only scaffold_622 even using all the default values

gunzip -c /work/cauretc/tropicalis_v9/Xtropicalis_v9_repeatMasked.fa.gz | awk -v seq="scaffold_622" -v RS='>' '$1 == seq {print RS $0}' - >/work/cauretc/tropicalis_v9/Xtropicalis_v9_repeatMasked_scaffold_622.fa
blastn -evalue 1e-1 -query /work/cauretc/tropicalis_v9/Xtropicalis_v9_repeatMasked_scaffold_622.fa -db /work/cauretc/laevis_genome/Xla_v91_repeatMasked_soft_blastable -out /work/cauretc/tropicalis_v9/Xtropicalis_v9_repeatMasked_scaffold_622_Xlaev91_soft_e1_nomaxtarget -outfmt 6
blastn -evalue 1e-1 -query /work/cauretc/tropicalis_v9/Xtropicalis_v9_repeatMasked_scaffold_622.fa -db /work/cauretc/laevis_genome/Xla_v91_genome_HARDmasked_blastable -out /work/cauretc/tropicalis_v9/Xtropicalis_v9_repeatMasked_scaffold_622_Xlaev91_hard_e1_nomaxtarget -outfmt 6
```
## Other options
### Bewick's primers
At that point there are some stuff that I would try (need to see with BE):

- focusing on sites that are only present in 1 sex that might have more information, confirming the faint "signal"

- If it is actually a similar sex-determining system as *X. tropicalis* then maybe we should try amplyfing some regions that had SNPs displaying a sex inheritance pattern. in *X. tropicalis*. Problem if the region has a similar region on the other subgenome but can blast and see how many times it shows up using Allpaths or DBG2OLC genomes... If the sub-genomes are diverged enough we should be able to amplify specifically sites from 1 of the subgenome.

Most interesting region from [Bewick et al. 2013](https://academic.oup.com/gbe/article/5/6/1087/616594#supplementary-data) from the supplements (names of the primers): 

- sc7v7-10128301-f/sc7v7-10129920-r (`GCAACTATGAGTTGGAACTT`/`CTCATTGCTCATTGTTTTGGTG`): highly polymorphic in females (=`Xenbase JBrowse tropicalis 9.0: Chr07:8909400-8909420`)

- scaf2_149790591_f/scaf2_149791341_r (`GATCAGAACTCGTTGAATCTCTTT`/`CGGGGGATTCACTGGTTATT`): female specific indels (=`Xenbase JBrowse tropicalis 9.0: scaffold_492:88224-88247`)

- scaf2_149954039_f/scaf2_149954800_r (`TGAAATTGGGCATCACAAAA`/`GCTGTACTCTTGAATTGTGTTACCAT`): 1 female specific SNP (=`Xenbase JBrowse tropicalis 9.0: scaffold_130:644037-644062`)

- scaf2_150071042_f/scaf2_150071793_r (`GATTGGTCCCCTTCCGTAAT`/`GGATTTCAGGCCAGCAGTTA`): 1 female specific SNP (=`Xenbase JBrowse tropicalis 9.0: scaffold_130:760304-760324`)

#### Somme comments

From Bewick et al. 2013

*this is presumably because some scaffolds are chimerical (e.g., a portion of scaffold 2 in version 7.1 is probably actually derived from S. tropicalis chromosome 7)*.

Confirmed if you do some blast on xenbase:

- blasting the primers on xenbase (Xenbase JBrowse tropicalis 9.0/9.1): mapped to the end of scaffolds 492 and 130

- genes on scaffold 130: `phc1`, `m6pr`, `ovos2`

- genes on scaffold 492: `tbx15` 

- looking for the previous genes as a research on xenbase to find where they are located on *X. laevis*

- `phc1`: `chr.07` of *X. laevis* `v.9.1` and `scaffold_2` of *X. tropicalis* `v.7.1`, `m6pr`: `chr.07` of *X. laevis* `v.9.1` and `scaffold_159` of *X. tropicalis* `v.8.0`, `ovos2`: `chr.07L` of *X. laevis* `v.9.1` and `scaffold_130` of *X. tropicalis* `v.8.0`, `tbx15`: `chr.02` of *X. laevis* `v.9.1` and `scaffold_2` of *X. tropicalis* `v.7.1`.

- `phc1` and `tbx15` are both on `scaffold_2` of *X. tropicalis* `v.7.1` but on different chromosomes of *X. laevis* `v.9.1` which can be due to misassembly.

#### Blast agains DBG2OLC assembly
```
module load blast/2.2.28+
blastn -evalue 1e-1 -query /work/cauretc/2017_Mellotropicalis/pseudomolecules/filter/blast_find_SDregion/Bewick_primers.fa -db /work/cauretc/2017_Mellotropicalis/pseudomolecules/backbone_raw_blastable -out /work/cauretc/2017_Mellotropicalis/pseudomolecules/filter/blast_find_SDregion/Bewick_primers_DBG2OLC_e1_nomaxtarget -outfmt 6 -task blastn-short

#scaf2_149954800_r       Backbone_196855 95.83   24      1       0       1       24      6097    6120    0.020   40.1
#scaf2_149954800_r       Backbone_196855 100.00  19      0       0       8       26      9523    9505    0.078   38.2

zgrep "Backbone_196855" /4/caroline/Xmellotropicalis/backbone_raw_supercontig.index.gz
#16	Backbone_196855	14806001	14823452
vcftools --gzvcf Mellotrop_DBG2OLC_backbone_var.vcf.gz --chr "supercontig_16" --from-bp 14806001 --to-bp 14823452 --recode  --recode-INFO-all --out Mellotrop_Backbone_196855
#No data left for analysis!
vcftools --gzvcf Mellotrop_DBG2OLC_backbone_var_DP_AD.vcf.gz --chr "supercontig_16" --from-bp 14806001 --to-bp 14823452 --recode  --recode-INFO-all --out Mellotrop_Backbone_196855
#No data left for analysis!
```
Maybe I should consider decreasing again the depth and quality (but tried with depth of 5...)...

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

zgrep "Backbone_27162" /4/caroline/Xmellotropicalis/backbone_raw_supercontig.index.gz
#3	Backbone_27162	34879281	34893422
vcftools --gzvcf Mellotrop_DBG2OLC_backbone_var_DP_AD.vcf.gz --chr "supercontig_3" --from-bp 34879281 --to-bp 34893422 --recode  --recode-INFO-all --out Mellotrop_Backbone_27162

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
+ For494:31633-32115      Backbone_33734  100.000 19      0       0       3       21      5643    5625    0.068   38.2
+ Rev494:31633-32115      Backbone_48367  95.652  23      1       0       2       24      9002    8980    0.068   38.2
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

perl /work/cauretc/scripts/perl_script_extracting_seq.pl pseudomolecules/backbone_raw.fasta For494_Olmstead_backbones.fa /work/ben/2016_Hymenochirus/xenTro9/xenTro9_genome_HARDmasked_blastable For494_Olmstead_backbones_trop.out
#Backbone_33734  scaffold_1725

perl /work/cauretc/scripts/perl_script_extracting_seq.pl pseudomolecules/backbone_raw.fasta For494_Olmstead_backbones.fa /work/cauretc/laevis_genome/Xla_v91_genome_HARDmasked_blastable For494_Olmstead_backbones_laevis.out
#Backbone_33734  chr6S
###!was not repeatmasked - alignment ~100bp
``` 
#### Conclusion
Didn't work. Makes some sense. Primers can map against different regions: not specific in our species (but did not blast everywhere), can be a translocated region to another chromosome, bad assembly with chimeras (probably yeah even if it is supposed to be rare), the real region of interest is not in the assembly (possible, considering also that repeat sequences tend to be higher on sex-chr. and so sex-chr. are harder to assemble), "bad" job of blast (possible too but using no max target should give hopefully the main maching regions and scaffolds repeatmasked to blast them against trop or back to the assembly).

Mainly did not help at all but wanted to try to see how conserved the genomes seem to be. I am pretty sure I'll forget the DBG2OLC assembly considering how little I trust him (used it here because in theory has better statistics). Also to extract multiple sequences from fasta file, used script `perl_script_extracting_seq.pl` that I put [here](https://github.com/caro46/Tetraploid_project/blob/master/some_scripts/perl_script_extracting_seq.pl). 

### Olmstead sequences
Main idea as previously with the primers. Try to get matching scaffolds then look for genotypes.

```
module load blast/2.2.28+
blastn -evalue 1e-1 -query /work/cauretc/2017_Mellotropicalis/pseudomolecules/filter/blast_find_SDregion/Olmstead_seq.fa -db /work/cauretc/2017_Mellotropicalis/pseudomolecules/backbone_raw_blastable -out /work/cauretc/2017_Mellotropicalis/pseudomolecules/filter/blast_find_SDregion/Olmstead_seq_DBG2OLC_e1_nomaxtarget -outfmt 6
```
Did also with `-max_target_seqs 1` and `-max_target_seqs 2` (`Olmstead_seq_DBG2OLC_e1_1maxtarget` and `Olmstead_seq_DBG2OLC_e1_2maxtarget`).
```
blastn -evalue 1e-1 -query /work/cauretc/2017_Mellotropicalis/pseudomolecules/filter/blast_find_SDregion/backbones_Olmstead_seq.fa -db /work/ben/2016_Hymenochirus/xenTro9/xenTro9_genome_HARDmasked_blastable -out /work/cauretc/2017_Mellotropicalis/pseudomolecules/filter/blast_find_SDregion/Olmstead_seq_DBG2OLC_trop_e1_1maxtarget -outfmt 6 -max_target_seqs 1

#Main results
#Backbone_169539 Chr02
#Backbone_177261 Chr04
#Backbone_116961 Chr07
#Backbone_105388 scaffold_150 
```
Also done without `-max_target_seqs`. Without it: `Backbone_177261` also matched against `Chr.07` and `scaffold_306` with high scores but pretty small length (~200bp).

```
zgrep "Backbone_116961" /4/caroline/Xmellotropicalis/backbone_raw_supercontig.index.gz
#10	Backbone_116961	27052721	27062574
zgrep "Backbone_105388" /4/caroline/Xmellotropicalis/backbone_raw_supercontig.index.gz
#9	Backbone_105388	49207921	49229080
zgrep "Backbone_169539" /4/caroline/Xmellotropicalis/backbone_raw_supercontig.index.gz
#14	Backbone_169539	12997041	13012403
zgrep "Backbone_177261" /4/caroline/Xmellotropicalis/backbone_raw_supercontig.index.gz
#14	Backbone_177261	126053601	126063025

vcftools --gzvcf Mellotrop_DBG2OLC_backbone_var.vcf.gz --chr "supercontig_10" --from-bp 27052721 --to-bp 27062574 --recode  --recode-INFO-all --out Mellotrop_Backbone_116961
#No data left for analysis!

vcftools --gzvcf Mellotrop_DBG2OLC_backbone_var.vcf.gz --chr "supercontig_9" --from-bp 49207921 --to-bp 49229080 --recode  --recode-INFO-all --out Mellotrop_Backbone_105388
#No data left for analysis!

vcftools --gzvcf Mellotrop_DBG2OLC_backbone_var.vcf.gz --chr "supercontig_14" --from-bp 12997041 --to-bp 13012403 --recode  --recode-INFO-all --out Mellotrop_Backbone_169539
#No data left for analysis!

vcftools --gzvcf Mellotrop_DBG2OLC_backbone_var.vcf.gz --chr "supercontig_14" --from-bp 126053601 --to-bp 126063025 --recode  --recode-INFO-all --out Mellotrop_Backbone_177261
#No data left for analysis!
```
Also did with `Mellotrop_DBG2OLC_backbone_var_DP_AD.vcf.gz`. No data either.

## Potential regions to amplify

(Notes from 5/01/2018)

- Directly using trop primers? or trying to use one of the de novo assemblies to design new ones and making sure it doesn't map everywhere in the genome?

Maybe worth it to try `For494:31633-32115` and `Rev494:31633-32115`

- `Backbone_116961` that had good match for `E32.M94.406` (1.9% recombination, Olmstead) blast and align well against region of `Chr07p`.

- `scaf2_149954800_r` (Bewick - 1 female specific site with forward `scaf2_149954039_f`) mapped `Backbone_196855` - maybe try to design a new forward or check on scaffold (trop scaff130 - but best map 7S for laevis). Blasting gave 2 results but only 1 with almost the whole primer size. Cannot use the reverse primer but can produce a new primer pair including where the old primer spanned.

```
Primer pair 10
        Sequence (5'->3')       Template strand Length  Start   Stop    Tm      GC%     Self complementarity    Self 3' complementarity
Forward primer  GGGCACTCACCAACTGAACT    Plus    20      5394    5413    60.18   55.00   3.00    1.00
Reverse primer  CCCCCTGGAAACCATACCAC    Minus   20      6303    6284    60.03   60.00   3.00    0.00
Product length  910
```

(Notes from 8/01/2018)

- Need to confirm at at least 1 `XY Chr.08` that it is a bioinformatics issue and not a real signal.

`scaffold_4751`. Need to include positions `2272-2279`.
```
Primer pair 4
	Sequence (5'->3')	Template strand	Length	Start	Stop	Tm	GC%	Self complementarity	Self 3' complementarity
Forward primer	CTGGCCTCTTTCCTCACACT	Plus	20	1465	1484	59.31	55.00	4.00	1.00
Reverse primer	AGTCCTCAGCGCAAACCTAA	Minus	20	2434	2415	59.31	50.00	4.00	1.00
Product length	970
```
Self complementarity a little bit high
```
Primer pair 3
	Sequence (5'->3')	Template strand	Length	Start	Stop	Tm	GC%	Self complementarity	Self 3' complementarity
Forward primer	GGAAGGGACATCTGCCATTGA	Plus	21	1857	1877	60.06	52.38	4.00	1.00
Reverse primer	CCTCAGCGCAAACCTAATGC	Minus	20	2431	2412	59.90	55.00	4.00	2.00
Product length	575

Primer pair 7
	Sequence (5'->3')	Template strand	Length	Start	Stop	Tm	GC%	Self complementarity	Self 3' complementarity
Forward primer	AGGGACATCTGCCATTGACT	Plus	20	1860	1879	58.71	50.00	4.00	1.00
Reverse primer	AGTCCTCAGCGCAAACCTAAT	Minus	21	2434	2414	59.72	47.62	4.00	2.00
Product length	575

Primer pair 9
	Sequence (5'->3')	Template strand	Length	Start	Stop	Tm	GC%	Self complementarity	Self 3' complementarity
Forward primer	TGGCTCCCTTGATTTTAGCCA	Plus	21	2042	2062	59.64	47.62	5.00	3.00
Reverse primer	CAGAGTCCTCAGCGCAAACC	Minus	20	2437	2418	61.29	60.00	4.00	0.00
Product length	396

Primer pair 13
	Sequence (5'->3')	Template strand	Length	Start	Stop	Tm	GC%	Self complementarity	Self 3' complementarity
Forward primer	AAGGGACATCTGCCATTGACT	Plus	21	1859	1879	59.36	47.62	4.00	1.00
Reverse primer	GCAGAGTCCTCAGCGCAAA	Minus	19	2438	2420	60.67	57.89	6.00	2.00
Product length	580

Primer pair 18
	Sequence (5'->3')	Template strand	Length	Start	Stop	Tm	GC%	Self complementarity	Self 3' complementarity
Forward primer	GAAGGGACATCTGCCATTGAC	Plus	21	1858	1878	58.98	52.38	4.00	3.00
Reverse primer	TCCTCAGCGCAAACCTAATG	Minus	20	2432	2413	58.26	50.00	4.00	1.00
Product length	575

Primer pair 19
	Sequence (5'->3')	Template strand	Length	Start	Stop	Tm	GC%	Self complementarity	Self 3' complementarity
Forward primer	ATGGCTCCCTTGATTTTAGCCA	Plus	22	2041	2062	60.02	45.45	5.00	3.00
Reverse primer	GTCCTCAGCGCAAACCTAAT	Minus	20	2433	2414	58.26	50.00	4.00	2.00
Product length	393

Primer pair 22
	Sequence (5'->3')	Template strand	Length	Start	Stop	Tm	GC%	Self complementarity	Self 3' complementarity
Forward primer	GGGAAGGGACATCTGCCATTG	Plus	21	1856	1876	61.03	57.14	4.00	3.00
Reverse primer	GCAGAGTCCTCAGCGCAAAC	Minus	20	2438	2419	61.91	60.00	6.00	0.00
Product length	583
```
Tried `min 200` `max 1000` for product length and `Forward primer from 1500` and `Reverse primer to 3000` but no better primer pairs than before (without limit of size and primers return `40` and more). Should probably go with the 1st one called `Primer pair 4` for now.

Want to go with `Primer pair 4` and `Primer pair 7` to make sure I get this region.

- `scaffold_262360`

Primers using Geneious (difficulties using primer-blast from NCBI). Best seem
```
ATGCCCCAAACCATGACCAT
ATAATGCCGGGGGTAATGCC
```
Product size 526 (508 -> 1033)

- `scaffold_159590` (ZW Chr.07) - position 669

`PCR product size 100-100`, `Forward primer From 400`, `Reverse primer To 900`, `# of primers to return 20`.

```
Primer pair 7
	Sequence (5'->3')	Template strand	Length	Start	Stop	Tm	GC%	Self complementarity	Self 3' complementarity
Forward primer	AGCGGTGTTAACCCTATTGGT	Plus	21	529	549	59.37	47.62	6.00	2.00
Reverse primer	GGGCAAAATCCTGCTCTCAATG	Minus	22	847	826	60.16	50.00	4.00	3.00
Product length	319

Primer pair 11
	Sequence (5'->3')	Template strand	Length	Start	Stop	Tm	GC%	Self complementarity	Self 3' complementarity
Forward primer	CCAATAGGGTTTCGCTTCACC	Plus	21	571	591	59.26	52.38	4.00	2.00
Reverse primer	ACCTTCCTTTGGACTAGCCATT	Minus	22	767	746	59.35	45.45	6.00	2.00
Product length	197

Primer pair 13
	Sequence (5'->3')	Template strand	Length	Start	Stop	Tm	GC%	Self complementarity	Self 3' complementarity
Forward primer	GGACCAATAGGGTTTCGCTTC	Plus	21	568	588	58.99	52.38	4.00	0.00
Reverse primer	GACATAGGGCAAAATCCTGCT	Minus	21	853	833	58.34	47.62	4.00	2.00
Product length	286

Primer pair 17
	Sequence (5'->3')	Template strand	Length	Start	Stop	Tm	GC%	Self complementarity	Self 3' complementarity
Forward primer	ACGGTTTAAGCTATAGCGGTGT	Plus	22	515	536	59.83	45.45	8.00	2.00
Reverse primer	TAGGGCAAAATCCTGCTCTCAAT	Minus	23	849	827	60.05	43.48	6.00	2.00
Product length	335

```
Best: `Primer pair 13`

- `scaffold_9128` (XY Chr.08) - positions 1716, 1729, 1759

`Forward primer From 1500`, `Reverse primer To 1900`

```
Primer pair 4
	Sequence (5'->3')	Template strand	Length	Start	Stop	Tm	GC%	Self complementarity	Self 3' complementarity
Forward primer	CAGCAGGTGTGCTATTGCTA	Plus	20	1514	1533	57.97	50.00	4.00	2.00
Reverse primer	CCTAATGCATGGGTCCCCTTA	Minus	21	1784	1764	59.22	52.38	6.00	2.00
Product length	271

Primer pair 5
	Sequence (5'->3')	Template strand	Length	Start	Stop	Tm	GC%	Self complementarity	Self 3' complementarity
Forward primer	CCTAGTGTCCGGAGTGAATGC	Plus	21	1673	1693	60.47	57.14	6.00	2.00
Reverse primer	GTGAACCAAATACAGTGAGCCC	Minus	22	1891	1870	59.51	50.00	3.00	2.00
Product length	219

Primer pair 7
	Sequence (5'->3')	Template strand	Length	Start	Stop	Tm	GC%	Self complementarity	Self 3' complementarity
Forward primer	AGGTGTGCTATTGCTACAGTCC	Plus	22	1518	1539	60.09	50.00	6.00	2.00
Reverse primer	CTCATACCACTGGTGTCTGCTT	Minus	22	1856	1835	60.03	50.00	7.00	0.00
Product length	339

Primer pair 9
	Sequence (5'->3')	Template strand	Length	Start	Stop	Tm	GC%	Self complementarity	Self 3' complementarity
Forward primer	ACCTAGTGTCCGGAGTGAATG	Plus	21	1672	1692	59.17	52.38	6.00	0.00
Reverse primer	AGTGAGCCCTCAATGCTTATCA	Minus	22	1878	1857	59.49	45.45	6.00	3.00
Product length	207

Primer pair 12
	Sequence (5'->3')	Template strand	Length	Start	Stop	Tm	GC%	Self complementarity	Self 3' complementarity
Forward primer	AACAGCAGGTGTGCTATTGCTA	Plus	22	1512	1533	60.29	45.45	6.00	2.00
Reverse primer	AGCTCATGCTAGCTCAACTCT	Minus	21	1826	1806	58.89	47.62	6.00	3.00
Product length	315

Primer pair 13
	Sequence (5'->3')	Template strand	Length	Start	Stop	Tm	GC%	Self complementarity	Self 3' complementarity
Forward primer	GTGCTATTGCTACAGTCCACCA	Plus	22	1522	1543	60.35	50.00	4.00	1.00
Reverse primer	TGCTTCCTGTACTAGCTCATGC	Minus	22	1839	1818	60.16	50.00	4.00	2.00
Product length	318

Primer pair 15
	Sequence (5'->3')	Template strand	Length	Start	Stop	Tm	GC%	Self complementarity	Self 3' complementarity
Forward primer	CCCTACCTAGTGTCCGGAGTG	Plus	21	1668	1688	61.02	61.90	6.00	0.00
Reverse primer	GTGAGCCCTCAATGCTTATCAC	Minus	22	1877	1856	59.38	50.00	6.00	1.00
Product length	210

Primer pair 16
	Sequence (5'->3')	Template strand	Length	Start	Stop	Tm	GC%	Self complementarity	Self 3' complementarity
Forward primer	CTAGTGTCCGGAGTGAATGC	Plus	20	1674	1693	58.07	55.00	6.00	2.00
Reverse primer	TGAACCAAATACAGTGAGCCC	Minus	21	1890	1870	58.21	47.62	3.00	2.00
Product length	217

Primer pair 18
	Sequence (5'->3')	Template strand	Length	Start	Stop	Tm	GC%	Self complementarity	Self 3' complementarity
Forward primer	ACCCTACCTAGTGTCCGGAGT	Plus	21	1667	1687	61.47	57.14	6.00	2.00
Reverse primer	AGCCCTCAATGCTTATCACTCA	Minus	22	1874	1853	59.49	45.45	3.00	3.00
Product length	208

Primer pair 19
	Sequence (5'->3')	Template strand	Length	Start	Stop	Tm	GC%	Self complementarity	Self 3' complementarity
Forward primer	GGCTCCATTTCTTTGAACCCT	Plus	21	1651	1671	58.47	47.62	3.00	0.00
Reverse primer	TGAGCCCTCAATGCTTATCACT	Minus	22	1876	1855	59.49	45.45	6.00	3.00
Product length	226

```
Best: `Primer pair 13`

- `scaffold_60594` (XY Chr.08) - positions 4849, 4850, 4913

```
Primer pair 14
	Sequence (5'->3')	Template strand	Length	Start	Stop	Tm	GC%	Self complementarity	Self 3' complementarity
Forward primer	AGACCCATTAGGCACACAGA	Plus	20	4714	4733	58.34	50.00	3.00	0.00
Reverse primer	ACGTGGCACACAAATTATCGG	Minus	21	5086	5066	59.53	47.62	5.00	1.00
Product length	373

Primer pair 8
	Sequence (5'->3')	Template strand	Length	Start	Stop	Tm	GC%	Self complementarity	Self 3' complementarity
Forward primer	ACCCCAAACAAAGCATACGGA	Plus	21	4870	4890	60.20	47.62	2.00	2.00
Reverse primer	CGTGGCACACAAATTATCGGG	Minus	21	5085	5065	60.20	52.38	5.00	1.00
Product length	216
```

Best `Primer pair 14` - large masked region

- `scaffold_110653` (XY Chr.08) - positions 952, 953

```
Primer pair 3
	Sequence (5'->3')	Template strand	Length	Start	Stop	Tm	GC%	Self complementarity	Self 3' complementarity
Forward primer	ACAGGGAATGGACCCCAAGA	Plus	20	904	923	60.48	55.00	3.00	0.00
Reverse primer	ATGCTCCACAGATGTTGCGT	Minus	20	1380	1361	60.32	50.00	4.00	2.00
Product length	477

Primer pair 4
	Sequence (5'->3')	Template strand	Length	Start	Stop	Tm	GC%	Self complementarity	Self 3' complementarity
Forward primer	ATCGAGCACCTTGCAACACA	Plus	20	804	823	60.53	50.00	6.00	0.00
Reverse primer	GTGAGGAGCGCCGATAAGAT	Minus	20	1135	1116	59.68	55.00	4.00	2.00
Product length	332

Primer pair 5
	Sequence (5'->3')	Template strand	Length	Start	Stop	Tm	GC%	Self complementarity	Self 3' complementarity
Forward primer	GAAGGGGGAGGGCTACTGAA	Plus	20	861	880	60.62	60.00	2.00	1.00
Reverse primer	CTGCTCTGCTAGACCACCAA	Minus	20	1305	1286	59.39	55.00	6.00	1.00
Product length	445

Primer pair 8
	Sequence (5'->3')	Template strand	Length	Start	Stop	Tm	GC%	Self complementarity	Self 3' complementarity
Forward primer	AGGGGGAGGGCTACTGAAAG	Plus	20	863	882	60.62	60.00	2.00	1.00
Reverse primer	TCTTGGAACATGATCGGCCT	Minus	20	1227	1208	59.09	50.00	6.00	2.00
Product length	365

Primer pair 9
	Sequence (5'->3')	Template strand	Length	Start	Stop	Tm	GC%	Self complementarity	Self 3' complementarity
Forward primer	ATGGAACAGGGAATGGACCC	Plus	20	899	918	59.37	55.00	3.00	2.00
Reverse primer	CGTATACCTCTGAGCCAGCA	Minus	20	1363	1344	58.97	55.00	6.00	2.00
Product length	465
Primer pair 10
	Sequence (5'->3')	Template strand	Length	Start	Stop	Tm	GC%	Self complementarity	Self 3' complementarity
Forward primer	GCACCTTGCAACACAGATCA	Plus	20	809	828	59.05	50.00	6.00	2.00
Reverse primer	AGTGAGGAGCGCCGATAAGA	Minus	20	1136	1117	60.75	55.00	4.00	0.00
Product length	328

```
Best: Primer pair 3

- `scaffold_119447` (XY Chr.08) - positions 108, 125

`PCR product size Min 1 Max 1000`


```
Primer pair 2
	Sequence (5'->3')	Template strand	Length	Start	Stop	Tm	GC%	Self complementarity	Self 3' complementarity
Forward primer	ACCGTATGTCAAGTGAGCAGG	Plus	21	66	86	60.07	52.38	4.00	0.00
Reverse primer	TTCTCGGACTCGTGTTGCAG	Minus	20	432	413	60.32	55.00	4.00	2.00
Product length	367

Primer pair 4
	Sequence (5'->3')	Template strand	Length	Start	Stop	Tm	GC%	Self complementarity	Self 3' complementarity
Forward primer	TACCGTATGTCAAGTGAGCAGG	Plus	22	65	86	59.83	50.00	5.00	0.00
Reverse primer	TGGCACTTCGTGGTAATGGC	Minus	20	288	269	60.96	55.00	3.00	2.00
Product length	224

Primer pair 7
	Sequence (5'->3')	Template strand	Length	Start	Stop	Tm	GC%	Self complementarity	Self 3' complementarity
Forward primer	CGTATGTCAAGTGAGCAGGT	Plus	20	68	87	57.63	50.00	4.00	1.00
Reverse primer	CTCGGACTCGTGTTGCAGTAT	Minus	21	430	410	60.14	52.38	4.00	2.00
Product length	363

Primer pair 16
	Sequence (5'->3')	Template strand	Length	Start	Stop	Tm	GC%	Self complementarity	Self 3' complementarity
Forward primer	ATACCGTATGTCAAGTGAGCAGG	Plus	23	64	86	60.18	47.83	7.00	0.00
Reverse primer	ACCACGGAAGCCCTTCTATT	Minus	20	312	293	58.71	50.00	6.00	2.00
Product length	249
```
Best: Primer pair 7

- `scaffold_157504` (XY Chr.08) - positions 346, 363

```
Primer pair 4
	Sequence (5'->3')	Template strand	Length	Start	Stop	Tm	GC%	Self complementarity	Self 3' complementarity
Forward primer	TTATTACTGTGGGTGGAGGGGA	Plus	22	119	140	60.23	50.00	3.00	0.00
Reverse primer	AGCAGCAATCTGTCTCATGGTT	Minus	22	448	427	60.29	45.45	4.00	1.00
Product length	330
```

- `scaffold_1906` (XY Chr.08) - positions 4406, 4435

```
Primer pair 9
	Sequence (5'->3')	Template strand	Length	Start	Stop	Tm	GC%	Self complementarity	Self 3' complementarity
Forward primer	GGCGCCAAAATTAGATCCAACAA	Plus	23	4156	4178	60.37	43.48	6.00	0.00
Reverse primer	ATCCCATGCATTGCTTTGATGA	Minus	22	4501	4480	58.96	40.91	6.00	3.00
Product length	346

Primer pair 10
	Sequence (5'->3')	Template strand	Length	Start	Stop	Tm	GC%	Self complementarity	Self 3' complementarity
Forward primer	GCGCCAAAATTAGATCCAACAAC	Plus	23	4157	4179	59.39	43.48	6.00	0.00
Reverse primer	CCTATCCCATGCATTGCTTTGA	Minus	22	4504	4483	59.04	45.45	6.00	3.00
Product length	348

Primer pair 17
	Sequence (5'->3')	Template strand	Length	Start	Stop	Tm	GC%	Self complementarity	Self 3' complementarity
Forward primer	CGCCAAAATTAGATCCAACAACCT	Plus	24	4158	4181	60.08	41.67	6.00	0.00
Reverse primer	CTAGAGGTAACCCTATCCCATGC	Minus	23	4515	4493	59.48	52.17	7.00	2.00
Product length	358

Primer pair 28
	Sequence (5'->3')	Template strand	Length	Start	Stop	Tm	GC%	Self complementarity	Self 3' complementarity
Forward primer	ATACCAAGAACCCCTGTGAAAATG	Plus	24	4133	4156	59.23	41.67	2.00	0.00
Reverse primer	CTATCCCATGCATTGCTTTGATGA	Minus	24	4503	4480	59.72	41.67	6.00	3.00
Product length	371

```
Best: `Primer pair 28`

- `scaffold_7061` needs to include positions `4335` (mom SNP not sex-linked) and `4345` (partially sex-linked with GBS data)

```
Primer pair 3
	Sequence (5'->3')	Template strand	Length	Start	Stop	Tm	GC%	Self complementarity	Self 3' complementarity
Forward primer	AACAGCCAGTGTTTCCCTTTG	Plus	21	4077	4097	59.24	47.62	4.00	0.00
Reverse primer	GCGAGACAAGGCAGAGTTTTT	Minus	21	4474	4454	59.40	47.62	2.00	0.00
Product length	398

Primer pair 12
	Sequence (5'->3')	Template strand	Length	Start	Stop	Tm	GC%	Self complementarity	Self 3' complementarity
Forward primer	AAAAACTGTCCAACTGCACCC	Plus	21	3649	3669	59.52	47.62	4.00	0.00
Reverse primer	AATGAGAAGGCGAGACAAGGC	Minus	21	4483	4463	60.68	52.38	2.00	2.00
Product length	835
```

Want to try `Primer pair 12` in priority. 

## Some notes/comments

### Meeting 10/01 with BE:
- need to add coordinates on table 

- designing primers for scaffolds with SNPs (matching against chr.07 and chr.08) ~10scaffolds

