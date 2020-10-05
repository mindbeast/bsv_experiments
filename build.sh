#!/bin/bash
set -e
set -x
bsc -sim fibonacci.bsv
#bsc -sim -e mkFbTestbench mkFbTestbench.ba
bsc -sim -e mkFbTestbench mkFibonacciGenerator.ba mkFbTestbench.ba
#bsc -sim mkFbTestbench.ba 

