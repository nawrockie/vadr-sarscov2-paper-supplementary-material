# 00README-table2.txt
# Eric Nawrocki
# March 31, 2022
# 
# This file explains the contents of this directory which contains
# supplementary data for the paper "Faster SARS-CoV-2 sequence
# validation and annotation for GenBank using VADR" related to Table
# 2.
#
# =====================================================================
#
# Table 2 shows statistics on Norovirus, Dengue virus and SARS-CoV-2
# GenBank sequences. 
# 
# This file includes the following sections: 
# - How the lists of sequences were obtained
# - How Ns were counted in the sequences
# - How VADR v1.0 was run on the sequences
# - How average percent identity was calculated
# 
################################################
# 
# How the lists of sequences were obtained:
# 
# The 1,616,891 SARS-CoV-2 sequences are the same set from Table 1,
# and are listed in files in the table1-files directory of this
# supplementary material. The 00README-table1.txt file in that
# directory explains how those sequences were obtained.
# The timing and average percent identity statistics for SARS-CoV-2
# were based on 300 randomly selected sequences from the 1,616,891,
# selected using the esl-selectn program and listed in the file 
# gb.sarscov2.full.r300.list file in this directory.
# 
# The 300 sequences are listed in the file: 
# gb.sarscov2.full.r300.list 
#
# The following four files listed below list the sets of all and full 
# length Norovirus and Dengue virus sequences:
# 
# noro.all.list
# noro.full.list
# dengue.all.list
# dengue.full.list
# 
# The list of Norovirus and Dengue virus sequences were obtained using
# Entrez queries on Jan 25, 2022: 

esearch -db nuccore -query "Norovirus NOT chimeric AND 50:10000[slen]  AND 1950/01/01:2022/1/25[Publication Date]" | efetch -format acc  > noro.all.list
esearch -db nuccore -query "Norovirus NOT chimeric AND 6947:10000[slen] AND 1950/01/01:2022/1/25[Publication Date]" | efetch -format acc > noro.full.list

esearch -db nuccore -query "Dengue NOT chimeric AND 50:11200[slen] AND 1950/01/01:2022/1/25[Publication Date]" | efetch -format acc > dengue.all.list
esearch -db nuccore -query "Dengue NOT chimeric AND 10117:11200[slen] AND 1950/01/01:2022/1/25[Publication Date]" | efetch -format acc > dengue.full.list

