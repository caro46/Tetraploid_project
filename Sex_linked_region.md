Using perl version `5.24.0` and specifying the necessary libraries
```
/usr/local/perl5.24/perl-5.24.0/perl -I /usr/local/perl5.24/perl-5.24.0/lib -I /home/caroline/programs/lib_perl5/List-MoreUtils-master/lib -I /home/caroline/programs/lib_perl5/p5-exporter-tiny-master/lib 1st_part_mellotrop.pl
```
Issues:
- Not a lot of SNP. Changing parameters for GATK, samtools 
- `1st_part_mellotrop.pl`: not a lot of sites and XY and ZW because of the threshold used for the error rate and match to multiple chromosomes. If we increase the threshold, nothing left.
- Need to see if it is because of undercall with GATK/samtools or a wrong identification of males/females? -> need to ask Ben if the sex was determined by surgery.
In paticular, need to check for 4175_girl and 4173_boy. The girl has much less data than the other individual (fq file much smaller) but not the boy. Confirmed the sex with BenF. 
- More sites that can be considered sex-linked if we considered threshold of 20% (compared with Hymenochirus and Pipa). 

Some of the most promissing sites.
```
#CHROM	POS	REF	3799_dad	3800_mom	3810_boy	4169_girl	4170_girl	4171_boy	4172_boy	4173_boy	4174_boy	4175_girl	4176_boy	4177_girl	4178_girl	4179_boy	4180_girl	4181_boy	4182_girl	4183_girl	4184_girl	4185_girl

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
```
`Backbone_64488` seems particularly interesting, let's blast it 1st.
```
awk -v seq="Backbone_64488" -v RS='>' '$1 == seq {print RS $0}' /4/caroline/Xmellotropicalis/GBS/samtools_genotypes/Sex_linked/Mellotrop_putative_sex_linked_polym1ratio0_HF.fa >/4/caroline/Xmellotropicalis/GBS/samtools_genotypes/Sex_linked/Mellotrop_putative_sex_linked_Backbone_64488.fa
```
```
blastn -evalue 1e-20 -query /4/caroline/Xmellotropicalis/GBS/samtools_genotypes/Sex_linked/Mellotrop_putative_sex_linked_Backbone_64488.fa -db /4/caroline/tropicalis_genome/Xtropicalis_v9_repeatMasked_HARD_MASK_blastable -out /4/caroline/Xmellotropicalis/GBS/samtools_genotypes/Sex_linked/Mellotrop_Backbone_64488_tropv9 -outfmt 6 -max_target_seqs 1
```
