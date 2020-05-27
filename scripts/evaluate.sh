#! /bin/bash

scripts=`dirname "$0"`
base=$scripts/..

data=$base/data
configs=$base/configs

translations=$base/translations

mkdir -p $translations

src=de
trg=en

# cloned from https://github.com/bricksdont/moses-scripts
MOSES=$base/tools/moses-scripts/scripts

num_threads=12
device=0

# measure time

SECONDS=0

echo "###############################################################################"
echo "model_name word-level"

mkdir -p $translations/word-level

CUDA_VISIBLE_DEVICES=$device OMP_NUM_THREADS=$num_threads python -m joeynmt translate $configs/word-level.yaml < $data/test.de-en.tokenized.$src > $translations/word-level/test.word-level.tokenized.$trg

# undo tokenization

cat $translations/word-level/test.word-level.tokenized.$trg | $MOSES/tokenizer/detokenizer.perl -l $trg > $translations/word-level/test.word-level.$trg

# compute case-sensitive BLEU on detokenized data

cat $translations/word-level/test.word-level.$trg | sacrebleu $data/test.de-en.$trg

# translate and evaluate BPE models

for model_name in bpe.2000 bpe.5000 bpe.10000; do

    echo "###############################################################################"
    echo "model_name $model_name"

    translations_sub=$translations/$model_name

    mkdir -p $translations_sub

    CUDA_VISIBLE_DEVICES=$device OMP_NUM_THREADS=$num_threads python -m joeynmt translate $configs/$model_name.yaml < $data/test.$model_name.$trg > $translations_sub/test.$model_name.$trg

    # undo BPE (this does not do anything: https://github.com/joeynmt/joeynmt/issues/91)

    cat $translations_sub/test.$model_name.$trg | sed 's/\@\@ //g' > $translations_sub/test.tokenized.$model_name.$trg

    # undo tokenization

    cat $translations_sub/test.tokenized.$model_name.$trg | $MOSES/tokenizer/detokenizer.perl -l $trg > $translations_sub/test.$model_name.$trg

    # compute case-sensitive BLEU on detokenized data

    cat $translations_sub/test.$model_name.$trg | sacrebleu $data/test.de-en.$trg

done

echo "time taken:"
echo "$SECONDS seconds"
