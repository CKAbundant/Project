# Objective
* Classify age of abalone from physical measurements

# Dataset
* Obtained from [Abalone Data Set](https://archive.ics.uci.edu/ml/datasets/Abalone) from UCI Machine Learning Repository.
* Target of classification will be Age of abalones, which is determined by the number of rings counted by cutting the shell through the cone of the abalone and staining it. Age in years of abalones is given by: `Age (in years) = Number of Rings + 1.5`
* 7 out of 8 attributes in the data set are considered suitable features:
    - Sex (Removed as gender is not likely to be effective in age classification)
    - Length
    - Diameter
    - Height
    - Whole weight (whole abalone)
    - Shucked weight (Weight of meat)
    - Viscera weight (gut weight i.e. after bleeding)
    - Shell weight (after being dried)

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

