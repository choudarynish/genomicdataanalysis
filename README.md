**SARS-CoV-2 Spike Protein Variant Analysis Pipeline**

This repository contains an automated bioinformatics pipeline designed to execute a complete workflow starting from raw NGS data to variant identification and biological annotation

The objective of this pipeline is to process viral DNA sequences of SARS-CoV-2 and identify biologically significant mutations, with a specific focus on the **S gene (`GU280_gp02`)**, which codes for the viral Spike protein

**Data Sources**
*   **Raw Sequence Data:** Paired-end sequencing reads (`SRRxxxxxxxx_1.fastq` and `SRRxxxxxxxx_2.fastq`) retrieved from the SRA/ENA
*   **Reference Genome:** SARS-CoV-2 reference genome (`NC_045512.2`, `GCF_009858895.2`)

**Tools Used**
*   **FastQC:** Quality check of raw sequencing reads
0*   **fastp:** Removes sequencing adapters and trims low-quality bases
*   **Burrows-Wheeler Aligner:** Maps the cleaned reads accurately to the reference genome
*   **SAMtools:** Converts, sorts, and indexes alignment files (SAM to BAM)
*   **bcftools:** Analyzes read depth and base quality to call genetic variants (SNPs and InDels)
*   **vcftools:** Filters variants based on quality scores
*   **SnpEff:** Annotates the generated VCF file

**Executing the Pipeline**
The entire workflow has been automated in a bash script (`run.sh`). Ensure all raw `fastq` files and the reference genome renamed to `ref.fna` are in your working directory

Make the script executable and run it:
```bash
chmod +x run.sh
./run.sh
```

**Pipeline Workflow**
1.  **Reference Indexing:** `bwa index ref.fna` prepares the genome for alignment
2.  **Quality Control:** `fastqc` evaluates the raw data for potential issues
3.  **Trimming:** `fastp` filters reads with a quality score threshold
4.  **Alignment:** `bwa mem` aligns the trimmed reads to the reference genome, generating a SAM file
5.  **BAM Processing:** `samtools` converts the SAM file to a sorted BAM file and indexes it
6.  **Variant Calling:** `bcftools mpileup` and `bcftools call` detect variations and output them into a VCF format
7.  **Quality Filtering:** `vcftools` keeps only high-confidence variants
8.  **Biological Annotation:** `snpEff` predicts how each mutation impacts the protein sequence
9.  **Data Extraction:** `grep` is used to specifically isolate missense mutations occurring in the `GU280_gp02` (Spike protein) gene

