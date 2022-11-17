# Pokemon Classifier using Transfer Learning
* Build a convolutional neural network model using transfer learning to classify Pokemon
* We use [VGG16](https://keras.io/api/applications/vgg/#vgg16-function) pre-trained model for our classifier 
* Pokemon images are sourced from the web; cropped and resize to 224 by 224 pixels.
* Duplicated images are identified using perceptual hashing (pHash) found in imagehash module.
