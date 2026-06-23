#!/bin/bash

#set -euo pipefail
#set -x
CROMWELL_JAR="/opt/cromwell/cromwell.jar"

wd=$(pwd)

REPO_ROOT="$(git rev-parse --show-toplevel)"
cd "$REPO_ROOT"

java -Dconfig.file=conf/cromwell/local.conf \
  -jar $CROMWELL_JAR \
  run pipelines/brca/wdl/workflows/brca.wdl \
  -i pipelines/brca/wdl/inputs/test.brca.json \
  -o pipelines/brca/wdl/options/local.options.json \
   2>&1 | tee pipelines/brca/wdl/logs/brca_test_$(date +%Y%m%d_%H%M%S).log

cd $wd