# These commands require that E-Utils be installed on your computer
# (https://www.ncbi.nlm.nih.gov/books/NBK25500/).
#
# These commands can be found in the files noro-entrez-fetch.sh and
# dengue-entrez-fetch.sh
#
# Alternatively, you can use the Entrez website
# (https://www.ncbi.nlm.nih.gov/search/), and enter the quoted strings
# from the above commands.
# 
# The lists returned from these commands will 
# include sequences originally published in GenBank, ENA and DDBJ.
# These were filtered to only those accessions published in GenBank by
# fetching all the sequences using an internal NCBI script that
# fetches sequences and renames them with a 'long form' sequence name
# that includes the GI and the original database, e.g. 
#
# gi|1607263845|gb|MK752937.1|
#
# These sequence files were filtered for sequence names containing
# 'gb' to restrict to only sequences deposited in GenBank.
# 
# The lists in this directory include only the resulting GenBank
# accessions. 
#
# The accession list returned from esearch or Entrez can also be split into GenBank vs
# ENA/DDBJ based on the first one or two letters of the accessions
# (first one letter if the second character is a number, and first two
# letters if the second character is a letter). 
#
# The 44,936 Norovirus sequence accesions from Table 2 all begin with
# one of the following one or two letter prefixes:
# L, M, S, U, AF, AH, AY, CX, DQ, EA, EF, EU, FJ, GP, GQ, GU, GX, GZ,
# HK, HL, HM, HQ, JF, JN, JQ, JX, KC, KF, KH, KJ, KM, KP, KR, KT, KU,
# KX, KY, MF, MG, MH, MI, MK, MM, MN, MO, MT, MV, MW, MX, MY, MZ, OK,
# OL, OM
#
# The 113,211 Dengue virus sequence accesions from Table 2 all begin with
# one of the following one or two letter prefixes:
# L, M, S, U, AF, AH, AR, AY, BG, CB, DQ, DV, EA, EF, EU, FJ, GO, GP,
# GQ, GU, GV, GX, GY, GZ, HJ, HK, HL, HM, HQ, JF, JN, JQ, JR, JX, KC,
# KF, KH, KJ, KM, KP, KR, KT, KU, KX, KY, L, M, MF, MG, MH, MI, MK,
# MM, MN, MO, MT, MV, MW, MX, MY, MZ, OK, OL, OM, VC
# 
# See https://www.ncbi.nlm.nih.gov/genbank/acc_prefix/
# for more information on accession prefixes.
#
################################################
# 
# How Ns were counted in the sequences: 
# 
# The esl-seqstat program was used to determine fraction of Ns in each
# sequence dataset using the -c option. esl-seqstat is installed with
# VADR in the directory that the $VADREASELDIR environment variable
# will point to if the installation instructions are followed.
# 
# The longest-N-stretch.pl perl script (included in this directory)
# was used to determine the longest stretch of Ns in each sequence in
# each sequence dataset, and the summarize-longest-N-stretch.pl script
# (included in this directory) was used to determine what fraction of
# sequences have a stretch of at least 50 consecutive Ns.
# 
# Example usage:
# $VADREASELDIR/esl-seqstat -c gb.noro.all.fa
# perl longest-N-stretch.pl gb.noro.all.fa > gb.noro.all.longest-N-stretch 
# perl summarize-longest-N-stretch.pl gb.noro.all.longest-N-stretch 
#
###################################################
#
# How VADR v1.0 was run on the sequences
#
# To reproduce the commands used to generate the data in Table 2,
# first install vadr v1.0 following the instructions here:
# 
# https://github.com/ncbi/vadr/blob/vadr-1.0/documentation/install.md
# 
# Note that you'll need to use the install script from version 1.0:
# 
# https://raw.githubusercontent.com/nawrockie/vadr/1.0/vadr-install.sh
#
# After installing and updating environment variables as explained in
# the instructions above, download the VADR coronaviridae
# 55-1.0.2dev-5 model set from here:
# https://ftp.ncbi.nlm.nih.gov/pub/nawrocki/vadr-models/coronaviridae/1.0.2dev-5/vadr-models-corona-55-1.0.2dev-5.tar.gz
#
# Example Norovirus command:

v-annotate.pl --out_stk gb.noro.full.fa va-gb.noro.full

#
# Example Dengue command:

v-annotate.pl --out_stk gb.dengue.full.fa va-gb.dengue.full

# 
# Example SARS-CoV-2 command:
# Set the MDLDIR environment variable to the path you installed the
# vadr-models-corona-55-1.0.2dev-5 model set

v-annotate.pl --out_stk --mxsize 64000 -m $MDLDIR/NC_045512.cm -b $MDLDIR -i $MDLDIR/NC_045512.minfo gb.sarscov2.full.r300.fa 

################################################
# 
# How average percent identity was calculated
#
# For each of Norovirus, Dengue virus and SARS-CoV-2, for each of the
# RefSeq models (listed below), all alignments from the v-annotate.pl
# were merged with the esl-alimerge command and then average identity
# per merged alignment was determined using esl-alipid and the perl
# script alipid2avg.pl (provided). Those average percent identities
# were were then themselves averaged to get the values reported in
# Table 2 (Norovirus: 81.6%, Dengue: 94.4%, SARS-CoV-2: 99.7%).
#
# The 'esl-' programs are installed with VADR in the directory that
# the $VADREASELDIR environment variable will point to.
#
# List of RefSeqs:
# Norovirus: 
# NC_001959, NC_006269, NC_008311, NC_010624, NC_029645, NC_029646,
# NC_029647, NC_031324, NC_039475, NC_039476, NC_039477
# 
# Dengue: 
# NC_001474, NC_001475, NC_001477, NC_002640,
#
# SARS-CoV-2:
# NC_045512
# 
# Example commands (shown for 1 of the 11 Norovirus RefSeqs):

  ls va-gb.noro.full/*NC_001959*stk > NC_001959.list
  $VADREASELDIR/esl-alimerge --list NC_001959.list > NC_001959.merged.stk
  $VADREASELDIR/esl-alipid NC_001959.merged.stk | perl alipid2avg.pl 

#
################################################
# Question/problems? email eric.nawrocki@nih.gov
