FROM ruby:2.2

ARG APP_HOME
ARG POST_SERVICE_HOST
ARG POST_SERVICE_PORT
ARG COMMENT_SERVICE_HOST
ARG COMMENT_SERVICE_PORT

ENV APP_HOME=${APP_HOME:-'/app'} \
    POST_SERVICE_HOST=${POST_SERVICE_HOST:-'post'} \
    POST_SERVICE_PORT=${POST_SERVICE_PORT:-'5000'} \
    COMMENT_SERVICE_HOST=${COMMENT_SERVICE_HOST:-'comment'} \
    COMMENT_SERVICE_PORT=${COMMENT_SERVICE_PORT:-'9292'}

RUN apt-get update \
    && apt-get install -y --no-install-recommends build-essential=11.7 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

WORKDIR $APP_HOME

COPY Gemfile* $APP_HOME/

RUN bundle install

COPY . $APP_HOME/

CMD ["puma"]
