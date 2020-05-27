#! /bin/bash
# TODO: add BPE with different vocab size

scripts=`dirname "$0"`
base=$scripts/..

data=$base/data
tools=$base/tools

mkdir -p $base/shared_models

src=de
trg=en

# cloned from https://github.com/bricksdont/moses-scripts
MOSES=$tools/moses-scripts/scripts

bpe_num_operations=2000
bpe_vocab_threshold=10

#################################################################

# measure time

SECONDS=0

# learn BPE model on train (concatenate both languages)

subword-nmt learn-joint-bpe-and-vocab -i $data/train.de-en.$src $data/train.de-en.$trg \
	--write-vocabulary $base/shared_models/vocab.2000.$src $base/shared_models/vocab.2000.$trg \
	-s $bpe_num_operations -o $base/shared_models/$src$trg.2000.bpe

# apply BPE model to train, test and dev

for corpus in train dev test; do
	subword-nmt apply-bpe -c $base/shared_models/$src$trg.2000.bpe --vocabulary $base/shared_models/vocab.2000.$src --vocabulary-threshold $bpe_vocab_threshold < $data/$corpus.de-en.$src > $data/$corpus.bpe.2000.$src
	subword-nmt apply-bpe -c $base/shared_models/$src$trg.2000.bpe --vocabulary $base/shared_models/vocab.2000.$trg --vocabulary-threshold $bpe_vocab_threshold < $data/$corpus.de-en.$trg > $data/$corpus.bpe.2000.$trg
done


# build joeynmt vocab

python $tools/joeynmt/scripts/build_vocab.py $data/train.bpe.2000.$src $data/train.bpe.2000.$trg --output_path $base/shared_models/vocab.2000.txt


# file sizes

for corpus in train dev test; do
	echo "corpus: "$corpus
	wc -l $data/$corpus.bpe.2000.$src $data/$corpus.bpe.2000.$trg
done

wc -l $base/shared_models/*

# sanity checks

echo "At this point, please check that 1) file sizes are as expected, 2) languages are correct and 3) material is still parallel"

echo "time taken:"
echo "$SECONDS seconds"
