
#libraries
library(rhmmer)
library(tidyverse)
library(rjson)

#reading tabular HMMER output files

#path to output data

path = "/home/mbrockley/snakemake/outputs/"

genes <- c(paste(path,"mcyA/",sep = ""), paste(path,"mcyB/",sep = ""), paste(path,"mcyC/",sep = ""), paste(path,"mcyD/",sep = ""))

#looping thorugh each gene
for(i in 1:length(genes)){
	file.names <- dir(genes[i], pattern = ".tblout")
	for(t in 1:length(file.names)){
		#reading in the tblout file for each gene and each metagenome
		tblout <- read_tblout(paste(genes[i], file.names[t], sep = ""))
		#filtering results with e-values less than or equal to 1.0e-5
		seq_names <- tblout %>%
			filter(sequence_evalue <= 1.0e-5)%>%
			select(domain_name, sequence_evalue)
		write.csv(seq_names, paste(genes[i],file.names[t],".csv",sep = ""))
	}
}
			
