export REPO=mlflow
export ID=086726293497
aws ecr get-login-password --region eu-central-1 | sudo docker login --username AWS --password-stdin $ID.dkr.ecr.eu-central-1.amazonaws.com
sudo docker build -t $REPO .
sudo docker tag $REPO:latest $ID.dkr.ecr.eu-central-1.amazonaws.com/$REPO:latest
sudo docker push $ID.dkr.ecr.eu-central-1.amazonaws.com/$REPO:latest