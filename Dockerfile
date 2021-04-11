FROM python:3

LABEL DJ STINKY IN THE HOUSE LETS GOOOOOOOOOOO

#grab bot stuff
COPY ./requirements.txt /app/requirements.txt
WORKDIR /app

#bot reqs
RUN apt-get update -y && apt-get install -y \
    libffi-dev \
    libnacl-dev \
    python3-dev \
    ffmpeg \
    wget
RUN pip install --no-cache-dir -r requirements.txt

#cloudwatch agent
RUN wget https://s3.amazonaws.com/amazoncloudwatch-agent/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb 
RUN dpkg -i -E ./amazon-cloudwatch-agent.deb

COPY . /app

#go
CMD [ "python", "bot.py" ]