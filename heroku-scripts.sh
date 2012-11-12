#!/usr/bin/env bash
# This script is largely borrowed from https://devcenter.heroku.com/articles/django
# with a few small tweaks.  Lu Guanqun <guanqun.lu@gmail.com>

PROJECT_NAME=$1

mkdir -p ${PROJECT_NAME}
cd ${PROJECT_NAME}

virtualenv venv --distribute --no-site-packages

source venv/bin/activate

pip install Django psycopg2 dj-database-url

django-admin.py startproject ${PROJECT_NAME} .

pip freeze | egrep "Django|dj-database|psycopg2" > requirements.txt

cat >> ${PROJECT_NAME}/settings.py << EOF
import dj_database_url
DATABASES['default'] =  dj_database_url.config()
EOF

cat >> .gitignore << EOF
venv
*.pyc
EOF

git init
git add .
git commit -m "initial commit for ${PROJECT_NAME}"

heroku create
git push heroku master

echo "The first skeleton of a Django on Heroku is done!"
