FROM ruby:2.2

ARG APP_HOME
ARG COMMENT_DATABASE_HOST
ARG COMMENT_DATABASE

ENV APP_HOME=${APP_HOME:-'/app'} \
    COMMENT_DATABASE_HOST=${COMMENT_DATABASE_HOST:-'comment_db'} \
    COMMENT_DATABASE=${COMMENT_DATABASE:-'comments'}

RUN apt-get update \
    && apt-get install -y --no-install-recommends build-essential=11.7 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

WORKDIR $APP_HOME

COPY Gemfile* $APP_HOME/

RUN bundle install

COPY . $APP_HOME/

CMD ["puma"]
