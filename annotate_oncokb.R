#
# Set ONCOKB_DB_FILE to point to whereever the
# oncokb database file is installed
#
# The following code tries to figure out that
# locaiton of this script file to get the path
# implicitly
#

SDIR=grep("--file=",commandArgs(trailingOnly=F),value=T)
if(length(SDIR)>0) {
    SDIR=normalizePath(dirname(gsub("--file=","",SDIR)))
} else {
    SDIR="."
}

ONCOKB_DB_FILE=file.path(SDIR,"data/oncokb.db.v230119.rds")

read_oncokb_db <- function(ofile=ONCOKB_DB_FILE) {

    readRDS(ofile)

}

oncoKbDb=read_oncokb_db()

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

    header=c(header,paste("#argos-annote:",VERSION,"oncodb:",basename(ONCOKB_DB_FILE)))
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

VERSION="1.1.1"

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
if(length(args)<1) {
    cat("\n   usage: annotate_oncokb.R INPUT_MAF_FILE [OUTPUT_MAF_FILE]\n\n")
    cat("      OUTPUT_MAF_FILE is optional and if not supplied will be derived\n")
    cat("                      input file name and written in same folder as input\n\n")
    quit()
}

inputMaf=args[1]

if(length(args)==1) {
    outputMaf=gsub("\\.[^.]*$",".oncokb.maf",inputMaf)
} else {
    outputMaf=args[2]
}

params=list(
    VERSION=VERSION,
    ONCOKB_DB_FILE=ONCOKB_DB_FILE,
    inputMaf=inputMaf,
    outputMaf=outputMaf
)

db=read_oncokb_db()
maf=read_maf(inputMaf)
omaf=annotate_maf_oncokb(maf$maf)
write_maf(omaf,outputMaf,maf$header)

write_json(params,paste0(outputMaf,".json"),auto_unbox=T)
