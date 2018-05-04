# sourmash indexing benchmarks

This is a simple benchmark using the Snakemake benchmark capabilities and
throwing a bit of parsing to print it on the screen.

## Usage

- Update `envs/branch.yaml` to point to the branch we want to benchmark (against master)
- Running with 30 replicates:
``` bash
$ snakemake --use-conda --benchmark-repeats 30
```
- The output looks like this:
```
                         master               branch     change
         s         63.77 ± 3.37         62.92 ± 2.90       0.99
   max_rss        165.65 ± 6.60        39.84 ± 15.85       0.24
   max_vms        258.32 ± 6.57       138.58 ± 14.51       0.54
   max_uss        161.54 ± 6.60        35.56 ± 15.91       0.22
   max_pss        162.18 ± 6.60        36.19 ± 15.91       0.22
     io_in          0.00 ± 0.01          0.00 ± 0.01       0.60
    io_out          0.00 ± 0.00          0.00 ± 0.00       0.00
 mean_load          0.00 ± 0.00          0.00 ± 0.00       0.00
```
- If there are updates in the branch (or master), you need to regenerate the
  conda environment. Since I don't know a better way to do it, I usually run
  `$ rm -rf .snakemake/conda` to remove the current env.
