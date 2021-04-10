FROM python:3

LABEL DJ STINKY IN THE HOUSE LETS GOOOOOOOOOOO

COPY ./requirements.txt /app/requirements.txt
WORKDIR /app

RUN apt-get update -y && apt-get install -y \
    libffi-dev \
    libnacl-dev \
    python3-dev \
    ffmpeg \
    wget
RUN wget https://s3.amazonaws.com/amazoncloudwatch-agent/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb 
RUN dpkg -i -E ./amazon-clouwatch-agent.deb
RUN pip install --no-cache-dir -r requirements.txt
COPY . /app

CMD [ "python", "bot.py" ]