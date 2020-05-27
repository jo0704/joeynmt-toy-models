#! /bin/bash

scripts=`dirname "$0"`
base=$scripts/..

data=$base/data
tools=$base/tools
MOSES=$base/tools/moses-scripts/scripts

mkdir -p $base/shared_models

src=de
trg=en

# cloned from https://github.com/bricksdont/moses-scripts
MOSES=$tools/moses-scripts/scripts

bpe_vocab_threshold=10

#################################################################

# measure time

SECONDS=0

# tokenize corpus

for corpus in train dev test; do
  for lang in $src $trg; do
    cat $data/$corpus.de-en.$lang | $MOSES/tokenizer/tokenizer.perl -l $lang > $data/$corpus.de-en.tokenized.$lang
  done
done

for bpe_num_operations in 2000 5000 10000; do
  # learn BPE model on train (concatenate both languages)

  subword-nmt learn-joint-bpe-and-vocab -i $data/train.de-en.tokenized.$src $data/train.de-en.tokenized.$trg \
    --write-vocabulary $base/shared_models/vocab.$bpe_num_operations.$src $base/shared_models/vocab.$bpe_num_operations.$trg \
    -s $bpe_num_operations -o $base/shared_models/$src$trg.$bpe_num_operations.bpe

  # apply BPE model to train, test and dev

  for corpus in train dev test; do
    subword-nmt apply-bpe -c $base/shared_models/$src$trg.$bpe_num_operations.bpe --vocabulary $base/shared_models/vocab.$bpe_num_operations.$src --vocabulary-threshold $bpe_vocab_threshold < $data/$corpus.de-en.tokenized.$src > $data/$corpus.bpe.$bpe_num_operations.$src
    subword-nmt apply-bpe -c $base/shared_models/$src$trg.$bpe_num_operations.bpe --vocabulary $base/shared_models/vocab.$bpe_num_operations.$trg --vocabulary-threshold $bpe_vocab_threshold < $data/$corpus.de-en.tokenized.$trg > $data/$corpus.bpe.$bpe_num_operations.$trg
  done


  # build joeynmt vocab

  python $tools/joeynmt/scripts/build_vocab.py $data/train.bpe.$bpe_num_operations.$src $data/train.bpe.$bpe_num_operations.$trg --output_path $base/shared_models/vocab.$bpe_num_operations.txt


  # file sizes

  for corpus in train dev test; do
    echo "corpus: "$corpus
    wc -l $data/$corpus.bpe.$bpe_num_operations.$src $data/$corpus.bpe.$bpe_num_operations.$trg
  done
done

wc -l $base/shared_models/*

# sanity checks

echo "At this point, please check that 1) file sizes are as expected, 2) languages are correct and 3) material is still parallel"

echo "time taken:"
echo "$SECONDS seconds"
