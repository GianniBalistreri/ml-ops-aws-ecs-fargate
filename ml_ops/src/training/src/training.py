from easyexplore.data_import_export import DataImporter
#from happy_learning.feature_engineer import FeatureEngineer
from happy_learning.genetic_algorithm import GeneticAlgorithm
from typing import List

import boto3
import io
import json
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
    _predictors: List[str] = []
    _transformation: dict(one_hot={})
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
    _predictors.extend(['Total Volume', '4046', '4225', '4770', 'Total Bags', 'Small Bags', 'Large Bags', 'XLarge Bags'])
    _processor_file_path: str = os.path.join(S3_OUTPUT_BUCKET, S3_PROCESSOR_FOLDER, PROCESSOR_FILE_NAME)
    print(f'Save processor file to S3 bucket ({_processor_file_path}) ...')
    _processor: dict = dict(target_feature=TARGET_FEATURE, predictors=_predictors, one_hot=_transformation.get('one_hot'))
    _aws_s3_client = boto3.client('s3', region_name=REGION)
    _buffer: io.BytesIO = io.BytesIO()
    with open(_processor_file_path, 'w', encoding='utf-8') as file:
        json.dump(obj=_processor, fp=file, ensure_ascii=False)
    _aws_s3_client.put_object(Body=_buffer.getvalue(), Bucket=S3_OUTPUT_BUCKET, Key=f'/{S3_PROCESSOR_FOLDER}/{PROCESSOR_FILE_NAME}')
    print('Start modeling using evolutionary algorithm ...')
    _ga: GeneticAlgorithm = GeneticAlgorithm(mode='model', feature_engineer=_feature_engineer, output_file_path=S3_OUTPUT_BUCKET)
    _ga.optimize()
    print('Finished modeling')

if __name__ == '__main__':
    main()
