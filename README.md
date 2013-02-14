# Yumster!

Copyright 2013 Jack Chatterton. Built on Rails 3.2.

## Database configuration

This has been tested with Postgres 9.2.2 running locally and a Heroku Postgres instance, both by way of the pg gem.

## Deploying to Heroku
You can setup a Heroku account for free at [https://devcenter.heroku.com/articles/quickstart](https://devcenter.heroku.com/articles/quickstart)

    heroku create
    heroku addons:add heroku-postgresql:dev
    heroku addons:add mandrill:starter --app {{heroku app name}}
    rake secret # to generate a secret token
    heroku config:set SECRET_TOKEN={{your secret token}}
    git push heroku master
    heroku run rake db:migrate

