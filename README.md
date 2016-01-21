Domino Website
==============
 This documentation is meant to cover all aspects of the Domino code base.

Stack Choices
==============
 We run on Ruby on Rails with Unicorn as the server hosted on Heroku. We use a Postgres database (per heroku), HAML templating and sass (using Basscss(www.basscss.com) as a css framework).

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

The blog routes have been raising H13 errors on Heroku sporadically, and I can't tell exactly why. Restarting the dynos fixes it, but I haven't found the root cause yet.

User Sign Up Flow
=================

Users who are directed to the ``get_started_path`` will arrive on /get_started/1, and a new object ``@get_started`` is created for them. It is stored in their session so that if they navigate away from the flow their answers will not be lost. Once they've completed that flow (or signed up via the contest page or some other sign up form) they are created as a lead in the database and several important DelayedJobs are scheduled.

Using the geocoder gem they are geocoded by their IP address, and then they are reverse geocoded to get back a city, zip code, and state. Then a thank you email is sent, and then they are exported to Zoho. All of these are wrapped in individual DelayedJobs and are called in :after_create hooks on the Lead model. If they checked the "Subscribe me to the newsletter" checkbox they are also uploaded to MailChimp, but that is not done in the background.


Dashboards
==========

Dashboards are a major object in this application, they knit together leads, concierges, and recommendations. They are also slugged by the person's name, so Tom Waits would access his energy dashboard by going to mydomino.com/tom-waits

Right now, we're just using this slugging structure but **there is no account system for leads, all of their dashboards are technically public**. They aren't crawlable because the index is password protected and they are only accessible via slugs, not ID's but it's still very important that we don't store personal information on these pages.

Duplicate Slugs
---------------
 Duplicate slugs get a number added to the end of them to maintain uniqueness, to the second Tom Waits will be /tom-waits-1 and the third will be /tom-waits-2 and so on.

Recommendations
===============
 Dashboards connect leads with concierges, and they connect them for the purpose of making recommendations. Both products and tasks are recommendable via a polymorphic relationship.

Products
========
 Products have some interesting behaviours. First of all, they are primarily derived from the Amazon Product Advertising API at the time of creation. Concierges just put in a product URL and we do a few things:
  * Parse out the products ID for use with the API
  * Query the amazon API using that ID
  * Parse those results and store them in the appropriate database columns

Price Changes
-------------
Amazon prices change kind of a lot, so there is a button on the products index page to "Update Prices" which creates a UpdateAllAmazonPricesJob (this is also called once a day by the Heroku scheduler).
