
filter_hmmer_data <- function(input_path, output_csv, output_list) {
  library(rhmmer)
  library(tidyverse)
  
  #reading in tblout data using rhmmer
  tblout <- read_tblout(input_path)
  
  #create object to contain filtered domain names and evalues
  seq_eval <- tblout %>% 
    filter(sequence_evalue < 1.0e-10) %>% 
    select(domain_name, sequence_evalue)
  
  #write seq_eval to a csv file
  write.csv(seq_eval, file = output_csv)
  
  #create object to contain just domain names
  seq_name <- seq_eval %>% 
    select(domain_name)
  
  #write object to list file for esl tools
  write.table(seq_name, file = output_list, quote = FALSE, sep = '\n', row.names = FALSE, col.names = FALSE)
}

#execute for snakemake
filter_hmmer_data(snakemake@input[["table"]], snakemake@output[["csv"]], snakemake@output[["list"]])
