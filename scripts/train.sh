#! /bin/bash

scripts=`dirname "$0"`
base=$scripts/..

models=$base/models
configs=$base/configs

mkdir -p $models

num_threads=12
device=0

# measure time

SECONDS=0

# train word-level model
CUDA_VISIBLE_DEVICES=$device OMP_NUM_THREADS=$num_threads python -m joeynmt train $configs/word-level.yaml

# train bpe models:

for model_name in bpe.2000 bpe.5000 bpe.10000; do
  echo "###############################################################################"
  echo "model_name $model_name"

  CUDA_VISIBLE_DEVICES=$device OMP_NUM_THREADS=$num_threads python -m joeynmt train $configs/$model_name.yaml
done

# archive models folder to upload
tar -zcvf models.tar.gz models/

echo "time taken:"
echo "$SECONDS seconds"
