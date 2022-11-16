import numpy as np
import pandas as pd
import re
from sklearn.preprocessing import MinMaxScaler, StandardScaler
from pathlib import Path

DOWNLEN = 10


def norm(train, test):
    """max min(0-1)"""

    normalizer = StandardScaler().fit(train) # scale training data to [0,1] range
    train_ret = normalizer.transform(train)
    test_ret = normalizer.transform(test)

    return train_ret, test_ret



def downsample(data, labels, down_len):
    """down-sample by DOWNLEN"""
    
    np_data = np.array(data)
    np_labels = np.array([0 if label.lower()=='normal' else 1 for label in labels])  # 1 = Anomaly; 0 = Normal

    orig_len, col_num = np_data.shape
    down_time_len = orig_len // down_len
    np_data = np_data.transpose()

    d_data = np_data[:, :down_time_len*down_len].reshape(col_num, -1, down_len)
    d_data = np.median(d_data, axis=2).reshape(col_num, -1)

    d_labels = np_labels[:down_time_len*down_len].reshape(-1, down_len)
    
    
    # if exist anomalies, then this sample is abnormal
    d_labels = np.max(d_labels, axis=1)
             
    d_data = d_data.transpose()

    return d_data.tolist(), d_labels.tolist()



def save_stat(df_data, file):
    """
    Read sensor.csv file for sensor description.
    Append min, max, median and mean value and save as csv file
    """
    
    # Read sensor.csv
    dir_path = Path.cwd().joinpath('swat')
    file_path = dir_path.joinpath('sensor.csv')
    df = pd.read_csv(file_path, header=0)
    df = df.rename(columns=str.title)
    
    # Save statistics as stat dataframe
    stat = df_data.describe().T.get(['min', 'max', '50%', 'mean'])
    stat = stat.reset_index(level=0).rename(columns={'index': 'sensor', '50%':'median'})
    stat = stat.rename(columns=str.title)
    
    # Join sensor description with statistics
    df_combined = df.join(stat.set_index('Sensor'), on='Sensor')
    
    path = dir_path.joinpath(file)
    df_combined.to_csv(path, index=False)



def main():

    test = pd.read_csv('./swat/swat_test.csv')
    train = pd.read_csv('./swat/swat_train.csv')
    
    # trim column names
    train = train.rename(str.strip, axis='columns')
    test = test.rename(str.strip, axis='columns')
    
    # Save statistics for train and test
    save_stat(train, 'train_stat.csv')
    save_stat(test, 'test_stat.csv')

    # Drop Timestamp column for both test and train data
    test = test.iloc[:, 1:]
    train = train.iloc[:, 1:]

    train = train.fillna(0)
    test = test.fillna(0)

    train_labels = train.attack
    test_labels = test.attack

    train = train.drop(columns=['attack'])
    test = test.drop(columns=['attack'])

    x_train, x_test = norm(train.values, test.values)

    for i, col in enumerate(train.columns):
        train.loc[:, col] = x_train[:, i]
        test.loc[:, col] = x_test[:, i]
        
    d_train_x, d_train_labels = downsample(train.values, train_labels, DOWNLEN)
    d_test_x, d_test_labels = downsample(test.values, test_labels, DOWNLEN)

    train_df = pd.DataFrame(d_train_x, columns = train.columns)
    test_df = pd.DataFrame(d_test_x, columns = test.columns)

    test_df['attack'] = d_test_labels
    train_df['attack'] = d_train_labels

    # Remove first 2160 samples
    train_df = train_df.iloc[2160:]
    
    dir_path = Path.cwd().joinpath('processed', 'swat_s')
    
    if not dir_path.is_dir():
        dir_path.mkdir(parents=True, exist_ok=True)
        
    train_path = dir_path.joinpath('train.csv')
    test_path = dir_path.joinpath('test.csv')
    list_path = dir_path.joinpath('list.txt')

    train_df.to_csv(train_path)
    test_df.to_csv(test_path)

    # Save feature names as list.txt
    f = open(list_path, 'w')
    for col in train.columns:
        f.write(col+'\n')
    f.close()
    


if __name__ == '__main__':
    main()
