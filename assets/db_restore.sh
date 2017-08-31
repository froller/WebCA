#!/bin/bash

. db_settings

export PGPASSWORD=$PASSWORD

psql --user=$USERNAME --password=$PASSWORD $DATABASE  < $FILENAME
