# gene-finder
Snakemake for hmmer searches

Provided some alignment this pipeline will generate an hmmer profile and then use hmmer search against any protein sequence set. 
We can also automate the creation of an e value table.

in submit_script is the loca_submit_snakemake.sh which you used to run scavenger environment submissions

in inputs is the genelist which needs to be edited to tell Snakemake what genes to run searches on

In the config.yaml the gene_list to use is specified (you could do a test and run smaller portion)

