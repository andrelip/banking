FROM elixir:1.9.4-alpine as build

WORKDIR /banking

# Set build ENV
ENV MIX_ENV=prod

RUN apk add --update alpine-sdk
RUN apk add yarn
# Install mix dependencies
COPY mix.exs mix.lock ./
COPY config config
RUN mix local.hex --force
RUN mix local.rebar --force
RUN mix deps.get --only prod
RUN mix deps.compile

# Build assets
COPY assets assets
RUN cd assets && yarn install --frozen-lockfile && yarn deploy
RUN mix phx.digest

# Build project
COPY priv priv
COPY lib lib
RUN mix compile

# Build release
# COPY rel rel
RUN mix release

# Prepare release image
FROM alpine:3.10

RUN apk add --update --no-cache bash openssl curl

WORKDIR /banking

COPY --from=build /banking/_build/prod/rel/banking ./

RUN chown -R nobody: /banking
USER nobody

ENV HOME=/banking

CMD ["bin/banking", "start"]