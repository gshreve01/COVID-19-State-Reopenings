import os
basedir = os.path.abspath(os.path.dirname(__file__))
# SQLALCHEMY_DATABASE_URI = os.environ['DATABASE_URL']
SQLALCHEMY_DATABASE_URI = "postgresql://localhost/Covid19?user=Greg&password=chrisin05"


