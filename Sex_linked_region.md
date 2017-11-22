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
**To do**:
Need to improve the part 1 to find the sex-linked sites. Because of the 20% errors allowed, a lot of sites showing up, when are manually checked are most likely not sex-linked. If increase the threshold, nothing show up. The best sites that actually look sex-linked are the ones mentioned before (Heterozygous_sons_dad_XY matching against trop 6)

**For discussion with BE on Nov. 22:**

- Should not use the DBG2OLC assembly yet (need to run the last step of correction). Inter-chromosomal chimerical errors?

- Should probably do it again using the Allpaths assembly to map the reads. + samtools

- Maybe easier to have 1st a better assembly than trying to include *X. mellotropicalis* in the same paper as *Hymenochirus* and *Pipa*.

- For now 2 chromosomes seem maybe interesting chr. 08 (XY) and chr. 07 (ZW)

