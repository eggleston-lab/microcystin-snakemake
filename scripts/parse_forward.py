#!/bin/env/python

import os
import glob
from Bio import SeqIO

metagenome = "/storage/eggleston-research/metagenomes/CB_VirMetaG_FD1.proteins.faa"

with open(metagenome, "r") as fasta:
    sequences = list(SeqIO.parse(fasta, "fasta"))

print(sequences[0])
		
	
		
