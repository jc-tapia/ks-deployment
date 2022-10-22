FROM python:3.8-slim-buster

RUN mkdir /app
WORKDIR /app
ADD . /app/
RUN pip install -r ./app/requirements.txt

EXPOSE 5000
CMD ["python", "/app/main.py"]