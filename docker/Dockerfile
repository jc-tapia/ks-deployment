FROM python:3.8-slim-buster

RUN mkdir /app
WORKDIR /app
ADD . /app/
RUN pip install --upgrade pip
RUN python -m venv venv
RUN source ./venv/bin/activate
RUN pip install -r ./app/requirements.txt

EXPOSE 5000
CMD ["python", "/app/main.py"]