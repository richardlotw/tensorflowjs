
Automatic deployment of tensorflow models as rest apis to Vercel using tensorflow serving.

# Try it out.

[![Deploy with Vercel](https://vercel.com/button)](https://vercel.com/new/clone?repository-url=https%3A%2F%2Fgithub.com%2Fvercel%2Fexamples%2Ftree%2Fmain%2Fpython%2Fflask3&demo-title=Flask%203%20%2B%20Vercel&demo-description=Use%20Flask%203%20on%20Vercel%20with%20Serverless%20Functions%20using%20the%20Python%20Runtime.&demo-url=https%3A%2F%2Fflask3-python-template.vercel.app%2F&demo-image=https://assets.vercel.com/image/upload/v1669994156/random/flask.png)

# How to use:

1. Save your Tensorflow model using Tensorflow SaveModel API

2. Create a model cofiguration file in the model base path

3. zip the model in tar.gz format and upload to a public aws bucket

4. Click the deploy button on this repo to deploy the model

Visit the [documentation](https://github.com/JesuFemi-O/Cruise/blob/main/documentation.md) for a detailed guide.

# How to test it

on clicking the deploy button:

you can use this aws bucket url for deployment:

```
https://cruise-bucket.s3.amazonaws.com/tf-models.tar.gz
```

set the MODEL_FOLDER_NAME to img_classifier

then deploy on your heroku account.

on successful deployment, navigate to:

```
https://YOUR-APP-NAME.herokuapp.com/v1/models/YOUR-MODEL-NAME
```

you should see something simiilar to:

```
{
 "model_version_status": [
  {
   "version": "1",
   "state": "AVAILABLE",
   "status": {
    "error_code": "OK",
    "error_message": ""
   }
  }
 ]
}

```

if you used the url above, here's a simple python script you can run on your PC to test the model:

```
import requests
import json
import numpy as np
from tensorflow.keras.datasets.mnist import load_data


#load MNIST dataset
(_, _), (x_test, y_test) = load_data()

# reshape data to have a single channel
x_test = x_test.reshape((x_test.shape[0], x_test.shape[1], x_test.shape[2], 1))

# normalize pixel values
x_test = x_test.astype('float32') / 255.0


test_img = x_test[0]

YOUR_APP_NAME = "the-name-of-your-heroku-app"
url = f'https://{YOUR_APP_NAME}.herokuapp.com/v1/models/img_classifier:predict'


def make_prediction(instances, many=False):
    if not many:
        data = json.dumps({"signature_name": "serving_default", "instances": [instances.tolist()]})
    else:
        data = json.dumps({"signature_name": "serving_default", "instances": instances.tolist()})
    headers = {"content-type": "application/json"}
    json_response = requests.post(url, data=data, headers=headers)
    predictions = json.loads(json_response.text)['predictions']
    return predictions


for p in make_prediction(test_img):
    print(np.argmax(p))
```

# Features:

The end goal is to allow you effortlessly deploy your Tensorflow models to heroku and test it easily.

- [x] allow users deploy multiple versions of their models to heroku with the click of a button

- [x] allow users to easily extend their server to serve multiple Tensorflow models

# References:

- Tensorflow Serving [Documentation](https://www.tensorflow.org/tfx/guide/serving)
- A [Tutorial](https://neptune.ai/blog/how-to-serve-machine-learning-models-with-tensorflow-serving-and-docker) on TF-Serving with Docker
