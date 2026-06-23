BRCA pipeline

WDL-пайплайн для анализа таргетного секвенирования BRCA1/BRCA2.

Структура проекта
common/wdl/tasks/                  Общие WDL-задачи
conf/cromwell/local.conf           Конфигурация Cromwell

pipelines/brca/wdl/workflows/      Workflow-файлы
pipelines/brca/wdl/inputs/         Входные JSON-файлы
pipelines/brca/wdl/options/        Cromwell options
pipelines/brca/wdl/data/test/      Тестовые данные

Перед запуском необходимо указать путь к сromwell.jar в тестовом скрипте:

CROMWELL_JAR="/path/to/cromwell.jar"

или использовать собственную команду запуска Cromwell.

Тестовый запуск

Из корня репозитория:

bash pipelines/brca/wdl/scripts/run_brca_test.sh

или напрямую:

java \
  -Dconfig.file=conf/cromwell/local.conf \
  -jar /path/to/cromwell.jar \
  run pipelines/brca/wdl/workflows/brca_full.wdl \
  -i pipelines/brca/wdl/inputs/test.json \
  -o pipelines/brca/wdl/options/local.options.json
