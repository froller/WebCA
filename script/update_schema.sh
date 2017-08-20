#!/bin/sh

script/webca_create.pl --mechanize model DB DBIC::Schema WebCA::Schema create=static dbi:mysql:webca webca webca_123
