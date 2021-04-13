# dj-stinky     [![Build Status](http://ec2-3-8-139-22.eu-west-2.compute.amazonaws.com/buildStatus/icon?job=DJ+Stinky)](http://ec2-3-8-139-22.eu-west-2.compute.amazonaws.com/job/DJ%20Stinky/)
DJ Stinky number 1 dj in all of discord

Very basic discord.py bot - plays internet radio stations/youtube videos with ffmpeg.
Mostly just an exercise in learning, and practicing CD techniques. 
Webhook test - 

DJ Stinky:
- Infra declared as IaC in /tf
- Deploys on push to master (webhook to Jenkins build).
- Builds, tags and pushes to ECR from Jenkins.
- Updates ECS Task definition, starts Cluster service.
- Container logs through Cloudwatch agent.

