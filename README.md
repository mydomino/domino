Domino Website
==============
 This documentation is meant to cover all aspects of the Domino code base.
 
Stack Choices
==============
 We run on Ruby on Rails with Unicorn as the server hosted on Heroku. We use a Postgres database (per heroku), HAML templating and sass (using basscss as a css framework). 
 
Static Pages
============
 All static pages are handled by the pages controller. Currently this includes:
 * the home page
 * the signup page
 * the about page
 * the terms page
 * the privacy page
 
 Note: The solar page is currently commented out in the routes file because it wasn't updated to use basscss and we had practically zero traffic to it.

Concierge Features
==================
  Concierges each have their own login (managed using devise). New logins can be created from the rails console, which is reached by running
  
    heroku run rails console -a domino-production
    
and then typing

    Concierge.create(username: EMAIL, password: PASSWORD)
    
where EMAIL is the new login's email address and PASSWORD is their temporary password (they can change it by going into their profile).

Blog Routing
============

 Our blog is run on Wordpress and is reached via a reverse proxy running on the Rails app. The configuration is in /config.ru. Also note that the line:
 
      get '/blog' => redirect("/blog/")

in routes.rb is necessary for this to work.