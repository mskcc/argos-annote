# ArgosAnnote

Various annotation tools for Argos Pipeline

```
usage:

Rscript annotate_oncokb.R INPUT_MAF [OUTPUT_MAF.maf]

    INPUT_MAF.maf must be a properly formatted MAF file.

    If OUTPUT_MAF.maf is specific it is used for the output file
    if not then the OUTPUT_MAF = INPUT_MAF.oncokb.maf

    Additionally a file called OUTPUT_MAF.json will be written with
    a list of parameters that were used in the run
```