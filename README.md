# joeynmt-toy-models

This repo is just a collection of scripts showing how to install [JoeyNMT](https://github.com/joeynmt/joeynmt), preprocess
data, train and evaluate models.

# Requirements

- This only works on a Unix-like system, with bash.
- Python 3 must be installed on your system, i.e. the command `python3` must be available
- Make sure virtualenv is installed on your system. To install, e.g.

    `pip install virtualenv`

# Steps

Clone this repository in the desired place and check out the correct branch:

    git clone https://github.com/bricksdont/joeynmt-toy-models
    cd joeynmt-toy-models
    checkout ex5

Create a new virtualenv that uses Python 3. Please make sure to run this command outside of any virtual Python environment:

    ./scripts/make_virtualenv.sh

**Important**: Then activate the env by executing the `source` command that is output by the shell script above.

Download and install required software:

    ./scripts/download_install_packages.sh

Download and split data:

    ./scripts/download_split_data.sh

Preprocess data:

    ./scripts/preprocess.sh

Then finally train a model:

    ./scripts/train.sh

The training process can be interrupted at any time, and the best checkpoint will always be saved.

Evaluate a trained model with

    ./scripts/evaluate.sh

# Feedback

All the changes were made on the branch apply_bpe on our github repository.

### Data

The language pair and translation direction that we chose is de-en.

### Training

BPE: vocabulary size was first initialized with 2000 subwords. Then, we trained our BPE model with 5000 and 1000 words.
To make this more interesting, we increased the number of epochs from 2 to TODO.

### results: BLEU

We get the following results on BLEU scores:

| use BPE | vocabulary size | BLEU |
| ---: | ---: | ---: |
| no | 2000 | 15.8 |
| yes | 2000 | 16.9 |
| yes | 5000 | 9.3 |
| yes | 10000 | 5.8 |


TODO : How do translations differ if we look at them manually?

### results: beam size VS BLEU

In order to investigate how beam size influences BLEU score, we trained our best model:
use BPE with vocaulary size of 2000

and translated the test set 10 times, each time varyingn the beam size. 

| Beam size | BLEU |
| ---: | ---: |
| 1 | 12.1 |
| 2 | 14.7 |
| 3 | 16.0 |
| 4 | 16.7 |
| 5 | 16.9 |
| 6 | 17.4 |
| 7 | 17.4 |
| 8 | 17.7 |
| 9 | 18.0 |
| 10 | 18.1 |

We plotted a graph to show the results we got. This graph can be found as an image under:

    bleu_beam.png

In order to produce the graph, we created a python script:

    graph.py

TODO : comments about the impact of beam size on BLEU and personal take on which beam size to choose in the future
