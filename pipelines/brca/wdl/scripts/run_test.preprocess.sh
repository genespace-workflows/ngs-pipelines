#!/bin/bash

#set -euo pipefail
set -x

inputs=$1

if [[ ! -f "$inputs" ]]; then

  echo "No inputs.json!"
  echo "Use default inputs.json"
  inputs="pipelines/brca/wdl/inputs/test.preprocess.json"

else

  inputs=$(realpath $inputs)

fi

CROMWELL_JAR="/opt/cromwell/cromwell.jar"

wd=$(pwd)

REPO_ROOT="$(git rev-parse --show-toplevel)"
cd "$REPO_ROOT"

java -Dconfig.file=conf/cromwell/local.conf \
  -jar $CROMWELL_JAR \
  run pipelines/brca/wdl/workflows/preprocess.wdl \
  -i $inputs \
  -o pipelines/brca/wdl/options/local.options.json \
   2>&1 | tee pipelines/brca/wdl/logs/brca_test_$(date +%Y%m%d_%H%M%S).log

cd $wd
