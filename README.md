# Banking

[![CircleCI](https://circleci.com/gh/andrelip/banking.svg?style=svg)](https://circleci.com/gh/andrelip/banking) [![Coverage Status](https://coveralls.io/repos/github/andrelip/banking/badge.svg?branch=master)](https://coveralls.io/github/andrelip/banking?branch=master)

Open source bank made in Phoenix

You can start by using our [`Postman Collection`](https://www.getpostman.com/collections/c1bada16ca6fa2b9ee3a) or by exploring with [`Graphiql`](https://andrestephano.com/graphiql).

Endpoint: `https://andrestephano.com/graphql`

[`Example of Queries and Mutations`](https://github.com/andrelip/banking/tree/master/test/banking_web/graphql/gql)

[`Documentation`](https://andrelip.github.io/banking/doc/api-reference.html)

## Features

- Money transfer between users
- Deposit and withdrawal
- Registration gift
- GraphQL interface

# Getting started

## Development

To get started with docker

- Install dependencies with `mix deps.get`
- Create and migrate your database with `mix ecto.setup`
- Start Phoenix endpoint with `mix phx.server`

Now you can send your requests to [`localhost:4000/graphql`](http://localhost:4000) or [`interact with Graphiql`](<[`localhost:4000/graphql`](http://localhost:4000)>) from your browser to explore the API.

## Production

The preferred way to run in production is using Elixir Release. You can build a release by yourself by running `MIX_ENV=prod mix release` or use our [`public docker image`](https://hub.docker.com/r/andrelip/banking)

You will need to set the following environment variables:

- PG_USERNAME
- PG_PASSWORD
- PG_HOSTNAME
- PG_DATABASE
- SECRET_KEY_BASE
- GUARDIAN_SECRET_KEY
- ADMIN_KEY_HASH
- BANKING_DOMAIN
- BANKING_SUPPORT_EMAIL
- SENDGRID_API_KEY
- BANKING_SSL_KEY_PATH
- BANKING_INTERMEDIATE_CERTFILE_PATH
- BANKING_SSL_CERT_PATH

You can generate the secrets using `mix phx.gen.secret`.

You will need to mount a volume or create another layer to place your SSL keys if you are using our Docker image.

## Conveniences and TODO's

There are some conveniences. Please check them before using in production:

    * Double-entry accounting system in a single database row. You may need to change that into an item table to perform split operations and fees.
    * There is no human approval of new accounts.
    * There is no document validation.
    * No react event handle. Implementing this would be useful to decouple modules, for example the email notification and bonuses from the source that generated event generator.
