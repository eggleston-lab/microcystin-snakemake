



snakemake   \
        --jobs 120 --use-conda --rerun-incomplete \
        --cluster-config ./config/cluster.yaml --cluster "sbatch --parsable --qos=unlim --partition={cluster.queue} --job-name=Brockley.{rule}.{wildcards} --mem={cluster.mem}gb --mem-per-cpu={cluster.mem_cpu} --time={cluster.time} --ntasks={cluster.threads} --nodes={cluster.nodes} --mail-user=mbrockley@middlebury.edu --mail-type=ALL" &
