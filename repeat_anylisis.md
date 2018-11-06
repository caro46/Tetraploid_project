# RepARK

Done on Graham

```
module load nixpkgs/16.09  intel/2016.4 jellyfish/2.2.6 velvet/1.2.10

/home/cauretc/project/cauretc/programs/RepARK/RepARK.pl -o /home/cauretc/scratch/RepARK_mello_analysis/ -p 8
```

# TEclass `TEclass-2.1.3`

Could not run it properly on Graham, run it on info; using the `contigs.fa` produced by RepARK

```
TEclass-2.1.3/TEclassTest.pl -r /4/caroline/Xmellotropicalis/repeat_analysis/contigs.fa -o /4/caroline/Xmellotropicalis/repeat_analysis 
```

```
less contigs.fa_1533303450/contigs.fa.stat

Repeat statistics:
DNA transposons: 287594
LTRs:  222851
LINEs: 35790
SINEs: 98484
Unclear:  267515

Total: 912234
```

# RepeatMasker `RepeatMasker version open-3.2.6`

```
sed 's/|TEclass result: /#/' contigs.fa.lib >Xmello_TEclass_repeatmaskerformat.fa
```
```
/usr/local/RepeatMasker/RepeatMasker -lib contigs.fa_1533303450/Xmello_TEclass_repeatmaskerformat.fa -dir /4/caroline/Xmellotropicalis/repeat_analysis -pa 4 scaffolds_NotSexLinked.fa
```
