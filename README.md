# README

Rales Engine is an api for sales data that returns record, relationship, and business intelligence endpoints. 

	![Diagram of the Rales Engine schema](https://github.com/ap2322/rales_engine/blob/master/rales_engine_resource_diagram.png?raw=true)

---
**Ruby Versions and Setup**

* Ruby version 2.4.1
* Rails version 5.2.3

* Configuration: Create a project folder for this repo. Move into it and clone this repo into that project folder. After cloning the repo, run `bundle install` in the terminal to install gems.

* Database creation:  
Run `bundle exec rake db:{create, migrate}` to set up the database. To import the csv data into the application, run `rake import:all` in the terminal.

* How to run the test suite  
From the terminal, run `rspec` to run the test files within rales_engine.  
To run against the spec harness provided by Turing School, clone the repo into the project folder (adjacent to the clone of rales_engine). Then, within in one terminal window, run the rales_engine on localhost with the command `rails s`. In another terminal window, navigate into the spec harness repo and run `rake`.

---
<h2>About Rales Engine</h2>

Rales Engine includes six main resources:
1. customers
2. merchants
3. items
4. invoices
5. invoice_items
6. transactions

Each resource can be queried through the following api endpoints:

**Record Endpoints:**  
- Index of all resources: `/api/v1/<resource>`, e.g. `/api/v1/merchants`
- Show a single resource: `/api/v1/<resource>/:id`, e.g. `/api/v1/merchants/1`
- Find a resource with a query: `/api/v1/merchants/find?<query_parameter>`, e.g. `/api/v1/merchants/find?name=Schroeder-Jerde`
- Find all of a resource with a query: `/api/v1/merchants/find_all?<query_parameter>`, e.g. `/api/v1/merchants/find_all?name=Cummings-Thiel`
- Find a random resource: `api/v1/<resource>/random`, e.g. `api/v1/merchants/random`

**Relationship Endpoints**

Merchants  
- GET `/api/v1/merchants/:id/items` returns a collection of items associated with that merchant  
- GET `/api/v1/merchants/:id/invoices` returns a collection of invoices associated with that merchant from their known orders

Invoices  
- GET `/api/v1/invoices/:id/transactions` returns a collection of associated transactions
- GET `/api/v1/invoices/:id/invoice_items` returns a collection of associated invoice items
- GET `/api/v1/invoices/:id/items` returns a collection of associated items
- GET `/api/v1/invoices/:id/customer` returns the associated customer
- GET `/api/v1/invoices/:id/merchant` returns the associated merchant

Invoice Items  
- GET `/api/v1/invoice_items/:id/invoice` returns the associated invoice
- GET `/api/v1/invoice_items/:id/item` returns the associated item

Items  
- GET `/api/v1/items/:id/invoice_items` returns a collection of associated invoice items
- GET `/api/v1/items/:id/merchant returns` the associated merchant

Transactions  
- GET `/api/v1/transactions/:id/invoice` returns the associated invoice

Customers  
- GET `/api/v1/customers/:id/invoices` returns a collection of associated invoices
- GET `/api/v1/customers/:id/transactions` returns a collection of associated transactions

**Business Intelligence Endpoints**

Merchants  
- GET `/api/v1/merchants/most_revenue?quantity=x` returns the top x merchants ranked by total revenue
- GET `/api/v1/merchants/revenue?date=x returns` the total revenue for date x across all merchants
- GET `/api/v1/merchants/:id/favorite_customer` returns the customer who has conducted the most total number of successful transactions.  

Items  
- GET `/api/v1/items/most_revenue?quantity=x` returns the top x items ranked by total revenue generated
- GET `/api/v1/items/:id/best_day` returns the date with the most sales for the given item using the invoice date. If there are multiple days with equal number of sales, return the most recent day.

Customers  
- GET `/api/v1/customers/:id/favorite_merchant` returns a merchant where the customer has conducted the most successful transactions
