## GTSeq ####

library(tidyverse)
library(adegenet)

# A. Uploading the csv file
gtseq <- read.csv("../../Data/Genetic/GTSeq 2024 UofI YCT Genotypes Table 20240531.xlsx - GY2024 UofI YCT Trays.csv",
                  header = T) ## 718 cols - 10 of metadata= 708/2 = 840 SNPs?


# B. Converting to a "genetic" object - solution thanks to https://groups.google.com/g/poppr/c/i8EKe9b0_b

library(adegenet)

## B.1. Creating a df with the expected format for the function, i.e. each locus in a column with a1:a2
gtseq.geninfo <- gtseq[ ,11:ncol(gtseq)]
# Keeping the 1st and 2nd alleles in different df's
allele1 <-as.matrix(gtseq.geninfo[,seq(1,ncol(gtseq.geninfo)-1, by = 2)])
allele2 <-as.matrix(gtseq.geninfo[,seq(2,ncol(gtseq.geninfo), by = 2)])

# Combining them in a single df
gtseq.geninfo.onecol <-as.data.frame(matrix(paste(allele1, allele2, sep = ":"), ncol = ncol(gtseq.geninfo)/2))

# Assigning colnames without the .A1 or 2 and removing any "." that may be present in the loci names
colnames(gtseq.geninfo.onecol) <- str_remove(colnames(allele1), ".A[12]")
colnames(gtseq.geninfo.onecol) <- sub("\\.", "_", colnames(gtseq.geninfo.onecol))

## B2. From df to genind object

gtseq.genind <- df2genind(gtseq.geninfo.onecol, sep= ":") ## worked
