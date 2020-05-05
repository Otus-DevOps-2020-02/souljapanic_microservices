FROM python:3.6.0-alpine

ARG POST_DATABASE_HOST
ARG POST_DATABASE

ENV POST_DATABASE_HOST=${POST_DATABASE_HOST:-'post_db'} \
    POST_DATABASE=${POST_DATABASE:-'posts'}

WORKDIR /app

COPY . /app/

RUN apk add --no-cache --virtual .build-dependencies build-base=0.4-r1 \
    && pip install -r /app/requirements.txt \
    && apk del .build-dependencies

CMD [ "python3", "post_app.py" ]
