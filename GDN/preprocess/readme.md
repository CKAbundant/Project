The directory contains codes to pre-process SWaT and European Credit Card Fraud Dataset (credit dataset)

### SWaT
1. Run `npy2csv.ipynb` to load and combine npy files in both train and test subfolders to generate `swat_train.csv` and `swat_test.csv`. Note that each npy file represent a column in swat dataset.
2. Convert SWaT_Dataset_Normal_v0/SWaT_Dataset_Attack_v0.xlsx to csv, rename 'Normal' / 'Normal/Attack' columns to 'attack' with label 0/1
3. run the script `python process_swat.py`. train.csv, test.csv and list.txt files are generated and saved in 'swat' folder under 'processed' folder.

### Credit
1. Run `npy2csv.ipynb` to load and combile npy files to generate `creditcard.csv`. Note that each npy file represent a column in credit dataset.
2. Rename 'Class' to 'attack' with label 0/1
2. Run `process_credit.ipynb` to generate 14 under-sampled credit datasets and 2 over-sampled credit datasets.

### Random Sampling
1. Run `random_sample.ipynb` to generate random sampling of swat dataset at 10%, 30%, 50%, 70% and 90% of the original swat dataset.
2. `summary.csv` summarize number of records removed or added after under-sampling and over-sampling respectively.
