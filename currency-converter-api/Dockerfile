# syntax=docker/dockerfile:1
# check=error=true

# This Dockerfile is designed for production, not development. Use with Kamal or build'n'run by hand:
# docker build -t currency_converter_api .
# docker run -d -p 80:80 -e RAILS_MASTER_KEY=<value from config/master.key> --name currency_converter_api currency_converter_api

# Make sure RUBY_VERSION matches the Ruby version in .ruby-version
ARG RUBY_VERSION=3.4.1
FROM ruby:$RUBY_VERSION-slim AS base

# Rails app lives here
WORKDIR /rails

# Install base packages
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
      curl libjemalloc2 libvips sqlite3 && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives

# Set production environment by default
ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development"

# ────────────────────────────────────────────────────────────────────────────────
# BUILD STAGE: instala gems com dependências de compilação
FROM base AS build

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
      build-essential \
      git \
      libyaml-dev \
      pkg-config \
      libpq-dev && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives

# Copia Gemfile e instala gems
COPY Gemfile Gemfile.lock ./
RUN bundle config set --local frozen false
RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    bundle exec bootsnap precompile --gemfile

# Copia o app completo e precompila bootsnap
COPY . .
RUN bundle exec bootsnap precompile app/ lib/

# ────────────────────────────────────────────────────────────────────────────────
# FINAL STAGE: imagem enxuta apenas com o necessário para rodar o app
FROM base

# Instala dependência necessária para runtime da gem pg
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
      libpq5 && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives

# Copia a aplicação e gems do build
COPY --from=build ${BUNDLE_PATH} ${BUNDLE_PATH}
COPY --from=build /rails /rails

# Cria usuário não-root e garante permissões
RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash && \
    mkdir -p tmp log storage db && \
    chown -R rails:rails db log storage tmp
USER 1000:1000

# Entrypoint e execução do servidor
ENTRYPOINT ["/rails/bin/docker-entrypoint"]

EXPOSE 3000
CMD ["./bin/thrust", "./bin/rails", "server", "-b", "0.0.0.0"]
