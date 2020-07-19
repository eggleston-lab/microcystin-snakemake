



snakemake   \
        --jobs 60 --use-conda  \
        --cluster-config cluster.yaml --cluster "sbatch --parsable --qos=unlim --partition={cluster.queue} --job-name=Brockley.{rule}.{wildcards} --mem={cluster.mem}gb --mem-per-cup={cluster.mem_cpu}gb --time={cluster.time} --ntasks={cluster.threads} --nodes={cluster.nodes} --mail-user=mbrockley@middlebury.edu --mail-type=ALL" &
