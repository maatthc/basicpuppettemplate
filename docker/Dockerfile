FROM alpine

MAINTAINER Alexandre Andrade <aleandrade@gmail.com>

ENV MyDir /var/sinatra

RUN mkdir -p $MyDir
RUN apk add --no-cache ruby-dev
RUN apk add --no-cache ruby
RUN apk add --no-cache ruby-rdoc
RUN apk add --no-cache ruby-irb
RUN gem install sinatra
RUN gem install rakeup

COPY simple-sinatra-app/ $MyDir

WORKDIR $MyDir

EXPOSE 80

CMD rackup --port 80
