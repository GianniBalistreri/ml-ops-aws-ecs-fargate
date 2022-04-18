"""
Generating inferences from pre-trained machine learning model
"""
from easyexplore.data_import_export import DataExporter, DataImporter
from flask import Flask, request
from typing import Tuple

import os
import pandas as pd


S3_INPUT_BUCKET: str = 's3://gfb-ml-ops-data-for-prediction'
S3_MODEL_BUCKET: str = 's3://gfb-ml-ops-model'
S3_OUTPUT_BUCKET: str = 's3://gfb-ml-ops-inference'
INPUT_FILE_NAME: str = 'data_for_prediction.csv'
OUTPUT_FILE_NAME: str = 'prediction.csv'
MODEL_NAME: str = 'model.p'
PREPROCESSING_FILE_NAME: str = 'processor.json'
MODEL = DataImporter(file_path=os.path.join(S3_MODEL_BUCKET, MODEL_NAME), as_data_frame=False, cloud='aws').file()

app = Flask(__name__)


def pre_processing(df: pd.DataFrame, preprocessing_template: dict) -> pd.DataFrame:
    """
    Generate features like on training process to generate predictions from the model
    """
    _data_set: dict = {}
    for feature in df.columns:
        _data_set.update({feature: df[feature].values.tolist()})
        if feature in preprocessing_template.get('one_hot').keys():
            for value in df[feature].values:
                for one_hot_feature in preprocessing_template.get('one_hot')[feature]:
                    if _data_set.get(one_hot_feature) is None:
                        _data_set.update({one_hot_feature: []})
                    if str(f'{feature}_{value}') == one_hot_feature:
                        _data_set[one_hot_feature].append(1)
                    else:
                        _data_set[one_hot_feature].append(0)
    if df.shape[0] == 1:
        return pd.DataFrame(data=_data_set, index=[0])
    return pd.DataFrame(data=_data_set)

@app.route('/ping', methods=['GET'])
def ping() -> Tuple[str, int]:
    """
    Check whether container is running (alive) or not
    """
    return 'Inference service is alive!', 200

@app.route('/inference', methods=['GET', 'POST'])
def inference() -> Tuple[dict, int]:
    """
    Generate inference from pre-trained model using request data
    """
    _processor: dict = DataImporter(file_path=os.path.join(S3_MODEL_BUCKET, PREPROCESSING_FILE_NAME), as_data_frame=False).file()
    _raw_data: dict = request.get_json(force=True)
    _df = pre_processing(df=pd.DataFrame(data=_raw_data, index=[0]), preprocessing_template=_processor)
    _prediction = MODEL.predict(_df[_processor.get('predictors')].values)
    _response: dict = dict(predictions=_prediction)
    return _response, 200

@app.route('/inference_s3', methods=['GET', 'POST'])
def inference() -> int:
    """
    Generate inference from pre-trained model using data set from s3 bucket
    """
    _processor: dict = DataImporter(file_path=os.path.join(S3_MODEL_BUCKET, PREPROCESSING_FILE_NAME), as_data_frame=False).file()
    _df_raw: pd.DataFrame = DataImporter(file_path=os.path.join(S3_INPUT_BUCKET, INPUT_FILE_NAME), use_dask=False, sep=',').file()
    _df = pre_processing(df=_df_raw, preprocessing_template=_processor)
    _predictions = MODEL.predict(_df[_processor.get('predictors')].values)
    _df['prediction'] = _predictions
    DataExporter(obj=_df, file_path=os.path.join(S3_OUTPUT_BUCKET, OUTPUT_FILE_NAME), sep=',', cloud='aws').file()
    return 200

if __name__ == '__main__':
    app.run(host='0.0.0.0', debug=True)