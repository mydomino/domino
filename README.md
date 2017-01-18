MyDomino Website
==============
 This documentation is meant to cover all aspects of the MyDomino code base.

Stack Choices
==============
 We run on Ruby on Rails with Puma as the server hosted on Heroku. We use a Postgres database (per heroku), HAML templating and sass (using [Basscss](http://www.basscss.com) as a css framework).

Static Pages
============
 All static pages are handled by the pages controller. Currently this includes:
 * the home page
 * the about page
 * the terms page
 * the privacy page

Concierge Features
==================
  Concierges each have their own login (managed using devise). New logins can be created from the rails console, which is reached by running

    heroku run rails console -a domino-production

and then typing

    User.create(email: EMAIL, password: PASSWORD, password_confirmation: PASSWORD, role: 'concierge')


Dashboards
==========

Dashboards are a major object in this application, they knit together leads, concierges, and recommendations.


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

Testing
=======
Selenium webdriver doesn't work with Firefox 47. Use Firefox 46 instead.

