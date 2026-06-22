version 1.0

task Mutect2TumorNormal {

  input {

    File tumor_bam
    File tumor_bai
    File normal_bam
    File normal_bai

    String tumor_sample_name
    String normal_sample_name

    File reference_fasta
    File reference_fai
    File reference_dict
    File target_regions

    String output_prefix

    Int ram_g = 8
    String docker_image = "broadinstitute/gatk:4.6.2.0"

  }


  command <<<

    TUMOR_BAM=$(basename ~{tumor_bam})
    TUMOR_BAI=$(basename ~{tumor_bai})
    NORMAL_BAM=$(basename ~{normal_bam})
    NORMAL_BAI=$(basename ~{normal_bai})
    REF=$(basename ~{reference_fasta})
    REF_FAI=$(basename ~{reference_fai})
    REF_DICT=$(basename ~{reference_dict})

    ln -s ~{tumor_bam} $TUMOR_BAM
    ln -s ~{tumor_bai} $TUMOR_BAI

    ln -s ~{normal_bam} $NORMAL_BAM
    ln -s ~{normal_bai} $NORMAL_BAI

    ln -s ~{reference_fasta} $REF
    ln -s ~{reference_fai} $REF_FAI
    ln -s ~{reference_dict} $REF_DICT

    gatk --java-options "-Xmx~{ram_g}G" Mutect2 \
      -R $REF \
      -I $TUMOR_BAM \
      -tumor ~{tumor_sample_name} \
      -I $NORMAL_BAM \
      -normal ~{normal_sample_name} \
      -L ~{target_regions} \
      -O ~{output_prefix}.mutect2.vcf.gz

  >>>

  output {

    File vcf = "~{output_prefix}.mutect2.vcf.gz"
    File vcf_index = "~{output_prefix}.mutect2.vcf.gz.tbi"
    File stats = "~{output_prefix}.mutect2.vcf.gz.stats"

  }

  runtime {

    docker: docker_image
    memory: "~{ram_g}G"

  }

}

task FilterMutectCalls {

  input {

    File vcf
    File vcf_index
    File stats

    File reference_fasta
    File reference_fai
    File reference_dict

    String output_prefix

    Int ram_g = 8
    String docker_image = "broadinstitute/gatk:4.6.2.0"

  }

  command <<<

    gatk --java-options "-Xmx~{ram_g}G" FilterMutectCalls \
      -R ~{reference_fasta} \
      -V ~{vcf} \
      --stats ~{stats} \
      -O ~{output_prefix}.mutect2.filtered.vcf.gz

  >>>

  output {

    File vcf_filtered = "~{output_prefix}.mutect2.filtered.vcf.gz"
    File vcf_filtered_index = "~{output_prefix}.mutect2.filtered.vcf.gz.tbi"

  }

  runtime {

    docker: docker_image
    memory: "~{ram_g}G"

  }

}
