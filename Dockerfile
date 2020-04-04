FROM ruby:2.7.1-alpine3.11
RUN mkdir /app
WORKDIR /app
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock

RUN apk update && \
    apk add --no-cache bash tzdata libxml2-dev curl-dev make gcc libc-dev g++ && \
    bundle install
    # && \
    # rm -rf /usr/local/bundle/cache/* /usr/local/share/.cache/* /var/cache/* /tmp/* && \
    # apk del git libxml2-dev curl-dev make gcc libc-dev g++

COPY . /app

COPY docker-entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/docker-entrypoint.sh
ENTRYPOINT ["sh", "docker-entrypoint.sh"]
EXPOSE 3000


# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]
