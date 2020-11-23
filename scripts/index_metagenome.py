#!/bin/env/python3

#define function to carry out metagenome indexing

from Bio import SeqIO, SeqRecord
import os

def index_metagenome(metagenome):
	
	#read in metagenome as a list of sequences
	with open(metagenome, "r") as fasta:
		sequences = list(SeqIO.parse(fasta, "fasta")
	
	#loop through sequences changing the sequence name and ID
	for i in range(0, len(sequences):
		
		#modify the sequence ID with the sequence index
		sequences[i].id = str(sequences[i].id) + ":" + str(i)
		sequences[i].name = str(sequences[i].name) + ":" + str(i)
	
	print(sequences[0].id)
	print(sequences[0].name)
	print(sequences[0].seq)
	from Bio.SeqRecord import SeqRecord
	print(sequences[0].format("fasta"))


index_metagenome("/storage/eggleston-research/metagenomes/CB_WirMetaG_FD1.proteins.faa")
	
