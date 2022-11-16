import argparse
import pandas as pd
import numpy as np
from pathlib import Path
import shutil



def sampling(dataset, percent):
    """
    Randomly remove items from dataset based on percentage provided
    """
    
    # Read original train.csv
    file_path = Path.cwd().joinpath('data', dataset, 'train.csv')
    df = pd.read_csv(file_path, header=0)
    size = len(df)
    
    # Create directories to save randomly sampled train data
    dir_name = f"{dataset}_{int(percent*100)}"
    path = Path.cwd().joinpath('data', dir_name)
    
    if not path.is_dir():
        path.mkdir(parents=True)
    
    # Randomly sample train data
    num_data = int(round(percent * size, 0))
    index = sorted(np.random.choice(size, num_data, replace=False))
    df_sample = df.loc[index, :].reset_index(drop=True)
    
    # Print sampling percentage and size of data sample
    print(f"Sampling percentage and sample size: {percent}, {len(df_sample)}")
    
    # Save train data as train.csv in respective directories
    df_sample.to_csv(path.joinpath('train.csv'), index=False)
    
    # Copy test.csv and list.txt to new directories
    for file in ['test.csv', 'list.txt']:
        copy_file(dataset, dir_name, file)
    
    return df_sample



def copy_file(old, new, file):
    """
    Copy file from old folder to new folder
    """
    
    old_path = Path.cwd().joinpath('data', old, file)
    new_path = Path.cwd().joinpath('data', new, file)
    
    shutil.copy(old_path, new_path)



if __name__ == "__main__":

    parser = argparse.ArgumentParser()
    parser.add_argument('-dataset', help='dataset to downsample', type = str, default='')
    args = parser.parse_args()

    sample = {}
    dataset = args.dataset

    # Generate sampling size from 50% to 90% of dataset
    for i in range(5, 10):
    
        sample_percent = i/10
    
        # Generate sample
        df_temp = sampling(dataset, sample_percent)
        key = f"{dataset}_{int(sample_percent*100)}"
        sample[key] = df_temp
