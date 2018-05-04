from glob import glob
import numpy as np

INPUTS = glob('inputs/*.sig')


def print_benchmarks(benchmarks, fields=None):
    if fields is None:
        fields = benchmarks['master'].keys()
    header_fmt = "{:>10} {:>20} {:>20} {:>10}"
    field_fmt = "{:>10} {:>20} {:>20} {:>10.2f}"

    branches = ['master']
    keys = list(benchmarks.keys())
    keys.remove('master')
    branches += keys

    print(header_fmt.format("", *benchmarks.keys(), "change"))

    for field in fields:
        values = []
        old, new = None, None
        for bench in branches:
            measures = benchmarks[bench][field]

            if np.isreal(measures[0]):
                if old is None:
                    old = measures.mean()
                elif new is None:
                    new = measures.mean()

                values.append("{:.2f} ± {:.2f}".format(measures.mean(), measures.std()))

        if values:
            print(field_fmt.format(field, *values, new / (old or 1)))


rule all:
    input: expand('outputs/{branch}.sbt.json', branch=['master', 'branch'])
    run:
        import pandas as pd
        benchmarks = {}
        for f in input:
            branch = os.path.basename(f).split('.')[0]
            benchmarks[branch] = pd.read_table('benchmarks/{}.txt'.format(branch))
        #print_benchmarks(benchmarks, ('max_rss', 's', 'io_in', 'io_out'))
        print_benchmarks(benchmarks)

rule benchmark:
    output: 'outputs/{branch}.sbt.json'
    input: INPUTS
    conda: 'envs/{branch}.yaml'
    benchmark: 'benchmarks/{branch}.txt'
    shell: '''
        sourmash info
        sourmash index -k 31 -d 2 -x 1e6 {output} {input}
    '''
