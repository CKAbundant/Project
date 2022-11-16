from main import Main
import itertools

# Hyperparameters
BATCH = 32
EPOCH = 100

SEED = 5
VAL_RATIO = 0.1
EARLY_STOP = -1
REPORT = 'best'
DEVICE = 'cuda'
MODEL_PATH = ''

slide_win = [20]
dim = [64]
slide_stride = [1]
out_layer_num = [3]
out_layer_inter_dim = [128]
decay = [0]
topk = [20]
dataset = [
    'adasyn_1'
]


combi = itertools.product(slide_win, dim, slide_stride, out_layer_num, out_layer_inter_dim, decay, topk, dataset)

for item in combi:
    train_config = {
        'batch': BATCH,
        'epoch': EPOCH,
        'slide_win': item[0],
        'dim': item[1],
        'slide_stride': item[2],
        'comment': item[7],
        'seed': SEED,
        'out_layer_num': item[3],
        'out_layer_inter_dim': item[4],
        'decay': item[5],
        'val_ratio': VAL_RATIO,
        'topk': item[6],
        'early_stop': EARLY_STOP,
    }

    env_config={
        'save_path': item[7],
        'dataset': item[7],
        'report': REPORT,
        'device': DEVICE,
        'load_model_path': MODEL_PATH,
    }

    main = Main(train_config, env_config, debug=False)
    main.run()

