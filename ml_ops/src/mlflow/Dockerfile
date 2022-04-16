FROM python:3.8.0

RUN pip install \
    mlflow \
    boto3 & \
    mkdir /mlflow/

EXPOSE 5000

## Environment variables made available through the Fargate task.
CMD mlflow server \
    --host 0.0.0.0 \
    --port 5000 \
    --default-artifact-root ${BUCKET}