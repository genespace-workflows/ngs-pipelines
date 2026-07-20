#!/bin/bash

#set -euo pipefail

tumor_r1="$1"
normal_r1="$2"

FASTQ_DIR="pipelines/brca/wdl/data/fastq"
REF_DIR="pipelines/brca/wdl/data/test/reference/GRCh38"

tumor_r2="${tumor_r1/_R1./_R2.}"
normal_r2="${normal_r1/_R1./_R2.}"

tumor_sample=$(echo "$tumor_r1" | sed 's/^.*NGS[0-9]*_//' | sed 's/_L00_R1\.fq\.gz$//')
normal_sample=$(echo "$normal_r1" | sed 's/^.*NGS[0-9]*_//' | sed 's/_L00_R1\.fq\.gz$//')

cat << EOF
{
  "BRCA_full_wf.tumor_r1_fastq": "${FASTQ_DIR}/${tumor_r1}",
  "BRCA_full_wf.tumor_r2_fastq": "${FASTQ_DIR}/${tumor_r2}",
  "BRCA_full_wf.normal_r1_fastq": "${FASTQ_DIR}/${normal_r1}",
  "BRCA_full_wf.normal_r2_fastq": "${FASTQ_DIR}/${normal_r2}",

  "BRCA_full_wf.tumor_sample_name": "${tumor_sample}",
  "BRCA_full_wf.normal_sample_name": "${normal_sample}",

  "BRCA_full_wf.reference_fasta": "${REF_DIR}/GCA_000001405.15_GRCh38_no_alt_analysis_set.chr13_chr17.fna",
  "BRCA_full_wf.reference_fai": "${REF_DIR}/GCA_000001405.15_GRCh38_no_alt_analysis_set.chr13_chr17.fna.fai",
  "BRCA_full_wf.reference_dict": "${REF_DIR}/GCA_000001405.15_GRCh38_no_alt_analysis_set.chr13_chr17.dict",

  "BRCA_full_wf.bwa_index": [
    "${REF_DIR}/GCA_000001405.15_GRCh38_no_alt_analysis_set.chr13_chr17.fna.bwt",
    "${REF_DIR}/GCA_000001405.15_GRCh38_no_alt_analysis_set.chr13_chr17.fna.pac",
    "${REF_DIR}/GCA_000001405.15_GRCh38_no_alt_analysis_set.chr13_chr17.fna.ann",
    "${REF_DIR}/GCA_000001405.15_GRCh38_no_alt_analysis_set.chr13_chr17.fna.amb",
    "${REF_DIR}/GCA_000001405.15_GRCh38_no_alt_analysis_set.chr13_chr17.fna.sa"
  ],

  "BRCA_full_wf.target_regions": "pipelines/brca/wdl/data/test/target_regions/BRCA.bed",

  "BRCA_full_wf.vep_cache_dir": "pipelines/brca/wdl/data/test/vep_cache.tar.gz",

  "BRCA_full_wf.threads": 2,
  "BRCA_full_wf.ram_g": 6
}
EOF
