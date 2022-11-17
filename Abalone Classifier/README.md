# Objective
* Classify age of abalone from physical measurements

# Dataset
* Obtained from [Abalone Data Set](https://archive.ics.uci.edu/ml/datasets/Abalone) from UCI Machine Learning Repository.

# Classification Approach
1. Age will be categorized into 5 classes. 
2. Same training set and test set will be used. Training set and test set are normalized (i.e. subtract by mean and divided by standard deviation) separately to avoid [data leak](https://scikit-learn.org/stable/modules/generated/sklearn.preprocessing.scale.html).
3. Classification will be performed using following 5 algorithims:
    - Logistic Regression
    - Decision Tree
    - Random Forest
    - Support Vector Machine
    - Naive Bayes
4. Performance of each algorithm will be accessed by F1-Score, Precision, Recall and AUC. 

