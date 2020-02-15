# digit-classifier

This Machine Learning project implements the **Expectation Maximization** algorithm using *Bernoulli* mixes (1-32 mixes were tested) in order to classify digits.

## Run

Firstly, a train + test dataset is given on the `mnist_all.mat` file.

By running `bernoullimix3.m` file you train the dataset for all bernoulli mixes. 
If you run `draw_digits.m` after that for different values of `Kplot` (number of mixes), you will see what we have *learned* from the test dataset for each mix (larger `K` means a larger pool of different forms for every digit). 
Lastly, if you run the `test_digits.m` file you will get the final results (*avg error percentage* for every mix and for every digit/mix) on a `results.txt` file.

## Install

The code was executed in `Matlab` (version: `R2011a`).

## Presentation

[Here](https://github.com/bblodfon/digit-classifier/blob/master/Digit%20classification%20(EM-BernoulliMix).pptx) you can find the presentation I did of this project for the Machine Learning Course, during my MSc (AUEB) in 2014.
