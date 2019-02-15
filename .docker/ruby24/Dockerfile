FROM ruby:2.4

RUN apt-get update -qq && \
	apt-get install -y clamdscan wait-for-it vim less

# Client needs to know server conf :(
RUN echo "TCPSocket 3310" > /etc/clamav/clamd.conf && \
	echo "TCPAddr clamav" >> /etc/clamav/clamd.conf

WORKDIR /src
COPY . .
RUN gem install bundler -N && \
	bundle install

CMD ["bundle", "exec", "rake"]
