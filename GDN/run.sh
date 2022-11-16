#!/bin/bash
gpu_n=$1
DATASET_LIST=(
    'machine-1-1' 'machine-1-2' 'machine-1-3' 'machine-1-4' 'machine-1-5' \
    'machine-1-6' 'machine-1-7' 'machine-1-8' \
    'machine-2-1' 'machine-2-2' 'machine-2-3' 'machine-2-4' 'machine-2-5' \
    'machine-2-6' 'machine-2-7' 'machine-2-8' 'machine-2-9' \
    'machine-3-1' 'machine-3-2' 'machine-3-3' 'machine-3-4' 'machine-3-5' \
    'machine-3-6' 'machine-3-7' 'machine-3-8' 'machine-3-9' \
    'machine-3-10' 'machine-3-11'
)

seed=5
BATCH_SIZE=32
SLIDE_WIN=5
dim=64
out_layer_num=2
SLIDE_STRIDE=1
topk=5
out_layer_inter_dim=128
val_ratio=0.05
decay=0
early_stop=-1

# path_pattern="${DATASET}""
# COMMENT="${DATASET}"

EPOCH=1000
report='best'

for DATASET in "${DATASET_LIST[@]}"
do
    if [[ "$gpu_n" == "cpu" ]]; then
        python main.py \
            -dataset $DATASET \
            -save_path_pattern "${DATASET}" \
            -slide_stride $SLIDE_STRIDE \
            -slide_win $SLIDE_WIN \
            -batch $BATCH_SIZE \
            -epoch $EPOCH \
            -comment "${DATASET}" \
            -random_seed $seed \
            -decay $decay \
            -dim $dim \
            -out_layer_num $out_layer_num \
            -out_layer_inter_dim $out_layer_inter_dim \
            -decay $decay \
            -val_ratio $val_ratio \
            -report $report \
            -topk $topk \
            -device 'cpu' \
            -early_stop $early_stop
    else
        CUDA_VISIBLE_DEVICES=$gpu_n  python main.py \
            -dataset $DATASET \
            -save_path_pattern "${DATASET}" \
            -slide_stride $SLIDE_STRIDE \
            -slide_win $SLIDE_WIN \
            -batch $BATCH_SIZE \
            -epoch $EPOCH \
            -comment "${DATASET}" \
            -random_seed $seed \
            -decay $decay \
            -dim $dim \
            -out_layer_num $out_layer_num \
            -out_layer_inter_dim $out_layer_inter_dim \
            -decay $decay \
            -val_ratio $val_ratio \
            -report $report \
            -topk $topk \
            -early_stop $early_stop
    fi
done
