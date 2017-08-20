#!/bin/bash

. db_settings

mysql --user=$USERNAME --password=$PASSWORD $DATABASE --batch < $FILENAME

