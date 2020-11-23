

def forward_fasta_generator(input_file, output_file):
	
	#make an empty list to caputre new sequence data
	seq_to_write = []
	
	with open(input_file, "rU") as fasta_prot:
		sequences = list(SeqIO.parse(fasta_prot, "fasta"))
	
	
	
	for i in range(0, len(sequences), 2):
		seq_to_write.append(sequences[i])
		
	with open (output_file, "w") as new_fasta:
		SeqIO.write(seq_to_write, new_fasta, "fasta")

		
	return 0	

forward_fasta_generator(snakemake.input, snakemake.output)
