echo "Changing desired tasks to $1";
aws ecs update-service --cluster dj_stinky_cluster --service stinky_service --desired-count $1 > /dev/null
echo "Done";