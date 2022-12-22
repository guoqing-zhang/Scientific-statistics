# -*- coding: utf-8 -*-
"""
Created on Thu Dec 22 21:39:27 2022

cited from https://github.com/PotapenkoEugene/Bioscripts/blob/main/CountsToTPM.py
"""

import pandas as pd
import numpy as np
import argparse
import mygene


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    # REQUIRED - positional arguments:
    parser.add_argument('file', type=str, nargs=1,
                        help="""Specified output table of featureCounts tool
                        if opt raw(default) or FPKM tables if opt FRKM """)
    parser.add_argument('--opt', type=str, nargs='?', default='raw',
                        help="""Specified output table of featureCounts tool
                            if opt raw or FPKM tables if opt FRKM""")
    parser.add_argument('--sep', type=str, nargs='?', default='\t',
                        help="""Specified separator for tables""")

    args = parser.parse_args().__dict__

    # if not args['file']:
    #     print('You need to specified featureCount table')
    #     exit(1)

    filename = args['file'][0]
    print(filename)
    opt = args['opt']
    sep = args['sep']

    OUTFILE = '.'.join(filename.split('.')[:-1]) + 'TPM.tsv'

    def countsToTPM(counts, geneLen):
        RPK = counts.T * 10**3/ geneLen
        SF = np.array([row.sum() / 10**6 for row in RPK])
        norm_counts = RPK.T / SF
        return norm_counts

    def FPKMtoTPM(counts):
        colsum = counts.sum(axis=0)[:, np.newaxis]
        tpm = ((counts.T / colsum) * 10**6).T
        return tpm

    # TODO
    # def countsToRPKM(counts, geneLen):
    # def countsToFPKM(counts, geneLen):

    if opt == 'raw':
        data = pd.read_csv(filename, sep='\t', comment='#')
        geneLen = np.array(data.Length, dtype='float64')
        samples = data.iloc[:, 6:]
        counts = np.array(samples, dtype='float64')
        tpm = countsToTPM(counts, geneLen)


    elif opt == 'FPKM':
        data = pd.read_csv(filename, sep=sep, comment='#')
        samples = data.iloc[:, 1:]
        symbols = data.Gene
        counts = data.iloc[:, 1:].values
        tpm = FPKMtoTPM(counts)

    # Make result table
    result_table = pd.DataFrame(tpm, columns=samples.columns, index=data.Geneid)
    # Save result to OUTFILE
    result_table.to_csv(OUTFILE, sep='\t')