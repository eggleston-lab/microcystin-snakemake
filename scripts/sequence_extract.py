#!/bin/env/python3

#importing libraries
import os
import csv
import glob
#establishes a list that contains the absolute paths of all CSV files that need to be extracted
CSVS = []

for f in glob.glob("/home/mbrockley/snakemake/outputs/mcy*/*.tblout.csv"):
	CSVS.append(f)

#first esl index.ssi assmebly code

for meta_prot in glob.glob("/storage/eggleston-research/metagenomes/*.proteins.faa"):
	esl_command1 = "esl-sfetch --index " + meta_prot  
	os.system(esl_command1)



#loop through CSV files and generate a string of parameters to pass to esl-sfetch

for sheet in CSVS:
	with open(sheet, 'r') as Sequence_ID:
		csv_read_dict = csv.DictReader(Sequence_ID)
		Sequence_list = []
		for row in csv_read_dict:
			Sequence_list.append(row['domain_name'])
		Sequence_ID.close()
	split = os.path.splitext(os.path.splitext(sheet)[0])[0]
	basename = os.path.basename(split)
	with open(split + ".list", "w+") as list_file:
		for sequence in Sequence_list:
			list_file.write(sequence + "\n")
		list_file.close()
	#run esl-sfetch for the list file
	
	input_fasta = "/storage/eggleston-research/metagenomes/" + basename + ".proteins.faa"
	output_fasta = split + ".filtered.hits.faa"
	esl_command2 = "esl-sfetch -f " + input_fasta + " " + split + ".list" +  " > " + output_fasta
	os.system(esl_command2)
			
		

