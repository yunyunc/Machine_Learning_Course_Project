The goal of this project is to apply variational inference (VI) techniques into learning the posterior distribution of 
undirected graphical model. We will use Gaussian Markov Random Field and Ising model to solve image classfication problems. 
We will use algorithms introduced in [1] [2] [3] [4] to train the models. Our data sets are [5] and [6]. The preprocessing phase
of this project involves applying various machine learning algorithms that we have learned in this class. We will use Gaussian Mixture
Model and K-mean clustering to cluster the data first. Parameter learning during this step will be done by expectation maximization 
and bayesian optimization. The second step is to train graphical model on each cluster. We expect to compare the performances of 
different VI algorithms and analyze the pros and cons of different graphical structure.



Reference:

[1] Stochastic Variational Inference. Matthew D. Hoffman, David M. Blei, Chong Wang, John Paisley. 2013

[2] Fixed-Form Variational Posterior Approximation through Stochastic Linear Regression. Tim Saliman and  David A. Knowles. 2014

[3] Doubly Stochastic Variational Bayes for non-Conjugate Inference. Michalis K. Titsias and Miguel Lazaro-Gredilla. 2014

[4] Fast Black-box Variational Inference through Stochastic Trust-Region Optimization. Jeffrey Regier, Michael I. Jordan, Jon McAuliffe. 2017

[5] Right Whale Recognition. https://www.kaggle.com/c/noaa-right-whale-recognition

[6] CIFAR-10 - Object Recognition in Images. https://www.kaggle.com/c/cifar-10


