import os
import numpy as np
import torch
import matplotlib.pyplot as plt
import torch.nn as nn
import time
from datetime import datetime
import pytz
from util.time import *
from util.env import *
from sklearn.metrics import mean_squared_error
from test import *
import torch.nn.functional as F
import numpy as np
from evaluate import get_best_performance_data, get_val_performance_data, get_full_err_scores
from sklearn.metrics import precision_score, recall_score, roc_auc_score, f1_score
from torch.utils.data import DataLoader, random_split, Subset
from scipy.stats import iqr




def loss_func(y_pred, y_true):
    loss = F.mse_loss(y_pred, y_true, reduction='mean')

    return loss



def train(model = None, save_path='', config={},  train_dataloader=None, val_dataloader=None, feature_map={}, test_dataloader=None, test_dataset=None, dataset_name='swat', train_dataset=None):

    seed = config['seed']

    optimizer = torch.optim.Adam(model.parameters(), lr=0.001, weight_decay=config['decay'])

    now = time.time()

    history = {}
    history['train_loss'] = []
    history['val_loss'] = []

    device = get_device()


    acu_loss = 0
    min_loss = 1e+8
    min_f1 = 0
    min_pre = 0
    best_prec = 0

    i = 0
    epoch = config['epoch']
    early_stop_win = config['early_stop']

    model.train()

    log_interval = 1000
    stop_improve_count = 0

    dataloader = train_dataloader

    for i_epoch in range(epoch):

        acu_loss = 0
        model.train()

        for x, labels, attack_labels, edge_index in dataloader:
            _start = time.time()

            x, labels, edge_index = [item.float().to(device) for item in [x, labels, edge_index]]

            optimizer.zero_grad()
            out = model(x, edge_index).float().to(device)
            loss = loss_func(out, labels)

            loss.backward()
            optimizer.step()

            acu_loss += loss.item()

        avg_loss = acu_loss/len(dataloader)

        # use val dataset to judge
        if val_dataloader is not None:

            val_loss, val_result = test(model, val_dataloader)

            # each epoch
            print('epoch ({} / {}) (Loss:{:.8f}, Val_Loss:{:.8f}, ACU_loss:{:.8f})'.format(
                        i_epoch+1, epoch, 
                        avg_loss, val_loss, acu_loss), flush=True
                 )

            history['train_loss'].append(avg_loss)
            history['val_loss'].append(val_loss)

            if val_loss < min_loss:
                torch.save(model.state_dict(), save_path)

                min_loss = val_loss
                stop_improve_count = 0
            else:
                stop_improve_count += 1


            if stop_improve_count >= early_stop_win and early_stop_win != -1:
                break

        else:

            # each epoch
            print('epoch ({} / {}) (Loss:{:.8f}, ACU_loss:{:.8f})'.format(
                        i_epoch+1, epoch, 
                        avg_loss, acu_loss), flush=True
                 )

            history['train_loss'].append(avg_loss)

            if acu_loss < min_loss :
                torch.save(model.state_dict(), save_path)
                min_loss = acu_loss

    plot_perf(history, dataset_name)

    return history



def plot_perf(history, dataset):
    """plot train and validation loss on the same graph"""

    # Create directory to save loss graphs
    directory = os.sep.join([os.getcwd(), 'results', dataset])
    if not os.path.isdir(directory):
        os.makedirs(directory)

    # path to save loss graphs
    curr = datetime.now().astimezone(pytz.timezone('Asia/Singapore')).strftime("%d-%b-%Y_%H%M")
    path = os.sep.join([directory, f"loss_{dataset}_{curr}.png"])

    f_loss = plt.figure(figsize=(10,6))
    x = list(range(1, len(history['train_loss']) + 1))

    if history['val_loss']:
        plt.plot(x, history['val_loss'], color = 'red', label = 'Val_Loss')

    plt.plot(x, history['train_loss'], label = 'Train_Loss')
    plt.xlabel('Epoch')
    plt.ylabel('Loss')
    plt.title(f'Loss over Epochs [{dataset}]')
    plt.legend()

    plt.savefig(path)
    f_loss.clear()
    plt.close(f_loss)

