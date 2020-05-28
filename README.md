# MT Exercise 5: Byte Pair Encoding, Beam Search

**Due date: Friday, May 29 2020, 14:00**

This repo contains scripts and translation results for 5th exercise of machine translation course, 
as well as feedback this assignment.

# Requirements

- This only works on a Unix-like system, with bash.
- Python 3 must be installed on your system, i.e. the command `python3` must be available
- Make sure virtualenv is installed on your system. To install, e.g.

    `pip install virtualenv`

# Steps

Clone this repository in the desired place and check out the correct branch:

    git clone https://github.com/bricksdont/joeynmt-toy-models
    cd joeynmt-toy-models
    checkout apply_bpe

Create a new virtualenv that uses Python 3. Please make sure to run this command outside of any virtual Python environment:

    ./scripts/make_virtualenv.sh

**Important**: Then activate the env by executing the `source` command that is output by the shell script above.

Download and install required software:

    ./scripts/download_install_packages.sh

Download prepared data:

    ./scripts/download_data.sh

Preprocess data:

    ./scripts/preprocess.sh

Then finally train a model:

    ./scripts/train.sh

The training process can be interrupted at any time, and the best checkpoint will always be saved.

Evaluate trained models for task 1 with

    ./scripts/evaluate.sh

Evaluate trained models for task 2 with

    ./scripts/evaluate_beam.sh

# Feedback

All the changes were made on the branch [apply_bpe](https://github.com/jo0704/joeynmt-toy-models/tree/apply_bpe) on our github repository.

## Data

The language pair and translation direction that we chose is de-en.

## Training

BPE: vocabulary size was first initialized with 2000 subwords. Then, we trained our BPE model with 5000 and 1000 words.
Regarding the training time with a GPU-enabled machine, we increased the number of epochs from 2 to 8.

## Results: Task 1

We get the following results on BLEU scores:

| use BPE | vocabulary size | BLEU |
| ---: | ---: | ---: |
| no | 2000 | 15.8 |
| yes | 2000 | 16.9 |
| yes | 5000 | 9.3 |
| yes | 10000 | 5.8 |

TODO : explain results

As we can see from the table, low-resource set up can benefit from BPE, but in a constrained way: the vocabulary size
plays a important role here. Larger vocabulary size doesn't contribute to performance...

TODO : How do translations differ if we look at them manually?

## Results: Task 2

In order to investigate how beam size influences BLEU score, we trained our best model:
**BPE with vocaulary size of 2000** and translated the test set 10 times, each time varying the beam size. 

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

## Problems
If 2-3 models were training one after another without stopping in a single bash script, 
after first model was trained,
there would be an error indicating GPU memory was full and training process could not be proceeded, 
actually we think it might be a bug from pytorch because pytorch didn't reallocate GPU memory to new training sessions 
after previous sessions were already finished. 
The solution is simple but annoying: reboot the computer to empty the GPU memory will solve the problem in no time.
