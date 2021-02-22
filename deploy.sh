
#build docker image
docker build -t djstinky:latest .

## aws cli login
aws ecr get-login-password --region eu-west-2 | docker login --username AWS --password-stdin 818224701131.dkr.ecr.eu-west-2.amazonaws.com

#tag and push
docker tag djstinky:latest 818224701131.dkr.ecr.eu-west-2.amazonaws.com/dj_stinky_repo:latest
docker push 818224701131.dkr.ecr.eu-west-2.amazonaws.com/dj_stinky_repo:latest

#remove ecstask role
#aws iam delete-role-policy --role-name ecsTaskExecutionRole --policy-name AmazonECSTaskExecutionRolePolicy
#aws iam delete-role --role-name ecsTaskExecutionRole

#tf init, apply, deploy
aws ecs update-service --cluster dj_stinky_cluster --service dj-stinky-service