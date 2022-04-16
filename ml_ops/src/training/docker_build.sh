export REPO=training
export ID=086726293497
export REGION=eu-central-1
aws ecr get-login-password --region $REGION | sudo docker login --username AWS --password-stdin $ID.dkr.ecr.$REGION1.amazonaws.com
sudo docker build -t $REPO .
sudo docker tag $REPO:latest $ID.dkr.ecr.$REGION.amazonaws.com/$REPO:latest
sudo docker push $ID.dkr.ecr.$REGION.amazonaws.com/$REPO:latest