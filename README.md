# Little Esty Shop

"Little Esty Shop" is a fictitious e-commerce management platform for admins and merchants to oversee inventory, and track and fulfill customer invoices. "Little Esty Shop" is deployed via Heroku at [Little Esty Shop](https://stark-castle-51480.herokuapp.com/).

### Features: Merchants
#### Tools created to make it easy for your merchants to manage inventory and customers
**_Merchants can track items and invoices, and easily see favorite customers._**\
![Merchant Show Page](/app/assets/images/merchant_show.png)

**_Merchants can track and change the status of their items with the click of a button._**\
![Merchant Items Page](/app/assets/images/merchant_items_show.png)

**_Merchants can see individual items and update their attributes._**\
![Item Show Page](/app/assets/images/item_show.png)

### Features: Admins
#### Tools created to support site administrators simplify the tasks associated with managing complex commerce.
**_Admins can track merchants, invoices, and customers from a single central dashboard._**\
![Admin Dashboard](/app/assets/images/admin_dashboard.png)

**_With a simple click of a button, admins can enable or disable their merchants._**\
![Admin Merchants Show](/app/assets/images/admin_merchants_show.png)

**_Admins can track individual invoices and statistics with ease._**\
![Admin Invoices Show](/app/assets/images/admin_invoice_show.png)

## Shipping Changes
If you would like to make changes to this project, please contact the owner of this repository via GitHub.

## Setup
This project was developed via Ruby 2.7.2, on Rails 5.2.5.

**_Database Schema_**\
![Database Schema](/app/assets/images/database_schema.png)

To access the dev environment for this app please follow these steps:
* Fork this repository
* Clone your fork
* From the command line, install gems and set up your DB:
    * `bundle`
    * `rails db:create`

You can access the test suite (includes use of Capybara, FactoryBot, Faker, RSpec, and Pry) via `bundle exec rspec`. You can run the development server
with `rails s` to see the app in action.
* Run `rake csv_load:all` to populate data from the Command Line to the rails server

## Contributors
Parts of this app were developed via Ruby on Rails by Didi Dodson at Turing School of Software and Design in 2021. Other parts of this app were developed by Didi and other students at Turing.
