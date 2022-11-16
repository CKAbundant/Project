import numpy as np
import pandas as pd
import re
from sklearn.preprocessing import MinMaxScaler

DOWNLEN = 1

# max min(0-1)
def norm(train, test):

    normalizer = MinMaxScaler(feature_range=(0, 1)).fit(train) # scale training data to [0,1] range
    train_ret = normalizer.transform(train)
    test_ret = normalizer.transform(test)

    return train_ret, test_ret

# downsample by DOWNLEN
def downsample(data, labels, down_len):
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


def main():

    test = pd.read_csv('./swat_test.csv')
    train = pd.read_csv('./swat_train.csv')


    test = test.iloc[:, 1:]
    train = train.iloc[:, 1:]

#     train = train.fillna(train.mean())
#     test = test.fillna(test.mean())
    train = train.fillna(0)
    test = test.fillna(0)

    # trim column names
    train = train.rename(str.strip, axis='columns')
    test = test.rename(str.strip, axis='columns')

#     print(len(test.columns),test.columns)
#     print(len(train.columns),train.columns)


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

    train_df = train_df.iloc[2160:]

    train_df.to_csv('./train.csv')
    test_df.to_csv('./test.csv')

    f = open('./list.txt', 'w')
    for col in train.columns:
        f.write(col+'\n')
    f.close()

if __name__ == '__main__':
    main()
