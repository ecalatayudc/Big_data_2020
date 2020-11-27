#!/bin/bash

# Import our enriched airline data as the 'airlines' collection
mongoimport --uri mongodb://mongodb:27017/agile_data_science -c origin_dest_distances --file /data/origin_dest_distances.jsonl
mongo mongodb://mongodb:27017/agile_data_science --eval 'db.origin_dest_distances.ensureIndex({Origin: 1, Dest: 1})'
