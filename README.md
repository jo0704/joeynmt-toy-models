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
    checkout ex4

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
| Model | BLEU |
| --- | ---|
| Baseline | 8.9 |
| concatenated | 3.0 |
| summed | None | 

We understand the basic idea behind the "add" and "concatenate" methods and the requirements they need (the source embedding has to be equal to the target embedding). However, we were not able to imply the "add" method successfully, even for the "concatenate" method, we are not sure if the implementation in our code is the right way to achieve that (which is most likely not). 
The problem we see for the "add" method is that source and factor embeddings cannot be added directly together. The main problem is that the dimensions should be equal to each other, but they are different: the source embedding has 2915 dimensions (vocabulary size) and has to match the factor embedding which has 57.
That's why we get a RuntimeError and our implementation for adding embeddings does not work.
Overall, we spent a lot of time to understand the code and to study documentation about pytorch on how to implement these two methods.
For this assignment, we spent more than 10 hours (not to mention the errors that had to be solved in train.sh and the uncountable hours taking pytorch tutorials). 