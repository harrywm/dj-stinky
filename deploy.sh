
## aws cli login
aws ecr get-login-password --region eu-west-2 | docker login --username AWS --password-stdin 818224701131.dkr.ecr.eu-west-2.amazonaws.com


#build docker image
echo 'Build Docker Image...'
docker build -t djstinky:latest . > /dev/null
echo 'Done'

#tag and push
echo 'Tag and Push...'
docker tag djstinky:latest 818224701131.dkr.ecr.eu-west-2.amazonaws.com/dj_stinky_repo:latest > /dev/null
docker push 818224701131.dkr.ecr.eu-west-2.amazonaws.com/dj_stinky_repo:latest > /dev/null
echo 'Done'

#remove ecstask role
#aws iam delete-role-policy --role-name ecsTaskExecutionRole --policy-name AmazonECSTaskExecutionRolePolicy
#aws iam delete-role --role-name ecsTaskExecutionRole

#tf init, apply, deploy
echo 'Update ECS Service...'
aws ecs update-service --cluster dj_stinky_cluster --service dj-stinky-service --desired-tasks 1 > /dev/null
echo 'Done'