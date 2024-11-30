FROM ruby:3.3
RUN mkdir /temp
WORKDIR /temp
ADD . /temp
RUN gem install bundler
RUN bundler install
RUN mkdir /app
WORKDIR /app
EXPOSE $PORT
