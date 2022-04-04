# 00README-table3.txt
# Eric Nawrocki
# April 1, 2022
# 
# This file explains the contents of this directory which contains
# supplementary data for the paper "Faster SARS-CoV-2 sequence
# validation and annotation for GenBank using VADR" related to Table
# 3.
#
# =====================================================================
#
# Table 3 includes statistics related to N-replacement and seeded
# alignment on ENA sequences from each month between July 2020 and
# December 2021. 
# 
# This file includes the following sections: 
# - How the lists of sequences were obtained
# - How VADR v1.4.1 was run on the sequences
# - How reported statistics were calculated from the VADR output
# 
################################################
# 
# How the lists of sequences were obtained:
# 
# The 1,406,660 total ENA SARS-CoV-2 sequences were obtained
# similarly to the GenBank sequences in Table 1.
# 
# This directory contains 19 list files that end with '.all.list',
# These lists were obtained on January 19, 2022 from the NCBI Virus
# SARS-CoV-2 interactive dashboard, tabular view:
# https://www.ncbi.nlm.nih.gov/labs/virus/vssi/#/sars-cov-2 by
# restricting by 'release date'
#
# The dashboard allows you to download all INSDC accessions, which
# include sequences originally published in GenBank, ENA and DDBJ.
# These were filtered to only those accessions published in ENA by
# fetching all the sequences using an internal NCBI script that
# fetches sequences and renames them with a 'long form' sequence name
# that includes the GI and the original database, e.g. 
#
# gi|2017501276|emb|HG999274.1|
#
# These sequence files were filtered for sequence names containing
# 'emb' to restrict to only sequences deposited in ENA.
# 
# The accession list from NCBI virus can also be split into GenBank vs
# ENA/DDBJ based on the first two letters of the accessions. The
# 1,406,660 ENA SARS-CoV-2 sequences from Table 3 all begin with
# one of the following two letter prefixes: 
# FR, HG, LR, MQ, OA, OB, OC, OD, OE, OU, OV
# 
# See https://www.ncbi.nlm.nih.gov/genbank/acc_prefix/
# for more information on accession prefixes.
#
# The 19 '.all.list' list files in this directory include only the
# resulting ENA accessions. 
# 
# The ena.feb20.all.list file includes only 4 sequences and none of
# these were used for testing as mentioned in the paper. 
#
# The .all.list files from August, September, October, November and
# December 2020 and February 2021 all include less than 1000
# sequences, and all of these were used for testing. The other 12
# months include more than 1000 sequences, and these lists were
# downsampled randomly to 1000 sequences using the 'esl-selectn'
# program (installed with VADR in the directory pointed to by the
# environment variable $VADREASELDIR after installation). The 12 files
# that end with .r1k.list are these downsampled lists.
#
# The file ena.14912.list lists all 14,912 test sequences. 
#
# The file ena.14912.trim.fa.gz is a gzipped version of the fasta file
# used for testing. ***NOTE*** these are not the same versions of the 
# 14,912 sequences as they are found publicly in ENA. They differ only
# in that leading and trailing Ns in the sequences removed. That is, all
# ambiguous (non-ACGT) characters before the first canonical character
# (A, C, G, or T) have been removed, and all ambiguous (non-ACGT)
# characters after the final canonical character (A, C, G, or T) have
# been removed.
# 
# The 'trimming' of ambiguous nucleotides was performed with the 
# fasta-trim-terminal-ambigs.pl script that is included with VADR
# 1.4.1 on an input file with the original 14,912 sequences called
# ena.14912.orig.fa (not included) with the command: 
# 
 perl $VADRSCRIPTSDIR/miniscripts/fasta-trim-terminal-ambigs.pl ena.14912.orig.fa > ena.14192.trim.fa
#
# This trimming was performed because leading/trailing Ns are trimmed
# on sequences submitted to GenBank prior to running VADR.
# 
# To uncompress the .fa.gz file, use a command like 'gunzip ena.14912.trim.fa.gz'
# 
################################################
# 
# How VADR v1.4.1 was run on the sequences
#
# To reproduce the commands used to get the data in Table 3, first
# install vadr v1.4.1 following instructions here:
# 
# https://github.com/ncbi/vadr/blob/vadr-1.4.1/documentation/install.md
# 
# Note that you'll need to use the install script from version 1.4.1:
# 
# https://raw.githubusercontent.com/nawrockie/vadr/1.4.1/vadr-install.sh
#
# After installing and updating environment variables as explained in
# the instructions above, download the vadr-models-sarscov2-1.3-2 model set
# from here:
#
# https://ftp.ncbi.nlm.nih.gov/pub/nawrocki/vadr-models/sarscov2/1.3-2/vadr-models-sarscov2-1.3-2.tar.gz
#
# Bitbucket repo with tag for 1.3-2 models:
# https://bitbucket.org/nawrockie/vadr-models-sarscov2/src/vadr-models-sarscov2-1.3-2/
#
# Example SARS-CoV-2 command, 
# Set the MDLDIR environment variable to the path you installed the
# vadr-models-sarscov2-1.3-2 model set
#
v-annotate.pl -f --split --mdir $MDLDIR -s -r --nomisc --mkey sarscov2 --lowsim5seq 6 --lowsim3seq 6 --alt_fail lowscore,insertnn,deletinn --glsearch ena.14912.trim.fa va-14912
#
# The options used above are the currently recommended options from
# GenBank as of April 1, 2022
# (https://github.com/ncbi/vadr/wiki/Coronavirus-annotation)
# 
################################################
# 
# How reported statistics were calculated from the VADR output
#
# The four rightmost columns of Table 4 were calculated as follows:
# 
# 'average #Ns per sequence' and 'average #Ns replaced' the 6th and
# 7th fields of the v-annotate.pl .vadr.rpn output file reports the
# number of Ns per sequence, and the number of Ns replaced. The
# rpn2data.pl perl script (including in this directory) was used to
# average these values for the sequences from each dataset.
#
# 'average seed % coverage' and '% seqs w/100% seed coverage' values
# were determined based on the v-annotate.pl .vadr.sda output file
# using the 'sda-and-log2data.pl' perl script (included in this
# directory).
#
# Example usage: 
# perl rpn2data.pl ena.14912 va-14912/va-14912.vadr.rpn
# perl sda-and-log2data.pl ena.14912 va-14912/va-14912.vadr.log va-14912/va-14912.vadr.sda
#
# The '% seqs w/100% seed coverage' values are not simply the fraction
# sequences for which the the 'seed fraction' (8th field) of the
# .vadr.sda file is '1.000' because that value will be 1.000 for any
# seed that covers 0.9995 or higher value due to rounding (e.g. will
# include a seed that is 0.9996 fraction which is not 100\%). So the
# sda-and-log2data.pl script makes sure that the seed covers the
# complete input sequence to count towards the '% seqs w/100% seed
# coverage value.
#
################################################
# Question/problems? email eric.nawrocki@nih.gov
