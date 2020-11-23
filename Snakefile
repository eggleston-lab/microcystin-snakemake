#----Matt Microcystin Gene Finder----#

configfile: "/home/mbrockley/snakemake/config/config.yaml"

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
OUTPUT_LIST = config['small_outputs']
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
	parse = expand('{meta}/{genome}.index.proteins.faa', meta = PROTEIN_DIR, genome = METAGENOMES),
        hmmbuild =  expand('{base}/{gene}/alignment-profile.hmm', base = ALIGNMENT_DIR, gene = genelist), 
        hmmsearch = expand('{base}/hmm_results/{gene}/{sample}.index.hmmout', base = OUTPUT_DIR, gene = genelist, sample = SAMPLES),
        eval_filter = expand('{base}/{gene}/{sample}.index.csv', base = OUTPUT_LIST, gene = genelist, sample = METAGENOMES),
        easel_profile = expand('{meta}/{genome}.index.proteins.faa', meta = PROTEIN_DIR, genome = METAGENOMES),
        easel_fetch = expand('{base}/{gene}/{sample}.filtered.hits.fasta', base = OUTPUT_LIST, gene = genelist, sample = METAGENOMES) 
        
 
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
    output: clean = PROTEIN_DIR + "/{genome}.index.proteins.faa"
    conda:
        "env/biopython.yaml"
    script:
        "scripts/index_metagenomes.py"
        

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
        proteins = PROTEIN_DIR + "/{sample}.index.proteins.faa", 
        hmm = ALIGNMENT_DIR + "/{gene}/alignment-profile.hmm"
    output: 
        hmmout = OUTPUT_DIR + "/hmm_results/{gene}/{sample}.index.hmmout",
        tblout = OUTPUT_DIR + "/hmm_results/{gene}/{sample}.index.tblout" 
    params:
        all = "--cpu 2 --tblout"
    conda:
        "env/hmmer.yaml"
    shell:
        """
        hmmsearch {params.all} {output.tblout} {input.hmm} {input.proteins} > {output.hmmout}  
        """

rule eval_filter:
    input:
        table = OUTPUT_DIR + "/hmm_results/{gene}/{sample}.index.tblout"
    output:
        csv = OUTPUT_LIST + "/{gene}/{sample}.filtered.csv",
        list = OUTPUT_LIST + "/{gene}/{sample}.list"
    script:
        "scripts/parse.R"

rule easel_profile:
    input:
        filtered_protein = PROTEIN_DIR + "/{sample}.index.proteins.faa"
    output:
        index = PROTEIN_DIR + "/{sample}.index.proteins.faa.ssi"
    conda:
        "env/easel.yaml"
    shell:
        """
        esl-sfetch --index {input.filtered_protein}
        """

rule easel_fetch:
    input:
        ssi = PROTEIN_DIR + "/{sample}.index.proteins.faa.ssi",
        search_space = PROTEIN_DIR + "/{sample}.index.proteins.faa",
        seq_list = OUTPUT_LIST + "/{gene}/{sample}.list"
    output:
        hits = OUTPUT_LIST + "/{gene}/{sample}.filtered.hits.fasta"
    conda:
        "env/easel.yaml"
    shell:
        """
        esl-sfetch -f {input.search_space} {input.seq_list} > {output.hits}
        """

