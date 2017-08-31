#!/bin/bash

. db_settings

export PGPASSWORD=$PASSWORD

pg_dump --clean --file=$FILENAME --user=$USERNAME $DATABASE
