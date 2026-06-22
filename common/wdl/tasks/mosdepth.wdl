version 1.0

task MosdepthByTargets {

  input {

    File bam
    File bai
    File targets_bed
    String sample_name
    String thresholds = "10,20,50,100,250"

    Int threads = 4
    Int ram_g = 4
    String docker_image = "quay.io/biocontainers/mosdepth:0.3.14--h05c3d44_0"

  }

  command <<<

    BAM=$(basename ~{bam})

    ln -s ~{bam} $BAM
    ln -s ~{bai} $BAM.bai

    mosdepth \
      --thresholds ~{thresholds} \
      --threads ~{threads} \
      --by ~{targets_bed} \
      ~{sample_name}.mosdepth \
      $BAM

    mv ~{sample_name}.mosdepth.mosdepth.summary.txt ~{sample_name}.mosdepth.summary.txt
    mv ~{sample_name}.mosdepth.mosdepth.global.dist.txt ~{sample_name}.mosdepth.global.dist.txt
    mv ~{sample_name}.mosdepth.mosdepth.region.dist.txt ~{sample_name}.mosdepth.region.dist.txt

  >>>

  output {

    File summary = "~{sample_name}.mosdepth.summary.txt"

    File regions_bed_gz = "~{sample_name}.mosdepth.regions.bed.gz"
    File regions_bed_gz_csi = "~{sample_name}.mosdepth.regions.bed.gz.csi"

    File thresholds_bed_gz = "~{sample_name}.mosdepth.thresholds.bed.gz"
    File thresholds_bed_gz_csi = "~{sample_name}.mosdepth.thresholds.bed.gz.csi"

    File per_base_bed_gz = "~{sample_name}.mosdepth.per-base.bed.gz"
    File per_base_bed_gz_csi = "~{sample_name}.mosdepth.per-base.bed.gz.csi"

    File global_dist = "~{sample_name}.mosdepth.global.dist.txt"
    File region_dist = "~{sample_name}.mosdepth.region.dist.txt"

  }

  runtime {

    docker: docker_image
    cpu: threads
    memory: "~{ram_g}G"

  }

}

