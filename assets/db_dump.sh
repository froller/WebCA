#!/bin/bash

. db_settings

mysqldump --add-drop-database --add-drop-table --complete-insert --skip-extended-insert --user=$USERNAME --password=$PASSWORD $DATABASE > $FILENAME

