version 1.0

import "preprocess.wdl" as preprocess
import "somatic.wdl" as somatic
import "germline.wdl" as germline

workflow BRCA_full_wf {

  input {

    File tumor_r1_fastq
    File tumor_r2_fastq
    File normal_r1_fastq
    File normal_r2_fastq

    String tumor_sample_name
    String normal_sample_name

    File reference_fasta
    File reference_fai
    File reference_dict
    Array[File] bwa_index

    File target_regions

    Int threads = 4
    Int ram_g = 8

  }

  call preprocess.preprocess_wf as PrepareTumorBam {

    input:
      r1_fastq = tumor_r1_fastq,
      r2_fastq = tumor_r2_fastq,
      sample_name = tumor_sample_name,
      reference_fasta = reference_fasta,
      reference_fai = reference_fai,
      bwa_index = bwa_index,
      target_regions = target_regions,
      threads = threads,
      ram_g = ram_g

  }

  call preprocess.preprocess_wf as PrepareNormalBam {

    input:
      r1_fastq = normal_r1_fastq,
      r2_fastq = normal_r2_fastq,
      sample_name = normal_sample_name,
      reference_fasta = reference_fasta,
      reference_fai = reference_fai,
      bwa_index = bwa_index,
      target_regions = target_regions,
      threads = threads,
      ram_g = ram_g

  }

  call somatic.somatic_wf {

    input:
      tumor_bam = PrepareTumorBam.coord_sorted_bam,
      tumor_bai = PrepareTumorBam.coord_sorted_bai,
      normal_bam = PrepareNormalBam.coord_sorted_bam,
      normal_bai = PrepareNormalBam.coord_sorted_bai,
      tumor_sample_name = tumor_sample_name,
      normal_sample_name = normal_sample_name,
      reference_fasta = reference_fasta,
      reference_fai = reference_fai,
      reference_dict = reference_dict,
      target_regions = target_regions,
      ram_g = ram_g

  }

  call germline.germline_wf {

    input:
      coord_sorted_bam = PrepareNormalBam.coord_sorted_bam,
      coord_sorted_bai = PrepareNormalBam.coord_sorted_bai,
      sample_name = normal_sample_name,
      reference_fasta = reference_fasta,
      reference_fai = reference_fai,
      target_regions = target_regions,
      threads = threads,
      ram_g = ram_g

  }

  output {

    File tumor_bam = PrepareTumorBam.coord_sorted_bam
    File tumor_bai = PrepareTumorBam.coord_sorted_bai

    File normal_bam = PrepareNormalBam.coord_sorted_bam
    File normal_bai = PrepareNormalBam.coord_sorted_bai

    File somatic_vcf = somatic_wf.mutect2_filtered_vcf
    File somatic_vcf_index = somatic_wf.mutect2_filtered_vcf_index

    File germline_vcf = germline_wf.deepvariant_vcf_gz
    File germline_vcf_index = germline_wf.deepvariant_vcf_gz_tbi

  }
}

