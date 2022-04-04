# 00README-table4.txt
# Eric Nawrocki
# April 4, 2022
# 
# This file explains the contents of this directory which contains
# supplementary data for the paper "Faster SARS-CoV-2 sequence
# validation and annotation for GenBank using VADR" related to Table
# 4.
#
# =====================================================================
#
# Table 4 shows running time statistics of VADR v1.0, v1.1 and v1.4.1
# on the 14,912 sequence ENA dataset. Details on how the 14,912
# sequence dataset can be found in the file
# table3-files/00README-table3.txt.
# 
# This README file includes the following sections: 
# - How VADR v1.0 was run on the sequences
# - How VADR v1.1 was run on the sequences
# - How VADR v1.4.1 was run on the sequences
# - How reported statistics were calculated from the VADR output
# 
###################################################
#
# How VADR v1.0 was run on the sequences
#
# To reproduce the v-annotate.pl v1.0 runs reported in table 4, first
# install vadr v1.1 following instructions here:
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
# Because running vadr 1.0 on the 14,912 sequence dataset would take
# over 1000 hours, I split it up into 100 smaller sequence files using
# the esl-ssplit.pl perl script that is installed with VADR. It will
# be in the Bio-Easel/scripts/ directory after installing VADR.
# 
# Example command of v-annotate.pl on one of the 100 fasta files:
# Set the MDLDIR environment variable to the path you installed the
# vadr-models-corona-55-1.0.2dev-5 model set
# 

v-annotate.pl --mxsize 64000 -m $MDLDIR/NC_045512.cm -b $MDLDIR -i $MDLDIR/NC_045512.minfo ena.14912.trim.fa.1 va-v1p0-14912.1

################################################
#
# How VADR v1.1 was run on the sequences
#
# To reproduce the v-annotate.pl v1.1 runs reported in table 4, first
# install vadr v1.1 following instructions here:
# 
# https://github.com/ncbi/vadr/blob/vadr-1.1/documentation/install.md
# 
# Note that you'll need to use the install script from version 1.1:
# 
# https://raw.githubusercontent.com/nawrockie/vadr/1.1/vadr-install.sh
#
# After installing and updating environment variables as explained in
# the instructions above, download the VADR coronaviridae
# 1.1-1 model set from here:
# https://ftp.ncbi.nlm.nih.gov/pub/nawrocki/vadr-models/coronaviridae/1.1-1/vadr-models-corona-1.1-1.tar.gz
#
# Like for the v1.0 runs, I ran v1.1 on the 100 smaller sequence
# subset files, created as explained above.
# 
# Example command of v-annotate.pl on one of the 100 fasta files:
# Set the MDLDIR environment variable to the path you installed the
# vadr-models-corona-1.1-1 model set
# 

v-annotate.pl -s -r --mxsize 64000 -m $MDLDIR/NC_045512.cm -x $MDLDIR -i $MDLDIR/NC_045512.minfo -n $MDLDIR/NC_045512.fa ena.14912.trim.fa.1 va-v1p1-14912.1

#############################################
# 
# How VADR v1.4.1 was run on the sequences
# 
# To reproduce the v-annotate.pl v1.4.1 runs reported in table 4,
# first install vadr v1.4.1 following instructions here:
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
# Example SARS-CoV-2 command using 8 CPUs:
# Set the MDLDIR environment variable to the path you installed the
# vadr-models-sarscov2-1.3-2 model set
#

v-annotate.pl -f --cpu 8 --split --mdir $MDLDIR -s -r --nomisc --mkey sarscov2 --lowsim5seq 6 --lowsim3seq 6 --alt_fail lowscore,insertnn,deletinn --glsearch ena.14912.trim.fa va-v1p4p1-cpu8-14912

#
# The options used above are the currently recommended options from
# GenBank as of April 1, 2022
# (https://github.com/ncbi/vadr/wiki/Coronavirus-annotation)
# 
# Repeat the above command with '--cpu 1', '--cpu 2', '--cpu 4',
# '--cpu 16', and '--cpu 32' instead of '--cpu 8', to reproduce
# the other rows of the table.
# 
################################################
# 
# How reported statistics were calculated from the VADR output
#
# Table 4 includes timing statistics for the v1.0, v1.1 and v1.4.1
# runs. These stats were compiled based on the vadr output file with 
# the suffix '.vadr.log' which includes the elapsed time required by 
# the program. The perl script logs2data.pl (included in 
# this directory takes as input a list of .vadr.log files (100 for
# v1.0 and v1.1 runs as explained above, or 1 for v1.4.1 runs). 
# 
# Example usage:
# ls va-v1p0-14912*/*vadr.log > v1p0.log.list
# perl logs2data.pl v1p0 v1p0.log.list
# 
################################################
# Question/problems? email eric.nawrocki@nih.gov
