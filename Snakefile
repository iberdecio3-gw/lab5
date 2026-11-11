rule all:
    input:
        "results/combined.csv",
        "results/summary.png",
        "results/summary.md"

rule clean_samples:
    input:
        csv="data/messy_samples.csv",
        script="clean_1.R"
    output:
        "results/samples.csv"
    shell:
        "Rscript {input.script:q} {input.csv:q} {output:q}"

rule query_cohort:
    input:
        db="data/cohort.db",
        script="build_features.py"
    output:
        "results/patient_features.tsv"
    shell:
        "python {input.script:q} {input.db:q} {output:q}"

rule merge_tables:
    input:
        samples="results/samples.csv",
        patients="results/patient_features.tsv",
        script="merge_tables.R"
    output:
        "results/combined.csv"
    shell:
        "Rscript {input.script:q} {input.samples:q} {input.patients:q} {output:q}"

rule report:
    input:
        table="results/combined.csv",
        script="make_report.R"
    output:
        figure="results/summary.png",
        summary="results/summary.md"
    shell:
        "Rscript {input.script:q} {input.table:q} {output.figure:q} {output.summary:q}"