FROM ubuntu:18.04

RUN apt-get update && apt-get install -y python3 && apt-get install -y python3-pip

RUN mkdir practica_big_data_2019

ENV PROJECT_HOME=/practica_big_data_2019

COPY requirements.txt practica_big_data_2019/

WORKDIR practica_big_data_2019

RUN pip3 install -r requirements.txt

EXPOSE 5000

ENTRYPOINT ["python3", "resources/web/predict_flask.py"]
