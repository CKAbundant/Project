# Anomaly Detection for Credit Card Fraud Dataset via GDN

1. Codes were modified from the original code implementation for [Graph Neural Network-Based Anomaly Detection in Multivariate Time Series(AAAI'21)](https://arxiv.org/pdf/2106.06947.pdf) that are found in [d-ailin/GDN GitHub](https://github.com/d-ailin/GDN)
2. Anomaly detection is performed on 16 variations of European Credit Card Fraud dataset using GDN.
3. Random sampling of SWaT dataset is performed to validate if performance will degrad as time intervals will no longer be of equal intervals.
4. Experimental methodology, results and findings are documented in `AIIT_Capstone_Group1_Report.pdf` and `Annex_E.pdf`.



# Installation
### Requirements
* Python >= 3.8
* cuda == 11.7
* [Pytorch==1.13.0](https://pytorch.org/)
* [PyG: torch-geometric==2.1.0](https://pytorch-geometric.readthedocs.io/en/latest/notes/installation.html)

### Install packages
```
    # run after installing correct Pytorch package
    bash install.sh
```

### Quick Start
Run to check if the environment is ready
```
    bash run.sh cpu msl
    # or with gpu
    bash run.sh <gpu_id> msl    # e.g. bash run.sh 1 msl
```

# Data Preparation
```
# Put your dataset under data/ directory with the same structure shown in the data/msl/

data
 |-msl
 | |-list.txt    # the feature names, one feature per line
 | |-train.csv   # training data
 | |-test.csv    # test data
 |-your_dataset
 | |-list.txt
 | |-train.csv
 | |-test.csv
 | ...

```

### Notices:
* The first column in .csv will be regarded as index column. 
* The column sequence in .csv don't need to match the sequence in list.txt, we will rearrange the data columns according to the sequence in list.txt.
* test.csv should have a column named "attack" which contains ground truth label(0/1) of being attacked or not(0: normal, 1: attacked)

# Run
```
    # using gpu
    bash run.sh <gpu_id> <dataset>

    # or using cpu
    bash run.sh cpu <dataset>
    
    # or running wrapper.py file for multiple experiments
    python wrapper.py
```
You can change running parameters in the run.sh or wrapper.py

# Others
* Each column of SWaT and European Credit Fraud Dataset are saved a numpy file. 
* Run `npy2csv.ipynb` under `preprocess` folder to re-create the original dataset in csv format. 
* Run `process_credit.ipynb` and `process_swat.py` to generate the required train.csv, test.csv and list.txt for credit dataset and swat dataset respectively.


# Citation
All credit should go to the original researchers on GDN. Please consider citing the paper
```
@inproceedings{deng2021graph,
  title={Graph neural network-based anomaly detection in multivariate time series},
  author={Deng, Ailin and Hooi, Bryan},
  booktitle={Proceedings of the AAAI Conference on Artificial Intelligence},
  volume={35},
  number={5},
  pages={4027--4035},
  year={2021}
}
```
