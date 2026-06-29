#!/bin/bash

echo -n "Reference Genome Indexing "
{ bwa index ref.fna ; } &> /dev/null
echo ""

echo -n "Quality Check for Paired Reads"
{ time (fastqc SRR34271998_1.fastq SRR34271998_2.fastq) ; } &> /dev/null
echo ""

echo -n "Trimming of Paired Reads"
{ time (fastp -i SRR34271998_1.fastq -I SRR34271998_2.fastq -o SRR34271998_1.trimmed.fastq -O SRR34271998_2.trimmed.fastq -Q 30) ; } &> /dev/null
echo ""

echo -n "Aligning Trimmed reads to Reference gemone"
{ time (bwa mem ref.fna SRR34271998_1.trimmed.fastq SRR34271998_2.trimmed.fastq > alignment.sam) ; } &> /dev/null
echo ""

echo -n "Sorting and Indexing the alignment"
{ time (samtools view -S -b alignment.sam | samtools sort -o alignment.sorted.bam
samtools index alignment.sorted.bam) ; } &> /dev/null
echo ""

echo -n "Identifying and Filtering Variants"
{ time (bcftools mpileup -f ref.fna alignment.sorted.bam | bcftools call -mv -Oz -o out.vcf
vcftools --gzvcf out.vcf --recode --recode-INFO-all --out out_filtered --minQ 30) ; } &> /dev/null
echo ""

echo -n "Step 7: Annotating and extracting mutations... "
{ time (java -jar snpEff/snpEff.jar NC_045512.2 out_filtered.recode.vcf > out_ann.vcf
grep "GU280_gp02" out_ann.vcf | grep "missense" | grep -oE "p\.[A-Z][a-z]{2}[0-9]+[A-Z][a-z]{2}" > Summary.txt) ; } &> /dev/null
echo ""

echo "Pipeline Complete! Check 'Summary.txt' for final list"
