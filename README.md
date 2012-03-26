A Spine.js / jQuery Mobile / Sinatra / Mustache Example 
=======================================================

A multi-restaurant mobile ordering application

Get started:

    $ git clone git://github.com/integrallis/jqm-spine-sinatra-demo.git
    $ cd jqm-spine-sinatra-demo
    $ gem install bundler
    $ bundle
    $ bundle exec ruby seeds.rb

Run it

    $ bundle exec shotgun -O config.ru

Or

    $ foreman start

Deploying to Heroku's Cedar Stack

    $ heroku create [appname] --stack cedar
    $ git push heroku master
    $ heroku run rake db:migrate
    $ heroku run console
      $ irb(main):002:0> require './seeds'
    $ heroku open

See demo at
    $ http://integrallis-rubynation-demo.herokuapp.com/