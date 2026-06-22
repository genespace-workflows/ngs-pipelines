#!/bin/bash

#set -euo pipefail
#set -x

java -jar /opt/cromwell/womtool.jar \
  validate pipelines/brca/wdl/workflows/germline.wdl

wd=$(pwd)

REPO_ROOT="$(git rev-parse --show-toplevel)"
cd "$REPO_ROOT"

java -Dconfig.file=conf/cromwell/local.conf \
  -jar /opt/cromwell/cromwell.jar \
  run pipelines/brca/wdl/workflows/germline.wdl \
  -i pipelines/brca/wdl/inputs/test.germline.json \
  -o pipelines/brca/wdl/options/local.options.json \
   2>&1 | tee pipelines/brca/wdl/logs/brca_test_$(date +%Y%m%d_%H%M%S).log

cd $wd
