# BRCA pipeline

WDL-пайплайн для анализа таргетного секвенирования BRCA1/BRCA2.

### Структура проекта

```text
common/wdl/tasks/                  Общие WDL-задачи
conf/cromwell/local.conf           Конфигурация Cromwell

pipelines/brca/wdl/workflows/      Workflow-файлы
pipelines/brca/wdl/inputs/         Входные JSON-файлы
pipelines/brca/wdl/options/        Cromwell options
pipelines/brca/wdl/data/test/      Тестовые данные
```

Перед запуском необходимо указать путь к `cromwell.jar` в тестовом скрипте:

```bash
CROMWELL_JAR="/path/to/cromwell.jar"
```

или использовать собственную команду запуска Cromwell.

### Тестовый запуск

#### Из корня репозитория

```bash
bash pipelines/brca/wdl/scripts/run_brca_test.sh
```

#### Или напрямую

```bash
java \
  -Dconfig.file=conf/cromwell/local.conf \
  -jar /path/to/cromwell.jar \
  run pipelines/brca/wdl/workflows/brca_full.wdl \
  -i pipelines/brca/wdl/inputs/test.json \
  -o pipelines/brca/wdl/options/local.options.json
```


### Тестовые данные

В репозитории хранятся тестовые данные, необходимые для запуска пайплайна:

```text
pipelines/brca/wdl/data/test/
```

Референсные последовательности и индексы не входят в состав репозитория из-за ограничений на размер файлов GitHub.

Перед запуском необходимо самостоятельно подготовить референсные данные и разместить их в каталоге:

```text
pipelines/brca/wdl/data/test/references/
```

Ожидается наличие FASTA-файла референсного генома и соответствующих индексных файлов (`.fai`, `.dict`, BWA-индексов и др.), используемых тестовым запуском.
