FROM ruby:2.5

RUN apt-get update -qq && \
	apt-get install -y clamdscan wait-for-it vim less

WORKDIR /src
COPY . .
RUN gem install bundler -N && \
	bundle install

COPY .docker/clamd.conf /etc/clamav/
COPY .docker/docker-entrypoint.sh /usr/bin/
RUN chmod u+x /usr/bin/docker-entrypoint.sh
ENTRYPOINT ["docker-entrypoint.sh"]
