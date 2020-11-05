#----Matt Microcystin Gene Finder----#

configfile: "/home/mbrockley/snakemake/config.yaml"

import io
import os
import glob
import pandas as pd
import numpy as np
import pathlib
from snakemake.exceptions import print_exception, WorkflowError

#----SET VARIABLES----#
PROTEIN_DIR = config['protein_dir'] #metagenomes in this directory
ALIGNMENT_DIR = config['alignment_dir']
OUTPUT_DIR = config['output_dir']
GENEFILE = config['gene_list']
genelist = []
with open(GENEFILE, 'r') as f:
    for line in f:
        genelist.append(line.strip())
#metagenomes go here
SAMPLES = [os.path.basename(f).replace(".proteins.faa", "") for f in glob.glob(PROTEIN_DIR + "/*.proteins.faa")]
METAGENOMES = [os.path.basename(name).replace(".fastq.gz", "") for name in glob.glob(PROTEIN_DIR + "/*.fastq.gz")]

#----RULES----#


rule all:
    input:
        convert = expand('{meta}/{genome}.fasta', meta = PROTEIN_DIR, genome = METAGENOMES),
        prodigal = expand('{meta}/{genome}.proteins.faa', meta = PROTEIN_DIR, genome = METAGENOMES),
	parse = expand('{meta}/{genome}.forward.proteins.faa', meta = PROTEIN_DIR, genome = METAGENOMES),
        hmmbuild =  expand('{base}/{gene}/alignment-profile.hmm', base = ALIGNMENT_DIR, gene = genelist), 
        hmmsearch = expand('{base}/hmm_results/{gene}/{sample}.forward.hmmout', base = OUTPUT_DIR, gene = genelist, sample = SAMPLES ) 
        
 
rule convert:
    input: archive = PROTEIN_DIR + "/{genome}.fastq.gz"
    output: fasta = PROTEIN_DIR + "/{genome}.fasta"
    conda:
        "env/seqtk.yaml"
    shell:
        """
        seqtk seq -a {input.archive} > {output.fasta}
        """

rule prodigal:
    input: dna = PROTEIN_DIR + "/{genome}.fasta"
    output: amino = PROTEIN_DIR + "/{genome}.proteins.faa"
    conda:
        "env/prodigal.yaml"
    shell:
        """
        prodigal -i {input.dna} -a {output.amino} 
        """

rule parse:
    input: protein = PROTEIN_DIR + "/{genome}.proteins.faa"
    output: forward = PROTEIN_DIR + "/{genome}.forward.proteins.faa"
    conda:
        "env/biopython.yaml"
    script:
        "scripts/parser.py"

rule hmmbuild:
    input: alignment = ALIGNMENT_DIR + "/{gene}/protein-alignment.fas"
    output: hmm = ALIGNMENT_DIR + "/{gene}/alignment-profile.hmm"
    conda: 
        "env/hmmer.yaml"
    shell:
        """
        hmmbuild {output.hmm} {input.alignment} 
        """

rule hmmsearch:
    input: 
        proteins = PROTEIN_DIR + "/{sample}.forward.proteins.faa", 
        hmm = ALIGNMENT_DIR + "/{gene}/alignment-profile.hmm"
    output: 
        hmmout = OUTPUT_DIR + "/hmm_results/{gene}/{sample}.forward.hmmout",
        tblout = OUTPUT_DIR + "/hmm_results/{gene}/{sample}.forward.tblout" 
    params:
        all = "--cpu 2 --tblout"
    conda:
        "env/hmmer.yaml"
    shell:
        """
        hmmsearch {params.all} {output.tblout} {input.hmm} {input.proteins} > {output.hmmout}  
        """

