FROM python:3

LABEL DJ STINKY IN THE HOUSE LETS GOOOOOOOOOOO

COPY ./requirements.txt /app/requirements.txt
WORKDIR /app

RUN apt-get update -y && apt-get install -y \
    libffi-dev \
    libnacl-dev \
    python3-dev \
    ffmpeg \
    curl https://s3.amazonaws.com//aws-cloudwatch/downloads/latest/awslogs-agent-setup.py -O \
    suod python ./awslogs-agent-setup.py --region eu-west-2
RUN pip install --no-cache-dir -r requirements.txt
COPY . /app

CMD [ "python", "bot.py" ]