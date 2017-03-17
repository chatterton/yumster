# Yumster!

Check it: [http://www.yumster.co](http://www.yumster.co)

## Development

Start with `bundle install`

Make sure postgres is installed, and create a development database:
`createdb yumster_dev`

Create the database structure: `rake db:migrate`

List various rake tasks: `bundle exec rake --tasks`

## Deployment

### Database configuration

This has been tested with Postgres 9.2.2 running locally and a Heroku Postgres instance, both by way of the pg gem.

### Deploying to Heroku
You can setup a Heroku account for free at [https://devcenter.heroku.com/articles/quickstart](https://devcenter.heroku.com/articles/quickstart)

    heroku create
    heroku addons:add heroku-postgresql:dev
    heroku addons:add mandrill:starter --app {{heroku app name}}
    rake secret # to generate a secret token
    heroku config:set SECRET_TOKEN={{your secret token}}
    git push heroku master
    heroku run rake db:migrate

## Shoutouts

Yumster is built with the [Ruby on Rails](http://rubyonrails.org/) framework.

Illustrations and logo care of the amazing [Ava Savitsky](http://www.avasavitsky.com/).

Glyphs by [Font Awesome](http://fortawesome.github.com/Font-Awesome/).

Maps by [Google](https://developers.google.com/maps/documentation/javascript/).

## License

Copyright (c) 2013 Jack Chatterton

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

The software is provided "as is", without warranty of any kind, express or implied, including but not limited to the warranties of merchantability, fitness for a particular purpose, and noninfringement. In no event shall the authors or copyright holders be liable for any claim, damages, or other liability, whether in an action of contract, tort, or otherwise, arising from, out of, or in connection with the software or the use or other dealings in the software.
