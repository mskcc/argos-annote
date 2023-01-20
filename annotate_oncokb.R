read_oncokb_db <- function(ofile) {

    readRDS(ofile)

}

read_maf <- function(mfile) {

    header=grep("^#",readLines(mfile,1000),value=T)
    if(length(header)==0) header=NULL
    maf=read_tsv(mfile,comment="#",col_types = cols(.default = "c"))

    list(maf=maf,header=header)

}

write_maf <- function(omaf,ofile,header=NULL) {

    if(is.null(header)) {
        header=c()
    }

    header=c(header,paste("#argos-annote:",VERSION,"oncodb:",basename(oncoKbDb)))
    write(header,ofile)
    write_tsv(omaf,ofile,append=T,col_names=T,na="")

}

annotate_maf_oncokb <- function(maf) {
    left_join(
        maf,
        db,
        by=c("Chromosome","Start_Position","End_Position","Reference_Allele","Tumor_Seq_Allele2")
    )
}

VERSION="1.3.1"

###############################################################################
# Dependancies
###############################################################################
suppressPackageStartupMessages({
    library(jsonlite)
    library(readr)
    library(dplyr)
})
###############################################################################
#
###############################################################################

args=commandArgs(trailing=T)
if(length(args)<2) {
    cat("\n   usage: annotate_oncokb.R ONCOKB_DB_FILE INPUT_MAF_FILE [OUTPUT_MAF_FILE]\n\n")
    cat("      ONCOKB_DB_FILE  OncoKb database in rds format\n")
    cat("      INPUT_MAF_FILE  Maf file to annotate\n")
    cat("      OUTPUT_MAF_FILE is optional and if not supplied will be derived\n")
    cat("                      input file name and written in same folder as input\n\n")
    quit()
}

oncoKbDb=args[1]
inputMaf=args[2]

if(length(args)==2) {
    outputMaf=gsub("\\.[^.]*$",".oncokb.maf",inputMaf)
} else {
    outputMaf=args[3]
}

params=list(
    VERSION=VERSION,
    ONCOKB_DB_FILE=oncoKbDb,
    inputMaf=inputMaf,
    outputMaf=outputMaf
)

db=read_oncokb_db(oncoKbDb)
maf=read_maf(inputMaf)
omaf=annotate_maf_oncokb(maf$maf)
write_maf(omaf,outputMaf,maf$header)

write_json(params,paste0(outputMaf,".json"),auto_unbox=T)
