sqlite3 home-assistant_v2.db .dump \
| sed -re 's/^PRAGMA .+OFF/SET FOREIGN_KEY_CHECKS=0;SET UNIQUE_CHECKS=0/' \
       -e 's/^CREATE INDEX .+//' \
       -e 's/^BEGIN TRANSACTION;$/SET autocommit=0;BEGIN;/' \
       -e '/^CREATE TABLE .+ \($/,/^\);/ d' \
       -e 's/^INSERT INTO "([^"]+)"/INSERT INTO \1/' \
       -e 's/\\n/\n/g' \
| perl -pe 'binmode STDOUT, ":utf8";s/\\u([0-9A-Fa-f]{4})/pack"U*",hex($1)/ge' \
| mysql hass_db --default-character-set=utf8 -u hass_user -p
