from easyexplore.data_import_export import DataImporter
#from happy_learning.feature_engineer import FeatureEngineer
from happy_learning.genetic_algorithm import GeneticAlgorithm
from typing import List

import boto3
import io
import json
import numpy as np
import os
import pandas as pd

S3_INPUT_BUCKET: str = 's3://gfb-ml-ops-training'
S3_OUTPUT_BUCKET: str = 's3://gfb-ml-ops-model'
S3_PROCESSOR_FOLDER: str = 'processing'
TRAINING_FILE_NAME: str = 'training_data.csv'
PROCESSOR_FILE_NAME: str = 'processor.json'
REGION: str = 'eu-central-1'
TARGET_FEATURE: str = 'AveragePrice'


def main():
    """
    Run pre-processing and modeling
    """
    _input_file_path: str = os.path.join(S3_INPUT_BUCKET, TRAINING_FILE_NAME)
    print(f'Load data set from S3 bucket ({_input_file_path}) ...')
    _df: pd.DataFrame = DataImporter(file_path=_input_file_path, as_data_frame=True, use_dask=False, sep=',', cloud='aws').file()
    _df[TARGET_FEATURE] = _df[TARGET_FEATURE].astype(float)
    _predictors: List[str] = ['Total Volume', '4046', '4225', '4770', 'Total Bags', 'Small Bags', 'Large Bags', 'XLarge Bags']
    _transformation: dict = dict(one_hot={})
    print('Generate one-hot encoded features ...')
    for feature in ['type', 'year', 'region']:
        _transformation['one_hot'].update({feature: []})
        _dummies: pd.DataFrame = pd.get_dummies(data=_df[feature],
                                                prefix=None,
                                                prefix_sep='_',
                                                dummy_na=True,
                                                columns=None,
                                                sparse=False,
                                                drop_first=False,
                                                dtype=np.int64
                                               )
        _dummies = _dummies.loc[:, ~_dummies.columns.duplicated()]
        _predictors.extend(_dummies.columns.tolist())
        _transformation['one_hot'][feature].extend(_dummies.columns.tolist())
        _df = pd.concat(objs=[_df, _dummies], axis=1)
    _processor_file_path: str = os.path.join(S3_OUTPUT_BUCKET, S3_PROCESSOR_FOLDER, PROCESSOR_FILE_NAME)
    print(f'Save processor file to S3 bucket ({_processor_file_path}) ...')
    _processor: dict = dict(target_feature=TARGET_FEATURE, predictors=_predictors, one_hot=_transformation.get('one_hot'))
    _aws_s3_client = boto3.client('s3', region_name=REGION)
    _buffer: io.BytesIO = io.BytesIO()
    json.dump(obj=_processor, fp=_buffer, ensure_ascii=False)
    _s3_bucket_name: str = S3_OUTPUT_BUCKET.split('//')[1]
    _aws_s3_client.put_object(Body=_buffer.getvalue(), Bucket=_s3_bucket_name, Key=f'{S3_PROCESSOR_FOLDER}/{PROCESSOR_FILE_NAME}')
    print('Start modeling using evolutionary algorithm ...')
    _ga: GeneticAlgorithm = GeneticAlgorithm(mode='model', target=TARGET_FEATURE, features=_predictors, df=_df, models=['cat'], max_generations=2, pop_size=10, cloud='aws', verbose=True, mlflow_log=False, output_file_path=S3_OUTPUT_BUCKET)
    _ga.optimize()
    print('Finished modeling')

if __name__ == '__main__':
    main()
