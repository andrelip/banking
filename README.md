# Banking [![CircleCI](https://circleci.com/gh/andrelip/banking.svg?style=svg)](https://circleci.com/gh/andrelip/banking) [![Coverage Status](https://coveralls.io/repos/github/andrelip/banking/badge.svg?branch=master)](https://coveralls.io/github/andrelip/banking?branch=master)

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Conveniences

For the propose of this project, there are some conveniences. Please check them before using in production:

    * Single account per user
    * Single document requirement per use
    * Accounts status are enabled just after creation
    * No document validation
    * No distinction between business and personal account
