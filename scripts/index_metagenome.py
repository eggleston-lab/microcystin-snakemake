#!/bin/env/python3

#define function to carry out metagenome indexing

from Bio import SeqIO
from Bio.SeqRecord import SeqRecord
import os

def index_metagenome(metagenome, cleaned_file):
	data_to_write = []
	
	#read in metagenome as a list of sequences
	with open(metagenome, "r") as fasta:
		sequences = list(SeqIO.parse(fasta, "fasta"))
	fasta.close()
	
	#loop through sequences changing the sequence name and ID
	for i in range(0, len(sequences)):
		
		#modify the sequence ID with the sequence index
		sequences[i].id = str(sequences[i].id) + ":" + str(i)
		
		#build sequence record
		seq_obj = SeqRecord(sequences[i].seq, id = sequences[i].id)
		data_to_write.append(seq_obj)
	
	#write the data to a new fasta file
	with open(cleaned_file, "w") as index_fasta:
		SeqIO.write(data_to_write, "fasta")
	index_fasta.close()


index_metagenome(snakemake.input, snakemake.output)
	
