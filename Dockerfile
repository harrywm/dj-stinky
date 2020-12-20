FROM python:3

LABEL DJ STINKY IN THE HOUSE

COPY ./requirements.txt /app/requirements.txt
WORKDIR /app

RUN apt-get update -y

RUN apt-get install -y libffi-dev
RUN apt-get install -y libnacl-dev
RUN apt-get install -y python3-dev
RUN apt-get install -y ffmpeg
RUN pip install --no-cache-dir -r requirements.txt
COPY . /app

CMD [ "python", "bot.py" ]