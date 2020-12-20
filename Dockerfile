FROM python:3

LABEL DJ STINKY IN THE HOUSE

COPY ./requirements.txt /app/requirements.txt
WORKDIR /app

RUN apt-get update -y && apt-get install -y \
    libffi-dev \
    libnacl-dev \
    python3-dev \
    ffmpeg
RUN pip install --no-cache-dir -r requirements.txt
COPY . /app

CMD [ "python", "bot.py" ]