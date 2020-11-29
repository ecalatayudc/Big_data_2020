FROM mongo:4.2

RUN mkdir practica_big_data_2019

WORKDIR practica_big_data_2019

ENTRYPOINT ["mongoimport", "--uri", "mongodb://mongodb:27017/agile_data_science", "-c", "origin_dest_distances", "--file", "data/origin_dest_distances.jsonl"]
