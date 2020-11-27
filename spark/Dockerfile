FROM bitnami/spark:2.4.4

USER root

RUN apt update && apt install -y gcc && apt-get install -y git && apt-get install -y gnupg

RUN echo "deb https://dl.bintray.com/sbt/debian /" | tee -a /etc/apt/sources.list.d/sbt.list && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2EE0EA64E40A89B84B2DF73499E82A75642AC823 && \
    apt-get update && apt-get install -y sbt

RUN pip install wheel

RUN cd work/ && git clone https://github.com/ging/practica_big_data_2019.git

RUN work/practica_big_data_2019/resources/download_data.sh

COPY requirements.txt /work/practica_big_data_2019/ 

COPY import_distances.sh /work/practica_big_data_2019/resources/

WORKDIR work/practica_big_data_2019/

RUN sed -i 's/from sklearn.externals import joblib/import joblib/g' /opt/bitnami/spark/work/practica_big_data_2019/resources/web/predict_flask.py

RUN sed -i "s/localhost:9092/kafka:29092/g" /opt/bitnami/spark/work/practica_big_data_2019/resources/web/predict_flask.py

RUN sed -i "s,MongoClient(),MongoClient('mongodb://mongodb:27017/')," /opt/bitnami/spark/work/practica_big_data_2019/resources/web/predict_flask.py

RUN sed -i "s,ELASTIC_URL='http://localhost:9200/agile_data_science',ELASTIC_URL='mongodb://mongodb:27017/agile_data_science'," /opt/bitnami/spark/work/practica_big_data_2019/resources/web/config.py

RUN sed -i 's,localhost:9092,kafka:29092,' /opt/bitnami/spark/work/practica_big_data_2019/flight_prediction/src/main/scala/es/upm/dit/ging/predictor/MakePrediction.scala

RUN sed -i 's,"/home/user/Desktop/practica_big_data_2019","opt/bitnami/spark/work/practica_big_data_2019",' /opt/bitnami/spark/work/practica_big_data_2019/flight_prediction/src/main/scala/es/upm/dit/ging/predictor/MakePrediction.scala

RUN sed -i 's,mongodb://127.0.0.1:27017/agile_data_science.flight_delay_classification_response,mongodb://mongodb:27017/agile_data_science.flight_delay_classification_response,' /opt/bitnami/spark/work/practica_big_data_2019/flight_prediction/src/main/scala/es/upm/dit/ging/predictor/MakePrediction.scala

RUN sed -i "s,mongodb://localhost:27017/agile_data_science.prediction_tasks,mongodb://mongodb:27017/agile_data_science.prediction_tasks," /opt/bitnami/spark/work/practica_big_data_2019/resources/fetch_prediction_requests.py

RUN sed -i "s,mongodb://localhost:27017/agile_data_science.prediction_results,mongodb://mongodb:27017/agile_data_science.prediction_results," /opt/bitnami/spark/work/practica_big_data_2019/resources/load_prediction_results.py

RUN sed -i "s,BROKERS='localhost:9092',BROKERS='kafka:29092'," /opt/bitnami/spark/work/practica_big_data_2019/resources/streaming_test.py

RUN pip install -r requirements.txt

RUN python3 resources/train_spark_mllib_model.py .

RUN cd flight_prediction && sbt package

WORKDIR /

ENTRYPOINT ["spark-submit", "--class", "es.upm.dit.ging.predictor.MakePrediction", "--packages", "org.mongodb.spark:mongo-spark-connector_2.11:2.4.1,org.apache.spark:spark-sql-kafka-0-10_2.11:2.4.0", "--master", "local[4]", "opt/bitnami/spark/work/practica_big_data_2019/flight_prediction/target/scala-2.11/flight_prediction_2.11-0.1.jar"]

