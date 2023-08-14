FROM ruby:3.1.3

RUN apt-get update -qq && \
    apt-get install -y build-essential && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /usr/share/doc /usr/share/man

RUN mkdir /app
WORKDIR /app
ADD . /app
RUN gem install bundler
RUN bundle install

RUN gem install foreman

# Start the main process.
CMD ["foreman", "start", "-f", "Procfile"]

EXPOSE 3000