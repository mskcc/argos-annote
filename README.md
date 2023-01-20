# ArgosAnnote

Various annotation tools for Argos Pipeline

```
usage:

Rscript annotate_oncokb.R DATABASE INPUT_MAF [OUTPUT_MAF]

    DATABASE        Annotation database file

    INPUT_MAF       must be a properly formatted MAF file.

    OUTPUT_MAF      if specific it is used for the output file
                    if not then then
                       OUTPUT_MAF = INPUT_MAF.oncokb.maf

    Additionally a file called OUTPUT_MAF.json will be written with
    a list of parameters that were used in the run
```