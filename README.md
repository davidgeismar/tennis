# WeTennis

## Configuration

The app configuration lies in `config/application.yml` and is **not**
versionned by git (for security reasons). If you've just cloned this
repo, ask a colleague for his `application.yml` file over a secure channel.

## Getting started

    $ git clone
    $ bundle install

    $ rake db:create
    $ rake db:migrate && rake db:seed


## Deploying

### In production

    $ figaro heroku:set
    $ git push heroku master
    $ heroku run rake db:migrate

### In staging

    $ figaro heroku:set -a we-tennis-staging -e staging
    $ git push staging master
    $ heroku run rake db:migrate --app we-tennis-staging

## Credits

The first commit of this app has been generated thanks to [lewagon/wagon_rails](https://github.com/lewagon/wagon_rails)'s rails app generator.
