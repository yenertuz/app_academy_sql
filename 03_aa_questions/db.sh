rm -f questions.db
cat import_db.sql | sqlite3 questions.db