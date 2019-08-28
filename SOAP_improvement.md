# Rational

Reconsidering the previous pipeline.

Before we wanted to try to get a better contigs assembly to be able to use a chimerical approach for scaffolding. However the attempts have not been successful with some newer assemblies being half or less from the expected genome size. Another major issue is the resources required for a "successful" run and the stability of the server I am using... i.e. issues when need to run with a lot of memory requirement for a long time.
A more realistic approach is too use the assemblies we were previously able to make and improve them. We have multiple SOAP de novo assemblies that have a size without gap close to the expected genome size (3-3.5 Gb), with N50 ~ 10-11 kb. The main issue with these assemblies is the amount of missing data.

# Using other assemblies to close the gaps - [FGAP](https://github.com/pirovc/fgap)

We got multiple assemblies usinf SOAPdenovo2 (1 kmer approach, multiple kmer approach, mate libraries only for scaffolding, ...) that had promising statistics. Since the weaknesses from the different assemblies and maybe "good"/"bad" regions might be different and scaffolds a bit different.

```
./run_fgap.sh <MCR installation folder> -d <draft file> -a "<dataset(s) file(s)>" [parameters]
```

