require "pg"

PG_URL = "postgres://stuart@localhost:5432/people"
DB     = PG.connect PG_URL
