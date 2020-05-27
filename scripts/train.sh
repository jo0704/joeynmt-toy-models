#! /bin/bash
# TODO: adapt to new project

scripts=`dirname "$0"`
base=$scripts/..

models=$base/models
configs=$base/configs

mkdir -p $models

num_threads=12
device=0

# measure time

SECONDS=0

CUDA_VISIBLE_DEVICES=$device OMP_NUM_THREADS=$num_threads python -m joeynmt train $configs/de_en_without_bpe.yaml

# train bpe setup:

# CUDA_VISIBLE_DEVICES=$device OMP_NUM_THREADS=$num_threads python -m joeynmt train $configs/rnn_wmt16_factors_concatenate_deen.yaml
# CUDA_VISIBLE_DEVICES=$device OMP_NUM_THREADS=$num_threads python -m joeynmt train $configs/rnn_wmt16_factors_add_deen.yaml

echo "time taken:"
echo "$SECONDS seconds"
