#!/bin/bash

conda config --add channels bioconda
conda config --add channels conda-forge
conda install samtools=1.11 -y
conda install bcftools -y
conda install -c bioconda vcftools -y
conda install -c bioconda htslib -y
conda install -c bioconda sra-tools -y
conda install -c bioconda trim-galore -y
conda install -c bioconda bwa -y
conda install -c bioconda tablet -y

