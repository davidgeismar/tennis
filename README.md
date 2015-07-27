<<<<<<< HEAD
# wetennis
=======
# WeTennis
>>>>>>> 99842a8f6f68c1c0e7ac7935beb5887a5983bb20

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

    $ git push heroku master

## Credits

The first commit of this app has been generated thanks to [lewagon/wagon_rails](https://github.com/lewagon/wagon_rails)'s rails app generator.
