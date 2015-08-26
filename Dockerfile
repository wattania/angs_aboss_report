FROM docker.io/angstroms/angs_aboss_report:appserver
MAINTAINER Wattana Inthaphong <wattaint@gmail.com>

ADD appserver/vendor/gems /gems
RUN cd /gems/ \
&& git init . \
&& cd /

ADD appserver/Gemfile /tmp/Gemfile
ADD appserver/Gemfile.lock /tmp/Gemfile.lock

RUN cd /tmp \ 
&& bundle install
