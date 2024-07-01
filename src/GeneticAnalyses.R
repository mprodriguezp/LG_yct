## GTSeq ####

library(tidyverse)
library(adegenet)

# A. Uploading the csv file
gtseq <- read.csv("./data_raw/GTSeq 2024 UofI YCT Genotypes Table 20240531.csv",
                  header = T) ## 718 cols - 10 of metadata= 708/2 = 840 SNPs?

# B. Converting to a "genetic" object


## df2genind needs a sep argument, and I couldn't find which represents that data are in diff columns (not sure if it even exists). Besides that I get some errors about allele dosage (don't know what is that) and about detecting more than one . in the column names (it says that columns must be named as locus.allele, and the data is exactly like that, so I don't understand why it doesn't work)
#ts locus name has a"." in the middle, need to get rid of it.
gtseq.genind <- df2genind(gtseq[ ,-c(1:10)], sep= "") 

## Trying if only by keeping the SNPs (not mt- or "multi-nucleotide" polymorphisms) it works
gtseq.snps.example <- gtseq[ ,c(11:22)]
gtseq.snps.example.genind <- df2genind(gtseq.snps.example, ncode = 2) ## ncode tells it the number of chr that codes for one genotype. It doesn't work either

## Testing whether it needs the genotype to be in a single column (i.e. the two alleles cannot be in diff cols)

loci.examp <- data.frame("Gen1" = c("A:T","G:T"),
                               "Gen2" = c("G:C","A:A"),
                               "Gen3" = c("T:A","G:C"))
loci.examp.genind <- df2genind(loci.examp, sep= ":") ## It  worked, so we have to combine the alleles in a single column

## Trials of combining alleles into a single column:

### a. I couldn't find a function that automatically does that in the stringr package

### b. Do a loop that does that using the stringr package/regex
library(stringr)
gtseq.comb.alleles <-data.frame()

for (i in 1:ncol(gtseq)) {
  if (i %% 2 == 1){
    gene.id <- str_remove(colnames(gtseq[i]), ".A[12]")
    gtseq.comb.alleles[1,i] <- gene.id} 
  else{
    print("even")  
  }
} ## This for loop doesn't work because I am skiping the even positions of the df that will be the output. I don't have a lot of practice with loops yet so I couldn't figure it out 
