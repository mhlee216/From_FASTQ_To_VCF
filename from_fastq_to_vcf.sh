#!/bin/bash

# Reference Download
# Thioalkalivibrio sp. ALE23 (g-proteobacteria)
wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR892/SRR892622/SRR892622_1.fastq.gz
wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR892/SRR892622/SRR892622_2.fastq.gz
wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/378/545/GCF_000378545.1_ASM37854v1/GCF_000378545.1_ASM37854v1_genomic.fna.gz
wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/378/545/GCF_000378545.1_ASM37854v1/GCF_000378545.1_ASM37854v1_genomic.gff.gz

# Genomic FASTA & GFF
less GCF_000378545.1_ASM37854v1_genomic.fna.gz > RefSeq.fasta
less GCF_000378545.1_ASM37854v1_genomic.gff.gz > RefSeq.gff
bwa index RefSeq.fasta

# Trimming
trim_galore --illumina --paired -q 30 --gzip SRR892622_1.fastq.gz SRR892622_2.fastq.gz

# SAM file
bwa index RefSeq.fasta
bwa mem RefSeq.fasta SRR892622_1_val_1.fq.gz SRR892622_2_val_2.fq.gz > trimmed_SRR892622_pe.sam

# BAM file
samtools view -b -o trimmed_SRR892622_pe.bam trimmed_SRR892622_pe.sam
samtools flagstat trimmed_SRR892622_pe.bam > trimmed_SRR892622_pe.flagstat
samtools sort trimmed_SRR892622_pe.bam -o trimmed_SRR892622_pe.sorted.bam
samtools index trimmed_SRR892622_pe.sorted.bam

# Visualization
# tablet
# P : trimmed_SRR490124_pe.sorted.bam
# R : NC_000913.gff (Genomic GFF)

# VCF file
bcftools mpileup -Ou -f RefSeq.fasta trimmed_SRR892622_pe.sorted.bam | bcftools call -mv -Ob --ploidy 1 -o trimmed_SRR892622_pe.haploid.bcf
bcftools mpileup -Ou -f RefSeq.fasta trimmed_SRR892622_pe.sorted.bam | bcftools call -mv -Ob -o trimmed_SRR892622_pe.diploid.bcf
bcftools view trimmed_SRR892622_pe.haploid.bcf > trimmed_SRR892622_pe.haploid.vcf
bcftools view trimmed_SRR892622_pe.diploid.bcf > trimmed_SRR892622_pe.diploid.vcf

