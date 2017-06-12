Using perl version `5.24.0` and specifying the necessary libraries
```
/usr/local/perl5.24/perl-5.24.0/perl -I /usr/local/perl5.24/perl-5.24.0/lib -I /home/caroline/programs/lib_perl5/List-MoreUtils-master/lib -I /home/caroline/programs/lib_perl5/p5-exporter-tiny-master/lib 1st_part_mellotrop.pl
```
Issues:
- Not a lot of SNP. Changing parameters for GATK, samtools 
- `1st_part_mellotrop.pl`: not a lot of sites and XY and ZW because of the threshold used for the error rate and match to multiple chromosomes. If we increase the threshold, nothing left.
- Need to see if it is because of undercall with GATK/samtools or a wrong identification of males/females? -> need to ask Ben if the sex was determined by surgery.


