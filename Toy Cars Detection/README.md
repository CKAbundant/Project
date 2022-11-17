# Toy Cars Detection using Transfer Learning
* Use pretrained detectnet model in NVIDIA [TAO (Train Adapt Optimize)](https://catalog.ngc.nvidia.com/orgs/nvidia/teams/tao/containers/tao-toolkit-tf) container
* We use [Object Detection: Batteries, Dice, and Toy Cars](https://www.kaggle.com/datasets/markcsizmadia/object-detection-batteries-dices-and-toy-cars) image set from kaggle.
* Total of 495 toy car images were extracted from the initial 1644 images in the dataset, which are further divided into test and train dataset.

| S/N | File | Description |
| :---: | :---: | :---: |
| 1 | toycars_detectnet_v2.ipynb | Jupyter notebook containing codes for implementation within NVIDIA TAO container |
| 2 | config_infer_primary_toycar_gpu.txt | Text file for configuring TAO container |
| 3 | deepstream_app_source1_video_toycar_gpu.txt | Text file for configuring video output via deepstream application |
| 4 | labels_toycar.txt | Text file to indicate objects for detection |
| 5 | toycars.mp4 | Original video for toy cars detection |
| 6 | toycar_box.mp4 | Processed video after toy cars detection |
