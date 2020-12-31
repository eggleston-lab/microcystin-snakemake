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
		SeqIO.write(data_to_write, index_fasta, "fasta")
	index_fasta.close()



path = "/storage/eggleston-research/metagenomes/"
oldext = ".proteins.faa"
newext = ".index.proteins.faa"
metagenome = ["CB_VirMetaG_FD1",
	"CB_VirMetaG_FD2",
	"CB_VirMetaG_FD3",
	"Fa13VDMM110DN_FD",
	"Fa13VDMM110SN_FD",
	"LakEricontroER36_FD",
	"LakEriepJuly2011",
	"NOAtaG_3_FD",
	"NOAtaG_6_FD",
	"NOAtaG_7_FD",
	"NOAtaG_FD",
	"Su13VDMM110SN_FD"]
	

for genome in metagenome:
	index_metagenome(path + genome + oldext, path + genome + newext)
