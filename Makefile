## Migrate database and run specs
##   $ make all
## Migrate database only
##   $ make migrate
## Runs specs only
##   $ make spec

migrate:
# sqlite3 ./crecto_test.db < spec/migrations/sqlite3_migrations.sql
# ifndef PG_URL
# 	$(error PG_URL is undefined)
# else
# 	psql -q $(PG_URL) < ./spec/migrations/pg_migrations.sql
# endif

spec:
	crystal spec

all: migrate spec

.PHONY: migrate spec all
