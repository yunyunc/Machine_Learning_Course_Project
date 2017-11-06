The goal of this project is to apply variational inference (VI) techniques into learning the posterior distribution of 
undirected graphical model. We will use Gaussian Markov Random Field and Ising model to solve object recognition and movie recommendation problems. We will try both traditional VI algorithms (loopy belief propagation & mean field approximation) and more recent algorithms such as [1], [2], [3]. Our data sets are [5] and [6]. This project involves applying various machine learning algorithms that we have learned in this class. We will use PCA to learn features from the data and reduce dimensions. Then we will use Gaussian Mixture Model and K-mean clustering to cluster the data. Parameter learning during this step will be done by expectation maximization and bayesian optimization. We will train graphical models on each cluster. We expect to compare the performances of different VI algorithms and analyze the pros and cons of different graphical structure.



Reference:

[1] Stochastic Variational Inference. Matthew D. Hoffman, David M. Blei, Chong Wang, John Paisley. 2013

[2] Doubly Stochastic Variational Bayes for non-Conjugate Inference. Michalis K. Titsias and Miguel Lazaro-Gredilla. 2014

[3] Fast Black-box Variational Inference through Stochastic Trust-Region Optimization. Jeffrey Regier, Michael I. Jordan, Jon McAuliffe. 2017

[5] Right Whale Recognition. https://www.kaggle.com/c/noaa-right-whale-recognition

[6] MovieLens. https://grouplens.org/datasets/movielens/


