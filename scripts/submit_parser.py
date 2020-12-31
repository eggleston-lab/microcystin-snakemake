
from Bio import SeqIO
from Bio.SeqRecord import SeqRecord
import os

from index_metagenome import index_metagenome

path = "/storage/eggleston-research/metagenomes/"
metagenome = "Su13VDMM110SN_FD"

index_metagenome(path + metagenome + ".proteins.faa", path + metagenome + ".index.proteins.faa")
