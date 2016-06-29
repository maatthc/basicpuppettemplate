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

COPY sinatra $MyDir

WORKDIR $MyDir

EXPOSE 80 80

CMD rackup --host 0.0.0.0 -p 80
