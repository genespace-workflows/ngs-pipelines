#!/bin/bash

#set -euo pipefail
set -x
CROMWELL_JAR="/opt/cromwell/cromwell.jar"

tumor_R1_name="$1"
norm_R1_name="$2"

wd="$(pwd)"

REPO_ROOT="$(git rev-parse --show-toplevel)"
cd "$REPO_ROOT"

date=$(date +%Y%m%d_%H%M%S)

input_json=pipelines/brca/wdl/inputs/test.brca.$date.json
./pipelines/brca/wdl/scripts/run_get-input-jsons.sh "$tumor_R1_name" "$norm_R1_name" > $input_json

options_json=pipelines/brca/wdl/options/tmp.$date.options.json

cat > $options_json << EOF
{
  "read_from_cache": true,
  "write_to_cache": true,
  "final_workflow_outputs_dir": "pipelines/brca/wdl/results/BRCA_wf_$date",
  "use_relative_output_paths": true
}
EOF

java -Dconfig.file=conf/cromwell/local.conf \
  -jar $CROMWELL_JAR \
  run pipelines/brca/wdl/workflows/brca.wdl \
  -i $input_json \
  -o $options_json \
   2>&1 | tee pipelines/brca/wdl/logs/brca_test_$date.log

cd $wd
